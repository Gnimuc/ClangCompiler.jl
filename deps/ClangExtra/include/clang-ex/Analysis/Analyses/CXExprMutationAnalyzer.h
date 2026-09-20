#ifndef LLVM_CLANG_C_EXTRA_CXEXPRMUTATIONANALYZER_H
#define LLVM_CLANG_C_EXTRA_CXEXPRMUTATIONANALYZER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// ExprMutationAnalyzer
// Answers "is this expression (or this declaration's value) written through, anywhere
// inside the statement I was built over?". Every query runs AST matchers over the same
// statement and memoizes its result, so one analyzer per statement is the intended use.
//
// LIFETIME: clang::ExprMutationAnalyzer stores `const Stmt &Stm` and `ASTContext &Context`
// as references (verified in clang/Analysis/Analyses/ExprMutationAnalyzer.h), so both must
// outlive the analyzer. Every Expr / Decl passed to a query must belong to that same
// statement and context.

// Neither Stm nor Context may be NULL — the constructor binds them by reference. The
// analyzer is CALLER-OWNED; pair with clang_ExprMutationAnalyzer_dispose.
CXExprMutationAnalyzer clang_ExprMutationAnalyzer_create(CXStmt Stm, CXASTContext Context);

void clang_ExprMutationAnalyzer_dispose(CXExprMutationAnalyzer EMA);

// Whether Exp is mutated somewhere in the analyzed statement — the same thing as
// clang_ExprMutationAnalyzer_findMutation returning non-NULL.
bool clang_ExprMutationAnalyzer_isMutated(CXExprMutationAnalyzer EMA, CXExpr Exp);

// isMutated(const Decl *) — the Decl overload, under a disambiguated symbol because C has
// no overloading. It is isMutated applied to every DeclRefExpr of Dec in the statement.
bool clang_ExprMutationAnalyzer_isMutatedFromDecl(CXExprMutationAnalyzer EMA, CXDecl Dec);

// The statement that mutates Exp, or NULL when nothing does. Which one is reported when
// there are several is unspecified.
CXStmt clang_ExprMutationAnalyzer_findMutation(CXExprMutationAnalyzer EMA, CXExpr Exp);

// findMutation(const Decl *) — the Decl overload.
CXStmt clang_ExprMutationAnalyzer_findMutationFromDecl(CXExprMutationAnalyzer EMA,
                                                       CXDecl Dec);

// Whether what Exp points at is mutated, as opposed to Exp itself: `*p = 1` mutates the
// pointee of `p`, not `p`.
bool clang_ExprMutationAnalyzer_isPointeeMutated(CXExprMutationAnalyzer EMA, CXExpr Exp);

// isPointeeMutated(const Decl *) — the Decl overload.
bool clang_ExprMutationAnalyzer_isPointeeMutatedFromDecl(CXExprMutationAnalyzer EMA,
                                                         CXDecl Dec);

CXStmt clang_ExprMutationAnalyzer_findPointeeMutation(CXExprMutationAnalyzer EMA,
                                                      CXExpr Exp);

// findPointeeMutation(const Decl *) — the Decl overload.
CXStmt clang_ExprMutationAnalyzer_findPointeeMutationFromDecl(CXExprMutationAnalyzer EMA,
                                                              CXDecl Dec);

// Static clang::ExprMutationAnalyzer::isUnevaluated — whether Smt is an unevaluated
// operand (of a sizeof, decltype, noexcept or typeid), where a write would never actually
// happen. Needs no analyzer object. LLVM 20 dropped the enclosing-statement parameter, so
// Stm is accepted and ignored. Neither Smt nor Context may be NULL.
bool clang_ExprMutationAnalyzer_isUnevaluated(CXStmt Smt, CXStmt Stm,
                                              CXASTContext Context);

// FunctionParmMutationAnalyzer
// clang::ExprMutationAnalyzer specialised to a function body, answering the mutation
// question per parameter.

// PARTIAL: clang::FunctionParmMutationAnalyzer's constructor is
// `BodyAnalyzer(*Func.getBody(), Context)` — it dereferences getBody() with no null check,
// so Func must have a body in this translation unit. Neither argument may be NULL, and
// both the body and the context must outlive the analyzer, which is CALLER-OWNED.
CXFunctionParmMutationAnalyzer
clang_FunctionParmMutationAnalyzer_create(CXFunctionDecl Func, CXASTContext Context);

void clang_FunctionParmMutationAnalyzer_dispose(CXFunctionParmMutationAnalyzer FPMA);

// Whether Parm is written to inside the function body. Parm must be a parameter of the
// FunctionDecl the analyzer was built from.
bool clang_FunctionParmMutationAnalyzer_isMutated(CXFunctionParmMutationAnalyzer FPMA,
                                                  CXParmVarDecl Parm);

// The statement that mutates Parm, or NULL when nothing does.
CXStmt clang_FunctionParmMutationAnalyzer_findMutation(CXFunctionParmMutationAnalyzer FPMA,
                                                       CXParmVarDecl Parm);

LLVM_CLANG_C_EXTERN_C_END

#endif
