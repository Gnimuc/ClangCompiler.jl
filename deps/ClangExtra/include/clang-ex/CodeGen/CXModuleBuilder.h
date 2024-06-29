#ifndef LLVM_CLANG_C_EXTRA_CXMODULEBUILDER_H
#define LLVM_CLANG_C_EXTRA_CXMODULEBUILDER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// CXCodeGenerator clang_CreateLLVMCodeGen(CXCompilerInstance CI, LLVMContextRef LLVMCtx,
//                                         const char *ModuleName);

CXCodeGenModule clang_CodeGenerator_CGM(CXCodeGenerator CG);

LLVMModuleRef clang_CodeGenerator_GetModule(CXCodeGenerator CG);

LLVMModuleRef clang_CodeGenerator_ReleaseModule(CXCodeGenerator CG);

CXDecl clang_CodeGenerator_GetDeclForMangledName(CXCodeGenerator CG,
                                                 const char *MangledName);

LLVMModuleRef clang_CodeGenerator_StartModule(CXCodeGenerator CG, LLVMContextRef LLVMCtx,
                                              const char *ModuleName);

LLVM_CLANG_C_EXTERN_C_END

#endif