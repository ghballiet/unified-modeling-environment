#include "clisp.h"

extern object module__cvode_ffi_clisp__object_tab[];

void (ms_model) (double g66927);
void (ms_model) (double g66927)
{
  begin_callback();
  pushSTACK(convert_from_foreign(module__cvode_ffi_clisp__object_tab[0],&g66927));
  funcall(module__cvode_ffi_clisp__object_tab[1],1);
  end_callback();
}

subr_t module__cvode_ffi_clisp__subr_tab[1];
uintC module__cvode_ffi_clisp__subr_tab_size = 0;
subr_initdata_t module__cvode_ffi_clisp__subr_tab_initdata[1];

object module__cvode_ffi_clisp__object_tab[2];
object_initdata_t module__cvode_ffi_clisp__object_tab_initdata[2] = {
  { "|COMMON-LISP|::|DOUBLE-FLOAT|" },
  { "|COMMON-LISP-USER|::|MS_MODEL|" },
};
uintC module__cvode_ffi_clisp__object_tab_size = 2;


void module__cvode_ffi_clisp__init_function_1 (module_t* module);

void module__cvode_ffi_clisp__init_function_2 (module_t* module);

void module__cvode_ffi_clisp__fini_function (module_t* module);


void module__cvode_ffi_clisp__init_function_1 (module_t* module)
{
  register_foreign_inttype("tcflag_t",sizeof(tcflag_t),(tcflag_t)-1<=(tcflag_t)0);
  register_foreign_inttype("speed_t",sizeof(speed_t),(speed_t)-1<=(speed_t)0);
  register_foreign_inttype("cc_t",sizeof(cc_t),(cc_t)-1<=(cc_t)0);
  register_foreign_inttype("__off_t",sizeof(__off_t),(__off_t)-1<=(__off_t)0);
  register_foreign_inttype("__time_t",sizeof(__time_t),(__time_t)-1<=(__time_t)0);
  register_foreign_inttype("__key_t",sizeof(__key_t),(__key_t)-1<=(__key_t)0);
  register_foreign_inttype("__caddr_t",sizeof(__caddr_t),(__caddr_t)-1<=(__caddr_t)0);
  register_foreign_inttype("__daddr_t",sizeof(__daddr_t),(__daddr_t)-1<=(__daddr_t)0);
  register_foreign_inttype("__ssize_t",sizeof(__ssize_t),(__ssize_t)-1<=(__ssize_t)0);
  register_foreign_inttype("__uid_t",sizeof(__uid_t),(__uid_t)-1<=(__uid_t)0);
  register_foreign_inttype("__pid_t",sizeof(__pid_t),(__pid_t)-1<=(__pid_t)0);
  register_foreign_inttype("__loff_t",sizeof(__loff_t),(__loff_t)-1<=(__loff_t)0);
  register_foreign_inttype("off64_t",sizeof(off64_t),(off64_t)-1<=(off64_t)0);
  register_foreign_inttype("__nlink_t",sizeof(__nlink_t),(__nlink_t)-1<=(__nlink_t)0);
  register_foreign_inttype("__mode_t",sizeof(__mode_t),(__mode_t)-1<=(__mode_t)0);
  register_foreign_inttype("ino64_t",sizeof(ino64_t),(ino64_t)-1<=(ino64_t)0);
  register_foreign_inttype("__ino_t",sizeof(__ino_t),(__ino_t)-1<=(__ino_t)0);
  register_foreign_inttype("__gid_t",sizeof(__gid_t),(__gid_t)-1<=(__gid_t)0);
  register_foreign_inttype("__dev_t",sizeof(__dev_t),(__dev_t)-1<=(__dev_t)0);
  register_foreign_inttype("__ipc_pid_t",sizeof(__ipc_pid_t),(__ipc_pid_t)-1<=(__ipc_pid_t)0);
  register_foreign_inttype("__swblk_t",sizeof(__swblk_t),(__swblk_t)-1<=(__swblk_t)0);
  register_foreign_inttype("wchar_t",sizeof(wchar_t),(wchar_t)-1<=(wchar_t)0);
  register_foreign_inttype("ptrdiff_t",sizeof(ptrdiff_t),(ptrdiff_t)-1<=(ptrdiff_t)0);
}

void module__cvode_ffi_clisp__init_function_2 (module_t* module)
{
}

void module__cvode_ffi_clisp__fini_function (module_t* module)
{
}
