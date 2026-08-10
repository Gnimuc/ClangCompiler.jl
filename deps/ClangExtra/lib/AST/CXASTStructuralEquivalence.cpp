#include "clang-ex/AST/CXASTStructuralEquivalence.h"

#include "clang/AST/ASTContext.h"
#include "clang/AST/ASTStructuralEquivalence.h"
#include "clang/AST/Decl.h"
#include "clang/AST/DeclBase.h"
#include "clang/AST/Stmt.h"
#include "clang/AST/Type.h"
#include "llvm/ADT/DenseSet.h"

#include <memory>
#include <optional>
#include <utility>

namespace {

// StructuralEquivalenceContext borrows its NonEquivalentDecls cache by reference and does
// not own it, so a bare `new StructuralEquivalenceContext(...)` would dangle the moment the
// factory returned. The box owns both and keeps the set's element type -- which changed
// after LLVM 18 -- inside this translation unit. Declaration order is load-bearing: the set
// is a member initialised before the context that binds to it.
struct StructuralEquivalenceBox {
  llvm::DenseSet<std::pair<clang::Decl *, clang::Decl *>> NonEquivalentDecls;
  clang::StructuralEquivalenceContext Context;

  StructuralEquivalenceBox(clang::ASTContext &FromCtx, clang::ASTContext &ToCtx,
                           clang::StructuralEquivalenceKind EqKind,
                           bool StrictTypeSpelling, bool Complain,
                           bool ErrorOnTagTypeMismatch, bool IgnoreTemplateParmDepth)
      : NonEquivalentDecls(),
        Context(FromCtx, ToCtx, NonEquivalentDecls, EqKind, StrictTypeSpelling, Complain,
                ErrorOnTagTypeMismatch, IgnoreTemplateParmDepth) {}
};

StructuralEquivalenceBox *box(CXStructuralEquivalenceContext Ctx) {
  return reinterpret_cast<StructuralEquivalenceBox *>(Ctx);
}

} // namespace

// StructuralEquivalenceContext
CXStructuralEquivalenceContext clang_StructuralEquivalenceContext_create(
    CXASTContext FromCtx, CXASTContext ToCtx, CXStructuralEquivalenceKind EqKind,
    bool StrictTypeSpelling, bool Complain, bool ErrorOnTagTypeMismatch,
    bool IgnoreTemplateParmDepth) {
  return reinterpret_cast<CXStructuralEquivalenceContext>(
      std::make_unique<StructuralEquivalenceBox>(
          *reinterpret_cast<clang::ASTContext *>(FromCtx),
          *reinterpret_cast<clang::ASTContext *>(ToCtx),
          static_cast<clang::StructuralEquivalenceKind>(EqKind), StrictTypeSpelling,
          Complain, ErrorOnTagTypeMismatch, IgnoreTemplateParmDepth)
          .release());
}

void clang_StructuralEquivalenceContext_dispose(CXStructuralEquivalenceContext Ctx) {
  delete box(Ctx); // NOLINT(*-owning-memory)
}

CXASTContext
clang_StructuralEquivalenceContext_getFromCtx(CXStructuralEquivalenceContext Ctx) {
  return reinterpret_cast<CXASTContext>(&box(Ctx)->Context.FromCtx);
}

CXASTContext
clang_StructuralEquivalenceContext_getToCtx(CXStructuralEquivalenceContext Ctx) {
  return reinterpret_cast<CXASTContext>(&box(Ctx)->Context.ToCtx);
}

// Diag1
// Diag2

bool clang_StructuralEquivalenceContext_IsEquivalentDecl(
    CXStructuralEquivalenceContext Ctx, CXDecl D1, CXDecl D2) {
  return box(Ctx)->Context.IsEquivalent(reinterpret_cast<clang::Decl *>(D1),
                                        reinterpret_cast<clang::Decl *>(D2));
}

bool clang_StructuralEquivalenceContext_IsEquivalentQualType(
    CXStructuralEquivalenceContext Ctx, CXQualType T1, CXQualType T2) {
  return box(Ctx)->Context.IsEquivalent(clang::QualType::getFromOpaquePtr(T1),
                                        clang::QualType::getFromOpaquePtr(T2));
}

bool clang_StructuralEquivalenceContext_IsEquivalentStmt(CXStructuralEquivalenceContext Ctx,
                                                         CXStmt S1, CXStmt S2) {
  return box(Ctx)->Context.IsEquivalent(reinterpret_cast<clang::Stmt *>(S1),
                                        reinterpret_cast<clang::Stmt *>(S2));
}

unsigned clang_StructuralEquivalenceContext_findUntaggedStructOrUnionIndex(
    CXRecordDecl Anon, bool *HasIndex) {
  std::optional<unsigned> Index =
      clang::StructuralEquivalenceContext::findUntaggedStructOrUnionIndex(
          reinterpret_cast<clang::RecordDecl *>(Anon));
  *HasIndex = Index.has_value();
  return Index.value_or(0U);
}

// getApplicableDiagnostic
