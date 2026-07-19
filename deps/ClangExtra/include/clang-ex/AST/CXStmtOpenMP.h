#ifndef LLVM_CLANG_C_EXTRA_CXSTMTOPENMP_H
#define LLVM_CLANG_C_EXTRA_CXSTMTOPENMP_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// OMPExecutableDirective is the abstract base of every OpenMP directive; all are
// Stmts, so classify a node with the stamped clang_Stmt_isOMP*/castToOMP* family
// and pass it here as a CXStmt. This is the abstract-base payload (per the OMP
// posture); per-directive payload is added on demand.
unsigned clang_OMPExecutableDirective_getNumClauses(CXStmt S);

bool clang_OMPExecutableDirective_isStandaloneDirective(CXStmt S);

bool clang_OMPExecutableDirective_hasAssociatedStmt(CXStmt S);

// The captured statement the directive applies to; valid only when
// hasAssociatedStmt(). Returned as a base CXStmt — resolve() to refine.
CXStmt clang_OMPExecutableDirective_getAssociatedStmt(CXStmt S);

LLVM_CLANG_C_EXTERN_C_END

#endif
