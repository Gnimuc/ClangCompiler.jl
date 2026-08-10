#ifndef LLVM_CLANG_C_EXTRA_CXDYNAMICPARSER_H
#define LLVM_CLANG_C_EXTRA_CXDYNAMICPARSER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::ast_matchers::dynamic — the string front end to the matcher DSL, the
// one that clang-query is built on. The static DSL is ~700 variadic function
// templates and so has no callable addresses; the Registry the parser consults
// holds a descriptor for every one of them, so a matcher spelled as TEXT
// ("cxxRecordDecl(hasName(\"Foo\")).bind(\"r\")") reaches all of them through
// this one entry point.
//
// NOTE on the name: the class segment below is clang::ast_matchers::dynamic::
// Parser, copied verbatim as the convention requires. It is a different class
// from clang::Parser, whose wrappers live in clang-ex/Parse/CXParser.h; the two
// share no function name.

// Diagnostics

// The error sink every parse writes into. Caller-owned; one may be reused across
// parses, in which case the errors accumulate.
CXMatcherDiagnostics clang_MatcherDiagnostics_create(void);

void clang_MatcherDiagnostics_dispose(CXMatcherDiagnostics D);

// helper: errors().size(). Zero after a successful parse; the toString pair
// below is empty exactly when this is zero.
unsigned clang_MatcherDiagnostics_getNumErrors(CXMatcherDiagnostics D);

// One line per error, message only.
CXString clang_MatcherDiagnostics_toString(CXMatcherDiagnostics D);

// One line per error with the full context chain ("Error parsing argument 1 for
// matcher hasName" and so on) — what clang-query prints.
CXString clang_MatcherDiagnostics_toStringFull(CXMatcherDiagnostics D);

// addError / errors / printToStream / printToStreamFull (the ArgStream and
// ErrorContent structures stay inside)

// Parser

// Parse MatcherCode into an OWNED CXDynTypedMatcher, release it with
// clang_DynTypedMatcher_dispose. NULL on failure, with the reason in Error.
//
// The Sema* the 4-argument upstream overload takes is always null here, which
// selects the default RegistrySema — the whole registry, no interception.
// NamedValues may be NULL; when it is not, its entries are the dictionary for
// the grammar's <NamedValue> rule, i.e. clang-query's `let name = matcher`
// (see clang-ex/ASTMatchers/Dynamic/CXVariantValue.h). Error must NOT be NULL:
// the parser writes through it without checking.
CXDynTypedMatcher clang_Parser_parseMatcherExpression(const char *MatcherCode,
                                                      CXNamedValueMap NamedValues,
                                                      CXMatcherDiagnostics Error);

// parseExpression (yields a VariantValue rather than a matcher; the matcher case
// is the one above, and a named value is built directly in CXVariantValue.h)

// Code completion at a byte offset into Code — matcher-name completion for a
// REPL. CompletionOffset 0 enumerates every root matcher the pinned LLVM knows,
// which is also the only way to list them without hand-maintaining the list.
// Returns an OWNED list (possibly empty, never NULL) to release with
// clang_MatcherCompletionList_dispose. Errors are not reported: an unparsable
// prefix simply yields no completions.
CXMatcherCompletionList clang_Parser_completeExpression(const char *Code,
                                                        unsigned CompletionOffset,
                                                        CXNamedValueMap NamedValues);

// MatcherCompletion (clang/ASTMatchers/Dynamic/Registry.h) — the parser returns
// these by value in a std::vector, which is heap-boxed whole rather than one
// handle per element; the three fields are read out by index.
void clang_MatcherCompletionList_dispose(CXMatcherCompletionList L);

unsigned clang_MatcherCompletionList_getNumCompletions(CXMatcherCompletionList L);

// The text to type to select this matcher. Out-of-range Index yields "".
CXString clang_MatcherCompletionList_getTypedText(CXMatcherCompletionList L, unsigned Index);

// The matcher's "declaration" with its type information, for display.
CXString clang_MatcherCompletionList_getMatcherDecl(CXMatcherCompletionList L, unsigned Index);

// How specific the conversion behind this completion is; zero means it would
// produce a matcher that always or never matches. Out-of-range Index yields 0.
unsigned clang_MatcherCompletionList_getSpecificity(CXMatcherCompletionList L, unsigned Index);

LLVM_CLANG_C_EXTERN_C_END

#endif
