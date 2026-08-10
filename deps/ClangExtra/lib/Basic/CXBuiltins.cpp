#include "clang-ex/Basic/CXBuiltins.h"
#include "utils.h"

#include "clang/Basic/Builtins.h"
#include <string>

static clang::Builtin::Context *unwrapBC(CXBuiltinContext C) {
  return reinterpret_cast<clang::Builtin::Context *>(C);
}

unsigned clang_Builtin_getFirstTSBuiltinID(void) {
  return static_cast<unsigned>(clang::Builtin::FirstTSBuiltin);
}

CXString clang_BuiltinContext_getName(CXBuiltinContext C, unsigned ID) {
  return extra::makeCXString(unwrapBC(C)->getName(ID).str());
}

CXString clang_BuiltinContext_getTypeString(CXBuiltinContext C, unsigned ID) {
  const char *S = unwrapBC(C)->getTypeString(ID);
  return extra::makeCXString(S ? std::string(S) : std::string());
}

CXString clang_BuiltinContext_getHeaderName(CXBuiltinContext C, unsigned ID) {
  const char *S = unwrapBC(C)->getHeaderName(ID);
  return extra::makeCXString(S ? std::string(S) : std::string());
}

bool clang_BuiltinContext_isTSBuiltin(CXBuiltinContext C, unsigned ID) {
  return unwrapBC(C)->isTSBuiltin(ID);
}

bool clang_BuiltinContext_isConst(CXBuiltinContext C, unsigned ID) {
  return unwrapBC(C)->isConst(ID);
}

bool clang_BuiltinContext_isNoThrow(CXBuiltinContext C, unsigned ID) {
  return unwrapBC(C)->isNoThrow(ID);
}

bool clang_BuiltinContext_isNoReturn(CXBuiltinContext C, unsigned ID) {
  return unwrapBC(C)->isNoReturn(ID);
}

bool clang_BuiltinContext_isPure(CXBuiltinContext C, unsigned ID) {
  return unwrapBC(C)->isPure(ID);
}

bool clang_BuiltinContext_isLibFunction(CXBuiltinContext C, unsigned ID) {
  return unwrapBC(C)->isLibFunction(ID);
}

bool clang_BuiltinContext_isPredefinedLibFunction(CXBuiltinContext C, unsigned ID) {
  return unwrapBC(C)->isPredefinedLibFunction(ID);
}

bool clang_BuiltinContext_isConstWithoutErrnoAndExceptions(CXBuiltinContext C,
                                                           unsigned ID) {
  return unwrapBC(C)->isConstWithoutErrnoAndExceptions(ID);
}

bool clang_BuiltinContext_hasPtrArgsOrResult(CXBuiltinContext C, unsigned ID) {
  return unwrapBC(C)->hasPtrArgsOrResult(ID);
}

bool clang_BuiltinContext_isPrintfLike(CXBuiltinContext C, unsigned ID,
                                       unsigned *FormatIdx, bool *HasVAListArg) {
  unsigned Idx = 0;
  bool VAList = false;
  bool Result = unwrapBC(C)->isPrintfLike(ID, Idx, VAList);
  if (FormatIdx)
    *FormatIdx = Idx;
  if (HasVAListArg)
    *HasVAListArg = VAList;
  return Result;
}

bool clang_BuiltinContext_isScanfLike(CXBuiltinContext C, unsigned ID,
                                      unsigned *FormatIdx, bool *HasVAListArg) {
  unsigned Idx = 0;
  bool VAList = false;
  bool Result = unwrapBC(C)->isScanfLike(ID, Idx, VAList);
  if (FormatIdx)
    *FormatIdx = Idx;
  if (HasVAListArg)
    *HasVAListArg = VAList;
  return Result;
}
