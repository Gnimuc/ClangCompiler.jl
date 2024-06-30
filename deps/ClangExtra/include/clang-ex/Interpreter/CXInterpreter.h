#ifndef LLVM_CLANG_C_EXTRA_CXINTERPRETER_H
#define LLVM_CLANG_C_EXTRA_CXINTERPRETER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/LLJIT.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXIncrementalCompilerBuilder clang_IncrementalCompilerBuilder_create(void);

void clang_IncrementalCompilerBuilder_dispose(CXIncrementalCompilerBuilder CB);

void clang_IncrementalCompilerBuilder_SetCompilerArgs(const char **Args, int N);

CXCompilerInstance clang_IncrementalCompilerBuilder_CreateCpp(void);

void clang_IncrementalCompilerBuilder_SetOffloadArch(const char *Arch);

void clang_IncrementalCompilerBuilder_SetCudaSDK(const char *path);

CXCompilerInstance clang_IncrementalCompilerBuilder_CreateCudaHost(void);

CXCompilerInstance clang_IncrementalCompilerBuilder_CreateCudaDevice(void);

CXInterpreter clang_Interpreter_create(CXCompilerInstance CI);

CXInterpreter clang_Interpreter_createWithCUDA(CXCompilerInstance CI,
                                               CXCompilerInstance DCI);

void clang_Interpreter_dispose(CXInterpreter Interp);

CXCompilerInstance clang_Interpreter_getCompilerInstance(CXInterpreter Interp);

LLVMOrcLLJITRef clang_Interpreter_getExecutionEngine(CXInterpreter Interp);

CXPartialTranslationUnit clang_Interpreter_Parse(CXInterpreter Interp, const char *Code);

void clang_Interpreter_Execute(CXInterpreter Interp, CXPartialTranslationUnit PTU);

void clang_Interpreter_ParseAndExecute(CXInterpreter Interp, const char *Code,
                                       CXValue *Result);

CXExecutorAddr clang_Interpreter_CompileDtorCall(CXInterpreter Interp,
                                                 CXCXXRecordDecl CXXRD);

void clang_Interpreter_Undo(CXInterpreter Interp, unsigned int N);

void clang_Interpreter_LoadDynamicLibrary(CXInterpreter Interp, const char *name);

CXExecutorAddr clang_Interpreter_getSymbolAddress(CXInterpreter Interp, const char *IRName);

CXExecutorAddr clang_Interpreter_getSymbolAddressFromLinkerName(CXInterpreter Interp,
                                                                const char *LinkerName);

LLVM_CLANG_C_EXTERN_C_END

#endif