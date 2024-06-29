#ifndef LIBCLANGEX_CXDECLSPEC_H
#define LIBCLANGEX_CXDECLSPEC_H

#include "clang-ex/CXError.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

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
  CXDeclaratorContext_RequiresExpr
} CXDeclaratorContext;

CINDEX_LINKAGE CXCXXScopeSpec clang_CXXScopeSpec_create(CXInit_Error *ErrorCode);

CINDEX_LINKAGE void clang_CXXScopeSpec_dispose(CXCXXScopeSpec SS);

CINDEX_LINKAGE void clang_CXXScopeSpec_clear(CXCXXScopeSpec SS);

CINDEX_LINKAGE CXNestedNameSpecifier clang_CXXScopeSpec_getScopeRep(CXCXXScopeSpec SS);

CINDEX_LINKAGE CXSourceLocation_ clang_CXXScopeSpec_getBeginLoc(CXCXXScopeSpec SS);

CINDEX_LINKAGE CXSourceLocation_ clang_CXXScopeSpec_getEndLoc(CXCXXScopeSpec SS);

CINDEX_LINKAGE void clang_CXXScopeSpec_setBeginLoc(CXCXXScopeSpec SS,
                                                   CXSourceLocation_ Loc);

CINDEX_LINKAGE void clang_CXXScopeSpec_setEndLoc(CXCXXScopeSpec SS, CXSourceLocation_ Loc);

CINDEX_LINKAGE bool clang_CXXScopeSpec_isEmpty(CXCXXScopeSpec SS);

CINDEX_LINKAGE bool clang_CXXScopeSpec_isNotEmpty(CXCXXScopeSpec SS);

CINDEX_LINKAGE bool clang_CXXScopeSpec_isInvalid(CXCXXScopeSpec SS);

CINDEX_LINKAGE bool clang_CXXScopeSpec_isValid(CXCXXScopeSpec SS);

#ifdef __cplusplus
}
#endif
#endif