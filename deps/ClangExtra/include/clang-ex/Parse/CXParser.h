#ifndef LLVM_CLANG_C_EXTRA_CXPARSER_H
#define LLVM_CLANG_C_EXTRA_CXPARSER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

typedef enum CXDeclSpecContext {
  CXDeclSpecContext_DSC_normal,
  CXDeclSpecContext_DSC_class,
  CXDeclSpecContext_DSC_type_specifier,
  CXDeclSpecContext_DSC_trailing,
  CXDeclSpecContext_DSC_alias_declaration,
  CXDeclSpecContext_DSC_conv_operator,
  CXDeclSpecContext_DSC_top_level,
  CXDeclSpecContext_DSC_template_param,
  CXDeclSpecContext_DSC_template_arg,
  CXDeclSpecContext_DSC_template_type_arg,
  CXDeclSpecContext_DSC_objc_method_result,
  CXDeclSpecContext_DSC_condition,
  CXDeclSpecContext_DSC_association,
  CXDeclSpecContext_DSC_new
} CXDeclSpecContext;

CXParser clang_Parser_create(CXPreprocessor PP, CXSema Actions, bool SkipFunctionBodies);

void clang_Parser_dispose(CXParser P);

void clang_Parser_Initialize(CXParser P);

CXLangOptions clang_Parser_getLangOpts(CXParser P);

CXTargetInfo_ clang_Parser_getTargetInfo(CXParser P);

CXPreprocessor clang_Parser_getPreprocessor(CXParser P);

CXSema clang_Parser_getActions(CXParser P);

CXToken_ clang_Parser_getCurToken(CXParser P);

CXToken_ clang_Parser_NextToken(CXParser P);

CXScope clang_Parser_getCurScope(CXParser P);

CXSourceLocation_ clang_Parser_ConsumeToken(CXParser P);

CXSourceLocation_ clang_Parser_ConsumeAnyToken(CXParser P);

bool clang_Parser_TryAnnotateCXXScopeToken(CXParser P, bool EnteringContext);

// bool clang_Parser_TryAnnotateTypeOrScopeTokenAfterScopeSpec(CXParser P, CXCXXScopeSpec
// SS,
//                                                             bool IsNewScope);

// CXDeclGroupRef clang_Parser_parseOneTopLevelDecl(CXParser Parser, bool IsFirstDecl);

LLVM_CLANG_C_EXTERN_C_END

#endif