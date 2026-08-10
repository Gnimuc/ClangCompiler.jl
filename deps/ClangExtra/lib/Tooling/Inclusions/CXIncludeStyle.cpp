#include "clang-ex/Tooling/Inclusions/CXIncludeStyle.h"

#include "utils.h"

#include "clang/Format/Format.h"
#include "clang/Tooling/Inclusions/IncludeStyle.h"

#include <memory>
#include <string>

CXIncludeStyle clang_IncludeStyle_create(void) {
  // clang::tooling::IncludeStyle has no in-class initialisers, so the only defensible
  // "default" is the one clang-format itself ships.
  return reinterpret_cast<CXIncludeStyle>(
      std::make_unique<clang::tooling::IncludeStyle>(
          clang::format::getLLVMStyle(clang::format::FormatStyle::LK_Cpp).IncludeStyle)
          .release());
}

void clang_IncludeStyle_dispose(CXIncludeStyle IS) {
  delete reinterpret_cast<clang::tooling::IncludeStyle *>(IS);
}

CXIncludeBlocksStyle clang_IncludeStyle_getIncludeBlocks(CXIncludeStyle IS) {
  return static_cast<CXIncludeBlocksStyle>(
      reinterpret_cast<clang::tooling::IncludeStyle *>(IS)->IncludeBlocks);
}

void clang_IncludeStyle_setIncludeBlocks(CXIncludeStyle IS, CXIncludeBlocksStyle S) {
  reinterpret_cast<clang::tooling::IncludeStyle *>(IS)->IncludeBlocks =
      static_cast<clang::tooling::IncludeStyle::IncludeBlocksStyle>(S);
}

CXString clang_IncludeStyle_getIncludeIsMainRegex(CXIncludeStyle IS) {
  return extra::makeCXString(
      reinterpret_cast<clang::tooling::IncludeStyle *>(IS)->IncludeIsMainRegex);
}

void clang_IncludeStyle_setIncludeIsMainRegex(CXIncludeStyle IS, const char *Regex) {
  reinterpret_cast<clang::tooling::IncludeStyle *>(IS)->IncludeIsMainRegex =
      std::string(Regex);
}

CXString clang_IncludeStyle_getIncludeIsMainSourceRegex(CXIncludeStyle IS) {
  return extra::makeCXString(
      reinterpret_cast<clang::tooling::IncludeStyle *>(IS)->IncludeIsMainSourceRegex);
}

void clang_IncludeStyle_setIncludeIsMainSourceRegex(CXIncludeStyle IS, const char *Regex) {
  reinterpret_cast<clang::tooling::IncludeStyle *>(IS)->IncludeIsMainSourceRegex =
      std::string(Regex);
}

unsigned clang_IncludeStyle_getNumIncludeCategories(CXIncludeStyle IS) {
  return static_cast<unsigned>(
      reinterpret_cast<clang::tooling::IncludeStyle *>(IS)->IncludeCategories.size());
}

CXString clang_IncludeStyle_getIncludeCategoryRegex(CXIncludeStyle IS, unsigned I) {
  return extra::makeCXString(
      reinterpret_cast<clang::tooling::IncludeStyle *>(IS)->IncludeCategories[I].Regex);
}

int clang_IncludeStyle_getIncludeCategoryPriority(CXIncludeStyle IS, unsigned I) {
  return reinterpret_cast<clang::tooling::IncludeStyle *>(IS)->IncludeCategories[I].Priority;
}

int clang_IncludeStyle_getIncludeCategorySortPriority(CXIncludeStyle IS, unsigned I) {
  return reinterpret_cast<clang::tooling::IncludeStyle *>(IS)
      ->IncludeCategories[I]
      .SortPriority;
}

bool clang_IncludeStyle_getIncludeCategoryRegexIsCaseSensitive(CXIncludeStyle IS,
                                                               unsigned I) {
  return reinterpret_cast<clang::tooling::IncludeStyle *>(IS)
      ->IncludeCategories[I]
      .RegexIsCaseSensitive;
}

void clang_IncludeStyle_addIncludeCategory(CXIncludeStyle IS, const char *Regex,
                                           int Priority, int SortPriority,
                                           bool RegexIsCaseSensitive) {
  clang::tooling::IncludeStyle::IncludeCategory C{std::string(Regex), Priority, SortPriority,
                                                  RegexIsCaseSensitive};
  reinterpret_cast<clang::tooling::IncludeStyle *>(IS)->IncludeCategories.push_back(C);
}

void clang_IncludeStyle_clearIncludeCategories(CXIncludeStyle IS) {
  reinterpret_cast<clang::tooling::IncludeStyle *>(IS)->IncludeCategories.clear();
}
