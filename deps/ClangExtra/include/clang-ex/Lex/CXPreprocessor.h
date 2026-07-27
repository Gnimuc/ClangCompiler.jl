#ifndef LLVM_CLANG_C_EXTRA_CXPREPROCESSOR_H
#define LLVM_CLANG_C_EXTRA_CXPREPROCESSOR_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
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

CXDiagnosticsEngine clang_Preprocessor_getDiagnostics(CXPreprocessor PP);

CXLangOptions clang_Preprocessor_getLangOpts(CXPreprocessor PP);

CXTargetInfo_ clang_Preprocessor_getTargetInfo(CXPreprocessor PP);

CXFileManager clang_Preprocessor_getFileManager(CXPreprocessor PP);

CXSourceManager clang_Preprocessor_getSourceManager(CXPreprocessor PP);

CXIdentifierTable clang_Preprocessor_getIdentifierTable(CXPreprocessor PP);

void clang_Preprocessor_SetCommentRetentionState(CXPreprocessor PP, bool KeepComments,
                                                 bool KeepMacroComments);

bool clang_Preprocessor_getCommentRetentionState(CXPreprocessor PP);

void clang_Preprocessor_setPragmasEnabled(CXPreprocessor PP, bool Enabled);

bool clang_Preprocessor_getPragmasEnabled(CXPreprocessor PP);

// The returned FileID is heap-allocated; dispose with `clang_FileID_dispose`.
CXFileID clang_Preprocessor_getPredefinesFileID(CXPreprocessor PP);

unsigned clang_Preprocessor_getTokenCount(CXPreprocessor PP);

unsigned clang_Preprocessor_getMaxTokens(CXPreprocessor PP);

bool clang_Preprocessor_isMacroDefined(CXPreprocessor PP, const char *Id);

// Borrowed; NULL when `II` has no active macro definition.
CXMacroInfo clang_Preprocessor_getMacroInfo(CXPreprocessor PP, CXIdentifierInfo II);

CXString clang_Preprocessor_getPredefines(CXPreprocessor PP);

void clang_Preprocessor_setPredefines(CXPreprocessor PP, const char *P);

CXIdentifierInfo clang_Preprocessor_getIdentifierInfo(CXPreprocessor PP,
                                                      const char *Name);

void clang_Preprocessor_Lex(CXPreprocessor PP, CXToken_ Result);

CXString clang_Preprocessor_getSpelling(CXPreprocessor PP, CXToken_ Tok);

LLVM_CLANG_C_EXTERN_C_END

#endif