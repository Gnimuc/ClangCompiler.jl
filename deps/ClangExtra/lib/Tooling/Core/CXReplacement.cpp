#include "clang-ex/Tooling/Core/CXReplacement.h"

#include "utils.h"

#include "clang/Basic/LangOptions.h"
#include "clang/Basic/SourceLocation.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Rewrite/Core/Rewriter.h"
#include "clang/Tooling/Core/Replacement.h"
#include "clang/Tooling/Refactoring.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/Error.h"

#include <iterator>
#include <map>
#include <memory>
#include <string>
#include <vector>

// Replacement

CXReplacement clang_Replacement_create(const char *FilePath, unsigned Offset,
                                       unsigned Length, const char *ReplacementText) {
  return reinterpret_cast<CXReplacement>(
      std::make_unique<clang::tooling::Replacement>(llvm::StringRef(FilePath), Offset, Length,
                                                    llvm::StringRef(ReplacementText))
          .release());
}

CXReplacement clang_Replacement_createInvalid(void) {
  return reinterpret_cast<CXReplacement>(
      std::make_unique<clang::tooling::Replacement>().release());
}

CXReplacement clang_Replacement_createFromSourceLocation(CXSourceManager SM,
                                                         CXSourceLocation_ Start,
                                                         unsigned Length,
                                                         const char *ReplacementText) {
  return reinterpret_cast<CXReplacement>(
      std::make_unique<clang::tooling::Replacement>(
          *reinterpret_cast<clang::SourceManager *>(SM),
          clang::SourceLocation::getFromPtrEncoding(Start), Length,
          llvm::StringRef(ReplacementText))
          .release());
}

CXReplacement clang_Replacement_createFromCharSourceRange(CXSourceManager SM,
                                                          CXSourceRange_ Range,
                                                          bool IsTokenRange,
                                                          const char *ReplacementText,
                                                          CXLangOptions LO) {
  clang::SourceRange SR(clang::SourceLocation::getFromPtrEncoding(Range.B),
                        clang::SourceLocation::getFromPtrEncoding(Range.E));
  clang::CharSourceRange CSR(SR, IsTokenRange);
  clang::LangOptions Default;
  const clang::LangOptions &Opts =
      LO ? *reinterpret_cast<clang::LangOptions *>(LO) : Default;
  return reinterpret_cast<CXReplacement>(
      std::make_unique<clang::tooling::Replacement>(
          *reinterpret_cast<clang::SourceManager *>(SM), CSR,
          llvm::StringRef(ReplacementText), Opts)
          .release());
}

void clang_Replacement_dispose(CXReplacement R) {
  delete reinterpret_cast<clang::tooling::Replacement *>(R);
}

bool clang_Replacement_isApplicable(CXReplacement R) {
  return reinterpret_cast<clang::tooling::Replacement *>(R)->isApplicable();
}

CXString clang_Replacement_getFilePath(CXReplacement R) {
  return extra::makeCXString(
      reinterpret_cast<clang::tooling::Replacement *>(R)->getFilePath().str());
}

unsigned clang_Replacement_getOffset(CXReplacement R) {
  return reinterpret_cast<clang::tooling::Replacement *>(R)->getOffset();
}

unsigned clang_Replacement_getLength(CXReplacement R) {
  return reinterpret_cast<clang::tooling::Replacement *>(R)->getLength();
}

CXString clang_Replacement_getReplacementText(CXReplacement R) {
  return extra::makeCXString(
      reinterpret_cast<clang::tooling::Replacement *>(R)->getReplacementText().str());
}

bool clang_Replacement_apply(CXReplacement R, CXRewriter Rewrite) {
  return reinterpret_cast<clang::tooling::Replacement *>(R)->apply(
      *reinterpret_cast<clang::Rewriter *>(Rewrite));
}

CXString clang_Replacement_toString(CXReplacement R) {
  return extra::makeCXString(
      reinterpret_cast<clang::tooling::Replacement *>(R)->toString());
}

// Replacements

CXReplacements clang_Replacements_create(void) {
  return reinterpret_cast<CXReplacements>(
      std::make_unique<clang::tooling::Replacements>().release());
}

CXReplacements clang_Replacements_createFromReplacement(CXReplacement R) {
  return reinterpret_cast<CXReplacements>(
      std::make_unique<clang::tooling::Replacements>(
          *reinterpret_cast<clang::tooling::Replacement *>(R))
          .release());
}

void clang_Replacements_dispose(CXReplacements Rs) {
  delete reinterpret_cast<clang::tooling::Replacements *>(Rs);
}

bool clang_Replacements_add(CXReplacements Rs, CXReplacement R, CXString *OutError) {
  llvm::Error E = reinterpret_cast<clang::tooling::Replacements *>(Rs)->add(
      *reinterpret_cast<clang::tooling::Replacement *>(R));
  if (!E) {
    if (OutError)
      *OutError = extra::makeCXString(std::string());
    return true;
  }
  std::string Msg = llvm::toString(std::move(E));
  if (OutError)
    *OutError = extra::makeCXString(Msg);
  return false;
}

CXReplacements clang_Replacements_merge(CXReplacements Rs, CXReplacements Other) {
  return reinterpret_cast<CXReplacements>(
      std::make_unique<clang::tooling::Replacements>(
          reinterpret_cast<clang::tooling::Replacements *>(Rs)->merge(
              *reinterpret_cast<clang::tooling::Replacements *>(Other)))
          .release());
}

unsigned clang_Replacements_getAffectedRanges(CXReplacements Rs, unsigned *Offsets,
                                              unsigned *Lengths, unsigned N) {
  std::vector<clang::tooling::Range> Ranges =
      reinterpret_cast<clang::tooling::Replacements *>(Rs)->getAffectedRanges();
  unsigned Count = static_cast<unsigned>(Ranges.size());
  unsigned Fill = N < Count ? N : Count;
  for (unsigned I = 0; I < Fill; ++I) {
    if (Offsets)
      Offsets[I] = Ranges[I].getOffset();
    if (Lengths)
      Lengths[I] = Ranges[I].getLength();
  }
  return Count;
}

unsigned clang_Replacements_getShiftedCodePosition(CXReplacements Rs, unsigned Position) {
  return reinterpret_cast<clang::tooling::Replacements *>(Rs)->getShiftedCodePosition(
      Position);
}

unsigned clang_Replacements_size(CXReplacements Rs) {
  return reinterpret_cast<clang::tooling::Replacements *>(Rs)->size();
}

void clang_Replacements_clear(CXReplacements Rs) {
  reinterpret_cast<clang::tooling::Replacements *>(Rs)->clear();
}

bool clang_Replacements_empty(CXReplacements Rs) {
  return reinterpret_cast<clang::tooling::Replacements *>(Rs)->empty();
}

CXReplacement clang_Replacements_getReplacement(CXReplacements Rs, unsigned I) {
  clang::tooling::Replacements *Set = reinterpret_cast<clang::tooling::Replacements *>(Rs);
  if (I >= Set->size())
    return nullptr;
  auto It = Set->begin();
  std::advance(It, I);
  return reinterpret_cast<CXReplacement>(
      const_cast<clang::tooling::Replacement *>(&*It));
}

bool clang_tooling_applyAllReplacements(CXReplacements Rs, CXRewriter Rewrite) {
  return clang::tooling::applyAllReplacements(
      *reinterpret_cast<clang::tooling::Replacements *>(Rs),
      *reinterpret_cast<clang::Rewriter *>(Rewrite));
}

CXString clang_tooling_applyAllReplacementsToCode(const char *Code, CXReplacements Rs,
                                                  bool *OutSuccess) {
  llvm::Expected<std::string> Result = clang::tooling::applyAllReplacements(
      llvm::StringRef(Code), *reinterpret_cast<clang::tooling::Replacements *>(Rs));
  if (!Result) {
    std::string Msg = llvm::toString(Result.takeError());
    if (OutSuccess)
      *OutSuccess = false;
    return extra::makeCXString(Msg);
  }
  if (OutSuccess)
    *OutSuccess = true;
  return extra::makeCXString(*Result);
}

bool clang_tooling_formatAndApplyAllReplacements(const char *FilePath, CXReplacements Rs,
                                                 CXRewriter Rewrite, const char *Style) {
  std::map<std::string, clang::tooling::Replacements> FileToReplaces;
  FileToReplaces[std::string(FilePath)] =
      *reinterpret_cast<clang::tooling::Replacements *>(Rs);
  return clang::tooling::formatAndApplyAllReplacements(
      FileToReplaces, *reinterpret_cast<clang::Rewriter *>(Rewrite),
      Style ? llvm::StringRef(Style) : llvm::StringRef("file"));
}
