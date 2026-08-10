#include "clang-ex/Edit/CXCommit.h"

#include "clang/Basic/SourceLocation.h"
#include "clang/Edit/Commit.h"
#include "clang/Edit/EditedSource.h"
#include "llvm/ADT/StringRef.h"

#include <memory>

// A CharSourceRange crosses as CXSourceRange_ plus a token-range flag; see CXCommit.h.
static clang::CharSourceRange charRange(CXSourceRange_ Range, bool IsTokenRange) {
  clang::SourceRange R(clang::SourceLocation::getFromPtrEncoding(Range.B),
                       clang::SourceLocation::getFromPtrEncoding(Range.E));
  return IsTokenRange ? clang::CharSourceRange::getTokenRange(R)
                      : clang::CharSourceRange::getCharRange(R);
}

// Commit

CXCommit clang_Commit_create(CXEditedSource Editor) {
  return reinterpret_cast<CXCommit>(
      std::make_unique<clang::edit::Commit>(
          *reinterpret_cast<clang::edit::EditedSource *>(Editor))
          .release());
}

void clang_Commit_dispose(CXCommit C) { delete reinterpret_cast<clang::edit::Commit *>(C); }

bool clang_Commit_isCommitable(CXCommit C) {
  return reinterpret_cast<clang::edit::Commit *>(C)->isCommitable();
}

bool clang_Commit_insert(CXCommit C, CXSourceLocation_ Loc, const char *Text,
                         bool AfterToken, bool BeforePreviousInsertions) {
  return reinterpret_cast<clang::edit::Commit *>(C)->insert(
      clang::SourceLocation::getFromPtrEncoding(Loc), llvm::StringRef(Text), AfterToken,
      BeforePreviousInsertions);
}

bool clang_Commit_insertAfterToken(CXCommit C, CXSourceLocation_ Loc, const char *Text,
                                   bool BeforePreviousInsertions) {
  return reinterpret_cast<clang::edit::Commit *>(C)->insertAfterToken(
      clang::SourceLocation::getFromPtrEncoding(Loc), llvm::StringRef(Text),
      BeforePreviousInsertions);
}

bool clang_Commit_insertBefore(CXCommit C, CXSourceLocation_ Loc, const char *Text) {
  return reinterpret_cast<clang::edit::Commit *>(C)->insertBefore(
      clang::SourceLocation::getFromPtrEncoding(Loc), llvm::StringRef(Text));
}

bool clang_Commit_insertFromRange(CXCommit C, CXSourceLocation_ Loc, CXSourceRange_ Range,
                                  bool IsTokenRange, bool AfterToken,
                                  bool BeforePreviousInsertions) {
  return reinterpret_cast<clang::edit::Commit *>(C)->insertFromRange(
      clang::SourceLocation::getFromPtrEncoding(Loc), charRange(Range, IsTokenRange),
      AfterToken, BeforePreviousInsertions);
}

bool clang_Commit_insertWrap(CXCommit C, const char *Before, CXSourceRange_ Range,
                             bool IsTokenRange, const char *After) {
  return reinterpret_cast<clang::edit::Commit *>(C)->insertWrap(
      llvm::StringRef(Before), charRange(Range, IsTokenRange), llvm::StringRef(After));
}

bool clang_Commit_remove(CXCommit C, CXSourceRange_ Range, bool IsTokenRange) {
  return reinterpret_cast<clang::edit::Commit *>(C)->remove(charRange(Range, IsTokenRange));
}

bool clang_Commit_replace(CXCommit C, CXSourceRange_ Range, bool IsTokenRange,
                          const char *Text) {
  return reinterpret_cast<clang::edit::Commit *>(C)->replace(
      charRange(Range, IsTokenRange), llvm::StringRef(Text));
}

bool clang_Commit_replaceWithInner(CXCommit C, CXSourceRange_ Range, bool IsTokenRange,
                                   CXSourceRange_ InnerRange, bool InnerIsTokenRange) {
  return reinterpret_cast<clang::edit::Commit *>(C)->replaceWithInner(
      charRange(Range, IsTokenRange), charRange(InnerRange, InnerIsTokenRange));
}

bool clang_Commit_replaceText(CXCommit C, CXSourceLocation_ Loc, const char *Text,
                              const char *ReplacementText) {
  return reinterpret_cast<clang::edit::Commit *>(C)->replaceText(
      clang::SourceLocation::getFromPtrEncoding(Loc), llvm::StringRef(Text),
      llvm::StringRef(ReplacementText));
}
