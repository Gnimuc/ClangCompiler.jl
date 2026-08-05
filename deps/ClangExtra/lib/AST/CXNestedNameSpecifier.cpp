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
  return reinterpret_cast<CXNestedNameSpecifier>(reinterpret_cast<clang::NestedNameSpecifier *>(NNS)->getPrefix());
}

CXNestedNameSpecifierKind clang_NestedNameSpecifier_getKind(CXNestedNameSpecifier NNS) {
  return static_cast<CXNestedNameSpecifierKind>(
      reinterpret_cast<clang::NestedNameSpecifier *>(NNS)->getKind());
}

CXIdentifierInfo clang_NestedNameSpecifier_getAsIdentifier(CXNestedNameSpecifier NNS) {
  return reinterpret_cast<CXIdentifierInfo>(reinterpret_cast<clang::NestedNameSpecifier *>(NNS)->getAsIdentifier());
}

CXNamespaceDecl clang_NestedNameSpecifier_getAsNamespace(CXNestedNameSpecifier NNS) {
  return reinterpret_cast<CXNamespaceDecl>(reinterpret_cast<clang::NestedNameSpecifier *>(NNS)->getAsNamespace());
}

CXNamespaceAliasDecl clang_NestedNameSpecifier_getAsNamespaceAlias(CXNestedNameSpecifier NNS) {
  return reinterpret_cast<CXNamespaceAliasDecl>(reinterpret_cast<clang::NestedNameSpecifier *>(NNS)->getAsNamespaceAlias());
}

CXCXXRecordDecl clang_NestedNameSpecifier_getAsRecordDecl(CXNestedNameSpecifier NNS) {
  return reinterpret_cast<CXCXXRecordDecl>(reinterpret_cast<clang::NestedNameSpecifier *>(NNS)->getAsRecordDecl());
}

CXType_ clang_NestedNameSpecifier_getAsType(CXNestedNameSpecifier NNS) {
  return reinterpret_cast<CXType_>(const_cast<clang::Type *>(
      reinterpret_cast<clang::NestedNameSpecifier *>(NNS)->getAsType()));
}

bool clang_NestedNameSpecifier_isDependent(CXNestedNameSpecifier NNS) {
  return reinterpret_cast<clang::NestedNameSpecifier *>(NNS)->isDependent();
}

bool clang_NestedNameSpecifier_isInstantiationDependent(CXNestedNameSpecifier NNS) {
  return reinterpret_cast<clang::NestedNameSpecifier *>(NNS)->isInstantiationDependent();
}

bool clang_NestedNameSpecifier_containsUnexpandedParameterPack(CXNestedNameSpecifier NNS) {
  return reinterpret_cast<clang::NestedNameSpecifier *>(NNS)->containsUnexpandedParameterPack();
}

bool clang_NestedNameSpecifier_containsErrors(CXNestedNameSpecifier NNS) {
  return reinterpret_cast<clang::NestedNameSpecifier *>(NNS)->containsErrors();
}

void clang_NestedNameSpecifier_dump(CXNestedNameSpecifier NNS) {
  reinterpret_cast<clang::NestedNameSpecifier *>(NNS)->dump();
}

CXNestedNameSpecifier clang_NestedNameSpecifier_Create(CXASTContext Ctx,
                                                       CXNestedNameSpecifier Prefix,
                                                       CXIdentifierInfo II) {
  return reinterpret_cast<CXNestedNameSpecifier>(clang::NestedNameSpecifier::Create(
      *reinterpret_cast<clang::ASTContext *>(Ctx),
      reinterpret_cast<clang::NestedNameSpecifier *>(Prefix),
      reinterpret_cast<clang::IdentifierInfo *>(II)));
}

CXNestedNameSpecifier clang_NestedNameSpecifier_GlobalSpecifier(CXASTContext Ctx) {
  return reinterpret_cast<CXNestedNameSpecifier>(clang::NestedNameSpecifier::GlobalSpecifier(
      *reinterpret_cast<clang::ASTContext *>(Ctx)));
}

CXNestedNameSpecifier clang_NestedNameSpecifier_SuperSpecifier(CXASTContext Ctx,
                                                               CXCXXRecordDecl RD) {
  return reinterpret_cast<CXNestedNameSpecifier>(clang::NestedNameSpecifier::SuperSpecifier(
      *reinterpret_cast<clang::ASTContext *>(Ctx), reinterpret_cast<clang::CXXRecordDecl *>(RD)));
}

CXString clang_NestedNameSpecifier_getName(CXNestedNameSpecifier NNS) {
  std::string Str;
  llvm::raw_string_ostream OS(Str);
  clang::LangOptions LO;
  clang::PrintingPolicy Policy(LO);
  reinterpret_cast<clang::NestedNameSpecifier *>(NNS)->print(OS, Policy);
  return extra::makeCXString(Str);
}
// NestedNameSpecifierLoc
bool clang_NestedNameSpecifierLoc_hasQualifier(CXNestedNameSpecifierLoc NNSL) {
  auto *L = reinterpret_cast<clang::NestedNameSpecifierLoc *>(NNSL);
  return L->hasQualifier();
}

CXNestedNameSpecifier
clang_NestedNameSpecifierLoc_getNestedNameSpecifier(CXNestedNameSpecifierLoc NNSL) {
  auto *L = reinterpret_cast<clang::NestedNameSpecifierLoc *>(NNSL);
  return reinterpret_cast<CXNestedNameSpecifier>(L->getNestedNameSpecifier());
}

CXSourceRange_ clang_NestedNameSpecifierLoc_getSourceRange(CXNestedNameSpecifierLoc NNSL) {
  auto *L = reinterpret_cast<clang::NestedNameSpecifierLoc *>(NNSL);
  clang::SourceRange R = L->getSourceRange();
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

CXSourceRange_
clang_NestedNameSpecifierLoc_getLocalSourceRange(CXNestedNameSpecifierLoc NNSL) {
  auto *L = reinterpret_cast<clang::NestedNameSpecifierLoc *>(NNSL);
  clang::SourceRange R = L->getLocalSourceRange();
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

CXSourceLocation_ clang_NestedNameSpecifierLoc_getBeginLoc(CXNestedNameSpecifierLoc NNSL) {
  auto *L = reinterpret_cast<clang::NestedNameSpecifierLoc *>(NNSL);
  return reinterpret_cast<CXSourceLocation_>(L->getBeginLoc().getPtrEncoding());
}

CXSourceLocation_ clang_NestedNameSpecifierLoc_getEndLoc(CXNestedNameSpecifierLoc NNSL) {
  auto *L = reinterpret_cast<clang::NestedNameSpecifierLoc *>(NNSL);
  return reinterpret_cast<CXSourceLocation_>(L->getEndLoc().getPtrEncoding());
}

CXSourceLocation_
clang_NestedNameSpecifierLoc_getLocalBeginLoc(CXNestedNameSpecifierLoc NNSL) {
  auto *L = reinterpret_cast<clang::NestedNameSpecifierLoc *>(NNSL);
  return reinterpret_cast<CXSourceLocation_>(L->getLocalBeginLoc().getPtrEncoding());
}

CXSourceLocation_
clang_NestedNameSpecifierLoc_getLocalEndLoc(CXNestedNameSpecifierLoc NNSL) {
  auto *L = reinterpret_cast<clang::NestedNameSpecifierLoc *>(NNSL);
  return reinterpret_cast<CXSourceLocation_>(L->getLocalEndLoc().getPtrEncoding());
}

CXNestedNameSpecifierLoc
clang_NestedNameSpecifierLoc_getPrefix(CXNestedNameSpecifierLoc NNSL) {
  auto *L = reinterpret_cast<clang::NestedNameSpecifierLoc *>(NNSL);
  return reinterpret_cast<CXNestedNameSpecifierLoc>(new clang::NestedNameSpecifierLoc(L->getPrefix())); // NOLINT(*-owning-memory)
}

CXTypeLoc clang_NestedNameSpecifierLoc_getTypeLoc(CXNestedNameSpecifierLoc NNSL) {
  auto *L = reinterpret_cast<clang::NestedNameSpecifierLoc *>(NNSL);
  return reinterpret_cast<CXTypeLoc>(new clang::TypeLoc(L->getTypeLoc())); // NOLINT(*-owning-memory)
}

void clang_NestedNameSpecifierLoc_dispose(CXNestedNameSpecifierLoc NNSL) {
  delete reinterpret_cast<clang::NestedNameSpecifierLoc *>(NNSL); // NOLINT(*-owning-memory)
}
