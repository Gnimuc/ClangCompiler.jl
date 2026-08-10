#ifndef LLVM_CLANG_C_EXTRA_CXBACKENDUTIL_H
#define LLVM_CLANG_C_EXTRA_CXBACKENDUTIL_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirrors clang::BackendAction (clang/CodeGen/BackendUtil.h; synced in
// lib/Basic/CXEnumSync.cpp): what the backend leaves behind after running the pipeline.
typedef enum CXBackendAction {
  CXBackendAction_Backend_EmitAssembly,
  CXBackendAction_Backend_EmitBC,
  CXBackendAction_Backend_EmitLL,
  CXBackendAction_Backend_EmitNothing,
  CXBackendAction_Backend_EmitMCNull,
  CXBackendAction_Backend_EmitObj
} CXBackendAction;

// Run clang's middle-end and backend over M -- the optimization pipeline CI's CodeGenOptions
// describe, then the emission Action asks for -- writing the result to OutputPath.
//
// Everything the C++ entry point takes separately is read off CI: its DiagnosticsEngine,
// header-search / codegen / target / language options, the data-layout string of its target,
// and the virtual file system its FileManager holds. The output stream is opened here, in
// text mode for the assembly and .ll actions and binary otherwise.
//
// PRECONDITIONS: CI must have a FileManager (clang_CompilerInstance_hasFileManager) and a
// target (clang_CompilerInstance_hasTarget); OutputPath must be non-NULL unless Action is
// CXBackendAction_Backend_EmitNothing. False (and a log line) when one of those does not
// hold or the file cannot be opened.
//
// The return value otherwise reports whether the pipeline itself added an error to CI's
// diagnostics -- the C++ function returns void and says so only through diagnostics.
bool clang_EmitBackendOutput(CXCompilerInstance CI, LLVMModuleRef M, CXBackendAction Action,
                             const char *OutputPath);

// EmbedBitcode
// EmbedObject

LLVM_CLANG_C_EXTERN_C_END

#endif
