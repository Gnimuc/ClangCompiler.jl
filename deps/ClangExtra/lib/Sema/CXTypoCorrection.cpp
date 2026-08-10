#include "clang-ex/Sema/CXTypoCorrection.h"
#include "utils.h"

#include "clang/AST/DeclarationName.h"
#include "clang/Basic/LangOptions.h"
#include "clang/Sema/DeclSpec.h"
#include "clang/Sema/Sema.h"
#include "clang/Sema/TypoCorrection.h"

#include <memory>

CXCorrectionCandidateCallback
clang_CorrectionCandidateCallback_create(CXCorrectionCandidateCallbackKind Kind, CXSema S,
                                         unsigned NumArgs, bool HasExplicitTemplateArgs) {
  std::unique_ptr<clang::CorrectionCandidateCallback> CCC;
  switch (Kind) {
  case CXCorrectionCandidateCallbackKind_Decl:
    CCC = std::make_unique<clang::DeclFilterCCC<clang::NamedDecl>>();
    break;
  case CXCorrectionCandidateCallbackKind_FunctionCall:
    CCC = std::make_unique<clang::FunctionCallFilterCCC>(*reinterpret_cast<clang::Sema *>(S),
                                                         NumArgs, HasExplicitTemplateArgs);
    break;
  case CXCorrectionCandidateCallbackKind_Default:
  default:
    CCC = std::make_unique<clang::DefaultFilterCCC>();
    break;
  }
  return reinterpret_cast<CXCorrectionCandidateCallback>(CCC.release());
}

void clang_CorrectionCandidateCallback_dispose(CXCorrectionCandidateCallback CCC) {
  delete reinterpret_cast<clang::CorrectionCandidateCallback *>(CCC);
}

CXTypoCorrection clang_Sema_CorrectTypo(CXSema S, CXDeclarationNameInfo Typo,
                                        CXLookupNameKind LookupKind, CXScope Scp,
                                        CXCXXScopeSpec SS,
                                        CXCorrectionCandidateCallback CCC,
                                        CXCorrectTypoKind Mode, CXDeclContext MemberContext,
                                        bool EnteringContext, bool RecordFailure) {
  clang::TypoCorrection TC = reinterpret_cast<clang::Sema *>(S)->CorrectTypo(
      *reinterpret_cast<clang::DeclarationNameInfo *>(Typo),
      static_cast<clang::Sema::LookupNameKind>(LookupKind),
      reinterpret_cast<clang::Scope *>(Scp), reinterpret_cast<clang::CXXScopeSpec *>(SS),
      *reinterpret_cast<clang::CorrectionCandidateCallback *>(CCC),
      static_cast<clang::Sema::CorrectTypoKind>(Mode),
      reinterpret_cast<clang::DeclContext *>(MemberContext), EnteringContext,
      /*OPT=*/nullptr, RecordFailure);
  return reinterpret_cast<CXTypoCorrection>(
      std::make_unique<clang::TypoCorrection>(std::move(TC)).release());
}

void clang_TypoCorrection_dispose(CXTypoCorrection TC) {
  delete reinterpret_cast<clang::TypoCorrection *>(TC);
}

bool clang_TypoCorrection_isEmpty(CXTypoCorrection TC) {
  return !static_cast<bool>(*reinterpret_cast<clang::TypoCorrection *>(TC));
}

bool clang_TypoCorrection_isResolved(CXTypoCorrection TC) {
  return reinterpret_cast<clang::TypoCorrection *>(TC)->isResolved();
}

bool clang_TypoCorrection_isOverloaded(CXTypoCorrection TC) {
  return reinterpret_cast<clang::TypoCorrection *>(TC)->isOverloaded();
}

CXDeclarationName clang_TypoCorrection_getCorrection(CXTypoCorrection TC) {
  return reinterpret_cast<CXDeclarationName>(
      reinterpret_cast<clang::TypoCorrection *>(TC)->getCorrection().getAsOpaquePtr());
}

CXString clang_TypoCorrection_getAsString(CXTypoCorrection TC, CXLangOptions LO) {
  return extra::makeCXString(reinterpret_cast<clang::TypoCorrection *>(TC)->getAsString(
      *reinterpret_cast<clang::LangOptions *>(LO)));
}

unsigned clang_TypoCorrection_getEditDistance(CXTypoCorrection TC, bool Normalized) {
  return reinterpret_cast<clang::TypoCorrection *>(TC)->getEditDistance(Normalized);
}

CXNamedDecl clang_TypoCorrection_getCorrectionDecl(CXTypoCorrection TC) {
  return reinterpret_cast<CXNamedDecl>(
      reinterpret_cast<clang::TypoCorrection *>(TC)->getCorrectionDecl());
}

bool clang_TypoCorrection_isKeyword(CXTypoCorrection TC) {
  return reinterpret_cast<clang::TypoCorrection *>(TC)->isKeyword();
}
