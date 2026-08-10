#include "clang-ex/Sema/CXInitialization.h"

#include "clang/AST/ASTContext.h"
#include "clang/AST/Decl.h"
#include "clang/Sema/Initialization.h"
#include "clang/Sema/Sema.h"

#include <memory>

namespace {

clang::MultiExprArg exprArgs(CXExpr *Args, unsigned NumArgs) {
  return clang::MultiExprArg(reinterpret_cast<clang::Expr **>(Args), NumArgs);
}

CXInitializedEntity boxEntity(clang::InitializedEntity E) {
  return reinterpret_cast<CXInitializedEntity>(
      std::make_unique<clang::InitializedEntity>(std::move(E)).release());
}

CXInitializationKind boxKind(clang::InitializationKind K) {
  return reinterpret_cast<CXInitializationKind>(
      std::make_unique<clang::InitializationKind>(std::move(K)).release());
}

} // namespace

// InitializedEntity

CXInitializedEntity clang_InitializedEntity_InitializeVariable(CXVarDecl Var) {
  return boxEntity(clang::InitializedEntity::InitializeVariable(
      reinterpret_cast<clang::VarDecl *>(Var)));
}

CXInitializedEntity clang_InitializedEntity_InitializeParameter(CXASTContext Ctx,
                                                                CXParmVarDecl Parm) {
  return boxEntity(clang::InitializedEntity::InitializeParameter(
      *reinterpret_cast<clang::ASTContext *>(Ctx),
      reinterpret_cast<clang::ParmVarDecl *>(Parm)));
}

CXInitializedEntity
clang_InitializedEntity_InitializeParameterWithType(CXASTContext Ctx, CXQualType Type,
                                                    bool Consumed) {
  return boxEntity(clang::InitializedEntity::InitializeParameter(
      *reinterpret_cast<clang::ASTContext *>(Ctx), clang::QualType::getFromOpaquePtr(Type),
      Consumed));
}

CXInitializedEntity clang_InitializedEntity_InitializeResult(CXSourceLocation_ ReturnLoc,
                                                             CXQualType Type) {
  return boxEntity(clang::InitializedEntity::InitializeResult(
      clang::SourceLocation::getFromPtrEncoding(ReturnLoc),
      clang::QualType::getFromOpaquePtr(Type)));
}

CXInitializedEntity clang_InitializedEntity_InitializeTemporary(CXQualType Type) {
  return boxEntity(
      clang::InitializedEntity::InitializeTemporary(clang::QualType::getFromOpaquePtr(Type)));
}

void clang_InitializedEntity_dispose(CXInitializedEntity Entity) {
  delete reinterpret_cast<clang::InitializedEntity *>(Entity);
}

CXQualType clang_InitializedEntity_getType(CXInitializedEntity Entity) {
  return reinterpret_cast<CXQualType>(
      reinterpret_cast<clang::InitializedEntity *>(Entity)->getType().getAsOpaquePtr());
}

// InitializationKind

CXInitializationKind clang_InitializationKind_CreateDirect(CXSourceLocation_ InitLoc,
                                                           CXSourceLocation_ LParenLoc,
                                                           CXSourceLocation_ RParenLoc) {
  return boxKind(clang::InitializationKind::CreateDirect(
      clang::SourceLocation::getFromPtrEncoding(InitLoc),
      clang::SourceLocation::getFromPtrEncoding(LParenLoc),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc)));
}

CXInitializationKind clang_InitializationKind_CreateDirectList(CXSourceLocation_ InitLoc) {
  return boxKind(clang::InitializationKind::CreateDirectList(
      clang::SourceLocation::getFromPtrEncoding(InitLoc)));
}

CXInitializationKind clang_InitializationKind_CreateCopy(CXSourceLocation_ InitLoc,
                                                         CXSourceLocation_ EqualLoc,
                                                         bool AllowExplicitConvs) {
  return boxKind(clang::InitializationKind::CreateCopy(
      clang::SourceLocation::getFromPtrEncoding(InitLoc),
      clang::SourceLocation::getFromPtrEncoding(EqualLoc), AllowExplicitConvs));
}

CXInitializationKind clang_InitializationKind_CreateDefault(CXSourceLocation_ InitLoc) {
  return boxKind(clang::InitializationKind::CreateDefault(
      clang::SourceLocation::getFromPtrEncoding(InitLoc)));
}

CXInitializationKind clang_InitializationKind_CreateValue(CXSourceLocation_ InitLoc,
                                                          CXSourceLocation_ LParenLoc,
                                                          CXSourceLocation_ RParenLoc,
                                                          bool IsImplicit) {
  return boxKind(clang::InitializationKind::CreateValue(
      clang::SourceLocation::getFromPtrEncoding(InitLoc),
      clang::SourceLocation::getFromPtrEncoding(LParenLoc),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc), IsImplicit));
}

void clang_InitializationKind_dispose(CXInitializationKind Kind) {
  delete reinterpret_cast<clang::InitializationKind *>(Kind);
}

// InitializationSequence

CXInitializationSequence
clang_InitializationSequence_create(CXSema S, CXInitializedEntity Entity,
                                    CXInitializationKind Kind, CXExpr *Args, unsigned NumArgs,
                                    bool TopLevelOfInitList,
                                    bool TreatUnavailableAsInvalid) {
  return reinterpret_cast<CXInitializationSequence>(
      std::make_unique<clang::InitializationSequence>(
          *reinterpret_cast<clang::Sema *>(S),
          *reinterpret_cast<clang::InitializedEntity *>(Entity),
          *reinterpret_cast<clang::InitializationKind *>(Kind), exprArgs(Args, NumArgs),
          TopLevelOfInitList, TreatUnavailableAsInvalid)
          .release());
}

void clang_InitializationSequence_dispose(CXInitializationSequence Seq) {
  delete reinterpret_cast<clang::InitializationSequence *>(Seq);
}

bool clang_InitializationSequence_Failed(CXInitializationSequence Seq) {
  return reinterpret_cast<clang::InitializationSequence *>(Seq)->Failed();
}

unsigned clang_InitializationSequence_getFailureKind(CXInitializationSequence Seq) {
  return static_cast<unsigned>(
      reinterpret_cast<clang::InitializationSequence *>(Seq)->getFailureKind());
}

unsigned clang_InitializationSequence_getKind(CXInitializationSequence Seq) {
  return static_cast<unsigned>(
      reinterpret_cast<clang::InitializationSequence *>(Seq)->getKind());
}

CXExpr clang_InitializationSequence_Perform(CXInitializationSequence Seq, CXSema S,
                                            CXInitializedEntity Entity,
                                            CXInitializationKind Kind, CXExpr *Args,
                                            unsigned NumArgs, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::InitializationSequence *>(Seq)->Perform(
      *reinterpret_cast<clang::Sema *>(S),
      *reinterpret_cast<clang::InitializedEntity *>(Entity),
      *reinterpret_cast<clang::InitializationKind *>(Kind), exprArgs(Args, NumArgs));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

bool clang_InitializationSequence_Diagnose(CXInitializationSequence Seq, CXSema S,
                                           CXInitializedEntity Entity,
                                           CXInitializationKind Kind, CXExpr *Args,
                                           unsigned NumArgs) {
  return reinterpret_cast<clang::InitializationSequence *>(Seq)->Diagnose(
      *reinterpret_cast<clang::Sema *>(S),
      *reinterpret_cast<clang::InitializedEntity *>(Entity),
      *reinterpret_cast<clang::InitializationKind *>(Kind), exprArgs(Args, NumArgs));
}

// Sema one-shots

bool clang_Sema_CanPerformCopyInitialization(CXSema S, CXInitializedEntity Entity,
                                             CXExpr Init) {
  return reinterpret_cast<clang::Sema *>(S)->CanPerformCopyInitialization(
      *reinterpret_cast<clang::InitializedEntity *>(Entity),
      clang::ExprResult(reinterpret_cast<clang::Expr *>(Init)));
}

CXExpr clang_Sema_PerformCopyInitialization(CXSema S, CXInitializedEntity Entity,
                                            CXSourceLocation_ EqualLoc, CXExpr Init,
                                            bool TopLevelOfInitList, bool AllowExplicit,
                                            bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->PerformCopyInitialization(
      *reinterpret_cast<clang::InitializedEntity *>(Entity),
      clang::SourceLocation::getFromPtrEncoding(EqualLoc),
      clang::ExprResult(reinterpret_cast<clang::Expr *>(Init)), TopLevelOfInitList,
      AllowExplicit);
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}
