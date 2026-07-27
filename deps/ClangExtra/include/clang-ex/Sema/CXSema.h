#ifndef LLVM_CLANG_C_EXTRA_CXSEMA_H
#define LLVM_CLANG_C_EXTRA_CXSEMA_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-ex/Basic/CXSpecifiers.h"
#include "clang-ex/Sema/CXLookup.h"  // CXLookupNameKind

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/Sema/Sema.h: enum class Sema::CompleteTypeKind
// The alias enumerator Default (= AcceptSizeless) is omitted per the mirroring
// rules; being an `=` assignment it does not shift the numbering.
typedef enum CXCompleteTypeKind {
  CXCompleteTypeKind_Normal,
  CXCompleteTypeKind_AcceptSizeless
} CXCompleteTypeKind;

// clang/Sema/Sema.h: enum Sema::RedeclarationKind
typedef enum CXRedeclarationKind {
  CXRedeclarationKind_NotForRedeclaration,
  CXRedeclarationKind_ForVisibleRedeclaration,
  CXRedeclarationKind_ForExternalRedeclaration
} CXRedeclarationKind;

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

LLVM_CLANG_C_EXTERN_C_END

#endif