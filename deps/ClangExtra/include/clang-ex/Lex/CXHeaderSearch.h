#ifndef LIBCLANGEX_CXHEADERSEARCH_H
#define LIBCLANGEX_CXHEADERSEARCH_H

#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE void clang_HeaderSearch_PrintStats(CXHeaderSearch HS);

#ifdef __cplusplus
}
#endif
#endif