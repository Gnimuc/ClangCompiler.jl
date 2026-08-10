#include "clang-ex/Basic/CXOperatorPrecedence.h"

#include "clang/Basic/OperatorPrecedence.h"

CXPrecLevel clang_getBinOpPrecedence(unsigned Kind, bool GreaterThanIsOperator,
                                     bool CPlusPlus11) {
  return static_cast<CXPrecLevel>(
      clang::getBinOpPrecedence(static_cast<clang::tok::TokenKind>(Kind),
                                GreaterThanIsOperator, CPlusPlus11));
}
