#ifndef LIBCLANGEX_CXDECLBASE_H
#define LIBCLANGEX_CXDECLBASE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

// Decl
CINDEX_LINKAGE CXSourceLocation_ clang_Decl_getLocation(CXDecl DC);

CINDEX_LINKAGE CXSourceLocation_ clang_Decl_getBeginLoc(CXDecl DC);

CINDEX_LINKAGE CXSourceLocation_ clang_Decl_getEndLoc(CXDecl DC);

CINDEX_LINKAGE const char *clang_Decl_getDeclKindName(CXDecl DC);

CINDEX_LINKAGE CXDecl clang_Decl_getNextDeclInContext(CXDecl DC);

CINDEX_LINKAGE CXDeclContext clang_Decl_getDeclContext(CXDecl DC);

CINDEX_LINKAGE CXDecl clang_Decl_getNonClosureContext(CXDecl DC);

CINDEX_LINKAGE CXTranslationUnitDecl clang_Decl_getTranslationUnitDecl(CXDecl DC);

CINDEX_LINKAGE bool clang_Decl_isInAnonymousNamespace(CXDecl DC);

CINDEX_LINKAGE bool clang_Decl_isInStdNamespace(CXDecl DC);

CINDEX_LINKAGE CXASTContext clang_Decl_getASTContext(CXDecl DC);

CINDEX_LINKAGE CXLangOptions clang_Decl_getLangOpts(CXDecl DC);

CINDEX_LINKAGE CXDeclContext clang_Decl_getLexicalDeclContext(CXDecl DC);

CINDEX_LINKAGE bool clang_Decl_isOutOfLine(CXDecl DC);

CINDEX_LINKAGE void clang_Decl_setDeclContext(CXDecl DC, CXDeclContext Ctx);

CINDEX_LINKAGE void clang_Decl_setLexicalDeclContext(CXDecl DC, CXDeclContext Ctx);

CINDEX_LINKAGE bool clang_Decl_isTemplated(CXDecl DC);

CINDEX_LINKAGE unsigned clang_Decl_getTemplateDepth(CXDecl DC);

CINDEX_LINKAGE bool clang_Decl_isDefinedOutsideFunctionOrMethod(CXDecl DC);

CINDEX_LINKAGE bool clang_Decl_isInLocalScopeForInstantiation(CXDecl DC);

CINDEX_LINKAGE CXDeclContext clang_Decl_getParentFunctionOrMethod(CXDecl DC);

CINDEX_LINKAGE CXDecl clang_Decl_getCanonicalDecl(CXDecl DC);

CINDEX_LINKAGE bool clang_Decl_isCanonicalDecl(CXDecl DC);

CINDEX_LINKAGE CXDecl clang_Decl_getPreviousDecl(CXDecl DC);

CINDEX_LINKAGE bool clang_Decl_isFirstDecl(CXDecl DC);

CINDEX_LINKAGE CXDecl clang_Decl_getMostRecentDecl(CXDecl DC);

CINDEX_LINKAGE bool clang_Decl_isTemplateParameter(CXDecl DC);

CINDEX_LINKAGE bool clang_Decl_isTemplateParameterPack(CXDecl DC);

CINDEX_LINKAGE bool clang_Decl_isParameterPack(CXDecl DC);

CINDEX_LINKAGE bool clang_Decl_isTemplateDecl(CXDecl DC);

CINDEX_LINKAGE CXTemplateDecl clang_Decl_getDescribedTemplate(CXDecl DC);

CINDEX_LINKAGE CXTemplateParameterList clang_Decl_getDescribedTemplateParams(CXDecl DC);

CINDEX_LINKAGE CXFunctionDecl clang_Decl_getAsFunction(CXDecl DC);

CINDEX_LINKAGE void clang_Decl_dump(CXDecl DC);

CINDEX_LINKAGE void clang_Decl_dumpColor(CXDecl DC);

CINDEX_LINKAGE int64_t clang_Decl_getID(CXDecl DC);

CINDEX_LINKAGE CXFunctionType clang_Decl_getFunctionType(CXDecl DC, bool BlocksToo);

CINDEX_LINKAGE void clang_Decl_EnableStatistics(void);

CINDEX_LINKAGE void clang_Decl_PrintStats(void);

// Decl Cast
CINDEX_LINKAGE CXDeclContext clang_Decl_castToDeclContext(CXDecl D);

CINDEX_LINKAGE CXDecl clang_Decl_castFromDeclContext(CXDeclContext DC);

CINDEX_LINKAGE CXClassTemplateDecl clang_Decl_castToClassTemplateDecl(CXDecl DC);

CINDEX_LINKAGE CXValueDecl clang_Decl_castToValueDecl(CXDecl DC);

// DeclContext
CINDEX_LINKAGE CXTagDecl clang_DeclContext_castToTagDecl(CXDeclContext DC);

CINDEX_LINKAGE CXRecordDecl clang_DeclContext_castToRecordDecl(CXDeclContext DC);

CINDEX_LINKAGE CXCXXRecordDecl clang_DeclContext_castToCXXRecordDecl(CXDeclContext DC);

CINDEX_LINKAGE const char *clang_DeclContext_getDeclKindName(CXDeclContext DC);

CINDEX_LINKAGE CXDeclContext clang_DeclContext_getParent(CXDeclContext DC);

CINDEX_LINKAGE CXDeclContext clang_DeclContext_getLexicalParent(CXDeclContext DC);

CINDEX_LINKAGE CXDeclContext clang_DeclContext_getLookupParent(CXDeclContext DC);

CINDEX_LINKAGE CXASTContext clang_DeclContext_getParentASTContext(CXDeclContext DC);

CINDEX_LINKAGE bool clang_DeclContext_isClosure(CXDeclContext DC);

CINDEX_LINKAGE bool clang_DeclContext_isFunctionOrMethod(CXDeclContext DC);

CINDEX_LINKAGE bool clang_DeclContext_isLookupContext(CXDeclContext DC);

CINDEX_LINKAGE bool clang_DeclContext_isFileContext(CXDeclContext DC);

CINDEX_LINKAGE bool clang_DeclContext_isTranslationUnit(CXDeclContext DC);

CINDEX_LINKAGE bool clang_DeclContext_isRecord(CXDeclContext DC);

CINDEX_LINKAGE bool clang_DeclContext_isNamespace(CXDeclContext DC);

CINDEX_LINKAGE bool clang_DeclContext_isStdNamespace(CXDeclContext DC);

CINDEX_LINKAGE bool clang_DeclContext_isInlineNamespace(CXDeclContext DC);

CINDEX_LINKAGE bool clang_DeclContext_isDependentContext(CXDeclContext DC);

CINDEX_LINKAGE bool clang_DeclContext_isTransparentContext(CXDeclContext DC);

CINDEX_LINKAGE bool clang_DeclContext_isExternCContext(CXDeclContext DC);

CINDEX_LINKAGE bool clang_DeclContext_isExternCXXContext(CXDeclContext DC);

CINDEX_LINKAGE bool clang_DeclContext_Equals(CXDeclContext DC, CXDeclContext DC2);

CINDEX_LINKAGE CXDeclContext clang_DeclContext_getPrimaryContext(CXDeclContext DC);

CINDEX_LINKAGE CXDecl clang_DeclContext_decl_iterator_begin(CXDeclContext DC);

CINDEX_LINKAGE void clang_DeclContext_addDecl(CXDeclContext DC, CXDecl D);

CINDEX_LINKAGE void clang_DeclContext_addDeclInternal(CXDeclContext DC, CXDecl D);

CINDEX_LINKAGE void clang_DeclContext_addHiddenDecl(CXDeclContext DC, CXDecl D);

CINDEX_LINKAGE void clang_DeclContext_removeDecl(CXDeclContext DC, CXDecl D);

CINDEX_LINKAGE void clang_DeclContext_containsDecl(CXDeclContext DC, CXDecl D);

CINDEX_LINKAGE void clang_DeclContext_dumpDeclContext(CXDeclContext DC);

CINDEX_LINKAGE void clang_DeclContext_dumpLookups(CXDeclContext DC);

#ifdef __cplusplus
}
#endif
#endif