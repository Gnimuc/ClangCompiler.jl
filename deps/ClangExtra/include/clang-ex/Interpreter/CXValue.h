#ifndef LLVM_CLANG_C_EXTRA_CXVALUE_H
#define LLVM_CLANG_C_EXTRA_CXVALUE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXValue clang_value_create(void);

void clang_value_dispose(CXValue V);

CXValue clang_createValueFromType(CXInterpreter I, void *Ty);

void *clang_value_getType(CXValue V);

bool clang_value_isValid(CXValue V);

bool clang_value_isVoid(CXValue V);

bool clang_value_hasValue(CXValue V);

bool clang_value_isManuallyAlloc(CXValue V);

typedef enum {
  CXValue_Bool = 0,
  CXValue_Char_S,
  CXValue_SChar,
  CXValue_UChar,
  CXValue_Short,
  CXValue_UShort,
  CXValue_Int,
  CXValue_UInt,
  CXValue_Long,
  CXValue_ULong,
  CXValue_LongLong,
  CXValue_ULongLong,
  CXValue_Float,
  CXValue_Double,
  CXValue_LongDouble,
  CXValue_Void,
  CXValue_PtrOrObj,
  CXValue_Unspecified
} CXValueKind;

CXValueKind clang_value_getKind(CXValue V);

void clang_value_setKind(CXValue V, CXValueKind K);

void clang_value_setOpaqueType(CXValue V, void *Ty);

void *clang_value_getPtr(CXValue V);

void clang_value_setPtr(CXValue V, void *P);

#define REPL_BUILTIN_TYPES                                                                 \
  X(bool, Bool)                                                                            \
  X(char, Char_S)                                                                          \
  X(signed char, SChar)                                                                    \
  X(unsigned char, UChar)                                                                  \
  X(short, Short)                                                                          \
  X(unsigned short, UShort)                                                                \
  X(int, Int)                                                                              \
  X(unsigned int, UInt)                                                                    \
  X(long, Long)                                                                            \
  X(unsigned long, ULong)                                                                  \
  X(long long, LongLong)                                                                   \
  X(unsigned long long, ULongLong)                                                         \
  X(float, Float)                                                                          \
  X(double, Double)                                                                        \
  X(long double, LongDouble)

#define X(type, name)                                                                      \
  void clang_value_set##name(CXValue V, type Val);                                         \
  type clang_value_get##name(CXValue V);
REPL_BUILTIN_TYPES
#undef X

LLVM_CLANG_C_EXTERN_C_END

#endif