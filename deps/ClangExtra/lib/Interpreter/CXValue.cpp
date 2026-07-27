#include "clang-ex/Interpreter/CXValue.h"
#include "utils.h"
#include "clang/Interpreter/Interpreter.h"
#include "clang/Interpreter/Value.h"
#include "llvm/Support/raw_ostream.h"

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

CXString clang_value_printType(CXValue V) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::Value *>(V)->printType(OS);
  return extra::makeCXString(S);
}

CXString clang_value_printData(CXValue V) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::Value *>(V)->printData(OS);
  return extra::makeCXString(S);
}

CXString clang_value_print(CXValue V) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::Value *>(V)->print(OS);
  return extra::makeCXString(S);
}

void clang_value_dump(CXValue V) { static_cast<clang::Value *>(V)->dump(); }

void clang_value_clear(CXValue V) { static_cast<clang::Value *>(V)->clear(); }

CXASTContext clang_value_getASTContext(CXValue V) {
  return &static_cast<clang::Value *>(V)->getASTContext();
}

CXInterpreter clang_value_getInterpreter(CXValue V) {
  return &static_cast<clang::Value *>(V)->getInterpreter();
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

// Expand the CX table (CXVALUE_ABI_TYPES), not clang's REPL_BUILTIN_TYPES:
// clang/Interpreter/Value.h redefines the latter with a long double entry,
// which must not cross the C boundary (see the header note).
#define X(type, name)                                                                      \
  void clang_value_set##name(CXValue V, type Val) {                                        \
    static_cast<clang::Value *>(V)->set##name(Val);                                        \
  }                                                                                        \
  type clang_value_get##name(CXValue V) {                                                  \
    return static_cast<clang::Value *>(V)->get##name();                                    \
  }
CXVALUE_ABI_TYPES
#undef X

void clang_value_setLongDouble(CXValue V, double Val) {
  static_cast<clang::Value *>(V)->setLongDouble(static_cast<long double>(Val));
}

double clang_value_getLongDouble(CXValue V) {
  return static_cast<double>(static_cast<clang::Value *>(V)->getLongDouble());
}