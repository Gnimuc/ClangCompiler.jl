#include "clang-ex/ASTMatchers/Dynamic/CXVariantValue.h"

#include "utils.h"

#include "clang/ASTMatchers/ASTMatchersInternal.h"
#include "clang/ASTMatchers/Dynamic/Parser.h"
#include "clang/ASTMatchers/Dynamic/VariantValue.h"
#include "llvm/ADT/StringRef.h"

#include <memory>
#include <optional>
#include <string>
#include <utility>

namespace {
using CXXVariantValue = clang::ast_matchers::dynamic::VariantValue;
using CXXVariantMatcher = clang::ast_matchers::dynamic::VariantMatcher;
using CXXNamedValueMap = clang::ast_matchers::dynamic::Parser::NamedValueMap;

CXXVariantValue *value(CXVariantValue V) { return reinterpret_cast<CXXVariantValue *>(V); }

CXXNamedValueMap *map(CXNamedValueMap M) { return reinterpret_cast<CXXNamedValueMap *>(M); }

CXVariantValue box(CXXVariantValue V) {
  return reinterpret_cast<CXVariantValue>(
      std::make_unique<CXXVariantValue>(std::move(V)).release());
}
} // namespace

CXVariantValue clang_VariantValue_create(void) { return box(CXXVariantValue()); }

CXVariantValue clang_VariantValue_createBoolean(bool Boolean) {
  return box(CXXVariantValue(Boolean));
}

CXVariantValue clang_VariantValue_createDouble(double Double) {
  return box(CXXVariantValue(Double));
}

CXVariantValue clang_VariantValue_createUnsigned(unsigned Unsigned) {
  return box(CXXVariantValue(Unsigned));
}

CXVariantValue clang_VariantValue_createString(const char *String) {
  return box(CXXVariantValue(llvm::StringRef(String)));
}

CXVariantValue clang_VariantValue_createMatcher(CXDynTypedMatcher Matcher) {
  return box(CXXVariantValue(CXXVariantMatcher::SingleMatcher(
      *reinterpret_cast<clang::ast_matchers::internal::DynTypedMatcher *>(Matcher))));
}

void clang_VariantValue_dispose(CXVariantValue V) {
  delete value(V); // NOLINT(*-owning-memory)
}

bool clang_VariantValue_hasValue(CXVariantValue V) { return value(V)->hasValue(); }

bool clang_VariantValue_isBoolean(CXVariantValue V) { return value(V)->isBoolean(); }

bool clang_VariantValue_getBoolean(CXVariantValue V) { return value(V)->getBoolean(); }

bool clang_VariantValue_isDouble(CXVariantValue V) { return value(V)->isDouble(); }

double clang_VariantValue_getDouble(CXVariantValue V) { return value(V)->getDouble(); }

bool clang_VariantValue_isUnsigned(CXVariantValue V) { return value(V)->isUnsigned(); }

unsigned clang_VariantValue_getUnsigned(CXVariantValue V) { return value(V)->getUnsigned(); }

bool clang_VariantValue_isString(CXVariantValue V) { return value(V)->isString(); }

CXString clang_VariantValue_getString(CXVariantValue V) {
  return extra::makeCXString(value(V)->getString());
}

bool clang_VariantValue_isMatcher(CXVariantValue V) { return value(V)->isMatcher(); }

CXDynTypedMatcher clang_VariantValue_getSingleMatcher(CXVariantValue V) {
  CXXVariantValue *Val = value(V);
  if (!Val->isMatcher())
    return nullptr;
  std::optional<clang::ast_matchers::internal::DynTypedMatcher> M =
      Val->getMatcher().getSingleMatcher();
  if (!M)
    return nullptr;
  return reinterpret_cast<CXDynTypedMatcher>(
      std::make_unique<clang::ast_matchers::internal::DynTypedMatcher>(std::move(*M))
          .release());
}

CXString clang_VariantValue_getTypeAsString(CXVariantValue V) {
  return extra::makeCXString(value(V)->getTypeAsString());
}

CXNamedValueMap clang_NamedValueMap_create(void) {
  return reinterpret_cast<CXNamedValueMap>(std::make_unique<CXXNamedValueMap>().release());
}

void clang_NamedValueMap_dispose(CXNamedValueMap M) {
  delete map(M); // NOLINT(*-owning-memory)
}

void clang_NamedValueMap_set(CXNamedValueMap M, const char *Name, CXVariantValue Value) {
  (*map(M))[llvm::StringRef(Name)] = *value(Value);
}

unsigned clang_NamedValueMap_size(CXNamedValueMap M) {
  return static_cast<unsigned>(map(M)->size());
}

bool clang_NamedValueMap_contains(CXNamedValueMap M, const char *Name) {
  CXXNamedValueMap *Map = map(M);
  return Map->find(llvm::StringRef(Name)) != Map->end();
}
