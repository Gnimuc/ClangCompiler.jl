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

CXNamedDecl clang_LookupResult_getResult(CXLookupResult LR);

typedef enum CXLookupResultKind {
  CXLookupResultKind_NotFound = 0,
  CXLookupResultKind_NotFoundInCurrentInstantiation,
  CXLookupResultKind_Found,
  CXLookupResultKind_FoundOverloaded,
  CXLookupResultKind_FoundUnresolvedValue,
  CXLookupResultKind_Ambiguous
} CXLookupResultKind;

typedef enum CXAmbiguityKind {
  CXAmbiguityKind_AmbiguousBaseSubobjectTypes = 0,
  CXAmbiguityKind_AmbiguousBaseSubobjects,
  CXAmbiguityKind_AmbiguousReference,
  CXAmbiguityKind_AmbiguousReferenceToPlaceholderVariable,
  CXAmbiguityKind_AmbiguousTagHiding
} CXAmbiguityKind;

CXLookupResultKind clang_LookupResult_getResultKind(CXLookupResult LR);

// Precondition: clang_LookupResult_isAmbiguous(LR) --
// LookupResult::getAmbiguityKind asserts it.
CXAmbiguityKind clang_LookupResult_getAmbiguityKind(CXLookupResult LR);

// Precondition: clang_LookupResult_getResultKind(LR) == CXLookupResultKind_Found --
// LookupResult::getFoundDecl asserts the result is unique before dereferencing begin().
CXNamedDecl clang_LookupResult_getFoundDecl(CXLookupResult LR);

// Null unless the lookup found its results in a class.
CXCXXRecordDecl clang_LookupResult_getNamingClass(CXLookupResult LR);

CXLookupNameKind clang_LookupResult_getLookupKind(CXLookupResult LR);

CXSourceLocation_ clang_LookupResult_getNameLoc(CXLookupResult LR);

unsigned clang_LookupResult_getIdentifierNamespace(CXLookupResult LR);

void clang_LookupResult_suppressDiagnostics(CXLookupResult LR);

LLVM_CLANG_C_EXTERN_C_END

#endif