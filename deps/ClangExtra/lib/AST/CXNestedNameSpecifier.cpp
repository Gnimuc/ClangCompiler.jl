#include "clang-ex/AST/CXNestedNameSpecifier.h"
#include "utils.h"
#include "clang/AST/NestedNameSpecifier.h"
#include "clang/AST/PrettyPrinter.h"
#include "clang/Basic/LangOptions.h"
#include "llvm/Support/raw_ostream.h"

CXNestedNameSpecifier clang_NestedNameSpecifier_getPrefix(CXNestedNameSpecifier NNS) {
  return static_cast<clang::NestedNameSpecifier *>(NNS)->getPrefix();
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