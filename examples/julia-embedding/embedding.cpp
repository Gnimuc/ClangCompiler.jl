#include <iostream>
#include "julia.h"

int main(void) {
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