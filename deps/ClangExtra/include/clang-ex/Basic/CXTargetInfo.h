#ifndef LLVM_CLANG_C_EXTRA_CXTARGETINFO_H
#define LLVM_CLANG_C_EXTRA_CXTARGETINFO_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXTargetInfo_ clang_TargetInfo_CreateTargetInfo(CXDiagnosticsEngine DE,
                                                CXTargetOptions Opts);

LLVM_CLANG_C_EXTERN_C_END

#endif