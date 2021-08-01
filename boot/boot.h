#ifndef CLANG_COMPILER_BOOT_H
#define CLANG_COMPILER_BOOT_H

#include "clang-ex/CXTypes.h"
#include "julia.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE bool
clang_Parser_tryParseAndSkipInvalidOrParsedDecl(CXParser Parser,
                                                CXCodeGenerator CodeGen);

CINDEX_LINKAGE void
clang_Sema_processWeakTopLevelDecls(CXSema Sema, CXCodeGenerator CodeGen);

#ifdef __cplusplus
}
#endif
#endif