#include "clang-ex/AST/CXNestedNameSpecifier.h"
#include "utils.h"
#include "clang/AST/NestedNameSpecifier.h"
#include "clang/AST/PrettyPrinter.h"
#include "clang/Basic/LangOptions.h"
#include "llvm/Support/raw_ostream.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/DeclCXX.h"
#include "clang/AST/TypeLoc.h"

CXNestedNameSpecifier clang_NestedNameSpecifier_getPrefix(CXNestedNameSpecifier NNS) {
  return static_cast<clang::NestedNameSpecifier *>(NNS)->getPrefix();
}

CXNestedNameSpecifierKind clang_NestedNameSpecifier_getKind(CXNestedNameSpecifier NNS) {
  return static_cast<CXNestedNameSpecifierKind>(
      static_cast<clang::NestedNameSpecifier *>(NNS)->getKind());
}

CXIdentifierInfo clang_NestedNameSpecifier_getAsIdentifier(CXNestedNameSpecifier NNS) {
  return static_cast<clang::NestedNameSpecifier *>(NNS)->getAsIdentifier();
}

CXNamespaceDecl clang_NestedNameSpecifier_getAsNamespace(CXNestedNameSpecifier NNS) {
  return static_cast<clang::NestedNameSpecifier *>(NNS)->getAsNamespace();
}

CXNamespaceAliasDecl clang_NestedNameSpecifier_getAsNamespaceAlias(CXNestedNameSpecifier NNS) {
  return static_cast<clang::NestedNameSpecifier *>(NNS)->getAsNamespaceAlias();
}

CXCXXRecordDecl clang_NestedNameSpecifier_getAsRecordDecl(CXNestedNameSpecifier NNS) {
  return static_cast<clang::NestedNameSpecifier *>(NNS)->getAsRecordDecl();
}

CXType_ clang_NestedNameSpecifier_getAsType(CXNestedNameSpecifier NNS) {
  return const_cast<clang::Type *>(
      static_cast<clang::NestedNameSpecifier *>(NNS)->getAsType());
}

bool clang_NestedNameSpecifier_isDependent(CXNestedNameSpecifier NNS) {
  return static_cast<clang::NestedNameSpecifier *>(NNS)->isDependent();
}

bool clang_NestedNameSpecifier_isInstantiationDependent(CXNestedNameSpecifier NNS) {
  return static_cast<clang::NestedNameSpecifier *>(NNS)->isInstantiationDependent();
}

bool clang_NestedNameSpecifier_containsUnexpandedParameterPack(CXNestedNameSpecifier NNS) {
  return static_cast<clang::NestedNameSpecifier *>(NNS)->containsUnexpandedParameterPack();
}

bool clang_NestedNameSpecifier_containsErrors(CXNestedNameSpecifier NNS) {
  return static_cast<clang::NestedNameSpecifier *>(NNS)->containsErrors();
}

void clang_NestedNameSpecifier_dump(CXNestedNameSpecifier NNS) {
  static_cast<clang::NestedNameSpecifier *>(NNS)->dump();
}

CXNestedNameSpecifier clang_NestedNameSpecifier_Create(CXASTContext Ctx,
                                                       CXNestedNameSpecifier Prefix,
                                                       CXIdentifierInfo II) {
  return clang::NestedNameSpecifier::Create(
      *static_cast<clang::ASTContext *>(Ctx),
      static_cast<clang::NestedNameSpecifier *>(Prefix),
      static_cast<clang::IdentifierInfo *>(II));
}

CXNestedNameSpecifier clang_NestedNameSpecifier_GlobalSpecifier(CXASTContext Ctx) {
  return clang::NestedNameSpecifier::GlobalSpecifier(
      *static_cast<clang::ASTContext *>(Ctx));
}

CXNestedNameSpecifier clang_NestedNameSpecifier_SuperSpecifier(CXASTContext Ctx,
                                                               CXCXXRecordDecl RD) {
  return clang::NestedNameSpecifier::SuperSpecifier(
      *static_cast<clang::ASTContext *>(Ctx), static_cast<clang::CXXRecordDecl *>(RD));
}

CXString clang_NestedNameSpecifier_getName(CXNestedNameSpecifier NNS) {
  std::string Str;
  llvm::raw_string_ostream OS(Str);
  clang::LangOptions LO;
  clang::PrintingPolicy Policy(LO);
  static_cast<clang::NestedNameSpecifier *>(NNS)->print(OS, Policy);
  return extra::makeCXString(Str);
}
// NestedNameSpecifierLoc
bool clang_NestedNameSpecifierLoc_hasQualifier(CXNestedNameSpecifierLoc NNSL) {
  auto *L = static_cast<clang::NestedNameSpecifierLoc *>(NNSL);
  return L->hasQualifier();
}

CXNestedNameSpecifier
clang_NestedNameSpecifierLoc_getNestedNameSpecifier(CXNestedNameSpecifierLoc NNSL) {
  auto *L = static_cast<clang::NestedNameSpecifierLoc *>(NNSL);
  return L->getNestedNameSpecifier();
}

CXSourceRange_ clang_NestedNameSpecifierLoc_getSourceRange(CXNestedNameSpecifierLoc NNSL) {
  auto *L = static_cast<clang::NestedNameSpecifierLoc *>(NNSL);
  clang::SourceRange R = L->getSourceRange();
  return CXSourceRange_{R.getBegin().getPtrEncoding(), R.getEnd().getPtrEncoding()};
}

CXSourceRange_
clang_NestedNameSpecifierLoc_getLocalSourceRange(CXNestedNameSpecifierLoc NNSL) {
  auto *L = static_cast<clang::NestedNameSpecifierLoc *>(NNSL);
  clang::SourceRange R = L->getLocalSourceRange();
  return CXSourceRange_{R.getBegin().getPtrEncoding(), R.getEnd().getPtrEncoding()};
}

CXSourceLocation_ clang_NestedNameSpecifierLoc_getBeginLoc(CXNestedNameSpecifierLoc NNSL) {
  auto *L = static_cast<clang::NestedNameSpecifierLoc *>(NNSL);
  return L->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_NestedNameSpecifierLoc_getEndLoc(CXNestedNameSpecifierLoc NNSL) {
  auto *L = static_cast<clang::NestedNameSpecifierLoc *>(NNSL);
  return L->getEndLoc().getPtrEncoding();
}

CXSourceLocation_
clang_NestedNameSpecifierLoc_getLocalBeginLoc(CXNestedNameSpecifierLoc NNSL) {
  auto *L = static_cast<clang::NestedNameSpecifierLoc *>(NNSL);
  return L->getLocalBeginLoc().getPtrEncoding();
}

CXSourceLocation_
clang_NestedNameSpecifierLoc_getLocalEndLoc(CXNestedNameSpecifierLoc NNSL) {
  auto *L = static_cast<clang::NestedNameSpecifierLoc *>(NNSL);
  return L->getLocalEndLoc().getPtrEncoding();
}

CXNestedNameSpecifierLoc
clang_NestedNameSpecifierLoc_getPrefix(CXNestedNameSpecifierLoc NNSL) {
  auto *L = static_cast<clang::NestedNameSpecifierLoc *>(NNSL);
  return new clang::NestedNameSpecifierLoc(L->getPrefix()); // NOLINT(*-owning-memory)
}

CXTypeLoc clang_NestedNameSpecifierLoc_getTypeLoc(CXNestedNameSpecifierLoc NNSL) {
  auto *L = static_cast<clang::NestedNameSpecifierLoc *>(NNSL);
  return new clang::TypeLoc(L->getTypeLoc()); // NOLINT(*-owning-memory)
}

void clang_NestedNameSpecifierLoc_dispose(CXNestedNameSpecifierLoc NNSL) {
  delete static_cast<clang::NestedNameSpecifierLoc *>(NNSL); // NOLINT(*-owning-memory)
}
