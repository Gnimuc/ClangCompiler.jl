#ifndef LLVM_CLANG_C_EXTRA_CXDRIVERTYPES_H
#define LLVM_CLANG_C_EXTRA_CXDRIVERTYPES_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::driver::types and clang::driver::phases — how the driver classifies an input and
// what it would do with it. The file is named CXDriverTypes rather than CXTypes because
// clang-ex/CXTypes.h already owns that spelling and its include guard.
//
// A types::ID crosses as a raw unsigned: the enumeration is X-macro-generated from
// clang/Driver/Types.def and runs to some eighty entries that no caller spells by name.
// What a caller does instead is obtain one — from clang_ToolChain_LookupTypeForExtension,
// clang_Command_getInputInfoType, or clang_types_lookupTypeForExtension below — and ask
// these predicates about it.
//
// clang indexes its type table with no bounds check and no zero check, so every function
// taking an Id requires 0 < Id < clang_types_getLastTypeID(). TY_INVALID is 0 and is what
// the two lookups answer when they recognise nothing; it is NOT a legal input here.

// Mirror of `clang::driver::phases::ID` (clang/Driver/Phases.h): the successive stages a
// driver input goes through. Ordered, and clang compares them with <=. The companion
// anonymous `MaxNumberOfPhases` is a computed sentinel, so it stays out of the enum and is
// reachable as clang_phases_getMaxNumberOfPhases instead. Synced by static_assert in
// lib/Basic/CXEnumSync.cpp.
typedef enum CXPhaseID {
  CXPhaseID_Preprocess,
  CXPhaseID_Precompile,
  CXPhaseID_Compile,
  CXPhaseID_Backend,
  CXPhaseID_Assemble,
  CXPhaseID_Link,
  CXPhaseID_IfsMerge
} CXPhaseID;

// helper: clang::driver::types::TY_LAST, the one-past-the-end sentinel that closes the
// type enumeration. Exposed so the Julia wrappers can restate clang's own bound.
unsigned clang_types_getLastTypeID(void);

// helper: clang::driver::phases::MaxNumberOfPhases, which is how large a buffer
// clang_types_getCompilationPhases can ever need.
unsigned clang_phases_getMaxNumberOfPhases(void);

// The human-readable name of the type, e.g. "c++" or "objective-c-header".
const char *clang_types_getTypeName(unsigned Id);

// The type this input becomes once preprocessed, or TY_INVALID when it is not preprocessed.
unsigned clang_types_getPreprocessedType(unsigned Id);

// The extension a temporary of this type gets, without its dot, or NULL when the type has
// none. `CLStyle` asks for the clang-cl spelling.
const char *clang_types_getTypeTempSuffix(unsigned Id, bool CLStyle);

// The classification predicates.
bool clang_types_isCXX(unsigned Id);
bool clang_types_isSrcFile(unsigned Id);
bool clang_types_isLLVMIR(unsigned Id);
bool clang_types_isAcceptedByClang(unsigned Id);

// The type to use for a file with extension `Ext` (no dot), or TY_INVALID for an extension
// the driver does not recognise. Total over every string.
unsigned clang_types_lookupTypeForExtension(const char *Ext);

// The type a `-x <Name>` names, or TY_INVALID for a name the driver does not recognise.
// Total over every string.
unsigned clang_types_lookupTypeForTypeSpecifier(const char *Name);

// The phases the driver would run for this type, up to and including `LastPhase`, written
// into `Buf` as CXPhaseID values. Returns how many there are; at most min(N, count) are
// written, and a buffer of clang_phases_getMaxNumberOfPhases() entries is always enough.
unsigned clang_types_getCompilationPhases(unsigned Id, CXPhaseID LastPhase, CXPhaseID *Buf,
                                          unsigned N);

// The name of a compilation phase, e.g. "preprocessor". Total over the mirrored enum;
// clang llvm_unreachable's on anything outside it, which is what the enum rules out.
const char *clang_phases_getPhaseName(CXPhaseID Id);

LLVM_CLANG_C_EXTERN_C_END

#endif
