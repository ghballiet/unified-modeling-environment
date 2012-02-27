/** Modified from model-t.c as written by Ljupco Todorovski for the original
 ** implementation of HIPM.  The parameter estimation routines have been
 ** stripped from here since they should be called separately from Lisp so that
 ** we can have the option of replacing them as desired.
 **
 ** Information about the parameters was also removed, although it may be
 ** added back when sensitivity analysis is implemented.
 **/

/** 
 ** I'm trying to keep the Lisp code from having to interact with any
 ** of the complicated CVODE types.  This decision is made primarily
 ** due to limitations of the CLISP FFI, but experiments have shown
 ** that as of version 2.38, it's fairly slow to access C-friendly
 ** data structures through the FFI.
 **/

/** ASSUMPTIONS:
 ** 
 ** each system variable appears on the LHS of an associated.
 **/
 
#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <math.h>
#include <float.h>

#include "sundials/cvodes/cvodes.h"
#include "sundials/cvodes/cvodes_spgmr.h"
#include "sundials/cvodes/cvodes_spils.h"
#include "sundials/nvector/nvector_serial.h"

#define ZERO  RCONST(0.0)
#define CVI_SUCCESS 0
#define CVI_FAILURE -1
#define SA_METHOD CV_SIMULTANEOUS

typedef void (*model_function) (double t);

/* function prototypes */
void print_cvode_error(int);
void init_dims(int, int, model_function);
int mem_alloc();
void mem_free();
int fill_in(double, double*, int);
int cvode_model(realtype, N_Vector, N_Vector, void*);
void init_cvode(double*, double);
int sim_model_cvode(double);

model_function MS_model; /* defined in Lisp */

/* CVODES state information */
struct {
  int sa_alloc;              /* nonzero when memory is allocated for sensitivity analysis */
  int sa_on;                 /* nonzero when sensitivity analysis is toggled on */
                             /* we can add a function to toggle sensitivity analysis if needed */

  void *cvode_mem;
  realtype t0;               /* starting point of the simulation */

  N_Vector y0;               /* the initial values of the system variables */
  N_Vector abstol;
  realtype reltol;

  N_Vector *ps0;             /* the initial values of the sensitivities */
  N_Vector *abstolS;
  realtype reltolS;
  int *plist;
  realtype *pbar;
} sim;


/* system variables */
typedef struct  {
  int n;                     /* the number of system variables */
  double *vals;              /* current values */
  double *dot_vals;          /* time derivatives of the current values */
} system_variables;

/* global system variable storage */
system_variables sys_var;

/* parameters */
struct {
  int n;                     /* number of parameters in the ODEs */ 
  double *vals;              /* [0..(param.n-1)]: the values of the parameters
				(used for sensitivity analysis). */
} param;

/* access functions added due to the sluggish CLISP FFI for foreign variables */
/* since these functions were created to speed execution, they don't have any 
 * bounds checks.  the caller assumes responsibility */
int get_sysvar_n(){return sys_var.n;}
double get_sysvar_val(int i) {return sys_var.vals[i];}
double* get_sysvar_vals(){return sys_var.vals;}
double get_sysvar_dotval(int i) {return sys_var.dot_vals[i];}
void set_sysvar_val(int i, double x) {sys_var.vals[i] = x;}
void set_sysvar_dotval(int i, double x) {sys_var.dot_vals[i] = x;}

int get_param_n() {return param.n;}
double get_param_val(int i) {return param.vals[i];}
void set_param_val(int i, double x) {param.vals[i] = x;}

/* returns the sensitivity of variable vi to parameter pi */
double get_sensitivity(int pi, int vi) {return NV_DATA_S(sim.ps0[pi])[vi];}

/* speed hacks */
double c_exp(double x) {return exp(x);}
double c_log(double x) {return log(x);}
double c_log10(double x) {return log10(x);}

/* initialization and allocation procedures */

/* init_dims
 * 
 * initializes the model-specific structure dimensions
 * this function only needs to be called once for a specific model
 */
void init_dims(int nsys_var, int nparams, model_function mf) {
  MS_model = mf;
  sys_var.n = nsys_var;
  param.n = nparams;
  sim.sa_alloc = 0;
  sim.sa_on = 0;
}

/* mem_alloc
 *
 * allocates memory for some of the global structures and variables
 * it only needs to be called once for a specific model structure and should
 * be called after init_dims()
 *
 * returns CVI_SUCCESS if all requested memory was allocated
 * returns CVI_FAILURE if the memory could not be allocated
 */
int mem_alloc(void) {
  sim.cvode_mem = NULL;
  sim.y0 = NULL;
  sim.abstol = NULL;
  sim.ps0 = NULL;
  sim.abstolS = NULL;
  sim.plist = NULL;
  sim.pbar = NULL;

  param.vals = NULL;
  sys_var.vals = NULL;
  sys_var.dot_vals = NULL;

  if (sys_var.n > 0) {
    if ((sys_var.vals = (double *) malloc(sys_var.n * sizeof(double))) == NULL)
      goto error_exit;
    if ((sys_var.dot_vals = (double *) malloc(sys_var.n * sizeof(double))) == NULL)
      goto error_exit;
  }

  if (param.n > 0) {
    if ((param.vals = (double *) malloc(param.n * sizeof(double))) == NULL)
      goto error_exit;
  }
  
  return CVI_SUCCESS;

 error_exit:
  if (sys_var.vals != NULL) free(sys_var.vals);
  if (sys_var.dot_vals != NULL) free(sys_var.dot_vals);
  if (param.vals != NULL) free(param.vals);
  return CVI_FAILURE;
}

/* mem_free
 * 
 * frees the allocated memory associated with the model
 * should be called after the model is no longer needed and once called, 
 * model simulation must begin from init_dims()
 *
 */
void mem_free(void) {
  N_VDestroy_Serial(sim.abstol);
  N_VDestroy_Serial(sim.y0);
  
  if (sim.sa_alloc) {
    CVodeSensFree(sim.cvode_mem);
  }

  CVodeFree(sim.cvode_mem);
  
  if (sim.ps0 != NULL) {
    N_VDestroyVectorArray_Serial(sim.ps0, param.n);
    sim.ps0 = NULL;
  }

  if (sim.abstolS != NULL) {
    N_VDestroyVectorArray_Serial(sim.abstolS, param.n);
    sim.abstolS = NULL;
  }

  if (sys_var.n > 0) {
    free(sys_var.vals);
    free(sys_var.dot_vals);
  }
  
  if (param.n > 0) {
    free(param.vals);
  }

  if (sim.plist != NULL) {
    free(sim.plist);
    sim.plist = NULL;
  }

  if (sim.pbar != NULL) {
    free(sim.pbar);
    sim.pbar = NULL;
  }
 
  /* put the system back into a nascent state */
  sys_var.n = 0;
  param.n = 0;
  MS_model = NULL;
  sim.sa_alloc = 0;
  sim.sa_on = 0;
}

/* fill_in
 *
 * prepare CVODE for simulation this function 
 * 
 * must be called after mem_alloc() and before model simulation
 * begins.  some CVODE(S) specific data structures are created here
 * and are destroyed in mem_free()
 * 
 * indicate the start time for the simulation
 * if sa is nonzero, then sensitivity analysis is performed
 *
 * returns CVI_SUCCESS or CVI_FAILURE
 */
int fill_in(double start_time, double* init_vals, int sa) {

  int j, sa_flag = -1;

  /* set to 0 to let cvode write to standard error */
  int suppress_cvode = 1;

  FILE *errfp;
  extern int cvode_model(realtype t, N_Vector cvode_y, 
			 N_Vector cvode_dy_dt, void *data);

  /* cvode initialization */
  if ((sim.cvode_mem = CVodeCreate(CV_BDF, CV_NEWTON)) == NULL) {
    printf("Library error: CVodeCreate failed.\n");
    goto error_exit;
  }

  /* disable cvode error output */
  if (suppress_cvode) {
    errfp = NULL; 
    /* fopen("/dev/null", "w"); */
    if (CVodeSetErrFile(sim.cvode_mem, errfp) != CV_SUCCESS) {
      printf("Library error: CVodeSetErrFile failed.\n");
      goto error_exit;
      /* this state can only occur if sim.cvode_mem is NULL, so we should never get here */
    }
  }

  /* cvode malloc */
  sim.reltol = 1.0e-4;
  sim.abstol = N_VNew_Serial(sys_var.n);
  for (j = 0; j < sys_var.n; ++j) NV_Ith_S(sim.abstol, j) = 1e-8;

  sim.t0 = start_time;

  sim.y0 = N_VNew_Serial(sys_var.n);
  /* store the initial values for communication with CVODE */
  for (j = 0; j < sys_var.n; j++) NV_Ith_S(sim.y0, j) = init_vals[j];

  if (CVodeMalloc(sim.cvode_mem, cvode_model, sim.t0, sim.y0, 
		  CV_SV, sim.reltol, sim.abstol) != CV_SUCCESS) {
    printf("Library error: CVodeMalloc failed.\n");
    goto error_exit;
  }

  /* cvode linear solver */
  if (CVSpgmr(sim.cvode_mem, PREC_NONE, 0) != CVSPILS_SUCCESS) {
    printf("Library error: CVSpgmr failed.\n");
    goto error_exit;
  }

  /* additional code for sensitivity analysis */
  if (sa) {

    /* allocate and initialize the parameters that guide sensitivity analysis */
    /* the list of parameters to analyze */
    sim.plist = (int *) malloc(param.n * sizeof(int));
    for (j = 0; j < param.n; j++) sim.plist[j] = j;
    
    /* the scale for analysis */
    sim.pbar = (realtype *) malloc(param.n * sizeof(realtype));
    for (j =0; j < param.n; j++) {
      /* hack to test for oddities in process sensitivity */
	/*
      if (param.vals[sim.plist[j]] < 1.00001 && param.vals[sim.plist[j]] > 0.99999) {
	sim.pbar[j] = 0.01;
	printf("crazy parameter\n");
      }
      else*/ 
      if (param.vals[sim.plist[j]] != 0)
	sim.pbar[j] = (realtype) fabs(param.vals[sim.plist[j]]);
      else
	sim.pbar[j] = 1.0;
    }

    /* allocate and initialize storage for the sensitivity information */
    sim.ps0 = N_VCloneVectorArray_Serial(param.n, sim.y0);
    /* not implemented: N_VNewVectorArray_Serial(param.n, sys_var.n); */
    for (j = 0; j < param.n; j++) N_VConst(ZERO, sim.ps0[j]);

    /* tell CVODES to calculate the sensitivities */
    if ((sa_flag = CVodeSensMalloc(sim.cvode_mem, param.n, SA_METHOD, sim.ps0)) 
	!= CV_SUCCESS) {
      printf("Library error: CVodeSensMalloc failed.\n");
      goto sens_error;
    }

    /* tell CVODES where it can find the parameters */
    if (CVodeSetSensParams(sim.cvode_mem, param.vals, sim.pbar, /*sim.plist*/NULL) != CV_SUCCESS) {
      printf("Library error: CVodeSetSensParams failed.\n");
      goto sens_error;
    }

    /* tell CVODES how much error we'll tolerate in the sensitivity scores */
    sim.reltolS = 1.0e-4;
    sim.abstolS = N_VCloneVectorArray_Serial(param.n, sim.abstol);
    for (j = 0; j < param.n; j++) N_VConst(1e-8, sim.abstolS[j]);

    if (CVodeSetSensTolerances(sim.cvode_mem, CV_SV, sim.reltolS, sim.abstolS) 
	!= CV_SUCCESS) {
      printf("Library error: CVodeSetSensTolerances failed.\n");
      goto sens_error;
    }

    /* turn error control on for the parameters */
    if (CVodeSetSensErrCon (sim.cvode_mem, 1) != CV_SUCCESS) {
      printf("Library error: CVodeSetSensErrCon failed.\n");
      goto sens_error;
    }

    sim.sa_alloc = 1;
    sim.sa_on = 1;
  }
  
  return CVI_SUCCESS;

 sens_error:
  if (sa_flag == CV_SUCCESS) CVodeSensFree(sim.cvode_mem);
  if (sim.ps0 != NULL) N_VDestroyVectorArray_Serial(sim.ps0, param.n);
  if (sim.abstolS != NULL) N_VDestroyVectorArray_Serial(sim.abstolS, param.n);
  if (sim.pbar != NULL) free(sim.pbar);
  if (sim.plist != NULL) free(sim.plist);
  sim.ps0 = NULL;
  sim.abstolS = NULL;
  sim.pbar = NULL;
  sim.plist = NULL;

 error_exit:
  if (sim.y0 != NULL) N_VDestroy_Serial(sim.y0);
  if (sim.abstol != NULL) N_VDestroy_Serial(sim.abstol);
  if (sim.cvode_mem != NULL) CVodeFree(sim.cvode_mem);
  sim.y0 = NULL;
  sim.abstol = NULL;
  sim.cvode_mem = NULL;
  return CVI_FAILURE;
}

/* cvode_model
 * 
 * this is the function called directly by CVODES to solve the system
 * of equations.  it primarily makes a call out to the MS_model
 * function, which must be implemented by the user of this interface.
 * 
 * this function is not model specific
 */
int cvode_model(realtype t, N_Vector y, N_Vector dy_dt, void *data) {

  int j;

  for (j = 0; j < sys_var.n; ++j) sys_var.vals[j] = NV_Ith_S(y, j);
  MS_model((double) t);
  for (j = 0; j < sys_var.n; ++j) NV_Ith_S(dy_dt, j) = sys_var.dot_vals[j];

  return(0);
}

/* init_cvode
 *
 * reinitializes CVODES and primes the solver with initial values.
 * the init_vals parameter should be the same length as sys_var.n.
 * start_time indicates the initial time for the simulation.  if sa is
 * nonzero, then sensitivity analysis is reinitialized as well.
 *
 */
void init_cvode(double* init_vals, double start_time) { 

  int i;

  /* store the initial values for communication with CVODE */
  for (i = 0; i < sys_var.n; i++) NV_Ith_S(sim.y0, i) = sys_var.vals[i] = init_vals[i];
    
  if (CVodeReInit(sim.cvode_mem, cvode_model, (realtype) start_time, sim.y0, 
		  CV_SV, sim.reltol, sim.abstol) != CV_SUCCESS) {
    printf("Library error: CVodeReInit failed.\n");
  }

  if (sim.sa_on && sim.sa_alloc) {
    for (i = 0; i < param.n; i++) N_VConst(ZERO, sim.ps0[i]);
    if (CVodeSensReInit(sim.cvode_mem, SA_METHOD, sim.ps0) != CV_SUCCESS) {
      printf("Library error: CVodeSensReInit failed.\n");
    }    

    /* remind CVODES where it can find the parameters */
    if (CVodeSetSensParams(sim.cvode_mem, param.vals, sim.pbar, /*sim.plist*/NULL) != CV_SUCCESS) {
      printf("Library error: CVodeSetSensParams failed.\n");
    }
    
    /* remind CVODES about the tolerances */
    if (CVodeSetSensTolerances(sim.cvode_mem, CV_SV, sim.reltolS, sim.abstolS) 
	!= CV_SUCCESS) {
      printf("Library error: CVodeSetSensTolerances failed.\n");
    }
    
    /* turn error control on for the parameters */
    if (CVodeSetSensErrCon (sim.cvode_mem, 1) != CV_SUCCESS) {
      printf("Library error: CVodeSetSensErrCon failed.\n");
    }
  }
}

/* one-step simulation of the model - using CVODE */
/* input: the next time to sample from */
/* output: the success status of CVODE */
int sim_model_cvode(double sample_time) {

  int j, cv_ret;
  realtype t;
  realtype *sdata;

  cv_ret = CVode(sim.cvode_mem, (realtype) sample_time, sim.y0, &t, CV_NORMAL);
  /* if necessary, print a formal error message */
  if (cv_ret != CV_SUCCESS && 
      cv_ret != CV_ROOT_RETURN && 
      cv_ret != CV_TSTOP_RETURN) {
    print_cvode_error(cv_ret);
    return cv_ret;
  }
  /* note: we incur a little redundancy here with cvode_model, but
   * cvode_model is called several times for each time point, so the
   * overhead is unlikely to be a problem.
   */
  /* write the simulation results to an accessible location */
  for (j = 0; j < sys_var.n; ++j) { 
    sys_var.vals[j] = NV_Ith_S(sim.y0, j);    
  } 

  /* store the info from the sensitivity analysis */
  if (sim.sa_on) {
    if (CVodeGetSens(sim.cvode_mem, sample_time, sim.ps0) != 0) {
      printf("Library error: CVodeGetSens failed.\n");
    }
  }

  /* note: save the sim.y0 values above and not the values stored in
   * sys_val.vals[] or you'll end up with some suspicious behavior.
   * Not sure why, yet.  However, there may be times when CVODE can
   * set the variable values without going back to the model, which
   * would mean that MS_model doesn't get the opportunity to alter the
   * sys_vals.vals or sys_vals.dot_vals arrays.
   */
  return cv_ret;
}


/* provide user-friendly output in the case of a CVODE error */
void print_cvode_error(int cv_ret) {
  printf("Simulation error: ");
  
  switch(cv_ret) {
  case CV_MEM_NULL:
    printf("CVode memory was null.\n");
    break;
  case CV_NO_MALLOC:
    printf("CVode memory was not allocated.\n");
    break;
  case CV_ILL_INPUT:
    printf("Illegal CVode input.\n");
    break;
  case CV_TOO_MUCH_WORK:
    printf("Too many internal CVode steps.\n");
    break;
  case CV_TOO_MUCH_ACC:
    printf("CVode accuracy demands too strict.\n");
    break;
  case CV_ERR_FAILURE:
    printf("Too many CVode errors.\n");
    break;
  case CV_CONV_FAILURE:
    printf("CVode cannot converge on a solution.\n");
    break;
  case CV_LSETUP_FAIL:
    printf("CVode's linear solver failed to initialize.\n");
    break;
  case CV_LSOLVE_FAIL:
    printf("CVode's linear solver failed.\n");
    break;
  }
}


/* notes on sensitivity analysis:
 *
 * the "plist" variable, which tells CVODES which parameters to
 * analyze only needs to be specified when you don't want information
 * on all of the parameters.  for now, i'm leaving this set to NULL,
 * but if we later want to be selective, this vector will have to be
 * created.
 *
 * the CVODES documentation says that the vector of parameters should
 * be attached to the user data f_data structure, but I think this is
 * only for convenience.  as long as we ensure that changes to the
 * parameters by CVODE will be used by the MS_model function, the code
 * should operate without problems.
 *
 * we won't specify the scaling factors for the parameters up front,
 * so the pbar vector won't exist in our implementation.
 */

