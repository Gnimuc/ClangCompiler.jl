#include "clang-ex/AST/CXNestedNameSpecifier.h"
#include "utils.h"
#include "clang/AST/NestedNameSpecifier.h"
#include "clang/AST/PrettyPrinter.h"
#include "clang/Basic/LangOptions.h"
#include "llvm/Support/raw_ostream.h"

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

CXString clang_NestedNameSpecifier_getName(CXNestedNameSpecifier NNS) {
  std::string Str;
  llvm::raw_string_ostream OS(Str);
  clang::LangOptions LO;
  clang::PrintingPolicy Policy(LO);
  static_cast<clang::NestedNameSpecifier *>(NNS)->print(OS, Policy);
  return extra::makeCXString(Str);
}