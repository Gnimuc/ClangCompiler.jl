#ifndef LLVM_CLANG_C_EXTRA_CXOPERATORKINDS_H
#define LLVM_CLANG_C_EXTRA_CXOPERATORKINDS_H

#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

typedef enum CXOverloadedOperatorKind : int {
  CXOverloadedOperatorKind_OO_None,
  CXOverloadedOperatorKind_OO_New,
  CXOverloadedOperatorKind_OO_Delete,
  CXOverloadedOperatorKind_OO_Array_New,
  CXOverloadedOperatorKind_OO_Array_Delete,
  CXOverloadedOperatorKind_OO_Plus,
  CXOverloadedOperatorKind_OO_Minus,
  CXOverloadedOperatorKind_OO_Star,
  CXOverloadedOperatorKind_OO_Slash,
  CXOverloadedOperatorKind_OO_Percent,
  CXOverloadedOperatorKind_OO_Caret,
  CXOverloadedOperatorKind_OO_Amp,
  CXOverloadedOperatorKind_OO_Pipe,
  CXOverloadedOperatorKind_OO_Tilde,
  CXOverloadedOperatorKind_OO_Exclaim,
  CXOverloadedOperatorKind_OO_Equal,
  CXOverloadedOperatorKind_OO_Less,
  CXOverloadedOperatorKind_OO_Greater,
  CXOverloadedOperatorKind_OO_PlusEqual,
  CXOverloadedOperatorKind_OO_MinusEqual,
  CXOverloadedOperatorKind_OO_StarEqual,
  CXOverloadedOperatorKind_OO_SlashEqual,
  CXOverloadedOperatorKind_OO_PercentEqual,
  CXOverloadedOperatorKind_OO_CaretEqual,
  CXOverloadedOperatorKind_OO_AmpEqual,
  CXOverloadedOperatorKind_OO_PipeEqual,
  CXOverloadedOperatorKind_OO_LessLess,
  CXOverloadedOperatorKind_OO_GreaterGreater,
  CXOverloadedOperatorKind_OO_LessLessEqual,
  CXOverloadedOperatorKind_OO_GreaterGreaterEqual,
  CXOverloadedOperatorKind_OO_EqualEqual,
  CXOverloadedOperatorKind_OO_ExclaimEqual,
  CXOverloadedOperatorKind_OO_LessEqual,
  CXOverloadedOperatorKind_OO_GreaterEqual,
  CXOverloadedOperatorKind_OO_Spaceship,
  CXOverloadedOperatorKind_OO_AmpAmp,
  CXOverloadedOperatorKind_OO_PipePipe,
  CXOverloadedOperatorKind_OO_PlusPlus,
  CXOverloadedOperatorKind_OO_MinusMinus,
  CXOverloadedOperatorKind_OO_Comma,
  CXOverloadedOperatorKind_OO_ArrowStar,
  CXOverloadedOperatorKind_OO_Arrow,
  CXOverloadedOperatorKind_OO_Call,
  CXOverloadedOperatorKind_OO_Subscript,
  CXOverloadedOperatorKind_OO_Conditional,
  CXOverloadedOperatorKind_OO_Coawait,
} CXOverloadedOperatorKind;

const char *clang_getOperatorSpelling(CXOverloadedOperatorKind Operator);

LLVM_CLANG_C_EXTERN_C_END

#endif