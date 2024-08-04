#ifndef LLVM_CLANG_C_EXTRA_CXLOOKUP_H
#define LLVM_CLANG_C_EXTRA_CXLOOKUP_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

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

CXLookupResult clang_LookupResult_create(CXSema S, CXDeclarationName Name,
                                         CXSourceLocation_ NameLoc,
                                         CXLookupNameKind LookupKind);

void clang_LookupResult_dispose(CXLookupResult LR);

bool clang_LookupResult_isForRedeclaration(CXLookupResult LR);

bool clang_LookupResult_isTemplateNameLookup(CXLookupResult LR);

bool clang_LookupResult_isAmbiguous(CXLookupResult LR);

bool clang_LookupResult_isSingleResult(CXLookupResult LR);

bool clang_LookupResult_isOverloadedResult(CXLookupResult LR);

bool clang_LookupResult_isUnresolvableResult(CXLookupResult LR);

bool clang_LookupResult_isClassLookup(CXLookupResult LR);

void clang_LookupResult_resolveKind(CXLookupResult LR);

bool clang_LookupResult_isSingleTagDecl(CXLookupResult LR);

void clang_LookupResult_clear(CXLookupResult LR, CXLookupNameKind LookupKind);

void clang_LookupResult_setLookupName(CXLookupResult LR, CXDeclarationName DN);

CXDeclarationName clang_LookupResult_getLookupName(CXLookupResult LR);

void clang_LookupResult_dump(CXLookupResult LR);

bool clang_LookupResult_empty(CXLookupResult LR);

CXNamedDecl clang_LookupResult_getRepresentativeDecl(CXLookupResult LR);

void clang_LookupResult_setLookupName(CXLookupResult LR, CXDeclarationName DN);

CXDeclarationName clang_LookupResult_getLookupName(CXLookupResult LR);

size_t clang_LookupResult_getNum(CXLookupResult LR);

void clang_LookupResult_getResults(CXLookupResult LR, CXNamedDecl *Decls, size_t N);

LLVM_CLANG_C_EXTERN_C_END

#endif