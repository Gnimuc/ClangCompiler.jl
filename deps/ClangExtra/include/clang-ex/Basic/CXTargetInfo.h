#ifndef LIBCLANGEX_CXTARGETINFO_H
#define LIBCLANGEX_CXTARGETINFO_H

#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE CXTargetInfo_ clang_TargetInfo_CreateTargetInfo(CXDiagnosticsEngine DE,
                                                               CXTargetOptions Opts);

#ifdef __cplusplus
}
#endif
#endif