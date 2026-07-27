#ifndef LLVM_CLANG_C_EXTRA_CXSCOPE_H
#define LLVM_CLANG_C_EXTRA_CXSCOPE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

void clang_Scope_dump(CXScope S);

CXScope clang_Scope_getParent(CXScope S);

unsigned clang_Scope_getDepth(CXScope S);

unsigned clang_Scope_getFlags(CXScope S);

// Closest enclosing scope that is a function body; null at file scope.
CXScope clang_Scope_getFnParent(CXScope S);

// Scope::getEntity returns null for a template parameter scope even when the scope
// does have an entity; use clang_Scope_isTemplateParamScope to tell the two apart.
CXDeclContext clang_Scope_getEntity(CXScope S);

bool clang_Scope_isTemplateParamScope(CXScope S);

bool clang_Scope_isDeclScope(CXScope S, CXDecl D);

LLVM_CLANG_C_EXTERN_C_END

#endif