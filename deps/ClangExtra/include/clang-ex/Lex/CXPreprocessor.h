#ifndef LIBCLANGEX_CXPREPROCESSOR_H
#define LIBCLANGEX_CXPREPROCESSOR_H

#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE CXHeaderSearch clang_Preprocessor_getHeaderSearchInfo(CXPreprocessor PP);

CINDEX_LINKAGE void clang_Preprocessor_EnterMainSourceFile(CXPreprocessor PP);

CINDEX_LINKAGE bool clang_Preprocessor_EnterSourceFile(CXPreprocessor PP, CXFileID FID,
                                                       CXSourceLocation_ Loc);

CINDEX_LINKAGE void clang_Preprocessor_EndSourceFile(CXPreprocessor PP);

CINDEX_LINKAGE void clang_Preprocessor_PrintStats(CXPreprocessor PP);

CINDEX_LINKAGE void clang_Preprocessor_InitializeBuiltins(CXPreprocessor PP);

CINDEX_LINKAGE void clang_Preprocessor_enableIncrementalProcessing(CXPreprocessor PP);

CINDEX_LINKAGE bool clang_Preprocessor_isIncrementalProcessingEnabled(CXPreprocessor PP);

CINDEX_LINKAGE void clang_Preprocessor_DumpToken(CXPreprocessor PP, CXToken_ Tok,
                                                 bool DumpFlags);

CINDEX_LINKAGE void clang_Preprocessor_DumpLocation(CXPreprocessor PP,
                                                    CXSourceLocation_ Loc);

#ifdef __cplusplus
}
#endif
#endif