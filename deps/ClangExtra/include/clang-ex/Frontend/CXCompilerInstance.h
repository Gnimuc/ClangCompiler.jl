#ifndef LIBCLANGEX_CXCOMPILERINSTANCE_H
#define LIBCLANGEX_CXCOMPILERINSTANCE_H

#include "clang-ex/CXError.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE CXCompilerInstance clang_CompilerInstance_create(CXInit_Error *ErrorCode);

CINDEX_LINKAGE void clang_CompilerInstance_dispose(CXCompilerInstance CI);

// Diagnostics
CINDEX_LINKAGE bool clang_CompilerInstance_hasDiagnostics(CXCompilerInstance CI);

CINDEX_LINKAGE CXDiagnosticsEngine
clang_CompilerInstance_getDiagnostics(CXCompilerInstance CI);

CINDEX_LINKAGE void clang_CompilerInstance_setDiagnostics(CXCompilerInstance CI,
                                                          CXDiagnosticsEngine Value);

CINDEX_LINKAGE CXDiagnosticConsumer
clang_CompilerInstance_getDiagnosticClient(CXCompilerInstance CI);

CINDEX_LINKAGE void clang_CompilerInstance_createDiagnostics(CXCompilerInstance CI,
                                                             CXDiagnosticConsumer DC,
                                                             bool ShouldOwnClient);

// FileManager
CINDEX_LINKAGE bool clang_CompilerInstance_hasFileManager(CXCompilerInstance CI);

CINDEX_LINKAGE CXFileManager clang_CompilerInstance_getFileManager(CXCompilerInstance CI);

CINDEX_LINKAGE void clang_CompilerInstance_setFileManager(CXCompilerInstance CI,
                                                          CXFileManager FM);

CINDEX_LINKAGE CXFileManager
clang_CompilerInstance_createFileManager(CXCompilerInstance CI);

CINDEX_LINKAGE CXFileManager clang_CompilerInstance_createFileManagerWithVOFS4PCH(
    CXCompilerInstance CI, const char *Path, time_t ModificationTime,
    LLVMMemoryBufferRef PCHBuffer);

// SourceManager
CINDEX_LINKAGE bool clang_CompilerInstance_hasSourceManager(CXCompilerInstance CI);

CINDEX_LINKAGE CXSourceManager
clang_CompilerInstance_getSourceManager(CXCompilerInstance CI);

CINDEX_LINKAGE void clang_CompilerInstance_setSourceManager(CXCompilerInstance CI,
                                                            CXSourceManager SM);

CINDEX_LINKAGE void clang_CompilerInstance_createSourceManager(CXCompilerInstance CI,
                                                               CXFileManager FileMgr);

// Invocation
CINDEX_LINKAGE bool clang_CompilerInstance_hasInvocation(CXCompilerInstance CI);

CINDEX_LINKAGE CXCompilerInvocation
clang_CompilerInstance_getInvocation(CXCompilerInstance CI);

CINDEX_LINKAGE void clang_CompilerInstance_setInvocation(CXCompilerInstance CI,
                                                         CXCompilerInvocation CInv);

// Target
CINDEX_LINKAGE bool clang_CompilerInstance_hasTarget(CXCompilerInstance CI);

CINDEX_LINKAGE CXTargetInfo_ clang_CompilerInstance_getTarget(CXCompilerInstance CI);

CINDEX_LINKAGE void clang_CompilerInstance_setTarget(CXCompilerInstance CI,
                                                     CXTargetInfo_ Info);

CINDEX_LINKAGE void clang_CompilerInstance_setTargetAndLangOpts(CXCompilerInstance CI);

// Preprocessor
CINDEX_LINKAGE bool clang_CompilerInstance_hasPreprocessor(CXCompilerInstance CI);

CINDEX_LINKAGE CXPreprocessor clang_CompilerInstance_getPreprocessor(CXCompilerInstance CI);

CINDEX_LINKAGE void clang_CompilerInstance_setPreprocessor(CXCompilerInstance CI,
                                                           CXPreprocessor PP);

CINDEX_LINKAGE void clang_CompilerInstance_createPreprocessor(CXCompilerInstance CI,
                                                              CXTranslationUnitKind TUKind);

// Sema
CINDEX_LINKAGE bool clang_CompilerInstance_hasSema(CXCompilerInstance CI);

CINDEX_LINKAGE CXSema clang_CompilerInstance_getSema(CXCompilerInstance CI);

CINDEX_LINKAGE void clang_CompilerInstance_setSema(CXCompilerInstance CI, CXSema S);

CINDEX_LINKAGE void clang_CompilerInstance_createSema(CXCompilerInstance CI,
                                                      CXTranslationUnitKind TUKind);

// ASTContext
CINDEX_LINKAGE bool clang_CompilerInstance_hasASTContext(CXCompilerInstance CI);

CINDEX_LINKAGE CXASTContext clang_CompilerInstance_getASTContext(CXCompilerInstance CI);

CINDEX_LINKAGE void clang_CompilerInstance_setASTContext(CXCompilerInstance CI,
                                                         CXASTContext Ctx);

CINDEX_LINKAGE void clang_CompilerInstance_createASTContext(CXCompilerInstance CI);

// ASTConsumer
CINDEX_LINKAGE bool clang_CompilerInstance_hasASTConsumer(CXCompilerInstance CI);

CINDEX_LINKAGE CXASTConsumer clang_CompilerInstance_getASTConsumer(CXCompilerInstance CI);

CINDEX_LINKAGE void clang_CompilerInstance_setASTConsumer(CXCompilerInstance CI,
                                                          CXASTConsumer CG);

// Options
CINDEX_LINKAGE CXCodeGenOptions
clang_CompilerInstance_getCodeGenOpts(CXCompilerInstance CI);

CINDEX_LINKAGE CXDiagnosticOptions
clang_CompilerInstance_getDiagnosticOpts(CXCompilerInstance CI);

CINDEX_LINKAGE CXFrontendOptions
clang_CompilerInstance_getFrontendOpts(CXCompilerInstance CI);

CINDEX_LINKAGE CXHeaderSearchOptions
clang_CompilerInstance_getHeaderSearchOpts(CXCompilerInstance CI);

CINDEX_LINKAGE CXPreprocessorOptions
clang_CompilerInstance_getPreprocessorOpts(CXCompilerInstance CI);

CINDEX_LINKAGE CXTargetOptions clang_CompilerInstance_getTargetOpts(CXCompilerInstance CI);

CINDEX_LINKAGE CXLangOptions clang_CompilerInstance_getLangOpts(CXCompilerInstance CI);

// Action
CINDEX_LINKAGE bool clang_CompilerInstance_ExecuteAction(CXCompilerInstance CI,
                                                         CXFrontendAction Act);

#ifdef __cplusplus
}
#endif
#endif