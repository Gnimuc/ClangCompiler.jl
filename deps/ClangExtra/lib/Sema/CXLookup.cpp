#include "clang-ex/Sema/CXLookup.h"
#include "clang/Sema/Lookup.h"
#include <iterator>

CXLookupResult clang_LookupResult_create(CXSema S, CXDeclarationName Name,
                                         CXSourceLocation_ NameLoc,
                                         CXLookupNameKind LookupKind) {
  auto LR = std::make_unique<clang::LookupResult>(
      *static_cast<clang::Sema *>(S), clang::DeclarationName::getFromOpaquePtr(Name),
      clang::SourceLocation::getFromPtrEncoding(NameLoc),
      static_cast<clang::Sema::LookupNameKind>(LookupKind));
  return LR.release();
}

void clang_LookupResult_dispose(CXLookupResult LR) {
  delete static_cast<clang::LookupResult *>(LR);
}

bool clang_LookupResult_isForRedeclaration(CXLookupResult LR) {
  return static_cast<clang::LookupResult *>(LR)->isForRedeclaration();
}

bool clang_LookupResult_isTemplateNameLookup(CXLookupResult LR) {
  return static_cast<clang::LookupResult *>(LR)->isTemplateNameLookup();
}

bool clang_LookupResult_isAmbiguous(CXLookupResult LR) {
  return static_cast<clang::LookupResult *>(LR)->isAmbiguous();
}

bool clang_LookupResult_isSingleResult(CXLookupResult LR) {
  return static_cast<clang::LookupResult *>(LR)->isSingleResult();
}

bool clang_LookupResult_isOverloadedResult(CXLookupResult LR) {
  return static_cast<clang::LookupResult *>(LR)->isOverloadedResult();
}

bool clang_LookupResult_isUnresolvableResult(CXLookupResult LR) {
  return static_cast<clang::LookupResult *>(LR)->isUnresolvableResult();
}

bool clang_LookupResult_isClassLookup(CXLookupResult LR) {
  return static_cast<clang::LookupResult *>(LR)->isClassLookup();
}

void clang_LookupResult_resolveKind(CXLookupResult LR) {
  static_cast<clang::LookupResult *>(LR)->resolveKind();
}

bool clang_LookupResult_isSingleTagDecl(CXLookupResult LR) {
  return static_cast<clang::LookupResult *>(LR)->isSingleTagDecl();
}

void clang_LookupResult_clear(CXLookupResult LR, CXLookupNameKind LookupKind) {
  static_cast<clang::LookupResult *>(LR)->clear(
      static_cast<clang::Sema::LookupNameKind>(LookupKind));
}

void clang_LookupResult_dump(CXLookupResult LR) {
  static_cast<clang::LookupResult *>(LR)->dump();
}

bool clang_LookupResult_empty(CXLookupResult LR) {
  return static_cast<clang::LookupResult *>(LR)->empty();
}

CXNamedDecl clang_LookupResult_getRepresentativeDecl(CXLookupResult LR) {
  return static_cast<clang::LookupResult *>(LR)->getRepresentativeDecl();
}

void clang_LookupResult_setLookupName(CXLookupResult LR, CXDeclarationName DN) {
  static_cast<clang::LookupResult *>(LR)->setLookupName(
      clang::DeclarationName::getFromOpaquePtr(DN));
}

CXDeclarationName clang_LookupResult_getLookupName(CXLookupResult LR) {
  return static_cast<clang::LookupResult *>(LR)->getLookupName().getAsOpaquePtr();
}

size_t clang_LookupResult_getNum(CXLookupResult LR) {
  auto *R = static_cast<clang::LookupResult *>(LR);
  return std::distance(R->begin(), R->end());
}

void clang_LookupResult_getResults(CXLookupResult LR, CXNamedDecl *Decls, size_t N) {
  auto *R = static_cast<clang::LookupResult *>(LR);
  auto It = R->begin();
  for (size_t I = 0; I < N; ++I, ++It)
    Decls[I] = (*It)->getUnderlyingDecl();
}

CXNamedDecl clang_LookupResult_getResult(CXLookupResult LR) {
  auto It = static_cast<clang::LookupResult *>(LR)->begin();
  return (*It)->getUnderlyingDecl();
}
