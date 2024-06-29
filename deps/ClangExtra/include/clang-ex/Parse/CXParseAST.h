#ifndef LIBCLANGEX_CXPARSEAST_H
#define LIBCLANGEX_CXPARSEAST_H

#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE void clang_ParseAST(CXSema Sema, bool PrintStats, bool SkipFunctionBodies);

CINDEX_LINKAGE bool
clang_Parser_tryParseAndSkipInvalidOrParsedDecl(CXParser Parser, CXCodeGenerator CodeGen);

#ifdef __cplusplus
}
#endif
#endif