#ifndef LIBCLANGEX_CXTEMPLATEBASE_H
#define LIBCLANGEX_CXTEMPLATEBASE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"
#include "llvm-c/ExecutionEngine.h"

#ifdef __cplusplus
extern "C" {
#endif

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

CINDEX_LINKAGE CXTemplateArgument
clang_TemplateArgument_constructFromQualType(CXQualType OpaquePtr, bool isNullPtr);

CINDEX_LINKAGE CXTemplateArgument
clang_TemplateArgument_constructFromValueDecl(CXValueDecl VD, CXQualType OpaquePtr);

CINDEX_LINKAGE CXTemplateArgument clang_TemplateArgument_constructFromIntegral(
    CXASTContext Ctx, LLVMGenericValueRef Val, CXQualType OpaquePtr);

CINDEX_LINKAGE void clang_TemplateArgument_dispose(CXTemplateArgument TA);

CINDEX_LINKAGE CXTemplateArgument_ArgKind
clang_TemplateArgument_getKind(CXTemplateArgument TA);

CINDEX_LINKAGE bool clang_TemplateArgument_isNull(CXTemplateArgument TA);

CINDEX_LINKAGE bool clang_TemplateArgument_isDependent(CXTemplateArgument TA);

CINDEX_LINKAGE bool clang_TemplateArgument_isInstantiationDependent(CXTemplateArgument TA);

CINDEX_LINKAGE CXQualType clang_TemplateArgument_getAsType(CXTemplateArgument TA);

CINDEX_LINKAGE CXValueDecl clang_TemplateArgument_getAsDecl(CXTemplateArgument TA);

CINDEX_LINKAGE CXQualType clang_TemplateArgument_getParamTypeForDecl(CXTemplateArgument TA);

CINDEX_LINKAGE CXQualType clang_TemplateArgument_getNullPtrType(CXTemplateArgument TA);

CINDEX_LINKAGE CXTemplateName clang_TemplateArgument_getAsTemplate(CXTemplateArgument TA);

CINDEX_LINKAGE CXTemplateName
clang_TemplateArgument_getAsTemplateOrTemplatePattern(CXTemplateArgument TA);

CINDEX_LINKAGE unsigned
clang_TemplateArgument_getNumTemplateExpansions(CXTemplateArgument TA);

CINDEX_LINKAGE LLVMGenericValueRef
clang_TemplateArgument_getAsIntegral(CXTemplateArgument TA);

CINDEX_LINKAGE CXQualType clang_TemplateArgument_getIntegralType(CXTemplateArgument TA);

CINDEX_LINKAGE void clang_TemplateArgument_setIntegralType(CXTemplateArgument TA,
                                                           CXQualType OpaquePtr);

CINDEX_LINKAGE CXQualType
clang_TemplateArgument_getNonTypeTemplateArgumentType(CXTemplateArgument TA);

CINDEX_LINKAGE void clang_TemplateArgument_dump(CXTemplateArgument TA);

#ifdef __cplusplus
}
#endif
#endif