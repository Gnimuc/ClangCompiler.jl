#ifndef LLVM_CLANG_C_EXTRA_CXASTCONTEXT_H
#define LLVM_CLANG_C_EXTRA_CXASTCONTEXT_H

#include "clang-ex/AST/CXType.h"
#include "clang-ex/Basic/CXSpecifiers.h"
#include "clang-ex/CXTypes.h"
#include "clang-ex/AST/CXAttr.h"
#include "clang-ex/Basic/CXAddressSpaces.h"
#include "clang-ex/Basic/CXLinkage.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-ex/Basic/CXTargetCXXABI.h"
#include "clang-ex/Basic/CXTargetInfo.h"
#include "llvm-c/ExecutionEngine.h"
#include "clang-ex/Basic/CXFloatModeKind.h"
#include "clang-ex/Basic/CXBuiltins.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirrors clang::AlignRequirementKind (clang/AST/ASTContext.h) — the third field
// of TypeInfo/TypeInfoChars, which cross as out-params (MARSHALLING.md §7).
typedef enum CXAlignRequirementKind {
  CXAlignRequirementKind_None,
  CXAlignRequirementKind_RequiredByTypedef,
  CXAlignRequirementKind_RequiredByRecord,
  CXAlignRequirementKind_RequiredByEnum
} CXAlignRequirementKind;

// Mirrors clang::ASTContext::InlineVariableDefinitionKind
// (clang/AST/ASTContext.h) — the class-local enum returned by
// getInlineVariableDefinitionKind.
typedef enum CXInlineVariableDefinitionKind {
  CXInlineVariableDefinitionKind_None,
  CXInlineVariableDefinitionKind_Weak,
  CXInlineVariableDefinitionKind_WeakUnknown,
  CXInlineVariableDefinitionKind_Strong
} CXInlineVariableDefinitionKind;

// Mirrors clang::ASTContext::GetBuiltinTypeError (clang/AST/ASTContext.h) — why
// clang_ASTContext_GetBuiltinType could not build a builtin's type.
typedef enum CXGetBuiltinTypeError {
  CXGetBuiltinTypeError_GE_None,
  CXGetBuiltinTypeError_GE_Missing_type,
  CXGetBuiltinTypeError_GE_Missing_stdio,
  CXGetBuiltinTypeError_GE_Missing_setjmp,
  CXGetBuiltinTypeError_GE_Missing_ucontext
} CXGetBuiltinTypeError;

// ASTContext

// getInterpContext

// The context's dynamic-parent map — the object that owns the cached parent edges every
// clang_ASTContext_getNumParentsOf*/getParentOf* call below reads, and the traversal kind
// that decides whether those edges step through nodes clang did not spell in the source.
// BORROWED: the ASTContext owns it through a std::unique_ptr member and builds it on the
// first call, so it lives exactly as long as the context and has no dispose.
CXParentMapContext clang_ASTContext_getParentMapContext(CXASTContext Ctx);

// getTraversalScope

// helper — how many decls clang_ASTContext_getTraversalScopeDecls will write
// (MARSHALLING.md §6, count+fill). The scope defaults to {getTranslationUnitDecl()}, so
// the count is at least 1 until setTraversalScope narrows it.
unsigned clang_ASTContext_getNumTraversalScopeDecls(CXASTContext Ctx);

// Fills Buf with exactly clang_ASTContext_getNumTraversalScopeDecls entries; the count is
// exact and no slot is null. Buf is caller-allocated; the decls it receives are borrowed
// interior pointers into the ASTContext arena.
void clang_ASTContext_getTraversalScopeDecls(CXASTContext Ctx, CXDecl *Buf);

// The Decls buffer is copied into the context's own vector, so it may be freed right after
// the call; Decls may be NULL when NumDecls is 0. Narrowing the scope also clears the
// cached parent map.
void clang_ASTContext_setTraversalScope(CXASTContext Ctx, CXDecl *Decls, unsigned NumDecls);

// helper — the parents of S within the current traversal scope (MARSHALLING.md §6
// count+index, §8 arm split on the parent node's kind). A statement inside a template
// pattern can have more than one parent; every other node has 0 or 1, and only the
// translation unit has none. The map is built lazily on the first call and CACHED on the
// ASTContext, so nodes produced by a LATER incremental parse are absent from it until the
// cache is dropped — clang_ASTContext_setTraversalScope and clang_ParentMapContext_clear
// are the two ways to drop it.
unsigned clang_ASTContext_getNumParentsOfStmt(CXASTContext Ctx, CXStmt S);

// PRECONDITION: I < clang_ASTContext_getNumParentsOfStmt(Ctx, S), restated as an @assert in
// the Julia layer. Out of range the shim answers NULL rather than tripping
// DynTypedNodeList::operator[]'s own assert, which aborts the process under an
// assertion-enabled LLVM (MARSHALLING.md §13). The parent is a discriminated node
// (MARSHALLING.md §8): for a given I at most one of the two accessors answers non-NULL,
// and both answer NULL when the parent is neither a Stmt nor a Decl (a Type, TypeLoc or
// NestedNameSpecifier parent). Only the pointer-identity node kinds are exposed, because
// DynTypedNode::get<T>() on a by-value kind points into the DynTypedNodeList temporary.
// Borrowed AST-arena pointers.
CXStmt clang_ASTContext_getParentOfStmtAsStmt(CXASTContext Ctx, CXStmt S, unsigned I);
CXDecl clang_ASTContext_getParentOfStmtAsDecl(CXASTContext Ctx, CXStmt S, unsigned I);

// The same pair over a declaration; the caveats above apply unchanged.
unsigned clang_ASTContext_getNumParentsOfDecl(CXASTContext Ctx, CXDecl D);
CXStmt clang_ASTContext_getParentOfDeclAsStmt(CXASTContext Ctx, CXDecl D, unsigned I);
CXDecl clang_ASTContext_getParentOfDeclAsDecl(CXASTContext Ctx, CXDecl D, unsigned I);

// The context's own policy -- the one every printer taking a CXASTContext reads. This is a
// BORROWED interior pointer into a by-value member (MARSHALLING.md §14 does not apply: it is
// a plain member, not an element of a container clang can reallocate), so it has no dispose,
// and passing it to clang_PrintingPolicy_dispose deletes into the ASTContext. Mutating it
// changes what every one of those printers produces for the rest of the context's life.
CXPrintingPolicy_ clang_ASTContext_getPrintingPolicy(CXASTContext Ctx);

// Copy-assigns Policy into the context. The handle is NOT adopted: the caller keeps ownership
// and must still dispose a policy it created.
void clang_ASTContext_setPrintingPolicy(CXASTContext Ctx, CXPrintingPolicy_ Policy);

CXSourceManager clang_ASTContext_getSourceManager(CXASTContext Ctx);

// cleanup
// getAllocator
// Allocate
// Deallocate
// AllocateDeclListNode
// DeallocateDeclListNode

size_t clang_ASTContext_getASTAllocatedMemory(CXASTContext Ctx);

size_t clang_ASTContext_getSideTableAllocatedMemory(CXASTContext Ctx);

// getDiagAllocator

CXTargetInfo_ clang_ASTContext_getTargetInfo(CXASTContext Ctx);

CXTargetInfo_ clang_ASTContext_getAuxTargetInfo(CXASTContext Ctx);

CXQualType clang_ASTContext_getIntTypeForBitwidth(CXASTContext Ctx, unsigned DestWidth,
                                                  unsigned Signed);

// CXQualType clang_ASTContext_getRealTypeForBitwidth(CXASTContext Ctx, unsigned DestWidth,
//                                                    clang::FloatModeKind ExplicitType);

// Returns a null CXQualType when the target has no floating-point type of DestWidth bits in
// the requested mode — that is the documented "no appropriate target type" answer, not an
// error.
CXQualType clang_ASTContext_getRealTypeForBitwidth(CXASTContext Ctx, unsigned DestWidth,
                                                   CXFloatModeKind ExplicitType);

bool clang_ASTContext_AtomicUsesUnsupportedLibcall(CXASTContext Ctx, CXAtomicExpr E);

CXLangOptions clang_ASTContext_getLangOpts(CXASTContext Ctx);

bool clang_ASTContext_isDependceAllowed(CXASTContext Ctx);

// getSanitizerBlacklist
// getXRayFilter
// getProfileList

CXDiagnosticsEngine clang_ASTContext_getDiagnostics(CXASTContext Ctx);

// getFullLoc

// The C++ ABI in effect: -fc++-abi= when it was given, the target's default otherwise.
CXTargetCXXABI_Kind clang_ASTContext_getCXXABIKind(CXASTContext Ctx);
// cacheRawCommentForDecl
// getRawCommentForDeclNoCacheImpl
// The documentation comment attached to D itself: no cache consultation and no
// redeclaration walk, unlike clang_ASTContext_getRawCommentForAnyRedecl. NULL when nothing is
// attached to D -- which is the normal answer for every redeclaration but the one the comment
// was written above. Borrowed: RawComments live in the context's arena.
CXRawComment clang_ASTContext_getRawCommentForDeclNoCache(CXASTContext Ctx, CXDecl D);
// addComment
// getRawCommentForAnyRedecl

// getRawCommentForAnyRedecl is exposed as two composite helpers rather than a
// CXRawComment handle: the comment text (already resolved against the
// ASTContext's own SourceManager) and the redeclaration the comment was attached
// to. Both report "no comment" out of band — an empty string (a RawComment always
// spans at least its introducer, so empty is unambiguous) and a null handle.
// The RawComment handle itself, for callers that need more than the text (kind,
// attachment/trailing flags, range). Returns NULL when no comment is attached.
CXRawComment clang_ASTContext_getRawCommentForAnyRedecl(CXASTContext Ctx, CXDecl D);
CXString clang_ASTContext_getRawCommentTextForAnyRedecl(CXASTContext Ctx,
                                                        CXDecl D); // helper

CXDecl clang_ASTContext_getRawCommentOriginalDeclForAnyRedecl(CXASTContext Ctx,
                                                              CXDecl D); // helper
// attachCommentsToJustParsedDecl
// Parsed documentation comment tree for D, or NULL when none is attached. PP may
// be NULL when no Preprocessor is available.
CXFullComment clang_ASTContext_getCommentForDecl(CXASTContext Ctx, CXDecl D,
                                                 CXPreprocessor PP);

// The parsed documentation comment attached to D itself — no redeclaration lookup
// and no cache. NULL when none is attached.
CXFullComment clang_ASTContext_getLocalCommentForDeclUncached(CXASTContext Ctx, CXDecl D);

// Copies FC's comment blocks onto a fresh FullComment carrying D's own DeclInfo. FC must
// be non-null — clang dereferences it — and the clone is ASTContext-arena memory (no
// dispose).
CXFullComment clang_ASTContext_cloneFullComment(CXASTContext Ctx, CXFullComment FC,
                                                CXDecl D);
// getCommentCommandTraits
// getDeclAttrs

void clang_ASTContext_eraseDeclAttrs(CXASTContext Ctx, CXDecl D);

// Partial (the Julia wrapper restates the precondition): clang asserts Var is a
// static data member. NULL when Var is not an instantiated one.
CXMemberSpecializationInfo
clang_ASTContext_getInstantiatedFromStaticDataMember(CXASTContext Ctx, CXVarDecl Var);

// getTemplateOrSpecializationInfo

// The two arms of the PointerUnion ASTContext::getTemplateOrSpecializationInfo returns
// (MARSHALLING.md §8). The arms are unrelated classes, so no companion discriminator is
// needed: each accessor answers NULL when the union holds the other arm or nothing at all.
// Both are total — unlike clang_ASTContext_getInstantiatedFromStaticDataMember, which
// asserts Var is a static data member.
CXVarTemplateDecl
clang_ASTContext_getTemplateOrSpecializationInfoAsVarTemplate(CXASTContext Ctx,
                                                              CXVarDecl Var);

CXMemberSpecializationInfo
clang_ASTContext_getTemplateOrSpecializationInfoAsMemberSpecialization(CXASTContext Ctx,
                                                                       CXVarDecl Var);
// setInstantiatedFromStaticDataMember

// PRECONDITIONS: Inst and Tmpl must both be static data members, Inst must not already
// have a recorded pattern, and TSK must not be TSK_Undeclared — clang asserts all four
// (the last inside MemberSpecializationInfo's constructor). The gates are
// clang_VarDecl_isStaticDataMember, clang_ASTContext_getInstantiatedFromStaticDataMember
// and clang_VarDecl_getDescribedVarTemplate (the other arm of the same union); the Julia
// layer restates them.
void clang_ASTContext_setInstantiatedFromStaticDataMember(
    CXASTContext Ctx, CXVarDecl Inst, CXVarDecl Tmpl, CXTemplateSpecializationKind TSK,
    CXSourceLocation_ PointOfInstantiation);
// setTemplateOrSpecializationInfo

// The VarTemplateDecl arm of the PointerUnion ASTContext::setTemplateOrSpecializationInfo
// takes (MARSHALLING.md §8), split out so no discriminator crosses. The
// MemberSpecializationInfo arm is already reachable through
// clang_ASTContext_setInstantiatedFromStaticDataMember, which builds one internally.
// PRECONDITION: Inst must not already carry either arm — clang asserts it. The gates are
// clang_ASTContext_getTemplateOrSpecializationInfoAsVarTemplate and
// clang_ASTContext_getTemplateOrSpecializationInfoAsMemberSpecialization, both restated as
// @asserts in the Julia layer.
void clang_ASTContext_setTemplateOrSpecializationInfoAsVarTemplate(CXASTContext Ctx,
                                                                   CXVarDecl Inst,
                                                                   CXVarTemplateDecl Tmpl);

CXNamedDecl clang_ASTContext_getInstantiatedFromUsingDecl(CXASTContext Ctx,
                                                          CXNamedDecl Inst);

void clang_ASTContext_setInstantiatedFromUsingDecl(CXASTContext Ctx, CXNamedDecl Inst,
                                                   CXNamedDecl Pattern);

CXUsingEnumDecl clang_ASTContext_getInstantiatedFromUsingEnumDecl(CXASTContext Ctx,
                                                                  CXUsingEnumDecl Inst);

// PRECONDITION: Inst must not already carry a recorded pattern — clang asserts it. The
// Julia layer restates this by checking the getter first.
void clang_ASTContext_setInstantiatedFromUsingEnumDecl(CXASTContext Ctx,
                                                       CXUsingEnumDecl Inst,
                                                       CXUsingEnumDecl Pattern);

void clang_ASTContext_setInstantiatedFromUsingShadowDecl(CXASTContext Ctx,
                                                         CXUsingShadowDecl Inst,
                                                         CXUsingShadowDecl Pattern);

CXUsingShadowDecl
clang_ASTContext_getInstantiatedFromUsingShadowDecl(CXASTContext Ctx,
                                                    CXUsingShadowDecl Inst);

CXFieldDecl clang_ASTContext_getInstantiatedFromUnnamedFieldDecl(CXASTContext Ctx,
                                                                 CXFieldDecl Field);

void clang_ASTContext_setInstantiatedFromUnnamedFieldDecl(CXASTContext Ctx,
                                                          CXFieldDecl Inst,
                                                          CXFieldDecl Tmpl);

void clang_ASTContext_addOverriddenMethod(CXASTContext Ctx, CXCXXMethodDecl Method,
                                          CXCXXMethodDecl Overridden);

// getOverriddenMethods

unsigned clang_ASTContext_overridden_methods_size(CXASTContext Ctx, CXCXXMethodDecl Method);

// helper — walks ASTContext::getOverriddenMethods once and reports how many entries
// clang_ASTContext_getOverriddenMethods will write (MARSHALLING.md §6, count+fill).
unsigned clang_ASTContext_getNumOverriddenMethods(CXASTContext Ctx, CXNamedDecl Method);

// Fills Buf with exactly clang_ASTContext_getNumOverriddenMethods entries; the count is
// exact and no slot is null. Buf is caller-allocated; the decls it receives are borrowed
// interior pointers into the ASTContext arena.
void clang_ASTContext_getOverriddenMethods(CXASTContext Ctx, CXNamedDecl Method,
                                           CXNamedDecl *Buf);

void clang_ASTContext_addedLocalImportDecl(CXASTContext Ctx, CXImportDecl Import);


// Static — ImportDecl's own accessor is private in clang 18, so this ASTContext entry
// point is the only path to the next link of the translation unit's local import chain.
// NULL at the end of the chain.
CXImportDecl clang_ASTContext_getNextLocalImport(CXImportDecl Import);

// local_imports

// helper — the head of this translation unit's local import chain
// (ASTContext::local_imports), walked from there with clang_ASTContext_getNextLocalImport.
// NULL when nothing has been imported. The ImportDecl is a borrowed interior pointer.
CXImportDecl clang_ASTContext_getFirstLocalImport(CXASTContext Ctx);

CXDecl clang_ASTContext_getPrimaryMergedDecl(CXASTContext Ctx, CXDecl D);

void clang_ASTContext_setPrimaryMergedDecl(CXASTContext Ctx, CXDecl D, CXDecl Primary);

void clang_ASTContext_mergeDefinitionIntoModule(CXASTContext Ctx, CXNamedDecl ND,
                                                CXModule_ Module, bool NotifyListeners);

void clang_ASTContext_deduplicateMergedDefinitonsFor(CXASTContext Ctx, CXNamedDecl ND);

// The additional modules the definition Def has been merged into (MARSHALLING.md §6,
// count+index over the ArrayRef the context stores per canonical decl). The count is 0
// outside a modules build; the CXModules are borrowed, owned by the module map.
unsigned clang_ASTContext_getNumModulesWithMergedDefinition(CXASTContext Ctx,
                                                            CXNamedDecl Def);

// PRECONDITION: I < clang_ASTContext_getNumModulesWithMergedDefinition(Ctx, Def) — the
// index is unchecked; restated as an @assert in the Julia layer.
CXModule_ clang_ASTContext_getModuleWithMergedDefinition(CXASTContext Ctx, CXNamedDecl Def,
                                                        unsigned I);

// getModuleInitializers

// Records Init as a declaration to run when Module M is initialized — typically a
// module-scope variable whose initializer runs on import, or an ImportDecl nominating
// another module. The context keys the list on the Module pointer and owns neither handle.
void clang_ASTContext_addModuleInitializer(CXASTContext Ctx, CXModule_ M, CXDecl Init);

// helper — how many initializers Module M has (MARSHALLING.md §6, count+index over the
// ArrayRef the context stores per module). 0 for a module nothing was recorded against.
unsigned clang_ASTContext_getNumModuleInitializers(CXASTContext Ctx, CXModule_ M);

// PRECONDITION: I < clang_ASTContext_getNumModuleInitializers(Ctx, M) — the index is
// unchecked; restated as an @assert in the Julia layer. The CXDecls are borrowed.
CXDecl clang_ASTContext_getModuleInitializer(CXASTContext Ctx, CXModule_ M, unsigned I);

// setCurrentNamedModule

// The C++20 named module under construction; NULL outside a named-module build.
CXModule_ clang_ASTContext_getCurrentNamedModule(CXASTContext Ctx);

CXTranslationUnitDecl clang_ASTContext_getTranslationUnitDecl(CXASTContext Ctx);

// The TUKind the context was built with. TUKind is a public const data member with no
// accessor in clang; it is exported because clang_ASTContext_addTranslationUnitDecl asserts
// on it (MARSHALLING.md §13, "export the gate").
CXTranslationUnitKind clang_ASTContext_getTranslationUnitKind(CXASTContext Ctx);

// The context's comment list, borrowed -- an interior pointer to a member, exactly like
// clang_ASTContext_getIdents. No dispose.
CXRawCommentList clang_ASTContext_getComments(CXASTContext Ctx);

// Pushes a fresh, empty TranslationUnitDecl onto the context's redeclaration chain and makes
// it the one clang_ASTContext_getTranslationUnitDecl returns; the previous TU stays reachable
// through getPreviousDecl. This is the operation clang's own IncrementalParser performs
// before each incremental parse.
// PRECONDITION: the context is TU_Incremental -- clang asserts `!TUDecl || TUKind ==
// TU_Incremental`, and TUDecl is non-null for every context this API hands out.
void clang_ASTContext_addTranslationUnitDecl(CXASTContext Ctx);

CXExternCContextDecl clang_ASTContext_getExternCContextDecl(CXASTContext Ctx);

CXBuiltinTemplateDecl clang_ASTContext_getMakeIntegerSeqDecl(CXASTContext Ctx);

CXBuiltinTemplateDecl clang_ASTContext_getTypePackElementDecl(CXASTContext Ctx);

// setExternalSource
// getExternalSource
// setASTMutationListener
// getASTMutationListener

void clang_ASTContext_PrintStats(CXASTContext Ctx);

// getTypes

// helper — the number of clang::Type nodes this context has created (MARSHALLING.md §6,
// count+index over ASTContext::getTypes(), which is contiguous storage).
unsigned clang_ASTContext_getNumTypes(CXASTContext Ctx);

// PRECONDITION: I < clang_ASTContext_getNumTypes(Ctx) — the index is unchecked; restated
// as an @assert in the Julia layer. The Type is a borrowed pointer into the ASTContext
// arena.
CXType_ clang_ASTContext_getType(CXASTContext Ctx, unsigned I);

// Builds the BuiltinTemplateDecl for BTK named II and adds it to the translation unit, the
// way getMakeIntegerSeqDecl/getTypePackElementDecl build theirs. ASTContext-arena memory
// (no dispose).
CXBuiltinTemplateDecl clang_ASTContext_buildBuiltinTemplateDecl(CXASTContext Ctx,
                                                                CXBuiltinTemplateKind BTK,
                                                                CXIdentifierInfo II);

CXRecordDecl clang_ASTContext_buildImplicitRecord(CXASTContext Ctx, const char *Name,
                                                  CXTagTypeKind TK);

CXTypedefDecl clang_ASTContext_buildImplicitTypedef(CXASTContext Ctx, CXQualType T,
                                                    const char *Name);

CXTypedefDecl clang_ASTContext_getInt128Decl(CXASTContext Ctx);

CXTypedefDecl clang_ASTContext_getUInt128Decl(CXASTContext Ctx);


// Any address space already on T is silently replaced.
CXQualType clang_ASTContext_getAddrSpaceQualType(CXASTContext Ctx, CXQualType T,
                                                 CXLangAS AddressSpace);

CXQualType clang_ASTContext_removeAddrSpaceQualType(CXASTContext Ctx, CXQualType T);

// applyObjCProtocolQualifiers

// The result carries the union of T's qualifiers and GCAttr.
// PRECONDITIONS: GCAttr must not be CXQualifiers_GCNone (Qualifiers::addObjCGCAttr asserts
// it names an attribute) and T must not already carry a GC attribute ("Type cannot have
// multiple ObjCGCQualifiers"). The gate is clang_QualType_getObjCGCAttr; the Julia layer
// restates both.
CXQualType clang_ASTContext_getObjCGCQualType(CXASTContext Ctx, CXQualType T,
                                              CXQualifiers_GC GCAttr);

CXQualType clang_ASTContext_removePtrSizeAddrSpace(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getRestrictType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getVolatileType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getConstType(CXASTContext Ctx, CXQualType T);


// FunctionType::ExtInfo flattened to the FFI-relevant subset (MARSHALLING.md §7): the
// calling convention plus the noreturn and ns_returns_retained bits. Every other ExtInfo
// field (regparm, no_caller_saved_regs, nocf_check, cmse_nonsecure_call) is carried over
// from Fn's own ExtInfo. The result is Fn itself when the requested ExtInfo already
// matches, and otherwise a fresh node of Fn's own class (FunctionProtoType stays a
// FunctionProtoType, FunctionNoProtoType stays a FunctionNoProtoType).
CXFunctionType clang_ASTContext_adjustFunctionType(CXASTContext Ctx, CXFunctionType Fn,
                                                   CXCallingConv_ CC, bool NoReturn,
                                                   bool ProducesResult);

CXQualType clang_ASTContext_getCanonicalFunctionResultType(CXASTContext Ctx,
                                                           CXQualType ResultType);

void clang_ASTContext_adjustDeducedFunctionResultType(CXASTContext Ctx, CXFunctionDecl FD,
                                                      CXQualType ResultType);


// FunctionProtoType::ExceptionSpecInfo flattened to its discriminator alone (MARSHALLING.md
// §7): only the specifications carrying no further payload can be requested this way.
// PRECONDITION: EST must be one of EST_None, EST_DynamicNone, EST_MSAny, EST_NoThrow and
// EST_BasicNoexcept — every other kind needs an exception type list, a noexcept expression
// or a source declaration this entry point cannot carry. Orig must also be a function
// prototype type: clang reaches its FunctionProtoType through an unchecked castAs<> once
// the "already matches" fast path misses. Both are restated as @asserts in the Julia layer.
CXQualType
clang_ASTContext_getFunctionTypeWithExceptionSpec(CXASTContext Ctx, CXQualType Orig,
                                                  CXExceptionSpecificationType EST);

bool clang_ASTContext_hasSameFunctionTypeIgnoringExceptionSpec(CXASTContext Ctx,
                                                               CXQualType T, CXQualType U);


// Rewrites FD's type with the exception specification EST, and its written type source
// info too when AsWritten is true. Same ExceptionSpecInfo flattening and the same EST
// precondition as clang_ASTContext_getFunctionTypeWithExceptionSpec, which this runs on
// FD's own type — so FD must have a function prototype type.
void clang_ASTContext_adjustExceptionSpec(CXASTContext Ctx, CXFunctionDecl FD,
                                          CXExceptionSpecificationType EST, bool AsWritten);

CXQualType clang_ASTContext_getFunctionTypeWithoutPtrSizes(CXASTContext Ctx, CXQualType T);

bool clang_ASTContext_hasSameFunctionTypeIgnoringPtrSizes(CXASTContext Ctx, CXQualType T,
                                                          CXQualType U);

CXQualType clang_ASTContext_getComplexType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getPointerType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getAdjustedType(CXASTContext Ctx, CXQualType Orig,
                                            CXQualType New);

CXQualType clang_ASTContext_getDecayedType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getAtomicType(CXASTContext Ctx, CXQualType T);

// Qualifiers cross as their opaque value — the same encoding
// clang_QualType_getQualifiersAsOpaqueValue produces.
CXQualType clang_ASTContext_getQualifiedType(CXASTContext Ctx, CXQualType T,
                                             unsigned Quals);

// Peels the qualifiers off the (possibly nested) array element type; *Quals
// receives them as the opaque Qualifiers value. Total: on a non-array it yields
// T.getUnqualifiedType() and the qualifiers it stripped.
CXQualType clang_ASTContext_getUnqualifiedArrayType(CXASTContext Ctx, CXQualType T,
                                                    unsigned *Quals);

CXQualType clang_ASTContext_getAttributedType(CXASTContext Ctx, CXAttrKind AttrKind,
                                              CXQualType ModifiedType,
                                              CXQualType EquivalentType);

// getBTFTagAttributedType

CXQualType clang_ASTContext_getIncompleteArrayType(CXASTContext Ctx, CXQualType EltTy,
                                                   CXArraySizeModifier ASM,
                                                   unsigned IndexTypeQuals);

bool clang_ASTContext_isPromotableIntegerType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getBlockPointerType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getBlockDescriptorType(CXASTContext Ctx);

CXQualType clang_ASTContext_getReadPipeType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getWritePipeType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getBitIntType(CXASTContext Ctx, bool Unsigned,
                                          unsigned NumBits);

CXQualType clang_ASTContext_getDependentBitIntType(CXASTContext Ctx, bool Unsigned,
                                                   CXExpr BitsExpr);

CXQualType clang_ASTContext_getBlockDescriptorExtendedType(CXASTContext Ctx);

// getOpenCLTypeKind
// getOpenCLTypeAddrSpace

// The OpenCL type family T belongs to; OCLTK_Default for every type that is not one of
// OpenCL's opaque builtins (so, for every ordinary C/C++ type).
CXOpenCLTypeKind clang_ASTContext_getOpenCLTypeKind(CXASTContext Ctx, CXType_ T);

// The address space the target assigns to T's OpenCL type family.
CXLangAS clang_ASTContext_getOpenCLTypeAddrSpace(CXASTContext Ctx, CXType_ T);

CXLangAS clang_ASTContext_getDefaultOpenCLPointeeAddrSpace(CXASTContext Ctx);

void clang_ASTContext_setcudaConfigureCallDecl(CXASTContext Ctx, CXFunctionDecl FD);

CXFunctionDecl clang_ASTContext_getcudaConfigureCallDecl(CXASTContext Ctx);

bool clang_ASTContext_BlockRequiresCopying(CXASTContext Ctx, CXQualType T, CXVarDecl D);

// getByrefLifeTime

// bool-return + out-params (MARSHALLING.md §8): true when Ty has a known ARC lifetime for a
// __block capture, with *Lifetime and *HasByrefExtendedLayout filled in. False — the answer
// for every translation unit that is not Objective-C under ARC — leaves both untouched, and
// the Julia layer reports that as `nothing`.
bool clang_ASTContext_getByrefLifetime(CXASTContext Ctx, CXQualType Ty,
                                       CXQualifiers_ObjCLifetime *Lifetime,
                                       bool *HasByrefExtendedLayout);

CXQualType clang_ASTContext_getLValueReferenceType(CXASTContext Ctx, CXQualType T,
                                                   bool SpelledAsLValue);

CXQualType clang_ASTContext_getRValueReferenceType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getMemberPointerType(CXASTContext Ctx, CXQualType T,
                                                 CXType_ Cls);

// getVariableArrayType
// getDependentSizedArrayType
// getIncompleteArrayType

// NumElts is stored on the type, never evaluated; the result is deliberately non-unique
// (a fresh type node per call), matching the C++ API.
CXQualType clang_ASTContext_getVariableArrayType(CXASTContext Ctx, CXQualType EltTy,
                                                 CXExpr NumElts, CXArraySizeModifier ASM,
                                                 unsigned IndexTypeQuals,
                                                 CXSourceRange_ Brackets);

// Same shape as getVariableArrayType, for a dependently-sized array; also non-unique.
CXQualType clang_ASTContext_getDependentSizedArrayType(CXASTContext Ctx, CXQualType EltTy,
                                                       CXExpr NumElts,
                                                       CXArraySizeModifier ASM,
                                                       unsigned IndexTypeQuals,
                                                       CXSourceRange_ Brackets);

// The APInt size is built inside the shim from `Size` at the target's size_t
// width; SizeExpr is always null.
CXQualType clang_ASTContext_getConstantArrayType(CXASTContext Ctx, CXQualType EltTy,
                                                 uint64_t Size, CXArraySizeModifier ASM,
                                                 unsigned IndexTypeQuals);


CXQualType clang_ASTContext_getStringLiteralArrayType(CXASTContext Ctx, CXQualType EltTy,
                                                      unsigned Length);

CXQualType clang_ASTContext_getVariableArrayDecayedType(CXASTContext Ctx, CXQualType T);

// getBuiltinVectorTypeInfo

CXQualType clang_ASTContext_getScalableVectorType(CXASTContext Ctx, CXQualType EltTy,
                                                  unsigned NumElts);

// getWebAssemblyExternrefType

CXQualType clang_ASTContext_getVectorType(CXASTContext Ctx, CXQualType VectorType,
                                          unsigned NumElts, CXVectorKind VecKind);

// getVectorType

CXQualType clang_ASTContext_getDependentVectorType(CXASTContext Ctx, CXQualType VectorType,
                                                   CXExpr SizeExpr,
                                                   CXSourceLocation_ AttrLoc,
                                                   CXVectorKind VecKind);

CXQualType clang_ASTContext_getExtVectorType(CXASTContext Ctx, CXQualType VectorType,
                                             unsigned NumElts);

CXQualType clang_ASTContext_getDependentSizedExtVectorType(CXASTContext Ctx,
                                                           CXQualType VectorType,
                                                           CXExpr SizeExpr,
                                                           CXSourceLocation_ AttrLoc);

CXQualType clang_ASTContext_getConstantMatrixType(CXASTContext Ctx, CXQualType ElementType,
                                                  unsigned NumRows, unsigned NumCols);

CXQualType clang_ASTContext_getDependentSizedMatrixType(CXASTContext Ctx,
                                                        CXQualType ElementType,
                                                        CXExpr RowsExpr, CXExpr ColsExpr,
                                                        CXSourceLocation_ AttrLoc);

CXQualType clang_ASTContext_getDependentAddressSpaceType(CXASTContext Ctx,
                                                         CXQualType PointeeType,
                                                         CXExpr AddrSpaceExpr,
                                                         CXSourceLocation_ AddrSpace);

CXQualType clang_ASTContext_getFunctionNoProtoType(CXASTContext Ctx, CXQualType ResultTy);

// ExtProtoInfo flattened to the FFI-relevant subset (variadic + calling
// convention; everything else defaulted). `ArgTys` is a (handle-buffer, count)
// array of CXQualType encodings rebuilt into an ArrayRef inside the shim.
CXQualType clang_ASTContext_getFunctionType(CXASTContext Ctx, CXQualType ResultTy,
                                            const CXQualType *ArgTys, unsigned NumArgs,
                                            bool IsVariadic, CXCallingConv_ CC);

CXQualType clang_ASTContext_adjustStringLiteralBaseType(CXASTContext Ctx,
                                                        CXQualType StrLTy);

CXQualType clang_ASTContext_getTypeDeclType(CXASTContext Ctx, CXTypeDecl Decl,
                                            CXTypeDecl PrevDecl);

// PRECONDITION (documented in the Julia wrapper; the C API exposes no cheap proxy for
// it): Found's target declaration must be a TypeDecl — clang casts it unchecked — and
// Underlying must be unqualified and canonically identical to that declaration's type,
// both of which clang asserts.
CXQualType clang_ASTContext_getUsingType(CXASTContext Ctx, CXUsingShadowDecl Found,
                                         CXQualType Underlying);

CXQualType clang_ASTContext_getTypedefType(CXASTContext Ctx, CXTypedefNameDecl Decl,
                                           CXQualType Underlying);

CXQualType clang_ASTContext_getRecordType(CXASTContext Ctx, CXRecordDecl Decl);

CXQualType clang_ASTContext_getEnumType(CXASTContext Ctx, CXEnumDecl Decl);

// Builds (and caches on the declaration) the UnresolvedUsingType of a dependent
// `using typename T::x;` declaration.
CXQualType clang_ASTContext_getUnresolvedUsingType(CXASTContext Ctx,
                                                   CXUnresolvedUsingTypenameDecl Decl);

CXQualType clang_ASTContext_getInjectedClassNameType(CXASTContext Ctx, CXCXXRecordDecl Decl,
                                                     CXQualType TST);

// getAttributedType

// CXQualType clang_ASTContext_getSubstTemplateTypeParmType(CXASTContext Ctx,
//                                                          CXTemplateTypeParmType Replaced,
//                                                          CXQualType Replacement);

// getSubstTemplateTypeParmPackType

// The std::optional<unsigned> pack index crosses as a flag plus a value (MARSHALLING.md
// §8): pass HasPackIndex = false for a disengaged optional, in which case PackIndex is
// ignored. The node is uniqued on the whole (replacement, decl, index, pack index) tuple.
// PRECONDITION (documented; the C API has no cheap proxy for it): AssociatedDecl must own
// a template parameter list with more than Index entries, because
// SubstTemplateTypeParmType::getReplacedParameter indexes into it unchecked afterwards.
CXQualType clang_ASTContext_getSubstTemplateTypeParmType(CXASTContext Ctx,
                                                         CXQualType Replacement,
                                                         CXDecl AssociatedDecl,
                                                         unsigned Index, bool HasPackIndex,
                                                         unsigned PackIndex);

// PRECONDITION: ArgPack must be a TemplateArgument of kind Pack, and every element of the
// pack must be a Type argument — clang reads the pack size unchecked and asserts the
// element kinds under an assertions build. Restated as @asserts in the Julia layer, which
// also shares AssociatedDecl's documented precondition above. The resulting type borrows
// the pack's element array, which lives in ASTContext memory.
CXQualType clang_ASTContext_getSubstTemplateTypeParmPackType(CXASTContext Ctx,
                                                             CXDecl AssociatedDecl,
                                                             unsigned Index, bool Final,
                                                             CXTemplateArgument ArgPack);

CXQualType clang_ASTContext_getTemplateTypeParmType(CXASTContext Ctx, unsigned Depth,
                                                    unsigned Index, bool ParameterPack,
                                                    CXTemplateTypeParmDecl ParmDecl);

// `Args` is a (handle-buffer, count) pair of CXTemplateArgument encodings
// (each handle is dereferenced — the buffer is handles, not a contiguous
// value array). `Underlying` may be null; it is only consulted for alias
// templates.
CXQualType clang_ASTContext_getTemplateSpecializationType(
    CXASTContext Ctx, CXTemplateName T, const CXTemplateArgument *Args,
    unsigned NumArgs, CXQualType Underlying);


// PRECONDITION: T and every argument must already be canonical — this entry point builds
// the canonical node directly and does not canonicalise its inputs. Restated as an @assert
// in the Julia layer for T (comparable against clang_ASTContext_getCanonicalTemplateName)
// and as a documented requirement for the arguments (canonicalise them with
// clang_ASTContext_getCanonicalTemplateArgument). Args is a (buffer, count) pair of
// heap-boxed CXTemplateArgument encodings (MARSHALLING.md §11), like
// clang_ASTContext_getTemplateSpecializationType above.
CXQualType clang_ASTContext_getCanonicalTemplateSpecializationType(
    CXASTContext Ctx, CXTemplateName T, const CXTemplateArgument *Args, unsigned NumArgs);
// getTemplateSpecializationType (TemplateArgumentLoc overload)

// The TypeSourceInfo for T<Args...>: the type itself plus the written locations, with the
// angle brackets and the per-argument location info taken from Args. Canon may be a null
// CXQualType, in which case clang computes the canonical type itself.
// PRECONDITION: T must not be a dependent template name and must not be an unresolved one
// (clang asserts the former and llvm_unreachable()s while canonicalising the latter), and
// Canon must be non-null when T names a type alias template, whose underlying type clang
// refuses to compute here. All three are restated as @asserts in the Julia layer.
// ASTContext-arena memory (no dispose).
CXTypeSourceInfo clang_ASTContext_getTemplateSpecializationTypeInfo(
    CXASTContext Ctx, CXTemplateName T, CXSourceLocation_ TLoc,
    CXTemplateArgumentListInfo Args, CXQualType Canon);

CXQualType clang_ASTContext_getParenType(CXASTContext Ctx, CXQualType NamedType);

CXQualType clang_ASTContext_getMacroQualifiedType(CXASTContext Ctx, CXQualType UnderlyingTy,
                                                  CXIdentifierInfo MacroII);

CXQualType clang_ASTContext_getElaboratedType(CXASTContext Ctx,
                                              CXElaboratedTypeKeyword Keyword,
                                              CXNestedNameSpecifier NNS,
                                              CXQualType NamedType, CXTagDecl OwnedTagDecl);

// NumExpansions crosses as (bool HasNumExpansions, unsigned NumExpansions)
// (MARSHALLING.md, section 8): pass HasNumExpansions=false for a disengaged optional.
// When ExpectPackInType is true, Pattern must contain an unexpanded parameter pack.
CXQualType clang_ASTContext_getPackExpansionType(CXASTContext Ctx, CXQualType Pattern,
                                                 bool HasNumExpansions,
                                                 unsigned NumExpansions,
                                                 bool ExpectPackInType);

// getElaboratedType

// Build the dependent type `Keyword NNS::Name` (`typename T::type` and friends). Canon may
// be NULL, in which case clang computes the canonical type itself.
CXQualType clang_ASTContext_getDependentNameType(CXASTContext Ctx,
                                                 CXElaboratedTypeKeyword Keyword,
                                                 CXNestedNameSpecifier NNS,
                                                 CXIdentifierInfo Name, CXQualType Canon);

// Build the dependent type `Keyword NNS::Name<Args...>` — the node behind
// `typename T::template X<int>` and its relatives. Args is a (buffer, count) pair of
// heap-boxed CXTemplateArgument encodings, each handle dereferenced the way
// clang_ASTContext_getTemplateSpecializationType does (MARSHALLING.md §11). Only the
// ArrayRef<TemplateArgument> overload is wrapped, not the TemplateArgumentLoc one.
CXQualType clang_ASTContext_getDependentTemplateSpecializationType(
    CXASTContext Ctx, CXElaboratedTypeKeyword Keyword, CXNestedNameSpecifier NNS,
    CXIdentifierInfo Name, const CXTemplateArgument *Args, unsigned NumArgs);

// PRECONDITION: ParamDecl must be a template parameter (TemplateTypeParmDecl,
// NonTypeTemplateParmDecl or TemplateTemplateParmDecl); clang cast<>s it unchecked.
// Restated as an @assert in the Julia layer. The TemplateArgument is returned as an owned
// box (it has no pointer encoding); release it with clang_TemplateArgument_dispose.
CXTemplateArgument clang_ASTContext_getInjectedTemplateArg(CXASTContext Ctx,
                                                           CXNamedDecl ParamDecl);
// getInjectedTempalteArgs

// Fills Buf with exactly clang_TemplateParameterList_size(Params) entries — one injected
// argument per template parameter, in order (MARSHALLING.md §6, count+fill against a count
// the parameter list already knows; the count is exact and no slot is null). Buf is
// caller-allocated, and unlike the borrowed array behind
// RedeclarableTemplateDecl::getInjectedTemplateArgs every slot it receives is an OWNED
// heap-boxed TemplateArgument encoding — release each with clang_TemplateArgument_dispose.
void clang_ASTContext_getInjectedTemplateArgs(CXASTContext Ctx,
                                              CXTemplateParameterList Params,
                                              CXTemplateArgument *Buf);
// getPackExpansionType
// getObjCInterfaceType
// gvetObjCObjectType
// getObjCTypeParamType
// adjustObjCTypeParamBoundType
// ObjCObjectAdoptsQTypeProtocols
// QIdProtocolsAdoptObjCObjectProtocols
// getObjCObjectPointerType

// CXQualType clang_ASTContext_getTypeOfExprType(CXASTContext Ctx, CXExpr Expr);

// CXQualType clang_ASTContext_getTypeOfType(CXASTContext Ctx, CXType_ T);

// Unqualified picks clang::TypeOfKind::Unqualified over ::Qualified; the two-state enum
// class crosses as a bool.
CXQualType clang_ASTContext_getTypeOfExprType(CXASTContext Ctx, CXExpr E, bool Unqualified);

CXQualType clang_ASTContext_getTypeOfType(CXASTContext Ctx, CXQualType QT,
                                          bool Unqualified);

CXQualType clang_ASTContext_getReferenceQualifiedType(CXASTContext Ctx, CXExpr E);

CXQualType clang_ASTContext_getDecltypeType(CXASTContext Ctx, CXExpr Expr,
                                            CXQualType UnderlyingType);

// getUnaryTransformType
// getAutoType

// The type of a unary type transform (__underlying_type and the __add_*/__remove_*
// family): BaseType is the operand, UnderlyingType the transformed result. A dependent
// BaseType yields a DependentUnaryTransformType instead.
CXQualType clang_ASTContext_getUnaryTransformType(CXASTContext Ctx, CXQualType BaseType,
                                                  CXQualType UnderlyingType,
                                                  CXUTTKind UKind);

// C++11 deduced `auto`. A null DeducedType builds the undeduced `auto` placeholder;
// TypeConstraintConcept may be NULL (an unconstrained `auto`), and TypeConstraintArgs is a
// (handle-buffer, count) pair of CXTemplateArgument encodings (MARSHALLING.md §11), each
// handle dereferenced like clang_ASTContext_getTemplateSpecializationType does.
// PRECONDITION: IsPack is only meaningful together with IsDependent (a pack `auto` is
// inherently dependent); restated as an @assert in the Julia layer.
CXQualType clang_ASTContext_getAutoType(CXASTContext Ctx, CXQualType DeducedType,
                                        CXAutoTypeKeyword Keyword, bool IsDependent,
                                        bool IsPack, CXConceptDecl TypeConstraintConcept,
                                        const CXTemplateArgument *TypeConstraintArgs,
                                        unsigned NumArgs);

CXQualType clang_ASTContext_getAutoDeductType(CXASTContext Ctx);

CXQualType clang_ASTContext_getAutoRRefDeductType(CXASTContext Ctx);

CXQualType clang_ASTContext_getUnconstrainedType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getDeducedTemplateSpecializationType(CXASTContext Ctx,
                                                                 CXTemplateName Template,
                                                                 CXQualType DeducedType,
                                                                 bool IsDependent);

CXQualType clang_ASTContext_getTagDeclType(CXASTContext Ctx, CXTagDecl Decl);

// getSizeType
// getSignedSizeType

CXQualType clang_ASTContext_getIntMaxType(CXASTContext Ctx);
// getUIntMaxType

CXQualType clang_ASTContext_getSizeType(CXASTContext Ctx);

CXQualType clang_ASTContext_getSignedSizeType(CXASTContext Ctx);

CXQualType clang_ASTContext_getUIntMaxType(CXASTContext Ctx);

CXQualType clang_ASTContext_getWCharType(CXASTContext Ctx);

CXQualType clang_ASTContext_getWideCharType(CXASTContext Ctx);

CXQualType clang_ASTContext_getSignedWCharType(CXASTContext Ctx);

CXQualType clang_ASTContext_getUnsignedWCharType(CXASTContext Ctx);

CXQualType clang_ASTContext_getWIntType(CXASTContext Ctx);

CXQualType clang_ASTContext_getIntPtrType(CXASTContext Ctx);

CXQualType clang_ASTContext_getUIntPtrType(CXASTContext Ctx);

CXQualType clang_ASTContext_getPointerDiffType(CXASTContext Ctx);

CXQualType clang_ASTContext_getUnsignedPointerDiffType(CXASTContext Ctx);

CXQualType clang_ASTContext_getProcessIDType(CXASTContext Ctx);

CXQualType clang_ASTContext_getCFConstantStringType(CXASTContext Ctx);

CXQualType clang_ASTContext_getObjCSuperType(CXASTContext Ctx);

// Plain field assignment. The paired getter builds the implicit `struct objc_super` record
// on first use only while the field is still null, so setting it first suppresses that.
void clang_ASTContext_setObjCSuperType(CXASTContext Ctx, CXQualType ST);

CXQualType clang_ASTContext_getRawCFConstantStringType(CXASTContext Ctx);

void clang_ASTContext_setCFConstantStringType(CXASTContext Ctx, CXQualType T);

CXTypedefDecl clang_ASTContext_getCFConstantStringDecl(CXASTContext Ctx);

CXRecordDecl clang_ASTContext_getCFConstantStringTagDecl(CXASTContext Ctx);

// getObjCConstantStringInterface
// getObjCNSStringType
// setObjCNSStringType

// A plain QualType field of the context, null until Sema records an @implementation of
// NSConstantString — which a C++ translation unit never does.
CXQualType clang_ASTContext_getObjCConstantStringInterface(CXASTContext Ctx);

// A plain QualType field of the context, null until setObjCNSStringType records one.
CXQualType clang_ASTContext_getObjCNSStringType(CXASTContext Ctx);

void clang_ASTContext_setObjCNSStringType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getObjCIdRedefinitionType(CXASTContext Ctx);

void clang_ASTContext_setObjCIdRedefinitionType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getObjCClassRedefinitionType(CXASTContext Ctx);

void clang_ASTContext_setObjCClassRedefinitionType(CXASTContext Ctx, CXQualType T);

// Falls back to the built-in 'SEL' type when no user redefinition was recorded, which
// lazily materialises the implicit 'SEL' typedef in the translation unit — same shape as
// clang_ASTContext_getObjCIdRedefinitionType above.
CXQualType clang_ASTContext_getObjCSelRedefinitionType(CXASTContext Ctx);

void clang_ASTContext_setObjCSelRedefinitionType(CXASTContext Ctx, CXQualType T);

CXIdentifierInfo clang_ASTContext_getNSObjectName(CXASTContext Ctx);

CXIdentifierInfo clang_ASTContext_getNSCopyingName(CXASTContext Ctx);

CXQualType clang_ASTContext_getNSUIntegerType(CXASTContext Ctx);

CXQualType clang_ASTContext_getNSIntegerType(CXASTContext Ctx);

// getNSUIntegerType
// getNSIntegerType

CXIdentifierInfo clang_ASTContext_getBoolName(CXASTContext Ctx);

CXIdentifierInfo clang_ASTContext_getMakeIntegerSeqName(CXASTContext Ctx);

CXIdentifierInfo clang_ASTContext_getTypePackElementName(CXASTContext Ctx);

CXQualType clang_ASTContext_getObjCInstanceType(CXASTContext Ctx);

CXTypedefDecl clang_ASTContext_getObjCInstanceTypeDecl(CXASTContext Ctx);

void clang_ASTContext_setFILEDecl(CXASTContext Ctx, CXTypeDecl FILEDecl);

CXQualType clang_ASTContext_getFILEType(CXASTContext Ctx);

// The setters behind the three C library types whose getters follow. Sema calls them when a
// typedef literally named jmp_buf/sigjmp_buf/ucontext_t is declared; nothing else populates
// those members, so each getter answers with a null QualType until its setter has run.
void clang_ASTContext_setjmp_bufDecl(CXASTContext Ctx, CXTypeDecl D);

void clang_ASTContext_setsigjmp_bufDecl(CXASTContext Ctx, CXTypeDecl D);

void clang_ASTContext_setucontext_tDecl(CXASTContext Ctx, CXTypeDecl D);

// The three C library types below are null QualTypes until the matching setter has run
// (the decl is looked up by Sema when <setjmp.h>/<ucontext.h> is seen).
CXQualType clang_ASTContext_getjmp_bufType(CXASTContext Ctx);

CXQualType clang_ASTContext_getsigjmp_bufType(CXASTContext Ctx);

CXQualType clang_ASTContext_getucontext_tType(CXASTContext Ctx);

CXQualType clang_ASTContext_getLogicalOperationType(CXASTContext Ctx);

// The Objective-C @encode string of T. The encoder is not ObjC-specific — `int` encodes as
// "i" in a C++ translation unit too.
// PRECONDITION: T must be non-dependent and every record/enum type it reaches must be
// complete (the encoder lays records out eagerly); restated as an @assert in the Julia
// layer.
CXString clang_ASTContext_getObjCEncodingForType(CXASTContext Ctx, CXQualType T);

// The @encode string used for an Objective-C property of type T; differs from
// clang_ASTContext_getObjCEncodingForType only in the encoder options. Same precondition.
CXString clang_ASTContext_getObjCEncodingForPropertyType(CXASTContext Ctx, CXQualType T);

// GCC-compatibility rewrite used by the legacy encoder: a typedef of a 32-bit `long` or
// `unsigned long` comes back as `int`/`unsigned int`, and every other type is returned
// unchanged. The C++ in/out parameter is returned by value here.
CXQualType clang_ASTContext_getLegacyIntegralTypeEncoding(CXASTContext Ctx, CXQualType T);

// The @encode string of D's signature: the return type, then the parameters with their
// byte offsets. Inherits the completeness precondition of getObjCEncodingForType.
CXString clang_ASTContext_getObjCEncodingForFunctionDecl(CXASTContext Ctx,
                                                         CXFunctionDecl D);

// Size of T for @encode purposes, in BYTES: like sizeof, except that integral and
// enumeration types are widened to at least the width of `int`. Inherits the completeness
// precondition above.
int64_t clang_ASTContext_getObjCEncodingTypeSize(CXASTContext Ctx, CXQualType T);

// getObjCEncodingForType
// getObjCEncodingForPropertyType
// getLegacyIntegralTypeEncoding
// getObjCEncodingForTypeQualifier
// getObjCEncodingForFunctionDecl
// getObjCEncodingForMethodDecl
// getObjCEncodingForBlock
// getObjCEncodingForPropertyDecl
// ProtocolCompatibleWithProtocol
// getObjCPropertyImplDeclForPropertyDecl
// getObjCEncodingTypeSize
// getObjCIdDecl
// getObjCIdType
// getObjCSelDecl
// getObjCSelType
// getObjCClassDecl
// getObjCClassType

// The predefined ObjC 'id', 'SEL' and 'Class' typedefs and the types they name. All six are
// lazily materialising: the first call builds the implicit typedef into the translation
// unit (they never return NULL), so they mutate the AST even though they read like getters.
CXTypedefDecl clang_ASTContext_getObjCIdDecl(CXASTContext Ctx);

CXQualType clang_ASTContext_getObjCIdType(CXASTContext Ctx);

CXTypedefDecl clang_ASTContext_getObjCSelDecl(CXASTContext Ctx);

CXQualType clang_ASTContext_getObjCSelType(CXASTContext Ctx);

CXTypedefDecl clang_ASTContext_getObjCClassDecl(CXASTContext Ctx);

CXQualType clang_ASTContext_getObjCClassType(CXASTContext Ctx);
// getObjCProtocolDecl

CXTypedefDecl clang_ASTContext_getBOOLDecl(CXASTContext Ctx);

void clang_ASTContext_setBOOLDecl(CXASTContext Ctx, CXTypedefDecl TD);

CXQualType clang_ASTContext_getBOOLType(CXASTContext Ctx);

CXQualType clang_ASTContext_getObjCProtoType(CXASTContext Ctx);

CXTypedefDecl clang_ASTContext_getBuiltinVaListDecl(CXASTContext Ctx);

CXQualType clang_ASTContext_getBuiltinVaListType(CXASTContext Ctx);

CXDecl clang_ASTContext_getVaListTagDecl(CXASTContext Ctx);

CXTypedefDecl clang_ASTContext_getBuiltinMSVaListDecl(CXASTContext Ctx);

CXQualType clang_ASTContext_getBuiltinMSVaListType(CXASTContext Ctx);

CXTagDecl clang_ASTContext_getMSGuidTagDecl(CXASTContext Ctx);

CXTagType clang_ASTContext_getMSGuidType(CXASTContext Ctx);

bool clang_ASTContext_canBuiltinBeRedeclared(CXASTContext Ctx, CXFunctionDecl D);

CXQualType clang_ASTContext_getCVRQualifiedType(CXASTContext Ctx, CXQualType T,
                                                unsigned CVR);

// getQualifiedType

// PRECONDITIONS: Lifetime must not be CXQualifiers_OCL_None and T must not already carry a
// lifetime — clang asserts both. The gate is clang_QualType_getObjCLifetime; the Julia
// layer restates them.
CXQualType clang_ASTContext_getLifetimeQualifiedType(CXASTContext Ctx, CXQualType T,
                                                     CXQualifiers_ObjCLifetime Lifetime);

// Strips the ObjC lifetime qualifier from an ObjC pointer type; anything else comes back
// unchanged. T must be a non-null QualType (clang dereferences its Type pointer).
CXQualType clang_ASTContext_getUnqualifiedObjCPointerType(CXASTContext Ctx, CXQualType T);

unsigned char clang_ASTContext_getFixedPointScale(CXASTContext Ctx, CXQualType Ty);

unsigned char clang_ASTContext_getFixedPointIBits(CXASTContext Ctx, CXQualType Ty);

// getFixedPointSemantics
// getFixedPointMax
// getFixedPointMin

// The DeclarationNameInfo is returned as an owned box (the class has no opaque encoding);
// release it with clang_DeclarationNameInfo_dispose.
CXDeclarationNameInfo clang_ASTContext_getNameForTemplate(CXASTContext Ctx,
                                                          CXTemplateName Name,
                                                          CXSourceLocation_ NameLoc);

// The UnresolvedSetIterator [First, Last) pair clang wants is built inside the shim from a
// (handle-buffer, count) array of candidates (MARSHALLING.md §11): each entry is added to a
// local UnresolvedSet whose begin()/end() are then passed through. The candidates are
// copied into ASTContext memory, so Decls may be freed right after the call.
// PRECONDITION: NumDecls must be at least 2 — clang asserts the set is overloaded.
// Restated as an @assert in the Julia layer.
CXTemplateName clang_ASTContext_getOverloadedTemplateName(CXASTContext Ctx,
                                                          const CXNamedDecl *Decls,
                                                          unsigned NumDecls);

CXTemplateName clang_ASTContext_getAssumedTemplateName(CXASTContext Ctx,
                                                       CXDeclarationName Name);

// CXTemplateName clang_ASTContext_getQualifiedTemplateName(CXASTContext Ctx,
//                                                          CXNestedNameSpecifier NNS,
//                                                          bool TemplateKeyword,
//                                                          CXTemplateDecl Template);

// The qualified spelling NNS::[template] Template. NNS must be non-null (clang asserts).
CXTemplateName clang_ASTContext_getQualifiedTemplateName(CXASTContext Ctx,
                                                         CXNestedNameSpecifier NNS,
                                                         bool TemplateKeyword,
                                                         CXTemplateName Template);

CXTemplateName clang_ASTContext_getDependentTemplateName(CXASTContext Ctx,
                                                         CXNestedNameSpecifier NNS,
                                                         CXIdentifierInfo Name);

// CXTemplateName clang_ASTContext_getSubstTemplateTemplateParm(
//     CXASTContext Ctx, CXTemplateTemplateParmDecl param, CXTemplateName replacement);

// getSubstTemplateTemplateParmPack

// Same optional-pack-index flattening as clang_ASTContext_getSubstTemplateTypeParmType
// (MARSHALLING.md §8), and the same documented AssociatedDecl/Index precondition.
CXTemplateName
clang_ASTContext_getSubstTemplateTemplateParm(CXASTContext Ctx, CXTemplateName Replacement,
                                              CXDecl AssociatedDecl, unsigned Index,
                                              bool HasPackIndex, unsigned PackIndex);

// PRECONDITION: ArgPack must be a TemplateArgument of kind Pack — the storage reads its
// pack size and element pointer unchecked. Restated as an @assert in the Julia layer.
CXTemplateName clang_ASTContext_getSubstTemplateTemplateParmPack(CXASTContext Ctx,
                                                                 CXTemplateArgument ArgPack,
                                                                 CXDecl AssociatedDecl,
                                                                 unsigned Index,
                                                                 bool Final);
// DecodeTypeStr
// GetBuiltinType

// The type of the builtin with the given ID.
// PRECONDITION: ID must be a builtin ID as reported by clang_IdentifierInfo_getBuiltinID or
// clang_FunctionDecl_getBuiltinID (nonzero) — clang indexes its builtin table with it
// unchecked. Error, which must not be NULL, says why a null QualType came back (a builtin
// whose signature names a type this translation unit has not declared, e.g. FILE).
// IntegerConstantArgs may be NULL; otherwise it receives the bitmask of arguments required
// to be integer constant expressions — the shim zeroes it first because clang only ORs
// bits into it.
CXQualType clang_ASTContext_GetBuiltinType(CXASTContext Ctx, unsigned ID,
                                           CXGetBuiltinTypeError *Error,
                                           unsigned *IntegerConstantArgs);

// Total: the method returns CXQualifiers_GCNone through its own early return whenever the
// translation unit is not Objective-C garbage collected, which is every C/C++ one.
CXQualifiers_GC clang_ASTContext_getObjCGCAttrKind(CXASTContext Ctx, CXQualType Ty);

bool clang_ASTContext_areCompatibleVectorTypes(CXASTContext Ctx, CXQualType FirstVec,
                                               CXQualType SecondVec);

bool clang_ASTContext_areCompatibleSveTypes(CXASTContext Ctx, CXQualType FirstVec,
                                            CXQualType SecondVec);

bool clang_ASTContext_areLaxCompatibleSveTypes(CXASTContext Ctx, CXQualType FirstVec,
                                               CXQualType SecondVec);

bool clang_ASTContext_areCompatibleRVVTypes(CXASTContext Ctx, CXQualType FirstType,
                                            CXQualType SecondType);

bool clang_ASTContext_areLaxCompatibleRVVTypes(CXASTContext Ctx, CXQualType FirstType,
                                               CXQualType SecondType);

bool clang_ASTContext_hasDirectOwnershipQualifier(CXASTContext Ctx, CXQualType Ty);

// Static — no receiver. True when Ty is a typedef of an Objective-C object pointer
// (NSObject and friends); always false in a C++ translation unit.
// PRECONDITION: Ty must be a non-null QualType (clang reaches through its Type pointer);
// restated as an @assert in the Julia layer.
bool clang_ASTContext_isObjCNSObjectType(CXQualType Ty);

// isObjCNSObjectType
// getFloatTypeSemantics

// helper — a floating-point type's llvm::fltSemantics crosses as its parts (MARSHALLING.md
// §7): the mantissa precision, and the total width of the format, both in bits.
// PRECONDITION for both: T must be a real (non-complex) floating builtin type — clang
// castAs<BuiltinType>()s it and llvm_unreachable()s on every other kind; restated as an
// @assert in the Julia layer.
unsigned clang_ASTContext_getFloatTypeSemanticsPrecision(CXASTContext Ctx, CXQualType T);

unsigned clang_ASTContext_getFloatTypeSemanticsSizeInBits(CXASTContext Ctx, CXQualType T);
// getTypeInfo

unsigned clang_ASTContext_getOpenMPDefaultSimdAlign(CXASTContext Ctx, CXQualType T);

uint64_t clang_ASTContext_getTypeSize(CXASTContext Ctx, CXQualType T);

uint64_t clang_ASTContext_getCharWidth(CXASTContext Ctx);

// toCharUnitsFromBits
// toBits
// getTypeSizeInChars
// getTypeSizeInCharsIfKnown

uint64_t clang_ASTContext_getSizeOf(CXASTContext Ctx, CXQualType T);

unsigned clang_ASTContext_getTypeAlign(CXASTContext Ctx, CXQualType T);

unsigned clang_ASTContext_getTypeUnadjustedAlign(CXASTContext Ctx, CXQualType T);

unsigned clang_ASTContext_getTypeAlignIfKnown(CXASTContext Ctx, CXQualType T,
                                              bool NeedsPreferredAlignment);

// getTypeAlignInChars
// getPreferredTypeAlignInChars
// getTypeUnadjustedAlignInChars
// getTypeInfoDataSizeInChars
// getTypeInfoInChars

bool clang_ASTContext_isAlignmentRequired(CXASTContext Ctx, CXQualType T);

unsigned clang_ASTContext_getPreferredTypeAlign(CXASTContext Ctx, CXQualType T);

unsigned clang_ASTContext_getTargetDefaultAlignForAttributeAligned(CXASTContext Ctx);

unsigned clang_ASTContext_getAlignOfGlobalVar(CXASTContext Ctx, CXQualType T);

// TypeInfo / TypeInfoChars cross as out-params (MARSHALLING.md §7). getTypeInfo
// reports BITS; every other quantity below is a CharUnits value in BYTES.
// PRECONDITION for this whole family, restated as an @assert in the Julia layer:
// T must not be a dependent type (ASTContext::getTypeInfoImpl is llvm_unreachable
// on those) and record/enum types must be complete, because the query lays the
// record out eagerly. The shim checks neither, by contract.
void clang_ASTContext_getTypeInfo(CXASTContext Ctx, CXQualType T, uint64_t *Width,
                                  unsigned *Align,
                                  CXAlignRequirementKind *AlignRequirement);

void clang_ASTContext_getTypeInfoInChars(CXASTContext Ctx, CXQualType T,
                                         int64_t *Width, int64_t *Align,
                                         CXAlignRequirementKind *AlignRequirement);

int64_t clang_ASTContext_getTypeSizeInChars(CXASTContext Ctx, CXQualType T);

int64_t clang_ASTContext_getTypeAlignInChars(CXASTContext Ctx, CXQualType T);

int64_t clang_ASTContext_getPreferredTypeAlignInChars(CXASTContext Ctx, CXQualType T);

int64_t clang_ASTContext_getTypeUnadjustedAlignInChars(CXASTContext Ctx, CXQualType T);

// Returns false and leaves *Size untouched when the size is not known — T incomplete or
// dependent (MARSHALLING.md §8). Unlike the rest of this family it is total.
bool clang_ASTContext_getTypeSizeInCharsIfKnown(CXASTContext Ctx, CXQualType T,
                                                int64_t *Size);

// Data size in BYTES (a record's tail padding is excluded) instead of sizeof; inherits
// the completeness/non-dependence precondition of the getTypeInfo family above.
void clang_ASTContext_getTypeInfoDataSizeInChars(CXASTContext Ctx, CXQualType T,
                                                 int64_t *Width, int64_t *Align,
                                                 CXAlignRequirementKind *AlignRequirement);

int64_t clang_ASTContext_toCharUnitsFromBits(CXASTContext Ctx, int64_t BitSize);

int64_t clang_ASTContext_toBits(CXASTContext Ctx, int64_t CharSize);

// ForAlignof selects alignof() semantics over the ABI alignment. Routes through
// getTypeInfo, so it inherits the completeness precondition above.
int64_t clang_ASTContext_getDeclAlign(CXASTContext Ctx, CXDecl D, bool ForAlignof);

int64_t clang_ASTContext_getAlignOfGlobalVarInChars(CXASTContext Ctx, CXQualType T);

int64_t clang_ASTContext_getExnObjectAlignment(CXASTContext Ctx);

// getAlignOfGlobalVarInChars
// getDeclAlign
// getExnObjectAlignment

// Borrowed, ASTContext-arena owned — no dispose. Precondition (checked by the
// Julia layer, per the axiom): `RD` has a complete definition.
CXASTRecordLayout clang_ASTContext_getASTRecordLayout(CXASTContext Ctx, CXRecordDecl RD);
// getASTObjCInterfaceLayout

// The layout dump clang writes to a raw_ostream, returned as a CXString (MARSHALLING.md
// §5). Simple selects the one-line form. PRECONDITION: RD has a complete definition —
// clang asserts it through getASTRecordLayout; restated as an @assert in the Julia layer.
CXString clang_ASTContext_DumpRecordLayout(CXASTContext Ctx, CXRecordDecl RD, bool Simple);
// getASTObjCImplementationLayout

// Partial (the Julia wrapper restates the precondition): clang asserts RD has a
// definition. NULL when the class has no key function.
CXCXXMethodDecl clang_ASTContext_getCurrentKeyFunction(CXASTContext Ctx,
                                                       CXCXXRecordDecl RD);
// setNonKeyFunction
// getOffsetOfBaseWithVBPtr

uint64_t clang_ASTContext_getFieldOffset(CXASTContext Ctx, CXValueDecl FD);

// lookupFieldBitOffset

// The `this` adjustment a member pointer's inheritance path implies, in bytes (the
// CharUnits convention of the ASTRecordLayout family). PRECONDITION: MP must hold a
// member pointer — APValue's accessor asserts on the kind; restated as an @assert in
// the Julia layer.
int64_t clang_ASTContext_getMemberPointerPathAdjustment(CXASTContext Ctx, CXAPValue MP);

bool clang_ASTContext_isNearlyEmpty(CXASTContext Ctx, CXCXXRecordDecl RD);

// getVTableContext

CXMangleContext clang_ASTContext_createMangleContext(CXASTContext Ctx, CXTargetInfo_ T);

// PRECONDITION: T's C++ ABI must not be Microsoft — clang asserts it and the mangler
// switch has no Microsoft arm. Restated as an @assert in the Julia layer.
// Caller-owned heap object with no dispose entry point (the same known leak as
// clang_ASTContext_createMangleContext).
CXMangleContext clang_ASTContext_createDeviceMangleContext(CXASTContext Ctx,
                                                           CXTargetInfo_ T);

// DeepCollectObjCIvars
// CountNonClassIvars
// CollectInheritedProtocols

bool clang_ASTContext_hasUniqueObjectRepresentations(CXASTContext Ctx, CXQualType Ty);


CXQualType clang_ASTContext_getCanonicalType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getCanonicalParamType(CXASTContext Ctx, CXQualType T);

bool clang_ASTContext_hasSameType(CXASTContext Ctx, CXQualType T1, CXQualType T2);

bool clang_ASTContext_hasSameExpr(CXASTContext Ctx, CXExpr X, CXExpr Y);

// getUnqualifiedArrayType

bool clang_ASTContext_hasSameUnqualifiedType(CXASTContext Ctx, CXQualType T1,
                                             CXQualType T2);

bool clang_ASTContext_hasSameNullabilityTypeQualifier(CXASTContext Ctx, CXQualType SubT,
                                                      CXQualType SuperT, bool IsParam);

// ObjCMethodsAreEqual
// UnwrapSimilarTypes
// UnwrapSimilarArrayTypes

// T1 and T2 are in/out: the C++ methods take them by reference and rewrite them to the
// unwrapped pointee/element types, so they cross as pointers to the QualType opaque
// encodings (MARSHALLING.md §7). UnwrapSimilarTypes reports whether a layer was peeled.
bool clang_ASTContext_UnwrapSimilarTypes(CXASTContext Ctx, CXQualType *T1, CXQualType *T2,
                                         bool AllowPiMismatch);

void clang_ASTContext_UnwrapSimilarArrayTypes(CXASTContext Ctx, CXQualType *T1,
                                              CXQualType *T2, bool AllowPiMismatch);

bool clang_ASTContext_hasSimilarType(CXASTContext Ctx, CXQualType T1, CXQualType T2);

bool clang_ASTContext_hasCvrSimilarType(CXASTContext Ctx, CXQualType T1, CXQualType T2);

CXNestedNameSpecifier
clang_ASTContext_getCanonicalNestedNameSpecifier(CXASTContext Ctx,
                                                 CXNestedNameSpecifier NNS);


CXCallingConv_ clang_ASTContext_getDefaultCallingConvention(CXASTContext Ctx,
                                                            bool IsVariadic,
                                                            bool IsCXXMethod,
                                                            bool IsBuiltin);

CXTemplateName clang_ASTContext_getCanonicalTemplateName(CXASTContext Ctx,
                                                         CXTemplateName TemplateName);

bool clang_ASTContext_hasSameTempalteName(CXASTContext Ctx, CXTemplateName T1,
                                          CXTemplateName T2);

bool clang_ASTContext_isSameEntity(CXASTContext Ctx, CXNamedDecl X, CXNamedDecl Y);

bool clang_ASTContext_isSameTemplateParameterList(CXASTContext Ctx,
                                                  CXTemplateParameterList X,
                                                  CXTemplateParameterList Y);

bool clang_ASTContext_isSameTemplateParameter(CXASTContext Ctx, CXNamedDecl X,
                                              CXNamedDecl Y);

bool clang_ASTContext_isSameConstraintExpr(CXASTContext Ctx, CXExpr XCE, CXExpr YCE);

// isSameTypeConstraint

// PRECONDITION: X and Y must have the same Decl kind (clang asserts it); restated as an
// @assert in the Julia layer.
bool clang_ASTContext_isSameDefaultTemplateArgument(CXASTContext Ctx, CXNamedDecl X,
                                                    CXNamedDecl Y);


// The TemplateArgument is returned as an owned box (it has no pointer encoding); release
// it with clang_TemplateArgument_dispose.
CXTemplateArgument clang_ASTContext_getCanonicalTemplateArgument(CXASTContext Ctx,
                                                                 CXTemplateArgument Arg);

CXArrayType clang_ASTContext_getAsArrayType(CXASTContext Ctx, CXQualType T);

CXConstantArrayType clang_ASTContext_getAsConstantArrayType(CXASTContext Ctx, CXQualType T);

CXVariableArrayType clang_ASTContext_getAsVariableArrayType(CXASTContext Ctx, CXQualType T);

CXIncompleteArrayType clang_ASTContext_getAsIncompleteArrayType(CXASTContext Ctx,
                                                                CXQualType T);

CXDependentSizedArrayType clang_ASTContext_getAsDependentSizedArrayType(CXASTContext Ctx,
                                                                        CXQualType T);

// CXQualType clang_ASTContext_getBaseElementType(CXASTContext Ctx, CXArrayType VAT);
//   return static_cast<clang::ASTContext *>(Ctx)
//       ->getBaseElementType(static_cast<clang::ArrayType *>(VAT))
//       .getAsOpaquePtr();
// }

CXQualType clang_ASTContext_getBaseElementType(CXASTContext Ctx, CXQualType QT);

uint64_t clang_ASTContext_getConstantArrayElementCount(CXASTContext Ctx,
                                                       CXConstantArrayType CAT);

// The number of elements the implicit initialization loop AILE covers — the loop clang
// synthesizes for array copy-initialization and for array captures of a lambda.
uint64_t clang_ASTContext_getArrayInitLoopExprElementCount(CXASTContext Ctx,
                                                           CXArrayInitLoopExpr AILE);

CXQualType clang_ASTContext_getAdjustedParameterType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getSignatureParameterType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getExceptionObjectType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getArrayDecayedType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getPromotedIntegerType(CXASTContext Ctx, CXQualType T);


// Walks pointer/array/reference layers down to the first retainable type and reports its
// ARC lifetime; CXQualifiers_OCL_None when there is none. Total.
CXQualifiers_ObjCLifetime clang_ASTContext_getInnerObjCOwnership(CXASTContext Ctx,
                                                                 CXQualType T);

CXQualType clang_ASTContext_isPromotableBitField(CXASTContext Ctx, CXExpr E);

int clang_ASTContext_getIntegerTypeOrder(CXASTContext Ctx, CXQualType LHS, CXQualType RHS);

int clang_ASTContext_getFloatingTypeOrder(CXASTContext Ctx, CXQualType LHS, CXQualType RHS);

int clang_ASTContext_getFloatingTypeSemanticOrder(CXASTContext Ctx, CXQualType LHS,
                                                  CXQualType RHS);

// CXQualType clang_ASTContext_getFloatingTypeOfSizeWithinDomain(CXASTContext Ctx,
//                                                               CXQualType typeSize,
//                                                               CXQualType typeDomain);

// unsigned clang_ASTContext_getTargetAddressSpace(CXASTContext Ctx, CXQualType T);

unsigned clang_ASTContext_getTargetAddressSpace(CXASTContext Ctx, CXLangAS AS);


CXLangAS clang_ASTContext_getLangASForBuiltinAddressSpace(CXASTContext Ctx, unsigned AS);

uint64_t clang_ASTContext_getTargetNullPointerValue(CXASTContext Ctx, CXQualType T);

// clang_ASTContext_addressSpaceMapManglingFor

bool clang_ASTContext_addressSpaceMapManglingFor(CXASTContext Ctx, CXLangAS AS);

// mergeExceptionSpecs

// Partial (the Julia wrapper restates the precondition): X and Y must be the same
// type — the same unqualified type when Unqualified is true.
CXQualType clang_ASTContext_getCommonSugaredType(CXASTContext Ctx, CXQualType X,
                                                 CXQualType Y, bool Unqualified);

bool clang_ASTContext_typesAreCompatible(CXASTContext Ctx, CXQualType T1, CXQualType T2,
                                         bool CompareUnqualified);

bool clang_ASTContext_propertyTypesAreCompatible(CXASTContext Ctx, CXQualType T1,
                                                 CXQualType T2);

bool clang_ASTContext_typesAreBlockPointerCompatible(CXASTContext Ctx, CXQualType T1,
                                                     CXQualType T2);

// isObjCIdType
// isObjCClassType
// isObjCSelType

// Compare T (looking through one ElaboratedType) against this context's predefined 'id',
// 'Class' and 'SEL' types, materialising those typedefs on first use like the getters
// above. T must be a non-null QualType (clang dyn_casts through its Type pointer).
bool clang_ASTContext_isObjCIdType(CXASTContext Ctx, CXQualType T);

bool clang_ASTContext_isObjCClassType(CXASTContext Ctx, CXQualType T);

bool clang_ASTContext_isObjCSelType(CXASTContext Ctx, CXQualType T);

// True when both types are Objective-C object pointers assignable in either direction.
// Total — a non-ObjC operand simply yields false.
bool clang_ASTContext_areComparableObjCPointerTypes(CXASTContext Ctx, CXQualType LHS,
                                                    CXQualType RHS);
// ObjCQualifiedIdTypesAreCompatible
// ObjCQualifiedClassTypesAreCompatible
// canAssignObjCInterfaces
// canAssignObjCInterfacesInBlockPointer
// areComparableObjCPointerTypes
// canBindObjCObjectType

CXQualType clang_ASTContext_mergeTypes(CXASTContext Ctx, CXQualType T1, CXQualType T2,
                                       bool OfBlockPointer, bool Unqualified,
                                       bool BlockReturnType);

CXQualType clang_ASTContext_mergeFunctionTypes(CXASTContext Ctx, CXQualType T1,
                                               CXQualType T2, bool OfBlockPointer,
                                               bool Unqualified, bool AllowCXX);

CXQualType clang_ASTContext_mergeFunctionParameterTypes(CXASTContext Ctx, CXQualType T1,
                                                        CXQualType T2, bool OfBlockPointer,
                                                        bool Unqualified);

CXQualType clang_ASTContext_mergeTransparentUnionType(CXASTContext Ctx, CXQualType T1,
                                                      CXQualType T2, bool OfBlockPointer,
                                                      bool Unqualified);

CXQualType clang_ASTContext_mergeObjCGCQualifiers(CXASTContext Ctx, CXQualType T1,
                                                  CXQualType T2);

// mergeExtParameterInfo
// ResetObjCLayout

unsigned clang_ASTContext_getIntWidth(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getCorrespondingUnsignedType(CXASTContext Ctx, CXQualType T);

// Partial (the Julia wrapper restates the precondition): T must be an unsigned
// integer type or an unsigned fixed-point type.
CXQualType clang_ASTContext_getCorrespondingSignedType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getCorrespondingSaturatedType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getCorrespondingSignedFixedPointType(CXASTContext Ctx,
                                                                 CXQualType T);

CXIdentifierTable clang_ASTContext_getIdents(CXASTContext Ctx);


// Value as an APSInt of Type's width and signedness, boxed in a caller-owned
// LLVMGenericValueRef (APSInt in GV->IntVal, released via llvm-c). See MARSHALLING.md §1.
// PRECONDITION: Type must be a complete integral or enumeration type — getIntWidth
// reaches getTypeSize, which asserts otherwise; restated as an @assert in the Julia layer.
LLVMGenericValueRef clang_ASTContext_MakeIntValue(CXASTContext Ctx, uint64_t Value,
                                                  CXQualType Type);

bool clang_ASTContext_isSentinelNullExpr(CXASTContext Ctx, CXExpr E);

// True when the translation unit contains at least one Objective-C @implementation.
bool clang_ASTContext_AnyObjCImplementation(CXASTContext Ctx);

// getObjCImplementation
// AnyObjCImplementation
// setObjCImplementation
// getObjCMethodRedeclaration
// setObjCMethodRedeclaration
// getObjContainingInterface

// Records CopyExpr as the expression that copies the __block variable VD into an escaping
// block, and whether that copy can throw — the write half of
// clang_ASTContext_getBlockVarCopyInit. The record is kept in a side table keyed on VD;
// neither handle is adopted, and CopyExpr must outlive the context's use of it (an
// AST-arena expression does).
// PRECONDITION: VD carries the Blocks attribute — the same gate the getter documents. The
// symmetric reading of clang's own API; ASTContext.cpp does not ship in the pinned
// artifact, so the assert text could not be read.
void clang_ASTContext_setBlockVarCopyInit(CXASTContext Ctx, CXVarDecl VD, CXExpr CopyExpr,
                                          bool CanThrow);

// The copy-initialization record clang recorded for the __block variable VD: the expression
// that copies it into an escaping block plus whether that copy can throw. A variable with no
// entry -- a scalar __block variable, or one no escaping block captures -- yields a
// default-constructed record whose clang_BlockVarCopyInit_getCopyExpr is NULL.
// PRECONDITION: VD carries the Blocks attribute. ASTContext.cpp does not ship in the pinned
// artifact, so the assert could not be read; the gate is the conservative reading of clang's
// symmetric API.
// The returned record is a heap-boxed copy of a by-value value: release it with
// clang_BlockVarCopyInit_dispose. The Expr inside it is AST-owned and outlives the box.
CXBlockVarCopyInit clang_ASTContext_getBlockVarCopyInit(CXASTContext Ctx, CXVarDecl VD);

CXTypeSourceInfo clang_ASTContext_CreateTypeSourceInfo(CXASTContext Ctx, CXQualType T,
                                                       unsigned Size);

CXTypeSourceInfo clang_ASTContext_getTrivialTypeSourceInfo(CXASTContext Ctx, CXQualType T,
                                                           CXSourceLocation_ Loc);

// AddDeallocation
// addDestruction

CXGVALinkage clang_ASTContext_GetGVALinkageForFunction(CXASTContext Ctx, CXFunctionDecl FD);

CXGVALinkage clang_ASTContext_GetGVALinkageForVariable(CXASTContext Ctx, CXVarDecl VD);

bool clang_ASTContext_DeclMustBeEmitted(CXASTContext Ctx, CXDecl D);

CXCXXConstructorDecl
clang_ASTContext_getCopyConstructorForExceptionObject(CXASTContext Ctx, CXCXXRecordDecl RD);

void clang_ASTContext_addCopyConstructorForExceptionObject(CXASTContext Ctx,
                                                           CXCXXRecordDecl RD,
                                                           CXCXXConstructorDecl CD);

void clang_ASTContext_addTypedefNameForUnnamedTagDecl(CXASTContext Ctx, CXTagDecl TD,
                                                      CXTypedefNameDecl TND);

CXTypedefNameDecl clang_ASTContext_getTypedefNameForUnnamedTagDecl(CXASTContext Ctx,
                                                                   CXTagDecl TD);

void clang_ASTContext_addDeclaratorForUnnamedTagDecl(CXASTContext Ctx, CXTagDecl TD,
                                                     CXDeclaratorDecl D);

CXDeclaratorDecl clang_ASTContext_getDeclaratorForUnnamedTagDecl(CXASTContext Ctx,
                                                                 CXTagDecl TD);

void clang_ASTContext_setManglingNumber(CXASTContext Ctx, CXNamedDecl ND, unsigned Number);

unsigned clang_ASTContext_getManglingNumber(CXASTContext Ctx, CXNamedDecl ND);

void clang_ASTContext_setStaticLocalNumber(CXASTContext Ctx, CXVarDecl ND, unsigned Number);

unsigned clang_ASTContext_getStaticLocalNumber(CXASTContext Ctx, CXVarDecl ND);

// getManglingNumberContext
// createMangleNumberingContext

void clang_ASTContext_setParameterIndex(CXASTContext Ctx, CXParmVarDecl D, unsigned index);

unsigned clang_ASTContext_getParameterIndex(CXASTContext Ctx, CXParmVarDecl D);

CXStringLiteral clang_ASTContext_getPredefinedStringLiteralFromCache(CXASTContext Ctx,
                                                                     const char *Key);

// getMSGuidDecl
// getTemplateParamObjectDecl

// The global GUID object for a GUID value, uniqued on the value — the declaration a
// __uuidof expression designates. MSGuidDeclParts is flattened to its fields
// (MARSHALLING.md §7); Part4And5 points at 8 bytes, copied inside the shim.
// PRECONDITION: the translation unit must carry the implicit `_GUID` record, which clang
// builds only under Microsoft extensions — this entry point reaches through it unchecked.
// The gate is clang_ASTContext_getMSGuidTagDecl; the Julia layer restates it.
CXMSGuidDecl clang_ASTContext_getMSGuidDecl(CXASTContext Ctx, uint32_t Part1,
                                            uint16_t Part2, uint16_t Part3,
                                            const uint8_t *Part4And5);

// The uniqued anonymous global constant of type Ty holding Value. Total. The declaration is
// ASTContext-arena memory (no dispose) and joins no DeclContext's lookup table.
CXUnnamedGlobalConstantDecl clang_ASTContext_getUnnamedGlobalConstantDecl(CXASTContext Ctx,
                                                                          CXQualType Ty,
                                                                          CXAPValue Value);

// The template parameter object of type T holding V — the static storage duration object a
// class-type non-type template argument denotes. Uniqued on the (type, value) pair.
// PRECONDITION: T must be a record type; clang asserts it. Restated as an @assert in the
// Julia layer.
CXTemplateParamObjectDecl
clang_ASTContext_getTemplateParamObjectDecl(CXASTContext Ctx, CXQualType T, CXAPValue V);

// helper — how many feature names survive parsing TD against this context's target: the
// `target(...)` spelling split on commas, minus the arch=/tune=/branch-protection=
// components, minus every name the target rejects. ParsedTargetAttr is a by-value aggregate
// holding a std::vector<std::string> whose storage dies with the call, so it crosses as its
// parts (MARSHALLING.md §7) with the parse rebuilt on every call (§10, the same scheme as
// clang_ASTContext_getNumFunctionFeatures): no StringRef escapes and the shim stays
// stateless. The parse is a pure function of TD's spelling and the target, so index I names
// the same feature in both functions.
// This is what the attribute ASKED for, not what the target resolved it to — the resolved
// map, with implied features expanded, is clang_ASTContext_getNumFunctionFeatures.
unsigned clang_ASTContext_getNumFilteredFunctionTargetFeatures(CXASTContext Ctx,
                                                               CXTargetAttr TD);

// PRECONDITION: I < clang_ASTContext_getNumFilteredFunctionTargetFeatures(Ctx, TD),
// restated as an @assert in the Julia layer. Out of range the shim answers the empty string
// rather than indexing a std::vector past its end, which aborts outright under mingw's
// assertion-enabled libstdc++ (MARSHALLING.md §13). The name keeps clang's leading '+'/'-'
// sign, so a `no-sse3` component comes back as "-sse3". The CXString is caller-owned.
CXString clang_ASTContext_getFilteredFunctionTargetFeature(CXASTContext Ctx,
                                                           CXTargetAttr TD, unsigned I);

// The `arch=` and `tune=` spellings TD named, or an empty string when it named neither.
CXString clang_ASTContext_getFilteredFunctionTargetCPU(CXASTContext Ctx, CXTargetAttr TD);
CXString clang_ASTContext_getFilteredFunctionTargetTune(CXASTContext Ctx, CXTargetAttr TD);

// filterFunctionTargetVersionAttrs
// getFunctionFeatureMap

// helper — the size of the target feature map clang computes for FD (the target's baseline
// features adjusted by FD's own target/target_clones attributes). clang builds the map into
// an llvm::StringMap whose key storage dies with the call, so the map crosses as a count
// plus an indexed accessor (MARSHALLING.md §6) and the shim rebuilds it on every call: no
// StringRef escapes and the shim stays stateless. A StringMap's iteration order is a pure
// function of its insertion sequence, which is the same on every rebuild, so index I names
// the same feature in both functions.
unsigned clang_ASTContext_getNumFunctionFeatures(CXASTContext Ctx, CXFunctionDecl FD);

// helper — the I-th entry of that map: the feature name is the return value and
// *IsEnabled receives its flag.
// PRECONDITION: I < clang_ASTContext_getNumFunctionFeatures(Ctx, FD) — the index is
// unchecked; restated as an @assert in the Julia layer. The CXString is caller-owned.
CXString clang_ASTContext_getFunctionFeature(CXASTContext Ctx, CXFunctionDecl FD,
                                             unsigned I, bool *IsEnabled);

void clang_ASTContext_InitBuiltinTypes(CXASTContext Ctx, CXTargetInfo_ Target,
                                       CXTargetInfo_ AuxTarget);

// getObjCEncodingForMethodParameter

bool clang_ASTContext_isMSStaticDataMemberInlineDefinition(CXASTContext Ctx, CXVarDecl VD);

CXInlineVariableDefinitionKind
clang_ASTContext_getInlineVariableDefinitionKind(CXASTContext Ctx, CXVarDecl VD);

// bool clang_ASTContext_mayExternalizeStaticVar(CXASTContext Ctx, CXDecl D);

// bool clang_ASTContext_shouldExternalizeStaticVar(CXASTContext Ctx, CXDecl D);

bool clang_ASTContext_mayExternalize(CXASTContext Ctx, CXDecl D);

bool clang_ASTContext_shouldExternalize(CXASTContext Ctx, CXDecl D);

// Hash of the CUDA/HIP compilation-unit ID; the empty string when -fcuid was not
// given.
CXString clang_ASTContext_getCUIDHash(CXASTContext Ctx);

// Builtin Types
CXQualType clang_ASTContext_VoidTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_BoolTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_CharTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_WCharTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_WideCharTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_WIntTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_Char8Ty_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_Char16Ty_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_Char32Ty_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_SignedCharTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_ShortTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_IntTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_LongTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_LongLongTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_Int128Ty_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_UnsignedCharTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_UnsignedShortTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_UnsignedIntTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_UnsignedLongTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_UnsignedLongLongTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_UnsignedInt128Ty_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_FloatTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_DoubleTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_LongDoubleTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_Float128Ty_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_HalfTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_BFloat16Ty_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_Float16Ty_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_VoidPtrTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_NullPtrTy_getAsQualType(CXASTContext Ctx);

// Whether this context admits dependent types at all, i.e. `LangOpts.CPlusPlus ||
// LangOpts.RecoveryAST`. A property of the language mode the context was built with, not of
// the host, so it is an equality on every target.
bool clang_ASTContext_isDependenceAllowed(CXASTContext Ctx);

// Whether two template names denote the same template, comparing through the sugar that
// `==` on the handles cannot see: X and Y may be a QualifiedTemplateName and the underlying
// TemplateDecl, or two substitutions reaching the same declaration. Equivalent to comparing
// clang_ASTContext_getCanonicalTemplateName of each, and clang implements it that way for
// the simple cases while also handling the dependent ones.
bool clang_ASTContext_hasSameTemplateName(CXASTContext Ctx, CXTemplateName X,
                                          CXTemplateName Y);

LLVM_CLANG_C_EXTERN_C_END

#endif
