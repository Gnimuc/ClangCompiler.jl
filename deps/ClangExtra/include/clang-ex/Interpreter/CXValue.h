#ifndef LLVM_CLANG_C_EXTRA_CXVALUE_H
#define LLVM_CLANG_C_EXTRA_CXVALUE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-c/CXString.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXValue clang_Value_create(void);

void clang_Value_dispose(CXValue V);

CXValue clang_createValueFromType(CXInterpreter I, void *Ty);

// clang 18 ships placeholder bodies for printType/printData/print: each emits one
// fixed "not implemented" line and reads nothing out of the value, so they are total.
// Only the presence of text is stable across LLVM versions, never its content.
CXString clang_Value_printType(CXValue V);

CXString clang_Value_printData(CXValue V);

CXString clang_Value_print(CXValue V);

// writes to llvm::outs()
void clang_Value_dump(CXValue V);

// resets the value to the unspecified kind, dropping its opaque type, its interpreter
// and — when the storage was manually allocated — the storage itself
void clang_Value_clear(CXValue V);

// UB when the value carries no interpreter: clang::Value::getASTContext dereferences
// its Interpreter member unconditionally, and that member is null in a
// default-constructed value and after clang_Value_clear. Gate on
// clang_Value_getInterpreter returning non-NULL.
CXASTContext clang_Value_getASTContext(CXValue V);

// returns NULL for a default-constructed value and after clang_Value_clear
CXInterpreter clang_Value_getInterpreter(CXValue V);

void *clang_Value_getType(CXValue V);

bool clang_Value_isValid(CXValue V);

bool clang_Value_isVoid(CXValue V);

bool clang_Value_hasValue(CXValue V);

bool clang_Value_isManuallyAlloc(CXValue V);

typedef enum {
  CXValue_Bool = 0,
  CXValue_Char_S,
  CXValue_SChar,
  CXValue_Char_U,
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

CXValueKind clang_Value_getKind(CXValue V);

void clang_Value_setKind(CXValue V, CXValueKind K);

void clang_Value_setOpaqueType(CXValue V, void *Ty);

void *clang_Value_getPtr(CXValue V);

void clang_Value_setPtr(CXValue V, void *P);

// Deliberately NOT named REPL_BUILTIN_TYPES: clang/Interpreter/Value.h defines
// a macro of that name (including long double), and whichever definition comes
// second would silently win inside a TU that includes both headers.
#define CXVALUE_ABI_TYPES                                                                  \
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
  X(double, Double)

#define X(type, name)                                                                      \
  void clang_Value_set##name(CXValue V, type Val);                                         \
  type clang_Value_get##name(CXValue V);
CXVALUE_ABI_TYPES
#undef X

// long double is not ABI-portable across the C boundary (80-bit x87 on
// x86_64, double on Apple aarch64); it crosses as double, converting inside
// the shim.
void clang_Value_setLongDouble(CXValue V, double Val);
double clang_Value_getLongDouble(CXValue V);

LLVM_CLANG_C_EXTERN_C_END

#endif