#ifndef LLVM_CLANG_C_EXTRA_CXDECLARATIONNAME_H
#define LLVM_CLANG_C_EXTRA_CXDECLARATIONNAME_H

#include "clang-ex/Basic/CXOperatorKinds.h"

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

CXDeclarationName clang_DeclarationName_create(void);

CXDeclarationName clang_DeclarationName_createFromIdentifierInfo(CXIdentifierInfo IDInfo);

void clang_DeclarationName_dump(CXDeclarationName DN);

bool clang_DeclarationName_isEmpty(CXDeclarationName DN);

CXString clang_DeclarationName_getAsString(CXDeclarationName DN);

// Mirrors clang::DeclarationName::NameKind (class-local enum; synced in
// lib/Basic/CXEnumSync.cpp). The numbering is not contiguous — 7 is reserved for
// the internal StoredDeclarationNameExtra tag — so every enumerator is spelled
// with its explicit value.
typedef enum CXDeclarationName_NameKind {
  CXDeclarationName_Identifier = 0,
  CXDeclarationName_ObjCZeroArgSelector = 1,
  CXDeclarationName_ObjCOneArgSelector = 2,
  CXDeclarationName_CXXConstructorName = 3,
  CXDeclarationName_CXXDestructorName = 4,
  CXDeclarationName_CXXConversionFunctionName = 5,
  CXDeclarationName_CXXOperatorName = 6,
  CXDeclarationName_CXXDeductionGuideName = 8,
  CXDeclarationName_CXXLiteralOperatorName = 9,
  CXDeclarationName_CXXUsingDirective = 10,
  CXDeclarationName_ObjCMultiArgSelector = 11
} CXDeclarationName_NameKind;

CXDeclarationName_NameKind clang_DeclarationName_getNameKind(CXDeclarationName DN);

bool clang_DeclarationName_isIdentifier(CXDeclarationName DN);

bool clang_DeclarationName_isObjCZeroArgSelector(CXDeclarationName DN);

bool clang_DeclarationName_isObjCOneArgSelector(CXDeclarationName DN);

bool clang_DeclarationName_isDependentName(CXDeclarationName DN);

// NULL unless the name is a plain identifier.
CXIdentifierInfo clang_DeclarationName_getAsIdentifierInfo(CXDeclarationName DN);

// The type a constructor/destructor/conversion-function name names; a null
// QualType encoding for every other kind.
CXQualType clang_DeclarationName_getCXXNameType(CXDeclarationName DN);

CXTemplateDecl clang_DeclarationName_getCXXDeductionGuideTemplate(CXDeclarationName DN);

// CXOverloadedOperatorKind_OO_None unless the name is an overloaded operator.
CXOverloadedOperatorKind
clang_DeclarationName_getCXXOverloadedOperator(CXDeclarationName DN);

// NULL unless the name is a literal-operator name.
CXIdentifierInfo clang_DeclarationName_getCXXLiteralIdentifier(CXDeclarationName DN);

// The single name shared by all C++ using-directives.
CXDeclarationName clang_DeclarationName_getUsingDirectiveName(void);

// Lexicographic for identifiers; a total order over all kinds otherwise.
int clang_DeclarationName_compare(CXDeclarationName LHS, CXDeclarationName RHS);

// DeclarationNameTable
//
// The uniquing table for the C++ special declaration names; it is the
// `DeclarationNames` member of an ASTContext, so getFromASTContext is the only
// way to obtain one and the handle is borrowed (nothing to dispose). The names
// it returns are the keys DeclContext::lookup expects, which is how a
// constructor/destructor/conversion/operator declaration is found by name.
//
// The CanQualType parameters must be CANONICAL types (clang::CanQualType is
// built here with CreateUnsafe, which does not re-canonicalise): pass the result
// of clang_ASTContext_getCanonicalType.
CXDeclarationNameTable clang_DeclarationNameTable_getFromASTContext(CXASTContext Ctx);

CXDeclarationName clang_DeclarationNameTable_getIdentifier(CXDeclarationNameTable Table,
                                                           CXIdentifierInfo ID);

CXDeclarationName
clang_DeclarationNameTable_getCXXConstructorName(CXDeclarationNameTable Table,
                                                 CXQualType Ty);

CXDeclarationName
clang_DeclarationNameTable_getCXXDestructorName(CXDeclarationNameTable Table,
                                                CXQualType Ty);

CXDeclarationName
clang_DeclarationNameTable_getCXXDeductionGuideName(CXDeclarationNameTable Table,
                                                    CXTemplateDecl TD);

CXDeclarationName
clang_DeclarationNameTable_getCXXConversionFunctionName(CXDeclarationNameTable Table,
                                                        CXQualType Ty);

// Kind must be one of CXDeclarationName_CXXConstructorName,
// CXDeclarationName_CXXDestructorName or
// CXDeclarationName_CXXConversionFunctionName.
CXDeclarationName
clang_DeclarationNameTable_getCXXSpecialName(CXDeclarationNameTable Table,
                                             CXDeclarationName_NameKind Kind,
                                             CXQualType Ty);

CXDeclarationName
clang_DeclarationNameTable_getCXXOperatorName(CXDeclarationNameTable Table,
                                              CXOverloadedOperatorKind Op);

CXDeclarationName
clang_DeclarationNameTable_getCXXLiteralOperatorName(CXDeclarationNameTable Table,
                                                     CXIdentifierInfo II);

// DeclarationNameInfo
//
// A CXDeclarationNameInfo is a heap-boxed clang::DeclarationNameInfo (the value
// type has no opaque pointer encoding). clang_DeclarationNameInfo_create and the
// class-specific producers (clang_FunctionDecl_getNameInfo,
// clang_DeclRefExpr_getNameInfo, clang_MemberExpr_getMemberNameInfo) each return
// an owned box; release it with clang_DeclarationNameInfo_dispose. The getName /
// getLoc / getBeginLoc / getEndLoc accessors return borrowed value encodings.
CXDeclarationNameInfo clang_DeclarationNameInfo_create(CXDeclarationName Name,
                                                       CXSourceLocation_ NameLoc);

void clang_DeclarationNameInfo_dispose(CXDeclarationNameInfo DNInfo);

CXDeclarationName clang_DeclarationNameInfo_getName(CXDeclarationNameInfo DNInfo);

CXSourceLocation_ clang_DeclarationNameInfo_getLoc(CXDeclarationNameInfo DNInfo);

CXSourceLocation_ clang_DeclarationNameInfo_getBeginLoc(CXDeclarationNameInfo DNInfo);

CXSourceLocation_ clang_DeclarationNameInfo_getEndLoc(CXDeclarationNameInfo DNInfo);

CXString clang_DeclarationNameInfo_getAsString(CXDeclarationNameInfo DNInfo);

void clang_DeclarationNameInfo_setName(CXDeclarationNameInfo DNInfo,
                                       CXDeclarationName Name);

void clang_DeclarationNameInfo_setLoc(CXDeclarationNameInfo DNInfo,
                                      CXSourceLocation_ L);

// NULL unless the name is a constructor, destructor or conversion function.
CXTypeSourceInfo clang_DeclarationNameInfo_getNamedTypeInfo(CXDeclarationNameInfo DNInfo);

// An invalid range unless the name is a (non-literal) overloaded operator.
CXSourceRange_
clang_DeclarationNameInfo_getCXXOperatorNameRange(CXDeclarationNameInfo DNInfo);

// An invalid location unless the name is a literal-operator name.
CXSourceLocation_
clang_DeclarationNameInfo_getCXXLiteralOperatorNameLoc(CXDeclarationNameInfo DNInfo);

bool clang_DeclarationNameInfo_isInstantiationDependent(CXDeclarationNameInfo DNInfo);

bool
clang_DeclarationNameInfo_containsUnexpandedParameterPack(CXDeclarationNameInfo DNInfo);

CXSourceRange_ clang_DeclarationNameInfo_getSourceRange(CXDeclarationNameInfo DNInfo);

// The DeclarationNameLoc mutators. Each overwrites the whole location union, and
// clang asserts that the info's current name matches: a constructor, destructor or
// conversion-function name for setNamedTypeInfo, a (non-literal) overloaded
// operator for setCXXOperatorNameRange, a literal-operator name for
// setCXXLiteralOperatorNameLoc.
void clang_DeclarationNameInfo_setNamedTypeInfo(CXDeclarationNameInfo DNInfo,
                                                CXTypeSourceInfo TInfo);

void clang_DeclarationNameInfo_setCXXOperatorNameRange(CXDeclarationNameInfo DNInfo,
                                                       CXSourceRange_ R);

void clang_DeclarationNameInfo_setCXXLiteralOperatorNameLoc(CXDeclarationNameInfo DNInfo,
                                                            CXSourceLocation_ Loc);

LLVM_CLANG_C_EXTERN_C_END

#endif