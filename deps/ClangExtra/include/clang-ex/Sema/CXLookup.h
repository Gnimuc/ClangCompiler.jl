#ifndef LIBCLANGEX_CXLOOKUP_H
#define LIBCLANGEX_CXLOOKUP_H

#include "clang-ex/CXError.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef enum CXLookupNameKind {
  CXLookupNameKind_LookupOrdinaryName = 0,
  CXLookupNameKind_LookupTagName,
  CXLookupNameKind_LookupLabel,
  CXLookupNameKind_LookupMemberName,
  CXLookupNameKind_LookupOperatorName,
  CXLookupNameKind_LookupDestructorName,
  CXLookupNameKind_LookupNestedNameSpecifierName,
  CXLookupNameKind_LookupNamespaceName,
  CXLookupNameKind_LookupUsingDeclName,
  CXLookupNameKind_LookupRedeclarationWithLinkage,
  CXLookupNameKind_LookupLocalFriendName,
  CXLookupNameKind_LookupObjCProtocolName,
  CXLookupNameKind_LookupObjCImplicitSelfParam,
  CXLookupNameKind_LookupOMPReductionName,
  CXLookupNameKind_LookupOMPMapperName,
  CXLookupNameKind_LookupAnyName
} CXLookupNameKind;

CINDEX_LINKAGE CXLookupResult clang_LookupResult_create(CXSema S, CXDeclarationName Name,
                                                        CXSourceLocation_ NameLoc,
                                                        CXLookupNameKind LookupKind,
                                                        CXInit_Error *ErrorCode);

CINDEX_LINKAGE void clang_LookupResult_dispose(CXLookupResult LR);

CINDEX_LINKAGE void clang_LookupResult_clear(CXLookupResult LR,
                                             CXLookupNameKind LookupKind);

CINDEX_LINKAGE void clang_LookupResult_setLookupName(CXLookupResult LR,
                                                     CXDeclarationName DN);

CINDEX_LINKAGE CXDeclarationName clang_LookupResult_getLookupName(CXLookupResult LR);

CINDEX_LINKAGE void clang_LookupResult_dump(CXLookupResult LR);

CINDEX_LINKAGE bool clang_LookupResult_empty(CXLookupResult LR);

CINDEX_LINKAGE CXNamedDecl clang_LookupResult_getRepresentativeDecl(CXLookupResult LR);

CINDEX_LINKAGE void clang_LookupResult_setLookupName(CXLookupResult LR,
                                                     CXDeclarationName DN);

CINDEX_LINKAGE CXDeclarationName clang_LookupResult_getLookupName(CXLookupResult LR);

#ifdef __cplusplus
}
#endif
#endif