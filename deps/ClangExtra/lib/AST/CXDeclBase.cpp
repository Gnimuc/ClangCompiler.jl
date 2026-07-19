#include "clang-ex/AST/CXDeclBase.h"
#include "clang/AST/Decl.h"
#include "clang/AST/DeclBase.h"
#include "clang/AST/DeclCXX.h"
#include "clang/AST/DeclFriend.h"
#include "clang/AST/DeclObjC.h"
#include "clang/AST/DeclOpenMP.h"
#include "clang/AST/DeclTemplate.h"

// Drift alarm: the vendored DeclNodes.inc must match the pinned LLVM version.
// One assert per concrete class proves CXDeclKind equals clang's Decl::Kind
// value-for-value. (clang exposes no Decl-count sentinel like Stmt's
// lastStmtConstant, so a class appended at the very end of the enum in a future
// LLVM is only caught when DeclNodes.inc is re-vendored — the documented
// per-bump step — not by these asserts.)
#define DECL(DERIVED, BASE)                                                                \
  static_assert(static_cast<int>(CXDeclKind_##DERIVED) ==                                  \
                    static_cast<int>(clang::Decl::DERIVED),                                 \
                "CXDeclKind drift: " #DERIVED);
#define ABSTRACT_DECL(DECL)
#include "clang-ex/AST/DeclNodes.inc"

#define DECL(DERIVED, BASE)                                                                \
  CXDecl clang_Decl_castTo##DERIVED##Decl(CXDecl D) {                                       \
    return llvm::dyn_cast_or_null<clang::DERIVED##Decl>(static_cast<clang::Decl *>(D));     \
  }                                                                                         \
  bool clang_Decl_is##DERIVED##Decl(CXDecl D) {                                             \
    return llvm::isa_and_nonnull<clang::DERIVED##Decl>(static_cast<clang::Decl *>(D));      \
  }
#define ABSTRACT_DECL(DECL) DECL
#include "clang-ex/AST/DeclNodes.inc"

CXDeclKind clang_Decl_getKind(CXDecl D) {
  return static_cast<CXDeclKind>(static_cast<clang::Decl *>(D)->getKind());
}

bool clang_Decl_hasAttrs(CXDecl D) { return static_cast<clang::Decl *>(D)->hasAttrs(); }

unsigned clang_Decl_getNumAttrs(CXDecl D) {
  clang::Decl *DD = static_cast<clang::Decl *>(D);
  return DD->hasAttrs() ? DD->getAttrs().size() : 0;
}

CXAttr clang_Decl_getAttr(CXDecl D, unsigned I) {
  return static_cast<clang::Decl *>(D)->getAttrs()[I];
}

// Decl
CXSourceLocation_ clang_Decl_getLocation(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->getLocation().getPtrEncoding();
}

CXSourceLocation_ clang_Decl_getBeginLoc(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_Decl_getEndLoc(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->getEndLoc().getPtrEncoding();
}

const char *clang_Decl_getDeclKindName(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->getDeclKindName();
}

CXDecl clang_Decl_getNextDeclInContext(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->getNextDeclInContext();
}

CXDeclContext clang_Decl_getDeclContext(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->getDeclContext();
}

CXDecl clang_Decl_getNonClosureContext(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->getNonClosureContext();
}

CXTranslationUnitDecl clang_Decl_getTranslationUnitDecl(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->getTranslationUnitDecl();
}

bool clang_Decl_isInAnonymousNamespace(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->isInAnonymousNamespace();
}

bool clang_Decl_isInStdNamespace(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->isInStdNamespace();
}

CXASTContext clang_Decl_getASTContext(CXDecl DC) {
  return &static_cast<clang::Decl *>(DC)->getASTContext();
}

CXLangOptions clang_Decl_getLangOpts(CXDecl DC) {
  return const_cast<clang::LangOptions *>(&static_cast<clang::Decl *>(DC)->getLangOpts());
}

CXDeclContext clang_Decl_getLexicalDeclContext(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->getLexicalDeclContext();
}

bool clang_Decl_isOutOfLine(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->isOutOfLine();
}

void clang_Decl_setDeclContext(CXDecl DC, CXDeclContext Ctx) {
  return static_cast<clang::Decl *>(DC)->setDeclContext(
      static_cast<clang::DeclContext *>(Ctx));
}

void clang_Decl_setLexicalDeclContext(CXDecl DC, CXDeclContext Ctx) {
  return static_cast<clang::Decl *>(DC)->setLexicalDeclContext(
      static_cast<clang::DeclContext *>(Ctx));
}

bool clang_Decl_isTemplated(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->isTemplated();
}

unsigned clang_Decl_getTemplateDepth(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->getTemplateDepth();
}

bool clang_Decl_isDefinedOutsideFunctionOrMethod(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->isDefinedOutsideFunctionOrMethod();
}

bool clang_Decl_isInLocalScopeForInstantiation(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->isInLocalScopeForInstantiation();
}

CXDeclContext clang_Decl_getParentFunctionOrMethod(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->getParentFunctionOrMethod();
}

CXDecl clang_Decl_getCanonicalDecl(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->getCanonicalDecl();
}

bool clang_Decl_isCanonicalDecl(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->isCanonicalDecl();
}

CXDecl clang_Decl_getPreviousDecl(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->getPreviousDecl();
}

bool clang_Decl_isFirstDecl(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->isFirstDecl();
}

CXDecl clang_Decl_getMostRecentDecl(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->getMostRecentDecl();
}

bool clang_Decl_isTemplateParameter(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->isTemplateParameter();
}

bool clang_Decl_isTemplateParameterPack(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->isTemplateParameterPack();
}

bool clang_Decl_isParameterPack(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->isParameterPack();
}

// clang_Decl_isTemplateDecl is provided by the stamped is<Class>Decl family
// above (clang::Decl::isTemplateDecl() is isa<TemplateDecl>).

bool clang_Decl_isFunctionOrFunctionTemplate(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->isFunctionOrFunctionTemplate();
}

CXTemplateDecl clang_Decl_getDescribedTemplate(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->getDescribedTemplate();
}

CXTemplateParameterList clang_Decl_getDescribedTemplateParams(CXDecl DC) {
  return const_cast<clang::TemplateParameterList *>(
      static_cast<clang::Decl *>(DC)->getDescribedTemplateParams());
}

CXFunctionDecl clang_Decl_getAsFunction(CXDecl DC) {
  return static_cast<clang::Decl *>(DC)->getAsFunction();
}

void clang_Decl_dump(CXDecl DC) { static_cast<clang::Decl *>(DC)->dump(); }

void clang_Decl_dumpColor(CXDecl DC) { static_cast<clang::Decl *>(DC)->dumpColor(); }

int64_t clang_Decl_getID(CXDecl DC) { return static_cast<clang::Decl *>(DC)->getID(); }

CXFunctionType clang_Decl_getFunctionType(CXDecl DC, bool BlocksToo) {
  return const_cast<clang::FunctionType *>(
      static_cast<clang::Decl *>(DC)->getFunctionType(BlocksToo));
}

void clang_Decl_EnableStatistics(void) { clang::Decl::EnableStatistics(); }

void clang_Decl_PrintStats(void) { clang::Decl::PrintStats(); }

CXDeclContext clang_Decl_castToDeclContext(CXDecl D) {
  return clang::Decl::castToDeclContext(static_cast<clang::Decl *>(D));
}

CXDecl clang_Decl_castFromDeclContext(CXDeclContext DC) {
  return clang::Decl::castFromDeclContext(static_cast<clang::DeclContext *>(DC));
}

// DeclContext
CXTagDecl clang_DeclContext_castToTagDecl(CXDeclContext DC) {
  return llvm::dyn_cast_or_null<clang::TagDecl>(static_cast<clang::DeclContext *>(DC));
}

CXRecordDecl clang_DeclContext_castToRecordDecl(CXDeclContext DC) {
  return llvm::dyn_cast_or_null<clang::RecordDecl>(static_cast<clang::DeclContext *>(DC));
}

CXCXXRecordDecl clang_DeclContext_castToCXXRecordDecl(CXDeclContext DC) {
  return llvm::dyn_cast_or_null<clang::CXXRecordDecl>(
      static_cast<clang::DeclContext *>(DC));
}

const char *clang_DeclContext_getDeclKindName(CXDeclContext DC) {
  return static_cast<clang::DeclContext *>(DC)->getDeclKindName();
}

CXDeclContext clang_DeclContext_getParent(CXDeclContext DC) {
  return static_cast<clang::DeclContext *>(DC)->getParent();
}

CXDeclContext clang_DeclContext_getLexicalParent(CXDeclContext DC) {
  return static_cast<clang::DeclContext *>(DC)->getLexicalParent();
}

CXDeclContext clang_DeclContext_getLookupParent(CXDeclContext DC) {
  return static_cast<clang::DeclContext *>(DC)->getLookupParent();
}

CXASTContext clang_DeclContext_getParentASTContext(CXDeclContext DC) {
  return &static_cast<clang::DeclContext *>(DC)->getParentASTContext();
}

bool clang_DeclContext_isClosure(CXDeclContext DC) {
  return static_cast<clang::DeclContext *>(DC)->isClosure();
}

bool clang_DeclContext_isFunctionOrMethod(CXDeclContext DC) {
  return static_cast<clang::DeclContext *>(DC)->isFunctionOrMethod();
}

bool clang_DeclContext_isLookupContext(CXDeclContext DC) {
  return static_cast<clang::DeclContext *>(DC)->isLookupContext();
}

bool clang_DeclContext_isFileContext(CXDeclContext DC) {
  return static_cast<clang::DeclContext *>(DC)->isFileContext();
}

bool clang_DeclContext_isTranslationUnit(CXDeclContext DC) {
  return static_cast<clang::DeclContext *>(DC)->isTranslationUnit();
}

bool clang_DeclContext_isRecord(CXDeclContext DC) {
  return static_cast<clang::DeclContext *>(DC)->isRecord();
}

bool clang_DeclContext_isNamespace(CXDeclContext DC) {
  return static_cast<clang::DeclContext *>(DC)->isNamespace();
}

bool clang_DeclContext_isStdNamespace(CXDeclContext DC) {
  return static_cast<clang::DeclContext *>(DC)->isStdNamespace();
}

bool clang_DeclContext_isInlineNamespace(CXDeclContext DC) {
  return static_cast<clang::DeclContext *>(DC)->isInlineNamespace();
}

bool clang_DeclContext_isDependentContext(CXDeclContext DC) {
  return static_cast<clang::DeclContext *>(DC)->isDependentContext();
}

bool clang_DeclContext_isTransparentContext(CXDeclContext DC) {
  return static_cast<clang::DeclContext *>(DC)->isTransparentContext();
}

bool clang_DeclContext_isExternCContext(CXDeclContext DC) {
  return static_cast<clang::DeclContext *>(DC)->isExternCContext();
}

bool clang_DeclContext_isExternCXXContext(CXDeclContext DC) {
  return static_cast<clang::DeclContext *>(DC)->isExternCXXContext();
}

bool clang_DeclContext_Equals(CXDeclContext DC, CXDeclContext DC2) {
  return static_cast<clang::DeclContext *>(DC)->Equals(
      static_cast<clang::DeclContext *>(DC2));
}

CXDeclContext clang_DeclContext_getPrimaryContext(CXDeclContext DC) {
  return static_cast<clang::DeclContext *>(DC)->getPrimaryContext();
}

CXDecl clang_DeclContext_decl_iterator_begin(CXDeclContext DC) {
  return *static_cast<clang::DeclContext *>(DC)->decls_begin();
}

namespace {
size_t recursiveDeclCount(clang::DeclContext *DC) {
  size_t N = 0;
  for (clang::Decl *D : DC->decls()) {
    ++N;
    if (auto *Inner = llvm::dyn_cast<clang::DeclContext>(D))
      N += recursiveDeclCount(Inner);
  }
  return N;
}

void collectRecursiveDecls(clang::DeclContext *DC, CXDecl *&Nodes, CXDeclKind *&Kinds) {
  for (clang::Decl *D : DC->decls()) {
    *Nodes++ = D;
    *Kinds++ = static_cast<CXDeclKind>(D->getKind());
    if (auto *Inner = llvm::dyn_cast<clang::DeclContext>(D))
      collectRecursiveDecls(Inner, Nodes, Kinds);
  }
}
} // namespace

size_t clang_DeclContext_getRecursiveDeclCount(CXDeclContext DC) {
  return recursiveDeclCount(static_cast<clang::DeclContext *>(DC));
}

void clang_DeclContext_collectRecursiveDecls(CXDeclContext DC, CXDecl *Nodes,
                                             CXDeclKind *Kinds) {
  collectRecursiveDecls(static_cast<clang::DeclContext *>(DC), Nodes, Kinds);
}

void clang_DeclContext_addDecl(CXDeclContext DC, CXDecl D) {
  static_cast<clang::DeclContext *>(DC)->addDecl(static_cast<clang::Decl *>(D));
}

void clang_DeclContext_addDeclInternal(CXDeclContext DC, CXDecl D) {
  static_cast<clang::DeclContext *>(DC)->addDeclInternal(static_cast<clang::Decl *>(D));
}

void clang_DeclContext_addHiddenDecl(CXDeclContext DC, CXDecl D) {
  static_cast<clang::DeclContext *>(DC)->addHiddenDecl(static_cast<clang::Decl *>(D));
}

void clang_DeclContext_removeDecl(CXDeclContext DC, CXDecl D) {
  static_cast<clang::DeclContext *>(DC)->removeDecl(static_cast<clang::Decl *>(D));
}

void clang_DeclContext_containsDecl(CXDeclContext DC, CXDecl D) {
  static_cast<clang::DeclContext *>(DC)->containsDecl(static_cast<clang::Decl *>(D));
}

void clang_DeclContext_dumpDeclContext(CXDeclContext DC) {
  static_cast<clang::DeclContext *>(DC)->dumpDeclContext();
}

void clang_DeclContext_dumpLookups(CXDeclContext DC) {
  static_cast<clang::DeclContext *>(DC)->dumpLookups();
}
