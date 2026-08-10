#ifndef LLVM_CLANG_C_EXTRA_CXMACROEXPANSIONCONTEXT_H
#define LLVM_CLANG_C_EXTRA_CXMACROEXPANSIONCONTEXT_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// MacroExpansionContext
// Records what every macro expansion in one translation unit turned into, so a
// SourceLocation can later be mapped to the text that was substituted there.
//
// ORDERING CONSTRAINT — read this before wrapping anything around it. The context learns
// nothing by inspecting a finished AST: it works by installing PPCallbacks and a token
// watcher on the Preprocessor, so clang_MacroExpansionContext_registerForPreprocessor MUST
// run BEFORE the code whose macros are of interest is preprocessed. Register it on a
// freshly built Preprocessor and only then parse; anything already lexed is invisible to
// it, and both getters simply report "no macro here" for those locations.
//
// LIFETIME: registerForPreprocessor hands the Preprocessor pointers back into this object,
// so the context must OUTLIVE the Preprocessor; and the constructor stores
// `const LangOptions &`, so the LangOptions must outlive the context. It also calls
// clang::Preprocessor::setTokenWatcher, which holds exactly one watcher — registering a
// second MacroExpansionContext on the same Preprocessor silently unhooks the first one's
// token collection.

// LangOpts must not be NULL. The context is CALLER-OWNED — pair with
// clang_MacroExpansionContext_dispose, after the Preprocessor it was registered on is
// gone.
CXMacroExpansionContext clang_MacroExpansionContext_create(CXLangOptions LangOpts);

void clang_MacroExpansionContext_dispose(CXMacroExpansionContext MEC);

// Install the recording callbacks on PP. Neither argument may be NULL. See the ordering
// constraint above: call this before PP lexes the tokens of interest.
void clang_MacroExpansionContext_registerForPreprocessor(CXMacroExpansionContext MEC,
                                                         CXPreprocessor PP);

// The text the macro expanded at MacroExpansionLoc was replaced by, after the whole
// expansion chain. std::optional<StringRef> crosses as a NULL CXString for the disengaged
// case (MARSHALLING.md §8): clang_getCString reports NULL, which is distinct from the
// engaged-but-empty answer an expansion producing no tokens gives. Disengaged means
// MacroExpansionLoc is a macro-ID location, or no expansion was recorded there — which
// includes every location preprocessed before registerForPreprocessor ran.
CXString clang_MacroExpansionContext_getExpandedText(CXMacroExpansionContext MEC,
                                                     CXSourceLocation_ MacroExpansionLoc);

// The original spelling that the expansion at MacroExpansionLoc replaced, taken back out
// of the source buffer. Same NULL-CXString convention for the disengaged optional.
CXString clang_MacroExpansionContext_getOriginalText(CXMacroExpansionContext MEC,
                                                     CXSourceLocation_ MacroExpansionLoc);

// clang::MacroExpansionContext::dumpExpansionRangesToStream rendered into a CXString: one
// line per recorded expansion, giving the substituted source range. All four dump entry
// points print each location through the context's SourceManager, which
// registerForPreprocessor is what installs — but the print sits inside the per-record
// loop, and an unregistered context has recorded no records, so there is no reachable
// null dereference and no precondition beyond the ordering constraint above. Each
// rendering opens with a header line, so the output of an empty context is not the empty
// string. // helper
CXString
clang_MacroExpansionContext_dumpExpansionRangesToString(CXMacroExpansionContext MEC);

// clang::MacroExpansionContext::dumpExpandedTextsToStream rendered into a CXString: one
// line per recorded expansion, giving the expanded text. // helper
CXString
clang_MacroExpansionContext_dumpExpandedTextsToString(CXMacroExpansionContext MEC);

// The same two renderings written straight to llvm::errs().
void clang_MacroExpansionContext_dumpExpansionRanges(CXMacroExpansionContext MEC);

void clang_MacroExpansionContext_dumpExpandedTexts(CXMacroExpansionContext MEC);

LLVM_CLANG_C_EXTERN_C_END

#endif
