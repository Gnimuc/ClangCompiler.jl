#include "clang-ex/Interpreter/CXValue.h"
#include "utils.h"
#include "clang/Interpreter/Interpreter.h"
#include "clang/Interpreter/Value.h"
#include "llvm/Support/raw_ostream.h"

#include <memory>

// Drift alarm: CXValueKind is hand-mirrored from clang::Value::Kind, which clang builds by
// expanding the REPL_BUILTIN_TYPES X-macro and then appending K_Void, K_PtrOrObj and
// K_Unspecified. Mirroring it by hand is what makes it driftable, and unlike the .inc-stamped
// families it has no CXEnumSync.cpp entry either, so nothing else in the build would notice.
//
// It is not a hypothetical: LLVM 20 inserts X(unsigned char, Char_U) between SChar and UChar,
// shifting every value from UChar onward by one. Unguarded, a port would compile clean and
// `clang_Value_getKind` would answer K_Int where the Julia side reads CXValue_Long. Expanding
// the macro over the mirror is what turns that into a build error -- on LLVM 20 the line below
// asks for CXValue_Char_U, which does not exist.
#define X(type, name)                                                                      \
  static_assert(static_cast<int>(CXValue_##name) == static_cast<int>(clang::Value::K_##name), \
                "CXValueKind drift: " #name);
REPL_BUILTIN_TYPES
#undef X
static_assert(static_cast<int>(CXValue_Void) == static_cast<int>(clang::Value::K_Void),
              "CXValueKind drift: Void");
static_assert(static_cast<int>(CXValue_PtrOrObj) == static_cast<int>(clang::Value::K_PtrOrObj),
              "CXValueKind drift: PtrOrObj");
static_assert(static_cast<int>(CXValue_Unspecified) ==
                  static_cast<int>(clang::Value::K_Unspecified),
              "CXValueKind drift: Unspecified");

namespace {
enum : int {
  CXValueKindCount = 3 // Void, PtrOrObj, Unspecified
#define X(type, name) +1
  REPL_BUILTIN_TYPES
#undef X
};
} // namespace
// K_Unspecified is last, so its ordinal is one less than the count -- this is what catches a
// builtin appended to the END of REPL_BUILTIN_TYPES, which the per-name asserts would miss.
static_assert(CXValueKindCount - 1 == static_cast<int>(clang::Value::K_Unspecified),
              "CXValueKind drift: clang::Value::Kind has gained a variant");

CXValue clang_Value_create(void) {
  auto V = std::make_unique<clang::Value>();
  return reinterpret_cast<CXValue>(V.release());
}

void clang_Value_dispose(CXValue V) { delete reinterpret_cast<clang::Value *>(V); }

CXValue clang_createValueFromType(CXInterpreter I, void *Ty) {
  auto V = std::make_unique<clang::Value>(reinterpret_cast<clang::Interpreter *>(I), Ty);
  return reinterpret_cast<CXValue>(V.release());
}

CXString clang_Value_printType(CXValue V) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::Value *>(V)->printType(OS);
  return extra::makeCXString(S);
}

CXString clang_Value_printData(CXValue V) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::Value *>(V)->printData(OS);
  return extra::makeCXString(S);
}

CXString clang_Value_print(CXValue V) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::Value *>(V)->print(OS);
  return extra::makeCXString(S);
}

void clang_Value_dump(CXValue V) { reinterpret_cast<clang::Value *>(V)->dump(); }

void clang_Value_clear(CXValue V) { reinterpret_cast<clang::Value *>(V)->clear(); }

CXASTContext clang_Value_getASTContext(CXValue V) {
  return reinterpret_cast<CXASTContext>(&reinterpret_cast<clang::Value *>(V)->getASTContext());
}

CXInterpreter clang_Value_getInterpreter(CXValue V) {
  return reinterpret_cast<CXInterpreter>(&reinterpret_cast<clang::Value *>(V)->getInterpreter());
}

void *clang_Value_getType(CXValue V) {
  return reinterpret_cast<clang::Value *>(V)->getType().getAsOpaquePtr();
}

bool clang_Value_isValid(CXValue V) { return reinterpret_cast<clang::Value *>(V)->isValid(); }

bool clang_Value_isVoid(CXValue V) { return reinterpret_cast<clang::Value *>(V)->isVoid(); }

bool clang_Value_hasValue(CXValue V) { return reinterpret_cast<clang::Value *>(V)->hasValue(); }

bool clang_Value_isManuallyAlloc(CXValue V) {
  return reinterpret_cast<clang::Value *>(V)->isManuallyAlloc();
}

CXValueKind clang_Value_getKind(CXValue V) {
  return static_cast<CXValueKind>(reinterpret_cast<clang::Value *>(V)->getKind());
}

void clang_Value_setKind(CXValue V, CXValueKind K) {
  reinterpret_cast<clang::Value *>(V)->setKind(static_cast<clang::Value::Kind>(K));
}

void clang_Value_setOpaqueType(CXValue V, void *Ty) {
  reinterpret_cast<clang::Value *>(V)->setOpaqueType(Ty);
}

void *clang_Value_getPtr(CXValue V) { return reinterpret_cast<clang::Value *>(V)->getPtr(); }

void clang_Value_setPtr(CXValue V, void *P) { reinterpret_cast<clang::Value *>(V)->setPtr(P); }

// Expand the CX table (CXVALUE_ABI_TYPES), not clang's REPL_BUILTIN_TYPES:
// clang/Interpreter/Value.h redefines the latter with a long double entry,
// which must not cross the C boundary (see the header note).
#define X(type, name)                                                                      \
  void clang_Value_set##name(CXValue V, type Val) {                                        \
    reinterpret_cast<clang::Value *>(V)->set##name(Val);                                   \
  }                                                                                        \
  type clang_Value_get##name(CXValue V) {                                                  \
    return reinterpret_cast<clang::Value *>(V)->get##name();                               \
  }
CXVALUE_ABI_TYPES
#undef X

void clang_Value_setLongDouble(CXValue V, double Val) {
  reinterpret_cast<clang::Value *>(V)->setLongDouble(static_cast<long double>(Val));
}

double clang_Value_getLongDouble(CXValue V) {
  return static_cast<double>(reinterpret_cast<clang::Value *>(V)->getLongDouble());
}
