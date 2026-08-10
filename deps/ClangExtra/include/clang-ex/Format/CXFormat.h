#ifndef LLVM_CLANG_C_EXTRA_CXFORMAT_H
#define LLVM_CLANG_C_EXTRA_CXFORMAT_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::format -- namespace-level free functions; the namespace is the class segment of
// every `clang_format_*` name below. `clang::format::FormatStyle` is a plain copyable
// value struct with no pointer form, so it is heap-boxed: every function here that yields
// a style returns a caller-owned box, released with clang_FormatStyle_dispose.
//
// Marshalling contract for the reformat/sortIncludes/cleanup family: upstream returns a
// `tooling::Replacements`, an edit script tied to clang's tooling layer. None of that
// crosses this boundary. Each wrapper runs the entry point over the WHOLE of Code (one
// `tooling::Range(0, strlen(Code))`), applies the returned replacements internally with
// `tooling::applyAllReplacements`, and hands back the resulting text as a CXString. A NULL
// CXString means the attempt failed; the reason is logged to llvm::errs().

// clang/Format/Format.h: enum class clang::format::ParseError. This is the value carried
// by the std::error_code parseConfiguration returns; an error_code from any other category
// is reported as CXParseError_Error.
typedef enum CXParseError {
  CXParseError_Success = 0,
  CXParseError_Error,
  CXParseError_Unsuitable,
  CXParseError_BinPackTrailingCommaConflict,
  CXParseError_InvalidQualifierSpecified,
  CXParseError_DuplicateQualifierSpecified,
  CXParseError_MissingQualifierType,
  CXParseError_MissingQualifierOrder
} CXParseError;

// FormatStyle

// clang/Format/Format.h: enum FormatStyle::LanguageKind (declared `: int8_t` upstream; the
// underlying type is dropped here because the binding generator cannot read it).
typedef enum CXLanguageKind {
  CXLanguageKind_LK_None,
  CXLanguageKind_LK_Cpp,
  CXLanguageKind_LK_CSharp,
  CXLanguageKind_LK_Java,
  CXLanguageKind_LK_JavaScript,
  CXLanguageKind_LK_Json,
  CXLanguageKind_LK_ObjC,
  CXLanguageKind_LK_Proto,
  CXLanguageKind_LK_TableGen,
  CXLanguageKind_LK_TextProto,
  CXLanguageKind_LK_Verilog
} CXLanguageKind;

/// Release a style box obtained from any of the functions below.
void clang_FormatStyle_dispose(CXFormatStyle Style);

/// The language the style targets. parseConfiguration reads this field to pick the base
/// style when the YAML document carries a `BasedOnStyle` key, which is why it is settable.
CXLanguageKind clang_FormatStyle_getLanguage(CXFormatStyle Style);

void clang_FormatStyle_setLanguage(CXFormatStyle Style, CXLanguageKind Language);

/// Caller-owned; release with clang_FormatStyle_dispose.
CXFormatStyle clang_format_getLLVMStyle(CXLanguageKind Language);

/// Caller-owned; release with clang_FormatStyle_dispose.
CXFormatStyle clang_format_getGoogleStyle(CXLanguageKind Language);

// getChromiumStyle
// getMozillaStyle
// getWebKitStyle
// getGNUStyle
// getMicrosoftStyle
// getClangFormatStyle
// -- all six are reachable by name through clang_format_getPredefinedStyle.

/// The style that formats nothing at all. Caller-owned.
CXFormatStyle clang_format_getNoStyle(void);

/// One of the predefined styles by name ("LLVM", "Google", "Chromium", "Mozilla",
/// "WebKit", "GNU", "Microsoft", "clang-format", "none"), compared case-insensitively.
/// Returns NULL when the name is not one of them; caller-owned otherwise.
CXFormatStyle clang_format_getPredefinedStyle(const char *Name, CXLanguageKind Language);

/// Parse YAML-formatted configuration INTO an existing style box -- the StringRef overload
/// at Format.h:5031, which names the buffer "YAML". Options absent from the document keep
/// the value they already had in Style unless the document sets BasedOnStyle.
CXParseError clang_format_parseConfiguration(const char *Config, CXFormatStyle Style,
                                             bool AllowUnknownOptions);

/// Serialize Style back to a YAML document.
CXString clang_format_configurationAsText(CXFormatStyle Style);

/// Sort every #include block. Upstream's optional `Cursor` in/out parameter is not exposed.
CXString clang_format_sortIncludes(CXFormatStyle Style, const char *Code,
                                   const char *FileName);

/// Apply a caller-supplied edit script to Code and reformat the touched regions.
/// The script is three parallel arrays of length NumReplacements: byte Offsets into Code,
/// Lengths of the replaced ranges, and the replacement Texts.
///
/// Upstream returns llvm::Expected<tooling::Replacements>; a failure -- including an
/// order-dependent script, which tooling::Replacements::add rejects -- is logged and
/// yields a NULL CXString.
CXString clang_format_formatReplacements(CXFormatStyle Style, const char *Code,
                                         const char *FileName, const unsigned *Offsets,
                                         const unsigned *Lengths,
                                         const char **Texts,
                                         unsigned NumReplacements);

/// Like formatReplacements, but cleans up the code around the applied edits (dangling
/// commas, empty namespaces, redundant colons) instead of reformatting it.
///
/// This is also the #include manipulation entry point, through the UINT_MAX-offset
/// convention: an entry whose Offset is UINT_MAX and whose Length is 0 inserts its Text --
/// a whole `#include "..."` directive -- into the correct block, and one whose Offset is
/// UINT_MAX and whose Length is 1 removes the header its Text names.
CXString clang_format_cleanupAroundReplacements(CXFormatStyle Style, const char *Code,
                                                const char *FileName,
                                                const unsigned *Offsets,
                                                const unsigned *Lengths,
                                                const char **Texts,
                                                unsigned NumReplacements);

/// FormatComplete and Line are the two fields of clang::format::FormattingAttemptStatus,
/// split into out-parameters; either may be NULL. FormatComplete is false when a
/// non-recoverable syntax error left some of the code unformatted, and Line is then a
/// one-based, best-effort guess at the line where it is.
CXString clang_format_reformat(CXFormatStyle Style, const char *Code, const char *FileName,
                               bool *FormatComplete, unsigned *Line);

CXString clang_format_cleanup(CXFormatStyle Style, const char *Code, const char *FileName);

CXString clang_format_fixNamespaceEndComments(CXFormatStyle Style, const char *Code,
                                              const char *FileName);

// separateDefinitionBlocks -- declared at clang/Format/Format.h:5129 but NOT exported by
// the libclang-cpp this package builds against (`nm -gU` finds no such symbol), so a
// wrapper for it would fail at link time.

CXString clang_format_sortUsingDeclarations(CXFormatStyle Style, const char *Code,
                                            const char *FileName);

// getFormattingLangOpts

/// The clang-format `--style=` entry point: StyleName may be a predefined style name, an
/// inline `{key: value, ...}` document, "file" (search the parent directories of FileName
/// for a .clang-format) or "file:<path>". Code is used to guess the language when the file
/// name is not enough; pass "" when there is none. The real file system is used.
///
/// Upstream returns llvm::Expected<FormatStyle>: on failure the error is logged to
/// llvm::errs() and this returns NULL. Caller-owned otherwise.
CXFormatStyle clang_format_getStyle(const char *StyleName, const char *FileName,
                                    const char *FallbackStyle, const char *Code,
                                    bool AllowUnknownOptions);

/// Guess the language from a file name and the code it holds. Defaults to LK_Cpp.
CXLanguageKind clang_format_guessLanguage(const char *FileName, const char *Code);

/// A printable name for a language kind ("C++", "Json", ...). Header-only upstream, so it
/// is not a dylib export; the StringRef it returns is copied into the CXString.
CXString clang_format_getLanguageName(CXLanguageKind Language);

// isClangFormatOn
// isClangFormatOff

LLVM_CLANG_C_EXTERN_C_END

#endif
