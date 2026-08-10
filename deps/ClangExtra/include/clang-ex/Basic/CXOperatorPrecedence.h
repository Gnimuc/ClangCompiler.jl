#ifndef LLVM_CLANG_C_EXTRA_CXOPERATORPRECEDENCE_H
#define LLVM_CLANG_C_EXTRA_CXOPERATORPRECEDENCE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirror of `clang::prec::Level` (clang/Basic/OperatorPrecedence.h): the binding strength
// of a binary or ternary operator, named for the C99 grammar production it belongs to. Low
// numbers bind more weakly. Synced by static_assert in lib/Basic/CXEnumSync.cpp.
typedef enum CXPrecLevel {
  CXPrecLevel_Unknown = 0,
  CXPrecLevel_Comma = 1,
  CXPrecLevel_Assignment = 2,
  CXPrecLevel_Conditional = 3,
  CXPrecLevel_LogicalOr = 4,
  CXPrecLevel_LogicalAnd = 5,
  CXPrecLevel_InclusiveOr = 6,
  CXPrecLevel_ExclusiveOr = 7,
  CXPrecLevel_And = 8,
  CXPrecLevel_Equality = 9,
  CXPrecLevel_Relational = 10,
  CXPrecLevel_Spaceship = 11,
  CXPrecLevel_Shift = 12,
  CXPrecLevel_Additive = 13,
  CXPrecLevel_Multiplicative = 14,
  CXPrecLevel_PointerToMember = 15
} CXPrecLevel;

// clang::getBinOpPrecedence. `Kind` is a raw clang::tok::TokenKind, the same currency
// clang_IdentifierInfo_getTokenID and the clang_tok_* helpers already use; a kind that is
// not a binary operator answers CXPrecLevel_Unknown, so the function is total over every
// unsigned.
//
// The two switches are the context the answer depends on: with GreaterThanIsOperator off,
// `>` closes a template argument list rather than comparing, and CPlusPlus11 is what makes
// `>>` a shift rather than two closing angle brackets.
CXPrecLevel clang_getBinOpPrecedence(unsigned Kind, bool GreaterThanIsOperator,
                                     bool CPlusPlus11);

LLVM_CLANG_C_EXTERN_C_END

#endif
