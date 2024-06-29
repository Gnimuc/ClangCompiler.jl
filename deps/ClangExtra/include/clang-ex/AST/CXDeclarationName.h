#ifndef LIBCLANGEX_CXDECLARATIONNAME_H
#define LIBCLANGEX_CXDECLARATIONNAME_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE CXDeclarationName clang_DeclarationName_create(void);

CINDEX_LINKAGE CXDeclarationName
clang_DeclarationName_createFromIdentifierInfo(CXIdentifierInfo IDInfo);

CINDEX_LINKAGE void clang_DeclarationName_dump(CXDeclarationName DN);

CINDEX_LINKAGE bool clang_DeclarationName_isEmpty(CXDeclarationName DN);

CINDEX_LINKAGE CXString clang_DeclarationName_getAsString(CXDeclarationName DN);

#ifdef __cplusplus
}
#endif
#endif