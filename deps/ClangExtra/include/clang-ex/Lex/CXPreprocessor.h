#ifndef LLVM_CLANG_C_EXTRA_CXPREPROCESSOR_H
#define LLVM_CLANG_C_EXTRA_CXPREPROCESSOR_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXHeaderSearch clang_Preprocessor_getHeaderSearchInfo(CXPreprocessor PP);

void clang_Preprocessor_EnterMainSourceFile(CXPreprocessor PP);

bool clang_Preprocessor_EnterSourceFile(CXPreprocessor PP, CXFileID FID,
                                        CXSourceLocation_ Loc);

void clang_Preprocessor_EndSourceFile(CXPreprocessor PP);

void clang_Preprocessor_PrintStats(CXPreprocessor PP);

void clang_Preprocessor_InitializeBuiltins(CXPreprocessor PP);

void clang_Preprocessor_enableIncrementalProcessing(CXPreprocessor PP);

bool clang_Preprocessor_isIncrementalProcessingEnabled(CXPreprocessor PP);

void clang_Preprocessor_DumpToken(CXPreprocessor PP, CXToken_ Tok, bool DumpFlags);

void clang_Preprocessor_DumpLocation(CXPreprocessor PP, CXSourceLocation_ Loc);

LLVM_CLANG_C_EXTERN_C_END

#endif