#ifndef LIBCLANGEX_CXSCOPE_H
#define LIBCLANGEX_CXSCOPE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE void clang_Scope_dump(CXScope S);

CINDEX_LINKAGE CXScope clang_Scope_getParent(CXScope S);

CINDEX_LINKAGE unsigned clang_Scope_getDepth(CXScope S);

#ifdef __cplusplus
}
#endif
#endif