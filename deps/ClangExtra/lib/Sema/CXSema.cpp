#include "clang-ex/Sema/CXSema.h"
#include "clang/CodeGen/ModuleBuilder.h"
#include "clang/Sema/Sema.h"
#include "clang/AST/DeclTemplate.h"

bool clang_Sema_usesPartialOrExplicitSpecialization(
    CXSema S, CXSourceLocation_ Loc, CXClassTemplateSpecializationDecl ClassTemplateSpec) {
  return static_cast<clang::Sema *>(S)->usesPartialOrExplicitSpecialization(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      static_cast<clang::ClassTemplateSpecializationDecl *>(ClassTemplateSpec));
}

bool clang_Sema_InstantiateClassTemplateSpecialization(
    CXSema S, CXSourceLocation_ PointOfInstantiation,
    CXClassTemplateSpecializationDecl ClassTemplateSpec, CXTemplateSpecializationKind TSK,
    bool Complain) {
  return static_cast<clang::Sema *>(S)->InstantiateClassTemplateSpecialization(
      clang::SourceLocation::getFromPtrEncoding(PointOfInstantiation),
      static_cast<clang::ClassTemplateSpecializationDecl *>(ClassTemplateSpec),
      static_cast<clang::TemplateSpecializationKind>(TSK), Complain);
}

void clang_Sema_InstantiateClassTemplateSpecializationMembers(
    CXSema S, CXSourceLocation_ PointOfInstantiation,
    CXClassTemplateSpecializationDecl ClassTemplateSpec, CXTemplateSpecializationKind TSK) {
  static_cast<clang::Sema *>(S)->InstantiateClassTemplateSpecializationMembers(
      clang::SourceLocation::getFromPtrEncoding(PointOfInstantiation),
      static_cast<clang::ClassTemplateSpecializationDecl *>(ClassTemplateSpec),
      static_cast<clang::TemplateSpecializationKind>(TSK));
}

void clang_Sema_InstantiateFunctionDefinition(CXSema S,
                                              CXSourceLocation_ PointOfInstantiation,
                                              CXFunctionDecl Function, bool Recursive,
                                              bool DefinitionRequired, bool AtEndOfTU) {
  static_cast<clang::Sema *>(S)->InstantiateFunctionDefinition(
      clang::SourceLocation::getFromPtrEncoding(PointOfInstantiation),
      static_cast<clang::FunctionDecl *>(Function), Recursive, DefinitionRequired,
      AtEndOfTU);
}

void clang_Sema_InstantiateVariableDefinition(CXSema S,
                                              CXSourceLocation_ PointOfInstantiation,
                                              CXVarDecl Var, bool Recursive,
                                              bool DefinitionRequired, bool AtEndOfTU) {
  static_cast<clang::Sema *>(S)->InstantiateVariableDefinition(
      clang::SourceLocation::getFromPtrEncoding(PointOfInstantiation),
      static_cast<clang::VarDecl *>(Var), Recursive, DefinitionRequired, AtEndOfTU);
}

void clang_Sema_PerformPendingInstantiations(CXSema S, bool LocalOnly) {
  static_cast<clang::Sema *>(S)->PerformPendingInstantiations(LocalOnly);
}
#include "clang/AST/ASTContext.h"
#include "clang/AST/DeclCXX.h"
#include "clang/Lex/Preprocessor.h"
#include "clang/Sema/DeclSpec.h"
#include "clang/Sema/Lookup.h"
#include "clang/Sema/Scope.h"

CXASTContext clang_Sema_getASTContext(CXSema S) {
  return &static_cast<clang::Sema *>(S)->getASTContext();
}

CXSourceManager clang_Sema_getSourceManager(CXSema S) {
  return &static_cast<clang::Sema *>(S)->getSourceManager();
}

CXDiagnosticsEngine clang_Sema_getDiagnostics(CXSema S) {
  return &static_cast<clang::Sema *>(S)->getDiagnostics();
}

CXPreprocessor clang_Sema_getPreprocessor(CXSema S) {
  return &static_cast<clang::Sema *>(S)->getPreprocessor();
}

CXLangOptions clang_Sema_getLangOpts(CXSema S) {
  return const_cast<clang::LangOptions *>(&static_cast<clang::Sema *>(S)->getLangOpts());
}

CXScope clang_Sema_getCurScope(CXSema S) {
  return static_cast<clang::Sema *>(S)->getCurScope();
}

bool clang_Sema_isCompleteType(CXSema S, CXSourceLocation_ Loc, CXQualType T,
                               CXCompleteTypeKind Kind) {
  return static_cast<clang::Sema *>(S)->isCompleteType(
      clang::SourceLocation::getFromPtrEncoding(Loc), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::Sema::CompleteTypeKind>(Kind));
}

bool clang_Sema_RequireCompleteType(CXSema S, CXSourceLocation_ Loc, CXQualType T,
                                    CXCompleteTypeKind Kind, unsigned DiagID) {
  return static_cast<clang::Sema *>(S)->RequireCompleteType(
      clang::SourceLocation::getFromPtrEncoding(Loc), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::Sema::CompleteTypeKind>(Kind), DiagID);
}

bool clang_Sema_RequireCompleteExprType(CXSema S, CXExpr E, unsigned DiagID) {
  return static_cast<clang::Sema *>(S)->RequireCompleteExprType(
      static_cast<clang::Expr *>(E), DiagID);
}

bool clang_Sema_RequireLiteralType(CXSema S, CXSourceLocation_ Loc, CXQualType T,
                                   unsigned DiagID) {
  return static_cast<clang::Sema *>(S)->RequireLiteralType(
      clang::SourceLocation::getFromPtrEncoding(Loc), clang::QualType::getFromOpaquePtr(T),
      DiagID);
}

CXQualType clang_Sema_getCompletedType(CXSema S, CXExpr E) {
  return static_cast<clang::Sema *>(S)
      ->getCompletedType(static_cast<clang::Expr *>(E))
      .getAsOpaquePtr();
}

bool clang_Sema_RequireCompleteDeclContext(CXSema S, CXCXXScopeSpec SS, CXDeclContext DC) {
  return static_cast<clang::Sema *>(S)->RequireCompleteDeclContext(
      *static_cast<clang::CXXScopeSpec *>(SS), static_cast<clang::DeclContext *>(DC));
}

bool clang_Sema_RequireCompleteEnumDecl(CXSema S, CXEnumDecl D, CXSourceLocation_ L,
                                        CXCXXScopeSpec SS) {
  return static_cast<clang::Sema *>(S)->RequireCompleteEnumDecl(
      static_cast<clang::EnumDecl *>(D), clang::SourceLocation::getFromPtrEncoding(L),
      static_cast<clang::CXXScopeSpec *>(SS));
}

CXDeclContext clang_Sema_computeDeclContextFromType(CXSema S, CXQualType T) {
  return static_cast<clang::Sema *>(S)->computeDeclContext(
      clang::QualType::getFromOpaquePtr(T));
}

CXDeclContext clang_Sema_computeDeclContext(CXSema S, CXCXXScopeSpec SS,
                                            bool EnteringContext) {
  return static_cast<clang::Sema *>(S)->computeDeclContext(
      *static_cast<clang::CXXScopeSpec *>(SS), EnteringContext);
}

bool clang_Sema_isDependentScopeSpecifier(CXSema S, CXCXXScopeSpec SS) {
  return static_cast<clang::Sema *>(S)->isDependentScopeSpecifier(
      *static_cast<clang::CXXScopeSpec *>(SS));
}

CXNamedDecl clang_Sema_LookupSingleName(CXSema S, CXScope Sp, CXDeclarationName Name,
                                        CXSourceLocation_ Loc, CXLookupNameKind NameKind,
                                        CXRedeclarationKind Redecl) {
  return static_cast<clang::Sema *>(S)->LookupSingleName(
      static_cast<clang::Scope *>(Sp), clang::DeclarationName::getFromOpaquePtr(Name),
      clang::SourceLocation::getFromPtrEncoding(Loc),
      static_cast<clang::Sema::LookupNameKind>(NameKind),
      static_cast<clang::Sema::RedeclarationKind>(Redecl));
}

bool clang_Sema_LookupQualifiedName(CXSema S, CXLookupResult R, CXDeclContext LookupCtx,
                                    bool InUnqualifiedLookup) {
  return static_cast<clang::Sema *>(S)->LookupQualifiedName(
      *static_cast<clang::LookupResult *>(R), static_cast<clang::DeclContext *>(LookupCtx),
      InUnqualifiedLookup);
}

bool clang_Sema_LookupQualifiedNameWithScopeSpec(CXSema S, CXLookupResult R,
                                                 CXDeclContext LookupCtx,
                                                 CXCXXScopeSpec SS) {
  return static_cast<clang::Sema *>(S)->LookupQualifiedName(
      *static_cast<clang::LookupResult *>(R), static_cast<clang::DeclContext *>(LookupCtx),
      *static_cast<clang::CXXScopeSpec *>(SS));
}

bool clang_Sema_LookupInSuper(CXSema S, CXLookupResult R, CXCXXRecordDecl Class) {
  return static_cast<clang::Sema *>(S)->LookupInSuper(
      *static_cast<clang::LookupResult *>(R), static_cast<clang::CXXRecordDecl *>(Class));
}

void clang_Sema_setCollectStats(CXSema S, bool ShouldCollect) {
  static_cast<clang::Sema *>(S)->CollectStats = ShouldCollect;
}

void clang_Sema_PrintStats(CXSema S) { static_cast<clang::Sema *>(S)->PrintStats(); }

void clang_Sema_RestoreNestedNameSpecifierAnnotation(
    CXSema S, void *Annotation, CXSourceLocation_ AnnotationRange_begin,
    CXSourceLocation_ AnnotationRange_end, CXCXXScopeSpec SS) {
  static_cast<clang::Sema *>(S)->RestoreNestedNameSpecifierAnnotation(
      Annotation,
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(AnnotationRange_begin),
                         clang::SourceLocation::getFromPtrEncoding(AnnotationRange_end)),
      *static_cast<clang::CXXScopeSpec *>(SS));
}

CXQualType clang_sema_getTypeName(CXSema S, CXIdentifierInfo II, CXSourceLocation_ NameLoc,
                                  CXScope Scp, CXCXXScopeSpec SS, bool isClassName,
                                  bool HasTrailingDot, CXQualType ObjectTypePtr,
                                  bool IsCtorOrDtorName, bool WantNontrivialTypeSourceInfo,
                                  bool IsClassTemplateDeductionContext,
                                  bool AllowImplicitTypename) {
  return static_cast<clang::Sema *>(S)
      ->getTypeName(*static_cast<clang::IdentifierInfo *>(II),
                    clang::SourceLocation::getFromPtrEncoding(NameLoc),
                    static_cast<clang::Scope *>(Scp),
                    static_cast<clang::CXXScopeSpec *>(SS), isClassName, HasTrailingDot,
                    clang::OpaquePtr<clang::QualType>::make(
                        clang::QualType::getFromOpaquePtr(ObjectTypePtr)),
                    IsCtorOrDtorName, WantNontrivialTypeSourceInfo,
                    IsClassTemplateDeductionContext,
                    AllowImplicitTypename ? clang::ImplicitTypenameContext::Yes
                                          : clang::ImplicitTypenameContext::No)
      .get()
      .getAsOpaquePtr();
}

bool clang_Sema_LookupParsedName(CXSema S, CXLookupResult R, CXScope Sp, CXCXXScopeSpec SS,
                                 bool AllowBuiltinCreation, bool EnteringContext) {
  return static_cast<clang::Sema *>(S)->LookupParsedName(
      *static_cast<clang::LookupResult *>(R), static_cast<clang::Scope *>(Sp),
      static_cast<clang::CXXScopeSpec *>(SS), AllowBuiltinCreation, EnteringContext);
}

bool clang_Sema_LookupName(CXSema S, CXLookupResult R, CXScope Sp,
                           bool AllowBuiltinCreation, bool ForceNoCPlusPlus) {
  return static_cast<clang::Sema *>(S)->LookupName(*static_cast<clang::LookupResult *>(R),
                                                   static_cast<clang::Scope *>(Sp),
                                                   AllowBuiltinCreation, ForceNoCPlusPlus);
}

void clang_Sema_processWeakTopLevelDecls(CXSema Sema, CXCodeGenerator CodeGen) {
  auto S = static_cast<clang::Sema *>(Sema);
  auto CG = static_cast<clang::CodeGenerator *>(CodeGen);
  for (clang::Decl *D : S->WeakTopLevelDecls())
    CG->HandleTopLevelDecl(clang::DeclGroupRef(D));
}

CXCXXConstructorDecl clang_Sema_LookupDefaultConstructor(CXSema S, CXCXXRecordDecl Class) {
  return static_cast<clang::Sema *>(S)->LookupDefaultConstructor(
      static_cast<clang::CXXRecordDecl *>(Class));
}

CXCXXDestructorDecl clang_Sema_LookupDestructor(CXSema S, CXCXXRecordDecl Class) {
  return static_cast<clang::Sema *>(S)->LookupDestructor(
      static_cast<clang::CXXRecordDecl *>(Class));
}