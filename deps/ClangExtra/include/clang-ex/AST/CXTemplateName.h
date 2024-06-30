#ifndef LLVM_CLANG_C_EXTRA_CXTEMPLATENAME_H
#define LLVM_CLANG_C_EXTRA_CXTEMPLATENAME_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

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

CXTemplateName clang_TemplateName_getUnderlying(CXTemplateName TN);

CXTemplateName clang_TemplateName_getNameToSubstitute(CXTemplateName TN);

bool clang_TemplateName_isDependent(CXTemplateName TN);

bool clang_TemplateName_isInstantiationDependent(CXTemplateName TN);

bool clang_TemplateName_containsUnexpandedParameterPack(CXTemplateName TN);

void clang_TemplateName_dump(CXTemplateName TN);

LLVM_CLANG_C_EXTERN_C_END

#endif