#ifndef _ICXXABI_H
#define _ICXXABI_H

#define ATEXIT_MAX_FUNCS 128

#ifdef __cplusplus
extern "C" {
#endif

struct atexit_func_entry_t {
  void (*destructor_func)(void *);
  void *obj_ptr;
  void *dso_handle;
};

atexit_func_entry_t __atexit_funcs[ATEXIT_MAX_FUNCS];

unsigned __atexit_func_count = 0;

void *__dso_handle = 0;

int __cxa_atexit(void (*f)(void *), void *objptr, void *dso) {
  if (__atexit_func_count >= ATEXIT_MAX_FUNCS) {
    return -1;
  };
  __atexit_funcs[__atexit_func_count].destructor_func = f;
  __atexit_funcs[__atexit_func_count].obj_ptr = objptr;
  __atexit_funcs[__atexit_func_count].dso_handle = dso;
  __atexit_func_count++;
  return 0;
};

void __cxa_finalize(void *f) {
  unsigned i = __atexit_func_count;
  if (!f) {
    while (i--) {
      if (__atexit_funcs[i].destructor_func) {
        (*__atexit_funcs[i].destructor_func)(__atexit_funcs[i].obj_ptr);
      };
    };
    return;
  };

  while (i--) {
    if (__atexit_funcs[i].destructor_func == f) {
      (*__atexit_funcs[i].destructor_func)(__atexit_funcs[i].obj_ptr);
      __atexit_funcs[i].destructor_func = 0;
    };
  };
};

#ifdef __cplusplus
};
#endif

#endif