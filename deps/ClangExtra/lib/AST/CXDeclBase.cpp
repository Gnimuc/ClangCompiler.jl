#include "clang-ex/AST/CXDeclBase.h"
#include "utils.h"
#include "clang/AST/Decl.h"
#include "clang/AST/DeclBase.h"
#include "clang/AST/DeclCXX.h"
#include "clang/AST/DeclFriend.h"
#include "clang/AST/DeclObjC.h"
#include "clang/AST/DeclOpenMP.h"
#include "clang/AST/DeclTemplate.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/Attr.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/raw_ostream.h"
#include "clang/AST/DeclLookups.h"

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
  CX##DERIVED##Decl clang_Decl_castTo##DERIVED##Decl(CXDecl D) {                            \
    return reinterpret_cast<CX##DERIVED##Decl>(                                             \
        llvm::dyn_cast_or_null<clang::DERIVED##Decl>(                                       \
            reinterpret_cast<clang::Decl *>(D)));                                           \
  }                                                                                         \
  bool clang_Decl_is##DERIVED##Decl(CXDecl D) {                                             \
    return llvm::isa_and_nonnull<clang::DERIVED##Decl>(                                     \
        reinterpret_cast<clang::Decl *>(D));                                                \
  }
#define ABSTRACT_DECL(DECL) DECL
#include "clang-ex/AST/DeclNodes.inc"

CXDeclKind clang_Decl_getKind(CXDecl D) {
  return static_cast<CXDeclKind>(reinterpret_cast<clang::Decl *>(D)->getKind());
}

bool clang_Decl_hasAttrs(CXDecl D) { return reinterpret_cast<clang::Decl *>(D)->hasAttrs(); }

unsigned clang_Decl_getNumAttrs(CXDecl D) {
  clang::Decl *DD = reinterpret_cast<clang::Decl *>(D);
  return DD->hasAttrs() ? DD->getAttrs().size() : 0;
}

CXAttr clang_Decl_getAttr(CXDecl D, unsigned I) {
  return reinterpret_cast<CXAttr>(reinterpret_cast<clang::Decl *>(D)->getAttrs()[I]);
}

void clang_Decl_setAttrs(CXDecl D, CXAttr *Attrs, unsigned NumAttrs) {
  clang::AttrVec V;
  V.reserve(NumAttrs);
  for (unsigned I = 0; I != NumAttrs; ++I)
    V.push_back(reinterpret_cast<clang::Attr *>(Attrs[I]));
  reinterpret_cast<clang::Decl *>(D)->setAttrs(V);
}

// Decl
CXSourceLocation_ clang_Decl_getLocation(CXDecl DC) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Decl *>(DC)->getLocation().getPtrEncoding());
}

CXSourceLocation_ clang_Decl_getBeginLoc(CXDecl DC) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Decl *>(DC)->getBeginLoc().getPtrEncoding());
}

CXSourceLocation_ clang_Decl_getEndLoc(CXDecl DC) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Decl *>(DC)->getEndLoc().getPtrEncoding());
}

const char *clang_Decl_getDeclKindName(CXDecl DC) {
  return reinterpret_cast<clang::Decl *>(DC)->getDeclKindName();
}

CXDecl clang_Decl_getNextDeclInContext(CXDecl DC) {
  return reinterpret_cast<CXDecl>(reinterpret_cast<clang::Decl *>(DC)->getNextDeclInContext());
}

CXDeclContext clang_Decl_getDeclContext(CXDecl DC) {
  return reinterpret_cast<CXDeclContext>(reinterpret_cast<clang::Decl *>(DC)->getDeclContext());
}

CXDecl clang_Decl_getNonClosureContext(CXDecl DC) {
  return reinterpret_cast<CXDecl>(reinterpret_cast<clang::Decl *>(DC)->getNonClosureContext());
}

CXTranslationUnitDecl clang_Decl_getTranslationUnitDecl(CXDecl DC) {
  return reinterpret_cast<CXTranslationUnitDecl>(reinterpret_cast<clang::Decl *>(DC)->getTranslationUnitDecl());
}

bool clang_Decl_isInAnonymousNamespace(CXDecl DC) {
  return reinterpret_cast<clang::Decl *>(DC)->isInAnonymousNamespace();
}

bool clang_Decl_isInStdNamespace(CXDecl DC) {
  return reinterpret_cast<clang::Decl *>(DC)->isInStdNamespace();
}

CXASTContext clang_Decl_getASTContext(CXDecl DC) {
  return reinterpret_cast<CXASTContext>(&reinterpret_cast<clang::Decl *>(DC)->getASTContext());
}

CXLangOptions clang_Decl_getLangOpts(CXDecl DC) {
  return reinterpret_cast<CXLangOptions>(const_cast<clang::LangOptions *>(&reinterpret_cast<clang::Decl *>(DC)->getLangOpts()));
}

CXDeclContext clang_Decl_getLexicalDeclContext(CXDecl DC) {
  return reinterpret_cast<CXDeclContext>(reinterpret_cast<clang::Decl *>(DC)->getLexicalDeclContext());
}

bool clang_Decl_isOutOfLine(CXDecl DC) {
  return reinterpret_cast<clang::Decl *>(DC)->isOutOfLine();
}

void clang_Decl_setDeclContext(CXDecl DC, CXDeclContext Ctx) {
  return reinterpret_cast<clang::Decl *>(DC)->setDeclContext(
      reinterpret_cast<clang::DeclContext *>(Ctx));
}

void clang_Decl_setLexicalDeclContext(CXDecl DC, CXDeclContext Ctx) {
  return reinterpret_cast<clang::Decl *>(DC)->setLexicalDeclContext(
      reinterpret_cast<clang::DeclContext *>(Ctx));
}

bool clang_Decl_isTemplated(CXDecl DC) {
  return reinterpret_cast<clang::Decl *>(DC)->isTemplated();
}

unsigned clang_Decl_getTemplateDepth(CXDecl DC) {
  return reinterpret_cast<clang::Decl *>(DC)->getTemplateDepth();
}

bool clang_Decl_isDefinedOutsideFunctionOrMethod(CXDecl DC) {
  return reinterpret_cast<clang::Decl *>(DC)->isDefinedOutsideFunctionOrMethod();
}

bool clang_Decl_isInLocalScopeForInstantiation(CXDecl DC) {
  return reinterpret_cast<clang::Decl *>(DC)->isInLocalScopeForInstantiation();
}

CXDeclContext clang_Decl_getParentFunctionOrMethod(CXDecl DC) {
  return reinterpret_cast<CXDeclContext>(reinterpret_cast<clang::Decl *>(DC)->getParentFunctionOrMethod());
}

CXDecl clang_Decl_getCanonicalDecl(CXDecl DC) {
  return reinterpret_cast<CXDecl>(reinterpret_cast<clang::Decl *>(DC)->getCanonicalDecl());
}

bool clang_Decl_isCanonicalDecl(CXDecl DC) {
  return reinterpret_cast<clang::Decl *>(DC)->isCanonicalDecl();
}

CXDecl clang_Decl_getPreviousDecl(CXDecl DC) {
  return reinterpret_cast<CXDecl>(reinterpret_cast<clang::Decl *>(DC)->getPreviousDecl());
}

bool clang_Decl_isFirstDecl(CXDecl DC) {
  return reinterpret_cast<clang::Decl *>(DC)->isFirstDecl();
}

CXDecl clang_Decl_getMostRecentDecl(CXDecl DC) {
  return reinterpret_cast<CXDecl>(reinterpret_cast<clang::Decl *>(DC)->getMostRecentDecl());
}

bool clang_Decl_isTemplateParameter(CXDecl DC) {
  return reinterpret_cast<clang::Decl *>(DC)->isTemplateParameter();
}

bool clang_Decl_isTemplateParameterPack(CXDecl DC) {
  return reinterpret_cast<clang::Decl *>(DC)->isTemplateParameterPack();
}

bool clang_Decl_isParameterPack(CXDecl DC) {
  return reinterpret_cast<clang::Decl *>(DC)->isParameterPack();
}

// clang_Decl_isTemplateDecl is provided by the stamped is<Class>Decl family
// above (clang::Decl::isTemplateDecl() is isa<TemplateDecl>).

bool clang_Decl_isFunctionOrFunctionTemplate(CXDecl DC) {
  return reinterpret_cast<clang::Decl *>(DC)->isFunctionOrFunctionTemplate();
}

CXTemplateDecl clang_Decl_getDescribedTemplate(CXDecl DC) {
  return reinterpret_cast<CXTemplateDecl>(reinterpret_cast<clang::Decl *>(DC)->getDescribedTemplate());
}

CXTemplateParameterList clang_Decl_getDescribedTemplateParams(CXDecl DC) {
  return reinterpret_cast<CXTemplateParameterList>(const_cast<clang::TemplateParameterList *>(
      reinterpret_cast<clang::Decl *>(DC)->getDescribedTemplateParams()));
}

CXFunctionDecl clang_Decl_getAsFunction(CXDecl DC) {
  return reinterpret_cast<CXFunctionDecl>(reinterpret_cast<clang::Decl *>(DC)->getAsFunction());
}

void clang_Decl_dump(CXDecl DC) { reinterpret_cast<clang::Decl *>(DC)->dump(); }

void clang_Decl_dumpColor(CXDecl DC) { reinterpret_cast<clang::Decl *>(DC)->dumpColor(); }

int64_t clang_Decl_getID(CXDecl DC) { return reinterpret_cast<clang::Decl *>(DC)->getID(); }

CXFunctionType clang_Decl_getFunctionType(CXDecl DC, bool BlocksToo) {
  return reinterpret_cast<CXFunctionType>(const_cast<clang::FunctionType *>(
      reinterpret_cast<clang::Decl *>(DC)->getFunctionType(BlocksToo)));
}

void clang_Decl_EnableStatistics(void) { clang::Decl::EnableStatistics(); }

void clang_Decl_PrintStats(void) { clang::Decl::PrintStats(); }

CXSourceRange_ clang_Decl_getSourceRange(CXDecl D) {
  auto rng = reinterpret_cast<clang::Decl *>(D)->getSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

void clang_Decl_setLocation(CXDecl D, CXSourceLocation_ L) {
  reinterpret_cast<clang::Decl *>(D)->setLocation(
      clang::SourceLocation::getFromPtrEncoding(L));
}

CXDeclContext clang_Decl_getNonTransparentDeclContext(CXDecl D) {
  return reinterpret_cast<CXDeclContext>(reinterpret_cast<clang::Decl *>(D)->getNonTransparentDeclContext());
}

bool clang_Decl_isFileContextDecl(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->isFileContextDecl();
}

CXAccessSpecifier clang_Decl_getAccess(CXDecl D) {
  return static_cast<CXAccessSpecifier>(reinterpret_cast<clang::Decl *>(D)->getAccess());
}

CXAccessSpecifier clang_Decl_getAccessUnsafe(CXDecl D) {
  return static_cast<CXAccessSpecifier>(reinterpret_cast<clang::Decl *>(D)->getAccessUnsafe());
}

void clang_Decl_setAccess(CXDecl D, CXAccessSpecifier AS) {
  reinterpret_cast<clang::Decl *>(D)->setAccess(static_cast<clang::AccessSpecifier>(AS));
}

void clang_Decl_addAttr(CXDecl D, CXAttr A) {
  reinterpret_cast<clang::Decl *>(D)->addAttr(reinterpret_cast<clang::Attr *>(A));
}

void clang_Decl_dropAttrs(CXDecl D) { reinterpret_cast<clang::Decl *>(D)->dropAttrs(); }

bool clang_Decl_hasAttrOfKind(CXDecl D, CXAttrKind K) {
  clang::Decl *DD = reinterpret_cast<clang::Decl *>(D);
  if (!DD->hasAttrs())
    return false;
  for (const clang::Attr *A : DD->getAttrs())
    if (static_cast<CXAttrKind>(A->getKind()) == K)
      return true;
  return false;
}

CXAttr clang_Decl_getAttrOfKind(CXDecl D, CXAttrKind K) {
  clang::Decl *DD = reinterpret_cast<clang::Decl *>(D);
  if (!DD->hasAttrs())
    return nullptr;
  for (clang::Attr *A : DD->getAttrs())
    if (static_cast<CXAttrKind>(A->getKind()) == K)
      return reinterpret_cast<CXAttr>(A);
  return nullptr;
}

unsigned clang_Decl_getMaxAlignment(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->getMaxAlignment();
}

bool clang_Decl_isInvalidDecl(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->isInvalidDecl();
}

void clang_Decl_setInvalidDecl(CXDecl D, bool Invalid) {
  reinterpret_cast<clang::Decl *>(D)->setInvalidDecl(Invalid);
}

bool clang_Decl_isImplicit(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->isImplicit();
}

void clang_Decl_setImplicit(CXDecl D, bool I) {
  reinterpret_cast<clang::Decl *>(D)->setImplicit(I);
}

bool clang_Decl_isUsed(CXDecl D, bool CheckUsedAttr) {
  return reinterpret_cast<clang::Decl *>(D)->isUsed(CheckUsedAttr);
}

void clang_Decl_setIsUsed(CXDecl D) { reinterpret_cast<clang::Decl *>(D)->setIsUsed(); }

void clang_Decl_markUsed(CXDecl D, CXASTContext C) {
  reinterpret_cast<clang::Decl *>(D)->markUsed(*reinterpret_cast<clang::ASTContext *>(C));
}

bool clang_Decl_isReferenced(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->isReferenced();
}

bool clang_Decl_isThisDeclarationReferenced(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->isThisDeclarationReferenced();
}

void clang_Decl_setReferenced(CXDecl D, bool R) {
  reinterpret_cast<clang::Decl *>(D)->setReferenced(R);
}

bool clang_Decl_isTopLevelDeclInObjCContainer(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->isTopLevelDeclInObjCContainer();
}

void clang_Decl_setTopLevelDeclInObjCContainer(CXDecl D, bool V) {
  reinterpret_cast<clang::Decl *>(D)->setTopLevelDeclInObjCContainer(V);
}

CXAttr clang_Decl_getExternalSourceSymbolAttr(CXDecl D) {
  return reinterpret_cast<CXAttr>(reinterpret_cast<clang::Decl *>(D)->getExternalSourceSymbolAttr());
}

bool clang_Decl_isModulePrivate(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->isModulePrivate();
}

bool clang_Decl_isInExportDeclContext(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->isInExportDeclContext();
}

bool clang_Decl_isInvisibleOutsideTheOwningModule(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->isInvisibleOutsideTheOwningModule();
}

bool clang_Decl_isInAnotherModuleUnit(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->isInAnotherModuleUnit();
}

bool clang_Decl_isDiscardedInGlobalModuleFragment(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->isDiscardedInGlobalModuleFragment();
}

bool clang_Decl_shouldSkipCheckingODR(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->shouldSkipCheckingODR();
}

bool clang_Decl_hasDefiningAttr(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->hasDefiningAttr();
}

CXAttr clang_Decl_getDefiningAttr(CXDecl D) {
  return reinterpret_cast<CXAttr>(const_cast<clang::Attr *>(reinterpret_cast<clang::Decl *>(D)->getDefiningAttr()));
}

CXAvailabilityResult clang_Decl_getAvailability(CXDecl D) {
  return static_cast<CXAvailabilityResult>(
      reinterpret_cast<clang::Decl *>(D)->getAvailability());
}

CXString clang_Decl_getAvailabilityMessage(CXDecl D) {
  std::string Message;
  reinterpret_cast<clang::Decl *>(D)->getAvailability(&Message);
  return extra::makeCXString(Message);
}

bool clang_Decl_getVersionIntroduced(CXDecl D, unsigned *Major, unsigned *Minor,
                                     unsigned *Subminor) {
  llvm::VersionTuple V = reinterpret_cast<clang::Decl *>(D)->getVersionIntroduced();
  if (V.empty())
    return false;
  *Major = V.getMajor();
  *Minor = V.getMinor().value_or(0);
  *Subminor = V.getSubminor().value_or(0);
  return true;
}

bool clang_Decl_isDeprecated(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->isDeprecated();
}

bool clang_Decl_isUnavailable(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->isUnavailable();
}

bool clang_Decl_isWeakImported(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->isWeakImported();
}

bool clang_Decl_canBeWeakImported(CXDecl D, bool *IsDefinition) {
  bool Def = false;
  bool R = reinterpret_cast<clang::Decl *>(D)->canBeWeakImported(Def);
  *IsDefinition = Def;
  return R;
}

bool clang_Decl_isFromASTFile(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->isFromASTFile();
}

unsigned clang_Decl_getGlobalID(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->getGlobalID();
}

unsigned clang_Decl_getOwningModuleID(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->getOwningModuleID();
}

CXModule_ clang_Decl_getImportedOwningModule(CXDecl D) {
  return reinterpret_cast<CXModule_>(reinterpret_cast<clang::Decl *>(D)->getImportedOwningModule());
}

CXModule_ clang_Decl_getLocalOwningModule(CXDecl D) {
  return reinterpret_cast<CXModule_>(reinterpret_cast<clang::Decl *>(D)->getLocalOwningModule());
}

bool clang_Decl_hasOwningModule(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->hasOwningModule();
}

CXModule_ clang_Decl_getOwningModule(CXDecl D) {
  return reinterpret_cast<CXModule_>(reinterpret_cast<clang::Decl *>(D)->getOwningModule());
}

CXModule_ clang_Decl_getOwningModuleForLinkage(CXDecl D, bool IgnoreLinkage) {
  return reinterpret_cast<CXModule_>(reinterpret_cast<clang::Decl *>(D)->getOwningModuleForLinkage(IgnoreLinkage));
}

bool clang_Decl_isUnconditionallyVisible(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->isUnconditionallyVisible();
}

bool clang_Decl_isReachable(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->isReachable();
}

void clang_Decl_setVisibleDespiteOwningModule(CXDecl D) {
  reinterpret_cast<clang::Decl *>(D)->setVisibleDespiteOwningModule();
}

CXDecl_ModuleOwnershipKind clang_Decl_getModuleOwnershipKind(CXDecl D) {
  return static_cast<CXDecl_ModuleOwnershipKind>(
      reinterpret_cast<clang::Decl *>(D)->getModuleOwnershipKind());
}

void clang_Decl_setModuleOwnershipKind(CXDecl D, CXDecl_ModuleOwnershipKind MOK) {
  reinterpret_cast<clang::Decl *>(D)->setModuleOwnershipKind(
      static_cast<clang::Decl::ModuleOwnershipKind>(MOK));
}

unsigned clang_Decl_getIdentifierNamespace(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->getIdentifierNamespace();
}

bool clang_Decl_isInIdentifierNamespace(CXDecl D, unsigned NS) {
  return reinterpret_cast<clang::Decl *>(D)->isInIdentifierNamespace(NS);
}

unsigned clang_Decl_getIdentifierNamespaceForKind(CXDeclKind DK) {
  return clang::Decl::getIdentifierNamespaceForKind(static_cast<clang::Decl::Kind>(DK));
}

bool clang_Decl_hasTagIdentifierNamespace(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->hasTagIdentifierNamespace();
}

bool clang_Decl_isTagIdentifierNamespace(unsigned NS) {
  return clang::Decl::isTagIdentifierNamespace(NS);
}

unsigned clang_Decl_getNumRedecls(CXDecl D) {
  unsigned N = 0;
  for (clang::Decl *R : reinterpret_cast<clang::Decl *>(D)->redecls()) {
    (void)R;
    ++N;
  }
  return N;
}

void clang_Decl_getRedecls(CXDecl D, CXDecl *Buf) {
  for (clang::Decl *R : reinterpret_cast<clang::Decl *>(D)->redecls())
    *Buf++ = reinterpret_cast<CXDecl>(R);
}

CXStmt clang_Decl_getBody(CXDecl D) { return reinterpret_cast<CXStmt>(reinterpret_cast<clang::Decl *>(D)->getBody()); }

bool clang_Decl_hasBody(CXDecl D) { return reinterpret_cast<clang::Decl *>(D)->hasBody(); }

CXSourceLocation_ clang_Decl_getBodyRBrace(CXDecl D) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Decl *>(D)->getBodyRBrace().getPtrEncoding());
}

bool clang_Decl_isLocalExternDecl(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->isLocalExternDecl();
}

CXDecl_FriendObjectKind clang_Decl_getFriendObjectKind(CXDecl D) {
  return static_cast<CXDecl_FriendObjectKind>(
      reinterpret_cast<clang::Decl *>(D)->getFriendObjectKind());
}

CXString clang_Decl_printToString(CXDecl D, unsigned Indentation,
                                  bool PrintInstantiation) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::Decl *>(D)->print(OS, Indentation, PrintInstantiation);
  return extra::makeCXString(OS.str());
}

bool clang_Decl_isFunctionPointerType(CXDecl D) {
  return reinterpret_cast<clang::Decl *>(D)->isFunctionPointerType();
}

bool clang_Decl_isFlexibleArrayMemberLike(CXASTContext Ctx, CXDecl D, CXQualType Ty,
                                          CXStrictFlexArraysLevelKind StrictFlexArraysLevel,
                                          bool IgnoreTemplateOrMacroSubstitution) {
  return clang::Decl::isFlexibleArrayMemberLike(
      *reinterpret_cast<clang::ASTContext *>(Ctx), reinterpret_cast<clang::Decl *>(D),
      clang::QualType::getFromOpaquePtr(Ty),
      static_cast<clang::LangOptions::StrictFlexArraysLevelKind>(StrictFlexArraysLevel),
      IgnoreTemplateOrMacroSubstitution);
}

void clang_Decl_setLocalExternDecl(CXDecl D) {
  reinterpret_cast<clang::Decl *>(D)->setLocalExternDecl();
}

void clang_Decl_clearIdentifierNamespace(CXDecl D) {
  reinterpret_cast<clang::Decl *>(D)->clearIdentifierNamespace();
}

void clang_Decl_setNonMemberOperator(CXDecl D) {
  reinterpret_cast<clang::Decl *>(D)->setNonMemberOperator();
}

CXString clang_Decl_printGroupToString(CXDecl *Decls, unsigned NumDecls,
                                       unsigned Indentation) {
  llvm::SmallVector<clang::Decl *, 8> Group;
  for (unsigned I = 0; I != NumDecls; ++I)
    Group.push_back(reinterpret_cast<clang::Decl *>(Decls[I]));
  std::string S;
  llvm::raw_string_ostream OS(S);
  clang::Decl::printGroup(Group.data(), NumDecls, OS,
                          Group.front()->getASTContext().getPrintingPolicy(), Indentation);
  return extra::makeCXString(OS.str());
}

CXDeclContext clang_Decl_castToDeclContext(CXDecl D) {
  return reinterpret_cast<CXDeclContext>(clang::Decl::castToDeclContext(reinterpret_cast<clang::Decl *>(D)));
}

CXDecl clang_Decl_castFromDeclContext(CXDeclContext DC) {
  return reinterpret_cast<CXDecl>(clang::Decl::castFromDeclContext(reinterpret_cast<clang::DeclContext *>(DC)));
}

// DeclContext
CXTagDecl clang_DeclContext_castToTagDecl(CXDeclContext DC) {
  return reinterpret_cast<CXTagDecl>(llvm::dyn_cast_or_null<clang::TagDecl>(reinterpret_cast<clang::DeclContext *>(DC)));
}

CXRecordDecl clang_DeclContext_castToRecordDecl(CXDeclContext DC) {
  return reinterpret_cast<CXRecordDecl>(llvm::dyn_cast_or_null<clang::RecordDecl>(reinterpret_cast<clang::DeclContext *>(DC)));
}

CXCXXRecordDecl clang_DeclContext_castToCXXRecordDecl(CXDeclContext DC) {
  return reinterpret_cast<CXCXXRecordDecl>(llvm::dyn_cast_or_null<clang::CXXRecordDecl>(
      reinterpret_cast<clang::DeclContext *>(DC)));
}

const char *clang_DeclContext_getDeclKindName(CXDeclContext DC) {
  return reinterpret_cast<clang::DeclContext *>(DC)->getDeclKindName();
}

CXDeclContext clang_DeclContext_getParent(CXDeclContext DC) {
  return reinterpret_cast<CXDeclContext>(reinterpret_cast<clang::DeclContext *>(DC)->getParent());
}

CXDeclContext clang_DeclContext_getLexicalParent(CXDeclContext DC) {
  return reinterpret_cast<CXDeclContext>(reinterpret_cast<clang::DeclContext *>(DC)->getLexicalParent());
}

CXDeclContext clang_DeclContext_getLookupParent(CXDeclContext DC) {
  return reinterpret_cast<CXDeclContext>(reinterpret_cast<clang::DeclContext *>(DC)->getLookupParent());
}

CXASTContext clang_DeclContext_getParentASTContext(CXDeclContext DC) {
  return reinterpret_cast<CXASTContext>(&reinterpret_cast<clang::DeclContext *>(DC)->getParentASTContext());
}

bool clang_DeclContext_isClosure(CXDeclContext DC) {
  return reinterpret_cast<clang::DeclContext *>(DC)->isClosure();
}

bool clang_DeclContext_isFunctionOrMethod(CXDeclContext DC) {
  return reinterpret_cast<clang::DeclContext *>(DC)->isFunctionOrMethod();
}

bool clang_DeclContext_isLookupContext(CXDeclContext DC) {
  return reinterpret_cast<clang::DeclContext *>(DC)->isLookupContext();
}

bool clang_DeclContext_isFileContext(CXDeclContext DC) {
  return reinterpret_cast<clang::DeclContext *>(DC)->isFileContext();
}

bool clang_DeclContext_isTranslationUnit(CXDeclContext DC) {
  return reinterpret_cast<clang::DeclContext *>(DC)->isTranslationUnit();
}

bool clang_DeclContext_isRecord(CXDeclContext DC) {
  return reinterpret_cast<clang::DeclContext *>(DC)->isRecord();
}

bool clang_DeclContext_isNamespace(CXDeclContext DC) {
  return reinterpret_cast<clang::DeclContext *>(DC)->isNamespace();
}

bool clang_DeclContext_isStdNamespace(CXDeclContext DC) {
  return reinterpret_cast<clang::DeclContext *>(DC)->isStdNamespace();
}

bool clang_DeclContext_isInlineNamespace(CXDeclContext DC) {
  return reinterpret_cast<clang::DeclContext *>(DC)->isInlineNamespace();
}

bool clang_DeclContext_isDependentContext(CXDeclContext DC) {
  return reinterpret_cast<clang::DeclContext *>(DC)->isDependentContext();
}

bool clang_DeclContext_isTransparentContext(CXDeclContext DC) {
  return reinterpret_cast<clang::DeclContext *>(DC)->isTransparentContext();
}

bool clang_DeclContext_isExternCContext(CXDeclContext DC) {
  return reinterpret_cast<clang::DeclContext *>(DC)->isExternCContext();
}

bool clang_DeclContext_isExternCXXContext(CXDeclContext DC) {
  return reinterpret_cast<clang::DeclContext *>(DC)->isExternCXXContext();
}

bool clang_DeclContext_Equals(CXDeclContext DC, CXDeclContext DC2) {
  return reinterpret_cast<clang::DeclContext *>(DC)->Equals(
      reinterpret_cast<clang::DeclContext *>(DC2));
}

CXDeclContext clang_DeclContext_getPrimaryContext(CXDeclContext DC) {
  return reinterpret_cast<CXDeclContext>(reinterpret_cast<clang::DeclContext *>(DC)->getPrimaryContext());
}

CXDecl clang_DeclContext_decl_iterator_begin(CXDeclContext DC) {
  return reinterpret_cast<CXDecl>(*reinterpret_cast<clang::DeclContext *>(DC)->decls_begin());
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
    *Nodes++ = reinterpret_cast<CXDecl>(D);
    *Kinds++ = static_cast<CXDeclKind>(D->getKind());
    if (auto *Inner = llvm::dyn_cast<clang::DeclContext>(D))
      collectRecursiveDecls(Inner, Nodes, Kinds);
  }
}
} // namespace

CXDeclKind clang_DeclContext_getDeclKind(CXDeclContext DC) {
  return static_cast<CXDeclKind>(reinterpret_cast<clang::DeclContext *>(DC)->getDeclKind());
}

bool clang_DeclContext_hasValidDeclKind(CXDeclContext DC) {
  return reinterpret_cast<clang::DeclContext *>(DC)->hasValidDeclKind();
}

CXBlockDecl clang_DeclContext_getInnermostBlockDecl(CXDeclContext DC) {
  return reinterpret_cast<CXBlockDecl>(const_cast<clang::BlockDecl *>(
      reinterpret_cast<clang::DeclContext *>(DC)->getInnermostBlockDecl()));
}

bool clang_DeclContext_isObjCContainer(CXDeclContext DC) {
  return reinterpret_cast<clang::DeclContext *>(DC)->isObjCContainer();
}

CXLinkageSpecDecl clang_DeclContext_getExternCContext(CXDeclContext DC) {
  return reinterpret_cast<CXLinkageSpecDecl>(const_cast<clang::LinkageSpecDecl *>(
      reinterpret_cast<clang::DeclContext *>(DC)->getExternCContext()));
}

bool clang_DeclContext_Encloses(CXDeclContext DC, CXDeclContext DC2) {
  return reinterpret_cast<clang::DeclContext *>(DC)->Encloses(
      reinterpret_cast<clang::DeclContext *>(DC2));
}

CXDecl clang_DeclContext_getNonClosureAncestor(CXDeclContext DC) {
  return reinterpret_cast<CXDecl>(reinterpret_cast<clang::DeclContext *>(DC)->getNonClosureAncestor());
}

CXDeclContext clang_DeclContext_getNonTransparentContext(CXDeclContext DC) {
  return reinterpret_cast<CXDeclContext>(reinterpret_cast<clang::DeclContext *>(DC)->getNonTransparentContext());
}

CXDeclContext clang_DeclContext_getRedeclContext(CXDeclContext DC) {
  return reinterpret_cast<CXDeclContext>(reinterpret_cast<clang::DeclContext *>(DC)->getRedeclContext());
}

CXDeclContext clang_DeclContext_getEnclosingNamespaceContext(CXDeclContext DC) {
  return reinterpret_cast<CXDeclContext>(reinterpret_cast<clang::DeclContext *>(DC)->getEnclosingNamespaceContext());
}

CXRecordDecl clang_DeclContext_getOuterLexicalRecordContext(CXDeclContext DC) {
  return reinterpret_cast<CXRecordDecl>(reinterpret_cast<clang::DeclContext *>(DC)->getOuterLexicalRecordContext());
}

bool clang_DeclContext_InEnclosingNamespaceSetOf(CXDeclContext DC, CXDeclContext NS) {
  return reinterpret_cast<clang::DeclContext *>(DC)->InEnclosingNamespaceSetOf(
      reinterpret_cast<clang::DeclContext *>(NS));
}

unsigned clang_DeclContext_getNumAllContexts(CXDeclContext DC) {
  llvm::SmallVector<clang::DeclContext *, 2> Contexts;
  reinterpret_cast<clang::DeclContext *>(DC)->collectAllContexts(Contexts);
  return Contexts.size();
}

void clang_DeclContext_collectAllContexts(CXDeclContext DC, CXDeclContext *Buf) {
  llvm::SmallVector<clang::DeclContext *, 2> Contexts;
  reinterpret_cast<clang::DeclContext *>(DC)->collectAllContexts(Contexts);
  for (clang::DeclContext *C : Contexts)
    *Buf++ = reinterpret_cast<CXDeclContext>(C);
}

bool clang_DeclContext_decls_empty(CXDeclContext DC) {
  return reinterpret_cast<clang::DeclContext *>(DC)->decls_empty();
}

bool clang_DeclContext_containsDeclAndLoad(CXDeclContext DC, CXDecl D) {
  return reinterpret_cast<clang::DeclContext *>(DC)->containsDeclAndLoad(
      reinterpret_cast<clang::Decl *>(D));
}

CXDecl clang_DeclContext_noload_decls_begin(CXDeclContext DC) {
  return reinterpret_cast<CXDecl>(*reinterpret_cast<clang::DeclContext *>(DC)->noload_decls_begin());
}

unsigned clang_DeclContext_getNumLocalUncachedLookupResults(CXDeclContext DC,
                                                            CXDeclarationName Name) {
  llvm::SmallVector<clang::NamedDecl *, 8> Results;
  reinterpret_cast<clang::DeclContext *>(DC)->localUncachedLookup(
      clang::DeclarationName::getFromOpaquePtr(Name), Results);
  return static_cast<unsigned>(Results.size());
}

void clang_DeclContext_localUncachedLookup(CXDeclContext DC, CXDeclarationName Name,
                                           CXNamedDecl *Results) {
  llvm::SmallVector<clang::NamedDecl *, 8> Found;
  reinterpret_cast<clang::DeclContext *>(DC)->localUncachedLookup(
      clang::DeclarationName::getFromOpaquePtr(Name), Found);
  for (clang::NamedDecl *ND : Found)
    *Results++ = reinterpret_cast<CXNamedDecl>(ND);
}

void clang_DeclContext_setMustBuildLookupTable(CXDeclContext DC) {
  reinterpret_cast<clang::DeclContext *>(DC)->setMustBuildLookupTable();
}

unsigned clang_DeclContext_getNumLookupResults(CXDeclContext DC,
                                               CXDeclarationName Name) {
  unsigned N = 0;
  for (clang::NamedDecl *ND : reinterpret_cast<clang::DeclContext *>(DC)->lookup(
           clang::DeclarationName::getFromOpaquePtr(Name))) {
    (void)ND;
    ++N;
  }
  return N;
}

void clang_DeclContext_lookup(CXDeclContext DC, CXDeclarationName Name,
                              CXNamedDecl *Results) {
  for (clang::NamedDecl *ND : reinterpret_cast<clang::DeclContext *>(DC)->lookup(
           clang::DeclarationName::getFromOpaquePtr(Name)))
    *Results++ = reinterpret_cast<CXNamedDecl>(ND);
}

unsigned clang_DeclContext_getNumNoloadLookupResults(CXDeclContext DC,
                                                     CXDeclarationName Name) {
  unsigned N = 0;
  for (clang::NamedDecl *ND : reinterpret_cast<clang::DeclContext *>(DC)->noload_lookup(
           clang::DeclarationName::getFromOpaquePtr(Name))) {
    (void)ND;
    ++N;
  }
  return N;
}

void clang_DeclContext_noload_lookup(CXDeclContext DC, CXDeclarationName Name,
                                     CXNamedDecl *Results) {
  for (clang::NamedDecl *ND : reinterpret_cast<clang::DeclContext *>(DC)->noload_lookup(
           clang::DeclarationName::getFromOpaquePtr(Name)))
    *Results++ = reinterpret_cast<CXNamedDecl>(ND);
}

void clang_DeclContext_makeDeclVisibleInContext(CXDeclContext DC, CXNamedDecl D) {
  reinterpret_cast<clang::DeclContext *>(DC)->makeDeclVisibleInContext(
      reinterpret_cast<clang::NamedDecl *>(D));
}

unsigned clang_DeclContext_getNumLookupNames(CXDeclContext DC) {
  unsigned N = 0;
  auto R = reinterpret_cast<clang::DeclContext *>(DC)->lookups();
  for (auto I = R.begin(), E = R.end(); I != E; ++I)
    ++N;
  return N;
}

void clang_DeclContext_getLookupNames(CXDeclContext DC, CXDeclarationName *Buf) {
  auto R = reinterpret_cast<clang::DeclContext *>(DC)->lookups();
  for (auto I = R.begin(), E = R.end(); I != E; ++I)
    *Buf++ = reinterpret_cast<CXDeclarationName>(I.getLookupName().getAsOpaquePtr());
}

unsigned clang_DeclContext_getNumNoloadLookupNames(CXDeclContext DC,
                                                   bool PreserveInternalState) {
  unsigned N = 0;
  auto R = reinterpret_cast<clang::DeclContext *>(DC)->noload_lookups(PreserveInternalState);
  for (auto I = R.begin(), E = R.end(); I != E; ++I)
    ++N;
  return N;
}

void clang_DeclContext_getNoloadLookupNames(CXDeclContext DC, bool PreserveInternalState,
                                            CXDeclarationName *Buf) {
  auto R = reinterpret_cast<clang::DeclContext *>(DC)->noload_lookups(PreserveInternalState);
  for (auto I = R.begin(), E = R.end(); I != E; ++I)
    *Buf++ = reinterpret_cast<CXDeclarationName>(I.getLookupName().getAsOpaquePtr());
}

CXNamedDecl clang_DeclContext_lookupSingleResult(CXDeclContext DC, CXDeclarationName Name) {
  clang::DeclContext::lookup_result R = reinterpret_cast<clang::DeclContext *>(DC)->lookup(
      clang::DeclarationName::getFromOpaquePtr(Name));
  if (!R.isSingleResult())
    return nullptr;
  return reinterpret_cast<CXNamedDecl>(R.front());
}

unsigned clang_DeclContext_getNumUsingDirectives(CXDeclContext DC) {
  unsigned N = 0;
  for (clang::UsingDirectiveDecl *UD :
       reinterpret_cast<clang::DeclContext *>(DC)->using_directives()) {
    (void)UD;
    ++N;
  }
  return N;
}

void clang_DeclContext_getUsingDirectives(CXDeclContext DC, CXUsingDirectiveDecl *Buf) {
  for (clang::UsingDirectiveDecl *UD :
       reinterpret_cast<clang::DeclContext *>(DC)->using_directives())
    *Buf++ = reinterpret_cast<CXUsingDirectiveDecl>(UD);
}

bool clang_DeclContext_hasLookupTable(CXDeclContext DC) {
  return reinterpret_cast<clang::DeclContext *>(DC)->getLookupPtr() != nullptr;
}

bool clang_DeclContext_buildLookup(CXDeclContext DC) {
  return reinterpret_cast<clang::DeclContext *>(DC)->buildLookup() != nullptr;
}

bool clang_DeclContext_hasExternalLexicalStorage(CXDeclContext DC) {
  return reinterpret_cast<clang::DeclContext *>(DC)->hasExternalLexicalStorage();
}

void clang_DeclContext_setHasExternalLexicalStorage(CXDeclContext DC, bool ES) {
  reinterpret_cast<clang::DeclContext *>(DC)->setHasExternalLexicalStorage(ES);
}

bool clang_DeclContext_hasExternalVisibleStorage(CXDeclContext DC) {
  return reinterpret_cast<clang::DeclContext *>(DC)->hasExternalVisibleStorage();
}

void clang_DeclContext_setHasExternalVisibleStorage(CXDeclContext DC, bool ES) {
  reinterpret_cast<clang::DeclContext *>(DC)->setHasExternalVisibleStorage(ES);
}

bool clang_DeclContext_isDeclInLexicalTraversal(CXDeclContext DC, CXDecl D) {
  return reinterpret_cast<clang::DeclContext *>(DC)->isDeclInLexicalTraversal(
      reinterpret_cast<clang::Decl *>(D));
}

void clang_DeclContext_setUseQualifiedLookup(CXDeclContext DC, bool Use) {
  reinterpret_cast<clang::DeclContext *>(DC)->setUseQualifiedLookup(Use);
}

bool clang_DeclContext_shouldUseQualifiedLookup(CXDeclContext DC) {
  return reinterpret_cast<clang::DeclContext *>(DC)->shouldUseQualifiedLookup();
}

bool clang_DeclContext_classof(CXDecl D) {
  return clang::DeclContext::classof(reinterpret_cast<clang::Decl *>(D));
}

size_t clang_DeclContext_getRecursiveDeclCount(CXDeclContext DC) {
  return recursiveDeclCount(reinterpret_cast<clang::DeclContext *>(DC));
}

void clang_DeclContext_collectRecursiveDecls(CXDeclContext DC, CXDecl *Nodes,
                                             CXDeclKind *Kinds) {
  collectRecursiveDecls(reinterpret_cast<clang::DeclContext *>(DC), Nodes, Kinds);
}

void clang_DeclContext_addDecl(CXDeclContext DC, CXDecl D) {
  reinterpret_cast<clang::DeclContext *>(DC)->addDecl(reinterpret_cast<clang::Decl *>(D));
}

void clang_DeclContext_addDeclInternal(CXDeclContext DC, CXDecl D) {
  reinterpret_cast<clang::DeclContext *>(DC)->addDeclInternal(reinterpret_cast<clang::Decl *>(D));
}

void clang_DeclContext_addHiddenDecl(CXDeclContext DC, CXDecl D) {
  reinterpret_cast<clang::DeclContext *>(DC)->addHiddenDecl(reinterpret_cast<clang::Decl *>(D));
}

void clang_DeclContext_removeDecl(CXDeclContext DC, CXDecl D) {
  reinterpret_cast<clang::DeclContext *>(DC)->removeDecl(reinterpret_cast<clang::Decl *>(D));
}

bool clang_DeclContext_containsDecl(CXDeclContext DC, CXDecl D) {
  return reinterpret_cast<clang::DeclContext *>(DC)->containsDecl(
      reinterpret_cast<clang::Decl *>(D));
}

void clang_DeclContext_dumpAsDecl(CXDeclContext DC) {
  reinterpret_cast<clang::DeclContext *>(DC)->dumpAsDecl();
}

void clang_DeclContext_dumpDeclContext(CXDeclContext DC) {
  reinterpret_cast<clang::DeclContext *>(DC)->dumpDeclContext();
}

void clang_DeclContext_dumpLookups(CXDeclContext DC) {
  reinterpret_cast<clang::DeclContext *>(DC)->dumpLookups();
}

void clang_Decl_setObjectOfFriendDecl(CXDecl D, bool PerformFriendInjection) {
  reinterpret_cast<clang::Decl *>(D)->setObjectOfFriendDecl(PerformFriendInjection);
}
