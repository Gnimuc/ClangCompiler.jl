#include "clang-ex/Rewrite/CXFixItRewriter.h"

#include "utils.h"

#include "clang/Basic/Diagnostic.h"
#include "clang/Basic/LangOptions.h"
#include "clang/Basic/SourceLocation.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Rewrite/Frontend/FixItRewriter.h"
#include "llvm/Support/raw_ostream.h"

#include <iterator>
#include <memory>
#include <string>

namespace {

// The one FixItOptions subclass libclangex compiles. RewriteFilename is the pure virtual
// that makes a subclass mandatory; the three behaviour switches are the plain public bools
// of the base, which clang_FixItRewriter_create sets after construction.
class ExtraFixItOptions : public clang::FixItOptions {
public:
  std::string RewriteFilename(const std::string &Filename, int &fd) override {
    fd = -1;
    return Filename + ".fixit";
  }
};

// clang::FixItRewriter keeps its FixItOptions as a raw pointer it does not own, so the two
// live in one allocation. Declaration order matters: Opts must be constructed before the
// rewriter that is handed its address.
struct FixItRewriterBox {
  ExtraFixItOptions Opts;
  clang::FixItRewriter Rewriter;

  FixItRewriterBox(clang::DiagnosticsEngine &Diags, clang::SourceManager &SM,
                   const clang::LangOptions &LO)
      : Opts(), Rewriter(Diags, SM, LO, &Opts) {}
};

FixItRewriterBox &unwrap(CXFixItRewriter R) {
  return *reinterpret_cast<FixItRewriterBox *>(R);
}

} // namespace

// FixItRewriter

CXFixItRewriter clang_FixItRewriter_create(CXDiagnosticsEngine DE, CXSourceManager SM,
                                           CXLangOptions LO, bool InPlace,
                                           bool FixWhatYouCan, bool FixOnlyWarnings,
                                           bool Silent) {
  auto Box = std::make_unique<FixItRewriterBox>(
      *reinterpret_cast<clang::DiagnosticsEngine *>(DE),
      *reinterpret_cast<clang::SourceManager *>(SM),
      *reinterpret_cast<clang::LangOptions *>(LO));
  Box->Opts.InPlace = InPlace;
  Box->Opts.FixWhatYouCan = FixWhatYouCan;
  Box->Opts.FixOnlyWarnings = FixOnlyWarnings;
  Box->Opts.Silent = Silent;
  return reinterpret_cast<CXFixItRewriter>(Box.release());
}

void clang_FixItRewriter_dispose(CXFixItRewriter R) {
  delete reinterpret_cast<FixItRewriterBox *>(R);
}

bool clang_FixItRewriter_IsModified(CXFixItRewriter R, CXFileID ID) {
  return unwrap(R).Rewriter.IsModified(*reinterpret_cast<clang::FileID *>(ID));
}

unsigned clang_FixItRewriter_getNumBuffers(CXFixItRewriter R) {
  clang::FixItRewriter &FR = unwrap(R).Rewriter;
  return static_cast<unsigned>(std::distance(FR.buffer_begin(), FR.buffer_end()));
}

CXFileID clang_FixItRewriter_getBufferFileID(CXFixItRewriter R, unsigned Idx) {
  clang::FixItRewriter &FR = unwrap(R).Rewriter;
  clang::FixItRewriter::iterator I = FR.buffer_begin();
  std::advance(I, Idx);
  return reinterpret_cast<CXFileID>(std::make_unique<clang::FileID>(I->first).release());
}

CXString clang_FixItRewriter_WriteFixedFile(CXFixItRewriter R, CXFileID ID) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  if (unwrap(R).Rewriter.WriteFixedFile(*reinterpret_cast<clang::FileID *>(ID), OS))
    return extra::makeCXString("");
  OS.flush();
  return extra::makeCXString(S);
}

bool clang_FixItRewriter_WriteFixedFiles(CXFixItRewriter R) {
  return unwrap(R).Rewriter.WriteFixedFiles(nullptr);
}

bool clang_FixItRewriter_IncludeInDiagnosticCounts(CXFixItRewriter R) {
  return unwrap(R).Rewriter.IncludeInDiagnosticCounts();
}

void clang_FixItRewriter_Diag(CXFixItRewriter R, CXSourceLocation_ Loc, unsigned DiagID) {
  unwrap(R).Rewriter.Diag(clang::SourceLocation::getFromPtrEncoding(Loc), DiagID);
}
