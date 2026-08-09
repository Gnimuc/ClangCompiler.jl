#ifndef LLVM_CLANG_C_EXTRA_CXDECLGROUP_H
#define LLVM_CLANG_C_EXTRA_CXDECLGROUP_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXDeclGroupRef clang_DeclGroupRef_fromDecl(CXDecl D);

bool clang_DeclGroupRef_isNull(CXDeclGroupRef DG);

bool clang_DeclGroupRef_isSingleDecl(CXDeclGroupRef DG);

bool clang_DeclGroupRef_isDeclGroup(CXDeclGroupRef DG);

CXDecl clang_DeclGroupRef_getSingleDecl(CXDeclGroupRef DG);

// The group as a count + index pair, which is the only way to reach a multi-declaration
// group (`int a, b;`) -- clang exposes those through iterators alone, and getSingleDecl
// asserts on them. Total: a null group has size 0.
unsigned clang_DeclGroupRef_size(CXDeclGroupRef DG);

// PRECONDITION: I < clang_DeclGroupRef_size.
CXDecl clang_DeclGroupRef_getDecl(CXDeclGroupRef DG, unsigned I);

LLVM_CLANG_C_EXTERN_C_END

#endif