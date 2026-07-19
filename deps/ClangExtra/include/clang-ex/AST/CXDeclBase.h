#ifndef LLVM_CLANG_C_EXTRA_CXDECLBASE_H
#define LLVM_CLANG_C_EXTRA_CXDECLBASE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// The Decl classification surface below is stamped from the vendored
// clang-ex/AST/DeclNodes.inc (a verbatim copy of clang's TableGen output for
// the pinned LLVM version). Mirror-by-construction: the same table clang uses
// to build clang::Decl::Kind builds CXDeclKind here, and the impl-side
// static_assert table in CXDeclBase.cpp proves value-for-value equality, so a
// stale vendored copy fails the build instead of shipping shifted values.
// POLICY: stamped symbols (CXDeclKind_* and the castTo/is families) are
// version-following per LLVM major, exempt from the frozen-ABI rule.

// Mirrors clang::Decl::Kind: one enumerator per CONCRETE class (the bare
// DeclNodes name, no "Decl" suffix) plus the first##Base/last##Base range
// markers, in DeclNodes.inc order; abstract classes get no enumerator (matching
// clang).
typedef enum CXDeclKind {
#define DECL(DERIVED, BASE) CXDeclKind_##DERIVED,
#define ABSTRACT_DECL(DECL)
#define DECL_RANGE(BASE, START, END)                                                       \
  CXDeclKind_first##BASE = CXDeclKind_##START, CXDeclKind_last##BASE = CXDeclKind_##END,
#define LAST_DECL_RANGE(BASE, START, END)                                                  \
  CXDeclKind_first##BASE = CXDeclKind_##START, CXDeclKind_last##BASE = CXDeclKind_##END
#include "clang-ex/AST/DeclNodes.inc"
} CXDeclKind;

// Null-safe downcast (dyn_cast_or_null) and kind predicate for every class in
// the hierarchy, ABSTRACT bases included. The wrapper name carries the full
// class spelling (DeclNodes name + "Decl"); stamped functions take and return
// plain CXDecl.
#define DECL(DERIVED, BASE)                                                                \
  CXDecl clang_Decl_castTo##DERIVED##Decl(CXDecl D);                                        \
  bool clang_Decl_is##DERIVED##Decl(CXDecl D);
#define ABSTRACT_DECL(DECL) DECL
#include "clang-ex/AST/DeclNodes.inc"

CXDeclKind clang_Decl_getKind(CXDecl D);

// attrs: Decl::attrs() as a count+index pair. getAttr returns the borrowed Attr*
// at position I (< getNumAttrs); classify it with clang_Attr_getKind.
bool clang_Decl_hasAttrs(CXDecl D);

unsigned clang_Decl_getNumAttrs(CXDecl D);

CXAttr clang_Decl_getAttr(CXDecl D, unsigned I);

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

// clang_Decl_isTemplateDecl is stamped from DeclNodes.inc above (the Template
// class): clang::Decl::isTemplateDecl() is isa<TemplateDecl>.
bool clang_Decl_isFunctionOrFunctionTemplate(CXDecl DC);

CXTemplateDecl clang_Decl_getDescribedTemplate(CXDecl DC);

CXTemplateParameterList clang_Decl_getDescribedTemplateParams(CXDecl DC);

CXFunctionDecl clang_Decl_getAsFunction(CXDecl DC);

void clang_Decl_dump(CXDecl DC);

void clang_Decl_dumpColor(CXDecl DC);

int64_t clang_Decl_getID(CXDecl DC);

CXFunctionType clang_Decl_getFunctionType(CXDecl DC, bool BlocksToo);

void clang_Decl_EnableStatistics(void);

void clang_Decl_PrintStats(void);

// Decl Cast — the Decl<->DeclContext pivot (DeclContext is not a Decl::Kind, so
// it is not part of the stamped castTo family above). Decl->Decl downcasts and
// kind predicates are stamped from DeclNodes.inc.
CXDeclContext clang_Decl_castToDeclContext(CXDecl D);

CXDecl clang_Decl_castFromDeclContext(CXDeclContext DC);

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