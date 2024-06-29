#ifndef LLVM_CLANG_C_EXTRA_CXTEMPLATEBASE_H
#define LLVM_CLANG_C_EXTRA_CXTEMPLATEBASE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/ExecutionEngine.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

typedef enum CXTemplateArgument_ArgKind {
  CXTemplateArgument_Null = 0,
  CXTemplateArgument_Type,
  CXTemplateArgument_Declaration,
  CXTemplateArgument_NullPtr,
  CXTemplateArgument_Integral,
  CXTemplateArgument_Template,
  CXTemplateArgument_TemplateExpansion,
  CXTemplateArgument_Expression,
  CXTemplateArgument_Pack
} CXTemplateArgument_ArgKind;

CXTemplateArgument clang_TemplateArgument_constructFromQualType(CXQualType OpaquePtr,
                                                                bool isNullPtr);

CXTemplateArgument clang_TemplateArgument_constructFromValueDecl(CXValueDecl VD,
                                                                 CXQualType OpaquePtr);

CXTemplateArgument clang_TemplateArgument_constructFromIntegral(CXASTContext Ctx,
                                                                LLVMGenericValueRef Val,
                                                                CXQualType OpaquePtr);

void clang_TemplateArgument_dispose(CXTemplateArgument TA);

CXTemplateArgument_ArgKind clang_TemplateArgument_getKind(CXTemplateArgument TA);

bool clang_TemplateArgument_isNull(CXTemplateArgument TA);

bool clang_TemplateArgument_isDependent(CXTemplateArgument TA);

bool clang_TemplateArgument_isInstantiationDependent(CXTemplateArgument TA);

CXQualType clang_TemplateArgument_getAsType(CXTemplateArgument TA);

CXValueDecl clang_TemplateArgument_getAsDecl(CXTemplateArgument TA);

CXQualType clang_TemplateArgument_getParamTypeForDecl(CXTemplateArgument TA);

CXQualType clang_TemplateArgument_getNullPtrType(CXTemplateArgument TA);

CXTemplateName clang_TemplateArgument_getAsTemplate(CXTemplateArgument TA);

CXTemplateName clang_TemplateArgument_getAsTemplateOrTemplatePattern(CXTemplateArgument TA);

unsigned clang_TemplateArgument_getNumTemplateExpansions(CXTemplateArgument TA);

LLVMGenericValueRef clang_TemplateArgument_getAsIntegral(CXTemplateArgument TA);

CXQualType clang_TemplateArgument_getIntegralType(CXTemplateArgument TA);

void clang_TemplateArgument_setIntegralType(CXTemplateArgument TA, CXQualType OpaquePtr);

CXQualType clang_TemplateArgument_getNonTypeTemplateArgumentType(CXTemplateArgument TA);

void clang_TemplateArgument_dump(CXTemplateArgument TA);

LLVM_CLANG_C_EXTERN_C_END

#endif