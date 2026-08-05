#include "clang-ex/AST/CXPrettyPrinter.h"
#include "clang/AST/PrettyPrinter.h"
#include "clang/Basic/LangOptions.h"
#include <memory>

CXPrintingPolicy clang_PrintingPolicy_create(CXLangOptions LO) {
  return std::make_unique<clang::PrintingPolicy>(*static_cast<clang::LangOptions *>(LO))
      .release();
}

CXPrintingPolicy clang_PrintingPolicy_copy(CXPrintingPolicy PP) {
  return std::make_unique<clang::PrintingPolicy>(*static_cast<clang::PrintingPolicy *>(PP))
      .release();
}

void clang_PrintingPolicy_dispose(CXPrintingPolicy PP) {
  delete static_cast<clang::PrintingPolicy *>(PP);
}

bool clang_PrintingPolicy_getSuppressTagKeyword(CXPrintingPolicy PP) {
  return static_cast<clang::PrintingPolicy *>(PP)->SuppressTagKeyword;
}

void clang_PrintingPolicy_setSuppressTagKeyword(CXPrintingPolicy PP, bool Value) {
  static_cast<clang::PrintingPolicy *>(PP)->SuppressTagKeyword = Value;
}

bool clang_PrintingPolicy_getSuppressScope(CXPrintingPolicy PP) {
  return static_cast<clang::PrintingPolicy *>(PP)->SuppressScope;
}

void clang_PrintingPolicy_setSuppressScope(CXPrintingPolicy PP, bool Value) {
  static_cast<clang::PrintingPolicy *>(PP)->SuppressScope = Value;
}

bool clang_PrintingPolicy_getBool(CXPrintingPolicy PP) {
  return static_cast<clang::PrintingPolicy *>(PP)->Bool;
}

void clang_PrintingPolicy_setBool(CXPrintingPolicy PP, bool Value) {
  static_cast<clang::PrintingPolicy *>(PP)->Bool = Value;
}
