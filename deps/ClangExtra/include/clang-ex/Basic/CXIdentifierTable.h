#ifndef LIBCLANGEX_CXIDENTIFIERTABLE_H
#define LIBCLANGEX_CXIDENTIFIERTABLE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE void clang_IdentifierTable_PrintStats(CXIdentifierTable IT);

CINDEX_LINKAGE CXIdentifierInfo clang_IdentifierTable_get(CXIdentifierTable Idents,
                                                          const char *Name);

#ifdef __cplusplus
}
#endif
#endif