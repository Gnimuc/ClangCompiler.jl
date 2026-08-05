#ifndef LLVM_CLANG_C_EXTRA_CXSCOPE_H
#define LLVM_CLANG_C_EXTRA_CXSCOPE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-c/CXString.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

void clang_Scope_dump(CXScope S);

CXScope clang_Scope_getParent(CXScope S);

unsigned clang_Scope_getDepth(CXScope S);

unsigned clang_Scope_getFlags(CXScope S);

// Closest enclosing scope that is a function body; null at file scope.
CXScope clang_Scope_getFnParent(CXScope S);

// Scope::getEntity returns null for a template parameter scope even when the scope
// does have an entity; use clang_Scope_isTemplateParamScope to tell the two apart.
CXDeclContext clang_Scope_getEntity(CXScope S);

bool clang_Scope_isTemplateParamScope(CXScope S);

bool clang_Scope_isDeclScope(CXScope S, CXDecl D);

bool clang_Scope_isBlockScope(CXScope S);

// Closest scope a `continue` statement would be affected by; null if there is none.
CXScope clang_Scope_getContinueParent(CXScope S);

// Closest scope a `break` statement would be affected by; null if there is none.
CXScope clang_Scope_getBreakParent(CXScope S);

// Immediately containing block (closure) scope; null if there is none.
CXScope clang_Scope_getBlockParent(CXScope S);

// Immediately containing template parameter scope; null if there is none.
CXScope clang_Scope_getTemplateParamParent(CXScope S);

unsigned clang_Scope_getFunctionPrototypeDepth(CXScope S);

// decls: two-call protocol (DeclsInScope is a SmallPtrSet, i.e. forward-only).
// getNumDecls counts; getDecls fills a caller buffer of exactly that size. The
// order is the set's own iteration order -- it carries no meaning, but it is the
// same for both calls as long as the scope is not mutated in between.
unsigned clang_Scope_getNumDecls(CXScope S);

void clang_Scope_getDecls(CXScope S, CXDecl *Buf);

bool clang_Scope_decl_empty(CXScope S);

// The DeclContext unqualified lookup continues in after this scope. Unlike
// clang_Scope_getEntity this reports the entity of a template parameter scope too.
CXDeclContext clang_Scope_getLookupEntity(CXScope S);

bool clang_Scope_isFunctionScope(CXScope S);

bool clang_Scope_isClassScope(CXScope S);

// Walks the parent chain looking for a function prototype scope.
bool clang_Scope_containedInPrototypeScope(CXScope S);

// Statement-kind and error-state predicates. Each is a flag test on the scope's own
// flag word except where noted; none of them mutate the scope.
bool clang_Scope_isConditionVarScope(CXScope S);

// Reads the scope's DiagnosticErrorTrap, which every Scope constructor initialises from
// the DiagnosticsEngine, so this is defined on any scope.
bool clang_Scope_hasUnrecoverableErrorOccurred(CXScope S);

bool clang_Scope_isClassInheritanceScope(CXScope S);

// Answers through the enclosing function scope: false outright when there is none,
// otherwise Scope::isInCXXInlineMethodScope asserts that function scope has a parent.
bool clang_Scope_isInCXXInlineMethodScope(CXScope S);

bool clang_Scope_isFunctionPrototypeScope(CXScope S);

bool clang_Scope_isFunctionDeclarationScope(CXScope S);

bool clang_Scope_isCatchScope(CXScope S);

// Walks the parent chain, stopping at the first function, class, block, template
// parameter or prototype boundary.
bool clang_Scope_isSwitchScope(CXScope S);

bool clang_Scope_isContinueScope(CXScope S);

bool clang_Scope_isTryScope(CXScope S);

bool clang_Scope_isCompoundStmtScope(CXScope S);

bool clang_Scope_isControlScope(CXScope S);

// Scope (Microsoft mangling numbers, ObjC/OpenMP/SEH scope kinds, using-directives)
// Innermost enclosing scope that takes part in Microsoft mangling numbering; null when
// there is none.
CXScope clang_Scope_getMSLastManglingParent(CXScope S);

// The mangling number held by the mangling parent, or 1 when there is no such parent.
unsigned clang_Scope_getMSLastManglingNumber(CXScope S);

unsigned clang_Scope_getMSCurManglingNumber(CXScope S);

// Walks the parent chain; not constant time.
bool clang_Scope_isInObjcMethodScope(CXScope S);

bool clang_Scope_isInObjcMethodOuterScope(CXScope S);

// The Objective-C @catch clause; the C++ one is clang_Scope_isCatchScope.
bool clang_Scope_isAtCatchScope(CXScope S);

bool clang_Scope_isOpenMPDirectiveScope(CXScope S);

// Asserts that a scope carrying the loop-directive flag also carries the plain directive
// flag. The parser never builds the other combination, so this is an internal consistency
// check rather than a caller precondition.
bool clang_Scope_isOpenMPLoopDirectiveScope(CXScope S);

bool clang_Scope_isOpenMPSimdDirectiveScope(CXScope S);

// Answers through the parent scope; false outright when there is no parent.
bool clang_Scope_isOpenMPLoopScope(CXScope S);

bool clang_Scope_isOpenMPOrderClauseScope(CXScope S);

bool clang_Scope_isFnTryCatchScope(CXScope S);

bool clang_Scope_isSEHTryScope(CXScope S);

bool clang_Scope_isSEHExceptScope(CXScope S);

// Compares scope depths only, so it is meaningful just when one of the two scopes is an
// ancestor of the other -- clang's own doc comment makes that the caller's responsibility.
bool clang_Scope_Contains(CXScope S, CXScope RHS);

// using_directives: count + index pair. Scope keeps the directives in a SmallVector, so
// indexing is O(1); the order is the order the parser pushed them in.
unsigned clang_Scope_getNumUsingDirectives(CXScope S);

// Precondition: I < clang_Scope_getNumUsingDirectives(S).
CXUsingDirectiveDecl clang_Scope_getUsingDirective(CXScope S, unsigned I);

// Scope::dumpImpl rendered into a string instead of into a raw_ostream.
CXString clang_Scope_dumpImplToString(CXScope S);

// Scope (construction and mutation)
// Mirrors clang::Scope::ScopeFlags (class-local enum; synced in lib/Basic/CXEnumSync.cpp).
// The enumerators are bit flags meant to be OR-ed together, so every flag-word parameter
// below is a plain unsigned rather than this enum type.
typedef enum CXScopeFlags {
  CXScopeFlags_FnScope = 0x01,
  CXScopeFlags_BreakScope = 0x02,
  CXScopeFlags_ContinueScope = 0x04,
  CXScopeFlags_DeclScope = 0x08,
  CXScopeFlags_ControlScope = 0x10,
  CXScopeFlags_ClassScope = 0x20,
  CXScopeFlags_BlockScope = 0x40,
  CXScopeFlags_TemplateParamScope = 0x80,
  CXScopeFlags_FunctionPrototypeScope = 0x100,
  CXScopeFlags_FunctionDeclarationScope = 0x200,
  CXScopeFlags_AtCatchScope = 0x400,
  CXScopeFlags_ObjCMethodScope = 0x800,
  CXScopeFlags_SwitchScope = 0x1000,
  CXScopeFlags_TryScope = 0x2000,
  CXScopeFlags_FnTryCatchScope = 0x4000,
  CXScopeFlags_OpenMPDirectiveScope = 0x8000,
  CXScopeFlags_OpenMPLoopDirectiveScope = 0x10000,
  CXScopeFlags_OpenMPSimdDirectiveScope = 0x20000,
  CXScopeFlags_EnumScope = 0x40000,
  CXScopeFlags_SEHTryScope = 0x80000,
  CXScopeFlags_SEHExceptScope = 0x100000,
  CXScopeFlags_SEHFilterScope = 0x200000,
  CXScopeFlags_CompoundStmtScope = 0x400000,
  CXScopeFlags_ClassInheritanceScope = 0x800000,
  CXScopeFlags_CatchScope = 0x1000000,
  CXScopeFlags_ConditionVarScope = 0x2000000,
  CXScopeFlags_OpenMPOrderClauseScope = 0x4000000,
  CXScopeFlags_LambdaScope = 0x8000000
} CXScopeFlags;

// Builds a free-standing clang::Scope. It is NOT pushed onto Sema's scope stack and nothing
// in clang refers to it, so mutating it cannot disturb a live parse -- it is what makes the
// mutators below usable at all outside the parser. Parent may be null. Diag is borrowed:
// Scope's DiagnosticErrorTrap keeps a reference to it, so it must outlive the scope.
// Release with clang_Scope_dispose, which is a plain delete and must therefore never be
// handed a scope obtained from clang_Sema_getCurScope or clang_Scope_getParent.
CXScope clang_Scope_create(CXScope Parent, unsigned ScopeFlags, CXDiagnosticsEngine Diag);

void clang_Scope_dispose(CXScope S);

// Replaces the flag word and re-derives what follows from it against the scope's existing
// parent: the depth, the break and continue parents, the prototype depth and the Microsoft
// mangling parent.
void clang_Scope_setFlags(CXScope S, unsigned F);

// ORs Flags into the scope's flags and updates the break/continue parent links accordingly.
// Unlike clang_Scope_setFlags, which overwrites, this preserves what is already set.
// PRECONDITION: Flags may only be BreakScope and/or ContinueScope, and none of them may
// already be set -- clang asserts both.
void clang_Scope_AddFlags(CXScope S, unsigned Flags);

void clang_Scope_setIsConditionVarScope(CXScope S, bool InConditionVarScope);

// Returns the number of parameters declared in this prototype so far and increments it.
// Precondition: clang_Scope_isFunctionPrototypeScope(S) -- the method asserts it.
unsigned clang_Scope_getNextFunctionPrototypeIndex(CXScope S);

// Adds D to the scope's declaration set, and additionally records it as an NRVO return slot
// when it is a variable that is not a parameter.
void clang_Scope_AddDecl(CXScope S, CXDecl D);

// Removes D from the declaration set. The NRVO return slots are not touched.
void clang_Scope_RemoveDecl(CXScope S, CXDecl D);

// Moves the mangling parent's number and this scope's current number together, so an
// increment and a decrement cancel exactly. Both are no-ops on a scope with no mangling
// parent (clang_Scope_getMSLastManglingParent).
void clang_Scope_incrementMSManglingNumber(CXScope S);

void clang_Scope_decrementMSManglingNumber(CXScope S);

// Precondition: !clang_Scope_isTemplateParamScope(S) -- Scope::setEntity asserts it.
void clang_Scope_setEntity(CXScope S, CXDeclContext E);

// Sets the same member as clang_Scope_setEntity with no template-parameter-scope assertion.
// A template parameter scope reports the value through clang_Scope_getLookupEntity but not
// through clang_Scope_getEntity.
void clang_Scope_setLookupEntity(CXScope S, CXDeclContext E);

// Appends UDir to the directives clang_Scope_getUsingDirective indexes. Only the pointer is
// stored, so UDir must outlive the scope.
void clang_Scope_PushUsingDirective(CXScope S, CXUsingDirectiveDecl UDir);

// Re-initialises the scope as a child of Parent carrying ScopeFlags -- the same work
// clang_Scope_create runs after allocating, which is how the parser recycles a cached scope
// instead of allocating a new one. Parent may be null.
void clang_Scope_Init(CXScope S, CXScope Parent, unsigned ScopeFlags);

LLVM_CLANG_C_EXTERN_C_END

#endif