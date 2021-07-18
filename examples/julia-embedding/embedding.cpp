#include <iostream>
#include "julia.h"

int main(void) {
  jl_array_t *args = (jl_array_t*)jl_get_global(jl_core_module, jl_symbol("ARGS"));
  jl_value_t **strs = (jl_value_t**)jl_array_data(args);
  for (int i = 0; i < jl_array_len(args); i++) {
      std::string s(jl_string_ptr(strs[i]));
      std::cout << s << std::endl;
  }

  jl_value_t *ret = jl_eval_string("sqrt(2.0)");

  if (jl_typeis(ret, jl_float64_type)) {
      double ret_unboxed = jl_unbox_float64(ret);
      printf("sqrt(2.0) in C: %e \n", ret_unboxed);
  }
  else {
      printf("ERROR: unexpected return type from sqrt(::Float64)\n");
  }

  return 0;
}