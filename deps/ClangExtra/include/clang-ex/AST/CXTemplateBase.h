#ifndef LLVM_CLANG_C_EXTRA_CXTEMPLATEBASE_H
#define LLVM_CLANG_C_EXTRA_CXTEMPLATEBASE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/ExecutionEngine.h"
#include "clang-c/CXString.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

typedef enum CXTemplateArgument_ArgKind {
  CXTemplateArgument_Null = 0,
  CXTemplateArgument_Type,
  CXTemplateArgument_Declaration,
  CXTemplateArgument_NullPtr,
  CXTemplateArgument_Integral,
  CXTemplateArgument_StructuralValue,
  CXTemplateArgument_Template,
  CXTemplateArgument_TemplateExpansion,
  CXTemplateArgument_Expression,
  CXTemplateArgument_Pack
} CXTemplateArgument_ArgKind;

CXTemplateArgument clang_TemplateArgument_constructFromQualType(CXQualType OpaquePtr,
                                                                bool isNullPtr);

CXTemplateArgument clang_TemplateArgument_constructFromValueDecl(CXValueDecl VD,
                                                                 CXQualType OpaquePtr);

// PRECONDITION: OpaquePtr is a non-null, non-dependent integral or enumeration type. The body
// reads its signedness and its width -- Profile folds both -- and clang answers neither for a
// null type (assert in QualType::operator->) or a dependent one (llvm_unreachable in
// getTypeSize, which a release build falls through). Restated in the Julia wrapper.
CXTemplateArgument clang_TemplateArgument_constructFromIntegral(CXASTContext Ctx,
                                                                LLVMGenericValueRef Val,
                                                                CXQualType OpaquePtr);

// Same argument, same preconditions, without the LLVMGenericValueRef. The GenericValue only
// ever carried raw bits: the body below takes the signedness and the width from OpaquePtr, so
// an int64_t says everything the GenericValue said. Having this means a Julia caller building
// a non-type template argument needs no LLVM context at all.
CXTemplateArgument clang_TemplateArgument_constructFromInt64(CXASTContext Ctx, int64_t Val,
                                                             CXQualType OpaquePtr);

void clang_TemplateArgument_dispose(CXTemplateArgument TA);

// A freshly heap-boxed empty pack argument. Owned by the caller: release it with
// clang_TemplateArgument_dispose.
CXTemplateArgument clang_TemplateArgument_getEmptyPack(void);

// A freshly heap-boxed pack argument whose elements are copied into Context's arena.
// Args is a caller buffer of CXTemplateArgument handles (pointers to heap-boxed
// clang::TemplateArgument), not a contiguous value array (MARSHALLING.md §11). The
// returned box is owned by the caller; the element boxes are untouched.
CXTemplateArgument clang_TemplateArgument_CreatePackCopy(CXASTContext Context,
                                                         CXTemplateArgument Args,
                                                         unsigned ArgNum);

CXTemplateArgument_ArgKind clang_TemplateArgument_getKind(CXTemplateArgument TA);

bool clang_TemplateArgument_isNull(CXTemplateArgument TA);

bool clang_TemplateArgument_isDependent(CXTemplateArgument TA);

bool clang_TemplateArgument_isInstantiationDependent(CXTemplateArgument TA);

bool clang_TemplateArgument_containsUnexpandedParameterPack(CXTemplateArgument TA);

bool clang_TemplateArgument_isPackExpansion(CXTemplateArgument TA);

CXQualType clang_TemplateArgument_getAsType(CXTemplateArgument TA);

CXValueDecl clang_TemplateArgument_getAsDecl(CXTemplateArgument TA);

CXQualType clang_TemplateArgument_getParamTypeForDecl(CXTemplateArgument TA);

CXQualType clang_TemplateArgument_getNullPtrType(CXTemplateArgument TA);

CXTemplateName clang_TemplateArgument_getAsTemplate(CXTemplateArgument TA);

CXTemplateName clang_TemplateArgument_getAsTemplateOrTemplatePattern(CXTemplateArgument TA);

// TemplateArgument::getNumTemplateExpansions is optional<unsigned>: engaged ->
// fills *N and returns true; disengaged -> returns false, *N untouched.
bool clang_TemplateArgument_getNumTemplateExpansions(CXTemplateArgument TA, unsigned *N);

LLVMGenericValueRef clang_TemplateArgument_getAsIntegral(CXTemplateArgument TA);

CXQualType clang_TemplateArgument_getIntegralType(CXTemplateArgument TA);

void clang_TemplateArgument_setIntegralType(CXTemplateArgument TA, CXQualType OpaquePtr);

CXQualType clang_TemplateArgument_getNonTypeTemplateArgumentType(CXTemplateArgument TA);

void clang_TemplateArgument_setIsDefaulted(CXTemplateArgument TA, bool V);

bool clang_TemplateArgument_getIsDefaulted(CXTemplateArgument TA);

// StructuralValue payload. Both accessors read a union member without checking the
// kind, so the precondition for each is
// getKind() == CXTemplateArgument_StructuralValue. The returned CXAPValue is BORROWED
// - it is interior to the argument and must never be disposed.
CXAPValue clang_TemplateArgument_getAsStructuralValue(CXTemplateArgument TA);

CXQualType clang_TemplateArgument_getStructuralValueType(CXTemplateArgument TA);

// Precondition: getKind() == CXTemplateArgument_Expression.
CXExpr clang_TemplateArgument_getAsExpr(CXTemplateArgument TA);

// Precondition: getKind() == CXTemplateArgument_Pack.
unsigned clang_TemplateArgument_pack_size(CXTemplateArgument TA);

// helper - the I-th element of getPackAsArray(). Borrowed interior pointer into the
// AST-owned pack storage (no dispose, unlike the heap-boxed TemplateArgument the
// construct* helpers return). Preconditions: getKind() == CXTemplateArgument_Pack
// and I < pack_size().
CXTemplateArgument clang_TemplateArgument_getPackElement(CXTemplateArgument TA, unsigned I);

bool clang_TemplateArgument_structurallyEquals(CXTemplateArgument TA,
                                               CXTemplateArgument Other);

// The pattern of a pack expansion, freshly heap-boxed and owned by the caller (release
// with clang_TemplateArgument_dispose). Precondition: isPackExpansion().
CXTemplateArgument clang_TemplateArgument_getPackExpansionPattern(CXTemplateArgument TA);

// Renders the argument as source text using Context's default printing policy.
// IncludeType spells the type of a non-type argument alongside its value.
CXString clang_TemplateArgument_print(CXTemplateArgument TA, CXASTContext Context,
                                      bool IncludeType);

void clang_TemplateArgument_dump(CXTemplateArgument TA);

// TemplateArgumentLoc
// Borrowed interior reference to the wrapped argument (no dispose, unlike the
// heap-boxed TemplateArgument the construct* helpers return).
CXTemplateArgument clang_TemplateArgumentLoc_getArgument(CXTemplateArgumentLoc TAL);

CXSourceLocation_ clang_TemplateArgumentLoc_getLocation(CXTemplateArgumentLoc TAL);

CXSourceRange_ clang_TemplateArgumentLoc_getSourceRange(CXTemplateArgumentLoc TAL);

// NULL for every argument kind other than CXTemplateArgument_Type.
CXTypeSourceInfo clang_TemplateArgumentLoc_getTypeSourceInfo(CXTemplateArgumentLoc TAL);

// Precondition: the wrapped argument's kind is CXTemplateArgument_Expression.
CXExpr clang_TemplateArgumentLoc_getSourceExpression(CXTemplateArgumentLoc TAL);

// The source expressions behind the remaining non-type argument kinds. Each asserts
// the wrapped argument's kind, so the preconditions are CXTemplateArgument_Declaration,
// _NullPtr, _Integral and _StructuralValue respectively.
CXExpr clang_TemplateArgumentLoc_getSourceDeclExpression(CXTemplateArgumentLoc TAL);

CXExpr clang_TemplateArgumentLoc_getSourceNullPtrExpression(CXTemplateArgumentLoc TAL);

CXExpr clang_TemplateArgumentLoc_getSourceIntegralExpression(CXTemplateArgumentLoc TAL);

CXExpr
clang_TemplateArgumentLoc_getSourceStructuralValueExpression(CXTemplateArgumentLoc TAL);

// The nested-name-specifier written in front of a Template / TemplateExpansion
// argument's name. Total: the accessor hands back a default-constructed location
// (NULL specifier) for every other kind, and for an unqualified name. Only the
// specifier crosses - its source locations stay in the AST (MARSHALLING.md §7).
CXNestedNameSpecifier
clang_TemplateArgumentLoc_getTemplateQualifier(CXTemplateArgumentLoc TAL);

// An invalid location unless the wrapped argument's kind is CXTemplateArgument_Template
// or CXTemplateArgument_TemplateExpansion.
CXSourceLocation_ clang_TemplateArgumentLoc_getTemplateNameLoc(CXTemplateArgumentLoc TAL);

// An invalid location unless the wrapped argument's kind is
// CXTemplateArgument_TemplateExpansion.
CXSourceLocation_
clang_TemplateArgumentLoc_getTemplateEllipsisLoc(CXTemplateArgumentLoc TAL);

// TemplateArgumentListInfo
// A freshly heap-boxed, empty argument list delimited by the two angle-bracket
// locations. Owned by the caller: release it with
// clang_TemplateArgumentListInfo_dispose. This is clang's AST-*unsafe* builder form
// (its placement operator new is deleted precisely so it is never embedded in a
// node); hand it to clang_ASTTemplateArgumentListInfo_Create for the AST-safe copy.
CXTemplateArgumentListInfo
clang_TemplateArgumentListInfo_create(CXSourceLocation_ LAngleLoc,
                                      CXSourceLocation_ RAngleLoc);

void clang_TemplateArgumentListInfo_dispose(CXTemplateArgumentListInfo LI);

CXSourceLocation_
clang_TemplateArgumentListInfo_getLAngleLoc(CXTemplateArgumentListInfo LI);

CXSourceLocation_
clang_TemplateArgumentListInfo_getRAngleLoc(CXTemplateArgumentListInfo LI);

void clang_TemplateArgumentListInfo_setLAngleLoc(CXTemplateArgumentListInfo LI,
                                                 CXSourceLocation_ Loc);

void clang_TemplateArgumentListInfo_setRAngleLoc(CXTemplateArgumentListInfo LI,
                                                 CXSourceLocation_ Loc);

unsigned clang_TemplateArgumentListInfo_size(CXTemplateArgumentListInfo LI);

// helper - the I-th entry of arguments(), as the count+index pair of
// MARSHALLING.md §6. The returned pointer is interior to the list's own vector and
// is invalidated by any later addArgument; it is never disposed. Precondition:
// I < size().
CXTemplateArgumentLoc
clang_TemplateArgumentListInfo_getArgument(CXTemplateArgumentListInfo LI, unsigned I);

// Appends a copy of Loc; Loc keeps whatever ownership it already had.
void clang_TemplateArgumentListInfo_addArgument(CXTemplateArgumentListInfo LI,
                                                CXTemplateArgumentLoc Loc);

// ASTTemplateArgumentListInfo
CXSourceLocation_
clang_ASTTemplateArgumentListInfo_getLAngleLoc(CXASTTemplateArgumentListInfo LI);

CXSourceLocation_
clang_ASTTemplateArgumentListInfo_getRAngleLoc(CXASTTemplateArgumentListInfo LI);

unsigned
clang_ASTTemplateArgumentListInfo_getNumTemplateArgs(CXASTTemplateArgumentListInfo LI);

// helper - the I-th entry of arguments(). Borrowed interior pointer into the list's
// AST-owned trailing array. Precondition: I < getNumTemplateArgs().
CXTemplateArgumentLoc
clang_ASTTemplateArgumentListInfo_getTemplateArg(CXASTTemplateArgumentListInfo LI,
                                                 unsigned I);

// A copy of Info allocated in Context's arena and safe to embed in an AST node.
// Never disposed - the arena owns it.
CXASTTemplateArgumentListInfo
clang_ASTTemplateArgumentListInfo_Create(CXASTContext Context,
                                         CXTemplateArgumentListInfo Info);

// The qualifier written before a template-name argument, heap-boxed and OWNED. The accessor is
// kind-gated inside clang: any other argument kind yields a default-constructed (empty) box.
CXNestedNameSpecifierLoc clang_TemplateArgumentLoc_getTemplateQualifierLoc(
    CXTemplateArgumentLoc TAL);

// The dependence bits of the argument, as the CXTemplateArgumentDependence bitmask.
// PRECONDITION: TA is not the null argument -- clang's `case Null` is unreachable-by-contract.
unsigned clang_TemplateArgument_getDependence(CXTemplateArgument TA);

LLVM_CLANG_C_EXTERN_C_END

#endif