#ifndef LLVM_CLANG_C_EXTRA_CXCONSTRUCTIONCONTEXT_H
#define LLVM_CLANG_C_EXTRA_CXCONSTRUCTIONCONTEXT_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirrors clang::ConstructionContext::Kind (a plain enum nested in
// ConstructionContext). Kept in declaration order; the VARIABLE_BEGIN/VARIABLE_END,
// INITIALIZER_BEGIN/INITIALIZER_END, TEMPORARY_BEGIN/TEMPORARY_END and
// RETURNED_VALUE_BEGIN/RETURNED_VALUE_END range aliases are omitted — alias
// enumerators duplicate values, which the generated Julia @enum cannot carry — and
// omitting them does not shift the numbering, since they are `=` assignments.
// CXEnumSync.cpp proves value-for-value equality.
typedef enum CXConstructionContextKind {
  CXConstructionContextKind_SimpleVariableKind,
  CXConstructionContextKind_CXX17ElidedCopyVariableKind,
  CXConstructionContextKind_SimpleConstructorInitializerKind,
  CXConstructionContextKind_CXX17ElidedCopyConstructorInitializerKind,
  CXConstructionContextKind_NewAllocatedObjectKind,
  CXConstructionContextKind_SimpleTemporaryObjectKind,
  CXConstructionContextKind_ElidedTemporaryObjectKind,
  CXConstructionContextKind_SimpleReturnedValueKind,
  CXConstructionContextKind_CXX17ElidedCopyReturnedValueKind,
  CXConstructionContextKind_ArgumentKind,
  CXConstructionContextKind_LambdaCaptureKind
} CXConstructionContextKind;

// ConstructionContext
//
// A construction context says where the object a CXXConstructExpr (or a class-prvalue
// call) builds is going to live. Instances are allocated from the owning CFG's
// BumpVectorContext by clang's CFG builder, so every CXConstructionContext is
// BORROWED: it is invalidated by clang_CFG_dispose and is never disposed on its own.
// Reach one with clang_CFGBlock_getElementConstructionContext.
//
// clang::ConstructionContext is an abstract base with twelve concrete subclasses whose
// payload accessors are declared on the subclass. Rather than mirroring that hierarchy
// in handle types, every accessor below is total: it dyn_casts to the subclass(es) that
// declare it and returns NULL (0 for getIndex) for every other kind — the same
// discipline the CFGElement payload accessors in CXCFG.h use.

CXConstructionContextKind clang_ConstructionContext_getKind(CXConstructionContext CC);

// getArrayInitLoop (its VariableConstructionContext override reaches the variable
// through an unchecked cast<VarDecl>(DS->getSingleDecl()))

// clang::VariableConstructionContext::getDeclStmt — SimpleVariable and
// CXX17ElidedCopyVariable kinds.
CXDeclStmt clang_ConstructionContext_getDeclStmt(CXConstructionContext CC);

// clang::ConstructorInitializerConstructionContext::getCXXCtorInitializer —
// SimpleConstructorInitializer and CXX17ElidedCopyConstructorInitializer kinds.
CXCXXCtorInitializer
clang_ConstructionContext_getCXXCtorInitializer(CXConstructionContext CC);

// clang::NewAllocatedObjectConstructionContext::getCXXNewExpr — NewAllocatedObject
// kind.
CXCXXNewExpr clang_ConstructionContext_getCXXNewExpr(CXConstructionContext CC);

// The bound-temporary payload, declared on five unrelated subclasses:
// CXX17ElidedCopyVariable, CXX17ElidedCopyConstructorInitializer, the two
// TemporaryObject kinds, CXX17ElidedCopyReturnedValue and Argument. NULL for every
// other kind, and NULL on those kinds too when the temporary's destructor is trivial.
CXCXXBindTemporaryExpr
clang_ConstructionContext_getCXXBindTemporaryExpr(CXConstructionContext CC);

// clang::TemporaryObjectConstructionContext::getMaterializedTemporaryExpr —
// SimpleTemporaryObject and ElidedTemporaryObject kinds; NULL there too when the
// temporary is never used after construction.
CXMaterializeTemporaryExpr
clang_ConstructionContext_getMaterializedTemporaryExpr(CXConstructionContext CC);

// clang::ElidedTemporaryObjectConstructionContext::getConstructorAfterElision —
// ElidedTemporaryObject kind.
CXCXXConstructExpr
clang_ConstructionContext_getConstructorAfterElision(CXConstructionContext CC);

// clang::ElidedTemporaryObjectConstructionContext::getConstructionContextAfterElision
// — ElidedTemporaryObject kind. Borrowed from the same CFG arena as its parent.
CXConstructionContext
clang_ConstructionContext_getConstructionContextAfterElision(CXConstructionContext CC);

// clang::ReturnedValueConstructionContext::getReturnStmt — SimpleReturnedValue and
// CXX17ElidedCopyReturnedValue kinds.
CXReturnStmt clang_ConstructionContext_getReturnStmt(CXConstructionContext CC);

// clang::ArgumentConstructionContext::getCallLikeExpr — Argument kind. The result is a
// CallExpr, a CXXConstructExpr or an ObjCMessageExpr; resolve it to refine.
CXExpr clang_ConstructionContext_getCallLikeExpr(CXConstructionContext CC);

// The argument/capture index, declared on ArgumentConstructionContext and
// LambdaCaptureConstructionContext. 0 for every other kind — which is also a valid
// index, so the Julia wrapper asserts the kind instead of reading a sentinel.
unsigned clang_ConstructionContext_getIndex(CXConstructionContext CC);

// clang::LambdaCaptureConstructionContext::getLambdaExpr — LambdaCapture kind.
CXLambdaExpr clang_ConstructionContext_getLambdaExpr(CXConstructionContext CC);

// clang::LambdaCaptureConstructionContext::getInitializer — LambdaCapture kind.
// PARTIAL: it indexes the lambda's capture-initializer list with the stored index and
// bounds-checks nothing. The index is in range by construction, because only clang's
// own CFG builder ever creates these contexts.
CXExpr clang_ConstructionContext_getInitializer(CXConstructionContext CC);

// clang::LambdaCaptureConstructionContext::getFieldDecl — LambdaCapture kind. PARTIAL
// in the same way as getInitializer: it advances the lambda class's field list by the
// stored index with no bounds check.
CXFieldDecl clang_ConstructionContext_getFieldDecl(CXConstructionContext CC);

LLVM_CLANG_C_EXTERN_C_END

#endif
