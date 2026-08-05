#ifndef LLVM_CLANG_C_EXTRA_CXTEMPLATE_H
#define LLVM_CLANG_C_EXTRA_CXTEMPLATE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirrors clang::TPOC (clang/Sema/Template.h): which context a partial ordering of function
// templates is being performed for.
typedef enum CXTPOC {
  CXTPOC_TPOC_Call,
  CXTPOC_TPOC_Conversion,
  CXTPOC_TPOC_Other,
} CXTPOC;


// clang spells this `enum class TemplateSubstitutionKind : char`. The underlying type is
// deliberately not copied: plain `char` has implementation-defined signedness, so pinning
// it here would make the generated Julia @enum's integer type platform-dependent. The
// value crosses by value through a static_cast, never by pointer and never inside a
// struct, so the widths need not agree.
typedef enum CXTemplateSubstitutionKind {
  CXTemplateSubstitutionKind_Specialization,
  CXTemplateSubstitutionKind_Rewrite,
} CXTemplateSubstitutionKind;

// MultiLevelTemplateArgumentList
//
// The handle is not a bare clang::MultiLevelTemplateArgumentList: the C++ class stores
// every level as an ArrayRef<TemplateArgument> and never copies the elements, so a bare
// box would hold views onto memory the caller owns. The handle is a box that owns a copy
// of every level it is given and holds the value last, so the storage outlives it
// (MARSHALLING.md §10). Caller-owned: release it with
// clang_MultiLevelTemplateArgumentList_dispose.
CXMultiLevelTemplateArgumentList clang_MultiLevelTemplateArgumentList_create(void);

void clang_MultiLevelTemplateArgumentList_dispose(CXMultiLevelTemplateArgumentList ML);

void clang_MultiLevelTemplateArgumentList_setKind(CXMultiLevelTemplateArgumentList ML,
                                                  CXTemplateSubstitutionKind K);

CXTemplateSubstitutionKind
clang_MultiLevelTemplateArgumentList_getKind(CXMultiLevelTemplateArgumentList ML);

bool clang_MultiLevelTemplateArgumentList_isRewrite(CXMultiLevelTemplateArgumentList ML);

unsigned
clang_MultiLevelTemplateArgumentList_getNumLevels(CXMultiLevelTemplateArgumentList ML);

unsigned clang_MultiLevelTemplateArgumentList_getNumSubstitutedLevels(
    CXMultiLevelTemplateArgumentList ML);

// The upstream spelling drops a letter ("Subsituted"); it is copied verbatim, like every
// other wrapper name. Precondition:
// getNumRetainedOuterLevels() <= Depth < getNumLevels().
unsigned clang_MultiLevelTemplateArgumentList_getNumSubsitutedArgs(
    CXMultiLevelTemplateArgumentList ML, unsigned Depth);

unsigned clang_MultiLevelTemplateArgumentList_getNumRetainedOuterLevels(
    CXMultiLevelTemplateArgumentList ML);

unsigned
clang_MultiLevelTemplateArgumentList_getNewDepth(CXMultiLevelTemplateArgumentList ML,
                                                 unsigned OldDepth);

// helper: clang::MultiLevelTemplateArgumentList::operator(). The returned argument is
// borrowed from the box's own storage - never pass it to clang_TemplateArgument_dispose,
// and it dangles once the box is disposed. Precondition:
// getNumRetainedOuterLevels() <= Depth < getNumLevels(), Index < the level's size.
CXTemplateArgument
clang_MultiLevelTemplateArgumentList_getArgument(CXMultiLevelTemplateArgumentList ML,
                                                 unsigned Depth, unsigned Index);

// The two halves of the std::pair<Decl *, bool> getAssociatedDecl returns
// (MARSHALLING.md §7). Precondition on both:
// getNumRetainedOuterLevels() <= Depth < getNumLevels().
CXDecl
clang_MultiLevelTemplateArgumentList_getAssociatedDecl(CXMultiLevelTemplateArgumentList ML,
                                                       unsigned Depth);

bool clang_MultiLevelTemplateArgumentList_isAssociatedDeclFinal(
    CXMultiLevelTemplateArgumentList ML, unsigned Depth);

// Precondition: Depth < getNumLevels(). A retained outer level always answers false.
bool clang_MultiLevelTemplateArgumentList_hasTemplateArgument(
    CXMultiLevelTemplateArgumentList ML, unsigned Depth, unsigned Index);

bool clang_MultiLevelTemplateArgumentList_isAnyArgInstantiationDependent(
    CXMultiLevelTemplateArgumentList ML);

// Overwrites one argument in the box's own copy of the level; the caller's Arg box is
// copied and left untouched. Precondition:
// getNumRetainedOuterLevels() <= Depth < getNumLevels(), Index < the level's size.
void clang_MultiLevelTemplateArgumentList_setArgument(CXMultiLevelTemplateArgumentList ML,
                                                      unsigned Depth, unsigned Index,
                                                      CXTemplateArgument Arg);

// Args is a caller buffer of CXTemplateArgument handles (pointers to heap-boxed
// clang::TemplateArgument), not a contiguous value array (MARSHALLING.md §11); the
// elements are copied into a fresh level of the box's storage, so the caller keeps its
// own boxes. AssociatedDecl is stored canonicalised. Precondition:
// getNumRetainedOuterLevels() == 0 and getKind() ==
// CXTemplateSubstitutionKind_Specialization.
void clang_MultiLevelTemplateArgumentList_addOuterTemplateArguments(
    CXMultiLevelTemplateArgumentList ML, CXDecl AssociatedDecl, CXTemplateArgument Args,
    unsigned NumArgs, bool Final);

// Same buffer convention. The replaced level's storage stays alive inside the box until
// it is disposed, so a CXTemplateArgument obtained earlier from that level never dangles
// before dispose - it just stops being the list's current argument. Precondition:
// getNumSubstitutedLevels() > 0 || getNumRetainedOuterLevels() > 0.
void clang_MultiLevelTemplateArgumentList_replaceInnermostTemplateArguments(
    CXMultiLevelTemplateArgumentList ML, CXDecl AssociatedDecl, CXTemplateArgument Args,
    unsigned NumArgs);

void clang_MultiLevelTemplateArgumentList_addOuterRetainedLevel(
    CXMultiLevelTemplateArgumentList ML);

void clang_MultiLevelTemplateArgumentList_addOuterRetainedLevels(
    CXMultiLevelTemplateArgumentList ML, unsigned Num);

// getInnermost() / getOutermost() as count + index pairs (MARSHALLING.md §6); the
// arguments are borrowed from the box's storage, like clang_..._getArgument.
// Precondition on all four: getNumSubstitutedLevels() > 0.
unsigned clang_MultiLevelTemplateArgumentList_getNumInnermostArgs(
    CXMultiLevelTemplateArgumentList ML);

CXTemplateArgument
clang_MultiLevelTemplateArgumentList_getInnermostArg(CXMultiLevelTemplateArgumentList ML,
                                                     unsigned I);

unsigned clang_MultiLevelTemplateArgumentList_getNumOutermostArgs(
    CXMultiLevelTemplateArgumentList ML);

CXTemplateArgument
clang_MultiLevelTemplateArgumentList_getOutermostArg(CXMultiLevelTemplateArgumentList ML,
                                                     unsigned I);

// begin
// end
// dump

// LocalInstantiationScope
//
// clang::LocalInstantiationScope is the RAII object that maps a pattern's local
// declarations - parameters, local variables, template parameters - onto the ones being
// created for an instantiation. Sema::CurrentInstantiationScope points at the innermost
// one, and every Sema entry point that rebuilds a *declaration* writes through it with no
// null check, so one must be live before those calls (MARSHALLING.md §13, "export the
// operation that establishes the state" - the same reason
// clang_InstantiatingTemplate_create exists). Caller-owned heap box: constructing it makes
// it current, and clang_LocalInstantiationScope_dispose runs the destructor, which
// restores the scope that was current before, so nested scopes must be disposed in reverse
// construction order. CombineWithOuterScope makes lookups fall through to the enclosing
// scope instead of stopping at this one.
CXLocalInstantiationScope clang_LocalInstantiationScope_create(CXSema S,
                                                               bool CombineWithOuterScope);

void clang_LocalInstantiationScope_dispose(CXLocalInstantiationScope Scope);

CXSema clang_LocalInstantiationScope_getSema(CXLocalInstantiationScope Scope);

// Ends the scope early: the scope that was current before it becomes current again, which
// is exactly what clang_LocalInstantiationScope_dispose does through the destructor. The
// method guards on its own already-exited flag, so calling it twice, and disposing an
// already-exited scope, are both defined.
void clang_LocalInstantiationScope_Exit(CXLocalInstantiationScope Scope);

// Whether D is one of the declarations this scope expanded into an argument pack. A scope
// created with CombineWithOuterScope answers for the enclosing scopes as well.
bool clang_LocalInstantiationScope_isLocalPackExpansion(CXLocalInstantiationScope Scope,
                                                        CXDecl D);

LLVM_CLANG_C_EXTERN_C_END

#endif
