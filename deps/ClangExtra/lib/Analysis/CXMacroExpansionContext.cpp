#include "clang-ex/Analysis/CXMacroExpansionContext.h"
#include "utils.h"
#include "clang/Analysis/MacroExpansionContext.h"
#include "clang/Basic/LangOptions.h"
#include "clang/Basic/SourceLocation.h"
#include "clang/Lex/Preprocessor.h"
#include "llvm/Support/raw_ostream.h"
#include <memory>
#include <optional>
#include <string>

namespace {

// The disengaged std::optional<StringRef> arm: a CXString whose data pointer is NULL, so
// clang_getCString reports NULL rather than the empty string an expansion that produced no
// tokens legitimately has. private_flags 0 is CXS_Unmanaged, so disposing it is a no-op.
CXString makeNullCXString() {
  CXString Str;
  Str.data = nullptr;
  Str.private_flags = 0;
  return Str;
}

} // namespace

// MacroExpansionContext

CXMacroExpansionContext clang_MacroExpansionContext_create(CXLangOptions LangOpts) {
  return reinterpret_cast<CXMacroExpansionContext>(
      std::make_unique<clang::MacroExpansionContext>(
          *reinterpret_cast<clang::LangOptions *>(LangOpts))
          .release());
}

void clang_MacroExpansionContext_dispose(CXMacroExpansionContext MEC) {
  delete reinterpret_cast<clang::MacroExpansionContext *>(MEC);
}

void clang_MacroExpansionContext_registerForPreprocessor(CXMacroExpansionContext MEC,
                                                         CXPreprocessor PP) {
  reinterpret_cast<clang::MacroExpansionContext *>(MEC)->registerForPreprocessor(
      *reinterpret_cast<clang::Preprocessor *>(PP));
}

CXString clang_MacroExpansionContext_getExpandedText(CXMacroExpansionContext MEC,
                                                     CXSourceLocation_ MacroExpansionLoc) {
  std::optional<llvm::StringRef> Text =
      reinterpret_cast<clang::MacroExpansionContext *>(MEC)->getExpandedText(
          clang::SourceLocation::getFromPtrEncoding(MacroExpansionLoc));
  if (!Text)
    return makeNullCXString();
  return extra::makeCXString(Text->str());
}

CXString clang_MacroExpansionContext_getOriginalText(CXMacroExpansionContext MEC,
                                                     CXSourceLocation_ MacroExpansionLoc) {
  std::optional<llvm::StringRef> Text =
      reinterpret_cast<clang::MacroExpansionContext *>(MEC)->getOriginalText(
          clang::SourceLocation::getFromPtrEncoding(MacroExpansionLoc));
  if (!Text)
    return makeNullCXString();
  return extra::makeCXString(Text->str());
}

CXString
clang_MacroExpansionContext_dumpExpansionRangesToString(CXMacroExpansionContext MEC) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::MacroExpansionContext *>(MEC)->dumpExpansionRangesToStream(OS);
  return extra::makeCXString(OS.str());
}

CXString
clang_MacroExpansionContext_dumpExpandedTextsToString(CXMacroExpansionContext MEC) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::MacroExpansionContext *>(MEC)->dumpExpandedTextsToStream(OS);
  return extra::makeCXString(OS.str());
}

void clang_MacroExpansionContext_dumpExpansionRanges(CXMacroExpansionContext MEC) {
  reinterpret_cast<clang::MacroExpansionContext *>(MEC)->dumpExpansionRanges();
}

void clang_MacroExpansionContext_dumpExpandedTexts(CXMacroExpansionContext MEC) {
  reinterpret_cast<clang::MacroExpansionContext *>(MEC)->dumpExpandedTexts();
}
