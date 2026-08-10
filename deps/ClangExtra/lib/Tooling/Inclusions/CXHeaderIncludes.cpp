#include "clang-ex/Tooling/Inclusions/CXHeaderIncludes.h"

#include "clang/Tooling/Core/Replacement.h"
#include "clang/Tooling/Inclusions/HeaderIncludes.h"
#include "clang/Tooling/Inclusions/IncludeStyle.h"
#include "llvm/ADT/StringRef.h"

#include <memory>
#include <optional>

// IncludeCategoryManager

CXIncludeCategoryManager clang_IncludeCategoryManager_create(CXIncludeStyle Style,
                                                             const char *FileName) {
  return reinterpret_cast<CXIncludeCategoryManager>(
      std::make_unique<clang::tooling::IncludeCategoryManager>(
          *reinterpret_cast<clang::tooling::IncludeStyle *>(Style),
          llvm::StringRef(FileName))
          .release());
}

void clang_IncludeCategoryManager_dispose(CXIncludeCategoryManager M) {
  delete reinterpret_cast<clang::tooling::IncludeCategoryManager *>(M);
}

int clang_IncludeCategoryManager_getIncludePriority(CXIncludeCategoryManager M,
                                                    const char *IncludeName,
                                                    bool CheckMainHeader) {
  return reinterpret_cast<clang::tooling::IncludeCategoryManager *>(M)->getIncludePriority(
      llvm::StringRef(IncludeName), CheckMainHeader);
}

int clang_IncludeCategoryManager_getSortIncludePriority(CXIncludeCategoryManager M,
                                                        const char *IncludeName,
                                                        bool CheckMainHeader) {
  return reinterpret_cast<clang::tooling::IncludeCategoryManager *>(M)
      ->getSortIncludePriority(llvm::StringRef(IncludeName), CheckMainHeader);
}

// HeaderIncludes

CXHeaderIncludes clang_HeaderIncludes_create(const char *FileName, const char *Code,
                                             CXIncludeStyle Style) {
  return reinterpret_cast<CXHeaderIncludes>(
      std::make_unique<clang::tooling::HeaderIncludes>(
          llvm::StringRef(FileName), llvm::StringRef(Code),
          *reinterpret_cast<clang::tooling::IncludeStyle *>(Style))
          .release());
}

void clang_HeaderIncludes_dispose(CXHeaderIncludes HI) {
  delete reinterpret_cast<clang::tooling::HeaderIncludes *>(HI);
}

CXReplacement clang_HeaderIncludes_insert(CXHeaderIncludes HI, const char *Header,
                                          bool IsAngled, CXIncludeDirective Directive) {
  std::optional<clang::tooling::Replacement> R =
      reinterpret_cast<clang::tooling::HeaderIncludes *>(HI)->insert(
          llvm::StringRef(Header), IsAngled,
          static_cast<clang::tooling::IncludeDirective>(Directive));
  if (!R)
    return nullptr;
  return reinterpret_cast<CXReplacement>(
      std::make_unique<clang::tooling::Replacement>(*R).release());
}

CXReplacements clang_HeaderIncludes_remove(CXHeaderIncludes HI, const char *Header,
                                           bool IsAngled) {
  return reinterpret_cast<CXReplacements>(
      std::make_unique<clang::tooling::Replacements>(
          reinterpret_cast<clang::tooling::HeaderIncludes *>(HI)->remove(
              llvm::StringRef(Header), IsAngled))
          .release());
}
