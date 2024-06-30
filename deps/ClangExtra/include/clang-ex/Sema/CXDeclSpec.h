#ifndef LLVM_CLANG_C_EXTRA_CXDECLSPEC_H
#define LLVM_CLANG_C_EXTRA_CXDECLSPEC_H

#include "clang-ex/CXError.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

typedef enum CXDeclaratorContext {
  CXDeclaratorContext_File,
  CXDeclaratorContext_Prototype,
  CXDeclaratorContext_ObjCResult,
  CXDeclaratorContext_ObjCParameter,
  CXDeclaratorContext_KNRTypeList,
  CXDeclaratorContext_TypeName,
  CXDeclaratorContext_FunctionalCast,
  CXDeclaratorContext_Member,
  CXDeclaratorContext_Block,
  CXDeclaratorContext_ForInit,
  CXDeclaratorContext_SelectionInit,
  CXDeclaratorContext_Condition,
  CXDeclaratorContext_TemplateParam,
  CXDeclaratorContext_CXXNew,
  CXDeclaratorContext_CXXCatch,
  CXDeclaratorContext_ObjCCatch,
  CXDeclaratorContext_BlockLiteral,
  CXDeclaratorContext_LambdaExpr,
  CXDeclaratorContext_LambdaExprParameter,
  CXDeclaratorContext_ConversionId,
  CXDeclaratorContext_TrailingReturn,
  CXDeclaratorContext_TrailingReturnVar,
  CXDeclaratorContext_TemplateArg,
  CXDeclaratorContext_TemplateTypeArg,
  CXDeclaratorContext_AliasDecl,
  CXDeclaratorContext_AliasTemplate,
  CXDeclaratorContext_RequiresExpr,
  CXDeclaratorContext_Association
} CXDeclaratorContext;

CXCXXScopeSpec clang_CXXScopeSpec_create(CXInit_Error *ErrorCode);

void clang_CXXScopeSpec_dispose(CXCXXScopeSpec SS);

void clang_CXXScopeSpec_clear(CXCXXScopeSpec SS);

CXNestedNameSpecifier clang_CXXScopeSpec_getScopeRep(CXCXXScopeSpec SS);

CXSourceLocation_ clang_CXXScopeSpec_getBeginLoc(CXCXXScopeSpec SS);

CXSourceLocation_ clang_CXXScopeSpec_getEndLoc(CXCXXScopeSpec SS);

void clang_CXXScopeSpec_setBeginLoc(CXCXXScopeSpec SS, CXSourceLocation_ Loc);

void clang_CXXScopeSpec_setEndLoc(CXCXXScopeSpec SS, CXSourceLocation_ Loc);

bool clang_CXXScopeSpec_isEmpty(CXCXXScopeSpec SS);

bool clang_CXXScopeSpec_isNotEmpty(CXCXXScopeSpec SS);

bool clang_CXXScopeSpec_isInvalid(CXCXXScopeSpec SS);

bool clang_CXXScopeSpec_isValid(CXCXXScopeSpec SS);

LLVM_CLANG_C_EXTERN_C_END

#endif