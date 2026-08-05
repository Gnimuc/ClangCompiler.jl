#ifndef LLVM_CLANG_C_EXTRA_CXTEMPLATENAME_H
#define LLVM_CLANG_C_EXTRA_CXTEMPLATENAME_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-c/CXString.h"
#include "clang-ex/Basic/CXOperatorKinds.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

typedef enum CXTemplateName_NameKind {
  CXTemplateName_Template,
  CXTemplateName_OverloadedTemplate,
  CXTemplateName_AssumedTemplate,
  CXTemplateName_QualifiedTemplate,
  CXTemplateName_DependentTemplate,
  CXTemplateName_SubstTemplateTemplateParm,
  CXTemplateName_SubstTemplateTemplateParmPack,
  UsingTemplate
} CXTemplateName_NameKind;

bool clang_TemplateName_isNull(CXTemplateName TN);

CXTemplateName_NameKind clang_TemplateName_getKind(CXTemplateName TN);

CXTemplateDecl clang_TemplateName_getAsTemplateDecl(CXTemplateName TN);

// The storage arms of a TemplateName. Every getAs* below tests the name's kind
// internally and returns NULL for the other arms, so none of them has a
// precondition. AssumedTemplateStorage is only ever created by Sema while a
// template is being parsed; its handle is opaque and carries no accessors here.
CXOverloadedTemplateStorage clang_TemplateName_getAsOverloadedTemplate(CXTemplateName TN);

CXAssumedTemplateStorage clang_TemplateName_getAsAssumedTemplateName(CXTemplateName TN);

CXSubstTemplateTemplateParmStorage
clang_TemplateName_getAsSubstTemplateTemplateParm(CXTemplateName TN);

CXSubstTemplateTemplateParmPackStorage
clang_TemplateName_getAsSubstTemplateTemplateParmPack(CXTemplateName TN);

CXQualifiedTemplateName clang_TemplateName_getAsQualifiedTemplateName(CXTemplateName TN);

CXDependentTemplateName clang_TemplateName_getAsDependentTemplateName(CXTemplateName TN);

CXUsingShadowDecl clang_TemplateName_getAsUsingShadowDecl(CXTemplateName TN);

CXTemplateName clang_TemplateName_getUnderlying(CXTemplateName TN);

CXTemplateName clang_TemplateName_getNameToSubstitute(CXTemplateName TN);

// The whole clang::TemplateNameDependence bitmask in one call. It is an LLVM bitmask
// enum whose combined enumerators duplicate values, so it crosses as a plain unsigned
// rather than a mirrored CX enum, the same way clang_Type_getDependence does. The bits
// (clang/AST/DependenceFlags.h) are 1 UnexpandedPack, 2 Instantiation, 4 Dependent and
// 8 Error -- the first three are also reachable one at a time through
// clang_TemplateName_containsUnexpandedParameterPack,
// clang_TemplateName_isInstantiationDependent and clang_TemplateName_isDependent.
unsigned clang_TemplateName_getDependence(CXTemplateName TN);

bool clang_TemplateName_isDependent(CXTemplateName TN);

bool clang_TemplateName_isInstantiationDependent(CXTemplateName TN);

bool clang_TemplateName_containsUnexpandedParameterPack(CXTemplateName TN);

// Mirrors clang::TemplateName::Qualified, the qualification mode TemplateName::print
// takes.
typedef enum CXTemplateName_Qualified {
  CXTemplateName_Qualified_None,
  CXTemplateName_Qualified_AsWritten,
  CXTemplateName_Qualified_Fully
} CXTemplateName_Qualified;

// helper -- TemplateName::print streamed into a string, under Ctx's own printing
// policy.
CXString clang_TemplateName_getAsString(CXTemplateName TN, CXASTContext Ctx,
                                        CXTemplateName_Qualified Qual);

void clang_TemplateName_dump(CXTemplateName TN);

// SubstTemplateTemplateParmStorage -- the storage behind a name of kind
// CXTemplateName_SubstTemplateTemplateParm. All three accessors are total.
CXDecl clang_SubstTemplateTemplateParmStorage_getAssociatedDecl(
    CXSubstTemplateTemplateParmStorage S);

unsigned
clang_SubstTemplateTemplateParmStorage_getIndex(CXSubstTemplateTemplateParmStorage S);

CXTemplateName
clang_SubstTemplateTemplateParmStorage_getReplacement(CXSubstTemplateTemplateParmStorage S);

// QualifiedTemplateName -- the storage behind a name of kind
// CXTemplateName_QualifiedTemplate, e.g. the `N::Tmpl` of a template template
// argument written with its qualifier. All three accessors are total.
CXNestedNameSpecifier clang_QualifiedTemplateName_getQualifier(CXQualifiedTemplateName QTN);

bool clang_QualifiedTemplateName_hasTemplateKeyword(CXQualifiedTemplateName QTN);

CXTemplateName
clang_QualifiedTemplateName_getUnderlyingTemplate(CXQualifiedTemplateName QTN);

// DependentTemplateName -- a template name that cannot be resolved before
// instantiation. Its name payload is a union discriminated by isIdentifier():
// PRECONDITION (Invariant 3) getIdentifier asserts isIdentifier() and getOperator
// asserts isOverloadedOperator(); reading the other arm is undefined behaviour. The
// Julia wrappers restate both as @assert.
CXNestedNameSpecifier clang_DependentTemplateName_getQualifier(CXDependentTemplateName DTN);

bool clang_DependentTemplateName_isIdentifier(CXDependentTemplateName DTN);

CXIdentifierInfo clang_DependentTemplateName_getIdentifier(CXDependentTemplateName DTN);

bool clang_DependentTemplateName_isOverloadedOperator(CXDependentTemplateName DTN);

CXOverloadedOperatorKind
clang_DependentTemplateName_getOperator(CXDependentTemplateName DTN);

// The pack index of the substitution, when it came from a pack expansion. Returns false and
// leaves *Out untouched when there is none (MARSHALLING.md §8).
bool clang_SubstTemplateTemplateParmStorage_getPackIndex(
    CXSubstTemplateTemplateParmStorage S, unsigned *Out);

// The template template parameter the substitution replaced.
CXTemplateTemplateParmDecl clang_SubstTemplateTemplateParmStorage_getParameter(
    CXSubstTemplateTemplateParmStorage S);

LLVM_CLANG_C_EXTERN_C_END

#endif