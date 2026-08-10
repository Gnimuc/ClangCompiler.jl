#include "clang-ex/AST/CXPrettyPrinter.h"
#include "clang/AST/PrettyPrinter.h"
#include "clang/Basic/LangOptions.h"
#include <memory>

CXPrintingPolicy_ clang_PrintingPolicy_create(CXLangOptions LO) {
  return reinterpret_cast<CXPrintingPolicy_>(std::make_unique<clang::PrintingPolicy>(*reinterpret_cast<clang::LangOptions *>(LO))
      .release());
}

CXPrintingPolicy_ clang_PrintingPolicy_copy(CXPrintingPolicy_ PP) {
  return reinterpret_cast<CXPrintingPolicy_>(std::make_unique<clang::PrintingPolicy>(*reinterpret_cast<clang::PrintingPolicy *>(PP))
      .release());
}

void clang_PrintingPolicy_dispose(CXPrintingPolicy_ PP) {
  delete reinterpret_cast<clang::PrintingPolicy *>(PP);
}

bool clang_PrintingPolicy_getSuppressTagKeyword(CXPrintingPolicy_ PP) {
  return reinterpret_cast<clang::PrintingPolicy *>(PP)->SuppressTagKeyword;
}

void clang_PrintingPolicy_setSuppressTagKeyword(CXPrintingPolicy_ PP, bool Value) {
  reinterpret_cast<clang::PrintingPolicy *>(PP)->SuppressTagKeyword = Value;
}

bool clang_PrintingPolicy_getSuppressScope(CXPrintingPolicy_ PP) {
  return reinterpret_cast<clang::PrintingPolicy *>(PP)->SuppressScope;
}

void clang_PrintingPolicy_setSuppressScope(CXPrintingPolicy_ PP, bool Value) {
  reinterpret_cast<clang::PrintingPolicy *>(PP)->SuppressScope = Value;
}

bool clang_PrintingPolicy_getBool(CXPrintingPolicy_ PP) {
  return reinterpret_cast<clang::PrintingPolicy *>(PP)->Bool;
}

void clang_PrintingPolicy_setBool(CXPrintingPolicy_ PP, bool Value) {
  reinterpret_cast<clang::PrintingPolicy *>(PP)->Bool = Value;
}

bool clang_PrintingPolicy_getFullyQualifiedName(CXPrintingPolicy_ PP) {
  return reinterpret_cast<clang::PrintingPolicy *>(PP)->FullyQualifiedName;
}

void clang_PrintingPolicy_setFullyQualifiedName(CXPrintingPolicy_ PP, bool Value) {
  reinterpret_cast<clang::PrintingPolicy *>(PP)->FullyQualifiedName = Value;
}

bool clang_PrintingPolicy_getSuppressDefaultTemplateArgs(CXPrintingPolicy_ PP) {
  return reinterpret_cast<clang::PrintingPolicy *>(PP)->SuppressDefaultTemplateArgs;
}

void clang_PrintingPolicy_setSuppressDefaultTemplateArgs(CXPrintingPolicy_ PP, bool Value) {
  reinterpret_cast<clang::PrintingPolicy *>(PP)->SuppressDefaultTemplateArgs = Value;
}

bool clang_PrintingPolicy_getPrintCanonicalTypes(CXPrintingPolicy_ PP) {
  return reinterpret_cast<clang::PrintingPolicy *>(PP)->PrintCanonicalTypes;
}

void clang_PrintingPolicy_setPrintCanonicalTypes(CXPrintingPolicy_ PP, bool Value) {
  reinterpret_cast<clang::PrintingPolicy *>(PP)->PrintCanonicalTypes = Value;
}
