#ifndef LLVM_CLANG_C_EXTRA_CXMODULEBUILDER_H
#define LLVM_CLANG_C_EXTRA_CXMODULEBUILDER_H

#include "clang-ex/CXTypes.h"
#include "clang-ex/Basic/CXABI.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// A standalone code generator: an ASTConsumer that lowers to LLVM IR without a
// FrontendAction or an Interpreter driving it. Everything but the module name and the LLVM
// context is read off CI -- its DiagnosticsEngine, header-search / preprocessor / codegen
// options, and the virtual file system its FileManager holds.
//
// PRECONDITION: CI must have a FileManager (clang_CompilerInstance_hasFileManager); the
// 18 signature takes the VFS and there is nowhere else to get one. NULL (and a log line)
// otherwise.
//
// The result is caller-owned: release it with clang_CodeGenerator_dispose. It must outlive
// every Sema and Parser that was built against it.
// ADOPTION: clang_CompilerInstance_setASTConsumer wraps the consumer in a unique_ptr, so a
// generator handed to it is owned by the CompilerInstance from then on and disposing it
// here is a double free.
CXCodeGenerator clang_CreateLLVMCodeGen(CXCompilerInstance CI, const char *ModuleName,
                                        LLVMContextRef LLVMCtx);

void clang_CodeGenerator_dispose(CXCodeGenerator CG);

CXCodeGenModule clang_CodeGenerator_CGM(CXCodeGenerator CG);

LLVMModuleRef clang_CodeGenerator_GetModule(CXCodeGenerator CG);

LLVMModuleRef clang_CodeGenerator_ReleaseModule(CXCodeGenerator CG);

// getCGDebugInfo -- returns CodeGen::CGDebugInfo *, a lib/CodeGen class with no installed
// header, so the handle would name a type nothing can be done with.

CXDecl clang_CodeGenerator_GetDeclForMangledName(CXCodeGenerator CG,
                                                 const char *MangledName);

// The name codegen mangled the decl to, split into one entry point per GlobalDecl spelling
// because C has no overloading. This is the name in the module, so it cannot disagree with
// what was emitted -- unlike a MangleContext consulted separately. The CXString is
// caller-owned.
CXString clang_CodeGenerator_GetMangledName(CXCodeGenerator CG, CXNamedDecl D);

// A constructor has several emitted bodies; CtorKind picks the one wanted. Passing the
// constructor through clang_CodeGenerator_GetMangledName instead would abort: clang's
// GlobalDecl(NamedDecl *) contract rejects constructors and destructors.
CXString clang_CodeGenerator_GetMangledNameFromCtorDecl(CXCodeGenerator CG,
                                                        CXCXXConstructorDecl D,
                                                        CXCXXCtorType CtorKind);

CXString clang_CodeGenerator_GetMangledNameFromDtorDecl(CXCodeGenerator CG,
                                                        CXCXXDestructorDecl D,
                                                        CXCXXDtorType DtorKind);

// The llvm::Constant naming the decl's storage, scheduling the decl for emission into the
// module this generator is currently building. With IsForDefinition the result is an
// llvm::GlobalValue; without it, any constant expression that names the entity.
//
// Same three-way GlobalDecl split as above, and the same reason for it.
LLVMValueRef clang_CodeGenerator_GetAddrOfGlobal(CXCodeGenerator CG, CXNamedDecl D,
                                                 bool IsForDefinition);

LLVMValueRef clang_CodeGenerator_GetAddrOfGlobalFromCtorDecl(CXCodeGenerator CG,
                                                             CXCXXConstructorDecl D,
                                                             CXCXXCtorType CtorKind,
                                                             bool IsForDefinition);

LLVMValueRef clang_CodeGenerator_GetAddrOfGlobalFromDtorDecl(CXCodeGenerator CG,
                                                             CXCXXDestructorDecl D,
                                                             CXCXXDtorType DtorKind,
                                                             bool IsForDefinition);

LLVMModuleRef clang_CodeGenerator_StartModule(CXCodeGenerator CG, LLVMContextRef LLVMCtx,
                                              const char *ModuleName);

LLVM_CLANG_C_EXTERN_C_END

#endif
