#ifndef LIBCLANGEX_CXCODEGENACTION_H
#define LIBCLANGEX_CXCODEGENACTION_H

#include "clang-ex/CXError.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE CXCodeGenAction clang_EmitAssemblyAction_create(CXInit_Error *ErrorCode,
                                                               LLVMContextRef LLVMCtx);
CINDEX_LINKAGE CXCodeGenAction clang_EmitBCAction_create(CXInit_Error *ErrorCode,
                                                         LLVMContextRef LLVMCtx);
CINDEX_LINKAGE CXCodeGenAction clang_EmitLLVMAction_create(CXInit_Error *ErrorCode,
                                                           LLVMContextRef LLVMCtx);
CINDEX_LINKAGE CXCodeGenAction clang_EmitLLVMOnlyAction_create(CXInit_Error *ErrorCode,
                                                               LLVMContextRef LLVMCtx);
CINDEX_LINKAGE CXCodeGenAction clang_EmitCodeGenOnlyAction_create(CXInit_Error *ErrorCode,
                                                                  LLVMContextRef LLVMCtx);
CINDEX_LINKAGE CXCodeGenAction clang_EmitObjAction_create(CXInit_Error *ErrorCode,
                                                          LLVMContextRef LLVMCtx);

CINDEX_LINKAGE void clang_CodeGenAction_dispose(CXCodeGenAction CA);

CINDEX_LINKAGE LLVMModuleRef clang_CodeGenAction_takeModule(CXCodeGenAction CA);

#ifdef __cplusplus
}
#endif
#endif