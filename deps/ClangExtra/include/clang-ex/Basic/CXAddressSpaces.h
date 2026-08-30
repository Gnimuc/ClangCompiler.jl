#ifndef LLVM_CLANG_C_EXTRA_CXADDRESSSPACES_H
#define LLVM_CLANG_C_EXTRA_CXADDRESSSPACES_H

#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

typedef enum CXLangAS : unsigned {
  CXLangAS_Default = 0,
  CXLangAS_opencl_global,
  CXLangAS_opencl_local,
  CXLangAS_opencl_constant,
  CXLangAS_opencl_private,
  CXLangAS_opencl_generic,
  CXLangAS_opencl_global_device,
  CXLangAS_opencl_global_host,
  CXLangAS_cuda_device,
  CXLangAS_cuda_constant,
  CXLangAS_cuda_shared,
  CXLangAS_sycl_global,
  CXLangAS_sycl_global_device,
  CXLangAS_sycl_global_host,
  CXLangAS_sycl_local,
  CXLangAS_sycl_private,
  CXLangAS_ptr32_sptr,
  CXLangAS_ptr32_uptr,
  CXLangAS_ptr64,
  CXLangAS_hlsl_groupshared,
  CXLangAS_hlsl_constant,
  CXLangAS_wasm_funcref,
  CXLangAS_FirstTargetAddressSpace
} CXLangAS;

LLVM_CLANG_C_EXTERN_C_END

#endif
