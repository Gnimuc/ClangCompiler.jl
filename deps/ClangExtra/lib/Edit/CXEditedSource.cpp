#include "clang-ex/Edit/CXEditedSource.h"

#include "clang/Basic/LangOptions.h"
#include "clang/Basic/SourceLocation.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Edit/Commit.h"
#include "clang/Edit/EditedSource.h"
#include "clang/Edit/EditsReceiver.h"
#include "clang/Edit/FileOffset.h"
#include "clang/Rewrite/Core/Rewriter.h"
#include "llvm/ADT/StringRef.h"

#include <memory>

namespace {

// The one EditsReceiver libclangex compiles. EditsReceiver::insert and ::replace are pure
// virtuals, so applyRewrites cannot be called without an implementation; this one forwards
// both into an existing Rewriter, which is exactly what clang's own migrator does, and
// keeps the pure-virtual interface off the C boundary entirely.
class RewriterEditsReceiver : public clang::edit::EditsReceiver {
  clang::Rewriter &Rewrite;

public:
  explicit RewriterEditsReceiver(clang::Rewriter &R) : Rewrite(R) {}

  void insert(clang::SourceLocation Loc, llvm::StringRef Text) override {
    Rewrite.InsertText(Loc, Text);
  }

  void replace(clang::CharSourceRange Range, llvm::StringRef Text) override {
    Rewrite.ReplaceText(Range.getBegin(), Rewrite.getRangeSize(Range), Text);
  }
};

} // namespace

// EditedSource

CXEditedSource clang_EditedSource_create(CXSourceManager SM, CXLangOptions LangOpts) {
  return reinterpret_cast<CXEditedSource>(
      std::make_unique<clang::edit::EditedSource>(
          *reinterpret_cast<clang::SourceManager *>(SM),
          *reinterpret_cast<clang::LangOptions *>(LangOpts), nullptr)
          .release());
}

void clang_EditedSource_dispose(CXEditedSource E) {
  delete reinterpret_cast<clang::edit::EditedSource *>(E);
}

CXSourceManager clang_EditedSource_getSourceManager(CXEditedSource E) {
  return reinterpret_cast<CXSourceManager>(const_cast<clang::SourceManager *>(
      &reinterpret_cast<clang::edit::EditedSource *>(E)->getSourceManager()));
}

CXLangOptions clang_EditedSource_getLangOpts(CXEditedSource E) {
  return reinterpret_cast<CXLangOptions>(const_cast<clang::LangOptions *>(
      &reinterpret_cast<clang::edit::EditedSource *>(E)->getLangOpts()));
}

bool clang_EditedSource_canInsertInOffset(CXEditedSource E, CXSourceLocation_ OrigLoc,
                                          CXFileID FID, unsigned Offs) {
  return reinterpret_cast<clang::edit::EditedSource *>(E)->canInsertInOffset(
      clang::SourceLocation::getFromPtrEncoding(OrigLoc),
      clang::edit::FileOffset(*reinterpret_cast<clang::FileID *>(FID), Offs));
}

bool clang_EditedSource_commit(CXEditedSource E, CXCommit C) {
  return reinterpret_cast<clang::edit::EditedSource *>(E)->commit(
      *reinterpret_cast<clang::edit::Commit *>(C));
}

void clang_EditedSource_applyRewrites(CXEditedSource E, CXRewriter R,
                                      bool AdjustRemovals) {
  RewriterEditsReceiver Receiver(*reinterpret_cast<clang::Rewriter *>(R));
  reinterpret_cast<clang::edit::EditedSource *>(E)->applyRewrites(Receiver,
                                                                  AdjustRemovals);
}

void clang_EditedSource_clearRewrites(CXEditedSource E) {
  reinterpret_cast<clang::edit::EditedSource *>(E)->clearRewrites();
}
