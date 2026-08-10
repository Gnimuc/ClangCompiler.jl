#ifndef LLVM_CLANG_C_EXTRA_CXASTSTRUCTURALEQUIVALENCE_H
#define LLVM_CLANG_C_EXTRA_CXASTSTRUCTURALEQUIVALENCE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/AST/ASTStructuralEquivalence.h: enum class clang::StructuralEquivalenceKind.
// Minimal skips the recursive check of declarations with external storage.
typedef enum CXStructuralEquivalenceKind {
  CXStructuralEquivalenceKind_Default,
  CXStructuralEquivalenceKind_Minimal
} CXStructuralEquivalenceKind;

// StructuralEquivalenceContext
//
// The ODR-shaped question "are these two declarations the same declaration written twice?",
// answerable ACROSS two ASTContexts. That is what makes it the conflict check to run before
// an ASTImporter import, and the dedup check for a header parsed twice into two contexts.
//
// The C++ constructor takes its NonEquivalentDecls cache by reference and does not own it,
// so the handle below is not a bare StructuralEquivalenceContext: the shim boxes the
// context together with the DenseSet it borrows, and the two are created and destroyed as
// one. That set's element type is an implementation detail of the pinned LLVM (a
// std::pair<Decl*, Decl*> here, changed after 18) and stays inside lib/AST/
// CXASTStructuralEquivalence.cpp.
//
// Caller-owned: release with clang_StructuralEquivalenceContext_dispose. The context caches
// across calls -- a pair once found non-equivalent stays non-equivalent -- so reuse one for
// a batch of related questions and build a fresh one when the ASTs have changed underneath.

// StrictTypeSpelling demands the two types be spelled the same way and not merely mean the
// same thing; Complain routes each mismatch through the diagnostics of the context it was
// found in; ErrorOnTagTypeMismatch turns a struct-vs-class mismatch from a warning into an
// error; IgnoreTemplateParmDepth lets two template parameters at different depths match.
CXStructuralEquivalenceContext clang_StructuralEquivalenceContext_create(
    CXASTContext FromCtx, CXASTContext ToCtx, CXStructuralEquivalenceKind EqKind,
    bool StrictTypeSpelling, bool Complain, bool ErrorOnTagTypeMismatch,
    bool IgnoreTemplateParmDepth);

void clang_StructuralEquivalenceContext_dispose(CXStructuralEquivalenceContext Ctx);

// helper — the two contexts the comparison runs between, read back from the public members
// clang exposes as fields rather than accessors. BORROWED.
CXASTContext clang_StructuralEquivalenceContext_getFromCtx(CXStructuralEquivalenceContext Ctx);

CXASTContext clang_StructuralEquivalenceContext_getToCtx(CXStructuralEquivalenceContext Ctx);

// Diag1
// Diag2

// Whether the two declarations are structurally equivalent. D1 must come from the "from"
// context and D2 from the "to" context; the same context twice is legal and is how a header
// parsed twice into one context is deduplicated.
bool clang_StructuralEquivalenceContext_IsEquivalentDecl(
    CXStructuralEquivalenceContext Ctx, CXDecl D1, CXDecl D2);

bool clang_StructuralEquivalenceContext_IsEquivalentQualType(
    CXStructuralEquivalenceContext Ctx, CXQualType T1, CXQualType T2);

bool clang_StructuralEquivalenceContext_IsEquivalentStmt(CXStructuralEquivalenceContext Ctx,
                                                         CXStmt S1, CXStmt S2);

// The index of the anonymous struct or union Anon within its context. HasIndex is an
// out-parameter and must not be NULL; it comes back false when Anon is not inside a record,
// which is what clang's empty std::optional means (MARSHALLING.md §8). Static — no
// receiver.
unsigned clang_StructuralEquivalenceContext_findUntaggedStructOrUnionIndex(
    CXRecordDecl Anon, bool *HasIndex);

// getApplicableDiagnostic

LLVM_CLANG_C_EXTERN_C_END

#endif
