#include "clang-ex/ASTMatchers/CXASTMatchersInternal.h"

#include "utils.h"

#include "clang/AST/ASTTypeTraits.h"
#include "clang/ASTMatchers/ASTMatchersInternal.h"
#include "llvm/ADT/StringRef.h"

#include <memory>
#include <optional>
#include <string>
#include <utility>

namespace {
using CXXDynTypedMatcher = clang::ast_matchers::internal::DynTypedMatcher;

CXXDynTypedMatcher *matcher(CXDynTypedMatcher M) {
  return reinterpret_cast<CXXDynTypedMatcher *>(M);
}

CXDynTypedMatcher box(CXXDynTypedMatcher M) {
  return reinterpret_cast<CXDynTypedMatcher>(
      std::make_unique<CXXDynTypedMatcher>(std::move(M)).release());
}
} // namespace

void clang_DynTypedMatcher_dispose(CXDynTypedMatcher M) {
  delete matcher(M); // NOLINT(*-owning-memory)
}

CXDynTypedMatcher clang_DynTypedMatcher_tryBind(CXDynTypedMatcher M, const char *ID) {
  std::optional<CXXDynTypedMatcher> Bound = matcher(M)->tryBind(llvm::StringRef(ID));
  if (!Bound)
    return nullptr;
  return box(std::move(*Bound));
}

CXDynTypedMatcher clang_DynTypedMatcher_withTraversalKind(CXDynTypedMatcher M,
                                                          CXTraversalKind TK) {
  return box(matcher(M)->withTraversalKind(static_cast<clang::TraversalKind>(TK)));
}

bool clang_DynTypedMatcher_getTraversalKind(CXDynTypedMatcher M, CXTraversalKind *TK) {
  std::optional<clang::TraversalKind> K = matcher(M)->getTraversalKind();
  if (!K)
    return false;
  if (TK != nullptr)
    *TK = static_cast<CXTraversalKind>(*K);
  return true;
}

CXString clang_DynTypedMatcher_getSupportedKind(CXDynTypedMatcher M) {
  return extra::makeCXString(matcher(M)->getSupportedKind().asStringRef().str());
}

bool clang_DynTypedMatcher_canConvertTo(CXDynTypedMatcher M, CXDynTypedMatcher To) {
  return matcher(M)->canConvertTo(matcher(To)->getSupportedKind());
}
