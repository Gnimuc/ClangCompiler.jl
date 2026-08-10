#ifndef LLVM_CLANG_C_EXTRA_CXDEPENDENCYDIRECTIVESSCANNER_H
#define LLVM_CLANG_C_EXTRA_CXDEPENDENCYDIRECTIVESSCANNER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/Lex/DependencyDirectivesScanner.h: enum
// clang::dependency_directives_scan::DirectiveKind. The kind of preprocessor directive (or
// module declaration) the scanner tracks in its token output.
typedef enum CXDependencyDirectiveKind : unsigned char {
  CXDependencyDirectiveKind_pp_none,
  CXDependencyDirectiveKind_pp_include,
  CXDependencyDirectiveKind_pp___include_macros,
  CXDependencyDirectiveKind_pp_define,
  CXDependencyDirectiveKind_pp_undef,
  CXDependencyDirectiveKind_pp_import,
  CXDependencyDirectiveKind_pp_pragma_import,
  CXDependencyDirectiveKind_pp_pragma_once,
  CXDependencyDirectiveKind_pp_pragma_push_macro,
  CXDependencyDirectiveKind_pp_pragma_pop_macro,
  CXDependencyDirectiveKind_pp_pragma_include_alias,
  CXDependencyDirectiveKind_pp_pragma_system_header,
  CXDependencyDirectiveKind_pp_include_next,
  CXDependencyDirectiveKind_pp_if,
  CXDependencyDirectiveKind_pp_ifdef,
  CXDependencyDirectiveKind_pp_ifndef,
  CXDependencyDirectiveKind_pp_elif,
  CXDependencyDirectiveKind_pp_elifdef,
  CXDependencyDirectiveKind_pp_elifndef,
  CXDependencyDirectiveKind_pp_else,
  CXDependencyDirectiveKind_pp_endif,
  CXDependencyDirectiveKind_decl_at_import,
  CXDependencyDirectiveKind_cxx_module_decl,
  CXDependencyDirectiveKind_cxx_import_decl,
  CXDependencyDirectiveKind_cxx_export_module_decl,
  CXDependencyDirectiveKind_cxx_export_import_decl,
  // there are tokens between the last scanned directive and eof; the directive's token
  // range is empty for this kind
  CXDependencyDirectiveKind_tokens_present_before_eof,
  CXDependencyDirectiveKind_pp_eof
} CXDependencyDirectiveKind;

// Scans a source buffer down to the preprocessor directives that can affect what a
// translation unit includes -- #define, #include, #import, @import, the C++20 module
// declarations, and the conditional logic wrapping any of them -- without building a
// Preprocessor, a SourceManager or a FileManager. This is the primitive clang's own
// dependency scanner is built on, and it is cheap enough to re-run whenever a file changes.
//
// One scan is one handle. It owns a copy of the input, the flat token vector and the
// directive vector, because each directive's token range is a view into that vector: the
// three cannot be handed out separately without the views dangling.

// Runs the scan and boxes its result. `Diags` may be NULL, which discards the errors a
// malformed directive would report; `InputSourceLoc` is where offset 0 of `Input` lives
// and is only used to place those diagnostics, so an invalid location is fine when `Diags`
// is NULL. `*HadError` receives whether the scan failed -- the handle is still valid and
// holds whatever was scanned before the failure. Release with
// `clang_DependencyDirectivesScan_dispose`.
CXDependencyDirectivesScan
clang_DependencyDirectivesScan_create(const char *Input, size_t Len,
                                      CXDiagnosticsEngine Diags,
                                      CXSourceLocation_ InputSourceLoc, bool *HadError);

void clang_DependencyDirectivesScan_dispose(CXDependencyDirectivesScan S);

unsigned clang_DependencyDirectivesScan_getNumTokens(CXDependencyDirectivesScan S);

// Reads token `I`, which must be < `getNumTokens`: `*Offset` and `*Length` delimit it in
// the original input, `*Kind` is its raw `clang::tok::TokenKind` value and `*Flags` its
// raw `clang::Token::TokenFlags` bitmask (CXTokenFlags in CXToken.h names the bits).
void clang_DependencyDirectivesScan_getToken(CXDependencyDirectivesScan S, unsigned I,
                                             unsigned *Offset, unsigned *Length,
                                             unsigned *Kind, unsigned *Flags);

unsigned clang_DependencyDirectivesScan_getNumDirectives(CXDependencyDirectivesScan S);

// `I` must be < `getNumDirectives` for these three.
CXDependencyDirectiveKind
clang_DependencyDirectivesScan_getDirectiveKind(CXDependencyDirectivesScan S, unsigned I);

unsigned clang_DependencyDirectivesScan_getNumDirectiveTokens(CXDependencyDirectivesScan S,
                                                              unsigned I);

// Index into the flat token array of directive `I`'s first token; 0 when it has none.
unsigned
clang_DependencyDirectivesScan_getDirectiveFirstTokenIndex(CXDependencyDirectivesScan S,
                                                           unsigned I);

// The minimized source the scanned directives render back to.
CXString clang_DependencyDirectivesScan_printAsSource(CXDependencyDirectivesScan S);

LLVM_CLANG_C_EXTERN_C_END

#endif
