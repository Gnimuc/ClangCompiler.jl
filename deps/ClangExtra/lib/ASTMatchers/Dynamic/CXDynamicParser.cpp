#include "clang-ex/ASTMatchers/Dynamic/CXDynamicParser.h"

#include "utils.h"

#include "clang/ASTMatchers/ASTMatchersInternal.h"
#include "clang/ASTMatchers/Dynamic/Diagnostics.h"
#include "clang/ASTMatchers/Dynamic/Parser.h"
#include "clang/ASTMatchers/Dynamic/Registry.h"
#include "clang/ASTMatchers/Dynamic/VariantValue.h"
#include "llvm/ADT/StringRef.h"

#include <memory>
#include <optional>
#include <string>
#include <utility>
#include <vector>

namespace {
using CXXDiagnostics = clang::ast_matchers::dynamic::Diagnostics;
using CXXParser = clang::ast_matchers::dynamic::Parser;
using CXXCompletionList = std::vector<clang::ast_matchers::dynamic::MatcherCompletion>;

CXXDiagnostics *diags(CXMatcherDiagnostics D) {
  return reinterpret_cast<CXXDiagnostics *>(D);
}

const CXXParser::NamedValueMap *namedValues(CXNamedValueMap NamedValues) {
  return reinterpret_cast<const CXXParser::NamedValueMap *>(NamedValues);
}

CXXCompletionList *completions(CXMatcherCompletionList L) {
  return reinterpret_cast<CXXCompletionList *>(L);
}
} // namespace

CXMatcherDiagnostics clang_MatcherDiagnostics_create(void) {
  return reinterpret_cast<CXMatcherDiagnostics>(std::make_unique<CXXDiagnostics>().release());
}

void clang_MatcherDiagnostics_dispose(CXMatcherDiagnostics D) {
  delete diags(D); // NOLINT(*-owning-memory)
}

unsigned clang_MatcherDiagnostics_getNumErrors(CXMatcherDiagnostics D) {
  return static_cast<unsigned>(diags(D)->errors().size());
}

CXString clang_MatcherDiagnostics_toString(CXMatcherDiagnostics D) {
  return extra::makeCXString(diags(D)->toString());
}

CXString clang_MatcherDiagnostics_toStringFull(CXMatcherDiagnostics D) {
  return extra::makeCXString(diags(D)->toStringFull());
}

CXDynTypedMatcher clang_Parser_parseMatcherExpression(const char *MatcherCode,
                                                      CXNamedValueMap NamedValues,
                                                      CXMatcherDiagnostics Error) {
  // The parser consumes the StringRef it is handed, so it takes a non-const
  // reference; this local is the buffer it advances.
  llvm::StringRef Code(MatcherCode);
  std::optional<clang::ast_matchers::internal::DynTypedMatcher> M =
      CXXParser::parseMatcherExpression(Code, nullptr, namedValues(NamedValues),
                                        diags(Error));
  if (!M)
    return nullptr;
  return reinterpret_cast<CXDynTypedMatcher>(
      std::make_unique<clang::ast_matchers::internal::DynTypedMatcher>(std::move(*M))
          .release());
}

CXMatcherCompletionList clang_Parser_completeExpression(const char *Code,
                                                        unsigned CompletionOffset,
                                                        CXNamedValueMap NamedValues) {
  llvm::StringRef C(Code);
  return reinterpret_cast<CXMatcherCompletionList>(
      std::make_unique<CXXCompletionList>(
          CXXParser::completeExpression(C, CompletionOffset, nullptr,
                                        namedValues(NamedValues)))
          .release());
}

void clang_MatcherCompletionList_dispose(CXMatcherCompletionList L) {
  delete completions(L); // NOLINT(*-owning-memory)
}

unsigned clang_MatcherCompletionList_getNumCompletions(CXMatcherCompletionList L) {
  return static_cast<unsigned>(completions(L)->size());
}

CXString clang_MatcherCompletionList_getTypedText(CXMatcherCompletionList L, unsigned Index) {
  CXXCompletionList *Cs = completions(L);
  if (Index >= Cs->size())
    return extra::makeCXString("");
  return extra::makeCXString((*Cs)[Index].TypedText);
}

CXString clang_MatcherCompletionList_getMatcherDecl(CXMatcherCompletionList L, unsigned Index) {
  CXXCompletionList *Cs = completions(L);
  if (Index >= Cs->size())
    return extra::makeCXString("");
  return extra::makeCXString((*Cs)[Index].MatcherDecl);
}

unsigned clang_MatcherCompletionList_getSpecificity(CXMatcherCompletionList L, unsigned Index) {
  CXXCompletionList *Cs = completions(L);
  if (Index >= Cs->size())
    return 0;
  return (*Cs)[Index].Specificity;
}
