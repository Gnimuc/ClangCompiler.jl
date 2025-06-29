#ifndef LLVM_CLANG_C_EXTRA_CXDECLBASE_H
#define LLVM_CLANG_C_EXTRA_CXDECLBASE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Decl
CXSourceLocation_ clang_Decl_getLocation(CXDecl DC);

CXSourceLocation_ clang_Decl_getBeginLoc(CXDecl DC);

CXSourceLocation_ clang_Decl_getEndLoc(CXDecl DC);

const char *clang_Decl_getDeclKindName(CXDecl DC);

CXDecl clang_Decl_getNextDeclInContext(CXDecl DC);

CXDeclContext clang_Decl_getDeclContext(CXDecl DC);

CXDecl clang_Decl_getNonClosureContext(CXDecl DC);

CXTranslationUnitDecl clang_Decl_getTranslationUnitDecl(CXDecl DC);

bool clang_Decl_isInAnonymousNamespace(CXDecl DC);

bool clang_Decl_isInStdNamespace(CXDecl DC);

CXASTContext clang_Decl_getASTContext(CXDecl DC);

CXLangOptions clang_Decl_getLangOpts(CXDecl DC);

CXDeclContext clang_Decl_getLexicalDeclContext(CXDecl DC);

bool clang_Decl_isOutOfLine(CXDecl DC);

void clang_Decl_setDeclContext(CXDecl DC, CXDeclContext Ctx);

void clang_Decl_setLexicalDeclContext(CXDecl DC, CXDeclContext Ctx);

bool clang_Decl_isTemplated(CXDecl DC);

unsigned clang_Decl_getTemplateDepth(CXDecl DC);

bool clang_Decl_isDefinedOutsideFunctionOrMethod(CXDecl DC);

bool clang_Decl_isInLocalScopeForInstantiation(CXDecl DC);

CXDeclContext clang_Decl_getParentFunctionOrMethod(CXDecl DC);

CXDecl clang_Decl_getCanonicalDecl(CXDecl DC);

bool clang_Decl_isCanonicalDecl(CXDecl DC);

CXDecl clang_Decl_getPreviousDecl(CXDecl DC);

bool clang_Decl_isFirstDecl(CXDecl DC);

CXDecl clang_Decl_getMostRecentDecl(CXDecl DC);

bool clang_Decl_isTemplateParameter(CXDecl DC);

bool clang_Decl_isTemplateParameterPack(CXDecl DC);

bool clang_Decl_isParameterPack(CXDecl DC);

bool clang_Decl_isTemplateDecl(CXDecl DC);

CXTemplateDecl clang_Decl_getDescribedTemplate(CXDecl DC);

CXTemplateParameterList clang_Decl_getDescribedTemplateParams(CXDecl DC);

CXFunctionDecl clang_Decl_getAsFunction(CXDecl DC);

void clang_Decl_dump(CXDecl DC);

void clang_Decl_dumpColor(CXDecl DC);

int64_t clang_Decl_getID(CXDecl DC);

CXFunctionType clang_Decl_getFunctionType(CXDecl DC, bool BlocksToo);

void clang_Decl_EnableStatistics(void);

void clang_Decl_PrintStats(void);

// Decl Cast
CXDeclContext clang_Decl_castToDeclContext(CXDecl D);

CXDecl clang_Decl_castFromDeclContext(CXDeclContext DC);

CXClassTemplateDecl clang_Decl_castToClassTemplateDecl(CXDecl DC);

CXValueDecl clang_Decl_castToValueDecl(CXDecl DC);

CXCXXConstructorDecl clang_Decl_castToCXXConstructorDecl(CXDecl D);

// DeclContext
CXTagDecl clang_DeclContext_castToTagDecl(CXDeclContext DC);

CXRecordDecl clang_DeclContext_castToRecordDecl(CXDeclContext DC);

CXCXXRecordDecl clang_DeclContext_castToCXXRecordDecl(CXDeclContext DC);

const char *clang_DeclContext_getDeclKindName(CXDeclContext DC);

CXDeclContext clang_DeclContext_getParent(CXDeclContext DC);

CXDeclContext clang_DeclContext_getLexicalParent(CXDeclContext DC);

CXDeclContext clang_DeclContext_getLookupParent(CXDeclContext DC);

CXASTContext clang_DeclContext_getParentASTContext(CXDeclContext DC);

bool clang_DeclContext_isClosure(CXDeclContext DC);

bool clang_DeclContext_isFunctionOrMethod(CXDeclContext DC);

bool clang_DeclContext_isLookupContext(CXDeclContext DC);

bool clang_DeclContext_isFileContext(CXDeclContext DC);

bool clang_DeclContext_isTranslationUnit(CXDeclContext DC);

bool clang_DeclContext_isRecord(CXDeclContext DC);

bool clang_DeclContext_isNamespace(CXDeclContext DC);

bool clang_DeclContext_isStdNamespace(CXDeclContext DC);

bool clang_DeclContext_isInlineNamespace(CXDeclContext DC);

bool clang_DeclContext_isDependentContext(CXDeclContext DC);

bool clang_DeclContext_isTransparentContext(CXDeclContext DC);

bool clang_DeclContext_isExternCContext(CXDeclContext DC);

bool clang_DeclContext_isExternCXXContext(CXDeclContext DC);

bool clang_DeclContext_Equals(CXDeclContext DC, CXDeclContext DC2);

CXDeclContext clang_DeclContext_getPrimaryContext(CXDeclContext DC);

CXDecl clang_DeclContext_decl_iterator_begin(CXDeclContext DC);

void clang_DeclContext_addDecl(CXDeclContext DC, CXDecl D);

void clang_DeclContext_addDeclInternal(CXDeclContext DC, CXDecl D);

void clang_DeclContext_addHiddenDecl(CXDeclContext DC, CXDecl D);

void clang_DeclContext_removeDecl(CXDeclContext DC, CXDecl D);

void clang_DeclContext_containsDecl(CXDeclContext DC, CXDecl D);

void clang_DeclContext_dumpDeclContext(CXDeclContext DC);

void clang_DeclContext_dumpLookups(CXDeclContext DC);

LLVM_CLANG_C_EXTERN_C_END

#endif