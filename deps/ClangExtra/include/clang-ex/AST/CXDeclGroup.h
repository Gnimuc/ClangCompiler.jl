#ifndef LLVM_CLANG_C_EXTRA_CXDECLGROUP_H
#define LLVM_CLANG_C_EXTRA_CXDECLGROUP_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXDeclGroupRef clang_DeclGroupRef_fromeDecl(CXDecl D);

bool clang_DeclGroupRef_isNull(CXDeclGroupRef DG);

bool clang_DeclGroupRef_isSingleDecl(CXDeclGroupRef DG);

bool clang_DeclGroupRef_isDeclGroup(CXDeclGroupRef DG);

CXDecl clang_DeclGroupRef_getSingleDecl(CXDeclGroupRef DG);

LLVM_CLANG_C_EXTERN_C_END

#endif