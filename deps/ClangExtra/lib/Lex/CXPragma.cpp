#include "clang-ex/Lex/CXPragma.h"
#include "utils.h"

#include "clang/Lex/Pragma.h"
#include "clang/Lex/Preprocessor.h"
#include "llvm/ADT/StringRef.h"

#include <memory>

namespace {

clang::PragmaHandler *handler(CXPragmaHandler H) {
  return reinterpret_cast<clang::PragmaHandler *>(H);
}

clang::PragmaNamespace *ns(CXPragmaNamespace NS) {
  return reinterpret_cast<clang::PragmaNamespace *>(NS);
}

// A NULL name is the null handler / top-level namespace, which clang spells as a default
// constructed StringRef rather than as "".
llvm::StringRef nameRef(const char *Name) {
  return Name ? llvm::StringRef(Name) : llvm::StringRef();
}

} // namespace

// PragmaHandler

CXString clang_PragmaHandler_getName(CXPragmaHandler H) {
  return extra::makeCXString(handler(H)->getName().str());
}

// HandlePragma

CXPragmaNamespace clang_PragmaHandler_getIfNamespace(CXPragmaHandler H) {
  return reinterpret_cast<CXPragmaNamespace>(handler(H)->getIfNamespace());
}

// EmptyPragmaHandler

CXEmptyPragmaHandler clang_EmptyPragmaHandler_create(const char *Name) {
  return reinterpret_cast<CXEmptyPragmaHandler>(
      std::make_unique<clang::EmptyPragmaHandler>(nameRef(Name)).release());
}

void clang_EmptyPragmaHandler_dispose(CXEmptyPragmaHandler H) {
  delete reinterpret_cast<clang::EmptyPragmaHandler *>(H);
}

// PragmaNamespace

CXPragmaNamespace clang_PragmaNamespace_create(const char *Name) {
  return reinterpret_cast<CXPragmaNamespace>(
      std::make_unique<clang::PragmaNamespace>(nameRef(Name)).release());
}

void clang_PragmaNamespace_dispose(CXPragmaNamespace NS) { delete ns(NS); }

CXPragmaHandler clang_PragmaNamespace_FindHandler(CXPragmaNamespace NS, const char *Name,
                                                  bool IgnoreNull) {
  return reinterpret_cast<CXPragmaHandler>(ns(NS)->FindHandler(nameRef(Name), IgnoreNull));
}

void clang_PragmaNamespace_AddPragma(CXPragmaNamespace NS, CXPragmaHandler Handler) {
  ns(NS)->AddPragma(handler(Handler));
}

void clang_PragmaNamespace_RemovePragmaHandler(CXPragmaNamespace NS,
                                               CXPragmaHandler Handler) {
  ns(NS)->RemovePragmaHandler(handler(Handler));
}

bool clang_PragmaNamespace_IsEmpty(CXPragmaNamespace NS) { return ns(NS)->IsEmpty(); }

// prepare_PragmaString

// Preprocessor

void clang_Preprocessor_AddPragmaHandler(CXPreprocessor PP, const char *Namespace,
                                         CXPragmaHandler Handler) {
  reinterpret_cast<clang::Preprocessor *>(PP)->AddPragmaHandler(nameRef(Namespace),
                                                                handler(Handler));
}

void clang_Preprocessor_RemovePragmaHandler(CXPreprocessor PP, const char *Namespace,
                                            CXPragmaHandler Handler) {
  reinterpret_cast<clang::Preprocessor *>(PP)->RemovePragmaHandler(nameRef(Namespace),
                                                                   handler(Handler));
}
