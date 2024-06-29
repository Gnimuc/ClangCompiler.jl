#ifndef LIBCLANGEX_CXLANGOPTIONS_H
#define LIBCLANGEX_CXLANGOPTIONS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE void clang_LangOptions_PrintStats(CXLangOptions LO);

#ifdef __cplusplus
}
#endif
#endif