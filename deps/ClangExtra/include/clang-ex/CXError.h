#ifndef LIBCLANGEX_CXERROR_H
#define LIBCLANGEX_CXERROR_H

#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
  CXInit_NoError = 0,
  CXInit_CanNotCreate = 1
} CXInit_Error;

#ifdef __cplusplus
}
#endif
#endif