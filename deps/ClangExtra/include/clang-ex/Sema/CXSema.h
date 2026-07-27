#ifndef LLVM_CLANG_C_EXTRA_CXSEMA_H
#define LLVM_CLANG_C_EXTRA_CXSEMA_H

#include "clang-ex/AST/CXExpr.h"            // CXPredefinedIdentKind, CXSourceLocIdentKind
#include "clang-ex/AST/CXOperationKinds.h"  // CXUnaryOperatorKind, CXBinaryOperatorKind
#include "clang-ex/AST/CXType.h"            // CXArraySizeModifier, CXTypeOfKind, CXUTTKind
#include "clang-ex/Basic/CXAddressSpaces.h" // CXLangAS
#include "clang-ex/Basic/CXCapturedStmt.h"  // CXCapturedRegionKind
#include "clang-ex/Basic/CXExceptionSpecificationType.h" // CXCanThrowResult
#include "clang-ex/Basic/CXExpressionTraits.h"           // CXExpressionTrait
#include "clang-ex/Basic/CXLangOptions.h"                // CXFPExceptionModeKind
#include "clang-ex/Basic/CXSpecifiers.h"
#include "clang-ex/Basic/CXTypeTraits.h" // CXUnaryExprOrTypeTrait
#include "clang-ex/CXTypes.h"
#include "clang-ex/Sema/CXLookup.h" // CXLookupNameKind
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/Sema/Sema.h: enum class Sema::CompleteTypeKind
// The alias enumerator Default (= AcceptSizeless) is omitted per the mirroring
// rules; being an `=` assignment it does not shift the numbering.
typedef enum CXCompleteTypeKind {
  CXCompleteTypeKind_Normal,
  CXCompleteTypeKind_AcceptSizeless
} CXCompleteTypeKind;


CXASTContext clang_Sema_getASTContext(CXSema S);

CXSourceManager clang_Sema_getSourceManager(CXSema S);

CXDiagnosticsEngine clang_Sema_getDiagnostics(CXSema S);

CXPreprocessor clang_Sema_getPreprocessor(CXSema S);

CXLangOptions clang_Sema_getLangOpts(CXSema S);

// Borrowed; null outside of parsing.
CXScope clang_Sema_getCurScope(CXSema S);

// T must be a non-null QualType. Never diagnoses (null TypeDiagnoser).
bool clang_Sema_isCompleteType(CXSema S, CXSourceLocation_ Loc, CXQualType T,
                               CXCompleteTypeKind Kind);

// Precondition: DiagID != 0. Sema wraps it in a BoundTypeDiagnoser whose ctor
// asserts `DiagID != 0 && "no diagnostic for type diagnoser"` (Sema.h). T must
// be a non-null QualType.
bool clang_Sema_RequireCompleteType(CXSema S, CXSourceLocation_ Loc, CXQualType T,
                                    CXCompleteTypeKind Kind, unsigned DiagID);

// Precondition: DiagID != 0 (same BoundTypeDiagnoser assert).
bool clang_Sema_RequireCompleteExprType(CXSema S, CXExpr E, unsigned DiagID);

// Precondition: DiagID != 0 (same BoundTypeDiagnoser assert).
bool clang_Sema_RequireLiteralType(CXSema S, CXSourceLocation_ Loc, CXQualType T,
                                   unsigned DiagID);

CXQualType clang_Sema_getCompletedType(CXSema S, CXExpr E);

// Marks SS invalid if it represents an incomplete type. DC must be non-null.
bool clang_Sema_RequireCompleteDeclContext(CXSema S, CXCXXScopeSpec SS, CXDeclContext DC);

// SS may be null (Clang's default argument).
bool clang_Sema_RequireCompleteEnumDecl(CXSema S, CXEnumDecl D, CXSourceLocation_ L,
                                        CXCXXScopeSpec SS);

// computeDeclContext(QualType) overload; null when T is not a tag/ObjC type.
CXDeclContext clang_Sema_computeDeclContextFromType(CXSema S, CXQualType T);

// computeDeclContext(const CXXScopeSpec &, bool) overload; null for an unset SS.
CXDeclContext clang_Sema_computeDeclContext(CXSema S, CXCXXScopeSpec SS,
                                            bool EnteringContext);

bool clang_Sema_isDependentScopeSpecifier(CXSema S, CXCXXScopeSpec SS);

// Null when the results were absent, ambiguous, or overloaded.
CXNamedDecl clang_Sema_LookupSingleName(CXSema S, CXScope Sp, CXDeclarationName Name,
                                        CXSourceLocation_ Loc, CXLookupNameKind NameKind,
                                        CXRedeclarationKind Redecl);

// LookupCtx must be non-null.
bool clang_Sema_LookupQualifiedName(CXSema S, CXLookupResult R, CXDeclContext LookupCtx,
                                    bool InUnqualifiedLookup);

// LookupQualifiedName(LookupResult &, DeclContext *, CXXScopeSpec &) overload;
// LookupCtx and SS must be non-null.
bool clang_Sema_LookupQualifiedNameWithScopeSpec(CXSema S, CXLookupResult R,
                                                 CXDeclContext LookupCtx,
                                                 CXCXXScopeSpec SS);

bool clang_Sema_LookupInSuper(CXSema S, CXLookupResult R, CXCXXRecordDecl Class);

void clang_Sema_setCollectStats(CXSema S, bool ShouldCollect);

void clang_Sema_PrintStats(CXSema S);

void clang_Sema_RestoreNestedNameSpecifierAnnotation(
    CXSema S, void *Annotation, CXSourceLocation_ AnnotationRange_begin,
    CXSourceLocation_ AnnotationRange_end, CXCXXScopeSpec SS);

CXQualType clang_sema_getTypeName(CXSema S, CXIdentifierInfo II, CXSourceLocation_ NameLoc,
                                  CXScope Scp, CXCXXScopeSpec SS, bool isClassName,
                                  bool HasTrailingDot, CXQualType ObjectTypePtr,
                                  bool IsCtorOrDtorName, bool WantNontrivialTypeSourceInfo,
                                  bool IsClassTemplateDeductionContext,
                                  bool AllowImplicitTypename);

bool clang_Sema_LookupParsedName(CXSema S, CXLookupResult R, CXScope Sp, CXCXXScopeSpec SS,
                                 bool AllowBuiltinCreation, bool EnteringContext);

bool clang_Sema_LookupName(CXSema S, CXLookupResult R, CXScope Sp,
                           bool AllowBuiltinCreation, bool ForceNoCPlusPlus);

void clang_Sema_processWeakTopLevelDecls(CXSema Sema, CXCodeGenerator CodeGen);

CXCXXConstructorDecl clang_Sema_LookupDefaultConstructor(CXSema S, CXCXXRecordDecl Class);

CXCXXDestructorDecl clang_Sema_LookupDestructor(CXSema S, CXCXXRecordDecl Class);

// DeclContextLookupResult LookupConstructors(CXXRecordDecl *Class);

// --- Sema state queries ---

// True when an error making the translation unit uncompilable has been emitted,
// including errors carried in deferred diagnostics.
bool clang_Sema_hasUncompilableErrorOccurred(CXSema S);

// The initializer clang suggests for zero-initializing T (" = 0", "{}", ...), as
// a CXString (MARSHALLING.md 5). T must be a non-null QualType: the body
// dereferences it before testing anything.
CXString clang_Sema_getFixItZeroInitializerForType(CXSema S, CXQualType T,
                                                   CXSourceLocation_ Loc);

// The bare zero literal for T, as a CXString. Precondition: T is a non-null
// QualType naming a SCALAR type -- this entry point forwards to the spelling
// helper unconditionally and that helper asserts `T.isScalarType()`, whereas
// getFixItZeroInitializerForType tests scalar-ness first.
CXString clang_Sema_getFixItZeroLiteralForType(CXSema S, CXQualType T,
                                               CXSourceLocation_ Loc);

CXSourceLocation_ clang_Sema_getLocForEndOfToken(CXSema S, CXSourceLocation_ Loc,
                                                 unsigned Offset);

CXCanThrowResult clang_Sema_canThrow(CXSema S, CXStmt E);

// Whether D is visible to / reachable from name lookup under Sema's current
// module visibility. Total for any non-null NamedDecl.
bool clang_Sema_isVisible(CXSema S, CXNamedDecl D);

bool clang_Sema_isReachable(CXSema S, CXNamedDecl D);

bool clang_Sema_hasVisibleMergedDefinition(CXSema S, CXNamedDecl Def);

bool clang_Sema_isEquivalentInternalLinkageDeclaration(CXSema S, CXNamedDecl A,
                                                       CXNamedDecl B);

// Sema's language-mode-aware form of CXXMethodDecl::isUsualDeallocationFunction.
bool clang_Sema_isUsualDeallocationFunction(CXSema S, CXCXXMethodDecl FD);

// The next three walk Sema's CurContext, which the parser sets when it enters the
// translation unit scope. Before that CurContext is null and the walk runs isa<>
// on a null pointer, so the Julia wrappers gate on
// clang_Sema_getCurLexicalContext returning non-null.
CXDeclContext clang_Sema_getFunctionLevelDeclContext(CXSema S, bool AllowLambda);

CXFunctionDecl clang_Sema_getCurFunctionDecl(CXSema S, bool AllowLambda);

CXNamedDecl clang_Sema_getCurFunctionOrMethodDecl(CXSema S);

// FromType and ToType must be non-null QualTypes; both are dereferenced.
bool clang_Sema_IsFloatingPointPromotion(CXSema S, CXQualType FromType, CXQualType ToType);

// Null until a declaration of the std namespace has been seen.
CXNamespaceDecl clang_Sema_getStdNamespace(CXSema S);

// Null until a declaration of std::bad_alloc has been seen.
CXCXXRecordDecl clang_Sema_getStdBadAlloc(CXSema S);

bool clang_Sema_isInitListConstructor(CXSema S, CXFunctionDecl Ctor);

bool clang_Sema_isImplicitlyDeleted(CXSema S, CXFunctionDecl FD);

// Derived and Base must be non-null QualTypes; both are dereferenced.
bool clang_Sema_IsDerivedFrom(CXSema S, CXSourceLocation_ Loc, CXQualType Derived,
                              CXQualType Base);

// Null until the parser has entered the translation unit scope.
CXDeclContext clang_Sema_getCurLexicalContext(CXSema S);

// Capacity-bounded fill of the constructors of Class, the implicit ones included: with a
// null Buf it returns how many there are and ignores BufSize, otherwise it writes at most
// BufSize of them and returns how many it wrote. The lookup declares the implicit
// constructors as a side effect, so a counting call can leave the following filling call
// with more entries to report -- hence the bound instead of a getNum*/get* pair. Entries
// are constructors, or the FunctionTemplateDecl of a constructor template, so they cross at
// the container's element type.
unsigned clang_Sema_LookupConstructors(CXSema S, CXCXXRecordDecl Class, CXNamedDecl *Buf,
                                       unsigned BufSize);

// Quals qualifies the parameter the copy constructor takes; ThisQuals below qualifies the
// implicit object parameter. Both are Qualifiers bitmasks and Sema asserts that they carry
// nothing but Const (0x1) and Volatile (0x4). Class must be a class definition that is
// neither dependent nor still being defined -- Sema's special-member lookups assert on it.
CXCXXConstructorDecl clang_Sema_LookupCopyingConstructor(CXSema S, CXCXXRecordDecl Class,
                                                         unsigned Quals);

CXCXXMethodDecl clang_Sema_LookupCopyingAssignment(CXSema S, CXCXXRecordDecl Class,
                                                   unsigned Quals, bool RValueThis,
                                                   unsigned ThisQuals);

CXCXXConstructorDecl clang_Sema_LookupMovingConstructor(CXSema S, CXCXXRecordDecl Class,
                                                        unsigned Quals);

CXCXXMethodDecl clang_Sema_LookupMovingAssignment(CXSema S, CXCXXRecordDecl Class,
                                                  unsigned Quals, bool RValueThis,
                                                  unsigned ThisQuals);

// clang/Sema/Sema.h: enum Sema::CXXSpecialMember
typedef enum CXCXXSpecialMember {
  CXCXXSpecialMember_CXXDefaultConstructor,
  CXCXXSpecialMember_CXXCopyConstructor,
  CXCXXSpecialMember_CXXMoveConstructor,
  CXCXXSpecialMember_CXXCopyAssignment,
  CXCXXSpecialMember_CXXMoveAssignment,
  CXCXXSpecialMember_CXXDestructor,
  CXCXXSpecialMember_CXXInvalid
} CXCXXSpecialMember;

// clang/Sema/Sema.h: enum Sema::SpecialMemberOverloadResult::Kind
typedef enum CXSpecialMemberOverloadResultKind {
  CXSpecialMemberOverloadResultKind_NoMemberOrDeleted,
  CXSpecialMemberOverloadResultKind_Ambiguous,
  CXSpecialMemberOverloadResultKind_Success
} CXSpecialMemberOverloadResultKind;

// The general form the five lookups above are built on. The SpecialMemberOverloadResult it
// returns is a value type, so its two halves cross separately: the selected method is the
// return value (null when there is none) and the resolution outcome goes into *Kind, which
// may be null when the caller does not want it. Same precondition on Class as above.
CXCXXMethodDecl clang_Sema_LookupSpecialMember(CXSema S, CXCXXRecordDecl D,
                                               CXCXXSpecialMember SM, bool ConstArg,
                                               bool VolatileArg, bool RValueThis,
                                               bool ConstThis, bool VolatileThis,
                                               CXSpecialMemberOverloadResultKind *Kind);

// True when the name in R names a builtin, in which case the builtin's declaration is
// lazily created in the translation-unit scope and added to R. A name that is not a builtin
// changes nothing and returns false.
bool clang_Sema_LookupBuiltin(CXSema S, CXLookupResult R);

// LookupVisibleDecls(DeclContext *, ...) overload, with the visitor callback replaced by
// the same capacity-bounded fill as clang_Sema_LookupConstructors: a null Buf counts (and
// ignores BufSize), a non-null Buf takes at most BufSize entries and returns how many were
// written. The walk order is a pure function of the AST state, but the walk itself forces
// the implicit members of every class context it enters to be declared, so the count a
// first call reports is a lower bound for a second one -- never size a buffer from it
// without keeping the bound.
unsigned clang_Sema_LookupVisibleDeclsInContext(
    CXSema S, CXDeclContext Ctx, CXLookupNameKind Kind, bool IncludeGlobalScope,
    bool IncludeDependentBases, bool LoadExternal, CXNamedDecl *Buf, unsigned BufSize);

// True when T is (an array of) an abstract class type, diagnosing at Loc.
// Precondition: DiagID != 0 (the same BoundTypeDiagnoser assert as RequireCompleteType).
bool clang_Sema_RequireNonAbstractType(CXSema S, CXSourceLocation_ Loc, CXQualType T,
                                       unsigned DiagID);

// True when T is not a structural type (C++20 [temp.param]p7), diagnosing at Loc. Unlike
// the Require* wrappers above this one carries its own diagnostic ids, so a non-structural
// or incomplete T does emit diagnostics. T must be a non-null QualType.
bool clang_Sema_RequireStructuralType(CXSema S, CXQualType T, CXSourceLocation_ Loc);

// --- Template instantiation ---

// Wraps Sema::isCompleteType with CompleteTypeKind::Default. Requiring completeness
// implicitly instantiates a class template specialization, so this doubles as the
bool clang_Sema_usesPartialOrExplicitSpecialization(
    CXSema S, CXSourceLocation_ Loc, CXClassTemplateSpecializationDecl ClassTemplateSpec);

// Returns true when an error occurred, false on success.
bool clang_Sema_InstantiateClassTemplateSpecialization(
    CXSema S, CXSourceLocation_ PointOfInstantiation,
    CXClassTemplateSpecializationDecl ClassTemplateSpec, CXTemplateSpecializationKind TSK,
    bool Complain);

void clang_Sema_InstantiateClassTemplateSpecializationMembers(
    CXSema S, CXSourceLocation_ PointOfInstantiation,
    CXClassTemplateSpecializationDecl ClassTemplateSpec, CXTemplateSpecializationKind TSK);

void clang_Sema_InstantiateFunctionDefinition(CXSema S,
                                              CXSourceLocation_ PointOfInstantiation,
                                              CXFunctionDecl Function, bool Recursive,
                                              bool DefinitionRequired, bool AtEndOfTU);

void clang_Sema_InstantiateVariableDefinition(CXSema S,
                                              CXSourceLocation_ PointOfInstantiation,
                                              CXVarDecl Var, bool Recursive,
                                              bool DefinitionRequired, bool AtEndOfTU);

void clang_Sema_PerformPendingInstantiations(CXSema S, bool LocalOnly);

// --- Semantic checks ---
// Sema's checking entry points that a caller can drive outside the parser. Every one
// that can fail reports through Sema's DiagnosticsEngine, so a caller that wants a
// pure query has to pick one of the forms documented below as never diagnosing.

// True when T cannot be used as a function return type (an array or function type, or
// an abstract class). Diagnoses at Loc in that case.
bool clang_Sema_CheckFunctionReturnType(CXSema S, CXQualType T, CXSourceLocation_ Loc);

// Resolve a deferred (unevaluated or uninstantiated) exception specification, returning
// the FunctionProtoType that carries the resolved spec — FPT itself when the spec needed
// no resolution, null when resolution failed. PRECONDITION: FPT's exception spec type is
// not EST_Unparsed, which Sema diagnoses instead of resolving.
CXFunctionProtoType clang_Sema_ResolveExceptionSpec(CXSema S, CXSourceLocation_ Loc,
                                                    CXFunctionProtoType FPT);

// True when T is a pointer (or pointer-to-member) to a function type that carries an
// exception specification. Always false under C++17 and later, where the specification
// is part of the function type itself. Never diagnoses.
bool clang_Sema_CheckDistantExceptionSpec(CXSema S, CXQualType T);

// True when N arguments satisfy a type trait declared with arity Arity (0 means
// variadic, and then N must be non-zero). Diagnoses at Loc on a mismatch.
bool clang_Sema_CheckTypeTraitArity(CXSema S, unsigned Arity, CXSourceLocation_ Loc,
                                    size_t N);

// True when E is usable as a `case` label expression: dependent, or an integral constant
// expression of integral or enumeration type. Never diagnoses.
bool clang_Sema_CheckCaseExpression(CXSema S, CXExpr E);

// The implicit special members. Each call declares the member on ClassDecl and returns
// it. PRECONDITION: the matching CXXRecordDecl::needsImplicit* predicate holds — clang
// asserts on it, and a second call would add a duplicate declaration of the same member.
// The two move members return null when the move member is not implicitly declared.
CXCXXConstructorDecl
clang_Sema_DeclareImplicitDefaultConstructor(CXSema S, CXCXXRecordDecl ClassDecl);

CXCXXDestructorDecl clang_Sema_DeclareImplicitDestructor(CXSema S,
                                                         CXCXXRecordDecl ClassDecl);

CXCXXConstructorDecl clang_Sema_DeclareImplicitCopyConstructor(CXSema S,
                                                               CXCXXRecordDecl ClassDecl);

CXCXXConstructorDecl clang_Sema_DeclareImplicitMoveConstructor(CXSema S,
                                                               CXCXXRecordDecl ClassDecl);

CXCXXMethodDecl clang_Sema_DeclareImplicitCopyAssignment(CXSema S,
                                                         CXCXXRecordDecl ClassDecl);

CXCXXMethodDecl clang_Sema_DeclareImplicitMoveAssignment(CXSema S,
                                                         CXCXXRecordDecl ClassDecl);

// Declare the implicit global operator new / operator delete overloads. Idempotent:
// Sema remembers that it has already run.
void clang_Sema_DeclareGlobalNewDelete(CXSema S);

// The usual deallocation function named Name (an OO_Delete / OO_Array_Delete operator
// name); null when no overload is viable. Declares the global new/delete set first.
CXFunctionDecl clang_Sema_FindUsualDeallocationFunction(CXSema S,
                                                        CXSourceLocation_ StartLoc,
                                                        bool CanProvideSize,
                                                        bool Overaligned,
                                                        CXDeclarationName Name);

// The operator delete a destructor of RD would call; null when none is viable. An
// ambiguous class-level operator delete is diagnosed.
CXFunctionDecl clang_Sema_FindDeallocationFunctionForDestructor(CXSema S,
                                                                CXSourceLocation_ StartLoc,
                                                                CXCXXRecordDecl RD);

// The leading component of NNS looked up in scope Sp; null when that component is not
// an identifier or the lookup is not a single result.
CXNamedDecl clang_Sema_FindFirstQualifierInScope(CXSema S, CXScope Sp,
                                                 CXNestedNameSpecifier NNS);

// True when the Derived -> Base conversion is ill-formed (the base is ambiguous, or is
// inaccessible unless IgnoreAccess), diagnosing at Loc over the range. PRECONDITION:
// Derived really derives from Base — clang asserts that the base-path walk succeeds. The
// CXXCastPath out-parameter is not exposed; nullptr is passed for it.
bool clang_Sema_CheckDerivedToBaseConversion(CXSema S, CXQualType Derived, CXQualType Base,
                                             CXSourceLocation_ Loc,
                                             CXSourceLocation_ Range_begin,
                                             CXSourceLocation_ Range_end,
                                             bool IgnoreAccess);

// True when Old carries the `final` attribute, in which case the illegal override by New
// is diagnosed.
bool clang_Sema_CheckIfOverriddenFunctionIsMarkedFinal(CXSema S, CXCXXMethodDecl New,
                                                       CXCXXMethodDecl Old);

// --- Declaration helpers, implicit members and pragma-driven attributes ---
//
// Everything below MUTATES the AST or Sema's bookkeeping; none of it is a pure query.
// These are the hooks the parser itself runs once a declaration is complete, so they are
// well defined against a finished translation unit, but running them against a shared
// interpreter changes what every later query sees.

// Wires up MD's overridden-method list from the virtual members of DC's bases, returning
// true when at least one overridden method was found. PRECONDITION: DC has a definition
// (its bases are walked), and MD's overridden-method list is still empty — clang appends
// without de-duplicating, so a second call records every entry twice.
bool clang_Sema_AddOverriddenMethods(CXSema S, CXCXXRecordDecl DC, CXCXXMethodDecl MD);

// Stores DefaultArg as Param's default argument. No conversion and no checking happen
// here; DefaultArg must already have been converted to Param's type.
void clang_Sema_SetParamDefaultArgument(CXSema S, CXParmVarDecl Param, CXExpr DefaultArg,
                                        CXSourceLocation_ EqualLoc);

// Marks Dcl as `= delete`. A Dcl that is not a function, or a redeclaration that is not
// the first declaration, is reported through Sema's DiagnosticsEngine instead (the latter
// also marks Dcl invalid).
void clang_Sema_SetDeclDeleted(CXSema S, CXDecl Dcl, CXSourceLocation_ DelLoc);

// Marks Dcl as `= default`. A Dcl that is not a defaultable special member or comparison
// operator is reported through Sema's DiagnosticsEngine instead.
void clang_Sema_SetDeclDefaulted(CXSema S, CXDecl Dcl, CXSourceLocation_ DefaultLoc);

// Adds the attributes clang infers from FD's builtin ID and from its name (the libc/libm
// knowledge base). Idempotent: each attribute is added only when absent.
void clang_Sema_AddKnownFunctionAttributes(CXSema S, CXFunctionDecl FD);

// Gives a user-declared destructor with no exception specification the implicit one, by
// retyping it with an unevaluated exception spec. PRECONDITION: Destructor's type is a
// FunctionProtoType (reached with an unchecked castAs<>), which every C++ destructor has.
// A no-op once a specification is present, so it is idempotent.
void clang_Sema_AdjustDestructorExceptionSpec(CXSema S, CXCXXDestructorDecl Destructor);

// Declares every implicit special member of Class that is not declared yet, closing all
// six CXXRecordDecl::needsImplicit* gates. PRECONDITION: Class has a definition — each
// gate reads it.
void clang_Sema_ForceDeclarationOfImplicitMembers(CXSema S, CXCXXRecordDecl Class);

// The bodies of the implicitly-declared special members. Each call synthesizes the
// member's definition on a member that has so far only been declared and marks it used,
// so each one mutates the AST. PRECONDITIONS, all of which clang asserts on: the member
// is defaulted, is the special member the call names, does not already have a body, and
// is not deleted. A definition that would be ill-formed leaves the member invalid
// instead, reported through Sema's DiagnosticsEngine.
void clang_Sema_DefineImplicitDefaultConstructor(CXSema S, CXSourceLocation_ Loc,
                                                 CXCXXConstructorDecl Constructor);

void clang_Sema_DefineImplicitDestructor(CXSema S, CXSourceLocation_ Loc,
                                         CXCXXDestructorDecl Destructor);

void clang_Sema_DefineImplicitCopyConstructor(CXSema S, CXSourceLocation_ Loc,
                                              CXCXXConstructorDecl Constructor);

void clang_Sema_DefineImplicitMoveConstructor(CXSema S, CXSourceLocation_ Loc,
                                              CXCXXConstructorDecl Constructor);

void clang_Sema_DefineImplicitCopyAssignment(CXSema S, CXSourceLocation_ Loc,
                                             CXCXXMethodDecl MethodDecl);

void clang_Sema_DefineImplicitMoveAssignment(CXSema S, CXSourceLocation_ Loc,
                                             CXCXXMethodDecl MethodDecl);

// Defines every vtable used so far in the translation unit and marks the virtual members
// those vtables reference. True when any work was done.
bool clang_Sema_DefineUsedVTables(CXSema S);

// The parser's own end-of-class hook: declares the implicit special members that overload
// resolution already needs and bumps ASTContext's implicit-member statistics. The
// declarations stay gated by the needsImplicit* predicates, so a second call declares
// nothing new but does double-count those statistics. PRECONDITION: ClassDecl has a
// definition.
void clang_Sema_AddImplicitlyDeclaredMembersToClass(CXSema S, CXCXXRecordDecl ClassDecl);

// Sets MemberDecl's access. With a null PrevMemberDecl the lexical specifier LexicalAS is
// used and false is returned; otherwise the access must equal PrevMemberDecl's, and a
// mismatch is diagnosed and returns true (MemberDecl still takes LexicalAS).
bool clang_Sema_SetMemberAccessSpecifier(CXSema S, CXNamedDecl MemberDecl,
                                         CXNamedDecl PrevMemberDecl,
                                         CXAccessSpecifier LexicalAS);

// When *D is a TemplateDecl, replaces *D with its templated declaration and returns the
// TemplateDecl; otherwise leaves *D alone and returns null. D is a single in/out CXDecl
// slot, mirroring clang's `Decl *&` parameter.
CXTemplateDecl clang_Sema_AdjustDeclIfTemplate(CXSema S, CXDecl *D);

// Declares the implicit deduction guides of a class template unless they already exist.
// A no-op before C++17, for a Template that is not a class template, for one in a
// dependent context, and for one whose deduced type is incomplete.
void clang_Sema_DeclareImplicitDeductionGuides(CXSema S, CXTemplateDecl Template,
                                               CXSourceLocation_ Loc);

// Applies the `#pragma pack` / `#pragma options align` state in effect to RD. A no-op
// when no such pragma is active.
void clang_Sema_AddAlignmentAttributesForRecord(CXSema S, CXRecordDecl RD);

// Applies the `#pragma ms_struct` state in effect to RD. A no-op when it is off.
void clang_Sema_AddMsStructLayoutForRecord(CXSema S, CXRecordDecl RD);

// Applies the `#pragma GCC visibility` state in effect to D. A no-op when the visibility
// stack is empty or D already carries explicit visibility.
void clang_Sema_AddPushedVisibilityAttribute(CXSema S, CXDecl D);

// Adds `optnone` to FD when a range-based `#pragma clang optimize off` is in effect.
void clang_Sema_AddRangeBasedOptnone(CXSema S, CXFunctionDecl FD);

// Adds the code section named by an active `#pragma alloc_text` to FD. A no-op when FD
// has no identifier or no pragma names it.
void clang_Sema_AddSectionMSAllocText(CXSema S, CXFunctionDecl FD);

// Adds `optnone` — and the `noinline` it implies — to FD unless FD already carries a
// conflicting `minsize` / `always_inline`. Loc is the location blamed for the attribute.
void clang_Sema_AddOptnoneAttributeIfNoConflicts(CXSema S, CXFunctionDecl FD,
                                                 CXSourceLocation_ Loc);

// Adds `no_builtin` to FD for the names a range-based no_builtin pragma in scope covers.
// A no-op when no such pragma is in effect.
void clang_Sema_AddImplicitMSFunctionNoBuiltinAttr(CXSema S, CXFunctionDecl FD);

// --- Type builders (SemaType.cpp) ---
//
// Every builder below reports its ill-formed cases through Sema's DiagnosticsEngine and
// returns a null CXQualType, so a non-null result is always a well-formed type. `Entity`
// names the entity the type belongs to and is used only in those diagnostics; it may be
// null (an empty DeclarationName).

// BuildQualifiedType(QualType, SourceLocation, Qualifiers, const DeclSpec *) overload.
// Quals is a clang::Qualifiers opaque value (MARSHALLING.md section 7) — the same encoding
// clang_QualType_getQualifiersAsOpaqueValue returns and clang_Qualifiers_fromCVRMask
// builds. The trailing const DeclSpec * is always null here: a DeclSpec exists only while
// a declarator is being parsed.
CXQualType clang_Sema_BuildQualifiedType(CXSema S, CXQualType T, CXSourceLocation_ Loc,
                                         unsigned Quals);

// Precondition: T is not an Objective-C object type — Sema asserts on it, because such a
// type has to become an ObjCObjectPointerType instead.
CXQualType clang_Sema_BuildPointerType(CXSema S, CXQualType T, CXSourceLocation_ Loc,
                                       CXDeclarationName Entity);

// Precondition: T is not the unresolved-overload placeholder type (Sema asserts on it).
CXQualType clang_Sema_BuildReferenceType(CXSema S, CXQualType T, bool LValueRef,
                                         CXSourceLocation_ Loc, CXDeclarationName Entity);

// ArraySize may be null, which builds an incomplete array type. Quals is the index type's
// CVR qualifier mask, matching clang_ASTContext_getIncompleteArrayType. The Brackets
// SourceRange crosses decomposed into its two endpoints.
CXQualType clang_Sema_BuildArrayType(CXSema S, CXQualType T, CXArraySizeModifier ASM,
                                     CXExpr ArraySize, unsigned Quals,
                                     CXSourceLocation_ Brackets_begin,
                                     CXSourceLocation_ Brackets_end,
                                     CXDeclarationName Entity);

// VecSize is the vector's size in BYTES and must be an integer constant expression that is
// a whole multiple of T's size.
CXQualType clang_Sema_BuildVectorType(CXSema S, CXQualType T, CXExpr VecSize,
                                      CXSourceLocation_ AttrLoc);

// Unlike BuildVectorType, ArraySize is the ELEMENT COUNT of the ext_vector_type.
CXQualType clang_Sema_BuildExtVectorType(CXSema S, CXQualType T, CXExpr ArraySize,
                                         CXSourceLocation_ AttrLoc);

// Class must be a class (or dependent) type; Sema diagnoses anything else.
CXQualType clang_Sema_BuildMemberPointerType(CXSema S, CXQualType T, CXQualType Class,
                                             CXSourceLocation_ Loc,
                                             CXDeclarationName Entity);

// T must be a function type; Sema diagnoses anything else.
CXQualType clang_Sema_BuildBlockPointerType(CXSema S, CXQualType T, CXSourceLocation_ Loc,
                                            CXDeclarationName Entity);

CXQualType clang_Sema_BuildParenType(CXSema S, CXQualType T);

CXQualType clang_Sema_BuildAtomicType(CXSema S, CXQualType T, CXSourceLocation_ Loc);

// The OpenCL `read_only pipe` / `write_only pipe` types whose element type is T.
CXQualType clang_Sema_BuildReadPipeType(CXSema S, CXQualType T, CXSourceLocation_ Loc);

CXQualType clang_Sema_BuildWritePipeType(CXSema S, CXQualType T, CXSourceLocation_ Loc);

// BitWidth must be an integer constant expression.
CXQualType clang_Sema_BuildBitIntType(CXSema S, bool IsUnsigned, CXExpr BitWidth,
                                      CXSourceLocation_ Loc);

// Precondition: E does not have a placeholder type (Sema asserts on it).
CXQualType clang_Sema_BuildTypeofExprType(CXSema S, CXExpr E, CXTypeOfKind Kind);

// Precondition: E does not have a placeholder type (Sema asserts on it).
CXQualType clang_Sema_BuildDecltypeType(CXSema S, CXExpr E, bool AsUnevaluated);

CXQualType clang_Sema_BuildUnaryTransformType(CXSema S, CXQualType BaseType,
                                              CXUTTKind UKind, CXSourceLocation_ Loc);

// --- Unary type-transform trait implementations ---
//
// The individual transforms clang_Sema_BuildUnaryTransformType dispatches to, i.e. the
// bodies of __underlying_type / __add_pointer / __remove_reference and friends. A
// transform that cannot apply comes back as a null QualType after Sema has reported it
// through its DiagnosticsEngine. UKind names which spelling of a shared transform is
// meant; it also picks the diagnostic, so a kind from a different family is a misuse
// rather than a variant, and the Julia wrapper asserts the family.

// BaseType must be a complete enumeration type; anything else is diagnosed.
CXQualType clang_Sema_BuiltinEnumUnderlyingType(CXSema S, CXQualType BaseType,
                                                CXSourceLocation_ Loc);

// Total: a type no pointer can be formed to comes back unchanged.
CXQualType clang_Sema_BuiltinAddPointer(CXSema S, CXQualType BaseType,
                                        CXSourceLocation_ Loc);

// Total: a non-pointer comes back unchanged.
CXQualType clang_Sema_BuiltinRemovePointer(CXSema S, CXQualType BaseType,
                                           CXSourceLocation_ Loc);

// Total: the array-to-pointer / function-to-pointer decay of BaseType.
CXQualType clang_Sema_BuiltinDecay(CXSema S, CXQualType BaseType, CXSourceLocation_ Loc);

// UKind selects the lvalue or the rvalue spelling (CXUTTKind_AddLvalueReference or
// CXUTTKind_AddRvalueReference). C++ only — clang asserts LangOptions::CPlusPlus, which
// is observable through clang_LangOptions_getCPlusPlus.
CXQualType clang_Sema_BuiltinAddReference(CXSema S, CXQualType BaseType, CXUTTKind UKind,
                                          CXSourceLocation_ Loc);

// UKind is CXUTTKind_RemoveExtent or CXUTTKind_RemoveAllExtents.
CXQualType clang_Sema_BuiltinRemoveExtent(CXSema S, CXQualType BaseType, CXUTTKind UKind,
                                          CXSourceLocation_ Loc);

// UKind is CXUTTKind_RemoveReference or CXUTTKind_RemoveCVRef.
CXQualType clang_Sema_BuiltinRemoveReference(CXSema S, CXQualType BaseType, CXUTTKind UKind,
                                             CXSourceLocation_ Loc);

// UKind is one of CXUTTKind_RemoveConst, CXUTTKind_RemoveCV, CXUTTKind_RemoveRestrict
// and CXUTTKind_RemoveVolatile.
CXQualType clang_Sema_BuiltinChangeCVRQualifiers(CXSema S, CXQualType BaseType,
                                                 CXUTTKind UKind, CXSourceLocation_ Loc);

// UKind is CXUTTKind_MakeSigned or CXUTTKind_MakeUnsigned. BaseType must be an integral
// or enumeration type; clang still diagnoses the cases the traits exclude, such as bool.
CXQualType clang_Sema_BuiltinChangeSignedness(CXSema S, CXQualType BaseType,
                                              CXUTTKind UKind, CXSourceLocation_ Loc);

// --- Expression builders ---
//
// clang::ExprResult is a discriminated (invalid, value) pair, so it crosses split
// (MARSHALLING.md section 8): the discriminator is the *IsInvalid out-parameter and the
// payload is the returned CXExpr. A null return with *IsInvalid == false is a valid but
// empty result, which is NOT the same as an error. Every node built here is
// ASTContext-arena memory — nothing is caller-owned and nothing has a dispose.

CXExpr clang_Sema_CreateBuiltinUnaryOp(CXSema S, CXSourceLocation_ OpLoc,
                                       CXUnaryOperatorKind Opc, CXExpr InputExpr,
                                       bool IsAfterAmp, bool *IsInvalid);

// CreateUnaryExprOrTypeTraitExpr(TypeSourceInfo *, ...) overload — sizeof/alignof over a
// type. R is the operand's source range, decomposed into its two endpoints.
CXExpr clang_Sema_CreateUnaryExprOrTypeTraitExpr(CXSema S, CXTypeSourceInfo TInfo,
                                                 CXSourceLocation_ OpLoc,
                                                 CXUnaryExprOrTypeTrait ExprKind,
                                                 CXSourceLocation_ R_begin,
                                                 CXSourceLocation_ R_end, bool *IsInvalid);

CXExpr clang_Sema_CreateBuiltinArraySubscriptExpr(CXSema S, CXExpr Base,
                                                  CXSourceLocation_ LLoc, CXExpr Idx,
                                                  CXSourceLocation_ RLoc, bool *IsInvalid);

CXExpr clang_Sema_CreateBuiltinBinOp(CXSema S, CXSourceLocation_ OpLoc,
                                     CXBinaryOperatorKind Opc, CXExpr LHSExpr,
                                     CXExpr RHSExpr, bool *IsInvalid);

// InitArgList crosses as a (handle buffer, count) pair rebuilt into the MultiExprArg clang
// wants (MARSHALLING.md section 11). The InitListExpr copies the pointers into its own
// ASTContext storage, so the buffer need not outlive the call.
CXExpr clang_Sema_BuildInitList(CXSema S, CXSourceLocation_ LBraceLoc,
                                const CXExpr *InitArgList, unsigned NumInits,
                                CXSourceLocation_ RBraceLoc, bool *IsInvalid);

CXExpr clang_Sema_BuildCXXNoexceptExpr(CXSema S, CXSourceLocation_ KeyLoc, CXExpr Operand,
                                       CXSourceLocation_ RParen, bool *IsInvalid);

// --- Declaration, expression and trait node builders ---
//
// The clang::ExprResult convention above holds throughout: the *IsInvalid out-parameter is
// the discriminator and the returned CXExpr is the payload (MARSHALLING.md section 8). The
// builders whose C++ return type is a node pointer rather than a *Result
// (BuildParmVarDeclForTypedef, BuildDeclRefExpr, CreateMaterializeTemporaryExpr,
// BuildStaticAssertDeclaration) carry no discriminator and use nullptr for failure. Every
// node built here is ASTContext-arena memory — nothing is caller-owned.

// Creates an implicit, unnamed parameter of type T in DC. The parameter is not attached to
// any function.
CXParmVarDecl clang_Sema_BuildParmVarDeclForTypedef(CXSema S, CXDeclContext DC,
                                                    CXSourceLocation_ Loc, CXQualType T);

// SubExprs crosses as a (handle buffer, count) pair rebuilt into the ArrayRef clang wants
// (MARSHALLING.md section 11). T may be a null CXQualType, matching the defaulted
// QualType() parameter. Sema yields an invalid result unless LangOptions::RecoveryAST is
// enabled.
CXExpr clang_Sema_CreateRecoveryExpr(CXSema S, CXSourceLocation_ Begin,
                                     CXSourceLocation_ End, const CXExpr *SubExprs,
                                     unsigned NumSubExprs, CXQualType T, bool *IsInvalid);

// The (ValueDecl *, QualType, ExprValueKind, SourceLocation, const CXXScopeSpec *)
// overload. SS may be null. Marks D referenced in Sema's current context.
CXDeclRefExpr clang_Sema_BuildDeclRefExpr(CXSema S, CXValueDecl D, CXQualType Ty,
                                          CXExprValueKind VK, CXSourceLocation_ Loc,
                                          CXCXXScopeSpec SS);

// Sp may be null; it is consulted only to look up overloaded operator candidates, so a
// null scope restricts the result to the built-in operator.
CXExpr clang_Sema_BuildUnaryOp(CXSema S, CXScope Sp, CXSourceLocation_ OpLoc,
                               CXUnaryOperatorKind Opc, CXExpr Input, bool IsAfterAmp,
                               bool *IsInvalid);

// ArgExprs crosses as a (handle buffer, count) pair. Sp and ExecConfig may be null.
CXExpr clang_Sema_BuildCallExpr(CXSema S, CXScope Sp, CXExpr Fn,
                                CXSourceLocation_ LParenLoc, const CXExpr *ArgExprs,
                                unsigned NumArgs, CXSourceLocation_ RParenLoc,
                                CXExpr ExecConfig, bool IsExecConfig, bool AllowRecovery,
                                bool *IsInvalid);

CXExpr clang_Sema_BuildCStyleCastExpr(CXSema S, CXSourceLocation_ LParenLoc,
                                      CXTypeSourceInfo Ty, CXSourceLocation_ RParenLoc,
                                      CXExpr Op, bool *IsInvalid);

// Sp may be null, with the same effect as in clang_Sema_BuildUnaryOp.
CXExpr clang_Sema_BuildBinOp(CXSema S, CXScope Sp, CXSourceLocation_ OpLoc,
                             CXBinaryOperatorKind Opc, CXExpr LHSExpr, CXExpr RHSExpr,
                             bool *IsInvalid);

// __builtin_astype: Sema rejects a DestTy whose size differs from E's type.
CXExpr clang_Sema_BuildAsTypeExpr(CXSema S, CXExpr E, CXQualType DestTy,
                                  CXSourceLocation_ BuiltinLoc, CXSourceLocation_ RParenLoc,
                                  bool *IsInvalid);

// __builtin_bit_cast: Sema rejects operand and destination types that are not trivially
// copyable or whose sizes differ.
CXExpr clang_Sema_BuildBuiltinBitCastExpr(CXSema S, CXSourceLocation_ KWLoc,
                                          CXTypeSourceInfo TSI, CXExpr Operand,
                                          CXSourceLocation_ RParenLoc, bool *IsInvalid);

// The value of a unary fold over an empty pack. [temp.variadic]p9 gives one only to
// BO_LAnd, BO_LOr and BO_Comma; every other opcode is diagnosed and yields an invalid
// result.
CXExpr clang_Sema_BuildEmptyCXXFoldExpr(CXSema S, CXSourceLocation_ EllipsisLoc,
                                        CXBinaryOperatorKind Operator, bool *IsInvalid);

// T(exprs) / T{exprs}. Exprs crosses as a (handle buffer, count) pair.
CXExpr clang_Sema_BuildCXXTypeConstructExpr(CXSema S, CXTypeSourceInfo Type,
                                            CXSourceLocation_ LParenLoc,
                                            const CXExpr *Exprs, unsigned NumExprs,
                                            CXSourceLocation_ RParenLoc,
                                            bool ListInitialization, bool *IsInvalid);

// Args crosses as a (handle buffer, count) pair. Precondition: NumArgs is at least 1 —
// Sema reads Args[0] unconditionally for the unary traits — and matches the arity Kind
// declares.
CXExpr clang_Sema_BuildTypeTrait(CXSema S, CXTypeTrait Kind, CXSourceLocation_ KWLoc,
                                 const CXTypeSourceInfo *Args, unsigned NumArgs,
                                 CXSourceLocation_ RParenLoc, bool *IsInvalid);

// Precondition: DimExpr is non-null when ATT is CXArrayTypeTrait_ATT_ArrayExtent — Sema
// evaluates it as an integer constant expression without a null check.
// CXArrayTypeTrait_ATT_ArrayRank ignores DimExpr, so a null one is fine there.
CXExpr clang_Sema_BuildArrayTypeTrait(CXSema S, CXArrayTypeTrait ATT,
                                      CXSourceLocation_ KWLoc, CXTypeSourceInfo TSInfo,
                                      CXExpr DimExpr, CXSourceLocation_ RParen,
                                      bool *IsInvalid);

CXExpr clang_Sema_BuildExpressionTrait(CXSema S, CXExpressionTrait OET,
                                       CXSourceLocation_ KWLoc, CXExpr Queried,
                                       CXSourceLocation_ RParen, bool *IsInvalid);

// Marks Sema's current full-expression as needing cleanups when T is a class type with a
// non-trivial destructor.
CXMaterializeTemporaryExpr
clang_Sema_CreateMaterializeTemporaryExpr(CXSema S, CXQualType T, CXExpr Temporary,
                                          bool BoundToLvalueReference);

// AssertMessageExpr may be null (the C++17 one-argument form). The new StaticAssertDecl is
// added to Sema's current DeclContext.
CXDecl clang_Sema_BuildStaticAssertDeclaration(CXSema S, CXSourceLocation_ StaticAssertLoc,
                                               CXExpr AssertExpr, CXExpr AssertMessageExpr,
                                               CXSourceLocation_ RParenLoc, bool Failed);

// Precondition: Arg is a *non-type* template argument. Sema's switch reaches
// llvm_unreachable for the Null/Type/Template/TemplateExpansion/Pack kinds, which aborts
// the process rather than returning an invalid result.
CXExpr clang_Sema_BuildExpressionFromNonTypeTemplateArgument(CXSema S,
                                                             CXTemplateArgument Arg,
                                                             CXSourceLocation_ Loc,
                                                             bool *IsInvalid);

CXExpr clang_Sema_BuildCXXFunctionalCastExpr(CXSema S, CXTypeSourceInfo TInfo,
                                             CXQualType Type, CXSourceLocation_ LParenLoc,
                                             CXExpr CastExpr, CXSourceLocation_ RParenLoc,
                                             bool *IsInvalid);

// --- Name, offsetof and instantiation-rebuild node builders ---
//
// Declared in the order clang::Sema declares them. The clang::ExprResult convention above
// holds throughout: the *IsInvalid out-parameter is the discriminator and the returned
// CXExpr is the payload (MARSHALLING.md section 8). Every node built here is
// ASTContext-arena memory — nothing is caller-owned.

// Two of the builders below carry no ExprResult discriminator:
// clang_Sema_BuildExceptionDeclaration returns a node pointer that is null on failure, and
// clang_Sema_BuildDeclaratorGroup returns a value encoding that is never null.

// Packages Group into the DeclGroupRef a declarator list produces, after checking that
// every deduced type in the group agrees. Group crosses as a (handle buffer, count) pair
// rebuilt into the MutableArrayRef clang wants (MARSHALLING.md section 11); the
// DeclGroupPtrTy return crosses as the DeclGroupRef opaque encoding inside it.
CXDeclGroupRef clang_Sema_BuildDeclaratorGroup(CXSema S, const CXDecl *Group,
                                               unsigned NumDecls);

// The (Expr *, SourceLocation) overload. Finishes Arg as a full expression at CC — the
// conversions, cleanup bookkeeping and completeness checks clang runs at the end of every
// full expression. clang::Sema::FullExprArg is a value wrapper around a single Expr *, so
// it crosses as that pointer (MARSHALLING.md section 7). Null when Sema rejected Arg.
CXExpr clang_Sema_MakeFullExpr(CXSema S, CXExpr Arg, CXSourceLocation_ CC);

// As clang_Sema_MakeFullExpr, but finishes Arg as an expression whose value is discarded,
// at Arg's own expression location.
CXExpr clang_Sema_MakeFullDiscardedValueExpr(CXSema S, CXExpr Arg);

// The variable a `catch (T name)` clause declares, marked as an exception variable. Id may
// be null, the unnamed-handler form. The declaration is created in Sema's current context
// but is not added to it. Null when the exception type was rejected.
CXVarDecl clang_Sema_BuildExceptionDeclaration(CXSema S, CXScope Sp, CXTypeSourceInfo TInfo,
                                               CXSourceLocation_ StartLoc,
                                               CXSourceLocation_ IdLoc,
                                               CXIdentifierInfo Id);

// __builtin_sycl_unique_stable_name(T). The result type is `const char *` whatever the
// language mode is.
CXExpr clang_Sema_BuildSYCLUniqueStableNameExpr(CXSema S, CXSourceLocation_ OpLoc,
                                                CXSourceLocation_ LParen,
                                                CXSourceLocation_ RParen,
                                                CXTypeSourceInfo TSI, bool *IsInvalid);

// `BaseExpr.Field` (IsArrow false) or `BaseExpr->Field` (IsArrow true) for an already
// resolved FieldDecl. clang::DeclAccessPair is a value aggregate with no handle, so it
// crosses as its two fields (MARSHALLING.md section 7): FoundDecl plus the access it was
// found with. SS may be an unset CXXScopeSpec, the ordinary unqualified case.
CXExpr clang_Sema_BuildFieldReferenceExpr(CXSema S, CXExpr BaseExpr, bool IsArrow,
                                          CXSourceLocation_ OpLoc, CXCXXScopeSpec SS,
                                          CXFieldDecl Field, CXNamedDecl FoundDecl,
                                          CXAccessSpecifier FoundAccess,
                                          CXDeclarationNameInfo MemberNameInfo,
                                          bool *IsInvalid);

// The compound literal `(T){...}`, initializing an object of the type TInfo names from
// LiteralExpr. Null when the initialization was rejected.
CXExpr clang_Sema_BuildCompoundLiteralExpr(CXSema S, CXSourceLocation_ LParenLoc,
                                           CXTypeSourceInfo TInfo,
                                           CXSourceLocation_ RParenLoc, CXExpr LiteralExpr,
                                           bool *IsInvalid);

// __builtin_va_arg(E, T). Sema requires E to have the target's va_list type; anything else
// is diagnosed and comes back as an invalid result.
CXExpr clang_Sema_BuildVAArgExpr(CXSema S, CXSourceLocation_ BuiltinLoc, CXExpr E,
                                 CXTypeSourceInfo TInfo, CXSourceLocation_ RPLoc,
                                 bool *IsInvalid);

// static_cast / dynamic_cast / const_cast / reinterpret_cast / addrspace_cast. Kind is a
// raw clang::tok::TokenKind value, as in Basic/CXTokenKinds.h — obtain it with
// clang_IdentifierInfo_getTokenID. Precondition: Kind is one of those five keywords;
// clang's switch over it ends in llvm_unreachable, which aborts the process. The two
// SourceRange parameters are decomposed into their endpoints, as elsewhere in this file.
CXExpr clang_Sema_BuildCXXNamedCast(CXSema S, CXSourceLocation_ OpLoc, unsigned Kind,
                                    CXTypeSourceInfo Ty, CXExpr E,
                                    CXSourceLocation_ AngleBracketsBegin,
                                    CXSourceLocation_ AngleBracketsEnd,
                                    CXSourceLocation_ ParensBegin,
                                    CXSourceLocation_ ParensEnd, bool *IsInvalid);

// typeid(T) — the TypeSourceInfo overload. TypeInfoType becomes the const-qualified type
// of the resulting expression and is stored unchecked; clang's parser passes the
// std::type_info it looked up in the current scope.
CXExpr clang_Sema_BuildCXXTypeId(CXSema S, CXQualType TypeInfoType,
                                 CXSourceLocation_ TypeidLoc, CXTypeSourceInfo Operand,
                                 CXSourceLocation_ RParenLoc, bool *IsInvalid);

// Re-expresses the template argument Arg as the expression that denotes the declaration it
// names, converted to ParamType. Precondition: Arg's kind is Declaration — clang asserts
// it.
CXExpr clang_Sema_BuildExpressionFromDeclTemplateArgument(CXSema S, CXTemplateArgument Arg,
                                                          CXQualType ParamType,
                                                          CXSourceLocation_ Loc,
                                                          bool *IsInvalid);

// clang/Sema/Sema.h: enum Sema::CCEKind
typedef enum CXCCEKind {
  CXCCEKind_CCEK_CaseValue,
  CXCCEKind_CCEK_Enumerator,
  CXCCEKind_CCEK_TemplateArg,
  CXCCEKind_CCEK_ArrayBound,
  CXCCEKind_CCEK_ExplicitBool,
  CXCCEKind_CCEK_Noexcept,
  CXCCEKind_CCEK_StaticAssertMessageSize,
  CXCCEKind_CCEK_StaticAssertMessageData
} CXCCEKind;

// ParamTypes is an IN/OUT (handle buffer, count) pair: clang takes a
// MutableArrayRef<QualType> and rewrites every entry with the adjusted parameter type, so
// the shim decodes the buffer into a local vector, calls, and writes the adjusted encodings
// back into the caller's buffer (MARSHALLING.md section 11). Entity may be a null
// CXDeclarationName. The ExtProtoInfo is flattened to the same variadic +
// calling-convention subset as clang_ASTContext_getFunctionType. A null CXQualType comes
// back when a parameter type was rejected.
CXQualType clang_Sema_BuildFunctionType(CXSema S, CXQualType T, CXQualType *ParamTypes,
                                        unsigned NumParams, CXSourceLocation_ Loc,
                                        CXDeclarationName Entity, bool IsVariadic,
                                        CXCallingConv_ CC);

// Dest may be null (clang's default argument); it names the entity being initialized and is
// used only for diagnostics.
CXExpr clang_Sema_BuildConvertedConstantExpression(CXSema S, CXExpr From, CXQualType T,
                                                   CXCCEKind CCE, CXNamedDecl Dest,
                                                   bool *IsInvalid);

// The (const CXXScopeSpec &, LookupResult &, bool, bool) overload: a DeclRefExpr for a
// single fully-resolved result, an UnresolvedLookupExpr otherwise. SS may be an unset
// CXXScopeSpec, which is the ordinary unqualified case.
CXExpr clang_Sema_BuildDeclarationNameExpr(CXSema S, CXCXXScopeSpec SS, CXLookupResult R,
                                           bool NeedsADL, bool AcceptInvalidDecl,
                                           bool *IsInvalid);

// __func__ and its siblings. Outside a function body clang emits an extension diagnostic
// and falls back to the translation unit as the enclosing declaration.
CXExpr clang_Sema_BuildPredefinedExpr(CXSema S, CXSourceLocation_ Loc,
                                      CXPredefinedIdentKind IK, bool *IsInvalid);

// __builtin_offsetof(T, a.b[i].c). The ArrayRef<Sema::OffsetOfComponent> crosses as
// parallel component arrays (MARSHALLING.md section 11): one C array per field of the
// aggregate, all read in lockstep against NumComponents. IsBrackets[I] selects the union
// arm — true takes Indices[I] (the `[expr]` subscript), false takes Idents[I] (the
// `.member` name); the unused array's slot at that index is ignored and may be null.
// Precondition: NumComponents is at least 1 with IsBrackets[0] false — clang assumes the
// first component is a field designator — and TInfo names a record or dependent type.
CXExpr clang_Sema_BuildBuiltinOffsetOf(
    CXSema S, CXSourceLocation_ BuiltinLoc, CXTypeSourceInfo TInfo,
    const CXSourceLocation_ *LocStarts, const CXSourceLocation_ *LocEnds,
    const bool *IsBrackets, const CXIdentifierInfo *Idents, const CXExpr *Indices,
    unsigned NumComponents, CXSourceLocation_ RParenLoc, bool *IsInvalid);

// __builtin_LINE() / __builtin_FILE() / __builtin_source_location() and friends.
// ParentContext may be null. ResultTy is stored unchecked, so it must be the type the kind
// implies: an integer for Line/Column, `const char *` for File/FileName/Function/FuncSig,
// the std::source_location implementation type for SourceLocStruct.
CXExpr clang_Sema_BuildSourceLocExpr(CXSema S, CXSourceLocIdentKind Kind,
                                     CXQualType ResultTy, CXSourceLocation_ BuiltinLoc,
                                     CXSourceLocation_ RParenLoc,
                                     CXDeclContext ParentContext, bool *IsInvalid);

// Ex may be null, which builds the re-throw form. Sema diagnoses the throw when C++
// exceptions are disabled and copy-initializes the exception object from Ex otherwise.
CXExpr clang_Sema_BuildCXXThrow(CXSema S, CXSourceLocation_ OpLoc, CXExpr Ex,
                                bool IsThrownVarInScope, bool *IsInvalid);

// TemplateArgs may be null. Precondition: R is not an ambiguous lookup result, and
// TemplateArgs is non-null or TemplateKWLoc is valid — clang asserts both.
CXExpr clang_Sema_BuildTemplateIdExpr(CXSema S, CXCXXScopeSpec SS,
                                      CXSourceLocation_ TemplateKWLoc, CXLookupResult R,
                                      bool RequiresADL,
                                      CXTemplateArgumentListInfo TemplateArgs,
                                      bool *IsInvalid);

// Returns T unchanged when T's type is not instantiation-dependent; otherwise rebuilds it
// against Sema's current instantiation. Name may be a null CXDeclarationName.
CXTypeSourceInfo clang_Sema_RebuildTypeInCurrentInstantiation(CXSema S, CXTypeSourceInfo T,
                                                              CXSourceLocation_ Loc,
                                                              CXDeclarationName Name);

// SS is an in/out parameter, adopted from the rebuilt qualifier on success. Returns true on
// failure, which includes an unset SS.
bool clang_Sema_RebuildNestedNameSpecifierInCurrentInstantiation(CXSema S,
                                                                 CXCXXScopeSpec SS);

CXExpr clang_Sema_RebuildExprInCurrentInstantiation(CXSema S, CXExpr E, bool *IsInvalid);

// Rewrites the type of every non-type parameter of Params in place. Returns true on
// failure.
bool clang_Sema_RebuildTemplateParamsInCurrentInstantiation(CXSema S,
                                                            CXTemplateParameterList Params);

// --- ODR-use marking, `auto` substitution and template-parameter deduction ---
//
// Declared in the order clang::Sema declares them. Every entry point below can be
// driven from outside the parser: none of them needs an active
// Sema::InstantiatingTemplate. The Subst*/Instantiate* overloads that take a
// MultiLevelTemplateArgumentList do (Sema asserts its CodeSynthesisContexts stack
// is non-empty) and are deliberately not wrapped.

// A no-op unless Sema::ShouldWarnIfUnusedFileScopedDecl(D) holds.
void clang_Sema_MarkUnusedFileScopedDecl(CXSema S, CXDeclaratorDecl D);

// Marks D referenced, dispatching on D's kind. MightBeOdrUse should normally be
// true; pass false only when the lack of an odr-use cannot be determined from the
// current context.
void clang_Sema_MarkAnyDeclReferenced(CXSema S, CXSourceLocation_ Loc, CXDecl D,
                                      bool MightBeOdrUse);

void clang_Sema_MarkFunctionReferenced(CXSema S, CXSourceLocation_ Loc, CXFunctionDecl Func,
                                       bool MightBeOdrUse);

void clang_Sema_MarkVariableReferenced(CXSema S, CXSourceLocation_ Loc, CXVarDecl Var);

// T must be a non-null QualType.
void clang_Sema_MarkDeclarationsReferencedInType(CXSema S, CXSourceLocation_ Loc,
                                                 CXQualType T);

// Precondition: Record has a definition — the walk visits its bases and fields.
void clang_Sema_MarkBaseAndMemberDestructorsReferenced(CXSema S, CXSourceLocation_ Loc,
                                                       CXCXXRecordDecl Record);

// Precondition: Class has a definition — the first thing Sema reads is
// isDynamicClass(), which goes through CXXRecordDecl::data(). Non-polymorphic and
// dependent classes are then ignored by Sema itself.
void clang_Sema_MarkVTableUsed(CXSema S, CXSourceLocation_ Loc, CXCXXRecordDecl Class,
                               bool DefinitionRequired);

// Precondition: RD has a definition (its methods are iterated).
void clang_Sema_MarkVirtualMemberExceptionSpecsNeeded(CXSema S, CXSourceLocation_ Loc,
                                                      CXCXXRecordDecl RD);

// Precondition: RD has a definition (its methods are iterated).
void clang_Sema_MarkVirtualMembersReferenced(CXSema S, CXSourceLocation_ Loc,
                                             CXCXXRecordDecl RD, bool ConstexprOnly);

// Checks Arg as a template *type* argument. Returns true when it is invalid,
// having emitted a diagnostic into Sema's DiagnosticsEngine.
bool clang_Sema_CheckTemplateArgument(CXSema S, CXTypeSourceInfo Arg);

// Substitutes Replacement for the `auto` in TypeWithAuto, retaining the `auto`
// sugar. Both must be non-null QualTypes.
CXQualType clang_Sema_SubstAutoType(CXSema S, CXQualType TypeWithAuto,
                                    CXQualType Replacement);

CXTypeSourceInfo clang_Sema_SubstAutoTypeSourceInfo(CXSema S, CXTypeSourceInfo TypeWithAuto,
                                                    CXQualType Replacement);

// Substitutes a dependent `auto` type for the `auto` in TypeWithAuto.
CXQualType clang_Sema_SubstAutoTypeDependent(CXSema S, CXQualType TypeWithAuto);

CXTypeSourceInfo clang_Sema_SubstAutoTypeSourceInfoDependent(CXSema S,
                                                             CXTypeSourceInfo TypeWithAuto);

// Completely replaces the `auto` in TypeWithAuto with Replacement, dropping the `auto`
// sugar that clang_Sema_SubstAutoType retains. Both must be non-null QualTypes.
CXQualType clang_Sema_ReplaceAutoType(CXSema S, CXQualType TypeWithAuto,
                                      CXQualType Replacement);

CXTypeSourceInfo clang_Sema_ReplaceAutoTypeSourceInfo(CXSema S,
                                                      CXTypeSourceInfo TypeWithAuto,
                                                      CXQualType Replacement);

// Deduces FD's return type, instantiating its body when FD is a template
// instantiation. Returns true when deduction failed. Precondition: FD's return
// type is still an undeduced `auto`.
bool clang_Sema_DeduceReturnType(CXSema S, CXFunctionDecl FD, CXSourceLocation_ Loc,
                                 bool Diagnose);

// Count+fill; the SmallBitVector sizes itself inside Sema, so the count comes from
// clang_TemplateParameterList_size(clang_TemplateDecl_getTemplateParameters(FTD)).
// Slot I is set when template parameter I of FTD is deducible from the templated
// function's parameter types. N is the caller buffer's capacity and the fill stops
// at min(N, number of template parameters).
void clang_Sema_MarkDeducedTemplateParameters(CXSema S, CXFunctionTemplateDecl FTD,
                                              bool *Deduced, unsigned N);

// Precondition: Param->hasUninstantiatedDefaultArg(). Returns true on error.
bool clang_Sema_InstantiateDefaultArgument(CXSema S, CXSourceLocation_ CallLoc,
                                           CXFunctionDecl FD, CXParmVarDecl Param);

// Precondition: Function's type is a FunctionProtoType (Sema reaches it with an
// unchecked castAs<>). A no-op unless the exception spec is still uninstantiated.
void clang_Sema_InstantiateExceptionSpec(CXSema S, CXSourceLocation_ PointOfInstantiation,
                                         CXFunctionDecl Function);

// Instantiates — or finds the existing instantiation of — FTD with Args, producing
// the function declaration only; the body comes from
// clang_Sema_InstantiateFunctionDefinition. Args must be a converted argument list
// holding one argument per template parameter of FTD. Null on substitution failure.
CXFunctionDecl clang_Sema_InstantiateFunctionDeclaration(CXSema S,
                                                         CXFunctionTemplateDecl FTD,
                                                         CXTemplateArgumentList Args,
                                                         CXSourceLocation_ Loc);

// --- Driving a substitution from outside the parser ---
//
// Sema::SubstType and its siblings assert that Sema's code-synthesis stack is non-empty:
// substituting only means anything inside an instantiation. That stack entry is pushed by
// clang::Sema::InstantiatingTemplate, an RAII sentinel, so exporting the sentinel is what
// makes the whole Subst* family reachable from outside the parser (MARSHALLING.md §13,
// "export the operation that establishes the state").

// helper: the depth of Sema::CodeSynthesisContexts. This is the gate every Subst* below
// asserts on, exported so the Julia wrapper can reject the call instead of tripping
// clang's own assert.
unsigned clang_Sema_getNumCodeSynthesisContexts(CXSema S);

// The handle is a caller-owned heap box holding the sentinel;
// clang_InstantiatingTemplate_dispose runs its destructor, which pops the stack's back(),
// so nested sentinels must be disposed in reverse construction order. InstantiationRange
// may be a pair of null CXSourceLocation_ (clang's own default).
CXInstantiatingTemplate
clang_InstantiatingTemplate_create(CXSema S, CXSourceLocation_ PointOfInstantiation,
                                   CXDecl Entity, CXSourceRange_ InstantiationRange);

void clang_InstantiatingTemplate_dispose(CXInstantiatingTemplate Inst);

// Pops the code-synthesis record this sentinel pushed, which is what
// clang_InstantiatingTemplate_dispose does through the destructor. The method guards on its
// own flag, so calling it twice -- and disposing an already-cleared sentinel -- leaves
// clang_Sema_getNumCodeSynthesisContexts at the value it had before construction. A cleared
// sentinel is spent: no Subst* entry point may run under it afterwards.
void clang_InstantiatingTemplate_Clear(CXInstantiatingTemplate Inst);

// True when construction exceeded the maximum recursive instantiation depth, in which case
// nothing was pushed and no substitution may be attempted under this sentinel.
bool clang_InstantiatingTemplate_isInvalid(CXInstantiatingTemplate Inst);

// True when a surrounding active instantiation is already instantiating this same
// specialization.
bool clang_InstantiatingTemplate_isAlreadyInstantiating(CXInstantiatingTemplate Inst);

// The Subst* family rebuilds an AST node with TemplateArgs substituted for the template
// parameters it mentions. Every entry point below needs a live CXInstantiatingTemplate and
// reads TemplateArgs out of a MultiLevelTemplateArgumentList box
// (clang-ex/Sema/CXTemplate.h).

// The TypeSourceInfo overload of Sema::SubstType, disambiguated by the same SourceInfo
// suffix as clang_Sema_SubstAutoTypeSourceInfo. Entity may be a null CXDeclarationName; it
// only names the entity being substituted into in a diagnostic. Null on failure.
CXTypeSourceInfo clang_Sema_SubstTypeSourceInfo(
    CXSema S, CXTypeSourceInfo T, CXMultiLevelTemplateArgumentList TemplateArgs,
    CXSourceLocation_ Loc, CXDeclarationName Entity, bool AllowDeducedTST);

// The QualType overload. A null QualType comes back when substitution failed.
CXQualType clang_Sema_SubstType(CXSema S, CXQualType T,
                                CXMultiLevelTemplateArgumentList TemplateArgs,
                                CXSourceLocation_ Loc, CXDeclarationName Entity);

// *IsInvalid receives the ExprResult's error bit; the return is null in that case.
CXExpr clang_Sema_SubstExpr(CXSema S, CXExpr E,
                            CXMultiLevelTemplateArgumentList TemplateArgs, bool *IsInvalid);

// SubstExpr with constraint satisfaction checked — the form to use at constraint-checking
// time.
CXExpr clang_Sema_SubstConstraintExpr(CXSema S, CXExpr E,
                                      CXMultiLevelTemplateArgumentList TemplateArgs,
                                      bool *IsInvalid);

// The same, leaving constraint satisfaction unevaluated.
CXExpr clang_Sema_SubstConstraintExprWithoutSatisfaction(
    CXSema S, CXExpr E, CXMultiLevelTemplateArgumentList TemplateArgs, bool *IsInvalid);

CXStmt clang_Sema_SubstStmt(CXSema S, CXStmt St,
                            CXMultiLevelTemplateArgumentList TemplateArgs, bool *IsInvalid);

// SubstExpr for an initializer; CXXDirectInit selects the `T x(a)` reading over `T x = a`.
CXExpr clang_Sema_SubstInitializer(CXSema S, CXExpr E,
                                   CXMultiLevelTemplateArgumentList TemplateArgs,
                                   bool CXXDirectInit, bool *IsInvalid);

// clang::NestedNameSpecifierLoc is a by-value class, so the result is an owned box released
// with clang_NestedNameSpecifierLoc_dispose. An empty qualifier substitutes to an empty
// one.
CXNestedNameSpecifierLoc
clang_Sema_SubstNestedNameSpecifierLoc(CXSema S, CXNestedNameSpecifierLoc NNS,
                                       CXMultiLevelTemplateArgumentList TemplateArgs);

// clang::DeclarationNameInfo likewise has no pointer form, so the parameter and the result
// are both boxes (MARSHALLING.md §7); the returned box is owned and must be released with
// clang_DeclarationNameInfo_dispose.
CXDeclarationNameInfo
clang_Sema_SubstDeclarationNameInfo(CXSema S, CXDeclarationNameInfo NameInfo,
                                    CXMultiLevelTemplateArgumentList TemplateArgs);

// Module scope, macro spelling, and the pure type/parameter relationship queries.

// The block-scope `extern "C"` declaration named Name. Sema keeps these in a side
// table rather than in the translation unit, so a qualified lookup does not find
// them. Null when no such declaration was seen.
CXNamedDecl clang_Sema_findLocallyScopedExternCDecl(CXSema S, CXDeclarationName Name);

// In/out. Returns true only when *Loc is a macro location whose expansion location is
// spelled exactly Name, and only then overwrites *Loc with that expansion location;
// *Loc is untouched on a false return.
bool clang_Sema_findMacroSpelling(CXSema S, CXSourceLocation_ *Loc, const char *Name);

// True when a handler of type HandlerType is a match for an exception object of type
// ExceptionType ([except.handle]p3). Emits no diagnostics.
bool clang_Sema_handlerCanCatch(CXSema S, CXQualType HandlerType, CXQualType ExceptionType);

// False when no module scope is open, which is the interpreter's normal state.
bool clang_Sema_currentModuleIsImplementation(CXSema S);

bool clang_Sema_currentModuleIsHeaderUnit(CXSema S);

bool clang_Sema_shouldLinkDependentDeclWithPrevious(CXSema S, CXDecl D, CXDecl OldDecl);

// Compares the two prototypes' parameter lists index by index; clang walks them in
// lockstep and asserts that both declare the same number of parameters. ArgPos, when
// non-null, receives the index of the first differing parameter and is written only on
// a false return. Reversed walks NewType's list back to front.
bool clang_Sema_FunctionParamTypesAreEqual(CXSema S, CXFunctionProtoType OldType,
                                           CXFunctionProtoType NewType, unsigned *ArgPos,
                                           bool Reversed);

// The same comparison over the two functions' non-object parameter lists.
bool clang_Sema_FunctionNonObjectParamTypesAreEqual(CXSema S, CXFunctionDecl OldFunction,
                                                    CXFunctionDecl NewFunction,
                                                    unsigned *ArgPos, bool Reversed);

// True when Function's address may be taken. Complain diagnoses the failure at Loc;
// with Complain false the call is a pure query.
bool clang_Sema_checkAddressOfFunctionIsAvailable(CXSema S, CXFunctionDecl Function,
                                                  bool Complain, CXSourceLocation_ Loc);

// [PossiblyAFunctionType] -> [Return]: peels one pointer, reference or member-pointer
// layer and drops the qualifiers. A non-function type comes back unqualified.
CXQualType clang_Sema_ExtractUnqualifiedFunctionType(CXSema S,
                                                     CXQualType PossiblyAFunctionType);

// The redeclaration lookup kind appropriate to Sema's current declaration context.
CXRedeclarationKind clang_Sema_forRedeclarationInCurContext(CXSema S);

// The unique field (or indirect field) of ClassDecl named MemberOrBase. Null when the
// name is not a field of ClassDecl or names more than one.
CXValueDecl clang_Sema_tryLookupUnambiguousFieldDecl(CXSema S, CXRecordDecl ClassDecl,
                                                     CXIdentifierInfo MemberOrBase);

// Rebuilds ArgFunctionType with FunctionType's calling convention and noreturn (and,
// when AdjustExceptionSpec, its exception specification). Both types must be
// FunctionProtoTypes — Sema reaches both through an unchecked castAs<>.
CXQualType clang_Sema_adjustCCAndNoReturn(CXSema S, CXQualType ArgFunctionType,
                                          CXQualType FunctionType,
                                          bool AdjustExceptionSpec);

// Static. ScalarTy must be a scalar type: Sema switches over
// Type::getScalarTypeKind(), which asserts isScalarType().
CXCastKind clang_Sema_ScalarTypeToBooleanCastKind(CXQualType ScalarTy);

// --- Standard expression conversions ---
//
// The C and C++ standard conversions Sema applies to an operand before using it. Each
// rewrites an expression that already exists, so none of them needs the parser to be
// running. They cross split like the other ExprResult returns (MARSHALLING.md section 8):
// the discriminator is *IsInvalid and the payload is the returned CXExpr. Every node they
// build is ASTContext-arena memory; nothing is caller-owned and nothing has a dispose.

// The conversions required when an expression's result is syntactically ignored.
CXExpr clang_Sema_IgnoredValueConversions(CXSema S, CXExpr E, bool *IsInvalid);

// Integer promotions plus function/array-to-pointer decay (C99 6.3.1.1p2, 6.3.2.1).
CXExpr clang_Sema_UsualUnaryConversions(CXSema S, CXExpr E, bool *IsInvalid);

// Function and array to pointer decay only. Diagnose selects whether an ill-formed
// operand is reported through Sema's DiagnosticsEngine; clang's own default is true.
CXExpr clang_Sema_DefaultFunctionArrayConversion(CXSema S, CXExpr E, bool Diagnose,
                                                 bool *IsInvalid);

// The same decay followed by the lvalue-to-rvalue conversion.
CXExpr clang_Sema_DefaultFunctionArrayLvalueConversion(CXSema S, CXExpr E, bool Diagnose,
                                                       bool *IsInvalid);

// The lvalue-to-rvalue conversion; a no-op on an operand of function or array type.
CXExpr clang_Sema_DefaultLvalueConversion(CXSema S, CXExpr E, bool *IsInvalid);

// The default argument promotions of C99 6.5.2.2p6.
CXExpr clang_Sema_DefaultArgumentPromotion(CXSema S, CXExpr E, bool *IsInvalid);

// The same-width signed vector type of V. V must be a vector type (unchecked
// castAs<VectorType>).
CXQualType clang_Sema_GetSignedVectorType(CXSema S, CXQualType V);

// clang/Sema/Sema.h: enum Sema::ReferenceCompareResult
typedef enum CXReferenceCompareResult {
  CXReferenceCompareResult_Ref_Incompatible,
  CXReferenceCompareResult_Ref_Related,
  CXReferenceCompareResult_Ref_Compatible
} CXReferenceCompareResult;

// clang/Sema/Sema.h: enum Sema::ReferenceConversionsScope::ReferenceConversions, a
// bitmask. The LLVM_MARK_AS_BITMASK_ENUM alias enumerator is omitted per the mirroring
// rules. It names the bits of the `unsigned *Conv` out-parameter below rather than
// typing it: an OR of two flags is not one of the enumerators, so a mirrored enum type
// could not carry the combined value.
typedef enum CXReferenceConversions {
  CXReferenceConversions_Qualification = 0x1,
  CXReferenceConversions_NestedQualification = 0x2,
  CXReferenceConversions_Function = 0x4,
  CXReferenceConversions_DerivedToBase = 0x8,
  CXReferenceConversions_ObjC = 0x10,
  CXReferenceConversions_ObjCLifetime = 0x20
} CXReferenceConversions;

// Compares cv1 T1 and cv2 T2 for direct reference binding ([dcl.init.ref]p4). Neither
// T1 nor T2 may be a reference type — clang asserts both. Conv, when non-null,
// receives the OR of the CXReferenceConversions that binding would perform.
CXReferenceCompareResult
clang_Sema_CompareReferenceRelationship(CXSema S, CXSourceLocation_ Loc, CXQualType T1,
                                        CXQualType T2, unsigned *Conv);

// clang/Sema/Sema.h: enum class Sema::ConditionKind
typedef enum CXConditionKind {
  CXConditionKind_Boolean,
  CXConditionKind_ConstexprIf,
  CXConditionKind_Switch
} CXConditionKind;

// The type a condition of kind K is contextually converted to: `int` for a switch
// condition, `bool` for the other two.
CXQualType clang_Sema_PreferredConditionType(CXSema S, CXConditionKind K);

// clang/Sema/Sema.h: enum Sema::FormatStringType
typedef enum CXFormatStringType {
  CXFormatStringType_FST_Scanf,
  CXFormatStringType_FST_Printf,
  CXFormatStringType_FST_NSString,
  CXFormatStringType_FST_Strftime,
  CXFormatStringType_FST_Strfmon,
  CXFormatStringType_FST_Kprintf,
  CXFormatStringType_FST_FreeBSDKPrintf,
  CXFormatStringType_FST_OSTrace,
  CXFormatStringType_FST_OSLog,
  CXFormatStringType_FST_Unknown
} CXFormatStringType;

// Static. Which format-string dialect Format names, decoded from its type identifier;
// CXFormatStringType_FST_Unknown for a spelling clang does not recognise.
CXFormatStringType clang_Sema_GetFormatStringType(CXFormatAttr Format);

// Static. True when Format is an NSString format, in which case *Idx receives the
// zero-based index of its format-string argument. *Idx is left untouched otherwise.
bool clang_Sema_GetFormatNSStringIdx(CXFormatAttr Format, unsigned *Idx);

// True when the printf/scanf format string FExpr has a %s conversion. FExpr must be a
// narrow string literal: StringLiteral::getString() asserts getCharByteWidth() == 1.
bool clang_Sema_FormatStringHasSArg(CXSema S, CXStringLiteral FExpr);

// Static. True when NumArgs exceeds what NumParams accepts; PartialOverloading allows
// one extra argument, for a position just after a comma.
bool clang_Sema_TooManyArguments(size_t NumParams, size_t NumArgs, bool PartialOverloading);

// --- Expression conversions and the remaining ODR-use marking entry points ---
//
// Declared in clang::Sema's own declaration order. None of these needs an active
// Sema::InstantiatingTemplate: each one reads or rewrites an expression that already
// exists. They do run real semantic analysis and may emit diagnostics. The ExprResult
// returns follow the split convention of the expression builders above — *IsInvalid is the
// discriminator, the CXExpr return is the payload, and every node produced is
// ASTContext-arena memory with no dispose.

// clang/Sema/Sema.h: enum Sema::AssignmentAction
typedef enum CXAssignmentAction {
  CXAssignmentAction_AA_Assigning,
  CXAssignmentAction_AA_Passing,
  CXAssignmentAction_AA_Returning,
  CXAssignmentAction_AA_Converting,
  CXAssignmentAction_AA_Initializing,
  CXAssignmentAction_AA_Sending,
  CXAssignmentAction_AA_Casting,
  CXAssignmentAction_AA_Passing_CFAudited
} CXAssignmentAction;

// clang/Sema/Sema.h: enum Sema::CheckedConversionKind
typedef enum CXCheckedConversionKind {
  CXCheckedConversionKind_CCK_ImplicitConversion,
  CXCheckedConversionKind_CCK_CStyleCast,
  CXCheckedConversionKind_CCK_FunctionalCast,
  CXCheckedConversionKind_CCK_OtherCast,
  CXCheckedConversionKind_CCK_ForBuiltinOverloadedOp
} CXCheckedConversionKind;

// Initializes Method's implicit object parameter from the object expression From,
// inserting the derived-to-base and qualification conversions a call would.
// Precondition: Method is an implicit object member function — Sema reaches
// Method->getThisType(), which asserts on a static or explicit-object member function.
// Qualifier may be null; FoundDecl is the lookup result that named Method.
CXExpr clang_Sema_PerformImplicitObjectArgumentInitialization(
    CXSema S, CXExpr From, CXNestedNameSpecifier Qualifier, CXNamedDecl FoundDecl,
    CXCXXMethodDecl Method, bool *IsInvalid);

// Converts From to bool the way an `if` condition does, honouring a user-defined
// conversion operator.
CXExpr clang_Sema_PerformContextuallyConvertToBool(CXSema S, CXExpr From, bool *IsInvalid);

// ExprResult crosses as the §8 discriminated pair: *IsInvalid carries the failure flag and
// the return value the node, because a null node and an INVALID result are different
// states. Strips a placeholder type from Base; for IsArrow it also runs the
// function/array-to-pointer and lvalue-to-rvalue conversions.
CXExpr clang_Sema_PerformMemberExprBaseConversion(CXSema S, CXExpr Base, bool IsArrow,
                                                  bool *IsInvalid);

// Converts the object expression From to the class that declares Member. Qualifier may be
// null; a Member whose DeclContext is not a CXXRecordDecl leaves From untouched.
CXExpr clang_Sema_PerformObjectMemberConversion(CXSema S, CXExpr From,
                                                CXNestedNameSpecifier Qualifier,
                                                CXNamedDecl FoundDecl, CXNamedDecl Member,
                                                bool *IsInvalid);

// Records that F's definition was reached through a typo correction.
void clang_Sema_MarkTypoCorrectedFunctionDefinition(CXSema S, CXNamedDecl F);

// Marks the declaration E names as referenced. Base is the object expression of the member
// access E appears in — read only to devirtualize a virtual member function — and may be
// null. Marking a reference to a variable with local storage makes Sema attempt an
// implicit capture, which walks its function-scope stack; do that only while parsing.
void clang_Sema_MarkDeclRefReferenced(CXSema S, CXDeclRefExpr E, CXExpr Base);

void clang_Sema_MarkMemberReferenced(CXSema S, CXMemberExpr E);

// Marks every declaration named inside E as referenced. StopAt is a (buffer, count) pair
// of sub-expressions the walk does not descend into; pass a null buffer and a zero count
// for none. SkipLocalVariables leaves references to variables with local storage unmarked,
// which is what makes the walk safe with no function scope on Sema's stack.
void clang_Sema_MarkDeclarationsReferencedInExpr(CXSema S, CXExpr E,
                                                 bool SkipLocalVariables,
                                                 const CXExpr *StopAt, unsigned NumStopAt);

// Precondition: ClassDecl is a complete definition — its virtual base range is iterated.
// The Clang doc comment's ABI wording says when clang itself reaches this, not a
// precondition: both the Itanium and the Microsoft ABI call it, at different points.
// The optional already-visited base set is not exposed; the shim always passes null.
void clang_Sema_MarkVirtualBaseDestructorsReferenced(CXSema S, CXSourceLocation_ Location,
                                                     CXCXXRecordDecl ClassDecl);

// The MarkUsedTemplateParameters(const Expr *) overload. Used is a caller buffer of N
// flags; slot I is set when template parameter I at Depth occurs in E. The SmallBitVector
// clang indexes is sized to N here, so N must cover every parameter index at Depth that E
// can name — a smaller N trips clang's own bounds assert.
void clang_Sema_MarkUsedTemplateParameters(CXSema S, CXExpr E, bool OnlyDeduced,
                                           unsigned Depth, bool *Used, unsigned N);

// The PerformImplicitConversion(Expr *, QualType, AssignmentAction, bool) overload: runs
// overload resolution for the conversion and diagnoses when there is none. ToType must be
// a non-null QualType.
CXExpr clang_Sema_PerformImplicitConversion(CXSema S, CXExpr From, CXQualType ToType,
                                            CXAssignmentAction Action, bool AllowExplicit,
                                            bool *IsInvalid);

// Inserts the no-op (or address-space) cast taking E to Ty, which should differ from E's
// type only in qualification. Ty must be a non-null QualType.
CXExpr clang_Sema_PerformQualificationConversion(CXSema S, CXExpr E, CXQualType Ty,
                                                 CXExprValueKind VK,
                                                 CXCheckedConversionKind CCK,
                                                 bool *IsInvalid);

// --- Further semantic checks ---
//
// The rest of Sema's Check*/Verify* entry points a caller can drive outside the parser,
// declared in the order clang::Sema declares them. Every one that rejects its input
// reports through Sema's DiagnosticsEngine, so only the ones documented below as never
// diagnosing are pure queries.

// clang/Sema/Sema.h: enum class Sema::CheckConstexprKind
typedef enum CXCheckConstexprKind {
  CXCheckConstexprKind_Diagnose,
  CXCheckConstexprKind_CheckValid
} CXCheckConstexprKind;

// clang/Sema/Sema.h: enum Sema::AssignConvertType
typedef enum CXAssignConvertType {
  CXAssignConvertType_Compatible,
  CXAssignConvertType_PointerToInt,
  CXAssignConvertType_IntToPointer,
  CXAssignConvertType_FunctionVoidPointer,
  CXAssignConvertType_IncompatiblePointer,
  CXAssignConvertType_IncompatibleFunctionPointer,
  CXAssignConvertType_IncompatibleFunctionPointerStrict,
  CXAssignConvertType_IncompatiblePointerSign,
  CXAssignConvertType_CompatiblePointerDiscardsQualifiers,
  CXAssignConvertType_IncompatiblePointerDiscardsQualifiers,
  CXAssignConvertType_IncompatibleNestedPointerAddressSpaceMismatch,
  CXAssignConvertType_IncompatibleNestedPointerQualifiers,
  CXAssignConvertType_IncompatibleVectors,
  CXAssignConvertType_IntToBlockPointer,
  CXAssignConvertType_IncompatibleBlockPointer,
  CXAssignConvertType_IncompatibleObjCQualifiedId,
  CXAssignConvertType_IncompatibleObjCWeakRef,
  CXAssignConvertType_Incompatible
} CXAssignConvertType;

// clang/Sema/Sema.h: enum Sema::AllowFoldKind
typedef enum CXAllowFoldKind {
  CXAllowFoldKind_NoFold,
  CXAllowFoldKind_AllowFold
} CXAllowFoldKind;

// True when T is a function type carrying cv-qualifiers or a ref-qualifier, which makes
// it invalid as a typeid / new / conversion-function-id operand. Diagnoses at Loc.
bool clang_Sema_CheckQualifiedFunctionForTypeId(CXSema S, CXQualType T,
                                                CXSourceLocation_ Loc);

// Check that *T may appear in an exception specification. *T is an in/out parameter:
// clang adjusts an array type to its decayed pointer and a function type to a pointer to
// function, checks the result, and writes it back. True means the type was rejected (an
// incomplete or abstract class), which is diagnosed over the range.
bool clang_Sema_CheckSpecifiedExceptionType(CXSema S, CXQualType *T,
                                            CXSourceLocation_ Range_begin,
                                            CXSourceLocation_ Range_end);

// True when the exception specifications of Old and New are incompatible, which is
// diagnosed; a missing specification on New may instead be completed from Old's.
// PRECONDITION: both declarations have a FunctionProtoType — clang reaches New's
// specification through an unchecked castAs<>.
bool clang_Sema_CheckEquivalentExceptionSpec(CXSema S, CXFunctionDecl Old,
                                             CXFunctionDecl New);

// True when FD's definition satisfies the formal rules for a constexpr function in the
// current language mode — the opposite polarity from the Check* entry points that report
// a rejection. CXCheckConstexprKind_CheckValid admits no extensions and emits nothing;
// CXCheckConstexprKind_Diagnose reports every violation, extensions included.
// PRECONDITION: FD has a body — clang asserts on it before inspecting the definition.
bool clang_Sema_CheckConstexprFunctionDefinition(CXSema S, CXFunctionDecl FD,
                                                 CXCheckConstexprKind Kind);

// True when the type TI describes cannot be an enumeration's fixed underlying type (it is
// neither an integer builtin nor a _BitInt), diagnosing at TI's begin location.
bool clang_Sema_CheckEnumUnderlyingType(CXSema S, CXTypeSourceInfo TI);

// The three C++20 module redeclaration checks. Each returns true when the redeclaration
// New of Old is ill-formed and diagnoses it; CheckRedeclarationInModule is the
// disjunction of the other two. Outside a named module every one of them returns false.
bool clang_Sema_CheckRedeclarationModuleOwnership(CXSema S, CXNamedDecl New,
                                                  CXNamedDecl Old);

bool clang_Sema_CheckRedeclarationExported(CXSema S, CXNamedDecl New, CXNamedDecl Old);

bool clang_Sema_CheckRedeclarationInModule(CXSema S, CXNamedDecl New, CXNamedDecl Old);

// Resolve a placeholder type — an unresolved overload set, a bound member function, a
// pseudo-object expression — to a real expression; an expression whose type is not a
// placeholder comes back unchanged. ExprResult crosses split, exactly as in the
// expression builders above.
CXExpr clang_Sema_CheckPlaceholderExpr(CXSema S, CXExpr E, bool *IsInvalid);

// True when AllocType is not a valid operand for `new` — a function or reference type, or
// an incomplete or abstract class — diagnosing at Loc over the range R.
bool clang_Sema_CheckAllocatedType(CXSema S, CXQualType AllocType, CXSourceLocation_ Loc,
                                   CXSourceLocation_ R_begin, CXSourceLocation_ R_end);

// The three virtual-override compatibility checks. Each returns true when the override of
// Old by New is ill-formed and diagnoses it. PRECONDITION for the attribute and
// exception-spec checks: both methods have a FunctionProtoType, which clang reaches
// through an unchecked castAs<>.
bool clang_Sema_CheckOverridingFunctionAttributes(CXSema S, CXCXXMethodDecl New,
                                                  CXCXXMethodDecl Old);

bool clang_Sema_CheckOverridingFunctionReturnType(CXSema S, CXCXXMethodDecl New,
                                                  CXCXXMethodDecl Old);

bool clang_Sema_CheckOverridingFunctionExceptionSpec(CXSema S, CXCXXMethodDecl New,
                                                     CXCXXMethodDecl Old);

// True when the declaration of an overloaded operator is ill-formed (wrong arity, no
// class-type parameter, a default argument, ...), which is diagnosed.
// PRECONDITION: FnDecl->isOverloadedOperator() — clang asserts on it.
bool clang_Sema_CheckOverloadedOperatorDeclaration(CXSema S, CXFunctionDecl FnDecl);

// True when the declaration of a literal operator is ill-formed (declared as a member,
// with C language linkage, or with a parameter list none of the permitted forms allows),
// which is diagnosed. PRECONDITION: FnDecl's name kind is CXXLiteralOperatorName — clang
// reaches the suffix identifier through DeclarationName::getCXXLiteralIdentifier, which
// asserts on it.
bool clang_Sema_CheckLiteralOperatorDeclaration(CXSema S, CXFunctionDecl FnDecl);

// CheckNonTypeTemplateParameterType(QualType, SourceLocation) overload: the type a
// non-type template parameter declared with type T would have, or a null CXQualType when
// T is not a permitted parameter type, which is diagnosed at Loc.
CXQualType clang_Sema_CheckNonTypeTemplateParameterType(CXSema S, CXQualType T,
                                                        CXSourceLocation_ Loc);

// CheckAssignmentConstraints(SourceLocation, QualType, QualType) overload: whether a
// value of RHSType may initialize an LHSType, and by which extension when the answer is
// not CXAssignConvertType_Compatible. Never diagnoses — clang runs the check over an
// internal placeholder expression with the conversion disabled, so Loc only names the
// position that placeholder pretends to occupy.
CXAssignConvertType clang_Sema_CheckAssignmentConstraints(CXSema S, CXSourceLocation_ Loc,
                                                          CXQualType LHSType,
                                                          CXQualType RHSType);

// True when E is not a valid constant initializer for an object of type T, diagnosing the
// subexpression that made it non-constant.
bool clang_Sema_CheckForConstantInitializer(CXSema S, CXExpr E, CXQualType T);

// Convert E to the boolean condition of an if/while/for, applying the usual function and
// array decays; IsConstexpr requests the constexpr-if rules. ExprResult crosses split, as
// in the expression builders above.
CXExpr clang_Sema_CheckBooleanCondition(CXSema S, CXSourceLocation_ Loc, CXExpr E,
                                        bool IsConstexpr, bool *IsInvalid);

// VerifyIntegerConstantExpression(Expr *, llvm::APSInt *, AllowFoldKind) overload with a
// null APSInt out-parameter — the value is read back with clang_Expr_EvaluateAsInt
// instead. Invalid when E is not an integral constant expression, which is diagnosed;
// CXAllowFoldKind_AllowFold downgrades a foldable non-ICE to a warning.
CXExpr clang_Sema_VerifyIntegerConstantExpression(CXSema S, CXExpr E,
                                                  CXAllowFoldKind CanFold, bool *IsInvalid);

// --- Lookup-result filters and declaration-level pragma helpers ---------------
// The three filters narrow a LookupResult the caller owns; Sema itself is only read by
// them. The rest record state on a declaration or in Sema's own tables.

// Drops from R every result that cannot be read as a template name, replacing a result
// that reaches a template through a using-shadow declaration by the template itself.
// AllowFunctionTemplates keeps function templates; AllowDependent keeps unresolved-using
// declarations that might name templates.
void clang_Sema_FilterAcceptableTemplateNames(CXSema S, CXLookupResult R,
                                              bool AllowFunctionTemplates,
                                              bool AllowDependent);

// Drops from R every declaration that is not in scope in Ctx/Sp. ConsiderLinkage keeps an
// out-of-scope previous declaration that would still redeclare. Ctx and Sp must both be
// non-null -- the scope test reaches through both.
void clang_Sema_FilterLookupForScope(CXSema S, CXLookupResult R, CXDeclContext Ctx,
                                     CXScope Sp, bool ConsiderLinkage,
                                     bool AllowInlineNamespace);

// Drops from R everything already in scope in Sema's current context, leaving what a
// using-declaration would newly introduce. Sp must be non-null.
void clang_Sema_FilterUsingLookup(CXSema S, CXScope Sp, CXLookupResult R);

// Gives an unnamed tag definition the typedef name it takes on for linkage purposes. A
// no-op when TagFromDeclSpec is invalid, already has a name for linkage, or NewTD's
// underlying type is not the tag's own type. PRECONDITION: TagFromDeclSpec is a
// definition -- clang asserts on that once the name-for-linkage check has passed.
void clang_Sema_setTagNameForLinkagePurposes(CXSema S, CXTagDecl TagFromDeclSpec,
                                             CXTypedefNameDecl NewTD);

// Registers MagicValue as a type tag mapping to Type for the `type_tag_for_datatype`
// argument kind named by ArgumentKind. A Sema-side table insert only: nothing in the AST
// changes and nothing is diagnosed. The first registration of a given
// (ArgumentKind, MagicValue) pair wins.
void clang_Sema_RegisterTypeTagForDatatype(CXSema S, CXIdentifierInfo ArgumentKind,
                                           uint64_t MagicValue, CXQualType Type,
                                           bool LayoutCompatible, bool MustBeNull);

// Adds to D the CoreFoundation ownership-transfer attribute implied by an open
// `#pragma clang arc_cf_code_audited` region. A no-op outside such a region and when D
// already carries an audited / unknown-transfer attribute.
void clang_Sema_AddCFAuditedAttribute(CXSema S, CXDecl D);

// Applies to D every attribute pushed by an open `#pragma clang attribute` region whose
// subject-match rules D satisfies. A no-op when no such region is open. Sp is the scope
// the attributes are processed in and must be non-null.
void clang_Sema_AddPragmaAttributes(CXSema S, CXScope Sp, CXDecl D);

// --- Conversion and operand checks -------------------------------------------
// Every entry below runs one Sema check over an expression or a pair of types that
// already exist. None of them drives the parser, so all are callable between parses;
// the ones that diagnose a rejection say so, and the ones that rewrite their operand
// hand the rewritten expression back rather than mutating in place.

// clang/Sema/Sema.h: enum class Sema::AllowedExplicit
typedef enum CXAllowedExplicit {
  CXAllowedExplicit_None,
  CXAllowedExplicit_Conversions,
  CXAllowedExplicit_All
} CXAllowedExplicit;

// The implicit conversion sequence that converts From to ToType, written into the
// caller-owned Out (clang_ImplicitConversionSequence_create / _dispose). Never
// diagnoses and never rewrites From: a conversion that does not exist comes back as a
// bad sequence, which clang_ImplicitConversionSequence_getKind reports.
void clang_Sema_TryImplicitConversion(CXSema S, CXExpr From, CXQualType ToType,
                                      bool SuppressUserConversions,
                                      CXAllowedExplicit AllowExplicit,
                                      bool InOverloadResolution, bool CStyle,
                                      bool AllowObjCWritebackConversion,
                                      CXImplicitConversionSequence Out);

// True when converting From to the pointer type ToType is ill-formed; *Kind receives
// the cast kind the conversion would use. IgnoreBaseAccess skips the access check on a
// derived-to-base step and Diagnose selects whether a rejection is reported. The
// base-specifier path clang fills alongside Kind is deliberately not exposed.
bool clang_Sema_CheckPointerConversion(CXSema S, CXExpr From, CXQualType ToType,
                                       CXCastKind *Kind, bool IgnoreBaseAccess,
                                       bool Diagnose);

// clang/Sema/Sema.h: enum Sema::ObjCLiteralKind
typedef enum CXObjCLiteralKind {
  CXObjCLiteralKind_LK_Array,
  CXObjCLiteralKind_LK_Dictionary,
  CXObjCLiteralKind_LK_Numeric,
  CXObjCLiteralKind_LK_Boxed,
  CXObjCLiteralKind_LK_String,
  CXObjCLiteralKind_LK_Block,
  CXObjCLiteralKind_LK_None
} CXObjCLiteralKind;

// Which Objective-C literal form FromE is, after parentheses and implicit casts are
// stripped. Total over every expression — anything that is not one of the literal
// forms answers CXObjCLiteralKind_LK_None. Never diagnoses.
CXObjCLiteralKind clang_Sema_CheckLiteralKind(CXSema S, CXExpr FromE);

// Check E as the operand of an unevaluated context. ExprResult crosses split, exactly
// as in the expression builders above.
CXExpr clang_Sema_CheckUnevaluatedOperand(CXSema S, CXExpr E, bool *IsInvalid);

// Check E as the operand an lvalue-to-rvalue conversion is about to be applied to.
// ExprResult crosses split.
CXExpr clang_Sema_CheckLValueToRValueConversionOperand(CXSema S, CXExpr E, bool *IsInvalid);

// True when E is not usable as the argument of a `#pragma clang loop` hint, which is
// diagnosed at Loc.
bool clang_Sema_CheckLoopHintExpr(CXSema S, CXExpr E, CXSourceLocation_ Loc);

// CheckUnaryExprOrTypeTraitOperand(Expr *, UnaryExprOrTypeTrait) overload: true when E
// is not a valid operand of the sizeof/alignof/vec_step family, which is diagnosed.
// PRECONDITION: E's type is not a reference type — clang asserts on it.
bool clang_Sema_CheckUnaryExprOrTypeTraitOperand(CXSema S, CXExpr E,
                                                 CXUnaryExprOrTypeTrait ExprKind);

// Whether a value of RHS's type may initialize an object of LHSType, and by which
// extension when the answer is not CXAssignConvertType_Compatible. *ConvertedRHS and
// *IsInvalid carry the (possibly converted) right-hand side back, ExprResult split as
// above. ConvertRHS false leaves RHS alone and then requires Diagnose false as well:
// clang documents the combination as invalid.
CXAssignConvertType clang_Sema_CheckSingleAssignmentConstraints(
    CXSema S, CXQualType LHSType, CXExpr RHS, bool Diagnose, bool DiagnoseCFAudited,
    bool ConvertRHS, CXExpr *ConvertedRHS, bool *IsInvalid);

// Whether RHS may initialize the transparent union ArgType. Any ArgType that is not a
// union carrying the transparent_union attribute answers
// CXAssignConvertType_Incompatible. ExprResult crosses split, as above.
CXAssignConvertType clang_Sema_CheckTransparentUnionArgumentConstraints(
    CXSema S, CXQualType ArgType, CXExpr RHS, CXExpr *ConvertedRHS, bool *IsInvalid);

// True when From's exception specification is incompatible with the one carried by the
// function ToType designates, which is diagnosed. A ToType that does not resolve to a
// function type answers false.
bool clang_Sema_CheckExceptionSpecCompatibility(CXSema S, CXExpr From, CXQualType ToType);

// True when a cast from Ty to the vector type VectorTy is ill-formed, which is
// diagnosed over the range R; *Kind receives the cast kind. PRECONDITION: VectorTy is
// a vector type — clang asserts on it.
bool clang_Sema_CheckVectorCast(CXSema S, CXSourceLocation_ R_begin,
                                CXSourceLocation_ R_end, CXQualType VectorTy, CXQualType Ty,
                                CXCastKind *Kind);

// The ARC unavailable-__weak rule for a conversion from ExprType to CastType. A pure
// comparison of the two canonicalized types; never diagnoses.
bool clang_Sema_CheckObjCARCUnavailableWeakConversion(CXSema S, CXQualType CastType,
                                                      CXQualType ExprType);

// Convert Cond to the condition of a `switch`, applying the contextual conversion to an
// integral or enumeration type. ExprResult crosses split.
CXExpr clang_Sema_CheckSwitchCondition(CXSema S, CXSourceLocation_ SwitchLoc, CXExpr Cond,
                                       bool *IsInvalid);

// Convert CondExpr to bool with the C++ contextual-conversion rules; IsConstexpr asks
// for the constexpr-if rules. ExprResult crosses split.
CXExpr clang_Sema_CheckCXXBooleanCondition(CXSema S, CXExpr CondExpr, bool IsConstexpr,
                                           bool *IsInvalid);

// Verify that BitWidth is a valid bit-field width for a field of type FieldTy and
// return the converted width expression. FieldName may be null — an unnamed bit field.
// ExprResult crosses split; an invalid width is diagnosed at FieldLoc.
CXExpr clang_Sema_VerifyBitField(CXSema S, CXSourceLocation_ FieldLoc,
                                 CXIdentifierInfo FieldName, CXQualType FieldTy,
                                 bool IsMsStruct, CXExpr BitWidth, bool *IsInvalid);

// --- Sema state queries ------------------------------------------------------
// Everything below only reads Sema; none of it drives the parser, so these are
// safe to call between parses.

// Borrowed; null unless a module scope is currently open.
CXModule clang_Sema_getCurrentModule(CXSema S);

// C11 6.2.7/1 structural layout compatibility. clang runs the comparison with
// complaints enabled, so a mismatch between two tag declarations is reported
// through Sema's DiagnosticsEngine.
bool clang_Sema_hasStructuralCompatLayout(CXSema S, CXDecl D, CXDecl Suggested);

// Which C++ special member MD is, or CXCXXSpecialMember_CXXInvalid for an
// ordinary member function.
CXCXXSpecialMember clang_Sema_getSpecialMember(CXSema S, CXCXXMethodDecl MD);

// True when New is an overload of Old rather than a redeclaration of it.
bool clang_Sema_IsOverload(CXSema S, CXFunctionDecl New, CXFunctionDecl Old,
                           bool UseMemberUsingDeclRules, bool ConsiderCudaAttrs);

// True when MD would override the base-class method BaseMD; the object
// parameters are ignored by the comparison.
bool clang_Sema_IsOverride(CXSema S, CXFunctionDecl MD, CXFunctionDecl BaseMD,
                           bool UseMemberUsingDeclRules, bool ConsiderCudaAttrs);

// Both must be non-null QualTypes; a non-complex operand answers false.
bool clang_Sema_IsComplexPromotion(CXSema S, CXQualType FromType, CXQualType ToType);

// Ordinary-name lookup of Name in the translation-unit scope. Name is interned
// in the identifier table, so even an unknown name creates an IdentifierInfo.
bool clang_Sema_isKnownName(CXSema S, const char *Name);

// True when SD can appear in a nested-name-specifier. CanCorrect is optional
// (null is clang's own default); it reports whether typo correction may still
// consider SD when the answer is false.
bool clang_Sema_isAcceptableNestedNameSpecifier(CXSema S, CXNamedDecl SD, bool *CanCorrect);

// T must be a non-null QualType.
bool clang_Sema_isValidPointerAttrType(CXSema S, CXQualType T, bool RefOkay);

// T must be a non-null QualType.
bool clang_Sema_hasExplicitCallingConv(CXSema S, CXQualType T);

// Borrowed; null when T carries no calling-convention attribute. T must be a
// non-null QualType.
CXAttributedType clang_Sema_getCallingConvAttributedType(CXSema S, CXQualType T);

// The type of `this` in the current context, or a null QualType when there is
// none. Precondition: clang_Sema_getCurLexicalContext is non-null — the walk up
// to the function-level declaration context dereferences it.
CXQualType clang_Sema_getCurrentThisType(CXSema S);

// True while any enclosing function scope is a lambda.
bool clang_Sema_isUnexpandedParameterPackPermitted(CXSema S);

bool clang_Sema_inTemplateInstantiation(CXSema S);

// The five predicates below read Sema's innermost expression-evaluation
// context. That stack is never empty — Sema's constructor pushes a
// PotentiallyEvaluated entry — so the assertion guarding it cannot fire.
bool clang_Sema_isConstantEvaluatedContext(CXSema S);

bool clang_Sema_isAlwaysConstantEvaluatedContext(CXSema S);

bool clang_Sema_isUnevaluatedContext(CXSema S);

bool clang_Sema_isImmediateFunctionContext(CXSema S);

bool clang_Sema_isCheckingDefaultArgumentOrInitializer(CXSema S);

// True when none of the four FP-relaxation bits of the current FPFeatures is set.
bool clang_Sema_isPreciseFPEnabled(CXSema S);

// --- Declaration groups, default-argument conversion and template deduction ---
//
// Declared in clang::Sema's own order. None of these needs the parser to be running.
// The two Convert*DefaultArgument entry points run the copy-initialization a default
// argument or a default member initializer performs; they report failure both through
// the IsInvalid out-parameter and through Sema's DiagnosticsEngine. The deduction entry
// points report through the returned CXTemplateDeductionResult and fill the caller's
// CXTemplateDeductionInfo (clang-ex/Sema/CXTemplateDeduction.h) instead of diagnosing.

// Wraps D — and OwnedType alongside it, when OwnedType is non-null — in a DeclGroupRef.
// OwnedType is the tag declaration a declaration statement owns, as in `struct S {} s;`.
CXDeclGroupRef clang_Sema_ConvertDeclToDeclGroup(CXSema S, CXDecl D, CXDecl OwnedType);

// Converts DefaultArg to Param's type the way a parameter's `= <expr>` initializer is
// converted. The result is NOT stored on Param — clang_Sema_SetParamDefaultArgument does
// that. Null with *IsInvalid set when the conversion is ill-formed, which is diagnosed.
CXExpr clang_Sema_ConvertParamDefaultArgument(CXSema S, CXParmVarDecl Param,
                                              CXExpr DefaultArg, CXSourceLocation_ EqualLoc,
                                              bool *IsInvalid);

// The same conversion for a default member initializer `int m = <expr>;`. The result is
// not stored on FD. Null with *IsInvalid set on an ill-formed conversion, which is
// diagnosed.
CXExpr clang_Sema_ConvertMemberDefaultInitExpression(CXSema S, CXFieldDecl FD,
                                                     CXExpr InitExpr,
                                                     CXSourceLocation_ InitLoc,
                                                     bool *IsInvalid);

// clang/Sema/Sema.h: enum Sema::TemplateParameterListEqualKind
typedef enum CXTemplateParameterListEqualKind {
  CXTemplateParameterListEqualKind_TPL_TemplateMatch,
  CXTemplateParameterListEqualKind_TPL_TemplateTemplateParmMatch,
  CXTemplateParameterListEqualKind_TPL_TemplateTemplateArgumentMatch,
  CXTemplateParameterListEqualKind_TPL_TemplateParamsEquivalent
} CXTemplateParameterListEqualKind;

// The Sema overload that carries no TemplateCompareNewDeclInfo and no OldInstFrom, so New
// and Old are compared purely structurally — clang itself calls it that way. Complain=false
// makes this a pure query; Complain=true reports every mismatch through Sema's
// DiagnosticsEngine. Both lists must be non-null: clang reads New->size() and Old->size()
// before anything else.
bool clang_Sema_TemplateParameterListsAreEqual(CXSema S, CXTemplateParameterList New,
                                               CXTemplateParameterList Old, bool Complain,
                                               CXTemplateParameterListEqualKind Kind,
                                               CXSourceLocation_ TemplateArgLoc);

// clang/Sema/Sema.h: enum Sema::TemplateDeductionResult
typedef enum CXTemplateDeductionResult {
  CXTemplateDeductionResult_TDK_Success = 0,
  CXTemplateDeductionResult_TDK_Invalid,
  CXTemplateDeductionResult_TDK_InstantiationDepth,
  CXTemplateDeductionResult_TDK_Incomplete,
  CXTemplateDeductionResult_TDK_IncompletePack,
  CXTemplateDeductionResult_TDK_Inconsistent,
  CXTemplateDeductionResult_TDK_Underqualified,
  CXTemplateDeductionResult_TDK_SubstitutionFailure,
  CXTemplateDeductionResult_TDK_DeducedMismatch,
  CXTemplateDeductionResult_TDK_DeducedMismatchNested,
  CXTemplateDeductionResult_TDK_NonDeducedMismatch,
  CXTemplateDeductionResult_TDK_TooManyArguments,
  CXTemplateDeductionResult_TDK_TooFewArguments,
  CXTemplateDeductionResult_TDK_InvalidExplicitArguments,
  CXTemplateDeductionResult_TDK_NonDependentConversionFailure,
  CXTemplateDeductionResult_TDK_ConstraintsNotSatisfied,
  CXTemplateDeductionResult_TDK_MiscellaneousDeductionFailure,
  CXTemplateDeductionResult_TDK_CUDATargetMismatch,
  CXTemplateDeductionResult_TDK_AlreadyDiagnosed
} CXTemplateDeductionResult;

// Matches TemplateArgs against Partial's own argument pattern. On success the deduced
// arguments are read back with clang_TemplateDeductionInfo_takeSugared; on failure the
// parameter and arguments the mismatch was about stay in Info.
CXTemplateDeductionResult clang_Sema_DeduceTemplateArguments(
    CXSema S, CXClassTemplatePartialSpecializationDecl Partial,
    CXTemplateArgumentList TemplateArgs, CXTemplateDeductionInfo Info);

// Deduces the type the `auto` in AutoTypeLoc stands for from Initializer, writing it
// through Result on success and leaving *Result untouched otherwise. PRECONDITION:
// AutoTypeLoc's type contains an `auto` — clang reaches it through an unchecked
// getContainedAutoType(). DependentDeduction allows a dependent initializer;
// IgnoreConstraints skips the constrained-`auto` check.
CXTemplateDeductionResult clang_Sema_DeduceAutoType(CXSema S, CXTypeLoc AutoTypeLoc,
                                                    CXExpr Initializer, CXQualType *Result,
                                                    CXTemplateDeductionInfo Info,
                                                    bool DependentDeduction,
                                                    bool IgnoreConstraints);

// --- Type relationships, module visibility and literal locations -------------
// Read-only queries over Sema and over the types/declarations handed to them;
// none of them touches the parser's scope stacks, so they are safe to call
// between parses. Declared in the order the methods appear in clang::Sema.

// True when VD is an external symbol that still cannot be named from another
// translation unit, because its type has no linkage and it is not extern "C".
// VD must be a variable or a function.
bool clang_Sema_isExternalWithNoLinkageType(CXSema S, CXValueDecl VD);

// True when any declaration of the entity D declares is visible / reachable.
// clang's trailing `Modules` out-parameter (the modules that would have to be
// imported to make D visible) is not exposed; the shim passes null, which is
// clang's own default.
bool clang_Sema_hasVisibleDeclaration(CXSema S, CXNamedDecl D);

bool clang_Sema_hasReachableDeclaration(CXSema S, CXNamedDecl D);

// True when D has a visible definition. *Suggested receives the declaration
// that would have to be made visible to expose that definition; the shim seeds
// it with null, so "no suggestion" reads back as null rather than as garbage.
// OnlyNeedComplete asks only for a complete type rather than a full definition.
bool clang_Sema_hasVisibleDefinition(CXSema S, CXNamedDecl D, CXNamedDecl *Suggested,
                                     bool OnlyNeedComplete);

// The reachable counterpart. clang's OnlyNeedComplete flag is meaningful only
// together with the visible query, so it is not exposed here; *Suggested is
// seeded with null exactly as above.
bool clang_Sema_hasReachableDefinition(CXSema S, CXNamedDecl D, CXNamedDecl *Suggested);

// C++ [conv.prom]. From is the expression being converted; it may be null and
// is read only to look through a bit-field. Both QualTypes must be non-null.
bool clang_Sema_IsIntegralPromotion(CXSema S, CXExpr From, CXQualType FromType,
                                    CXQualType ToType);

// Block-pointer conversion. *ConvertedType receives the type FromType converts
// to; the shim seeds it with a null QualType.
bool clang_Sema_IsBlockPointerConversion(CXSema S, CXQualType FromType, CXQualType ToType,
                                         CXQualType *ConvertedType);

// C++ [conv.qual]. *ObjCLifetimeConversion reports whether the conversion also
// changes an ObjC lifetime qualifier; the shim clears it before the call.
bool clang_Sema_IsQualificationConversion(CXSema S, CXQualType FromType, CXQualType ToType,
                                          bool CStyle, bool *ObjCLifetimeConversion);

// Function-pointer conversion (noexcept dropping and friends). *ResultTy
// receives the converted type; the shim seeds it with a null QualType.
bool clang_Sema_IsFunctionConversion(CXSema S, CXQualType FromType, CXQualType ToType,
                                     CXQualType *ResultTy);

bool clang_Sema_isSameOrCompatibleFunctionType(CXSema S, CXQualType Param, CXQualType Arg);

// The source range of E. E must be non-null.
CXSourceRange_ clang_Sema_getExprRange(CXSema S, CXExpr E);

// True when Ty is a specialization of std::initializer_list. *Element receives
// the element type and is seeded with a null QualType. clang asserts that the
// language being compiled is C++ (clang_LangOptions_getCPlusPlus is the gate).
bool clang_Sema_isStdInitializerList(CXSema S, CXQualType Ty, CXQualType *Element);

// The template D names once using-shadow declarations have been looked through,
// or null when D does not name a template. Static member of clang::Sema, so
// there is no Sema receiver.
CXNamedDecl clang_Sema_getAsTemplateNameDecl(CXNamedDecl D, bool AllowFunctionTemplates,
                                             bool AllowDependent);

// The location of the innermost active `#pragma clang optimize off`; an invalid
// location means the pragma state is "on".
CXSourceLocation_ clang_Sema_getOptimizeOffPragmaLocation(CXSema S);

// clang/Sema/Sema.h: enum Sema::VarArgKind
typedef enum CXVarArgKind {
  CXVarArgKind_VAK_Valid,
  CXVarArgKind_VAK_ValidInCXX11,
  CXVarArgKind_VAK_Undefined,
  CXVarArgKind_VAK_MSVCUndefined,
  CXVarArgKind_VAK_Invalid
} CXVarArgKind;

// Which VarArgKind fits a value of type Ty passed through a variadic ellipsis.
// Ty must be a non-null QualType.
CXVarArgKind clang_Sema_isValidVarArgType(CXSema S, CXQualType Ty);

// True when E's type is a class with a `c_str` member callable with no
// arguments. Any expression is accepted; a non-class type answers false.
bool clang_Sema_hasCStrMethod(CXSema S, CXExpr E);

// The three vector predicates below assert that at least one of the two
// operands is a vector type; the Julia wrapper restates that precondition.
bool clang_Sema_areVectorTypesSameSize(CXSema S, CXQualType SrcType, CXQualType DestType);

bool clang_Sema_areLaxCompatibleVectorTypes(CXSema S, CXQualType SrcType,
                                            CXQualType DestType);

bool clang_Sema_isLaxVectorConversion(CXSema S, CXQualType SrcType, CXQualType DestType);

// The location of byte ByteNo of the string literal SL. clang asserts that SL
// is a narrow (ordinary or UTF-8) literal and that ByteNo lies inside it.
CXSourceLocation_ clang_Sema_getLocationOfStringLiteralByte(CXSema S, CXStringLiteral SL,
                                                            unsigned ByteNo);

// --- Weak top-level declarations, capture and ADL queries, and the remaining standard
// --- conversions ---
//
// Read-only queries plus the expression rewrites that complete the standard-conversion
// section above. None of them needs the parser to be running: each reads Sema state or
// rewrites an expression that already exists. The ExprResult returns follow the same split
// convention (MARSHALLING.md section 8) — *IsInvalid is the discriminator and the CXExpr
// return the payload — and every node produced is ASTContext-arena memory with no dispose.

// clang::Sema::WeakTopLevelDecls() decomposed into the count+index pair of MARSHALLING.md
// section 6; the container is a SmallVector, so indexing is O(1). These are the
// declarations `#pragma weak name = alias` clones, so the list is empty until such a pragma
// has been processed. The count is exact and no slot is null.
unsigned clang_Sema_getNumWeakTopLevelDecls(CXSema S);

// I must be less than clang_Sema_getNumWeakTopLevelDecls(S).
CXDecl clang_Sema_getWeakTopLevelDecl(CXSema S, unsigned I);

// The identifier clang invents for the parameter of an abbreviated function template:
// "<ParamName>:auto", or "auto:<Index + 1>" when ParamName is null. The name is interned in
// the ASTContext's identifier table, so the result is Clang-owned.
CXIdentifierInfo
clang_Sema_InventAbbreviatedTemplateParameterTypeName(CXSema S, CXIdentifierInfo ParamName,
                                                      unsigned Index);

// True when E is plausibly a mis-parsed template-name. E must be non-null: clang wraps it
// in an ExprResult and dyn_casts the payload, and dyn_cast asserts on a null pointer.
// *Dependent, which must be non-null, receives whether the answer rests on a
// dependent-scope node.
bool clang_Sema_mightBeIntendedToBeTemplateName(CXSema S, CXExpr E, bool *Dependent);

// Static, so there is no Sema receiver. In/out: for a block-scope `extern` declaration
// whose lexical context *DC is a function or method, walks *DC out to the enclosing
// namespace or translation unit and returns true; otherwise returns false and leaves *DC
// untouched.
bool clang_Sema_adjustContextForLocalExternDecl(CXDeclContext *DC);

// True when a reference to Var at Loc would have to be captured by an enclosing lambda,
// block or captured region. Runs the capture machinery with capture building and
// diagnostics both disabled, so it is a pure query.
bool clang_Sema_NeedToCaptureVariable(CXSema S, CXValueDecl Var, CXSourceLocation_ Loc);

// True when argument-dependent lookup should be performed for a call whose callee was named
// by R. SS is the scope specifier written before the name (an empty one when there was
// none) and HasTrailingLParen whether the name is directly followed by `(`. Emits no
// diagnostics.
bool clang_Sema_UseArgumentDependentLookup(CXSema S, CXCXXScopeSpec SS, CXLookupResult R,
                                           bool HasTrailingLParen);

// Capacity-bounded fill, like clang_Sema_LookupConstructors, of the non-member candidate
// functions for the built-in binary operator Opc — the unqualified lookup of `operator@`
// from Sc, member functions excluded. A null Buf counts and ignores BufSize; otherwise at
// most BufSize entries are written and the number written is returned. Sc must be non-null,
// and the lookup is repeatable, so a counting call and a filling call agree.
unsigned clang_Sema_LookupBinOp(CXSema S, CXScope Sc, CXSourceLocation_ OpLoc,
                                CXBinaryOperatorKind Opc, CXNamedDecl *Buf,
                                unsigned BufSize);

// The floating-point options the innermost `#pragma float_control` overrides, as the opaque
// integer encoding of clang::FPOptionsOverride (MARSHALLING.md section 7) the expression
// accessors already use. Zero — the default-constructed encoding — when no pragma is
// active.
uint64_t clang_Sema_CurFPFeatureOverrides(CXSema S);

// True when either operand is an AltiVec vector type. Completes the vector-predicate family
// above and carries the same precondition: clang asserts that at least one of SrcType and
// DestType is a vector type.
bool clang_Sema_anyAltivecTypes(CXSema S, CXQualType SrcType, CXQualType DestType);

// The unary conversions applied to the function designator of a call: function-to-pointer
// decay followed by the lvalue-to-rvalue conversion, with no integer promotion.
CXExpr clang_Sema_CallExprUnaryConversions(CXSema S, CXExpr E, bool *IsInvalid);

// Materializes a prvalue E as an xvalue. A non-prvalue operand, or C++98, comes back
// unchanged. PARTIAL: for a prvalue clang requires the type to be complete and diagnoses
// when it is not, so clang_Sema_isCompleteType is the gate.
CXExpr clang_Sema_TemporaryMaterializationConversion(CXSema S, CXExpr E, bool *IsInvalid);

// clang/Sema/Sema.h: enum Sema::VariadicCallType
typedef enum CXVariadicCallType {
  CXVariadicCallType_VariadicFunction,
  CXVariadicCallType_VariadicBlock,
  CXVariadicCallType_VariadicMethod,
  CXVariadicCallType_VariadicConstructor,
  CXVariadicCallType_VariadicDoesNotApply
} CXVariadicCallType;

// The default argument promotions applied to an argument passed through an ellipsis. FDecl
// may be null. PARTIAL: an operand whose type is CXVarArgKind_VAK_Undefined is not promoted
// at all — clang rewrites the expression into a call to __builtin_trap through the parser
// action ActOnIdExpression, which needs a live TU scope. clang_Sema_isValidVarArgType is
// the gate for that input.
CXExpr clang_Sema_DefaultVariadicArgumentPromotion(CXSema S, CXExpr E,
                                                   CXVariadicCallType CT,
                                                   CXFunctionDecl FDecl, bool *IsInvalid);

// clang/Sema/Sema.h: enum Sema::ArithConvKind
typedef enum CXArithConvKind {
  CXArithConvKind_ACK_Arithmetic,
  CXArithConvKind_ACK_BitwiseOp,
  CXArithConvKind_ACK_Comparison,
  CXArithConvKind_ACK_Conditional,
  CXArithConvKind_ACK_CompAssign
} CXArithConvKind;

// The usual arithmetic conversions of C99 6.3.1.8 over the two operands. Returns the common
// type, or a null QualType when the operands are not both arithmetic — clang leaves that
// diagnostic to its caller. *LHSOut and *RHSOut, both of which must be non-null, receive
// the converted operands; a slot is null when that operand's own conversion failed.
CXQualType clang_Sema_UsualArithmeticConversions(CXSema S, CXExpr LHS, CXExpr RHS,
                                                 CXSourceLocation_ Loc, CXArithConvKind ACK,
                                                 CXExpr *LHSOut, CXExpr *RHSOut);

// Converts SplattedExpr to VectorTy's element type so it can be splatted across a vector.
// PARTIAL twice over: VectorTy must be a vector type (unchecked castAs<VectorType>), and
// the conversion is inserted as an implicit prvalue cast, which clang asserts against an
// operand that is still an lvalue. Pass an operand that has already undergone the
// lvalue-to-rvalue conversion.
CXExpr clang_Sema_prepareVectorSplat(CXSema S, CXQualType VectorTy, CXExpr SplattedExpr,
                                     bool *IsInvalid);

// clang/Sema/Sema.h: enum Sema::TrivialABIHandling
typedef enum CXTrivialABIHandling {
  CXTrivialABIHandling_TAH_IgnoreTrivialABI,
  CXTrivialABIHandling_TAH_ConsiderTrivialABI
} CXTrivialABIHandling;

// True when MD is a trivial CSM of its class. PARTIAL: clang asserts that MD is not
// user-provided and that CSM is not CXCXXSpecialMember_CXXInvalid. Diagnose true reports
// why a non-trivial member is non-trivial through Sema's DiagnosticsEngine; false makes the
// call a pure query.
bool clang_Sema_SpecialMemberIsTrivial(CXSema S, CXCXXMethodDecl MD, CXCXXSpecialMember CSM,
                                       CXTrivialABIHandling TAH, bool Diagnose);

// The base-class virtual methods MD hides without overriding - the walk that backs
// -Woverloaded-virtual, with the diagnostic left out. Returns how many were found; when
// Buf is non-null it receives at most BufSize of them, so a null Buf counts first. clang
// walks the bases of MD's parent, which must therefore have a definition.
unsigned clang_Sema_FindHiddenVirtualMethods(CXSema S, CXCXXMethodDecl MD,
                                             CXCXXMethodDecl *Buf, unsigned BufSize);

// Overload resolution: the candidate collectors. Each one appends to the caller-owned
// CandidateSet and touches nothing else. Conventions shared by the whole family:
//   - a DeclAccessPair parameter is flattened into the (FoundDecl, FoundAccess) pair
//     DeclAccessPair::make takes (MARSHALLING.md section 7);
//   - Sema::ADLCallKind and OverloadCandidateParamOrder are two-state enums flattened to
//     bool (IsADLCandidate, Reversed), as clang_OverloadCandidateSet_isNewCandidate
//     already does;
//   - an ArrayRef<Expr *> crosses as a (const CXExpr *Args, unsigned NumArgs) pair;
//   - ExplicitTemplateArgs may be null;
//   - the EarlyConversions parameter is not exposed: an ImplicitConversionSequence array
//     has no C form and clang's own callers pass none.
void clang_Sema_AddOverloadCandidate(CXSema S, CXFunctionDecl Function,
                                     CXNamedDecl FoundDecl, CXAccessSpecifier FoundAccess,
                                     const CXExpr *Args, unsigned NumArgs,
                                     CXOverloadCandidateSet CandidateSet,
                                     bool SuppressUserConversions, bool PartialOverloading,
                                     bool AllowExplicit, bool AllowExplicitConversion,
                                     bool IsADLCandidate, bool Reversed,
                                     bool AggregateCandidateDeduction);

// Score every declaration in an overload set at once. Functions/Accesses are the parallel
// component arrays of the UnresolvedSetImpl clang wants (MARSHALLING.md section 11), read
// in lockstep against NumFunctions; UnresolvedSetIterator has only private constructors,
// so the shim replays them into a local UnresolvedSet. Member functions in the set take
// their implicit object argument from Args[0] when FirstArgumentIsBase is set.
void clang_Sema_AddFunctionCandidates(CXSema S, const CXNamedDecl *Functions,
                                      const CXAccessSpecifier *Accesses,
                                      unsigned NumFunctions, const CXExpr *Args,
                                      unsigned NumArgs, CXOverloadCandidateSet CandidateSet,
                                      CXTemplateArgumentListInfo ExplicitTemplateArgs,
                                      bool SuppressUserConversions, bool PartialOverloading,
                                      bool FirstArgumentIsBase);

// Composite: clang's AddMethodCandidate takes the implicit object argument as a
// (QualType, Expr::Classification) pair, and a Classification has no C form of its own
// (its box is private to CXExpr.cpp), so this shim takes the object expression and derives
// both from it - which is what a call site does. Method must be a non-static member
// function and must not be a constructor; clang asserts on the latter.
void clang_Sema_AddMethodCandidate(CXSema S, CXCXXMethodDecl Method, CXNamedDecl FoundDecl,
                                   CXAccessSpecifier FoundAccess,
                                   CXCXXRecordDecl ActingContext, CXExpr Object,
                                   const CXExpr *Args, unsigned NumArgs,
                                   CXOverloadCandidateSet CandidateSet,
                                   bool SuppressUserConversions, bool PartialOverloading,
                                   bool Reversed);

// Deduce FunctionTemplate against Args and add the resulting specialization as a
// candidate; a deduction failure is recorded in the set as a non-viable candidate rather
// than reported.
void clang_Sema_AddTemplateOverloadCandidate(
    CXSema S, CXFunctionTemplateDecl FunctionTemplate, CXNamedDecl FoundDecl,
    CXAccessSpecifier FoundAccess, CXTemplateArgumentListInfo ExplicitTemplateArgs,
    const CXExpr *Args, unsigned NumArgs, CXOverloadCandidateSet CandidateSet,
    bool SuppressUserConversions, bool PartialOverloading, bool AllowExplicit,
    bool IsADLCandidate, bool Reversed, bool AggregateCandidateDeduction);

// The member `operator Op` candidates for a call whose left operand is Args[0]; NumArgs
// must be at least one, since clang reads Args[0]'s type to pick the class to look in.
void clang_Sema_AddMemberOperatorCandidates(CXSema S, CXOverloadedOperatorKind Op,
                                            CXSourceLocation_ OpLoc, const CXExpr *Args,
                                            unsigned NumArgs,
                                            CXOverloadCandidateSet CandidateSet,
                                            bool Reversed);

// One built-in candidate with the given parameter types. ParamTys must hold NumArgs
// entries - clang reads one parameter type per argument.
void clang_Sema_AddBuiltinCandidate(CXSema S, const CXQualType *ParamTys,
                                    const CXExpr *Args, unsigned NumArgs,
                                    CXOverloadCandidateSet CandidateSet,
                                    bool IsAssignmentOperator,
                                    unsigned NumContextualBoolArguments);

// Every built-in candidate for `operator Op` over Args. Op must be a real overloadable
// operator: clang's builder llvm_unreachable's on OO_None and on the operators that never
// have built-in forms (new/delete/new[]/delete[]/()), so those abort the process.
void clang_Sema_AddBuiltinOperatorCandidates(CXSema S, CXOverloadedOperatorKind Op,
                                             CXSourceLocation_ OpLoc, const CXExpr *Args,
                                             unsigned NumArgs,
                                             CXOverloadCandidateSet CandidateSet);

// The candidates argument-dependent lookup finds for Name over Args, skipping anything
// already in CandidateSet.
void clang_Sema_AddArgumentDependentLookupCandidates(
    CXSema S, CXDeclarationName Name, CXSourceLocation_ Loc, const CXExpr *Args,
    unsigned NumArgs, CXTemplateArgumentListInfo ExplicitTemplateArgs,
    CXOverloadCandidateSet CandidateSet, bool PartialOverloading);

// Deduce the member function template MethodTmpl against Args and add the resulting
// specialization as a candidate. Composite in the same way as
// clang_Sema_AddMethodCandidate: clang takes the implicit object argument as a
// (QualType, Expr::Classification) pair and a Classification has no C form of its own, so
// this shim derives both from the object expression, which is what a call site does.
// MethodTmpl's templated declaration must be a member function - clang casts the deduced
// specialization to CXXMethodDecl - and Object must designate an object of class type,
// because the implicit object parameter's class is reached through an unchecked
// castAs<RecordType>. ExplicitTemplateArgs may be null.
void clang_Sema_AddMethodTemplateCandidate(
    CXSema S, CXFunctionTemplateDecl MethodTmpl, CXNamedDecl FoundDecl,
    CXAccessSpecifier FoundAccess, CXCXXRecordDecl ActingContext,
    CXTemplateArgumentListInfo ExplicitTemplateArgs, CXExpr Object, const CXExpr *Args,
    unsigned NumArgs, CXOverloadCandidateSet CandidateSet, bool SuppressUserConversions,
    bool PartialOverloading, bool Reversed);

// Add the conversion function Conversion, found in ActingContext, as a candidate for
// converting From to ToType. Conversion must not be the pattern of a conversion function
// template: clang asserts on that and wants clang_Sema_AddTemplateConversionCandidate.
// From must designate an object of class type, or a pointer to one - clang reaches the
// implicit object parameter's class through an unchecked castAs<RecordType>.
void clang_Sema_AddConversionCandidate(CXSema S, CXCXXConversionDecl Conversion,
                                       CXNamedDecl FoundDecl, CXAccessSpecifier FoundAccess,
                                       CXCXXRecordDecl ActingContext, CXExpr From,
                                       CXQualType ToType,
                                       CXOverloadCandidateSet CandidateSet,
                                       bool AllowObjCConversionOnExplicit,
                                       bool AllowExplicit, bool AllowResultConversion);

// Deduce the conversion function template FunctionTemplate against ToType and add the
// specialization through clang_Sema_AddConversionCandidate, whose precondition on From
// therefore applies here too; a deduction failure is recorded in the set as a non-viable
// candidate rather than reported, so the set grows either way. FunctionTemplate's
// templated declaration must be a conversion function.
void clang_Sema_AddTemplateConversionCandidate(
    CXSema S, CXFunctionTemplateDecl FunctionTemplate, CXNamedDecl FoundDecl,
    CXAccessSpecifier FoundAccess, CXCXXRecordDecl ActingContext, CXExpr From,
    CXQualType ToType, CXOverloadCandidateSet CandidateSet,
    bool AllowObjCConversionOnExplicit, bool AllowExplicit, bool AllowResultConversion);

// Add the surrogate candidate for calling Object through the function pointer or reference
// Conversion yields. Proto is the function prototype behind that pointer and must be
// non-null. The preconditions of clang_Sema_AddConversionCandidate hold here as well:
// Conversion must not be a template pattern, and Object must designate an object of class
// type.
void clang_Sema_AddSurrogateCandidate(CXSema S, CXCXXConversionDecl Conversion,
                                      CXNamedDecl FoundDecl, CXAccessSpecifier FoundAccess,
                                      CXCXXRecordDecl ActingContext,
                                      CXFunctionProtoType Proto, CXExpr Object,
                                      const CXExpr *Args, unsigned NumArgs,
                                      CXOverloadCandidateSet CandidateSet);

// The non-member `operator` candidates in an overload set. Functions/Accesses are the
// parallel component arrays of the UnresolvedSetImpl clang wants, read in lockstep against
// NumFunctions exactly as in clang_Sema_AddFunctionCandidates. Every entry must name a
// function or a function template, since clang casts each one unconditionally.
// ExplicitTemplateArgs may be null.
void clang_Sema_AddNonMemberOperatorCandidates(
    CXSema S, const CXNamedDecl *Functions, const CXAccessSpecifier *Accesses,
    unsigned NumFunctions, const CXExpr *Args, unsigned NumArgs,
    CXOverloadCandidateSet CandidateSet, CXTemplateArgumentListInfo ExplicitTemplateArgs);

// The one function in the overload set AddressOfExpr names whose type matches TargetType,
// or null when the set does not resolve to exactly one. *FoundDecl and *FoundAccess, both
// of which must be non-null, receive the two halves of the DeclAccessPair clang reports
// (MARSHALLING.md section 7) and are only meaningful when the return is non-null;
// *HadMultipleCandidates, which may be null, records whether more than one candidate was
// considered. Complain reports the failure through Sema's DiagnosticsEngine, so false
// makes the call a pure query.
// PRECONDITION: clang asserts that AddressOfExpr's type is the overload placeholder type,
// i.e. clang_Type_isPlaceholderType holds and clang_Type_isNonOverloadPlaceholderType does
// not.
CXFunctionDecl clang_Sema_ResolveAddressOfOverloadedFunction(
    CXSema S, CXExpr AddressOfExpr, CXQualType TargetType, bool Complain,
    CXNamedDecl *FoundDecl, CXAccessSpecifier *FoundAccess, bool *HadMultipleCandidates);

// Add every declaration the unresolved lookup ULE names as a candidate for a call with
// Args. A ULE that requires ADL must carry no nested-name-specifier and come from a C++
// translation unit; clang re-checks both under an assertions build.
void clang_Sema_AddOverloadedCallCandidates(CXSema S, CXUnresolvedLookupExpr ULE,
                                            const CXExpr *Args, unsigned NumArgs,
                                            CXOverloadCandidateSet CandidateSet,
                                            bool PartialOverloading);

// The same collection driven from a lookup result rather than from an expression, with
// ExplicitTemplateArgs (which may be null) applied to every template among the results.
// Every result must name a function or a function template, since clang casts each one
// unconditionally.
void clang_Sema_AddOverloadedCallCandidatesWithLookupResult(
    CXSema S, CXLookupResult R, CXTemplateArgumentListInfo ExplicitTemplateArgs,
    const CXExpr *Args, unsigned NumArgs, CXOverloadCandidateSet CandidateSet);

// The classes and namespaces argument-dependent lookup associates with Args. clang fills
// both sets in one walk, so this is a capacity-bounded fill on each: NamespaceBuf and
// ClassBuf may each be null to count only, a non-null buffer takes at most its BufSize
// entries, and *NumNamespaces and *NumClasses - both of which must be non-null - always
// receive the full sizes. The walk reads nothing but Args, so a counting call and a
// filling call report the same sets in the same order.
void clang_Sema_FindAssociatedClassesAndNamespaces(
    CXSema S, CXSourceLocation_ InstantiationLoc, const CXExpr *Args, unsigned NumArgs,
    CXDeclContext *NamespaceBuf, unsigned NamespaceBufSize, unsigned *NumNamespaces,
    CXCXXRecordDecl *ClassBuf, unsigned ClassBufSize, unsigned *NumClasses);

// Convert Args to Constructor's parameter types, filling in default arguments, as a
// constructor call initializing DeclInitType would; returns true when the call is
// ill-formed, which clang diagnoses. The converted expressions are a capacity-bounded
// fill: ConvertedArgs may be null to discard them, otherwise it takes at most
// ConvertedArgsSize entries and *NumConvertedArgs (which must be non-null) receives the
// full count. That count never exceeds NumArgs plus Constructor's parameter count, so one
// call with a buffer that size is enough - re-running the call to size a buffer would
// build the converted nodes twice and re-report any diagnostic.
bool clang_Sema_CompleteConstructorCall(CXSema S, CXCXXConstructorDecl Constructor,
                                        CXQualType DeclInitType, const CXExpr *Args,
                                        unsigned NumArgs, CXSourceLocation_ Loc,
                                        CXExpr *ConvertedArgs, unsigned ConvertedArgsSize,
                                        unsigned *NumConvertedArgs, bool AllowExplicit,
                                        bool IsListInitialization);

// The same conversion for a call to FDecl through Proto, starting at parameter FirstParam;
// returns true when the call is ill-formed, which clang diagnoses. FDecl must be non-null:
// clang asserts on a missing callee as soon as a parameter needs its default argument.
// AllArgs is the same capacity-bounded fill as in clang_Sema_CompleteConstructorCall, with
// the same NumArgs-plus-parameter-count bound on *NumAllArgs, which must be non-null.
bool clang_Sema_GatherArgumentsForCall(CXSema S, CXSourceLocation_ CallLoc,
                                       CXFunctionDecl FDecl, CXFunctionProtoType Proto,
                                       unsigned FirstParam, const CXExpr *Args,
                                       unsigned NumArgs, CXExpr *AllArgs,
                                       unsigned AllArgsSize, unsigned *NumAllArgs,
                                       CXVariadicCallType CallType, bool AllowExplicit,
                                       bool IsListInitialization);

// Attach the attributes clang gives a replaceable global allocation function (alignment,
// nothrow, allocation size) to FD. A declaration that is not one is left alone.
void clang_Sema_AddKnownFunctionAttributesForReplaceableGlobalAllocationFunction(
    CXSema S, CXFunctionDecl FD);

// Declare the global allocation function Name with the given return and parameter types in
// the translation unit, unless a declaration with exactly those parameter types is already
// visible. Name must be one of the four operator new/delete names; for the operator new
// forms before C++11 clang reaches for std::bad_alloc, which a translation unit that never
// parsed <new> does not have (clang_LangOptions_getCPlusPlus11 is the gate).
void clang_Sema_DeclareGlobalAllocationFunction(CXSema S, CXDeclarationName Name,
                                                CXQualType Return, const CXQualType *Params,
                                                unsigned NumParams);

// Look Name (an operator delete name) up as a member of RD. Returns true when the lookup
// failed - ambiguous, or the result inaccessible - and false otherwise; *Operator receives
// the chosen function, or null when RD declares no usual deallocation function. Operator
// must be non-null. RD must have a definition, and the lookup declares RD's implicit
// members as a side effect. Diagnose should stay false outside the parser: clang has no
// source context to render a diagnostic against.
bool clang_Sema_FindDeallocationFunction(CXSema S, CXSourceLocation_ StartLoc,
                                         CXCXXRecordDecl RD, CXDeclarationName Name,
                                         CXFunctionDecl *Operator, bool Diagnose,
                                         bool WantSize, bool WantAligned);

// --- Semantic checks ---------------------------------------------------------
// The Check* entry points below only inspect the nodes they are handed; none of them
// drives the parser, so they are safe to call between parses. Each reports failure
// through Sema's DiagnosticsEngine, so every comment names the input that is diagnosed.

// Walk every delegating constructor Sema has recorded and mark the members of a
// delegation cycle invalid; the cycle itself is diagnosed. A translation unit without
// one is left untouched, so this is idempotent on well-formed code.
void clang_Sema_CheckDelegatingCtorCycles(CXSema S);

// Warn when casting Op to the pointer type T raises the required alignment. clang checks
// that -Wcast-align is enabled before anything else and returns if it is not, so with the
// default diagnostic settings this does nothing.
void clang_Sema_CheckCastAlign(CXSema S, CXExpr Op, CXQualType T,
                               CXSourceLocation_ TRange_begin,
                               CXSourceLocation_ TRange_end);

// True when FD's type has a non-trivial special member, which C++98 forbids in a union or
// an anonymous struct; the offending member is diagnosed at FD.
// PRECONDITION: the C++ language mode -- clang asserts getLangOpts().CPlusPlus.
bool clang_Sema_CheckNontrivialField(CXSema S, CXFieldDecl FD);

// True when redeclaring Prev with this scopedness and fixed underlying type contradicts
// it, which is diagnosed at EnumLoc. Passing Prev's own isScoped/getIntegerType/isFixed
// answers false and diagnoses nothing. EnumUnderlyingTy may be null when IsFixed is false.
bool clang_Sema_CheckEnumRedeclaration(CXSema S, CXSourceLocation_ EnumLoc, bool IsScoped,
                                       CXQualType EnumUnderlyingTy, bool IsFixed,
                                       CXEnumDecl Prev);

// True when ReturnType is an incomplete non-void type, which is diagnosed at Loc. CE and
// FD only name the call in that diagnostic and may both be null.
bool clang_Sema_CheckCallReturnType(CXSema S, CXQualType ReturnType, CXSourceLocation_ Loc,
                                    CXCallExpr CE, CXFunctionDecl FD);

// Check that every parameter of FD following the first defaulted one is itself defaulted;
// a gap is diagnosed and the stray default argument dropped.
void clang_Sema_CheckCXXDefaultArguments(CXSema S, CXFunctionDecl FD);

// Diagnose an `alignas` on D weaker than the alignment D's type requires.
// PRECONDITIONS: D carries attributes (clang asserts), and D is a ValueDecl or a TagDecl
// -- the body reaches the type through an unchecked cast<TagDecl> for everything that is
// not a ValueDecl.
void clang_Sema_CheckAlignasUnderalignment(CXSema S, CXDecl D);

// Drop E's left operand from the enclosing evaluation context's list of volatile
// assignment targets, which is what suppresses the C++20 deprecation warning for a
// volatile compound assignment. A non-volatile E, or a mode before C++20, returns at once.
void clang_Sema_CheckUnusedVolatileAssignment(CXSema S, CXExpr E);

// True when E is not a valid `vec_step` operand -- an incomplete, sizeless or array type
// -- which is diagnosed at E. PRECONDITION: E's type is not a reference type, which the
// shared operand check asserts.
bool clang_Sema_CheckVecStepExpr(CXSema S, CXExpr E);

// Diagnose an argument too short for a parameter declared with a static array bound
// (`void f(int a[static 4])`). C++ has no such parameters, so under a C++ language mode
// clang returns immediately.
void clang_Sema_CheckStaticArrayArgument(CXSema S, CXSourceLocation_ CallLoc,
                                         CXParmVarDecl Param, CXExpr ArgExpr);

// Warn when reinterpreting SrcType as DestType is undefined. IsDereference selects the
// "indirection through the result" form, which needs both types to be pointer types; the
// other form needs DestType to be a reference type. Anything else, and an ignored
// -Wundefined-reinterpret-cast, returns immediately.
void clang_Sema_CheckCompatibleReinterpretCast(CXSema S, CXQualType SrcType,
                                               CXQualType DestType, bool IsDereference,
                                               CXSourceLocation_ Range_begin,
                                               CXSourceLocation_ Range_end);

// True when CE is a valid constraint expression: a conjunction or disjunction is checked
// operand by operand, and every atomic constraint must have type bool. A non-bool operand
// is diagnosed at that operand, and *PossibleNonPrimary -- which may be null -- is set
// when the failure looks like a call written without the parentheses a constraint needs;
// IsTrailingRequiresClause only refines that guess. helper: clang also takes the token the
// parser had lexed after the constraint, which exists only mid-parse, so the shim passes a
// cleared token; it feeds nothing but that guess.
bool clang_Sema_CheckConstraintExpression(CXSema S, CXExpr CE, bool *PossibleNonPrimary,
                                          bool IsTrailingRequiresClause);

// Apply C++ [class.copy]p3 to Constructor: one whose first parameter is its own class by
// value, with every later parameter defaulted, is diagnosed and marked invalid. A
// Constructor whose semantic context is not a class is marked invalid without a
// diagnostic.
void clang_Sema_CheckConstructor(CXSema S, CXCXXConstructorDecl Constructor);

// Apply the C++11 override-control rules to D: `override` on a method that overrides
// nothing, or `final` on a non-virtual one, is diagnosed. A declaration carrying neither
// attribute returns immediately.
void clang_Sema_CheckOverrideControl(CXSema S, CXNamedDecl D);

// Warn about comparing floating-point operands for equality with Opcode. The warning is
// -Wfloat-equal, off by default; two references to the same declaration, and a literal the
// source type represents exactly, return before it.
void clang_Sema_CheckFloatComparison(CXSema S, CXSourceLocation_ Loc, CXExpr LHS,
                                     CXExpr RHS, CXBinaryOperatorKind Opcode);

// --- Sema state queries: current context, modules and type classification ---
// Read-only queries over Sema's own state and over the declarations and types
// handed to them; none of them drives the parser's scope stacks, so they are
// safe to call between parses. Declared in the order the methods appear in
// clang::Sema.

// The ASTConsumer Sema was constructed with. Borrowed — it is owned by the
// CompilerInstance and must never be disposed through this handle.
CXASTConsumer clang_Sema_getASTConsumer(CXSema S);

// The innermost enclosing Scope whose entity is Ctx's primary context, or null
// when there is none. A null Ctx answers null, and so does every query made
// while Sema has no current scope (i.e. outside of parsing).
CXScope clang_Sema_getScopeForContext(CXSema S, CXDeclContext Ctx);

// helper: whether a function scope is on Sema's scope stack. This is the gate
// for clang_Sema_hasAnyUnrecoverableErrorsInThisFunction, whose clang method
// dereferences getCurFunction() unconditionally although getCurFunction()
// itself returns null on an empty stack.
bool clang_Sema_hasCurFunction(CXSema S);

// PRECONDITION: clang_Sema_hasCurFunction(S). clang reads
// getCurFunction()->ErrorTrap with no null check.
bool clang_Sema_hasAnyUnrecoverableErrorsInThisFunction(CXSema S);

// Whether module M is visible from the translation unit being analysed. M must
// be non-null — clang indexes it without a null check. ModulePrivate asks the
// narrower question of whether M is part of the module currently being built.
bool clang_Sema_isModuleVisible(CXSema S, CXModule M, bool ModulePrivate);

// Whether Def has a merged definition owned by a module usable from the module
// currently being built. Def must be non-null.
bool clang_Sema_hasMergedDefinitionInCurrentModule(CXSema S, CXNamedDecl Def);

// The type `decltype(E)` denotes, without the DecltypeType sugar around it. E
// must be non-null. Unlike BuildDecltypeType this never diagnoses.
CXQualType clang_Sema_getDecltypeForExpr(CXSema S, CXExpr E);

// Whether Kind names one of the simple-type-specifier keywords. Kind is a raw
// clang::tok::TokenKind value, as returned by clang_IdentifierInfo_getTokenID.
bool clang_Sema_isSimpleTypeSpecifier(CXSema S, unsigned Kind);

// Whether D is declared in Ctx — and, when Ctx's redeclaration context is a
// function or method, in the scope Sc. PRECONDITION: Sc may be null only when
// that redeclaration context is NOT a function or method; in the function case
// clang walks Sc's parent chain with no null check
// (clang_DeclContext_isFunctionOrMethod on
// clang_DeclContext_getRedeclContext(Ctx) is the gate).
bool clang_Sema_isDeclInScope(CXSema S, CXNamedDecl D, CXDeclContext Ctx, CXScope Sc,
                              bool AllowInlineNamespace);

// Whether Init is a valid string initializer for the array type AT. Both must
// be non-null.
bool clang_Sema_IsStringInit(CXSema S, CXExpr Init, CXArrayType AT);

// clang/Sema/Sema.h: enum class Sema::FunctionEmissionStatus
typedef enum CXFunctionEmissionStatus {
  CXFunctionEmissionStatus_Emitted,
  CXFunctionEmissionStatus_CUDADiscarded,
  CXFunctionEmissionStatus_OMPDiscarded,
  CXFunctionEmissionStatus_TemplateDiscarded,
  CXFunctionEmissionStatus_Unknown
} CXFunctionEmissionStatus;

// Whether codegen will emit FD, and when it will not, why it is discarded. FD
// must be non-null (clang asserts). Final asks the end-of-translation-unit
// question instead of the point-of-use one.
CXFunctionEmissionStatus clang_Sema_getEmissionStatus(CXSema S, CXFunctionDecl FD,
                                                      bool Final);

// The address space implicitly applied to the qualifiers of a C++ method:
// opencl_generic under OpenCL, CXLangAS_Default everywhere else.
CXLangAS clang_Sema_getDefaultCXXMethodAddrSpace(CXSema S);

// The std::align_val_t enumeration, or null while no header has declared it.
CXEnumDecl clang_Sema_getStdAlignValT(CXSema S);

// Whether BaseType is the type of a `this` used outside the body of a member
// function of a class currently being defined. BaseType must be a non-null
// QualType.
bool clang_Sema_isThisOutsideMemberFunctionBody(CXSema S, CXQualType BaseType);

// Whether FD is an aligned allocation or deallocation function the deployment
// target does not provide. FD must be non-null — it crosses to a C++ reference
// parameter and is dereferenced here.
bool clang_Sema_isUnavailableAlignedAllocationFunction(CXSema S, CXFunctionDecl FD);

// Whether Sema's current context sits inside a class local to a function
// template.
bool clang_Sema_IsInsideALocalClassWithinATemplateFunction(CXSema S);

// Heuristic, decided from the name alone: whether FD could be the
// `get_return_object` member of a coroutine promise type. Static member of
// clang::Sema, so there is no Sema receiver. FD must be non-null.
bool clang_Sema_CanBeGetReturnObject(CXFunctionDecl FD);

// Whether converting From to ToType is the deprecated string-literal-to
// -non-const-pointer conversion. From must be non-null and ToType a non-null
// QualType.
bool clang_Sema_IsStringLiteralToNonConstPointerConversion(CXSema S, CXExpr From,
                                                           CXQualType ToType);

// The two scalable-vector bitcast predicates below assert that at least one of
// the two operands is a vector type, exactly like
// clang_Sema_areVectorTypesSameSize; the Julia wrappers restate that.
bool clang_Sema_isValidSveBitcast(CXSema S, CXQualType SrcType, CXQualType DestType);

bool clang_Sema_isValidRVVBitcast(CXSema S, CXQualType SrcType, CXQualType DestType);

// The lexical DeclContext an Objective-C attribute would be read from: the
// current lexical context, with a category mapped to the interface it extends.
CXDeclContext clang_Sema_getCurObjCLexicalContext(CXSema S);

// Sema::AlignPackInfo
//
// The `#pragma pack` / `#pragma align` state of one alignment-stack slot. clang hands the
// class back by value and it has no pointer form, so the handle is an owned heap box;
// release it with clang_AlignPackInfo_dispose.

// Mirrors clang::Sema::AlignPackInfo::Mode (class-local enum; synced in
// lib/Basic/CXEnumSync.cpp). Native is whatever the target's default alignment is.
typedef enum CXAlignPackInfo_Mode : unsigned char {
  CXAlignPackInfo_Native,
  CXAlignPackInfo_Natural,
  CXAlignPackInfo_Packed,
  CXAlignPackInfo_Mac68k
} CXAlignPackInfo_Mode;

// The `#pragma pack` constructor. Precondition: Num < 256 -- the pack number is stored in
// an unsigned char and clang asserts that it was not truncated.
CXAlignPackInfo clang_AlignPackInfo_createPack(CXAlignPackInfo_Mode M, unsigned Num,
                                               bool IsXL);

// The `#pragma align` constructor: the pack number is derived from the mode (1 for
// CXAlignPackInfo_Packed, otherwise left unset) instead of being given.
CXAlignPackInfo clang_AlignPackInfo_createAlign(CXAlignPackInfo_Mode M, bool IsXL);

void clang_AlignPackInfo_dispose(CXAlignPackInfo Info);

// Static in clang, taking the value as its argument; here the value is the receiver.
unsigned clang_AlignPackInfo_getRawEncoding(CXAlignPackInfo Info);

// Static. Rebuilds a caller-owned box from an encoding produced by
// clang_AlignPackInfo_getRawEncoding. The encoding carries only the low five bits of the
// pack number, so a value built by clang_AlignPackInfo_createPack with Num >= 32 does not
// round-trip; an align value, whose pack number is re-derived from the mode, always does.
CXAlignPackInfo clang_AlignPackInfo_getFromRawEncoding(unsigned Encoding);

bool clang_AlignPackInfo_IsPackAttr(CXAlignPackInfo Info);

bool clang_AlignPackInfo_IsAlignAttr(CXAlignPackInfo Info);

CXAlignPackInfo_Mode clang_AlignPackInfo_getAlignMode(CXAlignPackInfo Info);

unsigned clang_AlignPackInfo_getPackNumber(CXAlignPackInfo Info);

// Whether a pack number was actually set: `#pragma align`, `#pragma pack()` and
// `#pragma pack(0)` all leave it unset.
bool clang_AlignPackInfo_IsPackSet(CXAlignPackInfo Info);

bool clang_AlignPackInfo_IsXLStack(CXAlignPackInfo Info);

// Sema::DefaultedFunctionKind
//
// Which defaultable function a FunctionDecl is, if any. clang hands the class back by
// value and it has no pointer form, so the handle is an owned heap box; release it with
// clang_DefaultedFunctionKind_dispose.

// Mirrors clang::Sema::DefaultedComparisonKind (class-local enum; synced in
// lib/Basic/CXEnumSync.cpp).
typedef enum CXDefaultedComparisonKind : unsigned char {
  CXDefaultedComparisonKind_None,
  CXDefaultedComparisonKind_Equal,
  CXDefaultedComparisonKind_ThreeWay,
  CXDefaultedComparisonKind_NotEqual,
  CXDefaultedComparisonKind_Relational
} CXDefaultedComparisonKind;

// clang::Sema::getDefaultedFunctionKind -- the only way to obtain the value. It classifies
// FD from its declaration alone, reads no parser state and emits no diagnostic. FD must be
// non-null.
CXDefaultedFunctionKind clang_Sema_getDefaultedFunctionKind(CXSema S, CXFunctionDecl FD);

void clang_DefaultedFunctionKind_dispose(CXDefaultedFunctionKind DFK);

bool clang_DefaultedFunctionKind_isSpecialMember(CXDefaultedFunctionKind DFK);

bool clang_DefaultedFunctionKind_isComparison(CXDefaultedFunctionKind DFK);

// CXCXXSpecialMember_CXXInvalid unless clang_DefaultedFunctionKind_isSpecialMember.
CXCXXSpecialMember clang_DefaultedFunctionKind_asSpecialMember(CXDefaultedFunctionKind DFK);

// CXDefaultedComparisonKind_None unless clang_DefaultedFunctionKind_isComparison.
CXDefaultedComparisonKind
clang_DefaultedFunctionKind_asComparison(CXDefaultedFunctionKind DFK);

// The index clang's own diagnostic tables use: the special-member value plus the
// comparison value, at most one of which is ever non-default.
unsigned clang_DefaultedFunctionKind_getDiagnosticIndex(CXDefaultedFunctionKind DFK);

// Sema::SFINAETrap
//
// RAII sentinel: constructing it makes Sema a SFINAE context if it is not one already and
// records the SFINAE error counter; destroying it restores that counter, the
// non-instantiation SFINAE flag, the access-checking flag and the engine's
// last-diagnostic-ignored bit. The handle is an owned heap box whose dispose is what ends
// the trap, so nested traps must be disposed in reverse construction order. While a trap
// is live, a SFINAE-able error is counted rather than emitted, which is what lets the
// Subst* family be driven outside a parse without reaching clang's diagnostic renderer.
CXSFINAETrap clang_SFINAETrap_create(CXSema S, bool AccessCheckingSFINAE);

void clang_SFINAETrap_dispose(CXSFINAETrap Trap);

bool clang_SFINAETrap_hasErrorOccurred(CXSFINAETrap Trap);

// The non-member `operator Op` functions visible from Sc, member functions excluded. This
// is the general form of clang_Sema_LookupBinOp, which is the binary-operator convenience
// over it and cannot reach the call, subscript or unary operators. Capacity-bounded fill:
// a null Buf counts and ignores BufSize; otherwise at most BufSize entries are written and
// the number written is returned. Sc must be non-null, and the lookup is repeatable, so a
// counting call and a filling call agree.
unsigned clang_Sema_LookupOverloadedOperatorName(CXSema S, CXOverloadedOperatorKind Op,
                                                 CXScope Sc, CXNamedDecl *Buf,
                                                 unsigned BufSize);

// Score the candidates for the overloaded binary operator Op into CandidateSet: the member
// candidates, the non-member ones named by Functions/Accesses, the built-in ones and, when
// RequiresADL, the argument-dependent ones. Functions/Accesses are the parallel component
// arrays of the UnresolvedSetImpl clang wants (MARSHALLING.md section 11), read in lockstep
// against NumFunctions exactly as in clang_Sema_AddFunctionCandidates, and are usually what
// clang_Sema_LookupOverloadedOperatorName returned. Args are the two operands.
void clang_Sema_LookupOverloadedBinOp(CXSema S, CXOverloadCandidateSet CandidateSet,
                                      CXOverloadedOperatorKind Op,
                                      const CXNamedDecl *Functions,
                                      const CXAccessSpecifier *Accesses,
                                      unsigned NumFunctions, const CXExpr *Args,
                                      unsigned NumArgs, bool RequiresADL);

// clang/Sema/Sema.h: enum class Sema::ExpressionEvaluationContext
typedef enum CXExpressionEvaluationContext {
  CXExpressionEvaluationContext_Unevaluated,
  CXExpressionEvaluationContext_UnevaluatedList,
  CXExpressionEvaluationContext_DiscardedStatement,
  CXExpressionEvaluationContext_UnevaluatedAbstract,
  CXExpressionEvaluationContext_ConstantEvaluated,
  CXExpressionEvaluationContext_ImmediateFunctionContext,
  CXExpressionEvaluationContext_PotentiallyEvaluated,
  CXExpressionEvaluationContext_PotentiallyEvaluatedIfUsed
} CXExpressionEvaluationContext;

// clang/Sema/Sema.h: enum Sema::ExpressionEvaluationContextRecord::ExpressionKind
typedef enum CXExpressionKind {
  CXExpressionKind_EK_Decltype,
  CXExpressionKind_EK_TemplateArgument,
  CXExpressionKind_EK_Other
} CXExpressionKind;

// The innermost record of Sema's expression-evaluation context stack. The handle borrows an
// interior pointer into that stack, so it dangles as soon as a context is pushed or popped
// - read out of it before parsing anything. Never null and never a stale read: Sema's
// constructor pushes the potentially-evaluated bottom record and nothing pops it.
CXExpressionEvaluationContextRecord clang_Sema_currentEvaluationContext(CXSema S);

// Which evaluation context Rec is.
CXExpressionEvaluationContext
clang_ExpressionEvaluationContextRecord_getContext(CXExpressionEvaluationContextRecord Rec);

// The number of active cleanup objects when Rec was entered.
unsigned clang_ExpressionEvaluationContextRecord_getNumCleanupObjects(
    CXExpressionEvaluationContextRecord Rec);

// The number of TypoExprs created inside Rec.
unsigned clang_ExpressionEvaluationContextRecord_getNumTypos(
    CXExpressionEvaluationContextRecord Rec);

// The declaration providing the mangling context for lambdas and block literals when the
// normal declaration context does not suffice; null in an ordinary context.
CXDecl clang_ExpressionEvaluationContextRecord_getManglingContextDecl(
    CXExpressionEvaluationContextRecord Rec);

// Which syntactic construct opened Rec: a decltype operand, a template argument, or
// anything else.
CXExpressionKind clang_ExpressionEvaluationContextRecord_getExprContext(
    CXExpressionEvaluationContextRecord Rec);

// Whether Rec is a discarded statement, or an immediate function context nested in one. Its
// three sibling predicates need no wrapper of their own: isUnevaluated, isConstantEvaluated
// and isImmediateFunctionContext are what clang_Sema_isUnevaluatedContext,
// clang_Sema_isConstantEvaluatedContext and clang_Sema_isImmediateFunctionContext already
// ask of this same innermost record.
bool clang_ExpressionEvaluationContextRecord_isDiscardedStatementContext(
    CXExpressionEvaluationContextRecord Rec);

// The declaration whose default argument or default member initializer is being evaluated
// in Rec, as the three components of the optional InitializationContext aggregate
// (MARSHALLING.md sections 7 and 8). False - leaving the out-parameters untouched - when
// the optional is disengaged; when it is engaged both Decl and Ctx are non-null, which the
// aggregate's own constructor asserts.
bool clang_ExpressionEvaluationContextRecord_getDelayedDefaultInitializationContext(
    CXExpressionEvaluationContextRecord Rec, CXSourceLocation_ *Loc, CXValueDecl *Decl,
    CXDeclContext *Ctx);

// The innermost declaration on the whole evaluation-context stack whose default argument or
// default member initializer has delayed immediate invocations, marshalled like the
// accessor above. The search stops at the first constant-evaluated, immediate-function or
// unevaluated context.
bool clang_Sema_InnermostDeclarationWithDelayedImmediateInvocations(CXSema S,
                                                                    CXSourceLocation_ *Loc,
                                                                    CXValueDecl *Decl,
                                                                    CXDeclContext *Ctx);

// The outermost such declaration, same marshalling and same stopping rule.
bool clang_Sema_OutermostDeclarationWithDelayedImmediateInvocations(CXSema S,
                                                                    CXSourceLocation_ *Loc,
                                                                    CXValueDecl *Decl,
                                                                    CXDeclContext *Ctx);

// clang/Sema/Sema.h: enum Sema::CUDAFunctionTarget
typedef enum CXCUDAFunctionTarget {
  CXCUDAFunctionTarget_CFT_Device,
  CXCUDAFunctionTarget_CFT_Global,
  CXCUDAFunctionTarget_CFT_Host,
  CXCUDAFunctionTarget_CFT_HostDevice,
  CXCUDAFunctionTarget_CFT_InvalidTarget
} CXCUDAFunctionTarget;

// Whether D is a CUDA device/host/kernel function. Read from D's attributes rather than
// from the language mode, so it answers for a non-CUDA translation unit too. D must be
// non-null. IgnoreImplicitHDAttr skips the host-device attributes clang itself added.
CXCUDAFunctionTarget clang_Sema_IdentifyCUDATarget(CXSema S, CXFunctionDecl D,
                                                   bool IgnoreImplicitHDAttr);

// The CUDA target of the context Sema is in: the enclosing function's when the current
// context is a function, and the global host/device context's otherwise.
CXCUDAFunctionTarget clang_Sema_CurrentCUDATarget(CXSema S);

// clang/Sema/Sema.h: enum Sema::CUDAFunctionPreference
typedef enum CXCUDAFunctionPreference {
  CXCUDAFunctionPreference_CFP_Never,
  CXCUDAFunctionPreference_CFP_WrongSide,
  CXCUDAFunctionPreference_CFP_HostDevice,
  CXCUDAFunctionPreference_CFP_SameSide,
  CXCUDAFunctionPreference_CFP_Native
} CXCUDAFunctionPreference;

// How preferable the Caller/Callee combination is, from their host/device attributes;
// CFP_Never means the call is not allowed. Caller may be null for the global context,
// Callee must be non-null.
CXCUDAFunctionPreference clang_Sema_IdentifyCUDAPreference(CXSema S, CXFunctionDecl Caller,
                                                           CXFunctionDecl Callee);

// --- Declaration helpers: allocation lookup, instantiation mapping, merging --------
// The entry points below build or mutate declarations. None of them drives the parser, so
// they can run between parses, but several report failure through Sema's DiagnosticsEngine
// and several write state that outlives the call, so each comment names the input that is
// diagnosed and the state that changes. The Julia wrappers gate the diagnosed inputs out.

// clang/Sema/Sema.h: enum Sema::AllocationFunctionScope
typedef enum CXAllocationFunctionScope {
  CXAllocationFunctionScope_AFS_Global,
  CXAllocationFunctionScope_AFS_Class,
  CXAllocationFunctionScope_AFS_Both
} CXAllocationFunctionScope;

// Find the operator new and operator delete a new-expression allocating AllocType would
// call. Returns true when the lookup failed. *PassAlignment is in/out: it carries in
// whether the allocation wants an alignment argument and receives back whether the chosen
// operator new actually takes one; it must be non-null. *OperatorNew and *OperatorDelete,
// both of which must be non-null, receive the chosen functions, and a slot stays null when
// nothing was chosen. PlaceArgs is the placement-argument array as a (handle, count) pair
// (MARSHALLING.md section 11) and may be empty. Declaring the implicit global operator
// new/delete is a side effect on the translation unit. Diagnose should stay false outside
// the parser: clang has no source context to render a diagnostic against.
bool clang_Sema_FindAllocationFunctions(
    CXSema S, CXSourceLocation_ StartLoc, CXSourceLocation_ Range_begin,
    CXSourceLocation_ Range_end, CXAllocationFunctionScope NewScope,
    CXAllocationFunctionScope DeleteScope, CXQualType AllocType, bool IsArray,
    bool *PassAlignment, const CXExpr *PlaceArgs, unsigned NumPlaceArgs,
    CXFunctionDecl *OperatorNew, CXFunctionDecl *OperatorDelete, bool Diagnose);

// The composite pointer type of the two operands of a conditional or a comparison, or a
// null QualType when they have none - clang leaves that diagnostic to its caller. *E1 and
// *E2 are in/out and must both be non-null: they carry the operands in and receive them
// back, converted to the composite type when ConvertArgs is true. ConvertArgs true inserts
// the implicit conversions through PerformImplicitConversion, which diagnoses a conversion
// it cannot build; false makes the call a pure type computation.
CXQualType clang_Sema_FindCompositePointerType(CXSema S, CXSourceLocation_ Loc, CXExpr *E1,
                                               CXExpr *E2, bool ConvertArgs);

// The declaration D denotes once TemplateArgs have been substituted for the enclosing
// template's parameters, or D itself when nothing about its declaration context depends on
// them. PARTIAL: for a function parameter, a template parameter, or a declaration local to
// a dependent function, clang looks the instantiation up in the current local instantiation
// scope and asserts when it is not there, so those inputs need a live instantiation.
// FindingInstantiatedContext records that the caller is mapping a context rather than a
// declaration.
CXNamedDecl clang_Sema_FindInstantiatedDecl(CXSema S, CXSourceLocation_ Loc, CXNamedDecl D,
                                            CXMultiLevelTemplateArgumentList TemplateArgs,
                                            bool FindingInstantiatedContext);

// The same mapping for a declaration context. A context that is not itself a named
// declaration - the translation unit, a linkage specification - comes back unchanged;
// anything else is routed through clang_Sema_FindInstantiatedDecl and carries its
// precondition.
CXDeclContext
clang_Sema_FindInstantiatedContext(CXSema S, CXSourceLocation_ Loc, CXDeclContext DC,
                                   CXMultiLevelTemplateArgumentList TemplateArgs);

// The single function template specialization Ovl names, or null when the overload set does
// not resolve to exactly one. *FoundDecl and *FoundAccess, both of which must be non-null,
// receive the two halves of the DeclAccessPair clang reports (MARSHALLING.md section 7) and
// are only meaningful when the return is non-null. Complain reports why a set did not
// resolve through Sema's DiagnosticsEngine; false makes the call a pure query.
CXFunctionDecl clang_Sema_ResolveSingleFunctionTemplateSpecialization(
    CXSema S, CXOverloadExpr Ovl, bool Complain, CXNamedDecl *FoundDecl,
    CXAccessSpecifier *FoundAccess);

// T with the Objective-C lifetime qualifier a parameter of that type would be given
// inferred. Outside ARC clang returns T unchanged, so this is the identity in a C or C++
// translation unit. TSInfo supplies the source range the inference is reported against and
// must be non-null.
CXQualType clang_Sema_AdjustParameterTypeForObjCAutoRefCount(CXSema S, CXQualType T,
                                                             CXSourceLocation_ NameLoc,
                                                             CXTypeSourceInfo TSInfo);

// clang/Sema/Sema.h: enum class Sema::FnBodyKind
typedef enum CXFnBodyKind {
  CXFnBodyKind_Other,
  CXFnBodyKind_Default,
  CXFnBodyKind_Delete
} CXFnBodyKind;

// Give D the body kind a `= default;` or `= delete;` definition would give it. Only
// CXFnBodyKind_Default and CXFnBodyKind_Delete name a body clang can install here;
// CXFnBodyKind_Other is the parser's "an ordinary compound statement follows" state, which
// this entry point has no handling for. A D that is not a function, a function that already
// has a body, and a redeclaration of a function declared earlier are each diagnosed.
void clang_Sema_SetFunctionBodyKind(CXSema S, CXDecl D, CXSourceLocation_ Loc,
                                    CXFnBodyKind BodyKind);

// Set the floating-point exception behaviour in force from Loc on, exactly as
// `#pragma clang fp exceptions(...)` would. The change lands in Sema's current FPFeatures,
// so clang_Sema_CurFPFeatureOverrides reports it afterwards, and it stays in force for
// every expression built later.
void clang_Sema_setExceptionMode(CXSema S, CXSourceLocation_ Loc,
                                 CXFPExceptionModeKind FPE);

// Record ND in the side table Sema keeps for block-scope `extern "C"` declarations - the
// table clang_Sema_findLocallyScopedExternCDecl reads. Sc names the scope the declaration
// was seen in and may be null.
void clang_Sema_RegisterLocallyScopedExternCDecl(CXSema S, CXNamedDecl ND, CXScope Sc);

// Give New the type merged from its own and Old's, as a redeclaration of Old would.
// MergeTypeWithOld picks Old's type where the two differ only in a way the merge tolerates.
// Types that do not merge are diagnosed at New and leave it invalid.
void clang_Sema_MergeVarDeclTypes(CXSema S, CXVarDecl New, CXVarDecl Old,
                                  bool MergeTypeWithOld);

// Check that New and Old agree on the exception specification of the prototyped function
// type they point or refer to, and mark New invalid when they do not. A variable that is
// not a pointer or reference to such a function is left alone. A mismatch is diagnosed.
void clang_Sema_MergeVarDeclExceptionSpecs(CXSema S, CXVarDecl New, CXVarDecl Old);

// --- Rebuilding declarations, parameters and template names ---
//
// The declaration half of the Subst* family. Where clang_Sema_SubstType rebuilds a type,
// these rebuild the declarations that mention one, so on top of a live
// CXInstantiatingTemplate they need a second piece of parser state: a live
// clang::LocalInstantiationScope (clang-ex/Sema/CXTemplate.h), which is where the
// pattern-to-instance mapping for parameters and local declarations is recorded.

// helper: whether Sema::CurrentInstantiationScope is set. clang writes through that
// pointer with no null check while rebuilding a declaration, so an unset scope is a
// segfault rather than a failed substitution; exporting the flag lets the Julia wrapper
// reject the call instead (MARSHALLING.md §13).
bool clang_Sema_hasCurrentInstantiationScope(CXSema S);

// The function-type overload of Sema::SubstType. A function-prototype TypeLoc is
// transformed specially so that `this` inside the parameters and the trailing return type
// resolves against ThisContext with ThisTypeQuals applied; ThisContext may be NULL and
// ThisTypeQuals is a clang::Qualifiers opaque value. Rebuilding a prototype rebuilds its
// parameters, so a live LocalInstantiationScope is a precondition too. Null on failure.
CXTypeSourceInfo clang_Sema_SubstFunctionDeclType(
    CXSema S, CXTypeSourceInfo T, CXMultiLevelTemplateArgumentList TemplateArgs,
    CXSourceLocation_ Loc, CXDeclarationName Entity, CXCXXRecordDecl ThisContext,
    unsigned ThisTypeQuals, bool EvaluateConstraints);

// Substitutes into Proto's exception specification and installs the result on New and
// every redeclaration of it. PRECONDITION: New has a TypeSourceInfo - clang reads its
// TypeLoc for the diagnostic location with no null check. A no-op when Proto's exception
// specification is neither a computed noexcept nor a dynamic list.
void clang_Sema_SubstExceptionSpec(CXSema S, CXFunctionDecl New, CXFunctionProtoType Proto,
                                   CXMultiLevelTemplateArgumentList TemplateArgs);

// Rebuilds parameter D for an instantiated function. IndexAdjustment shifts the new
// parameter's index; the std::optional<unsigned> NumExpansions flattens to the
// (HasNumExpansions, NumExpansions) pair of MARSHALLING.md §8. The new parameter is
// created in the translation unit until the caller reparents it, and the D -> result
// mapping is recorded in Sema::CurrentInstantiationScope, which must therefore be live.
// Null on substitution failure.
CXParmVarDecl clang_Sema_SubstParmVarDecl(CXSema S, CXParmVarDecl D,
                                          CXMultiLevelTemplateArgumentList TemplateArgs,
                                          int IndexAdjustment, bool HasNumExpansions,
                                          unsigned NumExpansions, bool ExpectParameterPack,
                                          bool EvaluateConstraints);

// The parameter-list half of rebuilding a function prototype: substitutes TemplateArgs into
// the types of Params. Capacity-bounded fill (MARSHALLING.md section 6) over two parallel
// output arrays read in lockstep - at most Capacity entries are written to ParamTypes and,
// when OutParams is non-null, to OutParams - while *NumParamTypes always reports the true
// total, which a pack expansion makes differ from NumParams. ParamTypes may be NULL to take
// the count alone, but the substitution still runs and rebuilds the parameters, so a second
// call builds a second set. clang's ExtParameterInfos input and the ExtParameterInfoBuilder
// it fills are deliberately not exposed: they only mean anything to a caller that goes on
// to build a FunctionProtoType, and clang_ASTContext_getFunctionType does not carry them
// either. Each rebuilt parameter is recorded in Sema::CurrentInstantiationScope, which must
// be live. Returns true on error.
bool clang_Sema_SubstParmTypes(CXSema S, CXSourceLocation_ Loc, const CXParmVarDecl *Params,
                               unsigned NumParams,
                               CXMultiLevelTemplateArgumentList TemplateArgs,
                               CXQualType *ParamTypes, CXParmVarDecl *OutParams,
                               unsigned Capacity, unsigned *NumParamTypes);

// Substitutes TemplateArgs into Param's uninstantiated default argument and installs the
// result as its real default argument, so afterwards clang_ParmVarDecl_hasDefaultArg(Param)
// holds and clang_ParmVarDecl_hasUninstantiatedDefaultArg(Param) does not. PRECONDITIONS:
// clang_ParmVarDecl_hasUninstantiatedDefaultArg(Param) - the pattern is read through an
// accessor that asserts otherwise - and Param's DeclContext is a FunctionDecl, which clang
// reaches with an unchecked cast. TemplateArgs must have at least one level: clang takes
// its innermost list to name the code-synthesis record it opens around the substitution.
// ForCallExpr checks the substituted expression as an argument of a call rather than as a
// parameter initializer. Returns true on error, which is diagnosed.
bool clang_Sema_SubstDefaultArgument(CXSema S, CXSourceLocation_ Loc, CXParmVarDecl Param,
                                     CXMultiLevelTemplateArgumentList TemplateArgs,
                                     bool ForCallExpr);

// Substitutes into a whole list of expressions, expanding pack expansions, so the number
// of results is not the number of inputs. Capacity-bounded fill (MARSHALLING.md §6): at
// most OutputsCapacity handles are written to Outputs, while *NumOutputs always reports
// the true total, so a caller that under-allocated can size a second call from it.
// Outputs may be NULL to take the count alone, but the substitution still runs and builds
// the result nodes, so a second call builds a second set. Returns true on error.
bool clang_Sema_SubstExprs(CXSema S, const CXExpr *Exprs, unsigned NumExprs, bool IsCall,
                           CXMultiLevelTemplateArgumentList TemplateArgs, CXExpr *Outputs,
                           unsigned OutputsCapacity, unsigned *NumOutputs);

// Rebuilds the template parameter list Params, creating each new parameter in Owner, with
// TemplateArgs substituted into its type, default argument and type constraint. Each
// rebuilt parameter is recorded in Sema::CurrentInstantiationScope, which must be live.
// Null when any parameter failed to substitute.
CXTemplateParameterList clang_Sema_SubstTemplateParams(
    CXSema S, CXTemplateParameterList Params, CXDeclContext Owner,
    CXMultiLevelTemplateArgumentList TemplateArgs, bool EvaluateConstraints);

// Substitutes TemplateArgs into the written template arguments Args and appends the results
// to Outputs, a caller-owned CXTemplateArgumentListInfo
// (clang_TemplateArgumentListInfo_create). Args is a buffer of handles to
// clang::TemplateArgumentLoc values which the shim copies into the contiguous value array
// clang wants (MARSHALLING.md section 11); the handles keep whatever ownership they already
// had. A pack expansion makes the number of entries appended differ from NumArgs, and
// whatever Outputs already held is kept. Needs a live CXInstantiatingTemplate. Returns true
// on error.
bool clang_Sema_SubstTemplateArguments(CXSema S, const CXTemplateArgumentLoc *Args,
                                       unsigned NumArgs,
                                       CXMultiLevelTemplateArgumentList TemplateArgs,
                                       CXTemplateArgumentListInfo Outputs);

// Rebuilds declaration D inside Owner. This is the declaration-level counterpart of
// clang_Sema_SubstType and it MUTATES Owner: most declaration kinds are added to it as
// they are built. Needs a live LocalInstantiationScope. The result's dynamic class is D's
// own, so the Julia layer wraps it at the Decl floor. Null when substitution failed.
CXDecl clang_Sema_SubstDecl(CXSema S, CXDecl D, CXDeclContext Owner,
                            CXMultiLevelTemplateArgumentList TemplateArgs);

// Substitutes TemplateArgs into Pattern's base-specifier list and attaches the result to
// Instantiation, which it MUTATES. PRECONDITION: Pattern has a definition - its bases()
// range goes through CXXRecordDecl::data() with no check. A Pattern with no bases is a
// total no-op: clang attaches nothing and reports success. Needs a live
// CXInstantiatingTemplate. Returns true when a base failed to substitute or the attached
// list was rejected, which is diagnosed.
bool clang_Sema_SubstBaseSpecifiers(CXSema S, CXCXXRecordDecl Instantiation,
                                    CXCXXRecordDecl Pattern,
                                    CXMultiLevelTemplateArgumentList TemplateArgs);

// Rebuilds the template name Name, written after the optional qualifier QualifierLoc.
// QualifierLoc may be NULL, meaning the name was written unqualified. The result is a
// TemplateName encoding and is null when substitution failed.
CXTemplateName clang_Sema_SubstTemplateName(CXSema S, CXNestedNameSpecifierLoc QualifierLoc,
                                            CXTemplateName Name, CXSourceLocation_ Loc,
                                            CXMultiLevelTemplateArgumentList TemplateArgs);

// Instantiates Pattern's default member initializer into Instantiation. Returns true on
// error and false, without reading anything else out of either field, when Pattern has no
// default member initializer at all. When Pattern does have one, clang asserts that the
// two fields agree on their in-class initializer style.
bool clang_Sema_InstantiateInClassInitializer(
    CXSema S, CXSourceLocation_ PointOfInstantiation, CXFieldDecl Instantiation,
    CXFieldDecl Pattern, CXMultiLevelTemplateArgumentList TemplateArgs);

// Copies Pattern's attributes onto Inst, substituting TemplateArgs into the ones carrying
// expressions or types. OuterMostScope may be NULL. clang's LateAttrs out-parameter is
// deliberately not exposed: it exists so the parser can defer attributes whose arguments
// are not parsed yet, and nothing outside the parser can consume one - passing NULL is
// what clang itself does off the parser path.
void clang_Sema_InstantiateAttrs(CXSema S, CXMultiLevelTemplateArgumentList TemplateArgs,
                                 CXDecl Pattern, CXDecl Inst,
                                 CXLocalInstantiationScope OuterMostScope);

// The subset of clang_Sema_InstantiateAttrs that has to run before the instantiated
// declaration's type is built. A no-op unless Inst is a NamedDecl.
void clang_Sema_InstantiateAttrsForDecl(CXSema S,
                                        CXMultiLevelTemplateArgumentList TemplateArgs,
                                        CXDecl Pattern, CXDecl Inst,
                                        CXLocalInstantiationScope OuterMostScope);

// Replays the access checks Sema deferred while parsing the dependent context Pattern,
// now that TemplateArgs makes them checkable. PRECONDITION:
// clang_DeclContext_isDependentContext(Pattern) - clang asserts it before iterating the
// stored diagnostics.
void clang_Sema_PerformDependentDiagnostics(CXSema S, CXDeclContext Pattern,
                                            CXMultiLevelTemplateArgumentList TemplateArgs);

// --- Per-operator operand type checking --------------------------------------
// The checks CreateBuiltinBinOp dispatches to once it knows the opcode. Each answers the
// type the operator yields, or a null QualType when the operands are ill-formed -- which
// is diagnosed at Loc. The operands cross as in/out slots: *LHS and *RHS are read on
// entry and overwritten with the operands after the conversions the check inserted, a
// slot going null when that operand's own conversion failed. Both pointers must be
// non-null. This is the same shape as clang_Sema_UsualArithmeticConversions.

// `*` and `/`. IsDivide selects the division-specific diagnostics; IsCompAssign says the
// caller is checking `*=` or `/=` rather than the plain operator.
CXQualType clang_Sema_CheckMultiplyDivideOperands(CXSema S, CXExpr *LHS, CXExpr *RHS,
                                                  CXSourceLocation_ Loc, bool IsCompAssign,
                                                  bool IsDivide);

// `%` and `%=`. Both operands must end up integral, which is what a null return reports.
CXQualType clang_Sema_CheckRemainderOperands(CXSema S, CXExpr *LHS, CXExpr *RHS,
                                             CXSourceLocation_ Loc, bool IsCompAssign);

// `+` and `+=`; Opc distinguishes them in the diagnostics. IsCompAssign additionally
// turns on the CompLHSTy out-parameter, which receives the left operand's type before
// the usual arithmetic conversions -- the type a compound assignment converts back to.
// *CompLHSTy must be non-null and is left untouched when IsCompAssign is false.
CXQualType clang_Sema_CheckAdditionOperands(CXSema S, CXExpr *LHS, CXExpr *RHS,
                                            CXSourceLocation_ Loc, CXBinaryOperatorKind Opc,
                                            bool IsCompAssign, CXQualType *CompLHSTy);

// `-` and `-=`, with the same CompLHSTy protocol as CheckAdditionOperands.
CXQualType clang_Sema_CheckSubtractionOperands(CXSema S, CXExpr *LHS, CXExpr *RHS,
                                               CXSourceLocation_ Loc, bool IsCompAssign,
                                               CXQualType *CompLHSTy);

// `<<` and `>>`, and their compound forms.
CXQualType clang_Sema_CheckShiftOperands(CXSema S, CXExpr *LHS, CXExpr *RHS,
                                         CXSourceLocation_ Loc, CXBinaryOperatorKind Opc,
                                         bool IsCompAssign);

// Warn about comparing a pointer against a '\0' character literal. Neither operand being
// a pointer returns before the warning, so this is a no-op on arithmetic operands.
void clang_Sema_CheckPtrComparisonWithNullChar(CXSema S, CXExpr *E, CXExpr *NullE);

// The relational, equality and three-way comparison operators.
CXQualType clang_Sema_CheckCompareOperands(CXSema S, CXExpr *LHS, CXExpr *RHS,
                                           CXSourceLocation_ Loc, CXBinaryOperatorKind Opc);

// Simple and compound assignment. Unlike the operators above the left operand is never
// converted, so it crosses as a plain handle and only *RHS is in/out. A null CompoundType
// selects simple assignment; otherwise it is the type the compound operator computed.
// PRECONDITION: LHSExpr is a modifiable lvalue -- anything else is diagnosed at Loc.
CXQualType clang_Sema_CheckAssignmentOperands(CXSema S, CXExpr LHSExpr, CXExpr *RHS,
                                              CXSourceLocation_ Loc,
                                              CXQualType CompoundType,
                                              CXBinaryOperatorKind Opc);

// The `.*` (IsIndirect false) and `->*` (IsIndirect true) operators. *VK, which must be
// non-null, receives the value kind of the result. PRECONDITIONS: the right operand has
// member-pointer type, and for `->*` the left operand is a pointer -- clang diagnoses
// anything else at OpLoc.
CXQualType clang_Sema_CheckPointerToMemberOperands(CXSema S, CXExpr *LHS, CXExpr *RHS,
                                                   CXExprValueKind *VK,
                                                   CXSourceLocation_ OpLoc,
                                                   bool IsIndirect);

// The unary `&`. *Operand is in/out as above. The result is a pointer or
// pointer-to-member type, or a null QualType when the operand's address cannot be taken,
// which is diagnosed at OpLoc.
CXQualType clang_Sema_CheckAddressOfOperand(CXSema S, CXExpr *Operand,
                                            CXSourceLocation_ OpLoc);

// --- Casts and conversions ---------------------------------------------------

// Convert CastExpr to the extended vector type DestTy, splatting a scalar across it.
// Returns the converted expression, or null with *IsInvalid set; *Kind receives the cast
// kind. PRECONDITIONS: DestTy is an ext_vector type (clang asserts on it), and a scalar
// CastExpr has already undergone the lvalue-to-rvalue conversion -- the splat is inserted
// as an implicit prvalue cast, which clang asserts against an operand still an lvalue.
CXExpr clang_Sema_CheckExtVectorCast(CXSema S, CXSourceLocation_ R_begin,
                                     CXSourceLocation_ R_end, CXQualType DestTy,
                                     CXExpr CastExpr, CXCastKind *Kind, bool *IsInvalid);

// True when converting From to the member-pointer type ToType is ill-formed, with *Kind
// receiving the cast kind the conversion would use. IgnoreBaseAccess skips the access
// check on the base step; the CXXCastPath out-parameter is not exposed, matching
// clang_Sema_CheckPointerConversion. PRECONDITIONS: ToType is a member-pointer type
// (unchecked castAs), and From either has member-pointer type too or is a null pointer
// constant -- clang asserts the latter.
bool clang_Sema_CheckMemberPointerConversion(CXSema S, CXExpr From, CXQualType ToType,
                                             CXCastKind *Kind, bool IgnoreBaseAccess);

// --- Declaration-level checks ------------------------------------------------

// True when New may override Old as far as the explicit-object-parameter rule goes. A
// violation is diagnosed at New and marks it invalid; an overrider with no explicit
// object parameter is accepted without any diagnostic.
bool clang_Sema_CheckExplicitObjectOverride(CXSema S, CXCXXMethodDecl New,
                                            CXCXXMethodDecl Old);

// Run the exception-specification checks Sema deferred while a class was still being
// defined, then clear the deferred lists. Between parses both lists are empty, so this
// does nothing.
void clang_Sema_CheckDelayedMemberExceptionSpecs(CXSema S);

// Diagnose a function whose return type carries the CoroReturnType attribute but which is
// neither a coroutine nor marked as a coroutine wrapper. A function whose return type is
// not such a record returns immediately, so this is a no-op on ordinary functions.
void clang_Sema_CheckCoroutineWrapper(CXSema S, CXFunctionDecl FD);

// --- Overloaded-operator calls, default initializers and member initializers ---
//
// Each entry point below builds an AST node out of operands the caller already holds and
// pushes nothing onto Sema's scope stacks, so all of them can run between parses. The
// ExprResult / StmtResult / MemInitResult returns are DISCRIMINATED pairs: the node
// crosses as the function result and the validity through *IsInvalid, because an invalid
// result is not the same thing as a null node.

// Overload resolution for `Base[Args...]` over Base's operator[] members. Args is a
// (buffer, count) pair rebuilt as a MultiExprArg (MARSHALLING.md section 11).
// PRECONDITION: Base has class type, since operator[] is only ever a member.
CXExpr clang_Sema_CreateOverloadedArraySubscriptExpr(CXSema S, CXSourceLocation_ LLoc,
                                                     CXSourceLocation_ RLoc, CXExpr Base,
                                                     const CXExpr *Args, unsigned NumArgs,
                                                     bool *IsInvalid);

// Overload resolution for `Object(Args...)` over Object's operator() members and its
// surrogate conversions to function pointers. Args is a (buffer, count) pair; Sp may be
// null. PRECONDITION: Object has class type (clang asserts).
CXExpr clang_Sema_BuildCallToObjectOfClassType(CXSema S, CXScope Sp, CXExpr Object,
                                               CXSourceLocation_ LParenLoc,
                                               const CXExpr *Args, unsigned NumArgs,
                                               CXSourceLocation_ RParenLoc,
                                               bool *IsInvalid);

// Overload resolution for `Base->` over Base's operator-> members; one step only, so the
// result is whatever that operator returns. Sp may be null. *NoArrowOperatorFound is a
// second discriminator, independent of *IsInvalid: it is set when the class declares no
// operator-> at all. PRECONDITION: Base has class type (clang asserts).
CXExpr clang_Sema_BuildOverloadedArrowExpr(CXSema S, CXScope Sp, CXExpr Base,
                                           CXSourceLocation_ OpLoc,
                                           bool *NoArrowOperatorFound, bool *IsInvalid);

// Attrs is a (buffer, count) pair rebuilt as an ArrayRef (MARSHALLING.md section 11); the
// attributes are copied into the node's trailing storage, so the buffer need not outlive
// the call. PRECONDITION: clang::AttributedStmt::Create requires a non-empty list.
CXStmt clang_Sema_BuildAttributedStmt(CXSema S, CXSourceLocation_ AttrsLoc,
                                      const CXAttr *Attrs, unsigned NumAttrs,
                                      CXStmt SubStmt, bool *IsInvalid);

// _Generic(ControllingExprOrType, Types[I]: Exprs[I], ...). The controlling operand is a
// discriminated union (MARSHALLING.md section 8): PredicateIsExpr selects CXExpr, and
// CXTypeSourceInfo otherwise. Types and Exprs are parallel (buffer, count) arrays of the
// same length NumAssocs (MARSHALLING.md section 11); a null Types[I] slot is the `default`
// association. PRECONDITION: ControllingExprOrType is non-null (clang asserts) and exactly
// one association selects, which is what clang diagnoses when it does not hold.
CXExpr clang_Sema_CreateGenericSelectionExpr(
    CXSema S, CXSourceLocation_ KeyLoc, CXSourceLocation_ DefaultLoc,
    CXSourceLocation_ RParenLoc, bool PredicateIsExpr, void *ControllingExprOrType,
    const CXTypeSourceInfo *Types, const CXExpr *Exprs, unsigned NumAssocs,
    bool *IsInvalid);

// A call of the already-resolved NDecl through the callee expression Fn, converting Args
// to the parameter types and filling in default arguments. Args is a (buffer, count) pair
// (MARSHALLING.md section 11); Config may be null. UsesADL is clang::Sema::ADLCallKind
// flattened to a bool, read back by clang_CallExpr_usesADL.
CXExpr clang_Sema_BuildResolvedCallExpr(CXSema S, CXExpr Fn, CXNamedDecl NDecl,
                                        CXSourceLocation_ LParenLoc, const CXExpr *Args,
                                        unsigned NumArgs, CXSourceLocation_ RParenLoc,
                                        CXExpr Config, bool IsExecConfig, bool UsesADL,
                                        bool *IsInvalid);

// A CXXDefaultInitExpr standing for Field's in-class initializer, instantiating that
// initializer if it has not been instantiated yet. PRECONDITION: Field has an in-class
// initializer (clang asserts) and its parent is a C++ class (reached through an unchecked
// cast<>).
CXExpr clang_Sema_BuildCXXDefaultInitExpr(CXSema S, CXSourceLocation_ Loc,
                                          CXFieldDecl Field, bool *IsInvalid);

// A CXXDefaultArgExpr standing for Param's default argument in a call of FD,
// instantiating that argument if needed. Init may be null, which is the ordinary case.
// PRECONDITION: Param has a default argument.
CXExpr clang_Sema_BuildCXXDefaultArgExpr(CXSema S, CXSourceLocation_ CallLoc,
                                         CXFunctionDecl FD, CXParmVarDecl Param,
                                         CXExpr Init, bool *IsInvalid);

// A call of the conversion function Method on the object expression Exp. FoundDecl is
// what name lookup produced, normally Method itself. PRECONDITION: Exp has class type and
// that class declares or inherits Method: clang initializes Method's implicit object
// parameter from Exp with no fallback.
CXExpr clang_Sema_BuildCXXMemberCallExpr(CXSema S, CXExpr Exp, CXNamedDecl FoundDecl,
                                         CXCXXConversionDecl Method,
                                         bool HadMultipleCandidates, bool *IsInvalid);

// The CXXCtorInitializer that initializes Member from Init. PRECONDITION: Member is a
// FieldDecl or an IndirectFieldDecl (clang asserts).
CXCXXCtorInitializer clang_Sema_BuildMemberInitializer(CXSema S, CXValueDecl Member,
                                                       CXExpr Init, CXSourceLocation_ IdLoc,
                                                       bool *IsInvalid);

// Whether D is an Objective-C method declaration. Total: the clang method is
// `D && isa<ObjCMethodDecl>(D)`, so a null D answers false.
bool clang_Sema_isObjCMethodDecl(CXSema S, CXDecl D);

// Whether the body of the function (or function template) D may be skipped
// without breaking the parse of the rest of the translation unit. clang asks the
// ASTConsumer last, so the answer depends on the frontend action in flight. D
// must be non-null.
bool clang_Sema_canSkipFunctionBody(CXSema S, CXDecl D);

// Whether New and Old declare the same entity in two different modules, which
// makes New a redefinition. Both must be non-null.
bool clang_Sema_IsRedefinitionInModule(CXSema S, CXNamedDecl New, CXNamedDecl Old);

// Whether Str is a section specifier the target accepts. The clang method returns
// llvm::Error; the error is consumed here and reported as false. Only Darwin
// targets parse the specifier at all -- every other target accepts any string, so
// the answer is host-dependent.
bool clang_Sema_isValidSectionSpecifier(CXSema S, const char *Str);

// Whether D is a file-scoped declaration worth warning about if it ends up
// unused. D must be non-null.
bool clang_Sema_ShouldWarnIfUnusedFileScopedDecl(CXSema S, CXDeclaratorDecl D);

// Why D cannot be odr-used in the expression evaluation context Sema currently
// sits in, or CXNonOdrUseReason_NOUR_None when it can. Reads the
// expression-evaluation-context stack, which Sema's constructor primes, so it is
// defined between parses. D must be non-null.
CXNonOdrUseReason clang_Sema_getNonOdrUseReasonInCurrentContext(CXSema S, CXValueDecl D);

// Whether E names a class member through an explicit nested-name-specifier, as in
// `&C::m`. E must be non-null.
bool clang_Sema_isQualifiedMemberAccess(CXSema S, CXExpr E);

// The result type of a lambda's conversion-to-function-pointer operator, given
// the type CallOpType of its call operator and the calling convention wanted.
// CallOpType must be non-null and must carry no ref-qualifier: clang copies its
// ExtProtoInfo and asserts the invoker never gains one.
CXQualType clang_Sema_getLambdaConversionFunctionResultType(CXSema S,
                                                            CXFunctionProtoType CallOpType,
                                                            CXCallingConv_ CC);

// Whether D is accessible from Sema's current context when named through
// NamingClass on an object of BaseType. All three must be non-null, and BaseType
// is expected to be NamingClass's own type -- clang builds one access-check
// entity out of the pair and does not re-derive either from the other.
bool clang_Sema_IsSimplyAccessible(CXSema S, CXNamedDecl D, CXCXXRecordDecl NamingClass,
                                   CXQualType BaseType);

// The outermost point of instantiation that led to ND, or ND's own location when
// no instantiation is in flight. ND must be non-null.
CXSourceLocation_ clang_Sema_getTopMostPointOfInstantiation(CXSema S, CXNamedDecl ND);

// Whether Sema sits inside a SFINAE context, where template argument substitution
// failures are not errors. On true, *Info (when Info is non-null) receives the
// nearest template-deduction context, which is itself null for a SFINAE context
// that records no diagnostics -- the discriminator/payload split of
// MARSHALLING.md section 8, since std::optional<T *> conflates neither arm here.
bool clang_Sema_isSFINAEContext(CXSema S, CXTemplateDeductionInfo *Info);

// Heuristic, decided from the name alone: whether FD could be the
// `get_return_object_on_allocation_failure` member of a coroutine promise type.
// Static member of clang::Sema, so there is no Sema receiver. FD must be
// non-null.
bool clang_Sema_CanBeGetReturnTypeOnAllocFailure(CXFunctionDecl FD);

// Whether a `#pragma omp begin assumes` region is currently open.
bool clang_Sema_isInOpenMPAssumeScope(CXSema S);

// Whether a global `#pragma omp assumes` directive is in effect.
bool clang_Sema_hasGlobalOpenMPAssumes(CXSema S);

// Whether CCK denotes a cast rather than an implicit conversion. Static member of
// clang::Sema, so there is no Sema receiver.
bool clang_Sema_isCast(CXCheckedConversionKind CCK);

// Which flavour of variadic call an argument promotion through Proto belongs to.
// FDecl is the callee when one is known and Fn the callee expression; clang tests
// both for null itself, so either may be null here.
CXVariadicCallType clang_Sema_getVariadicCallType(CXSema S, CXFunctionDecl FDecl,
                                                  CXFunctionProtoType Proto, CXExpr Fn);

// Whether D carries both an implicit __host__ and an implicit __device__
// attribute. Static member of clang::Sema, so there is no Sema receiver. D must
// be non-null.
bool clang_Sema_isCUDAImplicitHostDeviceFunction(CXFunctionDecl D);

// The name of the kernel launch configuration function for the CUDA/HIP dialect
// and target SDK version in effect. Julia frees the CXString.
CXString clang_Sema_getCudaConfigureFuncName(CXSema S);

// The identifier "NSError", interned on first use.
CXIdentifierInfo clang_Sema_getNSErrorIdent(CXSema S);

// The identifier Objective-C spells `super`, interned on first use.
CXIdentifierInfo clang_Sema_getSuperIdentifier(CXSema S);

// --- External-source loads, cleanup wrapping and the remaining conversion helpers ---
//
// Declared in the order clang::Sema declares them.

// Pull the `#pragma weak` identifiers recorded by an external AST source into
// Sema's own table. A no-op when no ExternalSemaSource is attached, which is the
// case for an interpreter that has loaded neither a PCH nor a module file.
void clang_Sema_LoadExternalWeakUndeclaredIdentifiers(CXSema S);

// The pretty-printed spelling of the conjunct of the boolean constant expression
// Cond that evaluated to false; *FailedCond (which must be non-null) receives that
// sub-expression. Cond must be non-null, and *FailedCond is never null on return,
// because clang falls back to Cond itself when no conjunct could be blamed. This
// is the two-component split of MARSHALLING.md section 7 applied to a
// std::pair<Expr *, std::string>. Julia frees the CXString.
CXString clang_Sema_findFailedBooleanCondition(CXSema S, CXExpr Cond, CXExpr *FailedCond);

// Whether Callee is discarded by the CUDA/HIP or OpenMP host/device split, and so
// takes no part in the host/device call check. Defined for an ordinary C++
// translation unit too, where nothing is discarded. Callee must be non-null.
bool clang_Sema_shouldIgnoreInHostDeviceCheck(CXSema S, CXFunctionDecl Callee);

// T carrying the calling convention a member function has in the target's ABI,
// when T does not name one explicitly. PRECONDITION: T is a function type -- clang
// reaches the FunctionType through an unchecked castAs<>. Loc only locates a
// diagnostic, which clang reaches solely when an explicitly written convention
// cannot be honoured.
CXQualType clang_Sema_adjustMemberFunctionCC(CXSema S, CXQualType T, bool HasThisPointer,
                                             bool IsCtorOrDtor, CXSourceLocation_ Loc);

// Prepare E to be the operand of typeof/decltype: a placeholder is resolved, and a
// variably-modified operand is transformed back to a potentially-evaluated one.
// ExprResult crosses split (MARSHALLING.md section 8): *IsInvalid is the
// discriminator and the returned CXExpr the payload.
CXExpr clang_Sema_HandleExprEvaluationContextForTypeof(CXSema S, CXExpr E, bool *IsInvalid);

// Copy-initialize a temporary of type Ty from E and hand back the converted
// expression. A conversion clang cannot sequence comes back with *IsInvalid set
// and no diagnostic, since the sequence is checked before it is performed.
// ExprResult crosses split, as above.
CXExpr clang_Sema_tryConvertExprToType(CXSema S, CXExpr E, CXQualType Ty, bool *IsInvalid);

// The cast kind taking Src's type to DestTy. PRECONDITIONS: both types are scalar
// (clang asserts it) and Src's type is not a member-pointer type (clang reaches an
// llvm_unreachable for that scalar kind). Some conversions rewrite the operand, so
// *Adjusted -- which must be non-null -- receives the source expression clang ended
// up with; that is Src itself when nothing was rewritten, and null when the
// rewrite failed.
CXCastKind clang_Sema_PrepareScalarCast(CXSema S, CXExpr Src, CXQualType DestTy,
                                        CXExpr *Adjusted);

// Wrap SubExpr in an ExprWithCleanups when the full-expression under construction
// needs cleanups, otherwise hand SubExpr straight back. SubExpr must be non-null.
CXExpr clang_Sema_MaybeCreateExprWithCleanups(CXSema S, CXExpr SubExpr);

// The statement form: wraps SubStmt in a StmtExpr carrying the cleanups when any
// are pending, otherwise returns SubStmt. SubStmt must be non-null.
CXStmt clang_Sema_MaybeCreateStmtWithCleanups(CXSema S, CXStmt SubStmt);

// Pull the vtable uses recorded by an external AST source into Sema's own set. A
// no-op when no ExternalSemaSource is attached.
void clang_Sema_LoadExternalVTableUses(CXSema S);

// The text of a static_assert message. *Ok (which must be non-null) receives
// whether the message could be evaluated, and the CXString -- always returned, and
// always freed by Julia -- is empty when it could not. PRECONDITION: Message is a
// non-dependent StringLiteral, or an object of class type modelling the
// size()/data() protocol; every other operand is diagnosed at Message's location.
CXString clang_Sema_EvaluateStaticAssertMessageAsString(CXSema S, CXExpr Message,
                                                        CXASTContext Ctx,
                                                        bool ErrorOnInvalidMessage,
                                                        bool *Ok);

// Whether two constraint expressions are the same, ignoring a difference in
// template depth. Old and New are the declarations the constraints were written
// on; both may be null, and New crosses as the plain NamedDecl arm of
// clang::Sema::TemplateCompareNewDeclInfo, which that class converts implicitly.
// OldConstr and NewConstr must be non-null.
bool clang_Sema_AreConstraintExpressionsEqual(CXSema S, CXNamedDecl Old, CXExpr OldConstr,
                                              CXNamedDecl New, CXExpr NewConstr);

// Insert an implicit cast of E to Type, merging into an implicit cast E already
// carries. The CXXCastPath parameter is always null here, so this builds no
// base-class path; the cast builders cover that. ExprResult crosses split, as
// above. PRECONDITIONS mirror clang's own assertions: a VK_PRValue result needs E
// to be a prvalue already unless CK is one of CK_Dependent, CK_LValueToRValue,
// CK_ArrayToPointerDecay, CK_FunctionToPointerDecay, CK_ToVoid or
// CK_NonAtomicToAtomic, and a glvalue result needs E not to be a prvalue.
CXExpr clang_Sema_ImpCastExprToType(CXSema S, CXExpr E, CXQualType Type, CXCastKind CK,
                                    CXExprValueKind VK, CXCheckedConversionKind CCK,
                                    bool *IsInvalid);

// --- Argument, alignment and throw-operand checks -----------------------------

// Check an argument list for placeholder types clang will not handle later. Args is a
// (buffer, count) pair (MARSHALLING.md section 11) read AND written in place: an
// argument carrying a placeholder type is replaced by its converted form, an argument
// without one is left untouched, and a slot goes null when its own conversion failed.
// Returns true when any argument could not be converted, which is diagnosed at that
// argument.
bool clang_Sema_CheckArgsForPlaceholders(CXSema S, CXExpr *Args, unsigned NumArgs);

// The first enable_if attribute on Function whose condition fails for the argument list
// Args, or null when every condition succeeds -- which is also what a Function carrying
// no enable_if attribute reports, since the loop is then empty. Args is a (buffer,
// count) pair (MARSHALLING.md section 11); MissingImplicitThis says Args leaves the
// implicit object argument out.
CXAttr clang_Sema_CheckEnableIf(CXSema S, CXFunctionDecl Function,
                                CXSourceLocation_ CallLoc, const CXExpr *Args,
                                unsigned NumArgs, bool MissingImplicitThis);

// True when the type TInfo designates is not a valid operand for the alignment operator
// spelled KWName -- an incomplete or function type is the usual rejection, diagnosed at
// OpLoc over [R_begin, R_end]. A null TInfo reports invalid without diagnosing.
bool clang_Sema_CheckAlignasTypeArgument(CXSema S, const char *KWName,
                                         CXTypeSourceInfo TInfo, CXSourceLocation_ OpLoc,
                                         CXSourceLocation_ R_begin,
                                         CXSourceLocation_ R_end);

// True when ThrowTy cannot be the type of an exception object thrown from E -- an
// incomplete or abstract class type, or one whose copy constructor or destructor is not
// usable, is the rejection, diagnosed at ThrowLoc. For a class type this marks the copy
// constructor and the destructor referenced, exactly as building a real throw would.
bool clang_Sema_CheckCXXThrowOperand(CXSema S, CXSourceLocation_ ThrowLoc,
                                     CXQualType ThrowTy, CXExpr E);

// --- C++ access control --------------------------------------------------------
//
// A clang::DeclAccessPair is a NamedDecl* and an AccessSpecifier packed into one word
// with no pointer form of its own, so it crosses as its two components
// (MARSHALLING.md section 7) and the shim rebuilds it with DeclAccessPair::make.

// clang/Sema/Sema.h: enum Sema::AccessResult
typedef enum CXAccessResult {
  CXAccessResult_AR_accessible,
  CXAccessResult_AR_inaccessible,
  CXAccessResult_AR_dependent,
  CXAccessResult_AR_delayed
} CXAccessResult;

// Whether the member Found, named through NamingClass with path access FoundAccess, is
// accessible from Sema's current context. An inaccessible member is diagnosed at UseLoc.
CXAccessResult clang_Sema_CheckMemberAccess(CXSema S, CXSourceLocation_ UseLoc,
                                            CXCXXRecordDecl NamingClass, CXNamedDecl Found,
                                            CXAccessSpecifier FoundAccess);

// The same check for a field reached by decomposing DecomposedClass in a structured
// binding; only the diagnostic differs from clang_Sema_CheckMemberAccess.
CXAccessResult clang_Sema_CheckStructuredBindingMemberAccess(
    CXSema S, CXSourceLocation_ UseLoc, CXCXXRecordDecl DecomposedClass, CXNamedDecl Field,
    CXAccessSpecifier FieldAccess);

// --- The remaining binary, conditional and vector operand checks ---------------
//
// The operands cross as in/out slots exactly as in the arithmetic family above: *LHS
// and *RHS (and *Cond) are read on entry and overwritten with the operands after the
// conversions the check inserted, a slot going null when that operand's own conversion
// failed. Every pointer parameter must be non-null.

// CheckBitwiseOperands, CheckLogicalOperands -- not wrapped. Both are compiled into
// clang-cpp as FILE-LOCAL symbols (nm shows `t`, not `T`), so a wrapper compiles cleanly
// and fails at link time. Their sibling CheckAdditionOperands is exported and is wrapped.

// The conditional operator `Cond ? LHS : RHS`. *VK and *OK, both of which must be
// non-null, receive the value and object kind of the result. clang dispatches to the C++
// rules from inside this entry point when the language mode is C++.
CXQualType clang_Sema_CheckConditionalOperands(CXSema S, CXExpr *Cond, CXExpr *LHS,
                                               CXExpr *RHS, CXExprValueKind *VK,
                                               CXExprObjectKind *OK,
                                               CXSourceLocation_ QuestionLoc);

// The C++ rules for the conditional operator, reached unconditionally rather than
// through the language-mode dispatch in clang_Sema_CheckConditionalOperands.
CXQualType clang_Sema_CXXCheckConditionalOperands(CXSema S, CXExpr *Cond, CXExpr *LHS,
                                                  CXExpr *RHS, CXExprValueKind *VK,
                                                  CXExprObjectKind *OK,
                                                  CXSourceLocation_ QuestionLoc);

// The vector form of the conditional operator. PRECONDITION: Cond has vector type --
// clang reaches its element type through an unchecked castAs<VectorType>.
CXQualType clang_Sema_CheckVectorConditionalTypes(CXSema S, CXExpr *Cond, CXExpr *LHS,
                                                  CXExpr *RHS,
                                                  CXSourceLocation_ QuestionLoc);

// Type-check a binary operator over vector operands, allowing one side to be a scalar of
// the element type. The four Allow*/Report flags are the per-operator policy clang's own
// callers pass: AllowBothBool admits two boolean vectors, AllowBoolConversion admits a
// conversion to a boolean vector, AllowBoolOperation admits the operation on boolean
// element types, and ReportInvalid selects whether a rejection is diagnosed at Loc or
// only reported by the null return.
CXQualType clang_Sema_CheckVectorOperands(CXSema S, CXExpr *LHS, CXExpr *RHS,
                                          CXSourceLocation_ Loc, bool IsCompAssign,
                                          bool AllowBothBool, bool AllowBoolConversion,
                                          bool AllowBoolOperation, bool ReportInvalid);

// The relational and equality operators over vector operands; the result is the signed
// integer vector type the comparison yields.
CXQualType clang_Sema_CheckVectorCompareOperands(CXSema S, CXExpr *LHS, CXExpr *RHS,
                                                 CXSourceLocation_ Loc,
                                                 CXBinaryOperatorKind Opc);

// `&&` and `||` over vector operands; the result is the signed integer vector type.
CXQualType clang_Sema_CheckVectorLogicalOperands(CXSema S, CXExpr *LHS, CXExpr *RHS,
                                                 CXSourceLocation_ Loc);

// --- Declaration and node builders taken in clang::Sema declaration order ---
//
// The clang::ExprResult / clang::StmtResult convention documented above holds here too:
// the *IsInvalid out-parameter is the discriminator and the returned handle is the payload
// (MARSHALLING.md section 8). Every node built here is ASTContext-arena memory; nothing is
// caller-owned.

// Creates the implicit declaration of builtin ID under the name II with function type Type,
// parented to the translation unit (behind an implicit extern "C" LinkageSpecDecl in C++)
// and given its parameters from Type. ID is a clang::Builtin::ID; 0 is Builtin::NotBuiltin.
// PRECONDITION: Type is a function type -- clang::FunctionDecl::Create stores it unchecked.
CXFunctionDecl clang_Sema_CreateBuiltin(CXSema S, CXIdentifierInfo II, CXQualType Type,
                                        unsigned ID, CXSourceLocation_ Loc);

// Creates the closure record a captured statement needs together with its CapturedDecl,
// both added to the nearest enclosing function, record or file context. The CapturedDecl
// crosses through the *CD out-parameter, mirroring clang's CapturedDecl *& parameter, and
// the RecordDecl is the return value; the record is left in the started-but-unfinished
// state clang leaves it in. PRECONDITION: clang_Sema_getCurLexicalContext is non-null --
// the walk up from CurContext dereferences it.
CXRecordDecl clang_Sema_CreateCapturedStmtRecordDecl(CXSema S, CXCapturedDecl *CD,
                                                     CXSourceLocation_ Loc,
                                                     unsigned NumParams);

// Builds the GNU statement expression ({ ... }) whose body is SubStmt. PRECONDITIONS:
// SubStmt is a clang::CompoundStmt (clang asserts), and clang_Sema_hasCurFunction -- clang
// reads the current function scope to propagate the body's error state and its
// branch-protected scope, and that stack is empty between parses.
CXExpr clang_Sema_BuildStmtExpr(CXSema S, CXSourceLocation_ LPLoc, CXStmt SubStmt,
                                CXSourceLocation_ RPLoc, unsigned TemplateDepth,
                                bool *IsInvalid);

// Builds __if_exists (IsIfExists) or __if_not_exists over the name QualifierLoc::NameInfo,
// guarding Nested. Both value boxes are read, not adopted. No name lookup happens here --
// that is ActOnMSDependentExistsStmt's job. PRECONDITION: Nested is a clang::CompoundStmt
// (clang casts it to one).
CXStmt clang_Sema_BuildMSDependentExistsStmt(CXSema S, CXSourceLocation_ KeywordLoc,
                                             bool IsIfExists,
                                             CXNestedNameSpecifierLoc QualifierLoc,
                                             CXDeclarationNameInfo NameInfo, CXStmt Nested,
                                             bool *IsInvalid);

// Instantiates std::initializer_list<Element> and returns its written form, which is
// sugared through an ElaboratedType. Returns a null CXQualType when the template is not
// declared or is not the single-type-parameter template clang expects; clang diagnoses at
// Loc in that case. PRECONDITION: clang_Sema_getStdNamespace is non-null.
CXQualType clang_Sema_BuildStdInitializerList(CXSema S, CXQualType Element,
                                              CXSourceLocation_ Loc);

// Builds the UsingPackDecl holding Expansions and adds it to CurContext with
// InstantiatedFrom's access. Expansions is a (buffer, count) pair rebuilt as an ArrayRef
// (MARSHALLING.md section 11); the declarations are copied into the node's trailing
// storage, so the buffer need not outlive the call. The declared return type is NamedDecl.
// PRECONDITION: clang_Sema_getCurLexicalContext is non-null -- the new declaration is added
// to it without a null check.
CXNamedDecl clang_Sema_BuildUsingPackDecl(CXSema S, CXNamedDecl InstantiatedFrom,
                                          const CXNamedDecl *Expansions,
                                          unsigned NumExpansions);

// The non-empty counterpart of clang_Sema_BuildEmptyCXXFoldExpr: builds
// ( LHS Operator ... Operator RHS ) with no checking of the operands, which is
// ActOnCXXFoldExpr's job, and gives the node the ASTContext's dependent type. Callee, LHS
// and RHS may each be null -- a unary fold leaves one side absent. The trailing
// std::optional<unsigned> flattens to the (bool HasNumExpansions, unsigned NumExpansions)
// pair of MARSHALLING.md section 8.
CXExpr clang_Sema_BuildCXXFoldExpr(CXSema S, CXUnresolvedLookupExpr Callee,
                                   CXSourceLocation_ LParenLoc, CXExpr LHS,
                                   CXBinaryOperatorKind Operator,
                                   CXSourceLocation_ EllipsisLoc, CXExpr RHS,
                                   CXSourceLocation_ RParenLoc, bool HasNumExpansions,
                                   unsigned NumExpansions, bool *IsInvalid);

// Builds a CXXThisExpr of type Type and marks it referenced, capturing `this` into any
// enclosing lambda that needs it. PRECONDITION: clang_Sema_getCurrentThisType is non-null
// -- a `this` that cannot be captured is diagnosed, and rendering that diagnostic outside a
// parse is the crash described for clang_Sema_BuildPredefinedExpr.
CXExpr clang_Sema_BuildCXXThisExpr(CXSema S, CXSourceLocation_ Loc, CXQualType Type,
                                   bool IsImplicit);

// --- Read-only queries over Sema's own state ----------------------------------
//
// None of the entry points below pushes onto a scope stack or installs a declaration, so
// all of them are defined between parses. They are declared in the order clang::Sema
// declares them.

// The declarations odr-used in this translation unit but never defined in it, each paired
// with the location clang recorded the use at. Capacity-bounded parallel component arrays
// (MARSHALLING.md sections 10 and 11): the return value is the true total, at most
// Capacity rows are written, and Decls[I] and Locs[I] are the two halves of one row. Both
// buffers may be NULL to take the count alone. clang rebuilds the list from its own map on
// each call, so a second call reports the same rows in the same order.
unsigned clang_Sema_getUndefinedButUsed(CXSema S, CXNamedDecl *Decls,
                                        CXSourceLocation_ *Locs, unsigned Capacity);

// Whether the callee of a call can throw. Static member of clang::Sema, so the Sema
// receiver is an ordinary argument. E, D and Loc are all optional per clang's own doc
// comment: either handle may be NULL and Loc may be the null encoding.
CXCanThrowResult clang_Sema_canCalleeThrow(CXSema S, CXExpr E, CXDecl D,
                                           CXSourceLocation_ Loc);

// clang/Sema/Sema.h: enum class Sema::TemplateNameKindForDiagnostics
typedef enum CXTemplateNameKindForDiagnostics {
  CXTemplateNameKindForDiagnostics_ClassTemplate,
  CXTemplateNameKindForDiagnostics_FunctionTemplate,
  CXTemplateNameKindForDiagnostics_VarTemplate,
  CXTemplateNameKindForDiagnostics_AliasTemplate,
  CXTemplateNameKindForDiagnostics_TemplateTemplateParam,
  CXTemplateNameKindForDiagnostics_Concept,
  CXTemplateNameKindForDiagnostics_DependentTemplate
} CXTemplateNameKindForDiagnostics;

// The detailed kind of the template name Name, as clang's diagnostics classify it. Name is
// a TemplateName encoding and must be non-null; one that names no declaration at all is
// reported as DependentTemplate.
CXTemplateNameKindForDiagnostics
clang_Sema_getTemplateNameKindForDiagnostics(CXSema S, CXTemplateName Name);

// clang/Sema/Sema.h: enum Sema::NonTagKind
typedef enum CXNonTagKind {
  CXNonTagKind_NTK_NonStruct,
  CXNonTagKind_NTK_NonClass,
  CXNonTagKind_NTK_NonUnion,
  CXNonTagKind_NTK_NonEnum,
  CXNonTagKind_NTK_Typedef,
  CXNonTagKind_NTK_TypeAlias,
  CXNonTagKind_NTK_Template,
  CXNonTagKind_NTK_TypeAliasTemplate,
  CXNonTagKind_NTK_TemplateTemplateArgument
} CXNonTagKind;

// How the non-tag declaration D introduces a type name, for the diagnostic that rejects it
// where a tag was written. TTK is the tag keyword the caller wrote and selects the answer
// for a D that is none of the alias or template forms. D must be non-null.
CXNonTagKind clang_Sema_getNonTagTypeDeclKind(CXSema S, CXDecl D, CXTagTypeKind TTK);

// The field of the enclosing class whose name matches SelfAssigned -- the candidate the
// self-assignment warning points at. Null unless Sema's current context is a C++ method
// whose class has such a field. SelfAssigned must be non-null.
CXFieldDecl clang_Sema_getSelfAssignmentClassMemberCandidate(CXSema S,
                                                             CXValueDecl SelfAssigned);

// Whether D may be referenced at all -- false for a deleted function, for a variable whose
// auto type is still being deduced, and for an UnresolvedUsingIfExistsDecl.
// TreatUnavailableAsInvalid additionally rejects an unavailable aligned allocation
// function. This is the non-diagnosing half of clang's use check. D must be non-null.
bool clang_Sema_CanUseDecl(CXSema S, CXNamedDecl D, bool TreatUnavailableAsInvalid);

// Whether a scalar initializing the vector type VecTy is splatted across every element
// rather than stored into element zero: true for an AltiVecVector vector, and for
// AltiVecBool and AltiVecPixel when -faltivec-src-compat=xl is in effect. VecTy must be
// non-null.
bool clang_Sema_ShouldSplatAltivecScalarInCast(CXSema S, CXVectorType VecTy);

// Whether converting FromType to ToType is ill-formed because the two disagree on their
// AArch64 SME function attributes. PRECONDITION: both are prototyped function types -- the
// attributes live on a FunctionProtoType and the query has nothing to say about any other
// type.
bool clang_Sema_IsInvalidSMECallConversion(CXSema S, CXQualType FromType,
                                           CXQualType ToType);

// Whether any declaration in R can be read as a template name. Unlike
// clang_Sema_FilterAcceptableTemplateNames this leaves R alone. The three flags say
// whether function templates, dependent names and non-template functions count. R must be
// non-null.
bool clang_Sema_hasAnyAcceptableTemplateNames(CXSema S, CXLookupResult R,
                                              bool AllowFunctionTemplates,
                                              bool AllowDependent,
                                              bool AllowNonTemplateFunctions);

// The TypeLoc of FD's written return type. A TypeLoc is a by-value object, so this one is
// heap-boxed and released with clang_TypeLoc_dispose. PRECONDITION: FD carries a
// TypeSourceInfo and its written type is a function prototype -- clang reaches the return
// location through an unchecked cast of that TypeLoc.
CXTypeLoc clang_Sema_getReturnTypeLoc(CXSema S, CXFunctionDecl FD);

// Which of two class template partial specializations is the more specialized, or null
// when neither is. Both must be partial specializations of the same class template; Loc is
// the location the partial ordering is performed at. clang overloads this on the
// specialization kind; the variable-template overload is not exposed.
CXClassTemplatePartialSpecializationDecl clang_Sema_getMoreSpecializedPartialSpecialization(
    CXSema S, CXClassTemplatePartialSpecializationDecl PS1,
    CXClassTemplatePartialSpecializationDecl PS2, CXSourceLocation_ Loc);

// Whether the class template partial specialization T is more specialized than the primary
// template it specializes -- the well-formedness rule every partial specialization has to
// satisfy. Info records the deduction failure when it is not, and must be non-null. Same
// overload note as above.
bool clang_Sema_isMoreSpecializedThanPrimary(CXSema S,
                                             CXClassTemplatePartialSpecializationDecl T,
                                             CXTemplateDeductionInfo Info);

// Whether an `omp begin/end declare variant` scope is currently open.
bool clang_Sema_isInOpenMPDeclareVariantScope(CXSema S);

// Whether an OpenMP declare target region is currently open.
bool clang_Sema_isInOpenMPDeclareTargetContext(CXSema S);

// The identifier spelling the nullability qualifier Nullability (`_Nonnull` and friends),
// interned on first use.
CXIdentifierInfo clang_Sema_getNullabilityKeyword(CXSema S, CXNullabilityKind Nullability);

// Whether D is the record `CFErrorRef` points at, which clang identifies from its bridge
// to NSError. D must be non-null.
bool clang_Sema_isCFError(CXSema S, CXRecordDecl D);

// --- The scope, declaration-context and expression-evaluation stacks -------------------
//
// Each Push has a matching Pop, and Sema's own invariants assume they nest: a Pop with no
// live Push underflows the corresponding stack. The Julia wrappers pair them and document
// that pairing; nothing here checks it, per the shim's total-and-unchecked contract.

// Enter DC as the current declaration context, remembering the one it replaces. Sc may be
// null, in which case only Sema's context stack moves.
void clang_Sema_PushDeclContext(CXSema S, CXScope Sc, CXDeclContext DC);

// Leave the current declaration context, restoring the one PushDeclContext saved.
void clang_Sema_PopDeclContext(CXSema S);

// Push a bare function scope, the base of the scope-info stack every function body needs.
void clang_Sema_PushFunctionScope(CXSema S);

// Push a scope for the body of the block literal Block.
void clang_Sema_PushBlockScope(CXSema S, CXScope BlockScope, CXBlockDecl Block);

// Push a scope for a captured region (an OpenMP or CapturedStmt body). RD is the record
// holding the captured fields and K says which construct introduced the region.
void clang_Sema_PushCapturedRegionScope(CXSema S, CXScope RegionScope, CXCapturedDecl CD,
                                        CXRecordDecl RD, CXCapturedRegionKind K,
                                        unsigned OpenMPCaptureLevel);

// Push a compound-statement scope onto the innermost function scope. There must BE an
// innermost function scope: this dereferences getCurFunction() unchecked, so callers gate
// on clang_Sema_hasCurFunction.
void clang_Sema_PushCompoundScope(CXSema S, bool IsStmtExpr);

// Pop the innermost compound-statement scope. Gated like its Push.
void clang_Sema_PopCompoundScope(CXSema S);

// Push an expression-evaluation context. LambdaContextDecl may be null; the one-argument
// C++ overload taking ReuseLambdaContextDecl_t is not exposed, since it exists to thread
// parser state this boundary does not carry.
void clang_Sema_PushExpressionEvaluationContext(CXSema S,
                                                CXExpressionEvaluationContext NewContext,
                                                CXDecl LambdaContextDecl,
                                                CXExpressionKind Type);

// Leave the innermost expression-evaluation context.
void clang_Sema_PopExpressionEvaluationContext(CXSema S);

// Force `__host__ __device__` onto declarations parsed until the matching Pop.
void clang_Sema_PushForceCUDAHostDevice(CXSema S);

// Undo one PushForceCUDAHostDevice. Returns false when the stack was already empty, which
// is how clang reports the unbalanced case rather than asserting.
bool clang_Sema_PopForceCUDAHostDevice(CXSema S);

// Pop a `#pragma visibility` (IsNamespaceEnd false) or the visibility a namespace's
// attribute introduced (IsNamespaceEnd true).
void clang_Sema_PopPragmaVisibility(CXSema S, bool IsNamespaceEnd,
                                    CXSourceLocation_ EndLoc);

// Make D visible for unqualified lookup in Sc and, unless AddToContext is false, add it to
// the current declaration context.
void clang_Sema_PushOnScopeChains(CXSema S, CXNamedDecl D, CXScope Sc, bool AddToContext);

// Record UDir as a using-directive active in Sc.
void clang_Sema_PushUsingDirective(CXSema S, CXScope Sc, CXUsingDirectiveDecl UDir);

// Push the visibility a namespace-level visibility attribute establishes.
void clang_Sema_PushNamespaceVisibilityAttr(CXSema S, CXVisibilityAttr Attr,
                                            CXSourceLocation_ Loc);

// PopSatisfactionStackEntry -- not wrapped, and deliberately not wrapped alone. It is a
// bare pop_back() on the satisfaction stack, so it is only defined after a matching
// PushSatisfactionStackEntry, which takes an llvm::FoldingSetNodeID this boundary does not
// carry yet. Exposing the pop without the push would ship an operation whose only reachable
// use underflows the stack. Wrap the pair together or not at all.

// --- Sema accessors -------------------------------------------------------------------

// The class NNS names when it designates the current instantiation, or null when it does
// not. NNS must be non-null.
CXCXXRecordDecl clang_Sema_getCurrentInstantiationOf(CXSema S, CXNestedNameSpecifier NNS);

// Which defaulted comparison, if any, FD declares.
CXDefaultedComparisonKind clang_Sema_getDefaultedComparisonKind(CXSema S,
                                                                CXFunctionDecl FD);

// The nearest enclosing scope of Sc that can hold a non-field declaration.
CXScope clang_Sema_getNonFieldDeclScope(CXSema S, CXScope Sc);

// Namespace `std`, created on first use if the translation unit has not declared it.
CXNamespaceDecl clang_Sema_getOrCreateStdNamespace(CXSema S);

// The module owning Entity, or null when it is not owned by one. Entity must be non-null.
CXModule clang_Sema_getOwningModule(CXSema S, CXDecl Entity);

// The scope in Sc's chain corresponding to DC, or null when there is none. This mirrors a
// static member, so it takes no Sema receiver.
CXScope clang_Sema_getScopeForDeclContext(CXScope Sc, CXDeclContext DC);

// The template depth Sc sits at.
unsigned clang_Sema_getTemplateDepth(CXSema S, CXScope Sc);

// The module loader the compiler instance installed.
CXModuleLoader clang_Sema_getModuleLoader(CXSema S);

// The type a reference to Var has once the capture at Loc is accounted for.
CXQualType clang_Sema_getCapturedDeclRefType(CXSema S, CXValueDecl Var,
                                             CXSourceLocation_ Loc);

// The `code_seg` or `section` attribute FD implicitly carries, or null when it carries
// neither. IsDefinition says whether FD is being asked about as a definition.
CXAttr clang_Sema_getImplicitCodeSegOrSectionAttrForFunction(CXSema S, CXFunctionDecl FD,
                                                             bool IsDefinition);

LLVM_CLANG_C_EXTERN_C_END

#endif