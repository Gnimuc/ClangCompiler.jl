#ifndef LIBCLANGEX_CXTARGETOPTIONS_H
#define LIBCLANGEX_CXTARGETOPTIONS_H

#include "clang-ex/CXError.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE CXTargetOptions clang_TargetOptions_create(CXInit_Error *ErrorCode);

CINDEX_LINKAGE void clang_TargetOptions_dispose(CXTargetOptions TO);

CINDEX_LINKAGE void clang_TargetOptions_setTriple(CXTargetOptions TO, const char *TripleStr,
                                                  size_t Num);

CINDEX_LINKAGE void clang_TargetOptions_PrintStats(CXTargetOptions TO);

#ifdef __cplusplus
}
#endif
#endif