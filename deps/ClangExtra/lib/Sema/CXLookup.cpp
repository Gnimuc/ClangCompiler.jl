#include "clang-ex/Sema/CXLookup.h"
#include "clang/Sema/Lookup.h"
#include "clang/Sema/Redeclaration.h"
#include <iterator>
#include "clang/AST/DeclCXX.h"
#include <memory>
#include "utils.h"
#include "llvm/Support/raw_ostream.h"

bool clang_LookupResult_isForExternalRedeclaration(CXLookupResult LR) {
  return reinterpret_cast<clang::LookupResult *>(LR)->isForExternalRedeclaration();
}

void clang_LookupResult_setAllowHidden(CXLookupResult LR, bool AH) {
  reinterpret_cast<clang::LookupResult *>(LR)->setAllowHidden(AH);
}

bool clang_LookupResult_isHiddenDeclarationVisible(CXLookupResult LR, CXNamedDecl ND) {
  return reinterpret_cast<clang::LookupResult *>(LR)->isHiddenDeclarationVisible(
      reinterpret_cast<clang::NamedDecl *>(ND));
}

CXQualType clang_LookupResult_getBaseObjectType(CXLookupResult LR) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::LookupResult *>(LR)->getBaseObjectType().getAsOpaquePtr());
}

bool clang_LookupResult_isShadowed(CXLookupResult LR) {
  return reinterpret_cast<clang::LookupResult *>(LR)->isShadowed();
}

bool clang_LookupResult_isSuppressingAccessDiagnostics(CXLookupResult LR) {
  return reinterpret_cast<clang::LookupResult *>(LR)->isSuppressingAccessDiagnostics();
}

bool clang_LookupResult_isSuppressingAmbiguousDiagnostics(CXLookupResult LR) {
  return reinterpret_cast<clang::LookupResult *>(LR)->isSuppressingAmbiguousDiagnostics();
}

CXSourceRange_ clang_LookupResult_getContextRange(CXLookupResult LR) {
  auto Rng = reinterpret_cast<clang::LookupResult *>(LR)->getContextRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(Rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(Rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

CXLookupResultKind clang_LookupResult_getResultKind(CXLookupResult LR) {
  return static_cast<CXLookupResultKind>(
      reinterpret_cast<clang::LookupResult *>(LR)->getResultKind());
}

CXAmbiguityKind clang_LookupResult_getAmbiguityKind(CXLookupResult LR) {
  return static_cast<CXAmbiguityKind>(
      reinterpret_cast<clang::LookupResult *>(LR)->getAmbiguityKind());
}

CXNamedDecl clang_LookupResult_getFoundDecl(CXLookupResult LR) {
  return reinterpret_cast<CXNamedDecl>(reinterpret_cast<clang::LookupResult *>(LR)->getFoundDecl());
}

CXCXXRecordDecl clang_LookupResult_getNamingClass(CXLookupResult LR) {
  return reinterpret_cast<CXCXXRecordDecl>(reinterpret_cast<clang::LookupResult *>(LR)->getNamingClass());
}

CXLookupNameKind clang_LookupResult_getLookupKind(CXLookupResult LR) {
  return static_cast<CXLookupNameKind>(
      reinterpret_cast<clang::LookupResult *>(LR)->getLookupKind());
}

CXSourceLocation_ clang_LookupResult_getNameLoc(CXLookupResult LR) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::LookupResult *>(LR)->getNameLoc().getPtrEncoding());
}

unsigned clang_LookupResult_getIdentifierNamespace(CXLookupResult LR) {
  return reinterpret_cast<clang::LookupResult *>(LR)->getIdentifierNamespace();
}

void clang_LookupResult_suppressDiagnostics(CXLookupResult LR) {
  reinterpret_cast<clang::LookupResult *>(LR)->suppressDiagnostics();
}

CXLookupResult clang_LookupResult_create(CXSema S, CXDeclarationName Name,
                                         CXSourceLocation_ NameLoc,
                                         CXLookupNameKind LookupKind) {
  auto LR = std::make_unique<clang::LookupResult>(
      *reinterpret_cast<clang::Sema *>(S), clang::DeclarationName::getFromOpaquePtr(Name),
      clang::SourceLocation::getFromPtrEncoding(NameLoc),
      static_cast<clang::Sema::LookupNameKind>(LookupKind));
  return reinterpret_cast<CXLookupResult>(LR.release());
}

void clang_LookupResult_dispose(CXLookupResult LR) {
  delete reinterpret_cast<clang::LookupResult *>(LR);
}

bool clang_LookupResult_isForRedeclaration(CXLookupResult LR) {
  return reinterpret_cast<clang::LookupResult *>(LR)->isForRedeclaration();
}

bool clang_LookupResult_isTemplateNameLookup(CXLookupResult LR) {
  return reinterpret_cast<clang::LookupResult *>(LR)->isTemplateNameLookup();
}

bool clang_LookupResult_isAmbiguous(CXLookupResult LR) {
  return reinterpret_cast<clang::LookupResult *>(LR)->isAmbiguous();
}

bool clang_LookupResult_isSingleResult(CXLookupResult LR) {
  return reinterpret_cast<clang::LookupResult *>(LR)->isSingleResult();
}

bool clang_LookupResult_isOverloadedResult(CXLookupResult LR) {
  return reinterpret_cast<clang::LookupResult *>(LR)->isOverloadedResult();
}

bool clang_LookupResult_isUnresolvableResult(CXLookupResult LR) {
  return reinterpret_cast<clang::LookupResult *>(LR)->isUnresolvableResult();
}

bool clang_LookupResult_isClassLookup(CXLookupResult LR) {
  return reinterpret_cast<clang::LookupResult *>(LR)->isClassLookup();
}

void clang_LookupResult_resolveKind(CXLookupResult LR) {
  reinterpret_cast<clang::LookupResult *>(LR)->resolveKind();
}

bool clang_LookupResult_isSingleTagDecl(CXLookupResult LR) {
  return reinterpret_cast<clang::LookupResult *>(LR)->isSingleTagDecl();
}

void clang_LookupResult_clear(CXLookupResult LR, CXLookupNameKind LookupKind) {
  reinterpret_cast<clang::LookupResult *>(LR)->clear(
      static_cast<clang::Sema::LookupNameKind>(LookupKind));
}

void clang_LookupResult_dump(CXLookupResult LR) {
  reinterpret_cast<clang::LookupResult *>(LR)->dump();
}

bool clang_LookupResult_empty(CXLookupResult LR) {
  return reinterpret_cast<clang::LookupResult *>(LR)->empty();
}

CXNamedDecl clang_LookupResult_getRepresentativeDecl(CXLookupResult LR) {
  return reinterpret_cast<CXNamedDecl>(reinterpret_cast<clang::LookupResult *>(LR)->getRepresentativeDecl());
}

void clang_LookupResult_setLookupName(CXLookupResult LR, CXDeclarationName DN) {
  reinterpret_cast<clang::LookupResult *>(LR)->setLookupName(
      clang::DeclarationName::getFromOpaquePtr(DN));
}

CXDeclarationName clang_LookupResult_getLookupName(CXLookupResult LR) {
  return reinterpret_cast<CXDeclarationName>(reinterpret_cast<clang::LookupResult *>(LR)->getLookupName().getAsOpaquePtr());
}

size_t clang_LookupResult_getNum(CXLookupResult LR) {
  auto *R = reinterpret_cast<clang::LookupResult *>(LR);
  return std::distance(R->begin(), R->end());
}

void clang_LookupResult_getResults(CXLookupResult LR, CXNamedDecl *Decls, size_t N) {
  auto *R = reinterpret_cast<clang::LookupResult *>(LR);
  auto It = R->begin();
  for (size_t I = 0; I < N; ++I, ++It)
    Decls[I] = reinterpret_cast<CXNamedDecl>((*It)->getUnderlyingDecl());
}

CXNamedDecl clang_LookupResult_getResult(CXLookupResult LR) {
  auto It = reinterpret_cast<clang::LookupResult *>(LR)->begin();
  return reinterpret_cast<CXNamedDecl>((*It)->getUnderlyingDecl());
}

CXDeclarationNameInfo clang_LookupResult_getLookupNameInfo(CXLookupResult LR) {
  return reinterpret_cast<CXDeclarationNameInfo>(std::make_unique<clang::DeclarationNameInfo>(
             reinterpret_cast<clang::LookupResult *>(LR)->getLookupNameInfo())
      .release());
}

void clang_LookupResult_setLookupNameInfo(CXLookupResult LR,
                                          CXDeclarationNameInfo NameInfo) {
  reinterpret_cast<clang::LookupResult *>(LR)->setLookupNameInfo(
      *reinterpret_cast<clang::DeclarationNameInfo *>(NameInfo));
}

void clang_LookupResult_setNamingClass(CXLookupResult LR, CXCXXRecordDecl Record) {
  reinterpret_cast<clang::LookupResult *>(LR)->setNamingClass(
      reinterpret_cast<clang::CXXRecordDecl *>(Record));
}

void clang_LookupResult_setBaseObjectType(CXLookupResult LR, CXQualType T) {
  reinterpret_cast<clang::LookupResult *>(LR)->setBaseObjectType(
      clang::QualType::getFromOpaquePtr(T));
}

void clang_LookupResult_addDecl(CXLookupResult LR, CXNamedDecl ND) {
  reinterpret_cast<clang::LookupResult *>(LR)->addDecl(reinterpret_cast<clang::NamedDecl *>(ND));
}

void clang_LookupResult_addAllDecls(CXLookupResult LR, CXLookupResult Other) {
  reinterpret_cast<clang::LookupResult *>(LR)->addAllDecls(
      *reinterpret_cast<clang::LookupResult *>(Other));
}

bool clang_LookupResult_wasNotFoundInCurrentInstantiation(CXLookupResult LR) {
  return reinterpret_cast<clang::LookupResult *>(LR)->wasNotFoundInCurrentInstantiation();
}

void clang_LookupResult_setNotFoundInCurrentInstantiation(CXLookupResult LR) {
  reinterpret_cast<clang::LookupResult *>(LR)->setNotFoundInCurrentInstantiation();
}

void clang_LookupResult_setTemplateNameLookup(CXLookupResult LR, bool TemplateName) {
  reinterpret_cast<clang::LookupResult *>(LR)->setTemplateNameLookup(TemplateName);
}

void clang_LookupResult_setShadowed(CXLookupResult LR) {
  reinterpret_cast<clang::LookupResult *>(LR)->setShadowed();
}

void clang_LookupResult_setContextRange(CXLookupResult LR, CXSourceRange_ SR) {
  reinterpret_cast<clang::LookupResult *>(LR)->setContextRange(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(SR.B),
                         clang::SourceLocation::getFromPtrEncoding(SR.E)));
}

void clang_LookupResult_setHideTags(CXLookupResult LR, bool Hide) {
  reinterpret_cast<clang::LookupResult *>(LR)->setHideTags(Hide);
}

bool clang_LookupResult_isAvailableForLookup(CXSema S, CXNamedDecl ND) {
  return clang::LookupResult::isAvailableForLookup(*reinterpret_cast<clang::Sema *>(S),
                                                   reinterpret_cast<clang::NamedDecl *>(ND));
}

CXNamedDecl clang_LookupResult_getAcceptableDecl(CXLookupResult LR, CXNamedDecl ND) {
  return reinterpret_cast<CXNamedDecl>(reinterpret_cast<clang::LookupResult *>(LR)->getAcceptableDecl(
      reinterpret_cast<clang::NamedDecl *>(ND)));
}

void clang_LookupResult_resolveKindAfterFilter(CXLookupResult LR) {
  reinterpret_cast<clang::LookupResult *>(LR)->resolveKindAfterFilter();
}

void clang_LookupResult_setAmbiguousQualifiedTagHiding(CXLookupResult LR) {
  reinterpret_cast<clang::LookupResult *>(LR)->setAmbiguousQualifiedTagHiding();
}

void clang_LookupResult_suppressAccessDiagnostics(CXLookupResult LR) {
  reinterpret_cast<clang::LookupResult *>(LR)->suppressAccessDiagnostics();
}

CXSema clang_LookupResult_getSema(CXLookupResult LR) {
  return reinterpret_cast<CXSema>(&reinterpret_cast<clang::LookupResult *>(LR)->getSema());
}

CXLookupResult_Filter clang_LookupResult_makeFilter(CXLookupResult LR) {
  return reinterpret_cast<CXLookupResult_Filter>(std::make_unique<clang::LookupResult::Filter>(
             reinterpret_cast<clang::LookupResult *>(LR)->makeFilter())
      .release());
}

void clang_LookupResult_Filter_dispose(CXLookupResult_Filter F) {
  delete reinterpret_cast<clang::LookupResult::Filter *>(F);
}

bool clang_LookupResult_Filter_hasNext(CXLookupResult_Filter F) {
  return reinterpret_cast<clang::LookupResult::Filter *>(F)->hasNext();
}

CXNamedDecl clang_LookupResult_Filter_next(CXLookupResult_Filter F) {
  return reinterpret_cast<CXNamedDecl>(reinterpret_cast<clang::LookupResult::Filter *>(F)->next());
}

void clang_LookupResult_Filter_restart(CXLookupResult_Filter F) {
  reinterpret_cast<clang::LookupResult::Filter *>(F)->restart();
}

void clang_LookupResult_Filter_erase(CXLookupResult_Filter F) {
  reinterpret_cast<clang::LookupResult::Filter *>(F)->erase();
}

void clang_LookupResult_Filter_replace(CXLookupResult_Filter F, CXNamedDecl ND) {
  reinterpret_cast<clang::LookupResult::Filter *>(F)->replace(
      reinterpret_cast<clang::NamedDecl *>(ND));
}

void clang_LookupResult_Filter_done(CXLookupResult_Filter F) {
  reinterpret_cast<clang::LookupResult::Filter *>(F)->done();
}

void clang_LookupResult_setFindLocalExtern(CXLookupResult LR, bool FindLocalExtern) {
  reinterpret_cast<clang::LookupResult *>(LR)->setFindLocalExtern(FindLocalExtern);
}

// LookupResult (redeclaration kind and rendering)
CXRedeclarationKind clang_LookupResult_redeclarationKind(CXLookupResult LR) {
  return static_cast<CXRedeclarationKind>(
      reinterpret_cast<clang::LookupResult *>(LR)->redeclarationKind());
}

void clang_LookupResult_setRedeclarationKind(CXLookupResult LR, CXRedeclarationKind RK) {
  reinterpret_cast<clang::LookupResult *>(LR)->setRedeclarationKind(
      static_cast<RedeclarationKind>(RK));
}

CXString clang_LookupResult_printToString(CXLookupResult LR) {
  std::string Str;
  llvm::raw_string_ostream OS(Str);
  reinterpret_cast<clang::LookupResult *>(LR)->print(OS);
  return extra::makeCXString(OS.str());
}
