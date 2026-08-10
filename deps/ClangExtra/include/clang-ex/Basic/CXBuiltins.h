#ifndef LLVM_CLANG_C_EXTRA_CXBUILTINS_H
#define LLVM_CLANG_C_EXTRA_CXBUILTINS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/Basic/Builtins.h: enum BuiltinTemplateKind
typedef enum CXBuiltinTemplateKind {
  CXBuiltinTemplateKind_BTK__make_integer_seq,
  CXBuiltinTemplateKind_BTK__type_pack_element
} CXBuiltinTemplateKind;

// clang::Builtin::Context. The class segment spells the handle rather than the bare C++
// class name (`Context` in namespace `Builtin`), which alone would say nothing. Reach the
// one the preprocessor owns with clang_Preprocessor_getBuiltinInfo; it is borrowed and has
// no dispose.
//
// Every accessor below is keyed on a builtin ID, which is what
// clang_IdentifierInfo_getBuiltinID and clang_FunctionDecl_getBuiltinID hand out. clang
// looks the ID up in a table without a bounds check, and the ID 0 entry (Builtin::
// NotBuiltin) carries null Type and Attributes strings that the predicates walk with
// strchr, so an out-of-range or zero ID is undefined behaviour rather than a false answer.
// The Julia wrappers are what rule those out.

// helper: clang::Builtin::FirstTSBuiltin, the first ID that belongs to a target-specific
// table rather than the target-independent one. IDs strictly between 0 and this value are
// always in range; above it the count depends on the target the Context was initialized
// for and only clang knows it.
unsigned clang_Builtin_getFirstTSBuiltinID(void);

// "__builtin_abs" and friends. Always non-empty for an in-range ID.
CXString clang_BuiltinContext_getName(CXBuiltinContext C, unsigned ID);

// The type descriptor string clang encodes the signature in, e.g. "v." for a variadic
// void. Empty for Builtin::NotBuiltin, which has no signature.
CXString clang_BuiltinContext_getTypeString(CXBuiltinContext C, unsigned ID);

// The header a library builtin is documented to come from, e.g. "stdio.h". Empty when the
// builtin belongs to no header (HeaderDesc::NO_HEADER), which is the common case.
CXString clang_BuiltinContext_getHeaderName(CXBuiltinContext C, unsigned ID);

// Whether the ID belongs to a target-specific builtin table rather than the
// target-independent one. Unlike the predicates below this is a bare comparison and does
// not read the record.
bool clang_BuiltinContext_isTSBuiltin(CXBuiltinContext C, unsigned ID);

// The attribute-letter predicates: each tests one letter of the record's Attributes
// string.
bool clang_BuiltinContext_isConst(CXBuiltinContext C, unsigned ID);
bool clang_BuiltinContext_isNoThrow(CXBuiltinContext C, unsigned ID);
bool clang_BuiltinContext_isNoReturn(CXBuiltinContext C, unsigned ID);
bool clang_BuiltinContext_isPure(CXBuiltinContext C, unsigned ID);
bool clang_BuiltinContext_isLibFunction(CXBuiltinContext C, unsigned ID);
bool clang_BuiltinContext_isPredefinedLibFunction(CXBuiltinContext C, unsigned ID);
bool clang_BuiltinContext_isConstWithoutErrnoAndExceptions(CXBuiltinContext C,
                                                           unsigned ID);

// Whether a pointer appears in the signature; a test over the Type string rather than the
// Attributes one.
bool clang_BuiltinContext_hasPtrArgsOrResult(CXBuiltinContext C, unsigned ID);

// Whether the builtin follows printf's / scanf's format rules and, when it does, which
// argument is the format string and whether it takes a va_list. Both out-parameters may be
// NULL; they are written only when the predicate answers true, and clang leaves them
// untouched otherwise.
bool clang_BuiltinContext_isPrintfLike(CXBuiltinContext C, unsigned ID,
                                       unsigned *FormatIdx, bool *HasVAListArg);

bool clang_BuiltinContext_isScanfLike(CXBuiltinContext C, unsigned ID,
                                      unsigned *FormatIdx, bool *HasVAListArg);

LLVM_CLANG_C_EXTERN_C_END

#endif
