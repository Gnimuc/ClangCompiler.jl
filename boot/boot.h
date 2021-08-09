#ifndef CLANG_COMPILER_BOOT_H
#define CLANG_COMPILER_BOOT_H

#include "clang-ex/CXTypes.h"
#include "julia.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

JL_DLLEXPORT void print_julia_version(void);

#ifdef __cplusplus
}
#endif
#endif
