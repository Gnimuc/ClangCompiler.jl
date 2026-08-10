#ifndef LLVM_CLANG_C_EXTRA_CXINTERPRETER_H
#define LLVM_CLANG_C_EXTRA_CXINTERPRETER_H

#include "clang-ex/CXTypes.h"
#include "clang-ex/Basic/CXABI.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-c/CXString.h"
#include "llvm-c/LLJIT.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXIncrementalCompilerBuilder clang_IncrementalCompilerBuilder_create(void);

void clang_IncrementalCompilerBuilder_dispose(CXIncrementalCompilerBuilder CB);

void clang_IncrementalCompilerBuilder_SetCompilerArgs(CXIncrementalCompilerBuilder CB,
                                                      const char **Args, int N);

CXCompilerInstance
clang_IncrementalCompilerBuilder_CreateCpp(CXIncrementalCompilerBuilder CB);

void clang_IncrementalCompilerBuilder_SetOffloadArch(CXIncrementalCompilerBuilder CB,
                                                     const char *Arch);

void clang_IncrementalCompilerBuilder_SetCudaSDK(CXIncrementalCompilerBuilder CB,
                                                 const char *path);

CXCompilerInstance
clang_IncrementalCompilerBuilder_CreateCudaHost(CXIncrementalCompilerBuilder CB);

CXCompilerInstance
clang_IncrementalCompilerBuilder_CreateCudaDevice(CXIncrementalCompilerBuilder CB);

CXInterpreter clang_Interpreter_create(CXCompilerInstance CI);

CXInterpreter clang_Interpreter_createWithCUDA(CXCompilerInstance CI,
                                               CXCompilerInstance DCI);

void clang_Interpreter_dispose(CXInterpreter Interp);

CXCompilerInstance clang_Interpreter_getCompilerInstance(CXInterpreter Interp);

// The interpreter's ASTContext, borrowed. Equivalent to going through the compiler instance,
// which is what clang's own body does.
CXASTContext clang_Interpreter_getASTContext(CXInterpreter Interp);

LLVMOrcLLJITRef clang_Interpreter_getExecutionEngine(CXInterpreter Interp);

CXPartialTranslationUnit clang_Interpreter_Parse(CXInterpreter Interp, const char *Code);

// The four fallible void methods below report failure through their return value rather
// than the library's usual log-to-stderr-and-swallow, because a REPL has to tell its user
// that an input did not run. The CXString is the llvm::Error's message and is empty on
// success; it is caller-owned either way (an empty CXString is unmanaged, so disposing it
// is still correct).
CXString clang_Interpreter_Execute(CXInterpreter Interp, CXPartialTranslationUnit PTU);

CXString clang_Interpreter_ParseAndExecute(CXInterpreter Interp, const char *Code,
                                           CXValue Result);

LLVMOrcExecutorAddress clang_Interpreter_CompileDtorCall(CXInterpreter Interp,
                                                         CXCXXRecordDecl CXXRD);

// Undoing more increments than have been parsed is the caller's error to detect: the
// returned message says so rather than the process aborting.
CXString clang_Interpreter_Undo(CXInterpreter Interp, unsigned int N);

CXString clang_Interpreter_LoadDynamicLibrary(CXInterpreter Interp, const char *name);

LLVMOrcExecutorAddress clang_Interpreter_getSymbolAddress(CXInterpreter Interp,
                                                          const char *IRName);

// helper: the GlobalDecl overload of getSymbolAddress, split into one entry point per
// GlobalDecl spelling because C has no overloading. Unlike the IRName overload these use
// CodeGenModule's own mangled name for the decl, so they cannot disagree with what codegen
// emitted. All three return 0 when the decl has not been emitted yet (the symbol does not
// exist until its increment has been executed) and log the reason.
LLVMOrcExecutorAddress clang_Interpreter_getSymbolAddressFromDecl(CXInterpreter Interp,
                                                                  CXNamedDecl D);

// A constructor has several emitted bodies; CtorKind picks the one wanted.
LLVMOrcExecutorAddress
clang_Interpreter_getSymbolAddressFromCtorDecl(CXInterpreter Interp, CXCXXConstructorDecl D,
                                               CXCXXCtorType CtorKind);

LLVMOrcExecutorAddress
clang_Interpreter_getSymbolAddressFromDtorDecl(CXInterpreter Interp, CXCXXDestructorDecl D,
                                               CXCXXDtorType DtorKind);

LLVMOrcExecutorAddress
clang_Interpreter_getSymbolAddressFromLinkerName(CXInterpreter Interp,
                                                 const char *LinkerName);

CXCodeGenerator clang_Interpreter_getCodeGen(CXInterpreter Interp);

CXParser clang_Interpreter_getParser(CXInterpreter Interp);

LLVM_CLANG_C_EXTERN_C_END

#endif