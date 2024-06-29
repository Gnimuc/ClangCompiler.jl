#ifndef LLVM_CLANG_C_EXTRA_CXCOMPILERINSTANCE_H
#define LLVM_CLANG_C_EXTRA_CXCOMPILERINSTANCE_H

#include "clang-ex/CXError.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXCompilerInstance clang_CompilerInstance_create(CXInit_Error *ErrorCode);

void clang_CompilerInstance_dispose(CXCompilerInstance CI);

// Diagnostics
bool clang_CompilerInstance_hasDiagnostics(CXCompilerInstance CI);

CXDiagnosticsEngine clang_CompilerInstance_getDiagnostics(CXCompilerInstance CI);

void clang_CompilerInstance_setDiagnostics(CXCompilerInstance CI,
                                           CXDiagnosticsEngine Value);

CXDiagnosticConsumer clang_CompilerInstance_getDiagnosticClient(CXCompilerInstance CI);

void clang_CompilerInstance_createDiagnostics(CXCompilerInstance CI,
                                              CXDiagnosticConsumer DC,
                                              bool ShouldOwnClient);

// FileManager
bool clang_CompilerInstance_hasFileManager(CXCompilerInstance CI);

CXFileManager clang_CompilerInstance_getFileManager(CXCompilerInstance CI);

void clang_CompilerInstance_setFileManager(CXCompilerInstance CI, CXFileManager FM);

CXFileManager clang_CompilerInstance_createFileManager(CXCompilerInstance CI);

CXFileManager clang_CompilerInstance_createFileManagerWithVOFS4PCH(
    CXCompilerInstance CI, const char *Path, time_t ModificationTime,
    LLVMMemoryBufferRef PCHBuffer);

// SourceManager
bool clang_CompilerInstance_hasSourceManager(CXCompilerInstance CI);

CXSourceManager clang_CompilerInstance_getSourceManager(CXCompilerInstance CI);

void clang_CompilerInstance_setSourceManager(CXCompilerInstance CI, CXSourceManager SM);

void clang_CompilerInstance_createSourceManager(CXCompilerInstance CI,
                                                CXFileManager FileMgr);

// Invocation
bool clang_CompilerInstance_hasInvocation(CXCompilerInstance CI);

CXCompilerInvocation clang_CompilerInstance_getInvocation(CXCompilerInstance CI);

void clang_CompilerInstance_setInvocation(CXCompilerInstance CI, CXCompilerInvocation CInv);

// Target
bool clang_CompilerInstance_hasTarget(CXCompilerInstance CI);

CXTargetInfo_ clang_CompilerInstance_getTarget(CXCompilerInstance CI);

void clang_CompilerInstance_setTarget(CXCompilerInstance CI, CXTargetInfo_ Info);

void clang_CompilerInstance_setTargetAndLangOpts(CXCompilerInstance CI);

// Preprocessor
bool clang_CompilerInstance_hasPreprocessor(CXCompilerInstance CI);

CXPreprocessor clang_CompilerInstance_getPreprocessor(CXCompilerInstance CI);

void clang_CompilerInstance_setPreprocessor(CXCompilerInstance CI, CXPreprocessor PP);

void clang_CompilerInstance_createPreprocessor(CXCompilerInstance CI,
                                               CXTranslationUnitKind TUKind);

// Sema
bool clang_CompilerInstance_hasSema(CXCompilerInstance CI);

CXSema clang_CompilerInstance_getSema(CXCompilerInstance CI);

void clang_CompilerInstance_setSema(CXCompilerInstance CI, CXSema S);

void clang_CompilerInstance_createSema(CXCompilerInstance CI, CXTranslationUnitKind TUKind);

// ASTContext
bool clang_CompilerInstance_hasASTContext(CXCompilerInstance CI);

CXASTContext clang_CompilerInstance_getASTContext(CXCompilerInstance CI);

void clang_CompilerInstance_setASTContext(CXCompilerInstance CI, CXASTContext Ctx);

void clang_CompilerInstance_createASTContext(CXCompilerInstance CI);

// ASTConsumer
bool clang_CompilerInstance_hasASTConsumer(CXCompilerInstance CI);

CXASTConsumer clang_CompilerInstance_getASTConsumer(CXCompilerInstance CI);

void clang_CompilerInstance_setASTConsumer(CXCompilerInstance CI, CXASTConsumer CG);

// Options
CXCodeGenOptions clang_CompilerInstance_getCodeGenOpts(CXCompilerInstance CI);

CXDiagnosticOptions clang_CompilerInstance_getDiagnosticOpts(CXCompilerInstance CI);

CXFrontendOptions clang_CompilerInstance_getFrontendOpts(CXCompilerInstance CI);

CXHeaderSearchOptions clang_CompilerInstance_getHeaderSearchOpts(CXCompilerInstance CI);

CXPreprocessorOptions clang_CompilerInstance_getPreprocessorOpts(CXCompilerInstance CI);

CXTargetOptions clang_CompilerInstance_getTargetOpts(CXCompilerInstance CI);

CXLangOptions clang_CompilerInstance_getLangOpts(CXCompilerInstance CI);

// Action
bool clang_CompilerInstance_ExecuteAction(CXCompilerInstance CI, CXFrontendAction Act);

LLVM_CLANG_C_EXTERN_C_END

#endif