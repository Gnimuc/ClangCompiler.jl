#ifndef LLVM_CLANG_C_EXTRA_CXDECLBASE_H
#define LLVM_CLANG_C_EXTRA_CXDECLBASE_H

#include "clang-ex/AST/CXAttr.h"
#include "clang-ex/Basic/CXSpecifiers.h"

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-ex/Basic/CXLangOptions.h"

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

// Mirrors clang::AvailabilityResult (clang/AST/DeclBase.h; synced in
// lib/Basic/CXEnumSync.cpp).
typedef enum CXAvailabilityResult {
  CXAvailabilityResult_AR_Available = 0,
  CXAvailabilityResult_AR_NotYetIntroduced,
  CXAvailabilityResult_AR_Deprecated,
  CXAvailabilityResult_AR_Unavailable
} CXAvailabilityResult;

// Mirrors clang::Decl::IdentifierNamespace, the set of lookup namespaces a decl
// lives in (class-local enum; synced in lib/Basic/CXEnumSync.cpp). These are
// bitmask values: clang_Decl_getIdentifierNamespace returns an OR of them, not
// a single enumerator.
typedef enum CXDecl_IdentifierNamespace {
  CXDecl_IDNS_Label = 0x0001,
  CXDecl_IDNS_Tag = 0x0002,
  CXDecl_IDNS_Type = 0x0004,
  CXDecl_IDNS_Member = 0x0008,
  CXDecl_IDNS_Namespace = 0x0010,
  CXDecl_IDNS_Ordinary = 0x0020,
  CXDecl_IDNS_ObjCProtocol = 0x0040,
  CXDecl_IDNS_OrdinaryFriend = 0x0080,
  CXDecl_IDNS_TagFriend = 0x0100,
  CXDecl_IDNS_Using = 0x0200,
  CXDecl_IDNS_NonMemberOperator = 0x0400,
  CXDecl_IDNS_LocalExtern = 0x0800,
  CXDecl_IDNS_OMPReduction = 0x1000,
  CXDecl_IDNS_OMPMapper = 0x2000
} CXDecl_IdentifierNamespace;

// Mirrors clang::Decl::ModuleOwnershipKind (class-local enum; synced in
// lib/Basic/CXEnumSync.cpp). Higher values mean more name hiding.
typedef enum CXDecl_ModuleOwnershipKind : unsigned char {
  CXDecl_Unowned,
  CXDecl_Visible,
  CXDecl_VisibleWhenImported,
  CXDecl_ReachableWhenImported,
  CXDecl_ModulePrivate
} CXDecl_ModuleOwnershipKind;

// Mirrors clang::Decl::FriendObjectKind (class-local enum; synced in
// lib/Basic/CXEnumSync.cpp).
typedef enum CXDecl_FriendObjectKind {
  CXDecl_FOK_None,
  CXDecl_FOK_Declared,
  CXDecl_FOK_Undeclared
} CXDecl_FriendObjectKind;

// Null-safe downcast (dyn_cast_or_null) and kind predicate for every class in
// the hierarchy, ABSTRACT bases included. The wrapper name carries the full
// class spelling (DeclNodes name + "Decl"). Each cast returns that class's own
// handle, so narrowing is checked by the compiler rather than asserted.
#define DECL(DERIVED, BASE)                                                                \
  CX##DERIVED##Decl clang_Decl_castTo##DERIVED##Decl(CXDecl D);                             \
  bool clang_Decl_is##DERIVED##Decl(CXDecl D);
#define ABSTRACT_DECL(DECL) DECL
#include "clang-ex/AST/DeclNodes.inc"

CXDeclKind clang_Decl_getKind(CXDecl D);

// attrs: Decl::attrs() as a count+index pair. getAttr returns the borrowed Attr*
// at position I (< getNumAttrs); classify it with clang_Attr_getKind.
bool clang_Decl_hasAttrs(CXDecl D);

unsigned clang_Decl_getNumAttrs(CXDecl D);

CXAttr clang_Decl_getAttr(CXDecl D, unsigned I);

// setAttrs: Decl::setAttrs(const AttrVec &), with the vector rebuilt inside the
// shim from a caller array of NumAttrs borrowed CXAttr handles (MARSHALLING.md
// section 11). The Attr objects are not copied — they stay owned by whatever AST
// allocated them, so one attribute can end up on two declarations.
// PRECONDITION: D must carry no attributes yet (clang_Decl_hasAttrs is false);
// clang asserts on a declaration whose attribute list is already populated.
void clang_Decl_setAttrs(CXDecl D, CXAttr *Attrs, unsigned NumAttrs);

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

// The argument-taking / value-returning tail of clang::Decl, in the order the
// methods are declared in clang/AST/DeclBase.h.
CXSourceRange_ clang_Decl_getSourceRange(CXDecl D);

void clang_Decl_setLocation(CXDecl D, CXSourceLocation_ L);

CXDeclContext clang_Decl_getNonTransparentDeclContext(CXDecl D);

bool clang_Decl_isFileContextDecl(CXDecl D);

// getAccess asserts the access specifier has been set for a class member;
// getAccessUnsafe reads it unconditionally.
CXAccessSpecifier clang_Decl_getAccess(CXDecl D);

CXAccessSpecifier clang_Decl_getAccessUnsafe(CXDecl D);

void clang_Decl_setAccess(CXDecl D, CXAccessSpecifier AS);

// attrs, continued: addAttr appends to the ASTContext-allocated attribute
// vector and dropAttrs clears it. hasAttrOfKind / getAttrOfKind are the
// kind-indexed form of clang's hasAttr<T>() / getAttr<T>() templates, which
// cannot cross a C boundary; getAttrOfKind returns the first attribute of that
// kind, or NULL when there is none.
void clang_Decl_addAttr(CXDecl D, CXAttr A);

void clang_Decl_dropAttrs(CXDecl D);

bool clang_Decl_hasAttrOfKind(CXDecl D, CXAttrKind K); // helper

CXAttr clang_Decl_getAttrOfKind(CXDecl D, CXAttrKind K); // helper

unsigned clang_Decl_getMaxAlignment(CXDecl D);

bool clang_Decl_isInvalidDecl(CXDecl D);

void clang_Decl_setInvalidDecl(CXDecl D, bool Invalid);

bool clang_Decl_isImplicit(CXDecl D);

void clang_Decl_setImplicit(CXDecl D, bool I);

bool clang_Decl_isUsed(CXDecl D, bool CheckUsedAttr);

void clang_Decl_setIsUsed(CXDecl D);

void clang_Decl_markUsed(CXDecl D, CXASTContext C);

bool clang_Decl_isReferenced(CXDecl D);

bool clang_Decl_isThisDeclarationReferenced(CXDecl D);

void clang_Decl_setReferenced(CXDecl D, bool R);

bool clang_Decl_isTopLevelDeclInObjCContainer(CXDecl D);

void clang_Decl_setTopLevelDeclInObjCContainer(CXDecl D, bool V);

CXAttr clang_Decl_getExternalSourceSymbolAttr(CXDecl D);

bool clang_Decl_isModulePrivate(CXDecl D);

bool clang_Decl_isInExportDeclContext(CXDecl D);

bool clang_Decl_isInvisibleOutsideTheOwningModule(CXDecl D);

bool clang_Decl_isInAnotherModuleUnit(CXDecl D);

// Always false in the pinned LLVM: clang does not implement discarding
// declarations in the global module fragment ([module.global.frag]p3,4).
bool clang_Decl_isDiscardedInGlobalModuleFragment(CXDecl D);

bool clang_Decl_shouldSkipCheckingODR(CXDecl D);

bool clang_Decl_hasDefiningAttr(CXDecl D);

CXAttr clang_Decl_getDefiningAttr(CXDecl D);

// availability: clang fills an optional std::string alongside the result, so the
// query is split in two — getAvailability answers it, getAvailabilityMessage
// re-runs it and returns the explanatory message (empty when the decl is
// available or carries no message).
CXAvailabilityResult clang_Decl_getAvailability(CXDecl D);

CXString clang_Decl_getAvailabilityMessage(CXDecl D);

// True (and fills *Major/*Minor/*Subminor) when this decl carries an
// 'introduced' availability version; false leaves the out-params untouched.
// Absent minor/subminor components come back as 0.
bool clang_Decl_getVersionIntroduced(CXDecl D, unsigned *Major, unsigned *Minor,
                                     unsigned *Subminor);

bool clang_Decl_isDeprecated(CXDecl D);

bool clang_Decl_isUnavailable(CXDecl D);

bool clang_Decl_isWeakImported(CXDecl D);

// True when the decl could be weak-imported; *IsDefinition is set when it cannot
// be because the decl has a definition.
bool clang_Decl_canBeWeakImported(CXDecl D, bool *IsDefinition);

bool clang_Decl_isFromASTFile(CXDecl D);

// Both IDs live in the words the AST reader writes in front of a deserialized
// Decl; clang returns 0 for a decl that was parsed instead of deserialized.
unsigned clang_Decl_getGlobalID(CXDecl D);

unsigned clang_Decl_getOwningModuleID(CXDecl D);

CXModule_ clang_Decl_getImportedOwningModule(CXDecl D);

CXModule_ clang_Decl_getLocalOwningModule(CXDecl D);

bool clang_Decl_hasOwningModule(CXDecl D);

CXModule_ clang_Decl_getOwningModule(CXDecl D);

CXModule_ clang_Decl_getOwningModuleForLinkage(CXDecl D, bool IgnoreLinkage);

bool clang_Decl_isUnconditionallyVisible(CXDecl D);

bool clang_Decl_isReachable(CXDecl D);

void clang_Decl_setVisibleDespiteOwningModule(CXDecl D);

CXDecl_ModuleOwnershipKind clang_Decl_getModuleOwnershipKind(CXDecl D);

// PRECONDITION: a decl whose current kind is Unowned accepts a non-Unowned MOK
// only when it was deserialized or was allocated with local owning-module
// storage; clang asserts on the rest.
void clang_Decl_setModuleOwnershipKind(CXDecl D, CXDecl_ModuleOwnershipKind MOK);

// An OR of CXDecl_IdentifierNamespace bits, not a single enumerator.
unsigned clang_Decl_getIdentifierNamespace(CXDecl D);

bool clang_Decl_isInIdentifierNamespace(CXDecl D, unsigned NS);

// Static: the identifier-namespace bitmask every decl of kind DK starts out in.
unsigned clang_Decl_getIdentifierNamespaceForKind(CXDeclKind DK);

bool clang_Decl_hasTagIdentifierNamespace(CXDecl D);

// Static: whether an identifier-namespace bitmask is the one a tag decl carries.
bool clang_Decl_isTagIdentifierNamespace(unsigned NS);

// redecls: Decl::redecls() as a two-call count + fill (the redeclaration chain
// is forward-only). getNumRedecls walks the chain to count it — always at least
// one, the decl itself — and getRedecls fills exactly that many slots in clang's
// iteration order. No slot is null.
unsigned clang_Decl_getNumRedecls(CXDecl D);

void clang_Decl_getRedecls(CXDecl D, CXDecl *Buf);

CXStmt clang_Decl_getBody(CXDecl D);

bool clang_Decl_hasBody(CXDecl D);

CXSourceLocation_ clang_Decl_getBodyRBrace(CXDecl D);

bool clang_Decl_isLocalExternDecl(CXDecl D);

CXDecl_FriendObjectKind clang_Decl_getFriendObjectKind(CXDecl D);

// Decl::print() rendered into a string (clang writes it to a raw_ostream).
CXString clang_Decl_printToString(CXDecl D, unsigned Indentation,
                                  bool PrintInstantiation); // helper

bool clang_Decl_isFunctionPointerType(CXDecl D);

// The static entry points and the identifier-namespace mutators of clang::Decl,
// in the order the methods are declared in clang/AST/DeclBase.h.
//
// Static and total in D: D may be NULL, which restricts the answer to the checks
// that depend only on Ty and StrictFlexArraysLevel. StrictFlexArraysLevel selects
// the -fstrict-flex-arrays rule to apply instead of being read out of Ctx, so the
// answer does not depend on how the translation unit was configured.
bool clang_Decl_isFlexibleArrayMemberLike(CXASTContext Ctx, CXDecl D, CXQualType Ty,
                                          CXStrictFlexArraysLevelKind StrictFlexArraysLevel,
                                          bool IgnoreTemplateOrMacroSubstitution);

// PRECONDITION: clang clears IDNS_Ordinary and then asserts that nothing but
// IDNS_OrdinaryFriend and IDNS_Tag is left, so D's identifier namespace must hold
// no bit outside IDNS_Ordinary | IDNS_OrdinaryFriend | IDNS_Tag.
void clang_Decl_setLocalExternDecl(CXDecl D);

// Empties D's identifier namespace, hiding it from every ordinary name lookup
// while leaving it findable for redeclaration lookup.
void clang_Decl_clearIdentifierNamespace(CXDecl D);

// PRECONDITION: D's kind must be Function or FunctionTemplate and its identifier
// namespace must already contain IDNS_Ordinary; clang asserts both.
void clang_Decl_setNonMemberOperator(CXDecl D);

// Decl::printGroup() rendered into a string (clang writes it to a raw_ostream).
// NumDecls must be at least 1 and no slot may be null: the printing policy is
// taken from the ASTContext of Decls[0].
CXString clang_Decl_printGroupToString(CXDecl *Decls, unsigned NumDecls,
                                       unsigned Indentation); // helper

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

// recursive decls: bulk pre-order extraction of every decl in DC and all nested
// decl-contexts (namespaces, records, functions, …) in a single walk, so a
// whole-translation-unit sweep costs O(1) FFI round-trips instead of one per
// decl. getRecursiveDeclCount counts the decls; collectRecursiveDecls fills two
// caller-allocated buffers of exactly that many slots — the decl pointers and
// their CXDeclKind values in lockstep — letting the caller build resolved
// carriers without a per-decl getKind call.
size_t clang_DeclContext_getRecursiveDeclCount(CXDeclContext DC);

void clang_DeclContext_collectRecursiveDecls(CXDeclContext DC, CXDecl *Nodes,
                                             CXDeclKind *Kinds);

void clang_DeclContext_addDecl(CXDeclContext DC, CXDecl D);

void clang_DeclContext_addDeclInternal(CXDeclContext DC, CXDecl D);

void clang_DeclContext_addHiddenDecl(CXDeclContext DC, CXDecl D);

void clang_DeclContext_removeDecl(CXDeclContext DC, CXDecl D);

bool clang_DeclContext_containsDecl(CXDeclContext DC, CXDecl D);

// Dumps the Decl owning this context to llvm::errs(); prints an invalidity note
// instead when the context's decl kind is not valid.
void clang_DeclContext_dumpAsDecl(CXDeclContext DC);

void clang_DeclContext_dumpDeclContext(CXDeclContext DC);

void clang_DeclContext_dumpLookups(CXDeclContext DC);

// The argument-taking / value-returning tail of clang::DeclContext, in the order
// the methods are declared in clang/AST/DeclBase.h.
CXDeclKind clang_DeclContext_getDeclKind(CXDeclContext DC);

// For use when debugging: true for a correctly constructed DeclContext within
// its lifetime.
bool clang_DeclContext_hasValidDeclKind(CXDeclContext DC);

CXBlockDecl clang_DeclContext_getInnermostBlockDecl(CXDeclContext DC);

bool clang_DeclContext_isObjCContainer(CXDeclContext DC);

CXLinkageSpecDecl clang_DeclContext_getExternCContext(CXDeclContext DC);

bool clang_DeclContext_Encloses(CXDeclContext DC, CXDeclContext DC2);

CXDecl clang_DeclContext_getNonClosureAncestor(CXDeclContext DC);

CXDeclContext clang_DeclContext_getNonTransparentContext(CXDeclContext DC);

CXDeclContext clang_DeclContext_getRedeclContext(CXDeclContext DC);

CXDeclContext clang_DeclContext_getEnclosingNamespaceContext(CXDeclContext DC);

CXRecordDecl clang_DeclContext_getOuterLexicalRecordContext(CXDeclContext DC);

bool clang_DeclContext_InEnclosingNamespaceSetOf(CXDeclContext DC, CXDeclContext NS);

// all contexts: DeclContext::collectAllContexts() as a two-call count + fill —
// every semantic context connected to this one (the reopenings of a namespace,
// or just this context for a non-namespace). getNumAllContexts runs the
// collection to size it and collectAllContexts fills exactly that many slots.
unsigned clang_DeclContext_getNumAllContexts(CXDeclContext DC);

void clang_DeclContext_collectAllContexts(CXDeclContext DC, CXDeclContext *Buf);

bool clang_DeclContext_decls_empty(CXDeclContext DC);

bool clang_DeclContext_containsDeclAndLoad(CXDeclContext DC, CXDecl D);

// lookup: DeclContext::lookup(DeclarationName) as a two-call count + fill (the
// result list is forward-only). getNumLookupResults runs the lookup to size it —
// clang caches the lookup table, so the fill call is cheap — and lookup writes
// exactly that many CXNamedDecl slots, none null. Only this context is searched.
unsigned clang_DeclContext_getNumLookupResults(CXDeclContext DC, CXDeclarationName Name);

void clang_DeclContext_lookup(CXDeclContext DC, CXDeclarationName Name,
                              CXNamedDecl *Results);

// noload lookup: DeclContext::noload_lookup(DeclarationName) as the same
// two-call count + fill as lookup above, except that no external AST source is
// consulted — only names already present in this context's lookup table are
// found, and the count is 0 when the table has not been built yet.
// PRECONDITION: DC must not be a transparent context (a LinkageSpec or an
// Export); clang asserts on those.
unsigned clang_DeclContext_getNumNoloadLookupResults(CXDeclContext DC,
                                                     CXDeclarationName Name);

void clang_DeclContext_noload_lookup(CXDeclContext DC, CXDeclarationName Name,
                                     CXNamedDecl *Results);

void clang_DeclContext_makeDeclVisibleInContext(CXDeclContext DC, CXNamedDecl D);

// lookup names: DeclContext::lookups() as a two-call count + fill over the
// *names* the context can look up — clang's all_lookups_iterator visits one
// entry per DeclarationName, and the declarations behind a name come from
// clang_DeclContext_lookup. Both calls run on DC's primary context and build its
// lookup table, so the count is stable across the pair; getLookupNames writes
// exactly getNumLookupNames CXDeclarationName encodings, none null. Note clang
// filters its internal using-directive name only while advancing the iterator,
// so that name can still show up as the first entry.
unsigned clang_DeclContext_getNumLookupNames(CXDeclContext DC);

void clang_DeclContext_getLookupNames(CXDeclContext DC, CXDeclarationName *Buf);

// The same pair over DeclContext::noload_lookups(): no external AST source is
// consulted, so only names already in the built table are visited (0 when it has
// not been built yet). PreserveInternalState additionally suppresses loading
// lazily-stored lexical lookups, leaving the context untouched — pass the same
// value to both calls or the two walks disagree.
unsigned clang_DeclContext_getNumNoloadLookupNames(CXDeclContext DC,
                                                   bool PreserveInternalState);

void clang_DeclContext_getNoloadLookupNames(CXDeclContext DC, bool PreserveInternalState,
                                            CXDeclarationName *Buf);

// helper: the sole declaration named Name in DC, or null when the lookup found
// nothing or an overload set — DeclContextLookupResult's isSingleResult + front
// in one crossing. PRECONDITION: DC must not be a transparent context (a
// LinkageSpec or an Export), which clang's lookup asserts against.
CXNamedDecl clang_DeclContext_lookupSingleResult(CXDeclContext DC, CXDeclarationName Name);

// using directives: DeclContext::using_directives() as a two-call count + fill.
unsigned clang_DeclContext_getNumUsingDirectives(CXDeclContext DC);

void clang_DeclContext_getUsingDirectives(CXDeclContext DC, CXUsingDirectiveDecl *Buf);

bool clang_DeclContext_hasExternalLexicalStorage(CXDeclContext DC);

// PRECONDITION for both setters below: passing true commits the context to
// loading its declarations from an external AST source, so the parent
// ASTContext must have one — clang dereferences it unchecked on the next
// traversal or lookup.
void clang_DeclContext_setHasExternalLexicalStorage(CXDeclContext DC, bool ES);

bool clang_DeclContext_hasExternalVisibleStorage(CXDeclContext DC);

void clang_DeclContext_setHasExternalVisibleStorage(CXDeclContext DC, bool ES);

bool clang_DeclContext_isDeclInLexicalTraversal(CXDeclContext DC, CXDecl D);

void clang_DeclContext_setUseQualifiedLookup(CXDeclContext DC, bool Use);

bool clang_DeclContext_shouldUseQualifiedLookup(CXDeclContext DC);

// True when D also is a DeclContext, i.e. when clang_Decl_castToDeclContext is
// legal on it.
bool clang_DeclContext_classof(CXDecl D);

// noload decls: the first declaration lexically stored in DC, obtained without
// asking an external AST source for anything. NULL when DC stores none; walk the
// rest with clang_Decl_getNextDeclInContext, the way
// clang_DeclContext_decl_iterator_begin is walked.
CXDecl clang_DeclContext_noload_decls_begin(CXDeclContext DC);

// local uncached lookup: DeclContext::localUncachedLookup(DeclarationName) as a
// two-call count + fill. It searches this context alone and falls back to a linear
// scan of the stored declarations when no lookup table answers, which is why clang
// reserves it for AST-importer-style callers.
// getNumLocalUncachedLookupResults runs the search to size it and
// localUncachedLookup writes exactly that many CXNamedDecl slots, none null.
unsigned clang_DeclContext_getNumLocalUncachedLookupResults(CXDeclContext DC,
                                                            CXDeclarationName Name);

void clang_DeclContext_localUncachedLookup(CXDeclContext DC, CXDeclarationName Name,
                                           CXNamedDecl *Results);

// PRECONDITION: DC must be its own primary context
// (clang_DeclContext_getPrimaryContext returns DC itself); clang asserts on the rest.
void clang_DeclContext_setMustBuildLookupTable(CXDeclContext DC);

// getLookupPtr as a predicate: StoredDeclsMap is an internal clang type with no
// handle of its own, so only its presence crosses. Name lookup builds the table
// on the primary context, so query clang_DeclContext_getPrimaryContext(DC) to
// learn whether the noload enumerations above can see anything.
bool clang_DeclContext_hasLookupTable(CXDeclContext DC);

// buildLookup: force the lookup table to be fully built, reporting whether one
// exists afterwards (a context that declares nothing still has none).
// PRECONDITION: DC must be its own primary context
// (clang_DeclContext_getPrimaryContext returns DC itself); clang asserts on the rest.
bool clang_DeclContext_buildLookup(CXDeclContext DC);

// Marks D as the object of a friend declaration, moving its identifier namespace into the
// *Friend variants. PerformFriendInjection also keeps the ordinary namespace bits, which is
// what makes the decl findable by ordinary lookup as well.
// PRECONDITION: D's identifier namespace must include Ordinary or Tag and nothing outside
// {Tag, Ordinary, Type, TagFriend, OrdinaryFriend, LocalExtern, NonMemberOperator} -- clang
// asserts both. IRREVERSIBLE: clang exposes no setIdentifierNamespace.
void clang_Decl_setObjectOfFriendDecl(CXDecl D, bool PerformFriendInjection);

LLVM_CLANG_C_EXTERN_C_END

#endif