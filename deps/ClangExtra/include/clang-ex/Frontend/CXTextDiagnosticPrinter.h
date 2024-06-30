#ifndef LLVM_CLANG_C_EXTRA_CXTEXTDIAGNOSTICPRINTER_H
#define LLVM_CLANG_C_EXTRA_CXTEXTDIAGNOSTICPRINTER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXDiagnosticConsumer clang_TextDiagnosticPrinter_create(CXDiagnosticOptions Opts);

LLVM_CLANG_C_EXTERN_C_END

#endif