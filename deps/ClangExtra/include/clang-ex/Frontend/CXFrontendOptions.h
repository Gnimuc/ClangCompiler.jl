#ifndef LLVM_CLANG_C_EXTRA_CXFRONTENDOPTIONS_H
#define LLVM_CLANG_C_EXTRA_CXFRONTENDOPTIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

void clang_FrontendOptions_PrintStats(CXFrontendOptions FEO);

LLVM_CLANG_C_EXTERN_C_END

#endif