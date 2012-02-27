#include "clisp.h"

extern object module__cvode__object_tab[];

void (ms_model) (double g3201);
void (ms_model) (double g3201)
{
  begin_callback();
  pushSTACK(convert_from_foreign(module__cvode__object_tab[0],&g3201));
  funcall(module__cvode__object_tab[1],1);
  end_callback();
}

subr_t module__cvode__subr_tab[1];
uintC module__cvode__subr_tab_size = 0;
subr_initdata_t module__cvode__subr_tab_initdata[1];

object module__cvode__object_tab[2];
object_initdata_t module__cvode__object_tab_initdata[2] = {
  { "|COMMON-LISP|::|DOUBLE-FLOAT|" },
  { "|COMMON-LISP-USER|::|MS_MODEL|" },
};
uintC module__cvode__object_tab_size = 2;


void module__cvode__init_function_1 (module_t* module);

void module__cvode__init_function_2 (module_t* module);

void module__cvode__fini_function (module_t* module);


void module__cvode__init_function_1 (module_t* module)
{
}

void module__cvode__init_function_2 (module_t* module)
{
  register_foreign_variable((void*)&sys_var,"sys_var",0,sizeof(sys_var));
  register_foreign_function((void*)&init_dims,"init_dims",1024);
  register_foreign_function((void*)&mem_alloc,"mem_alloc",1024);
  register_foreign_function((void*)&mem_free,"mem_free",1024);
  register_foreign_function((void*)&fill_in,"fill_in",1024);
  register_foreign_function((void*)&sim_model_cvode,"sim_model_cvode",1024);
}

void module__cvode__fini_function (module_t* module)
{
}
