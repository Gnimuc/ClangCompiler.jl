#ifndef LIBCLANGEX_H
#define LIBCLANGEX_H

#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE void clang_Stmt_EnableStatistics(void);
CINDEX_LINKAGE void clang_Stmt_PrintStats(void);

#ifdef __cplusplus
}
#endif
#endif
