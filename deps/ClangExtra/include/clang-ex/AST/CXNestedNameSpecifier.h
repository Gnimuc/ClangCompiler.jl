#ifndef LIBCLANGEX_CXNESTEDNAMESPECIFIER_H
#define LIBCLANGEX_CXNESTEDNAMESPECIFIER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE CXNestedNameSpecifier
clang_NestedNameSpecifier_getPrefix(CXNestedNameSpecifier NNS);

CINDEX_LINKAGE bool clang_NestedNameSpecifier_containsErrors(CXNestedNameSpecifier NNS);

CINDEX_LINKAGE void clang_NestedNameSpecifier_dump(CXNestedNameSpecifier NNS);

#ifdef __cplusplus
}
#endif
#endif