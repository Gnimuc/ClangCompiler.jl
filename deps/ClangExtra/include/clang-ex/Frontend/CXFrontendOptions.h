#ifndef LIBCLANGEX_CXFRONTENDOPTIONS_H
#define LIBCLANGEX_CXFRONTENDOPTIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE void clang_FrontendOptions_PrintStats(CXFrontendOptions FEO);

#ifdef __cplusplus
}
#endif
#endif