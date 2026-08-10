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

bool clang_Parser_TryAnnotateTypeOrScopeToken(CXParser P, bool AllowImplicitTypename);

bool clang_Parser_TryAnnotateTypeOrScopeTokenAfterScopeSpec(CXParser P, CXCXXScopeSpec SS,
                                                            bool IsNewScope,
                                                            bool AllowImplicitTypename);

bool clang_Parser_TryAnnotateCXXScopeToken(CXParser P, bool EnteringContext);

bool clang_Parser_TryAnnotateOptionalCXXScopeToken(CXParser P, bool EnteringContext);

CXQualType clang_Parser_getTypeAnnotation(CXToken_ Tok);

// The incremental parse loop, as clang::IncrementalParser drives it: call
// clang_Parser_ParseFirstTopLevelDecl once per input, then clang_Parser_ParseTopLevelDecl
// until it returns true. Both return AtEOF and write the declaration group they parsed
// through *Result, which is a null DeclGroupRef when the increment produced none.
//
// *ImportState threads clang's Sema::ModuleImportState through the loop. It crosses as a
// plain unsigned rather than a mirrored enum on purpose: the caller never reads it, only
// hands the same cell back, and clang_Parser_ParseFirstTopLevelDecl initialises it. One
// cell per input, as upstream does -- sharing one across inputs is what a C++20 module
// declaration would need, and this library wraps no module support to need it.
bool clang_Parser_ParseFirstTopLevelDecl(CXParser P, CXDeclGroupRef *Result,
                                         unsigned *ImportState);

bool clang_Parser_ParseTopLevelDecl(CXParser P, CXDeclGroupRef *Result,
                                    unsigned *ImportState);

// clang/Parse/Parser.h: enum Parser::SkipUntilFlags. A bit set, so these are OR-able and
// the mirror is a plain unsigned parameter rather than an enum-typed one.
typedef enum CXSkipUntilFlags {
  CXSkipUntilFlags_StopAtSemi = 1 << 0,
  CXSkipUntilFlags_StopBeforeMatch = 1 << 1,
  CXSkipUntilFlags_StopAtCodeCompletion = 1 << 2
} CXSkipUntilFlags;

// Skip tokens until one of Toks is reached, returning whether one was found. This is how a
// driver of the incremental loop above recovers after a failed increment: without it the
// leftover tokens of the bad input are read as the start of the next one and the errors
// cascade.
//
// Toks holds NumToks tok::TokenKind values (the same currency CXTokenKinds.h mirrors).
// Flags is an OR of CXSkipUntilFlags; 0 means skip to the token unconditionally and consume
// it.
bool clang_Parser_SkipUntil(CXParser P, const unsigned *Toks, unsigned NumToks,
                            unsigned Flags);

LLVM_CLANG_C_EXTERN_C_END

#endif