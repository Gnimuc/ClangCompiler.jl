#ifndef LIBCLANGEX_CXMODULEBUILDER_H
#define LIBCLANGEX_CXMODULEBUILDER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE CXCodeGenerator clang_CreateLLVMCodeGen(CXCompilerInstance CI,
                                                       LLVMContextRef LLVMCtx,
                                                       const char *ModuleName);

CINDEX_LINKAGE CXCodeGenModule clang_CodeGenerator_CGM(CXCodeGenerator CG);

CINDEX_LINKAGE LLVMModuleRef clang_CodeGenerator_GetModule(CXCodeGenerator CG);

CINDEX_LINKAGE LLVMModuleRef clang_CodeGenerator_ReleaseModule(CXCodeGenerator CG);

CINDEX_LINKAGE CXDecl clang_CodeGenerator_GetDeclForMangledName(CXCodeGenerator CG,
                                                                const char *MangledName);

CINDEX_LINKAGE LLVMModuleRef clang_CodeGenerator_StartModule(CXCodeGenerator CG,
                                                             LLVMContextRef LLVMCtx,
                                                             const char *ModuleName);

#ifdef __cplusplus
}
#endif
#endif