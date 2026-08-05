#ifndef LLVM_CLANG_C_EXTRA_CXLOOKUP_H
#define LLVM_CLANG_C_EXTRA_CXLOOKUP_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-c/CXString.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/Sema/Sema.h: enum Sema::RedeclarationKind. Declared here rather than in CXSema.h
// because CXSema.h includes this header, so the dependency only works in this direction.
typedef enum CXRedeclarationKind {
  CXRedeclarationKind_NotForRedeclaration,
  CXRedeclarationKind_ForVisibleRedeclaration,
  CXRedeclarationKind_ForExternalRedeclaration
} CXRedeclarationKind;

typedef enum CXLookupNameKind {
  CXLookupNameKind_LookupOrdinaryName = 0,
  CXLookupNameKind_LookupTagName,
  CXLookupNameKind_LookupLabel,
  CXLookupNameKind_LookupMemberName,
  CXLookupNameKind_LookupOperatorName,
  CXLookupNameKind_LookupDestructorName,
  CXLookupNameKind_LookupNestedNameSpecifierName,
  CXLookupNameKind_LookupNamespaceName,
  CXLookupNameKind_LookupUsingDeclName,
  CXLookupNameKind_LookupRedeclarationWithLinkage,
  CXLookupNameKind_LookupLocalFriendName,
  CXLookupNameKind_LookupObjCProtocolName,
  CXLookupNameKind_LookupObjCImplicitSelfParam,
  CXLookupNameKind_LookupOMPReductionName,
  CXLookupNameKind_LookupOMPMapperName,
  CXLookupNameKind_LookupAnyName
} CXLookupNameKind;

CXLookupResult clang_LookupResult_create(CXSema S, CXDeclarationName Name,
                                         CXSourceLocation_ NameLoc,
                                         CXLookupNameKind LookupKind);

void clang_LookupResult_dispose(CXLookupResult LR);

bool clang_LookupResult_isForRedeclaration(CXLookupResult LR);

bool clang_LookupResult_isTemplateNameLookup(CXLookupResult LR);

bool clang_LookupResult_isAmbiguous(CXLookupResult LR);

bool clang_LookupResult_isSingleResult(CXLookupResult LR);

bool clang_LookupResult_isOverloadedResult(CXLookupResult LR);

bool clang_LookupResult_isUnresolvableResult(CXLookupResult LR);

bool clang_LookupResult_isClassLookup(CXLookupResult LR);

void clang_LookupResult_resolveKind(CXLookupResult LR);

bool clang_LookupResult_isSingleTagDecl(CXLookupResult LR);

void clang_LookupResult_clear(CXLookupResult LR, CXLookupNameKind LookupKind);

void clang_LookupResult_setLookupName(CXLookupResult LR, CXDeclarationName DN);

CXDeclarationName clang_LookupResult_getLookupName(CXLookupResult LR);

void clang_LookupResult_dump(CXLookupResult LR);

bool clang_LookupResult_empty(CXLookupResult LR);

CXNamedDecl clang_LookupResult_getRepresentativeDecl(CXLookupResult LR);

size_t clang_LookupResult_getNum(CXLookupResult LR);

void clang_LookupResult_getResults(CXLookupResult LR, CXNamedDecl *Decls, size_t N);

CXNamedDecl clang_LookupResult_getResult(CXLookupResult LR);

typedef enum CXLookupResultKind {
  CXLookupResultKind_NotFound = 0,
  CXLookupResultKind_NotFoundInCurrentInstantiation,
  CXLookupResultKind_Found,
  CXLookupResultKind_FoundOverloaded,
  CXLookupResultKind_FoundUnresolvedValue,
  CXLookupResultKind_Ambiguous
} CXLookupResultKind;

typedef enum CXAmbiguityKind {
  CXAmbiguityKind_AmbiguousBaseSubobjectTypes = 0,
  CXAmbiguityKind_AmbiguousBaseSubobjects,
  CXAmbiguityKind_AmbiguousReference,
  CXAmbiguityKind_AmbiguousReferenceToPlaceholderVariable,
  CXAmbiguityKind_AmbiguousTagHiding
} CXAmbiguityKind;

CXLookupResultKind clang_LookupResult_getResultKind(CXLookupResult LR);

// Precondition: clang_LookupResult_isAmbiguous(LR) --
// LookupResult::getAmbiguityKind asserts it.
CXAmbiguityKind clang_LookupResult_getAmbiguityKind(CXLookupResult LR);

// Precondition: clang_LookupResult_getResultKind(LR) == CXLookupResultKind_Found --
// LookupResult::getFoundDecl asserts the result is unique before dereferencing begin().
CXNamedDecl clang_LookupResult_getFoundDecl(CXLookupResult LR);

// Null unless the lookup found its results in a class.
CXCXXRecordDecl clang_LookupResult_getNamingClass(CXLookupResult LR);

CXLookupNameKind clang_LookupResult_getLookupKind(CXLookupResult LR);

CXSourceLocation_ clang_LookupResult_getNameLoc(CXLookupResult LR);

unsigned clang_LookupResult_getIdentifierNamespace(CXLookupResult LR);

void clang_LookupResult_suppressDiagnostics(CXLookupResult LR);

bool clang_LookupResult_isForExternalRedeclaration(CXLookupResult LR);

void clang_LookupResult_setAllowHidden(CXLookupResult LR, bool AH);

// Reads ND only when the lookup is for an external redeclaration (the disjunction
// short-circuits otherwise); ND must be non-null.
bool clang_LookupResult_isHiddenDeclarationVisible(CXLookupResult LR, CXNamedDecl ND);

// Null encoding unless the lookup was performed against a base object.
CXQualType clang_LookupResult_getBaseObjectType(CXLookupResult LR);

bool clang_LookupResult_isShadowed(CXLookupResult LR);

bool clang_LookupResult_isSuppressingAccessDiagnostics(CXLookupResult LR);

bool clang_LookupResult_isSuppressingAmbiguousDiagnostics(CXLookupResult LR);

// Source range of the scope specifier of a C++ qualified lookup; invalid otherwise.
CXSourceRange_ clang_LookupResult_getContextRange(CXLookupResult LR);

// Returns an owned box of the lookup's DeclarationNameInfo (the class has no opaque
// encoding); release it with clang_DeclarationNameInfo_dispose.
CXDeclarationNameInfo clang_LookupResult_getLookupNameInfo(CXLookupResult LR);

// NameInfo is copied, not adopted; the caller keeps the box and releases it with
// clang_DeclarationNameInfo_dispose.
void clang_LookupResult_setLookupNameInfo(CXLookupResult LR,
                                          CXDeclarationNameInfo NameInfo);

// Setting a naming class makes this a class lookup, which turns clang's access check on
// when the result is destroyed; suppress diagnostics first on a hand-assembled result.
void clang_LookupResult_setNamingClass(CXLookupResult LR, CXCXXRecordDecl Record);

void clang_LookupResult_setBaseObjectType(CXLookupResult LR, CXQualType T);

// Adds ND with its natural access and marks the result found. LookupResult::addDecl reads
// ND->getAccess(), which asserts when ND is a class member whose access is unset. Adding a
// second decl leaves the result kind inconsistent with the decl count until
// clang_LookupResult_resolveKind runs -- clang asserts on that in an assertion build.
void clang_LookupResult_addDecl(CXLookupResult LR, CXNamedDecl ND);

// Appends every decl of Other and marks the result found; the same resolveKind
// requirement as clang_LookupResult_addDecl applies once the total exceeds one.
void clang_LookupResult_addAllDecls(CXLookupResult LR, CXLookupResult Other);

bool clang_LookupResult_wasNotFoundInCurrentInstantiation(CXLookupResult LR);

// Precondition: the result kind is CXLookupResultKind_NotFound and the result is empty --
// LookupResult::setNotFoundInCurrentInstantiation asserts both.
void clang_LookupResult_setNotFoundInCurrentInstantiation(CXLookupResult LR);

// Sets whether this is a template-name lookup, in which an injected-class-name names the
// template itself rather than a specialization of it.
void clang_LookupResult_setTemplateNameLookup(CXLookupResult LR, bool TemplateName);

// Records that lookup found and ignored a declaration; there is no way back to false.
void clang_LookupResult_setShadowed(CXLookupResult LR);

// Sets the 'context' source range -- for a C++ qualified lookup, the scope specifier.
void clang_LookupResult_setContextRange(CXLookupResult LR, CXSourceRange_ SR);

// LookupResult (acceptability, filtering and the remaining configuration)
void clang_LookupResult_setHideTags(CXLookupResult LR, bool Hide);

// Static. Availability is weaker than visibility: a declaration reached through a
// non-exported import is available to lookup without being visible. ND must be non-null.
bool clang_LookupResult_isAvailableForLookup(CXSema S, CXNamedDecl ND);

// Returns the (re)declaration of ND this lookup accepts, or null when ND inhabits none of
// the lookup's identifier namespaces and has no acceptable redeclaration. ND must be
// non-null -- the method dereferences it before any other test.
CXNamedDecl clang_LookupResult_getAcceptableDecl(CXLookupResult LR, CXNamedDecl ND);

// Recomputes the result kind after declarations have been removed from the result.
void clang_LookupResult_resolveKindAfterFilter(CXLookupResult LR);

// Marks the result ambiguous because a tag declaration was hidden by an ordinary
// declaration in another context. Precondition: the result must already suppress its
// ambiguity diagnostics -- ~LookupResult runs Sema::DiagnoseAmbiguousLookup otherwise, and
// rendering a diagnostic outside a parse crashes clang's diagnostic renderer.
void clang_LookupResult_setAmbiguousQualifiedTagHiding(CXLookupResult LR);

// Turns off only the access-control diagnostic; the ambiguity one stays on.
void clang_LookupResult_suppressAccessDiagnostics(CXLookupResult LR);

CXSema clang_LookupResult_getSema(CXLookupResult LR);

// LookupResult::Filter
// The handle is an owned box of the by-value clang::LookupResult::Filter, which borrows the
// LookupResult it was made from -- that result must outlive the filter. Release it with
// clang_LookupResult_Filter_dispose, and only after clang_LookupResult_Filter_done:
// ~Filter asserts that done() has been called.
CXLookupResult_Filter clang_LookupResult_makeFilter(CXLookupResult LR);

void clang_LookupResult_Filter_dispose(CXLookupResult_Filter F);

bool clang_LookupResult_Filter_hasNext(CXLookupResult_Filter F);

// Precondition: clang_LookupResult_Filter_hasNext(F) -- Filter::next asserts it. The
// declaration handed back is the found one, possibly sugared, not its underlying decl.
CXNamedDecl clang_LookupResult_Filter_next(CXLookupResult_Filter F);

void clang_LookupResult_Filter_restart(CXLookupResult_Filter F);

// Erases the declaration last returned by clang_LookupResult_Filter_next. Precondition:
// next has been called at least once since the filter was made or restarted -- the method
// steps its iterator back with no check, and the iterator is private.
void clang_LookupResult_Filter_erase(CXLookupResult_Filter F);

// Replaces the declaration last returned by clang_LookupResult_Filter_next, preserving the
// access bits of the entry. Same precondition as clang_LookupResult_Filter_erase.
void clang_LookupResult_Filter_replace(CXLookupResult_Filter F, CXNamedDecl ND);

// Ends the filtering pass, re-resolving the result kind when anything changed.
// Precondition: not already called on this filter -- Filter::done asserts it.
void clang_LookupResult_Filter_done(CXLookupResult_Filter F);

void clang_LookupResult_setFindLocalExtern(CXLookupResult LR, bool FindLocalExtern);

// LookupResult (redeclaration kind and rendering)
CXRedeclarationKind clang_LookupResult_redeclarationKind(CXLookupResult LR);

// Reconfigures the identifier namespaces the lookup accepts. For a name that is one of the
// allocation or deallocation operators this reaches Sema::DeclareGlobalNewDelete, which
// adds the implicit global operators to the translation unit -- the same side effect
// clang_LookupResult_create and clang_LookupResult_clear already carry.
void clang_LookupResult_setRedeclarationKind(CXLookupResult LR, CXRedeclarationKind RK);

// LookupResult::print rendered into a string instead of into a raw_ostream.
CXString clang_LookupResult_printToString(CXLookupResult LR);

LLVM_CLANG_C_EXTERN_C_END

#endif