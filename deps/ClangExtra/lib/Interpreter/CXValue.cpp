#include "clang-ex/Interpreter/CXValue.h"
#include "clang/Interpreter/Interpreter.h"
#include "clang/Interpreter/Value.h"

#include <memory>

CXValue clang_value_create(void) {
  auto V = std::make_unique<clang::Value>();
  return V.release();
}

void clang_value_dispose(CXValue V) { delete static_cast<clang::Value *>(V); }

CXValue clang_createValueFromType(CXInterpreter I, void *Ty) {
  auto V = std::make_unique<clang::Value>(static_cast<clang::Interpreter *>(I), Ty);
  return V.release();
}

void *clang_value_getType(CXValue V) {
  return static_cast<clang::Value *>(V)->getType().getAsOpaquePtr();
}

bool clang_value_isValid(CXValue V) { return static_cast<clang::Value *>(V)->isValid(); }

bool clang_value_isVoid(CXValue V) { return static_cast<clang::Value *>(V)->isVoid(); }

bool clang_value_hasValue(CXValue V) { return static_cast<clang::Value *>(V)->hasValue(); }

bool clang_value_isManuallyAlloc(CXValue V) {
  return static_cast<clang::Value *>(V)->isManuallyAlloc();
}

CXValueKind clang_value_getKind(CXValue V) {
  return static_cast<CXValueKind>(static_cast<clang::Value *>(V)->getKind());
}

void clang_value_setKind(CXValue V, CXValueKind K) {
  static_cast<clang::Value *>(V)->setKind(static_cast<clang::Value::Kind>(K));
}

void clang_value_setOpaqueType(CXValue V, void *Ty) {
  static_cast<clang::Value *>(V)->setOpaqueType(Ty);
}

void *clang_value_getPtr(CXValue V) { return static_cast<clang::Value *>(V)->getPtr(); }

void clang_value_setPtr(CXValue V, void *P) { static_cast<clang::Value *>(V)->setPtr(P); }

#define X(type, name)                                                                      \
  void clang_value_set##name(CXValue V, type Val) {                                        \
    static_cast<clang::Value *>(V)->set##name(Val);                                        \
  }                                                                                        \
  type clang_value_get##name(CXValue V) {                                                  \
    return static_cast<clang::Value *>(V)->get##name();                                    \
  }
REPL_BUILTIN_TYPES
#undef X