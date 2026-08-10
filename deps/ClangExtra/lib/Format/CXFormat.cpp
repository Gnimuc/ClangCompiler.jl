#include "clang-ex/Format/CXFormat.h"

#include "utils.h"

#include "clang/Format/Format.h"
#include "clang/Tooling/Core/Replacement.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/Support/Error.h"
#include "llvm/Support/raw_ostream.h"

#include <memory>
#include <string>
#include <vector>

// See the marshalling contract in CXFormat.h: a NULL CXString is the failure sentinel for
// everything in the reformat/sortIncludes/cleanup family. extra::makeCXString can never
// produce one -- the empty string is a static "" -- so it is built here.
static CXString makeNullCXString() {
  CXString Str;
  Str.data = nullptr;
  Str.private_flags = 0; // CXS_Unmanaged
  return Str;
}

static clang::format::FormatStyle &unwrapStyle(CXFormatStyle Style) {
  return *reinterpret_cast<clang::format::FormatStyle *>(Style);
}

static CXFormatStyle boxStyle(const clang::format::FormatStyle &Style) {
  return reinterpret_cast<CXFormatStyle>(
      std::make_unique<clang::format::FormatStyle>(Style).release());
}

// Whole-file formatting is a single range covering the buffer.
static std::vector<clang::tooling::Range> wholeFile(llvm::StringRef Code) {
  return {clang::tooling::Range(0, static_cast<unsigned>(Code.size()))};
}

static CXString applyToCode(llvm::StringRef Code,
                            const clang::tooling::Replacements &Replaces,
                            const char *Who) {
  llvm::Expected<std::string> Changed =
      clang::tooling::applyAllReplacements(Code, Replaces);
  if (!Changed) {
    llvm::errs() << Who << ": " << llvm::toString(Changed.takeError()) << "\n";
    return makeNullCXString();
  }
  return extra::makeCXString(*Changed);
}

// Rebuild the caller's parallel arrays as a tooling::Replacements. add() rejects an
// order-dependent script by returning an llvm::Error, which must be consumed here.
static bool buildReplacements(clang::tooling::Replacements &Out, llvm::StringRef FileName,
                              const unsigned *Offsets, const unsigned *Lengths,
                              const char **Texts, unsigned NumReplacements,
                              const char *Who) {
  for (unsigned I = 0; I != NumReplacements; ++I) {
    llvm::Error E = Out.add(clang::tooling::Replacement(
        FileName, Offsets[I], Lengths[I], llvm::StringRef(Texts[I])));
    if (E) {
      llvm::errs() << Who << ": " << llvm::toString(std::move(E)) << "\n";
      return false;
    }
  }
  return true;
}

// FormatStyle

void clang_FormatStyle_dispose(CXFormatStyle Style) {
  delete reinterpret_cast<clang::format::FormatStyle *>(Style);
}

CXLanguageKind clang_FormatStyle_getLanguage(CXFormatStyle Style) {
  return static_cast<CXLanguageKind>(unwrapStyle(Style).Language);
}

void clang_FormatStyle_setLanguage(CXFormatStyle Style, CXLanguageKind Language) {
  unwrapStyle(Style).Language =
      static_cast<clang::format::FormatStyle::LanguageKind>(Language);
}

CXFormatStyle clang_format_getLLVMStyle(CXLanguageKind Language) {
  return boxStyle(clang::format::getLLVMStyle(
      static_cast<clang::format::FormatStyle::LanguageKind>(Language)));
}

CXFormatStyle clang_format_getGoogleStyle(CXLanguageKind Language) {
  return boxStyle(clang::format::getGoogleStyle(
      static_cast<clang::format::FormatStyle::LanguageKind>(Language)));
}

CXFormatStyle clang_format_getNoStyle(void) {
  return boxStyle(clang::format::getNoStyle());
}

CXFormatStyle clang_format_getPredefinedStyle(const char *Name, CXLanguageKind Language) {
  clang::format::FormatStyle Style = clang::format::getNoStyle();
  if (!clang::format::getPredefinedStyle(
          llvm::StringRef(Name),
          static_cast<clang::format::FormatStyle::LanguageKind>(Language), &Style)) {
    return nullptr;
  }
  return boxStyle(Style);
}

CXParseError clang_format_parseConfiguration(const char *Config, CXFormatStyle Style,
                                             bool AllowUnknownOptions) {
  std::error_code EC = clang::format::parseConfiguration(
      llvm::StringRef(Config), &unwrapStyle(Style), AllowUnknownOptions);
  if (!EC)
    return CXParseError_Success;
  if (EC.category() == clang::format::getParseCategory())
    return static_cast<CXParseError>(EC.value());
  llvm::errs() << "clang_format_parseConfiguration: " << EC.message() << "\n";
  return CXParseError_Error;
}

CXString clang_format_configurationAsText(CXFormatStyle Style) {
  return extra::makeCXString(clang::format::configurationAsText(unwrapStyle(Style)));
}

CXString clang_format_sortIncludes(CXFormatStyle Style, const char *Code,
                                   const char *FileName) {
  llvm::StringRef C(Code);
  clang::tooling::Replacements R = clang::format::sortIncludes(
      unwrapStyle(Style), C, wholeFile(C), llvm::StringRef(FileName), nullptr);
  return applyToCode(C, R, "clang_format_sortIncludes");
}

CXString clang_format_formatReplacements(CXFormatStyle Style, const char *Code,
                                         const char *FileName, const unsigned *Offsets,
                                         const unsigned *Lengths,
                                         const char **Texts,
                                         unsigned NumReplacements) {
  llvm::StringRef C(Code);
  clang::tooling::Replacements In;
  if (!buildReplacements(In, llvm::StringRef(FileName), Offsets, Lengths, Texts,
                         NumReplacements, "clang_format_formatReplacements")) {
    return makeNullCXString();
  }
  llvm::Expected<clang::tooling::Replacements> Out =
      clang::format::formatReplacements(C, In, unwrapStyle(Style));
  if (!Out) {
    llvm::errs() << "clang_format_formatReplacements: "
                 << llvm::toString(Out.takeError()) << "\n";
    return makeNullCXString();
  }
  return applyToCode(C, *Out, "clang_format_formatReplacements");
}

CXString clang_format_cleanupAroundReplacements(CXFormatStyle Style, const char *Code,
                                                const char *FileName,
                                                const unsigned *Offsets,
                                                const unsigned *Lengths,
                                                const char **Texts,
                                                unsigned NumReplacements) {
  llvm::StringRef C(Code);
  clang::tooling::Replacements In;
  if (!buildReplacements(In, llvm::StringRef(FileName), Offsets, Lengths, Texts,
                         NumReplacements, "clang_format_cleanupAroundReplacements")) {
    return makeNullCXString();
  }
  llvm::Expected<clang::tooling::Replacements> Out =
      clang::format::cleanupAroundReplacements(C, In, unwrapStyle(Style));
  if (!Out) {
    llvm::errs() << "clang_format_cleanupAroundReplacements: "
                 << llvm::toString(Out.takeError()) << "\n";
    return makeNullCXString();
  }
  return applyToCode(C, *Out, "clang_format_cleanupAroundReplacements");
}

CXString clang_format_reformat(CXFormatStyle Style, const char *Code, const char *FileName,
                               bool *FormatComplete, unsigned *Line) {
  llvm::StringRef C(Code);
  clang::format::FormattingAttemptStatus Status;
  clang::tooling::Replacements R = clang::format::reformat(
      unwrapStyle(Style), C, wholeFile(C), llvm::StringRef(FileName), &Status);
  if (FormatComplete)
    *FormatComplete = Status.FormatComplete;
  if (Line)
    *Line = Status.Line;
  return applyToCode(C, R, "clang_format_reformat");
}

CXString clang_format_cleanup(CXFormatStyle Style, const char *Code, const char *FileName) {
  llvm::StringRef C(Code);
  clang::tooling::Replacements R = clang::format::cleanup(unwrapStyle(Style), C,
                                                          wholeFile(C),
                                                          llvm::StringRef(FileName));
  return applyToCode(C, R, "clang_format_cleanup");
}

CXString clang_format_fixNamespaceEndComments(CXFormatStyle Style, const char *Code,
                                              const char *FileName) {
  llvm::StringRef C(Code);
  clang::tooling::Replacements R = clang::format::fixNamespaceEndComments(
      unwrapStyle(Style), C, wholeFile(C), llvm::StringRef(FileName));
  return applyToCode(C, R, "clang_format_fixNamespaceEndComments");
}

CXString clang_format_sortUsingDeclarations(CXFormatStyle Style, const char *Code,
                                            const char *FileName) {
  llvm::StringRef C(Code);
  clang::tooling::Replacements R = clang::format::sortUsingDeclarations(
      unwrapStyle(Style), C, wholeFile(C), llvm::StringRef(FileName));
  return applyToCode(C, R, "clang_format_sortUsingDeclarations");
}

CXFormatStyle clang_format_getStyle(const char *StyleName, const char *FileName,
                                    const char *FallbackStyle, const char *Code,
                                    bool AllowUnknownOptions) {
  llvm::Expected<clang::format::FormatStyle> Style = clang::format::getStyle(
      llvm::StringRef(StyleName), llvm::StringRef(FileName),
      llvm::StringRef(FallbackStyle), llvm::StringRef(Code), nullptr,
      AllowUnknownOptions);
  if (!Style) {
    llvm::errs() << "clang_format_getStyle: " << llvm::toString(Style.takeError()) << "\n";
    return nullptr;
  }
  return boxStyle(*Style);
}

CXLanguageKind clang_format_guessLanguage(const char *FileName, const char *Code) {
  return static_cast<CXLanguageKind>(
      clang::format::guessLanguage(llvm::StringRef(FileName), llvm::StringRef(Code)));
}

CXString clang_format_getLanguageName(CXLanguageKind Language) {
  return extra::makeCXString(
      clang::format::getLanguageName(
          static_cast<clang::format::FormatStyle::LanguageKind>(Language))
          .str());
}
