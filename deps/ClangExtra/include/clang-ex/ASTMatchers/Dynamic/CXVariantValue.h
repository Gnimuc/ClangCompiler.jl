#ifndef LLVM_CLANG_C_EXTRA_CXVARIANTVALUE_H
#define LLVM_CLANG_C_EXTRA_CXVARIANTVALUE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::ast_matchers::dynamic::VariantValue — the tagged union the matcher
// grammar's <Literal> and <NamedValue> rules evaluate to: bool, double,
// unsigned, string, or a matcher. Its only use from here is filling a
// CXNamedValueMap, which is what implements clang-query's
// `let name = <matcher>`: parse a matcher once, name it, and spell the name
// inside later query strings.
//
// VariantValue

// One constructor per alternative; C has no overloads, so the alternative is
// spelled in the name. Every result is caller-owned — release it with
// clang_VariantValue_dispose. clang_VariantValue_create makes the EMPTY value
// (hasValue false), which is the only one no accessor below reads.
CXVariantValue clang_VariantValue_create(void);

CXVariantValue clang_VariantValue_createBoolean(bool Boolean);

CXVariantValue clang_VariantValue_createDouble(double Double);

CXVariantValue clang_VariantValue_createUnsigned(unsigned Unsigned);

CXVariantValue clang_VariantValue_createString(const char *String);

// The matcher alternative, wrapped as VariantMatcher::SingleMatcher — the
// unambiguous case, which is what a parsed CXDynTypedMatcher always is. The
// matcher is COPIED into the value, so Matcher may be disposed afterwards.
CXVariantValue clang_VariantValue_createMatcher(CXDynTypedMatcher Matcher);

void clang_VariantValue_dispose(CXVariantValue V);

// The tag. Every getter below is partial: upstream asserts the matching
// is* predicate and reads the union member unchecked, so calling getBoolean on
// a string value is undefined behaviour, not an error return.
bool clang_VariantValue_hasValue(CXVariantValue V);

bool clang_VariantValue_isBoolean(CXVariantValue V);

bool clang_VariantValue_getBoolean(CXVariantValue V);

bool clang_VariantValue_isDouble(CXVariantValue V);

double clang_VariantValue_getDouble(CXVariantValue V);

bool clang_VariantValue_isUnsigned(CXVariantValue V);

unsigned clang_VariantValue_getUnsigned(CXVariantValue V);

bool clang_VariantValue_isString(CXVariantValue V);

CXString clang_VariantValue_getString(CXVariantValue V);

bool clang_VariantValue_isMatcher(CXVariantValue V);

// getMatcher folded with VariantMatcher::getSingleMatcher: an OWNED copy of the
// single matcher V holds, released with clang_DynTypedMatcher_dispose. NULL when
// V is not a matcher at all, and also when it holds a POLYMORPHIC matcher whose
// single representation is ambiguous — the same "no unambiguous answer" that
// upstream reports as an empty std::optional. Unlike the getters above this one
// is total, because the null return already carries the tag mismatch.
CXDynTypedMatcher clang_VariantValue_getSingleMatcher(CXVariantValue V);

// The name of the alternative held, for diagnostics ("String", "Matcher<Decl>",
// "Nothing"). Total.
CXString clang_VariantValue_getTypeAsString(CXVariantValue V);

// setBoolean / setDouble / setUnsigned / setString / setMatcher (the create
// family above covers every value this boundary can build)
// isNodeKind / getNodeKind / setNodeKind (ASTNodeKind does not cross; see
// clang-ex/ASTMatchers/CXASTMatchersInternal.h)
// isConvertibleTo (takes an ArgKind, which does not cross)

// Parser::NamedValueMap — llvm::StringMap<VariantValue>, the dictionary the
// parser resolves the grammar's <NamedValue> rule against. Caller-owned.
CXNamedValueMap clang_NamedValueMap_create(void);

void clang_NamedValueMap_dispose(CXNamedValueMap M);

// helper: insert-or-assign. Value is COPIED into the map, so it may be disposed
// afterwards; the map's own copy dies with the map.
void clang_NamedValueMap_set(CXNamedValueMap M, const char *Name, CXVariantValue Value);

unsigned clang_NamedValueMap_size(CXNamedValueMap M);

// helper: whether Name is bound, i.e. whether a query string may spell it.
bool clang_NamedValueMap_contains(CXNamedValueMap M, const char *Name);

LLVM_CLANG_C_EXTERN_C_END

#endif
