#ifndef LLVM_CLANG_C_EXTRA_CXOPTIONS_H
#define LLVM_CLANG_C_EXTRA_CXOPTIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirror of `llvm::opt::Option::OptionClass` (llvm/Option/Option.h): the shape of an
// option, i.e. how its value is written. Synced by static_assert in
// lib/Basic/CXEnumSync.cpp.
typedef enum CXOptionClass {
  CXOptionClass_GroupClass = 0,
  CXOptionClass_InputClass,
  CXOptionClass_UnknownClass,
  CXOptionClass_FlagClass,
  CXOptionClass_JoinedClass,
  CXOptionClass_ValuesClass,
  CXOptionClass_SeparateClass,
  CXOptionClass_RemainingArgsClass,
  CXOptionClass_RemainingArgsJoinedClass,
  CXOptionClass_CommaJoinedClass,
  CXOptionClass_MultiArgClass,
  CXOptionClass_JoinedOrSeparateClass,
  CXOptionClass_JoinedAndSeparateClass
} CXOptionClass;

// Mirror of `clang::driver::options::ClangVisibility` (clang/Driver/Options.h): the driver
// personality an option belongs to. These are the values a VisibilityMask argument below is
// built from; ORing several asks for the union, and ~0u for every option in the table.
// Synced by static_assert in lib/Basic/CXEnumSync.cpp.
typedef enum CXClangVisibility {
  CXClangVisibility_ClangOption = (1 << 0),
  CXClangVisibility_CLOption = (1 << 1),
  CXClangVisibility_CC1Option = (1 << 2),
  CXClangVisibility_CC1AsOption = (1 << 3),
  CXClangVisibility_FlangOption = (1 << 4),
  CXClangVisibility_FC1Option = (1 << 5),
  CXClangVisibility_DXCOption = (1 << 6)
} CXClangVisibility;

// clang::driver::getDriverOptTable() — the table of every option clang's driver
// understands, generated from Options.td. It is a function-local singleton with static
// storage duration: the handle is borrowed and there is no dispose.
CXOptTable clang_driver_getDriverOptTable(void);

// The number of options in the table. Valid option IDs run from 1 to this value inclusive
// (0 is OPT_INVALID); the table is indexed with no bounds check, so every id-taking entry
// point below requires that range and the Julia wrappers restate it.
unsigned clang_OptTable_getNumOptions(CXOptTable T);

// The option's name without any prefix, e.g. "std=" for -std=. Copied: clang answers with a
// StringRef into the table.
CXString clang_OptTable_getOptionName(CXOptTable T, unsigned Id);

// The option's help text, empty for an option that has none (clang stores a null pointer
// there, which most aliases do).
CXString clang_OptTable_getOptionHelpText(CXOptTable T, unsigned Id);

// The Option value for an ID, heap-boxed because llvm::opt::Option is a two-pointer value
// class rather than something with an address of its own. Caller-owned: release it with
// clang_Option_dispose. The box outliving the table would be a dangling read, but the table
// is a singleton, so it cannot.
CXOption clang_OptTable_getOption(CXOptTable T, unsigned Id);

void clang_Option_dispose(CXOption O);

// Whether the boxed option refers to an entry at all. False exactly for the option of
// OPT_INVALID, and the precondition of every accessor below — clang asserts on the rest.
bool clang_Option_isValid(CXOption O);

unsigned clang_Option_getID(CXOption O);

CXOptionClass clang_Option_getKind(CXOption O);

// The name without a prefix, and the name with the option's default prefix ("-std=").
CXString clang_Option_getName(CXOption O);
CXString clang_Option_getPrefixedName(CXOption O);

// The nearest option to a misspelled one — the "did you mean" engine. Returns the edit
// distance (0 for an exact match, UINT_MAX when nothing is near enough) and writes the
// spelling it found into the returned string, which is empty when nothing was found.
//
// `VisibilityMask` is an OR of CXClangVisibility values, ~0u for the whole table. This is
// the Visibility overload rather than the FlagsToInclude/FlagsToExclude one; both exist in
// LLVM 18 and only this one survives.
CXString clang_OptTable_findNearest(CXOptTable T, const char *Option,
                                    unsigned VisibilityMask, unsigned MinimumLength,
                                    unsigned MaximumDistance, unsigned *Distance);

// The whole help screen, rendered into a string instead of a stream. Same Visibility
// overload note as findNearest.
CXString clang_OptTable_printHelp(CXOptTable T, const char *Usage, const char *Title,
                                  bool ShowHidden, bool ShowAllAliases,
                                  unsigned VisibilityMask);

LLVM_CLANG_C_EXTERN_C_END

#endif
