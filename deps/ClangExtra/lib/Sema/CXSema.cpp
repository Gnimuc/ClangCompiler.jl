#include "clang-ex/Sema/CXSema.h"
#include "Sema/CXTemplateBox.h"
#include "clang/AST/Attr.h"
#include "clang/AST/DeclAccessPair.h"
#include "clang/AST/DeclGroup.h"
#include "clang/AST/DeclTemplate.h"
#include "clang/AST/DeclarationName.h"
#include "clang/AST/NestedNameSpecifier.h"
#include "clang/AST/TypeLoc.h"
#include "clang/AST/UnresolvedSet.h"
#include "clang/CodeGen/ModuleBuilder.h"
#include "clang/Lex/Token.h"
#include "clang/Sema/Overload.h"
#include "clang/Sema/Sema.h"
#include "llvm/ExecutionEngine/GenericValue.h"
#include "clang/Sema/TemplateDeduction.h"

bool clang_Sema_usesPartialOrExplicitSpecialization(
    CXSema S, CXSourceLocation_ Loc, CXClassTemplateSpecializationDecl ClassTemplateSpec) {
  return reinterpret_cast<clang::Sema *>(S)->usesPartialOrExplicitSpecialization(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      reinterpret_cast<clang::ClassTemplateSpecializationDecl *>(ClassTemplateSpec));
}

bool clang_Sema_InstantiateClassTemplateSpecialization(
    CXSema S, CXSourceLocation_ PointOfInstantiation,
    CXClassTemplateSpecializationDecl ClassTemplateSpec, CXTemplateSpecializationKind TSK,
    bool Complain) {
  return reinterpret_cast<clang::Sema *>(S)->InstantiateClassTemplateSpecialization(
      clang::SourceLocation::getFromPtrEncoding(PointOfInstantiation),
      reinterpret_cast<clang::ClassTemplateSpecializationDecl *>(ClassTemplateSpec),
      static_cast<clang::TemplateSpecializationKind>(TSK), Complain);
}

void clang_Sema_InstantiateClassTemplateSpecializationMembers(
    CXSema S, CXSourceLocation_ PointOfInstantiation,
    CXClassTemplateSpecializationDecl ClassTemplateSpec, CXTemplateSpecializationKind TSK) {
  reinterpret_cast<clang::Sema *>(S)->InstantiateClassTemplateSpecializationMembers(
      clang::SourceLocation::getFromPtrEncoding(PointOfInstantiation),
      reinterpret_cast<clang::ClassTemplateSpecializationDecl *>(ClassTemplateSpec),
      static_cast<clang::TemplateSpecializationKind>(TSK));
}

void clang_Sema_InstantiateFunctionDefinition(CXSema S,
                                              CXSourceLocation_ PointOfInstantiation,
                                              CXFunctionDecl Function, bool Recursive,
                                              bool DefinitionRequired, bool AtEndOfTU) {
  reinterpret_cast<clang::Sema *>(S)->InstantiateFunctionDefinition(
      clang::SourceLocation::getFromPtrEncoding(PointOfInstantiation),
      reinterpret_cast<clang::FunctionDecl *>(Function), Recursive, DefinitionRequired,
      AtEndOfTU);
}

void clang_Sema_InstantiateVariableDefinition(CXSema S,
                                              CXSourceLocation_ PointOfInstantiation,
                                              CXVarDecl Var, bool Recursive,
                                              bool DefinitionRequired, bool AtEndOfTU) {
  reinterpret_cast<clang::Sema *>(S)->InstantiateVariableDefinition(
      clang::SourceLocation::getFromPtrEncoding(PointOfInstantiation),
      reinterpret_cast<clang::VarDecl *>(Var), Recursive, DefinitionRequired, AtEndOfTU);
}

void clang_Sema_PerformPendingInstantiations(CXSema S, bool LocalOnly) {
  reinterpret_cast<clang::Sema *>(S)->PerformPendingInstantiations(LocalOnly);
}
#include "clang/AST/ASTContext.h"
#include "clang/AST/DeclCXX.h"
#include "clang/Lex/Preprocessor.h"
#include "clang/Sema/DeclSpec.h"
#include "clang/Sema/Lookup.h"
#include "clang/Sema/Scope.h"

CXASTContext clang_Sema_getASTContext(CXSema S) {
  return reinterpret_cast<CXASTContext>(&reinterpret_cast<clang::Sema *>(S)->getASTContext());
}

CXSourceManager clang_Sema_getSourceManager(CXSema S) {
  return reinterpret_cast<CXSourceManager>(&reinterpret_cast<clang::Sema *>(S)->getSourceManager());
}

CXDiagnosticsEngine clang_Sema_getDiagnostics(CXSema S) {
  return reinterpret_cast<CXDiagnosticsEngine>(&reinterpret_cast<clang::Sema *>(S)->getDiagnostics());
}

CXPreprocessor clang_Sema_getPreprocessor(CXSema S) {
  return reinterpret_cast<CXPreprocessor>(&reinterpret_cast<clang::Sema *>(S)->getPreprocessor());
}

CXLangOptions clang_Sema_getLangOpts(CXSema S) {
  return reinterpret_cast<CXLangOptions>(const_cast<clang::LangOptions *>(&reinterpret_cast<clang::Sema *>(S)->getLangOpts()));
}

CXScope clang_Sema_getCurScope(CXSema S) {
  return reinterpret_cast<CXScope>(reinterpret_cast<clang::Sema *>(S)->getCurScope());
}

bool clang_Sema_isCompleteType(CXSema S, CXSourceLocation_ Loc, CXQualType T,
                               CXCompleteTypeKind Kind) {
  return reinterpret_cast<clang::Sema *>(S)->isCompleteType(
      clang::SourceLocation::getFromPtrEncoding(Loc), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::Sema::CompleteTypeKind>(Kind));
}

bool clang_Sema_RequireCompleteType(CXSema S, CXSourceLocation_ Loc, CXQualType T,
                                    CXCompleteTypeKind Kind, unsigned DiagID) {
  return reinterpret_cast<clang::Sema *>(S)->RequireCompleteType(
      clang::SourceLocation::getFromPtrEncoding(Loc), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::Sema::CompleteTypeKind>(Kind), DiagID);
}

bool clang_Sema_RequireCompleteExprType(CXSema S, CXExpr E, unsigned DiagID) {
  return reinterpret_cast<clang::Sema *>(S)->RequireCompleteExprType(
      reinterpret_cast<clang::Expr *>(E), DiagID);
}

bool clang_Sema_RequireLiteralType(CXSema S, CXSourceLocation_ Loc, CXQualType T,
                                   unsigned DiagID) {
  return reinterpret_cast<clang::Sema *>(S)->RequireLiteralType(
      clang::SourceLocation::getFromPtrEncoding(Loc), clang::QualType::getFromOpaquePtr(T),
      DiagID);
}

CXQualType clang_Sema_getCompletedType(CXSema S, CXExpr E) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->getCompletedType(reinterpret_cast<clang::Expr *>(E))
      .getAsOpaquePtr());
}

bool clang_Sema_RequireCompleteDeclContext(CXSema S, CXCXXScopeSpec SS, CXDeclContext DC) {
  return reinterpret_cast<clang::Sema *>(S)->RequireCompleteDeclContext(
      *reinterpret_cast<clang::CXXScopeSpec *>(SS), reinterpret_cast<clang::DeclContext *>(DC));
}

bool clang_Sema_RequireCompleteEnumDecl(CXSema S, CXEnumDecl D, CXSourceLocation_ L,
                                        CXCXXScopeSpec SS) {
  return reinterpret_cast<clang::Sema *>(S)->RequireCompleteEnumDecl(
      reinterpret_cast<clang::EnumDecl *>(D), clang::SourceLocation::getFromPtrEncoding(L),
      reinterpret_cast<clang::CXXScopeSpec *>(SS));
}

CXDeclContext clang_Sema_computeDeclContextFromType(CXSema S, CXQualType T) {
  return reinterpret_cast<CXDeclContext>(reinterpret_cast<clang::Sema *>(S)->computeDeclContext(
      clang::QualType::getFromOpaquePtr(T)));
}

CXDeclContext clang_Sema_computeDeclContext(CXSema S, CXCXXScopeSpec SS,
                                            bool EnteringContext) {
  return reinterpret_cast<CXDeclContext>(reinterpret_cast<clang::Sema *>(S)->computeDeclContext(
      *reinterpret_cast<clang::CXXScopeSpec *>(SS), EnteringContext));
}

bool clang_Sema_isDependentScopeSpecifier(CXSema S, CXCXXScopeSpec SS) {
  return reinterpret_cast<clang::Sema *>(S)->isDependentScopeSpecifier(
      *reinterpret_cast<clang::CXXScopeSpec *>(SS));
}

CXNamedDecl clang_Sema_LookupSingleName(CXSema S, CXScope Sp, CXDeclarationName Name,
                                        CXSourceLocation_ Loc, CXLookupNameKind NameKind,
                                        CXRedeclarationKind Redecl) {
  return reinterpret_cast<CXNamedDecl>(reinterpret_cast<clang::Sema *>(S)->LookupSingleName(
      reinterpret_cast<clang::Scope *>(Sp), clang::DeclarationName::getFromOpaquePtr(Name),
      clang::SourceLocation::getFromPtrEncoding(Loc),
      static_cast<clang::Sema::LookupNameKind>(NameKind),
      static_cast<clang::Sema::RedeclarationKind>(Redecl)));
}

bool clang_Sema_LookupQualifiedName(CXSema S, CXLookupResult R, CXDeclContext LookupCtx,
                                    bool InUnqualifiedLookup) {
  return reinterpret_cast<clang::Sema *>(S)->LookupQualifiedName(
      *reinterpret_cast<clang::LookupResult *>(R), reinterpret_cast<clang::DeclContext *>(LookupCtx),
      InUnqualifiedLookup);
}

bool clang_Sema_LookupQualifiedNameWithScopeSpec(CXSema S, CXLookupResult R,
                                                 CXDeclContext LookupCtx,
                                                 CXCXXScopeSpec SS) {
  return reinterpret_cast<clang::Sema *>(S)->LookupQualifiedName(
      *reinterpret_cast<clang::LookupResult *>(R), reinterpret_cast<clang::DeclContext *>(LookupCtx),
      *reinterpret_cast<clang::CXXScopeSpec *>(SS));
}

bool clang_Sema_LookupInSuper(CXSema S, CXLookupResult R, CXCXXRecordDecl Class) {
  return reinterpret_cast<clang::Sema *>(S)->LookupInSuper(
      *reinterpret_cast<clang::LookupResult *>(R), reinterpret_cast<clang::CXXRecordDecl *>(Class));
}

void clang_Sema_setCollectStats(CXSema S, bool ShouldCollect) {
  reinterpret_cast<clang::Sema *>(S)->CollectStats = ShouldCollect;
}

void clang_Sema_PrintStats(CXSema S) { reinterpret_cast<clang::Sema *>(S)->PrintStats(); }

void clang_Sema_RestoreNestedNameSpecifierAnnotation(
    CXSema S, void *Annotation, CXSourceLocation_ AnnotationRange_begin,
    CXSourceLocation_ AnnotationRange_end, CXCXXScopeSpec SS) {
  reinterpret_cast<clang::Sema *>(S)->RestoreNestedNameSpecifierAnnotation(
      Annotation,
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(AnnotationRange_begin),
                         clang::SourceLocation::getFromPtrEncoding(AnnotationRange_end)),
      *reinterpret_cast<clang::CXXScopeSpec *>(SS));
}

CXQualType clang_Sema_getTypeName(CXSema S, CXIdentifierInfo II, CXSourceLocation_ NameLoc,
                                  CXScope Scp, CXCXXScopeSpec SS, bool isClassName,
                                  bool HasTrailingDot, CXQualType ObjectTypePtr,
                                  bool IsCtorOrDtorName, bool WantNontrivialTypeSourceInfo,
                                  bool IsClassTemplateDeductionContext,
                                  bool AllowImplicitTypename) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->getTypeName(*reinterpret_cast<clang::IdentifierInfo *>(II),
                    clang::SourceLocation::getFromPtrEncoding(NameLoc),
                    reinterpret_cast<clang::Scope *>(Scp),
                    reinterpret_cast<clang::CXXScopeSpec *>(SS), isClassName, HasTrailingDot,
                    clang::OpaquePtr<clang::QualType>::make(
                        clang::QualType::getFromOpaquePtr(ObjectTypePtr)),
                    IsCtorOrDtorName, WantNontrivialTypeSourceInfo,
                    IsClassTemplateDeductionContext,
                    AllowImplicitTypename ? clang::ImplicitTypenameContext::Yes
                                          : clang::ImplicitTypenameContext::No)
      .get()
      .getAsOpaquePtr());
}

bool clang_Sema_LookupParsedName(CXSema S, CXLookupResult R, CXScope Sp, CXCXXScopeSpec SS,
                                 bool AllowBuiltinCreation, bool EnteringContext) {
  return reinterpret_cast<clang::Sema *>(S)->LookupParsedName(
      *reinterpret_cast<clang::LookupResult *>(R), reinterpret_cast<clang::Scope *>(Sp),
      reinterpret_cast<clang::CXXScopeSpec *>(SS), AllowBuiltinCreation, EnteringContext);
}

bool clang_Sema_LookupName(CXSema S, CXLookupResult R, CXScope Sp,
                           bool AllowBuiltinCreation, bool ForceNoCPlusPlus) {
  return reinterpret_cast<clang::Sema *>(S)->LookupName(*reinterpret_cast<clang::LookupResult *>(R),
                                                   reinterpret_cast<clang::Scope *>(Sp),
                                                   AllowBuiltinCreation, ForceNoCPlusPlus);
}

void clang_Sema_processWeakTopLevelDecls(CXSema Sema, CXCodeGenerator CodeGen) {
  auto S = reinterpret_cast<clang::Sema *>(Sema);
  auto CG = reinterpret_cast<clang::CodeGenerator *>(CodeGen);
  for (clang::Decl *D : S->WeakTopLevelDecls())
    CG->HandleTopLevelDecl(clang::DeclGroupRef(D));
}

CXCXXConstructorDecl clang_Sema_LookupDefaultConstructor(CXSema S, CXCXXRecordDecl Class) {
  return reinterpret_cast<CXCXXConstructorDecl>(reinterpret_cast<clang::Sema *>(S)->LookupDefaultConstructor(
      reinterpret_cast<clang::CXXRecordDecl *>(Class)));
}

CXCXXDestructorDecl clang_Sema_LookupDestructor(CXSema S, CXCXXRecordDecl Class) {
  return reinterpret_cast<CXCXXDestructorDecl>(reinterpret_cast<clang::Sema *>(S)->LookupDestructor(
      reinterpret_cast<clang::CXXRecordDecl *>(Class)));
}

bool clang_Sema_CheckFunctionReturnType(CXSema S, CXQualType T, CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::Sema *>(S)->CheckFunctionReturnType(
      clang::QualType::getFromOpaquePtr(T), clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXFunctionProtoType clang_Sema_ResolveExceptionSpec(CXSema S, CXSourceLocation_ Loc,
                                                    CXFunctionProtoType FPT) {
  return reinterpret_cast<CXFunctionProtoType>(const_cast<clang::FunctionProtoType *>(
      reinterpret_cast<clang::Sema *>(S)->ResolveExceptionSpec(
          clang::SourceLocation::getFromPtrEncoding(Loc),
          reinterpret_cast<clang::FunctionProtoType *>(FPT))));
}

bool clang_Sema_CheckDistantExceptionSpec(CXSema S, CXQualType T) {
  return reinterpret_cast<clang::Sema *>(S)->CheckDistantExceptionSpec(
      clang::QualType::getFromOpaquePtr(T));
}

bool clang_Sema_CheckTypeTraitArity(CXSema S, unsigned Arity, CXSourceLocation_ Loc,
                                    size_t N) {
  return reinterpret_cast<clang::Sema *>(S)->CheckTypeTraitArity(
      Arity, clang::SourceLocation::getFromPtrEncoding(Loc), N);
}

bool clang_Sema_CheckCaseExpression(CXSema S, CXExpr E) {
  return reinterpret_cast<clang::Sema *>(S)->CheckCaseExpression(reinterpret_cast<clang::Expr *>(E));
}

CXCXXConstructorDecl
clang_Sema_DeclareImplicitDefaultConstructor(CXSema S, CXCXXRecordDecl ClassDecl) {
  return reinterpret_cast<CXCXXConstructorDecl>(reinterpret_cast<clang::Sema *>(S)->DeclareImplicitDefaultConstructor(
      reinterpret_cast<clang::CXXRecordDecl *>(ClassDecl)));
}

CXCXXDestructorDecl clang_Sema_DeclareImplicitDestructor(CXSema S,
                                                         CXCXXRecordDecl ClassDecl) {
  return reinterpret_cast<CXCXXDestructorDecl>(reinterpret_cast<clang::Sema *>(S)->DeclareImplicitDestructor(
      reinterpret_cast<clang::CXXRecordDecl *>(ClassDecl)));
}

CXCXXConstructorDecl clang_Sema_DeclareImplicitCopyConstructor(CXSema S,
                                                               CXCXXRecordDecl ClassDecl) {
  return reinterpret_cast<CXCXXConstructorDecl>(reinterpret_cast<clang::Sema *>(S)->DeclareImplicitCopyConstructor(
      reinterpret_cast<clang::CXXRecordDecl *>(ClassDecl)));
}

CXCXXConstructorDecl clang_Sema_DeclareImplicitMoveConstructor(CXSema S,
                                                               CXCXXRecordDecl ClassDecl) {
  return reinterpret_cast<CXCXXConstructorDecl>(reinterpret_cast<clang::Sema *>(S)->DeclareImplicitMoveConstructor(
      reinterpret_cast<clang::CXXRecordDecl *>(ClassDecl)));
}

CXCXXMethodDecl clang_Sema_DeclareImplicitCopyAssignment(CXSema S,
                                                         CXCXXRecordDecl ClassDecl) {
  return reinterpret_cast<CXCXXMethodDecl>(reinterpret_cast<clang::Sema *>(S)->DeclareImplicitCopyAssignment(
      reinterpret_cast<clang::CXXRecordDecl *>(ClassDecl)));
}

CXCXXMethodDecl clang_Sema_DeclareImplicitMoveAssignment(CXSema S,
                                                         CXCXXRecordDecl ClassDecl) {
  return reinterpret_cast<CXCXXMethodDecl>(reinterpret_cast<clang::Sema *>(S)->DeclareImplicitMoveAssignment(
      reinterpret_cast<clang::CXXRecordDecl *>(ClassDecl)));
}

void clang_Sema_DeclareGlobalNewDelete(CXSema S) {
  reinterpret_cast<clang::Sema *>(S)->DeclareGlobalNewDelete();
}

CXFunctionDecl clang_Sema_FindUsualDeallocationFunction(CXSema S,
                                                        CXSourceLocation_ StartLoc,
                                                        bool CanProvideSize,
                                                        bool Overaligned,
                                                        CXDeclarationName Name) {
  return reinterpret_cast<CXFunctionDecl>(reinterpret_cast<clang::Sema *>(S)->FindUsualDeallocationFunction(
      clang::SourceLocation::getFromPtrEncoding(StartLoc), CanProvideSize, Overaligned,
      clang::DeclarationName::getFromOpaquePtr(Name)));
}

CXFunctionDecl clang_Sema_FindDeallocationFunctionForDestructor(CXSema S,
                                                                CXSourceLocation_ StartLoc,
                                                                CXCXXRecordDecl RD) {
  return reinterpret_cast<CXFunctionDecl>(reinterpret_cast<clang::Sema *>(S)->FindDeallocationFunctionForDestructor(
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      reinterpret_cast<clang::CXXRecordDecl *>(RD)));
}

CXNamedDecl clang_Sema_FindFirstQualifierInScope(CXSema S, CXScope Sp,
                                                 CXNestedNameSpecifier NNS) {
  return reinterpret_cast<CXNamedDecl>(reinterpret_cast<clang::Sema *>(S)->FindFirstQualifierInScope(
      reinterpret_cast<clang::Scope *>(Sp), reinterpret_cast<clang::NestedNameSpecifier *>(NNS)));
}

bool clang_Sema_CheckDerivedToBaseConversion(CXSema S, CXQualType Derived, CXQualType Base,
                                             CXSourceLocation_ Loc,
                                             CXSourceLocation_ Range_begin,
                                             CXSourceLocation_ Range_end,
                                             bool IgnoreAccess) {
  return reinterpret_cast<clang::Sema *>(S)->CheckDerivedToBaseConversion(
      clang::QualType::getFromOpaquePtr(Derived), clang::QualType::getFromOpaquePtr(Base),
      clang::SourceLocation::getFromPtrEncoding(Loc),
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Range_begin),
                         clang::SourceLocation::getFromPtrEncoding(Range_end)),
      nullptr, IgnoreAccess);
}

bool clang_Sema_CheckIfOverriddenFunctionIsMarkedFinal(CXSema S, CXCXXMethodDecl New,
                                                       CXCXXMethodDecl Old) {
  return reinterpret_cast<clang::Sema *>(S)->CheckIfOverriddenFunctionIsMarkedFinal(
      reinterpret_cast<clang::CXXMethodDecl *>(New), reinterpret_cast<clang::CXXMethodDecl *>(Old));
}

bool clang_Sema_AddOverriddenMethods(CXSema S, CXCXXRecordDecl DC, CXCXXMethodDecl MD) {
  return reinterpret_cast<clang::Sema *>(S)->AddOverriddenMethods(
      reinterpret_cast<clang::CXXRecordDecl *>(DC), reinterpret_cast<clang::CXXMethodDecl *>(MD));
}

void clang_Sema_SetParamDefaultArgument(CXSema S, CXParmVarDecl Param, CXExpr DefaultArg,
                                        CXSourceLocation_ EqualLoc) {
  reinterpret_cast<clang::Sema *>(S)->SetParamDefaultArgument(
      reinterpret_cast<clang::ParmVarDecl *>(Param), reinterpret_cast<clang::Expr *>(DefaultArg),
      clang::SourceLocation::getFromPtrEncoding(EqualLoc));
}

void clang_Sema_SetDeclDeleted(CXSema S, CXDecl Dcl, CXSourceLocation_ DelLoc) {
  reinterpret_cast<clang::Sema *>(S)->SetDeclDeleted(
      reinterpret_cast<clang::Decl *>(Dcl), clang::SourceLocation::getFromPtrEncoding(DelLoc));
}

void clang_Sema_SetDeclDefaulted(CXSema S, CXDecl Dcl, CXSourceLocation_ DefaultLoc) {
  reinterpret_cast<clang::Sema *>(S)->SetDeclDefaulted(
      reinterpret_cast<clang::Decl *>(Dcl),
      clang::SourceLocation::getFromPtrEncoding(DefaultLoc));
}

void clang_Sema_AddKnownFunctionAttributes(CXSema S, CXFunctionDecl FD) {
  reinterpret_cast<clang::Sema *>(S)->AddKnownFunctionAttributes(
      reinterpret_cast<clang::FunctionDecl *>(FD));
}

void clang_Sema_AdjustDestructorExceptionSpec(CXSema S, CXCXXDestructorDecl Destructor) {
  reinterpret_cast<clang::Sema *>(S)->AdjustDestructorExceptionSpec(
      reinterpret_cast<clang::CXXDestructorDecl *>(Destructor));
}

void clang_Sema_ForceDeclarationOfImplicitMembers(CXSema S, CXCXXRecordDecl Class) {
  reinterpret_cast<clang::Sema *>(S)->ForceDeclarationOfImplicitMembers(
      reinterpret_cast<clang::CXXRecordDecl *>(Class));
}

void clang_Sema_DefineImplicitDefaultConstructor(CXSema S, CXSourceLocation_ Loc,
                                                 CXCXXConstructorDecl Constructor) {
  reinterpret_cast<clang::Sema *>(S)->DefineImplicitDefaultConstructor(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      reinterpret_cast<clang::CXXConstructorDecl *>(Constructor));
}

void clang_Sema_DefineImplicitDestructor(CXSema S, CXSourceLocation_ Loc,
                                         CXCXXDestructorDecl Destructor) {
  reinterpret_cast<clang::Sema *>(S)->DefineImplicitDestructor(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      reinterpret_cast<clang::CXXDestructorDecl *>(Destructor));
}

void clang_Sema_DefineImplicitCopyConstructor(CXSema S, CXSourceLocation_ Loc,
                                              CXCXXConstructorDecl Constructor) {
  reinterpret_cast<clang::Sema *>(S)->DefineImplicitCopyConstructor(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      reinterpret_cast<clang::CXXConstructorDecl *>(Constructor));
}

void clang_Sema_DefineImplicitMoveConstructor(CXSema S, CXSourceLocation_ Loc,
                                              CXCXXConstructorDecl Constructor) {
  reinterpret_cast<clang::Sema *>(S)->DefineImplicitMoveConstructor(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      reinterpret_cast<clang::CXXConstructorDecl *>(Constructor));
}

void clang_Sema_DefineImplicitCopyAssignment(CXSema S, CXSourceLocation_ Loc,
                                             CXCXXMethodDecl MethodDecl) {
  reinterpret_cast<clang::Sema *>(S)->DefineImplicitCopyAssignment(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      reinterpret_cast<clang::CXXMethodDecl *>(MethodDecl));
}

void clang_Sema_DefineImplicitMoveAssignment(CXSema S, CXSourceLocation_ Loc,
                                             CXCXXMethodDecl MethodDecl) {
  reinterpret_cast<clang::Sema *>(S)->DefineImplicitMoveAssignment(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      reinterpret_cast<clang::CXXMethodDecl *>(MethodDecl));
}

bool clang_Sema_DefineUsedVTables(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->DefineUsedVTables();
}

void clang_Sema_AddImplicitlyDeclaredMembersToClass(CXSema S, CXCXXRecordDecl ClassDecl) {
  reinterpret_cast<clang::Sema *>(S)->AddImplicitlyDeclaredMembersToClass(
      reinterpret_cast<clang::CXXRecordDecl *>(ClassDecl));
}

bool clang_Sema_SetMemberAccessSpecifier(CXSema S, CXNamedDecl MemberDecl,
                                         CXNamedDecl PrevMemberDecl,
                                         CXAccessSpecifier LexicalAS) {
  return reinterpret_cast<clang::Sema *>(S)->SetMemberAccessSpecifier(
      reinterpret_cast<clang::NamedDecl *>(MemberDecl),
      reinterpret_cast<clang::NamedDecl *>(PrevMemberDecl),
      static_cast<clang::AccessSpecifier>(LexicalAS));
}

CXTemplateDecl clang_Sema_AdjustDeclIfTemplate(CXSema S, CXDecl *D) {
  clang::Decl *Inner = reinterpret_cast<clang::Decl *>(*D);
  clang::TemplateDecl *TD = reinterpret_cast<clang::Sema *>(S)->AdjustDeclIfTemplate(Inner);
  *D = reinterpret_cast<CXDecl>(Inner);
  return reinterpret_cast<CXTemplateDecl>(TD);
}

void clang_Sema_DeclareImplicitDeductionGuides(CXSema S, CXTemplateDecl Template,
                                               CXSourceLocation_ Loc) {
  reinterpret_cast<clang::Sema *>(S)->DeclareImplicitDeductionGuides(
      reinterpret_cast<clang::TemplateDecl *>(Template),
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_Sema_AddAlignmentAttributesForRecord(CXSema S, CXRecordDecl RD) {
  reinterpret_cast<clang::Sema *>(S)->AddAlignmentAttributesForRecord(
      reinterpret_cast<clang::RecordDecl *>(RD));
}

void clang_Sema_AddMsStructLayoutForRecord(CXSema S, CXRecordDecl RD) {
  reinterpret_cast<clang::Sema *>(S)->AddMsStructLayoutForRecord(
      reinterpret_cast<clang::RecordDecl *>(RD));
}

void clang_Sema_AddPushedVisibilityAttribute(CXSema S, CXDecl D) {
  reinterpret_cast<clang::Sema *>(S)->AddPushedVisibilityAttribute(
      reinterpret_cast<clang::Decl *>(D));
}

void clang_Sema_AddRangeBasedOptnone(CXSema S, CXFunctionDecl FD) {
  reinterpret_cast<clang::Sema *>(S)->AddRangeBasedOptnone(
      reinterpret_cast<clang::FunctionDecl *>(FD));
}

void clang_Sema_AddSectionMSAllocText(CXSema S, CXFunctionDecl FD) {
  reinterpret_cast<clang::Sema *>(S)->AddSectionMSAllocText(
      reinterpret_cast<clang::FunctionDecl *>(FD));
}

void clang_Sema_AddOptnoneAttributeIfNoConflicts(CXSema S, CXFunctionDecl FD,
                                                 CXSourceLocation_ Loc) {
  reinterpret_cast<clang::Sema *>(S)->AddOptnoneAttributeIfNoConflicts(
      reinterpret_cast<clang::FunctionDecl *>(FD),
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

void clang_Sema_AddImplicitMSFunctionNoBuiltinAttr(CXSema S, CXFunctionDecl FD) {
  reinterpret_cast<clang::Sema *>(S)->AddImplicitMSFunctionNoBuiltinAttr(
      reinterpret_cast<clang::FunctionDecl *>(FD));
}

#include "clang/AST/Expr.h"
#include "clang/AST/Type.h"
#include "clang/Basic/TypeTraits.h"
#include "llvm/ADT/SmallVector.h"

CXQualType clang_Sema_BuildQualifiedType(CXSema S, CXQualType T, CXSourceLocation_ Loc,
                                         unsigned Quals) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuildQualifiedType(clang::QualType::getFromOpaquePtr(T),
                           clang::SourceLocation::getFromPtrEncoding(Loc),
                           clang::Qualifiers::fromOpaqueValue(Quals), nullptr)
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuildPointerType(CXSema S, CXQualType T, CXSourceLocation_ Loc,
                                       CXDeclarationName Entity) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuildPointerType(clang::QualType::getFromOpaquePtr(T),
                         clang::SourceLocation::getFromPtrEncoding(Loc),
                         clang::DeclarationName::getFromOpaquePtr(Entity))
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuildReferenceType(CXSema S, CXQualType T, bool LValueRef,
                                         CXSourceLocation_ Loc, CXDeclarationName Entity) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuildReferenceType(clang::QualType::getFromOpaquePtr(T), LValueRef,
                           clang::SourceLocation::getFromPtrEncoding(Loc),
                           clang::DeclarationName::getFromOpaquePtr(Entity))
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuildArrayType(CXSema S, CXQualType T, CXArraySizeModifier ASM,
                                     CXExpr ArraySize, unsigned Quals,
                                     CXSourceLocation_ Brackets_begin,
                                     CXSourceLocation_ Brackets_end,
                                     CXDeclarationName Entity) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuildArrayType(
          clang::QualType::getFromOpaquePtr(T), static_cast<clang::ArraySizeModifier>(ASM),
          reinterpret_cast<clang::Expr *>(ArraySize), Quals,
          clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Brackets_begin),
                             clang::SourceLocation::getFromPtrEncoding(Brackets_end)),
          clang::DeclarationName::getFromOpaquePtr(Entity))
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuildVectorType(CXSema S, CXQualType T, CXExpr VecSize,
                                      CXSourceLocation_ AttrLoc) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuildVectorType(clang::QualType::getFromOpaquePtr(T),
                        reinterpret_cast<clang::Expr *>(VecSize),
                        clang::SourceLocation::getFromPtrEncoding(AttrLoc))
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuildExtVectorType(CXSema S, CXQualType T, CXExpr ArraySize,
                                         CXSourceLocation_ AttrLoc) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuildExtVectorType(clang::QualType::getFromOpaquePtr(T),
                           reinterpret_cast<clang::Expr *>(ArraySize),
                           clang::SourceLocation::getFromPtrEncoding(AttrLoc))
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuildMemberPointerType(CXSema S, CXQualType T, CXQualType Class,
                                             CXSourceLocation_ Loc,
                                             CXDeclarationName Entity) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuildMemberPointerType(clang::QualType::getFromOpaquePtr(T),
                               clang::QualType::getFromOpaquePtr(Class),
                               clang::SourceLocation::getFromPtrEncoding(Loc),
                               clang::DeclarationName::getFromOpaquePtr(Entity))
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuildBlockPointerType(CXSema S, CXQualType T, CXSourceLocation_ Loc,
                                            CXDeclarationName Entity) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuildBlockPointerType(clang::QualType::getFromOpaquePtr(T),
                              clang::SourceLocation::getFromPtrEncoding(Loc),
                              clang::DeclarationName::getFromOpaquePtr(Entity))
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuildParenType(CXSema S, CXQualType T) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuildParenType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuildAtomicType(CXSema S, CXQualType T, CXSourceLocation_ Loc) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuildAtomicType(clang::QualType::getFromOpaquePtr(T),
                        clang::SourceLocation::getFromPtrEncoding(Loc))
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuildReadPipeType(CXSema S, CXQualType T, CXSourceLocation_ Loc) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuildReadPipeType(clang::QualType::getFromOpaquePtr(T),
                          clang::SourceLocation::getFromPtrEncoding(Loc))
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuildWritePipeType(CXSema S, CXQualType T, CXSourceLocation_ Loc) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuildWritePipeType(clang::QualType::getFromOpaquePtr(T),
                           clang::SourceLocation::getFromPtrEncoding(Loc))
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuildBitIntType(CXSema S, bool IsUnsigned, CXExpr BitWidth,
                                      CXSourceLocation_ Loc) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuildBitIntType(IsUnsigned, reinterpret_cast<clang::Expr *>(BitWidth),
                        clang::SourceLocation::getFromPtrEncoding(Loc))
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuildTypeofExprType(CXSema S, CXExpr E, CXTypeOfKind Kind) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuildTypeofExprType(reinterpret_cast<clang::Expr *>(E),
                            static_cast<clang::TypeOfKind>(Kind))
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuildDecltypeType(CXSema S, CXExpr E, bool AsUnevaluated) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuildDecltypeType(reinterpret_cast<clang::Expr *>(E), AsUnevaluated)
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuildUnaryTransformType(CXSema S, CXQualType BaseType,
                                              CXUTTKind UKind, CXSourceLocation_ Loc) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuildUnaryTransformType(clang::QualType::getFromOpaquePtr(BaseType),
                                static_cast<clang::UnaryTransformType::UTTKind>(UKind),
                                clang::SourceLocation::getFromPtrEncoding(Loc))
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuiltinEnumUnderlyingType(CXSema S, CXQualType BaseType,
                                                CXSourceLocation_ Loc) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuiltinEnumUnderlyingType(clang::QualType::getFromOpaquePtr(BaseType),
                                  clang::SourceLocation::getFromPtrEncoding(Loc))
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuiltinAddPointer(CXSema S, CXQualType BaseType,
                                        CXSourceLocation_ Loc) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuiltinAddPointer(clang::QualType::getFromOpaquePtr(BaseType),
                          clang::SourceLocation::getFromPtrEncoding(Loc))
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuiltinRemovePointer(CXSema S, CXQualType BaseType,
                                           CXSourceLocation_ Loc) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuiltinRemovePointer(clang::QualType::getFromOpaquePtr(BaseType),
                             clang::SourceLocation::getFromPtrEncoding(Loc))
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuiltinDecay(CXSema S, CXQualType BaseType, CXSourceLocation_ Loc) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuiltinDecay(clang::QualType::getFromOpaquePtr(BaseType),
                     clang::SourceLocation::getFromPtrEncoding(Loc))
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuiltinAddReference(CXSema S, CXQualType BaseType, CXUTTKind UKind,
                                          CXSourceLocation_ Loc) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuiltinAddReference(clang::QualType::getFromOpaquePtr(BaseType),
                            static_cast<clang::UnaryTransformType::UTTKind>(UKind),
                            clang::SourceLocation::getFromPtrEncoding(Loc))
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuiltinRemoveExtent(CXSema S, CXQualType BaseType, CXUTTKind UKind,
                                          CXSourceLocation_ Loc) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuiltinRemoveExtent(clang::QualType::getFromOpaquePtr(BaseType),
                            static_cast<clang::UnaryTransformType::UTTKind>(UKind),
                            clang::SourceLocation::getFromPtrEncoding(Loc))
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuiltinRemoveReference(CXSema S, CXQualType BaseType, CXUTTKind UKind,
                                             CXSourceLocation_ Loc) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuiltinRemoveReference(clang::QualType::getFromOpaquePtr(BaseType),
                               static_cast<clang::UnaryTransformType::UTTKind>(UKind),
                               clang::SourceLocation::getFromPtrEncoding(Loc))
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuiltinChangeCVRQualifiers(CXSema S, CXQualType BaseType,
                                                 CXUTTKind UKind, CXSourceLocation_ Loc) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuiltinChangeCVRQualifiers(clang::QualType::getFromOpaquePtr(BaseType),
                                   static_cast<clang::UnaryTransformType::UTTKind>(UKind),
                                   clang::SourceLocation::getFromPtrEncoding(Loc))
      .getAsOpaquePtr());
}

CXQualType clang_Sema_BuiltinChangeSignedness(CXSema S, CXQualType BaseType,
                                              CXUTTKind UKind, CXSourceLocation_ Loc) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuiltinChangeSignedness(clang::QualType::getFromOpaquePtr(BaseType),
                                static_cast<clang::UnaryTransformType::UTTKind>(UKind),
                                clang::SourceLocation::getFromPtrEncoding(Loc))
      .getAsOpaquePtr());
}

CXExpr clang_Sema_CreateBuiltinUnaryOp(CXSema S, CXSourceLocation_ OpLoc,
                                       CXUnaryOperatorKind Opc, CXExpr InputExpr,
                                       bool IsAfterAmp, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->CreateBuiltinUnaryOp(
      clang::SourceLocation::getFromPtrEncoding(OpLoc),
      static_cast<clang::UnaryOperatorKind>(Opc), reinterpret_cast<clang::Expr *>(InputExpr),
      IsAfterAmp);
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_CreateUnaryExprOrTypeTraitExpr(CXSema S, CXTypeSourceInfo TInfo,
                                                 CXSourceLocation_ OpLoc,
                                                 CXUnaryExprOrTypeTrait ExprKind,
                                                 CXSourceLocation_ R_begin,
                                                 CXSourceLocation_ R_end, bool *IsInvalid) {
  clang::ExprResult Res = reinterpret_cast<clang::Sema *>(S)->CreateUnaryExprOrTypeTraitExpr(
      reinterpret_cast<clang::TypeSourceInfo *>(TInfo),
      clang::SourceLocation::getFromPtrEncoding(OpLoc),
      static_cast<clang::UnaryExprOrTypeTrait>(ExprKind),
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(R_begin),
                         clang::SourceLocation::getFromPtrEncoding(R_end)));
  *IsInvalid = Res.isInvalid();
  return reinterpret_cast<CXExpr>(Res.isInvalid() ? nullptr : Res.get());
}

CXExpr clang_Sema_CreateBuiltinArraySubscriptExpr(CXSema S, CXExpr Base,
                                                  CXSourceLocation_ LLoc, CXExpr Idx,
                                                  CXSourceLocation_ RLoc, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->CreateBuiltinArraySubscriptExpr(
      reinterpret_cast<clang::Expr *>(Base), clang::SourceLocation::getFromPtrEncoding(LLoc),
      reinterpret_cast<clang::Expr *>(Idx), clang::SourceLocation::getFromPtrEncoding(RLoc));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_CreateBuiltinBinOp(CXSema S, CXSourceLocation_ OpLoc,
                                     CXBinaryOperatorKind Opc, CXExpr LHSExpr,
                                     CXExpr RHSExpr, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->CreateBuiltinBinOp(
      clang::SourceLocation::getFromPtrEncoding(OpLoc),
      static_cast<clang::BinaryOperatorKind>(Opc), reinterpret_cast<clang::Expr *>(LHSExpr),
      reinterpret_cast<clang::Expr *>(RHSExpr));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildInitList(CXSema S, CXSourceLocation_ LBraceLoc,
                                const CXExpr *InitArgList, unsigned NumInits,
                                CXSourceLocation_ RBraceLoc, bool *IsInvalid) {
  llvm::SmallVector<clang::Expr *, 8> Inits;
  Inits.reserve(NumInits);
  for (unsigned I = 0; I != NumInits; ++I)
    Inits.push_back(reinterpret_cast<clang::Expr *>(InitArgList[I]));
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildInitList(
      clang::SourceLocation::getFromPtrEncoding(LBraceLoc), Inits,
      clang::SourceLocation::getFromPtrEncoding(RBraceLoc));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildCXXNoexceptExpr(CXSema S, CXSourceLocation_ KeyLoc, CXExpr Operand,
                                       CXSourceLocation_ RParen, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildCXXNoexceptExpr(
      clang::SourceLocation::getFromPtrEncoding(KeyLoc),
      reinterpret_cast<clang::Expr *>(Operand),
      clang::SourceLocation::getFromPtrEncoding(RParen));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXParmVarDecl clang_Sema_BuildParmVarDeclForTypedef(CXSema S, CXDeclContext DC,
                                                    CXSourceLocation_ Loc, CXQualType T) {
  return reinterpret_cast<CXParmVarDecl>(reinterpret_cast<clang::Sema *>(S)->BuildParmVarDeclForTypedef(
      reinterpret_cast<clang::DeclContext *>(DC), clang::SourceLocation::getFromPtrEncoding(Loc),
      clang::QualType::getFromOpaquePtr(T)));
}

CXExpr clang_Sema_CreateRecoveryExpr(CXSema S, CXSourceLocation_ Begin,
                                     CXSourceLocation_ End, const CXExpr *SubExprs,
                                     unsigned NumSubExprs, CXQualType T, bool *IsInvalid) {
  llvm::SmallVector<clang::Expr *, 4> Subs;
  Subs.reserve(NumSubExprs);
  for (unsigned I = 0; I != NumSubExprs; ++I)
    Subs.push_back(reinterpret_cast<clang::Expr *>(SubExprs[I]));
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->CreateRecoveryExpr(
      clang::SourceLocation::getFromPtrEncoding(Begin),
      clang::SourceLocation::getFromPtrEncoding(End), Subs,
      clang::QualType::getFromOpaquePtr(T));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXDeclRefExpr clang_Sema_BuildDeclRefExpr(CXSema S, CXValueDecl D, CXQualType Ty,
                                          CXExprValueKind VK, CXSourceLocation_ Loc,
                                          CXCXXScopeSpec SS) {
  return reinterpret_cast<CXDeclRefExpr>(reinterpret_cast<clang::Sema *>(S)->BuildDeclRefExpr(
      reinterpret_cast<clang::ValueDecl *>(D), clang::QualType::getFromOpaquePtr(Ty),
      static_cast<clang::ExprValueKind>(VK), clang::SourceLocation::getFromPtrEncoding(Loc),
      reinterpret_cast<const clang::CXXScopeSpec *>(SS)));
}

CXExpr clang_Sema_BuildUnaryOp(CXSema S, CXScope Sp, CXSourceLocation_ OpLoc,
                               CXUnaryOperatorKind Opc, CXExpr Input, bool IsAfterAmp,
                               bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildUnaryOp(
      reinterpret_cast<clang::Scope *>(Sp), clang::SourceLocation::getFromPtrEncoding(OpLoc),
      static_cast<clang::UnaryOperatorKind>(Opc), reinterpret_cast<clang::Expr *>(Input),
      IsAfterAmp);
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildCallExpr(CXSema S, CXScope Sp, CXExpr Fn,
                                CXSourceLocation_ LParenLoc, const CXExpr *ArgExprs,
                                unsigned NumArgs, CXSourceLocation_ RParenLoc,
                                CXExpr ExecConfig, bool IsExecConfig, bool AllowRecovery,
                                bool *IsInvalid) {
  llvm::SmallVector<clang::Expr *, 8> Args;
  Args.reserve(NumArgs);
  for (unsigned I = 0; I != NumArgs; ++I)
    Args.push_back(reinterpret_cast<clang::Expr *>(ArgExprs[I]));
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildCallExpr(
      reinterpret_cast<clang::Scope *>(Sp), reinterpret_cast<clang::Expr *>(Fn),
      clang::SourceLocation::getFromPtrEncoding(LParenLoc), Args,
      clang::SourceLocation::getFromPtrEncoding(RParenLoc),
      reinterpret_cast<clang::Expr *>(ExecConfig), IsExecConfig, AllowRecovery);
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildCStyleCastExpr(CXSema S, CXSourceLocation_ LParenLoc,
                                      CXTypeSourceInfo Ty, CXSourceLocation_ RParenLoc,
                                      CXExpr Op, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildCStyleCastExpr(
      clang::SourceLocation::getFromPtrEncoding(LParenLoc),
      reinterpret_cast<clang::TypeSourceInfo *>(Ty),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc), reinterpret_cast<clang::Expr *>(Op));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildBinOp(CXSema S, CXScope Sp, CXSourceLocation_ OpLoc,
                             CXBinaryOperatorKind Opc, CXExpr LHSExpr, CXExpr RHSExpr,
                             bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildBinOp(
      reinterpret_cast<clang::Scope *>(Sp), clang::SourceLocation::getFromPtrEncoding(OpLoc),
      static_cast<clang::BinaryOperatorKind>(Opc), reinterpret_cast<clang::Expr *>(LHSExpr),
      reinterpret_cast<clang::Expr *>(RHSExpr));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildAsTypeExpr(CXSema S, CXExpr E, CXQualType DestTy,
                                  CXSourceLocation_ BuiltinLoc, CXSourceLocation_ RParenLoc,
                                  bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildAsTypeExpr(
      reinterpret_cast<clang::Expr *>(E), clang::QualType::getFromOpaquePtr(DestTy),
      clang::SourceLocation::getFromPtrEncoding(BuiltinLoc),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildBuiltinBitCastExpr(CXSema S, CXSourceLocation_ KWLoc,
                                          CXTypeSourceInfo TSI, CXExpr Operand,
                                          CXSourceLocation_ RParenLoc, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildBuiltinBitCastExpr(
      clang::SourceLocation::getFromPtrEncoding(KWLoc),
      reinterpret_cast<clang::TypeSourceInfo *>(TSI), reinterpret_cast<clang::Expr *>(Operand),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildEmptyCXXFoldExpr(CXSema S, CXSourceLocation_ EllipsisLoc,
                                        CXBinaryOperatorKind Operator, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildEmptyCXXFoldExpr(
      clang::SourceLocation::getFromPtrEncoding(EllipsisLoc),
      static_cast<clang::BinaryOperatorKind>(Operator));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildCXXTypeConstructExpr(CXSema S, CXTypeSourceInfo Type,
                                            CXSourceLocation_ LParenLoc,
                                            const CXExpr *Exprs, unsigned NumExprs,
                                            CXSourceLocation_ RParenLoc,
                                            bool ListInitialization, bool *IsInvalid) {
  llvm::SmallVector<clang::Expr *, 8> Args;
  Args.reserve(NumExprs);
  for (unsigned I = 0; I != NumExprs; ++I)
    Args.push_back(reinterpret_cast<clang::Expr *>(Exprs[I]));
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildCXXTypeConstructExpr(
      reinterpret_cast<clang::TypeSourceInfo *>(Type),
      clang::SourceLocation::getFromPtrEncoding(LParenLoc), Args,
      clang::SourceLocation::getFromPtrEncoding(RParenLoc), ListInitialization);
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildTypeTrait(CXSema S, CXTypeTrait Kind, CXSourceLocation_ KWLoc,
                                 const CXTypeSourceInfo *Args, unsigned NumArgs,
                                 CXSourceLocation_ RParenLoc, bool *IsInvalid) {
  llvm::SmallVector<clang::TypeSourceInfo *, 4> TSIs;
  TSIs.reserve(NumArgs);
  for (unsigned I = 0; I != NumArgs; ++I)
    TSIs.push_back(reinterpret_cast<clang::TypeSourceInfo *>(Args[I]));
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildTypeTrait(
      static_cast<clang::TypeTrait>(Kind), clang::SourceLocation::getFromPtrEncoding(KWLoc),
      TSIs, clang::SourceLocation::getFromPtrEncoding(RParenLoc));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildArrayTypeTrait(CXSema S, CXArrayTypeTrait ATT,
                                      CXSourceLocation_ KWLoc, CXTypeSourceInfo TSInfo,
                                      CXExpr DimExpr, CXSourceLocation_ RParen,
                                      bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildArrayTypeTrait(
      static_cast<clang::ArrayTypeTrait>(ATT),
      clang::SourceLocation::getFromPtrEncoding(KWLoc),
      reinterpret_cast<clang::TypeSourceInfo *>(TSInfo), reinterpret_cast<clang::Expr *>(DimExpr),
      clang::SourceLocation::getFromPtrEncoding(RParen));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildExpressionTrait(CXSema S, CXExpressionTrait OET,
                                       CXSourceLocation_ KWLoc, CXExpr Queried,
                                       CXSourceLocation_ RParen, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildExpressionTrait(
      static_cast<clang::ExpressionTrait>(OET),
      clang::SourceLocation::getFromPtrEncoding(KWLoc), reinterpret_cast<clang::Expr *>(Queried),
      clang::SourceLocation::getFromPtrEncoding(RParen));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXMaterializeTemporaryExpr
clang_Sema_CreateMaterializeTemporaryExpr(CXSema S, CXQualType T, CXExpr Temporary,
                                          bool BoundToLvalueReference) {
  return reinterpret_cast<CXMaterializeTemporaryExpr>(reinterpret_cast<clang::Sema *>(S)->CreateMaterializeTemporaryExpr(
      clang::QualType::getFromOpaquePtr(T), reinterpret_cast<clang::Expr *>(Temporary),
      BoundToLvalueReference));
}

CXDecl clang_Sema_BuildStaticAssertDeclaration(CXSema S, CXSourceLocation_ StaticAssertLoc,
                                               CXExpr AssertExpr, CXExpr AssertMessageExpr,
                                               CXSourceLocation_ RParenLoc, bool Failed) {
  return reinterpret_cast<CXDecl>(reinterpret_cast<clang::Sema *>(S)->BuildStaticAssertDeclaration(
      clang::SourceLocation::getFromPtrEncoding(StaticAssertLoc),
      reinterpret_cast<clang::Expr *>(AssertExpr), reinterpret_cast<clang::Expr *>(AssertMessageExpr),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc), Failed));
}

CXExpr clang_Sema_BuildExpressionFromNonTypeTemplateArgument(CXSema S,
                                                             CXTemplateArgument Arg,
                                                             CXSourceLocation_ Loc,
                                                             bool *IsInvalid) {
  clang::ExprResult R =
      reinterpret_cast<clang::Sema *>(S)->BuildExpressionFromNonTypeTemplateArgument(
          *reinterpret_cast<clang::TemplateArgument *>(Arg),
          clang::SourceLocation::getFromPtrEncoding(Loc));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildCXXFunctionalCastExpr(CXSema S, CXTypeSourceInfo TInfo,
                                             CXQualType Type, CXSourceLocation_ LParenLoc,
                                             CXExpr CastExpr, CXSourceLocation_ RParenLoc,
                                             bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildCXXFunctionalCastExpr(
      reinterpret_cast<clang::TypeSourceInfo *>(TInfo), clang::QualType::getFromOpaquePtr(Type),
      clang::SourceLocation::getFromPtrEncoding(LParenLoc),
      reinterpret_cast<clang::Expr *>(CastExpr),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

// --- Name, offsetof and instantiation-rebuild node builders ---

CXDeclGroupRef clang_Sema_BuildDeclaratorGroup(CXSema S, const CXDecl *Group,
                                               unsigned NumDecls) {
  llvm::SmallVector<clang::Decl *, 4> Decls;
  Decls.reserve(NumDecls);
  for (unsigned I = 0; I != NumDecls; ++I)
    Decls.push_back(reinterpret_cast<clang::Decl *>(Group[I]));
  return reinterpret_cast<CXDeclGroupRef>(reinterpret_cast<clang::Sema *>(S)->BuildDeclaratorGroup(Decls).getAsOpaquePtr());
}

CXExpr clang_Sema_MakeFullExpr(CXSema S, CXExpr Arg, CXSourceLocation_ CC) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::Sema *>(S)
      ->MakeFullExpr(reinterpret_cast<clang::Expr *>(Arg),
                     clang::SourceLocation::getFromPtrEncoding(CC))
      .get());
}

CXExpr clang_Sema_MakeFullDiscardedValueExpr(CXSema S, CXExpr Arg) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::Sema *>(S)
      ->MakeFullDiscardedValueExpr(reinterpret_cast<clang::Expr *>(Arg))
      .get());
}

CXVarDecl clang_Sema_BuildExceptionDeclaration(CXSema S, CXScope Sp, CXTypeSourceInfo TInfo,
                                               CXSourceLocation_ StartLoc,
                                               CXSourceLocation_ IdLoc,
                                               CXIdentifierInfo Id) {
  return reinterpret_cast<CXVarDecl>(reinterpret_cast<clang::Sema *>(S)->BuildExceptionDeclaration(
      reinterpret_cast<clang::Scope *>(Sp), reinterpret_cast<clang::TypeSourceInfo *>(TInfo),
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      clang::SourceLocation::getFromPtrEncoding(IdLoc),
      reinterpret_cast<clang::IdentifierInfo *>(Id)));
}

CXExpr clang_Sema_BuildSYCLUniqueStableNameExpr(CXSema S, CXSourceLocation_ OpLoc,
                                                CXSourceLocation_ LParen,
                                                CXSourceLocation_ RParen,
                                                CXTypeSourceInfo TSI, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildSYCLUniqueStableNameExpr(
      clang::SourceLocation::getFromPtrEncoding(OpLoc),
      clang::SourceLocation::getFromPtrEncoding(LParen),
      clang::SourceLocation::getFromPtrEncoding(RParen),
      reinterpret_cast<clang::TypeSourceInfo *>(TSI));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildFieldReferenceExpr(CXSema S, CXExpr BaseExpr, bool IsArrow,
                                          CXSourceLocation_ OpLoc, CXCXXScopeSpec SS,
                                          CXFieldDecl Field, CXNamedDecl FoundDecl,
                                          CXAccessSpecifier FoundAccess,
                                          CXDeclarationNameInfo MemberNameInfo,
                                          bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildFieldReferenceExpr(
      reinterpret_cast<clang::Expr *>(BaseExpr), IsArrow,
      clang::SourceLocation::getFromPtrEncoding(OpLoc),
      *reinterpret_cast<clang::CXXScopeSpec *>(SS), reinterpret_cast<clang::FieldDecl *>(Field),
      clang::DeclAccessPair::make(reinterpret_cast<clang::NamedDecl *>(FoundDecl),
                                  static_cast<clang::AccessSpecifier>(FoundAccess)),
      *reinterpret_cast<clang::DeclarationNameInfo *>(MemberNameInfo));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildCompoundLiteralExpr(CXSema S, CXSourceLocation_ LParenLoc,
                                           CXTypeSourceInfo TInfo,
                                           CXSourceLocation_ RParenLoc, CXExpr LiteralExpr,
                                           bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildCompoundLiteralExpr(
      clang::SourceLocation::getFromPtrEncoding(LParenLoc),
      reinterpret_cast<clang::TypeSourceInfo *>(TInfo),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc),
      reinterpret_cast<clang::Expr *>(LiteralExpr));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildVAArgExpr(CXSema S, CXSourceLocation_ BuiltinLoc, CXExpr E,
                                 CXTypeSourceInfo TInfo, CXSourceLocation_ RPLoc,
                                 bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildVAArgExpr(
      clang::SourceLocation::getFromPtrEncoding(BuiltinLoc), reinterpret_cast<clang::Expr *>(E),
      reinterpret_cast<clang::TypeSourceInfo *>(TInfo),
      clang::SourceLocation::getFromPtrEncoding(RPLoc));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildCXXNamedCast(CXSema S, CXSourceLocation_ OpLoc, unsigned Kind,
                                    CXTypeSourceInfo Ty, CXExpr E,
                                    CXSourceLocation_ AngleBracketsBegin,
                                    CXSourceLocation_ AngleBracketsEnd,
                                    CXSourceLocation_ ParensBegin,
                                    CXSourceLocation_ ParensEnd, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildCXXNamedCast(
      clang::SourceLocation::getFromPtrEncoding(OpLoc),
      static_cast<clang::tok::TokenKind>(Kind), reinterpret_cast<clang::TypeSourceInfo *>(Ty),
      reinterpret_cast<clang::Expr *>(E),
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(AngleBracketsBegin),
                         clang::SourceLocation::getFromPtrEncoding(AngleBracketsEnd)),
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(ParensBegin),
                         clang::SourceLocation::getFromPtrEncoding(ParensEnd)));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildCXXTypeId(CXSema S, CXQualType TypeInfoType,
                                 CXSourceLocation_ TypeidLoc, CXTypeSourceInfo Operand,
                                 CXSourceLocation_ RParenLoc, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildCXXTypeId(
      clang::QualType::getFromOpaquePtr(TypeInfoType),
      clang::SourceLocation::getFromPtrEncoding(TypeidLoc),
      reinterpret_cast<clang::TypeSourceInfo *>(Operand),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildExpressionFromDeclTemplateArgument(CXSema S, CXTemplateArgument Arg,
                                                          CXQualType ParamType,
                                                          CXSourceLocation_ Loc,
                                                          bool *IsInvalid) {
  clang::ExprResult R =
      reinterpret_cast<clang::Sema *>(S)->BuildExpressionFromDeclTemplateArgument(
          *reinterpret_cast<clang::TemplateArgument *>(Arg),
          clang::QualType::getFromOpaquePtr(ParamType),
          clang::SourceLocation::getFromPtrEncoding(Loc));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXQualType clang_Sema_BuildFunctionType(CXSema S, CXQualType T, CXQualType *ParamTypes,
                                        unsigned NumParams, CXSourceLocation_ Loc,
                                        CXDeclarationName Entity, bool IsVariadic,
                                        CXCallingConv_ CC) {
  llvm::SmallVector<clang::QualType, 8> Params;
  Params.reserve(NumParams);
  for (unsigned I = 0; I < NumParams; ++I)
    Params.push_back(clang::QualType::getFromOpaquePtr(ParamTypes[I]));
  clang::FunctionProtoType::ExtProtoInfo EPI;
  EPI.Variadic = IsVariadic;
  EPI.ExtInfo = EPI.ExtInfo.withCallingConv(static_cast<clang::CallingConv>(CC));
  clang::QualType R = reinterpret_cast<clang::Sema *>(S)->BuildFunctionType(
      clang::QualType::getFromOpaquePtr(T), Params,
      clang::SourceLocation::getFromPtrEncoding(Loc),
      clang::DeclarationName::getFromOpaquePtr(Entity), EPI);
  for (unsigned I = 0; I < NumParams; ++I)
    ParamTypes[I] = reinterpret_cast<CXQualType>(Params[I].getAsOpaquePtr());
  return reinterpret_cast<CXQualType>(R.getAsOpaquePtr());
}

CXExpr clang_Sema_BuildConvertedConstantExpression(CXSema S, CXExpr From, CXQualType T,
                                                   CXCCEKind CCE, CXNamedDecl Dest,
                                                   bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildConvertedConstantExpression(
      reinterpret_cast<clang::Expr *>(From), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::Sema::CCEKind>(CCE), reinterpret_cast<clang::NamedDecl *>(Dest));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildDeclarationNameExpr(CXSema S, CXCXXScopeSpec SS, CXLookupResult R,
                                           bool NeedsADL, bool AcceptInvalidDecl,
                                           bool *IsInvalid) {
  clang::ExprResult Res = reinterpret_cast<clang::Sema *>(S)->BuildDeclarationNameExpr(
      *reinterpret_cast<clang::CXXScopeSpec *>(SS), *reinterpret_cast<clang::LookupResult *>(R),
      NeedsADL, AcceptInvalidDecl);
  *IsInvalid = Res.isInvalid();
  return reinterpret_cast<CXExpr>(Res.isInvalid() ? nullptr : Res.get());
}

CXExpr clang_Sema_BuildPredefinedExpr(CXSema S, CXSourceLocation_ Loc,
                                      CXPredefinedIdentKind IK, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildPredefinedExpr(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      static_cast<clang::PredefinedIdentKind>(IK));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildBuiltinOffsetOf(
    CXSema S, CXSourceLocation_ BuiltinLoc, CXTypeSourceInfo TInfo,
    const CXSourceLocation_ *LocStarts, const CXSourceLocation_ *LocEnds,
    const bool *IsBrackets, const CXIdentifierInfo *Idents, const CXExpr *Indices,
    unsigned NumComponents, CXSourceLocation_ RParenLoc, bool *IsInvalid) {
  llvm::SmallVector<clang::Sema::OffsetOfComponent, 4> Components;
  Components.reserve(NumComponents);
  for (unsigned I = 0; I < NumComponents; ++I) {
    clang::Sema::OffsetOfComponent C;
    C.LocStart = clang::SourceLocation::getFromPtrEncoding(LocStarts[I]);
    C.LocEnd = clang::SourceLocation::getFromPtrEncoding(LocEnds[I]);
    C.isBrackets = IsBrackets[I];
    if (C.isBrackets)
      C.U.E = reinterpret_cast<clang::Expr *>(Indices[I]);
    else
      C.U.IdentInfo = reinterpret_cast<clang::IdentifierInfo *>(Idents[I]);
    Components.push_back(C);
  }
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildBuiltinOffsetOf(
      clang::SourceLocation::getFromPtrEncoding(BuiltinLoc),
      reinterpret_cast<clang::TypeSourceInfo *>(TInfo), Components,
      clang::SourceLocation::getFromPtrEncoding(RParenLoc));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildSourceLocExpr(CXSema S, CXSourceLocIdentKind Kind,
                                     CXQualType ResultTy, CXSourceLocation_ BuiltinLoc,
                                     CXSourceLocation_ RParenLoc,
                                     CXDeclContext ParentContext, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildSourceLocExpr(
      static_cast<clang::SourceLocIdentKind>(Kind),
      clang::QualType::getFromOpaquePtr(ResultTy),
      clang::SourceLocation::getFromPtrEncoding(BuiltinLoc),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc),
      reinterpret_cast<clang::DeclContext *>(ParentContext));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildCXXThrow(CXSema S, CXSourceLocation_ OpLoc, CXExpr Ex,
                                bool IsThrownVarInScope, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildCXXThrow(
      clang::SourceLocation::getFromPtrEncoding(OpLoc), reinterpret_cast<clang::Expr *>(Ex),
      IsThrownVarInScope);
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildTemplateIdExpr(CXSema S, CXCXXScopeSpec SS,
                                      CXSourceLocation_ TemplateKWLoc, CXLookupResult R,
                                      bool RequiresADL,
                                      CXTemplateArgumentListInfo TemplateArgs,
                                      bool *IsInvalid) {
  clang::ExprResult Res = reinterpret_cast<clang::Sema *>(S)->BuildTemplateIdExpr(
      *reinterpret_cast<clang::CXXScopeSpec *>(SS),
      clang::SourceLocation::getFromPtrEncoding(TemplateKWLoc),
      *reinterpret_cast<clang::LookupResult *>(R), RequiresADL,
      reinterpret_cast<clang::TemplateArgumentListInfo *>(TemplateArgs));
  *IsInvalid = Res.isInvalid();
  return reinterpret_cast<CXExpr>(Res.isInvalid() ? nullptr : Res.get());
}

CXTypeSourceInfo clang_Sema_RebuildTypeInCurrentInstantiation(CXSema S, CXTypeSourceInfo T,
                                                              CXSourceLocation_ Loc,
                                                              CXDeclarationName Name) {
  return reinterpret_cast<CXTypeSourceInfo>(reinterpret_cast<clang::Sema *>(S)->RebuildTypeInCurrentInstantiation(
      reinterpret_cast<clang::TypeSourceInfo *>(T),
      clang::SourceLocation::getFromPtrEncoding(Loc),
      clang::DeclarationName::getFromOpaquePtr(Name)));
}

bool clang_Sema_RebuildNestedNameSpecifierInCurrentInstantiation(CXSema S,
                                                                 CXCXXScopeSpec SS) {
  return reinterpret_cast<clang::Sema *>(S)->RebuildNestedNameSpecifierInCurrentInstantiation(
      *reinterpret_cast<clang::CXXScopeSpec *>(SS));
}

CXExpr clang_Sema_RebuildExprInCurrentInstantiation(CXSema S, CXExpr E, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->RebuildExprInCurrentInstantiation(
      reinterpret_cast<clang::Expr *>(E));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

bool clang_Sema_RebuildTemplateParamsInCurrentInstantiation(
    CXSema S, CXTemplateParameterList Params) {
  return reinterpret_cast<clang::Sema *>(S)->RebuildTemplateParamsInCurrentInstantiation(
      reinterpret_cast<clang::TemplateParameterList *>(Params));
}

#include "llvm/ADT/SmallBitVector.h"

void clang_Sema_MarkUnusedFileScopedDecl(CXSema S, CXDeclaratorDecl D) {
  reinterpret_cast<clang::Sema *>(S)->MarkUnusedFileScopedDecl(
      reinterpret_cast<clang::DeclaratorDecl *>(D));
}

void clang_Sema_MarkAnyDeclReferenced(CXSema S, CXSourceLocation_ Loc, CXDecl D,
                                      bool MightBeOdrUse) {
  reinterpret_cast<clang::Sema *>(S)->MarkAnyDeclReferenced(
      clang::SourceLocation::getFromPtrEncoding(Loc), reinterpret_cast<clang::Decl *>(D),
      MightBeOdrUse);
}

void clang_Sema_MarkFunctionReferenced(CXSema S, CXSourceLocation_ Loc, CXFunctionDecl Func,
                                       bool MightBeOdrUse) {
  reinterpret_cast<clang::Sema *>(S)->MarkFunctionReferenced(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      reinterpret_cast<clang::FunctionDecl *>(Func), MightBeOdrUse);
}

void clang_Sema_MarkVariableReferenced(CXSema S, CXSourceLocation_ Loc, CXVarDecl Var) {
  reinterpret_cast<clang::Sema *>(S)->MarkVariableReferenced(
      clang::SourceLocation::getFromPtrEncoding(Loc), reinterpret_cast<clang::VarDecl *>(Var));
}

void clang_Sema_MarkDeclarationsReferencedInType(CXSema S, CXSourceLocation_ Loc,
                                                 CXQualType T) {
  reinterpret_cast<clang::Sema *>(S)->MarkDeclarationsReferencedInType(
      clang::SourceLocation::getFromPtrEncoding(Loc), clang::QualType::getFromOpaquePtr(T));
}

void clang_Sema_MarkBaseAndMemberDestructorsReferenced(CXSema S, CXSourceLocation_ Loc,
                                                       CXCXXRecordDecl Record) {
  reinterpret_cast<clang::Sema *>(S)->MarkBaseAndMemberDestructorsReferenced(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      reinterpret_cast<clang::CXXRecordDecl *>(Record));
}

void clang_Sema_MarkVTableUsed(CXSema S, CXSourceLocation_ Loc, CXCXXRecordDecl Class,
                               bool DefinitionRequired) {
  reinterpret_cast<clang::Sema *>(S)->MarkVTableUsed(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      reinterpret_cast<clang::CXXRecordDecl *>(Class), DefinitionRequired);
}

void clang_Sema_MarkVirtualMemberExceptionSpecsNeeded(CXSema S, CXSourceLocation_ Loc,
                                                      CXCXXRecordDecl RD) {
  reinterpret_cast<clang::Sema *>(S)->MarkVirtualMemberExceptionSpecsNeeded(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      reinterpret_cast<clang::CXXRecordDecl *>(RD));
}

void clang_Sema_MarkVirtualMembersReferenced(CXSema S, CXSourceLocation_ Loc,
                                             CXCXXRecordDecl RD, bool ConstexprOnly) {
  reinterpret_cast<clang::Sema *>(S)->MarkVirtualMembersReferenced(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      reinterpret_cast<clang::CXXRecordDecl *>(RD), ConstexprOnly);
}

bool clang_Sema_CheckTemplateArgument(CXSema S, CXTypeSourceInfo Arg) {
  return reinterpret_cast<clang::Sema *>(S)->CheckTemplateArgument(
      reinterpret_cast<clang::TypeSourceInfo *>(Arg));
}

CXQualType clang_Sema_SubstAutoType(CXSema S, CXQualType TypeWithAuto,
                                    CXQualType Replacement) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->SubstAutoType(clang::QualType::getFromOpaquePtr(TypeWithAuto),
                      clang::QualType::getFromOpaquePtr(Replacement))
      .getAsOpaquePtr());
}

CXTypeSourceInfo clang_Sema_SubstAutoTypeSourceInfo(CXSema S, CXTypeSourceInfo TypeWithAuto,
                                                    CXQualType Replacement) {
  return reinterpret_cast<CXTypeSourceInfo>(reinterpret_cast<clang::Sema *>(S)->SubstAutoTypeSourceInfo(
      reinterpret_cast<clang::TypeSourceInfo *>(TypeWithAuto),
      clang::QualType::getFromOpaquePtr(Replacement)));
}

CXQualType clang_Sema_SubstAutoTypeDependent(CXSema S, CXQualType TypeWithAuto) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->SubstAutoTypeDependent(clang::QualType::getFromOpaquePtr(TypeWithAuto))
      .getAsOpaquePtr());
}

CXTypeSourceInfo
clang_Sema_SubstAutoTypeSourceInfoDependent(CXSema S, CXTypeSourceInfo TypeWithAuto) {
  return reinterpret_cast<CXTypeSourceInfo>(reinterpret_cast<clang::Sema *>(S)->SubstAutoTypeSourceInfoDependent(
      reinterpret_cast<clang::TypeSourceInfo *>(TypeWithAuto)));
}

CXQualType clang_Sema_ReplaceAutoType(CXSema S, CXQualType TypeWithAuto,
                                      CXQualType Replacement) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->ReplaceAutoType(clang::QualType::getFromOpaquePtr(TypeWithAuto),
                        clang::QualType::getFromOpaquePtr(Replacement))
      .getAsOpaquePtr());
}

CXTypeSourceInfo clang_Sema_ReplaceAutoTypeSourceInfo(CXSema S,
                                                      CXTypeSourceInfo TypeWithAuto,
                                                      CXQualType Replacement) {
  return reinterpret_cast<CXTypeSourceInfo>(reinterpret_cast<clang::Sema *>(S)->ReplaceAutoTypeSourceInfo(
      reinterpret_cast<clang::TypeSourceInfo *>(TypeWithAuto),
      clang::QualType::getFromOpaquePtr(Replacement)));
}

bool clang_Sema_DeduceReturnType(CXSema S, CXFunctionDecl FD, CXSourceLocation_ Loc,
                                 bool Diagnose) {
  return reinterpret_cast<clang::Sema *>(S)->DeduceReturnType(
      reinterpret_cast<clang::FunctionDecl *>(FD),
      clang::SourceLocation::getFromPtrEncoding(Loc), Diagnose);
}

void clang_Sema_MarkDeducedTemplateParameters(CXSema S, CXFunctionTemplateDecl FTD,
                                              bool *Deduced, unsigned N) {
  llvm::SmallBitVector Bits;
  reinterpret_cast<clang::Sema *>(S)->MarkDeducedTemplateParameters(
      reinterpret_cast<clang::FunctionTemplateDecl *>(FTD), Bits);
  unsigned Count = static_cast<unsigned>(Bits.size());
  if (N < Count)
    Count = N;
  for (unsigned I = 0; I != Count; ++I)
    Deduced[I] = Bits[I];
}

bool clang_Sema_InstantiateDefaultArgument(CXSema S, CXSourceLocation_ CallLoc,
                                           CXFunctionDecl FD, CXParmVarDecl Param) {
  return reinterpret_cast<clang::Sema *>(S)->InstantiateDefaultArgument(
      clang::SourceLocation::getFromPtrEncoding(CallLoc),
      reinterpret_cast<clang::FunctionDecl *>(FD), reinterpret_cast<clang::ParmVarDecl *>(Param));
}

void clang_Sema_InstantiateExceptionSpec(CXSema S, CXSourceLocation_ PointOfInstantiation,
                                         CXFunctionDecl Function) {
  reinterpret_cast<clang::Sema *>(S)->InstantiateExceptionSpec(
      clang::SourceLocation::getFromPtrEncoding(PointOfInstantiation),
      reinterpret_cast<clang::FunctionDecl *>(Function));
}

CXFunctionDecl clang_Sema_InstantiateFunctionDeclaration(CXSema S,
                                                         CXFunctionTemplateDecl FTD,
                                                         CXTemplateArgumentList Args,
                                                         CXSourceLocation_ Loc) {
  return reinterpret_cast<CXFunctionDecl>(reinterpret_cast<clang::Sema *>(S)->InstantiateFunctionDeclaration(
      reinterpret_cast<clang::FunctionTemplateDecl *>(FTD),
      reinterpret_cast<clang::TemplateArgumentList *>(Args),
      clang::SourceLocation::getFromPtrEncoding(Loc)));
}

// --- Driving a substitution from outside the parser ---

unsigned clang_Sema_getNumCodeSynthesisContexts(CXSema S) {
  return static_cast<unsigned>(reinterpret_cast<clang::Sema *>(S)->CodeSynthesisContexts.size());
}

CXInstantiatingTemplate
clang_InstantiatingTemplate_create(CXSema S, CXSourceLocation_ PointOfInstantiation,
                                   CXDecl Entity, CXSourceRange_ InstantiationRange) {
  return reinterpret_cast<CXInstantiatingTemplate>(new clang::Sema::InstantiatingTemplate( // NOLINT(*-owning-memory)
      *reinterpret_cast<clang::Sema *>(S),
      clang::SourceLocation::getFromPtrEncoding(PointOfInstantiation),
      reinterpret_cast<clang::Decl *>(Entity),
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(InstantiationRange.B),
                         clang::SourceLocation::getFromPtrEncoding(InstantiationRange.E))));
}

void clang_InstantiatingTemplate_dispose(CXInstantiatingTemplate Inst) {
  delete reinterpret_cast<clang::Sema::InstantiatingTemplate *>(Inst);
}

void clang_InstantiatingTemplate_Clear(CXInstantiatingTemplate Inst) {
  reinterpret_cast<clang::Sema::InstantiatingTemplate *>(Inst)->Clear();
}

bool clang_InstantiatingTemplate_isInvalid(CXInstantiatingTemplate Inst) {
  return reinterpret_cast<clang::Sema::InstantiatingTemplate *>(Inst)->isInvalid();
}

bool clang_InstantiatingTemplate_isAlreadyInstantiating(CXInstantiatingTemplate Inst) {
  return reinterpret_cast<clang::Sema::InstantiatingTemplate *>(Inst)->isAlreadyInstantiating();
}

CXTypeSourceInfo clang_Sema_SubstTypeSourceInfo(
    CXSema S, CXTypeSourceInfo T, CXMultiLevelTemplateArgumentList TemplateArgs,
    CXSourceLocation_ Loc, CXDeclarationName Entity, bool AllowDeducedTST) {
  return reinterpret_cast<CXTypeSourceInfo>(reinterpret_cast<clang::Sema *>(S)->SubstType(
      reinterpret_cast<clang::TypeSourceInfo *>(T),
      extra::unboxMultiLevelTemplateArgumentList(TemplateArgs),
      clang::SourceLocation::getFromPtrEncoding(Loc),
      clang::DeclarationName::getFromOpaquePtr(Entity), AllowDeducedTST));
}

CXQualType clang_Sema_SubstType(CXSema S, CXQualType T,
                                CXMultiLevelTemplateArgumentList TemplateArgs,
                                CXSourceLocation_ Loc, CXDeclarationName Entity) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->SubstType(clang::QualType::getFromOpaquePtr(T),
                  extra::unboxMultiLevelTemplateArgumentList(TemplateArgs),
                  clang::SourceLocation::getFromPtrEncoding(Loc),
                  clang::DeclarationName::getFromOpaquePtr(Entity))
      .getAsOpaquePtr());
}

CXExpr clang_Sema_SubstExpr(CXSema S, CXExpr E,
                            CXMultiLevelTemplateArgumentList TemplateArgs,
                            bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->SubstExpr(
      reinterpret_cast<clang::Expr *>(E),
      extra::unboxMultiLevelTemplateArgumentList(TemplateArgs));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_SubstConstraintExpr(CXSema S, CXExpr E,
                                      CXMultiLevelTemplateArgumentList TemplateArgs,
                                      bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->SubstConstraintExpr(
      reinterpret_cast<clang::Expr *>(E),
      extra::unboxMultiLevelTemplateArgumentList(TemplateArgs));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_SubstConstraintExprWithoutSatisfaction(
    CXSema S, CXExpr E, CXMultiLevelTemplateArgumentList TemplateArgs, bool *IsInvalid) {
  clang::ExprResult R =
      reinterpret_cast<clang::Sema *>(S)->SubstConstraintExprWithoutSatisfaction(
          reinterpret_cast<clang::Expr *>(E),
          extra::unboxMultiLevelTemplateArgumentList(TemplateArgs));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXStmt clang_Sema_SubstStmt(CXSema S, CXStmt St,
                            CXMultiLevelTemplateArgumentList TemplateArgs,
                            bool *IsInvalid) {
  clang::StmtResult R = reinterpret_cast<clang::Sema *>(S)->SubstStmt(
      reinterpret_cast<clang::Stmt *>(St),
      extra::unboxMultiLevelTemplateArgumentList(TemplateArgs));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXStmt>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_SubstInitializer(CXSema S, CXExpr E,
                                   CXMultiLevelTemplateArgumentList TemplateArgs,
                                   bool CXXDirectInit, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->SubstInitializer(
      reinterpret_cast<clang::Expr *>(E),
      extra::unboxMultiLevelTemplateArgumentList(TemplateArgs), CXXDirectInit);
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXNestedNameSpecifierLoc
clang_Sema_SubstNestedNameSpecifierLoc(CXSema S, CXNestedNameSpecifierLoc NNS,
                                       CXMultiLevelTemplateArgumentList TemplateArgs) {
  return reinterpret_cast<CXNestedNameSpecifierLoc>(new clang::NestedNameSpecifierLoc( // NOLINT(*-owning-memory)
      reinterpret_cast<clang::Sema *>(S)->SubstNestedNameSpecifierLoc(
          *reinterpret_cast<clang::NestedNameSpecifierLoc *>(NNS),
          extra::unboxMultiLevelTemplateArgumentList(TemplateArgs))));
}

CXDeclarationNameInfo
clang_Sema_SubstDeclarationNameInfo(CXSema S, CXDeclarationNameInfo NameInfo,
                                    CXMultiLevelTemplateArgumentList TemplateArgs) {
  return reinterpret_cast<CXDeclarationNameInfo>(new clang::DeclarationNameInfo( // NOLINT(*-owning-memory)
      reinterpret_cast<clang::Sema *>(S)->SubstDeclarationNameInfo(
          *reinterpret_cast<clang::DeclarationNameInfo *>(NameInfo),
          extra::unboxMultiLevelTemplateArgumentList(TemplateArgs))));
}
#include "utils.h"

bool clang_Sema_hasCurrentInstantiationScope(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->CurrentInstantiationScope != nullptr;
}

CXTypeSourceInfo clang_Sema_SubstFunctionDeclType(
    CXSema S, CXTypeSourceInfo T, CXMultiLevelTemplateArgumentList TemplateArgs,
    CXSourceLocation_ Loc, CXDeclarationName Entity, CXCXXRecordDecl ThisContext,
    unsigned ThisTypeQuals, bool EvaluateConstraints) {
  return reinterpret_cast<CXTypeSourceInfo>(reinterpret_cast<clang::Sema *>(S)->SubstFunctionDeclType(
      reinterpret_cast<clang::TypeSourceInfo *>(T),
      extra::unboxMultiLevelTemplateArgumentList(TemplateArgs),
      clang::SourceLocation::getFromPtrEncoding(Loc),
      clang::DeclarationName::getFromOpaquePtr(Entity),
      reinterpret_cast<clang::CXXRecordDecl *>(ThisContext),
      clang::Qualifiers::fromOpaqueValue(ThisTypeQuals), EvaluateConstraints));
}

void clang_Sema_SubstExceptionSpec(CXSema S, CXFunctionDecl New, CXFunctionProtoType Proto,
                                   CXMultiLevelTemplateArgumentList TemplateArgs) {
  reinterpret_cast<clang::Sema *>(S)->SubstExceptionSpec(
      reinterpret_cast<clang::FunctionDecl *>(New),
      reinterpret_cast<clang::FunctionProtoType *>(Proto),
      extra::unboxMultiLevelTemplateArgumentList(TemplateArgs));
}

CXParmVarDecl clang_Sema_SubstParmVarDecl(CXSema S, CXParmVarDecl D,
                                          CXMultiLevelTemplateArgumentList TemplateArgs,
                                          int IndexAdjustment, bool HasNumExpansions,
                                          unsigned NumExpansions, bool ExpectParameterPack,
                                          bool EvaluateConstraints) {
  return reinterpret_cast<CXParmVarDecl>(reinterpret_cast<clang::Sema *>(S)->SubstParmVarDecl(
      reinterpret_cast<clang::ParmVarDecl *>(D),
      extra::unboxMultiLevelTemplateArgumentList(TemplateArgs), IndexAdjustment,
      HasNumExpansions ? std::optional<unsigned>(NumExpansions) : std::nullopt,
      ExpectParameterPack, EvaluateConstraints));
}

bool clang_Sema_SubstParmTypes(CXSema S, CXSourceLocation_ Loc, const CXParmVarDecl *Params,
                               unsigned NumParams,
                               CXMultiLevelTemplateArgumentList TemplateArgs,
                               CXQualType *ParamTypes, CXParmVarDecl *OutParams,
                               unsigned Capacity, unsigned *NumParamTypes) {
  llvm::SmallVector<clang::ParmVarDecl *, 8> Inputs;
  Inputs.reserve(NumParams);
  for (unsigned I = 0; I != NumParams; ++I)
    Inputs.push_back(reinterpret_cast<clang::ParmVarDecl *>(Params[I]));

  llvm::SmallVector<clang::QualType, 8> Types;
  llvm::SmallVector<clang::ParmVarDecl *, 8> NewParams;
  clang::Sema::ExtParameterInfoBuilder ParamInfos;
  bool Failed = reinterpret_cast<clang::Sema *>(S)->SubstParmTypes(
      clang::SourceLocation::getFromPtrEncoding(Loc), Inputs, nullptr,
      extra::unboxMultiLevelTemplateArgumentList(TemplateArgs), Types, &NewParams,
      ParamInfos);

  unsigned Produced = static_cast<unsigned>(Types.size());
  *NumParamTypes = Produced;
  unsigned N = Capacity < Produced ? Capacity : Produced;
  if (ParamTypes)
    for (unsigned I = 0; I != N; ++I)
      ParamTypes[I] = reinterpret_cast<CXQualType>(Types[I].getAsOpaquePtr());
  if (OutParams) {
    unsigned Available = static_cast<unsigned>(NewParams.size());
    unsigned M = Available < N ? Available : N;
    for (unsigned I = 0; I != M; ++I)
      OutParams[I] = reinterpret_cast<CXParmVarDecl>(NewParams[I]);
  }
  return Failed;
}

bool clang_Sema_SubstDefaultArgument(CXSema S, CXSourceLocation_ Loc, CXParmVarDecl Param,
                                     CXMultiLevelTemplateArgumentList TemplateArgs,
                                     bool ForCallExpr) {
  return reinterpret_cast<clang::Sema *>(S)->SubstDefaultArgument(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      reinterpret_cast<clang::ParmVarDecl *>(Param),
      extra::unboxMultiLevelTemplateArgumentList(TemplateArgs), ForCallExpr);
}

bool clang_Sema_SubstExprs(CXSema S, const CXExpr *Exprs, unsigned NumExprs, bool IsCall,
                           CXMultiLevelTemplateArgumentList TemplateArgs, CXExpr *Outputs,
                           unsigned OutputsCapacity, unsigned *NumOutputs) {
  llvm::SmallVector<clang::Expr *, 8> Inputs;
  Inputs.reserve(NumExprs);
  for (unsigned I = 0; I != NumExprs; ++I)
    Inputs.push_back(reinterpret_cast<clang::Expr *>(Exprs[I]));

  llvm::SmallVector<clang::Expr *, 8> Results;
  bool Failed = reinterpret_cast<clang::Sema *>(S)->SubstExprs(
      Inputs, IsCall, extra::unboxMultiLevelTemplateArgumentList(TemplateArgs), Results);

  unsigned Produced = static_cast<unsigned>(Results.size());
  *NumOutputs = Produced;
  if (Outputs) {
    unsigned N = OutputsCapacity < Produced ? OutputsCapacity : Produced;
    for (unsigned I = 0; I != N; ++I)
      Outputs[I] = reinterpret_cast<CXExpr>(Results[I]);
  }
  return Failed;
}

CXTemplateParameterList clang_Sema_SubstTemplateParams(
    CXSema S, CXTemplateParameterList Params, CXDeclContext Owner,
    CXMultiLevelTemplateArgumentList TemplateArgs, bool EvaluateConstraints) {
  return reinterpret_cast<CXTemplateParameterList>(reinterpret_cast<clang::Sema *>(S)->SubstTemplateParams(
      reinterpret_cast<clang::TemplateParameterList *>(Params),
      reinterpret_cast<clang::DeclContext *>(Owner),
      extra::unboxMultiLevelTemplateArgumentList(TemplateArgs), EvaluateConstraints));
}

bool clang_Sema_SubstTemplateArguments(CXSema S, const CXTemplateArgumentLoc *Args,
                                       unsigned NumArgs,
                                       CXMultiLevelTemplateArgumentList TemplateArgs,
                                       CXTemplateArgumentListInfo Outputs) {
  llvm::SmallVector<clang::TemplateArgumentLoc, 8> Inputs;
  Inputs.reserve(NumArgs);
  for (unsigned I = 0; I != NumArgs; ++I)
    Inputs.push_back(*reinterpret_cast<clang::TemplateArgumentLoc *>(Args[I]));
  return reinterpret_cast<clang::Sema *>(S)->SubstTemplateArguments(
      Inputs, extra::unboxMultiLevelTemplateArgumentList(TemplateArgs),
      *reinterpret_cast<clang::TemplateArgumentListInfo *>(Outputs));
}

CXDecl clang_Sema_SubstDecl(CXSema S, CXDecl D, CXDeclContext Owner,
                            CXMultiLevelTemplateArgumentList TemplateArgs) {
  return reinterpret_cast<CXDecl>(reinterpret_cast<clang::Sema *>(S)->SubstDecl(
      reinterpret_cast<clang::Decl *>(D), reinterpret_cast<clang::DeclContext *>(Owner),
      extra::unboxMultiLevelTemplateArgumentList(TemplateArgs)));
}

bool clang_Sema_SubstBaseSpecifiers(CXSema S, CXCXXRecordDecl Instantiation,
                                    CXCXXRecordDecl Pattern,
                                    CXMultiLevelTemplateArgumentList TemplateArgs) {
  return reinterpret_cast<clang::Sema *>(S)->SubstBaseSpecifiers(
      reinterpret_cast<clang::CXXRecordDecl *>(Instantiation),
      reinterpret_cast<clang::CXXRecordDecl *>(Pattern),
      extra::unboxMultiLevelTemplateArgumentList(TemplateArgs));
}

CXTemplateName clang_Sema_SubstTemplateName(CXSema S, CXNestedNameSpecifierLoc QualifierLoc,
                                            CXTemplateName Name, CXSourceLocation_ Loc,
                                            CXMultiLevelTemplateArgumentList TemplateArgs) {
  clang::NestedNameSpecifierLoc Qualifier;
  if (QualifierLoc)
    Qualifier = *reinterpret_cast<clang::NestedNameSpecifierLoc *>(QualifierLoc);
  return reinterpret_cast<CXTemplateName>(reinterpret_cast<clang::Sema *>(S)
      ->SubstTemplateName(Qualifier, clang::TemplateName::getFromVoidPointer(Name),
                          clang::SourceLocation::getFromPtrEncoding(Loc),
                          extra::unboxMultiLevelTemplateArgumentList(TemplateArgs))
      .getAsVoidPointer());
}

bool clang_Sema_InstantiateInClassInitializer(
    CXSema S, CXSourceLocation_ PointOfInstantiation, CXFieldDecl Instantiation,
    CXFieldDecl Pattern, CXMultiLevelTemplateArgumentList TemplateArgs) {
  return reinterpret_cast<clang::Sema *>(S)->InstantiateInClassInitializer(
      clang::SourceLocation::getFromPtrEncoding(PointOfInstantiation),
      reinterpret_cast<clang::FieldDecl *>(Instantiation),
      reinterpret_cast<clang::FieldDecl *>(Pattern),
      extra::unboxMultiLevelTemplateArgumentList(TemplateArgs));
}

void clang_Sema_InstantiateAttrs(CXSema S, CXMultiLevelTemplateArgumentList TemplateArgs,
                                 CXDecl Pattern, CXDecl Inst,
                                 CXLocalInstantiationScope OuterMostScope) {
  reinterpret_cast<clang::Sema *>(S)->InstantiateAttrs(
      extra::unboxMultiLevelTemplateArgumentList(TemplateArgs),
      reinterpret_cast<clang::Decl *>(Pattern), reinterpret_cast<clang::Decl *>(Inst), nullptr,
      reinterpret_cast<clang::LocalInstantiationScope *>(OuterMostScope));
}

void clang_Sema_InstantiateAttrsForDecl(CXSema S,
                                        CXMultiLevelTemplateArgumentList TemplateArgs,
                                        CXDecl Pattern, CXDecl Inst,
                                        CXLocalInstantiationScope OuterMostScope) {
  reinterpret_cast<clang::Sema *>(S)->InstantiateAttrsForDecl(
      extra::unboxMultiLevelTemplateArgumentList(TemplateArgs),
      reinterpret_cast<clang::Decl *>(Pattern), reinterpret_cast<clang::Decl *>(Inst), nullptr,
      reinterpret_cast<clang::LocalInstantiationScope *>(OuterMostScope));
}

void clang_Sema_PerformDependentDiagnostics(CXSema S, CXDeclContext Pattern,
                                            CXMultiLevelTemplateArgumentList TemplateArgs) {
  reinterpret_cast<clang::Sema *>(S)->PerformDependentDiagnostics(
      reinterpret_cast<clang::DeclContext *>(Pattern),
      extra::unboxMultiLevelTemplateArgumentList(TemplateArgs));
}
#include "clang/AST/Stmt.h"

bool clang_Sema_hasUncompilableErrorOccurred(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->hasUncompilableErrorOccurred();
}

CXString clang_Sema_getFixItZeroInitializerForType(CXSema S, CXQualType T,
                                                   CXSourceLocation_ Loc) {
  return extra::makeCXString(reinterpret_cast<clang::Sema *>(S)->getFixItZeroInitializerForType(
      clang::QualType::getFromOpaquePtr(T),
      clang::SourceLocation::getFromPtrEncoding(Loc)));
}

CXString clang_Sema_getFixItZeroLiteralForType(CXSema S, CXQualType T,
                                               CXSourceLocation_ Loc) {
  return extra::makeCXString(reinterpret_cast<clang::Sema *>(S)->getFixItZeroLiteralForType(
      clang::QualType::getFromOpaquePtr(T),
      clang::SourceLocation::getFromPtrEncoding(Loc)));
}

CXSourceLocation_ clang_Sema_getLocForEndOfToken(CXSema S, CXSourceLocation_ Loc,
                                                 unsigned Offset) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Sema *>(S)
      ->getLocForEndOfToken(clang::SourceLocation::getFromPtrEncoding(Loc), Offset)
      .getPtrEncoding());
}

CXCanThrowResult clang_Sema_canThrow(CXSema S, CXStmt E) {
  return static_cast<CXCanThrowResult>(
      reinterpret_cast<clang::Sema *>(S)->canThrow(reinterpret_cast<clang::Stmt *>(E)));
}

bool clang_Sema_isVisible(CXSema S, CXNamedDecl D) {
  return reinterpret_cast<clang::Sema *>(S)->isVisible(reinterpret_cast<clang::NamedDecl *>(D));
}

bool clang_Sema_isReachable(CXSema S, CXNamedDecl D) {
  return reinterpret_cast<clang::Sema *>(S)->isReachable(reinterpret_cast<clang::NamedDecl *>(D));
}

bool clang_Sema_hasVisibleMergedDefinition(CXSema S, CXNamedDecl Def) {
  return reinterpret_cast<clang::Sema *>(S)->hasVisibleMergedDefinition(
      reinterpret_cast<clang::NamedDecl *>(Def));
}

bool clang_Sema_isEquivalentInternalLinkageDeclaration(CXSema S, CXNamedDecl A,
                                                       CXNamedDecl B) {
  return reinterpret_cast<clang::Sema *>(S)->isEquivalentInternalLinkageDeclaration(
      reinterpret_cast<clang::NamedDecl *>(A), reinterpret_cast<clang::NamedDecl *>(B));
}

bool clang_Sema_isUsualDeallocationFunction(CXSema S, CXCXXMethodDecl FD) {
  return reinterpret_cast<clang::Sema *>(S)->isUsualDeallocationFunction(
      reinterpret_cast<clang::CXXMethodDecl *>(FD));
}

CXDeclContext clang_Sema_getFunctionLevelDeclContext(CXSema S, bool AllowLambda) {
  return reinterpret_cast<CXDeclContext>(reinterpret_cast<clang::Sema *>(S)->getFunctionLevelDeclContext(AllowLambda));
}

CXFunctionDecl clang_Sema_getCurFunctionDecl(CXSema S, bool AllowLambda) {
  return reinterpret_cast<CXFunctionDecl>(reinterpret_cast<clang::Sema *>(S)->getCurFunctionDecl(AllowLambda));
}

CXNamedDecl clang_Sema_getCurFunctionOrMethodDecl(CXSema S) {
  return reinterpret_cast<CXNamedDecl>(reinterpret_cast<clang::Sema *>(S)->getCurFunctionOrMethodDecl());
}

bool clang_Sema_IsFloatingPointPromotion(CXSema S, CXQualType FromType, CXQualType ToType) {
  return reinterpret_cast<clang::Sema *>(S)->IsFloatingPointPromotion(
      clang::QualType::getFromOpaquePtr(FromType),
      clang::QualType::getFromOpaquePtr(ToType));
}

CXNamespaceDecl clang_Sema_getStdNamespace(CXSema S) {
  return reinterpret_cast<CXNamespaceDecl>(reinterpret_cast<clang::Sema *>(S)->getStdNamespace());
}

CXCXXRecordDecl clang_Sema_getStdBadAlloc(CXSema S) {
  return reinterpret_cast<CXCXXRecordDecl>(reinterpret_cast<clang::Sema *>(S)->getStdBadAlloc());
}

bool clang_Sema_isInitListConstructor(CXSema S, CXFunctionDecl Ctor) {
  return reinterpret_cast<clang::Sema *>(S)->isInitListConstructor(
      reinterpret_cast<clang::FunctionDecl *>(Ctor));
}

bool clang_Sema_isImplicitlyDeleted(CXSema S, CXFunctionDecl FD) {
  return reinterpret_cast<clang::Sema *>(S)->isImplicitlyDeleted(
      reinterpret_cast<clang::FunctionDecl *>(FD));
}

bool clang_Sema_IsDerivedFrom(CXSema S, CXSourceLocation_ Loc, CXQualType Derived,
                              CXQualType Base) {
  return reinterpret_cast<clang::Sema *>(S)->IsDerivedFrom(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      clang::QualType::getFromOpaquePtr(Derived), clang::QualType::getFromOpaquePtr(Base));
}

CXDeclContext clang_Sema_getCurLexicalContext(CXSema S) {
  return reinterpret_cast<CXDeclContext>(reinterpret_cast<clang::Sema *>(S)->getCurLexicalContext());
}
unsigned clang_Sema_LookupConstructors(CXSema S, CXCXXRecordDecl Class, CXNamedDecl *Buf,
                                       unsigned BufSize) {
  clang::DeclContextLookupResult R = reinterpret_cast<clang::Sema *>(S)->LookupConstructors(
      reinterpret_cast<clang::CXXRecordDecl *>(Class));
  unsigned N = 0;
  for (clang::NamedDecl *ND : R) {
    if (Buf) {
      if (N >= BufSize)
        break;
      Buf[N] = reinterpret_cast<CXNamedDecl>(ND);
    }
    ++N;
  }
  return N;
}

CXCXXConstructorDecl clang_Sema_LookupCopyingConstructor(CXSema S, CXCXXRecordDecl Class,
                                                         unsigned Quals) {
  return reinterpret_cast<CXCXXConstructorDecl>(reinterpret_cast<clang::Sema *>(S)->LookupCopyingConstructor(
      reinterpret_cast<clang::CXXRecordDecl *>(Class), Quals));
}

CXCXXMethodDecl clang_Sema_LookupCopyingAssignment(CXSema S, CXCXXRecordDecl Class,
                                                   unsigned Quals, bool RValueThis,
                                                   unsigned ThisQuals) {
  return reinterpret_cast<CXCXXMethodDecl>(reinterpret_cast<clang::Sema *>(S)->LookupCopyingAssignment(
      reinterpret_cast<clang::CXXRecordDecl *>(Class), Quals, RValueThis, ThisQuals));
}

CXCXXConstructorDecl clang_Sema_LookupMovingConstructor(CXSema S, CXCXXRecordDecl Class,
                                                        unsigned Quals) {
  return reinterpret_cast<CXCXXConstructorDecl>(reinterpret_cast<clang::Sema *>(S)->LookupMovingConstructor(
      reinterpret_cast<clang::CXXRecordDecl *>(Class), Quals));
}

CXCXXMethodDecl clang_Sema_LookupMovingAssignment(CXSema S, CXCXXRecordDecl Class,
                                                  unsigned Quals, bool RValueThis,
                                                  unsigned ThisQuals) {
  return reinterpret_cast<CXCXXMethodDecl>(reinterpret_cast<clang::Sema *>(S)->LookupMovingAssignment(
      reinterpret_cast<clang::CXXRecordDecl *>(Class), Quals, RValueThis, ThisQuals));
}

CXCXXMethodDecl clang_Sema_LookupSpecialMember(CXSema S, CXCXXRecordDecl D,
                                               CXCXXSpecialMember SM, bool ConstArg,
                                               bool VolatileArg, bool RValueThis,
                                               bool ConstThis, bool VolatileThis,
                                               CXSpecialMemberOverloadResultKind *Kind) {
  clang::Sema::SpecialMemberOverloadResult R =
      reinterpret_cast<clang::Sema *>(S)->LookupSpecialMember(
          reinterpret_cast<clang::CXXRecordDecl *>(D),
          static_cast<clang::Sema::CXXSpecialMember>(SM), ConstArg, VolatileArg, RValueThis,
          ConstThis, VolatileThis);
  if (Kind)
    *Kind = static_cast<CXSpecialMemberOverloadResultKind>(R.getKind());
  return reinterpret_cast<CXCXXMethodDecl>(R.getMethod());
}

bool clang_Sema_LookupBuiltin(CXSema S, CXLookupResult R) {
  return reinterpret_cast<clang::Sema *>(S)->LookupBuiltin(
      *reinterpret_cast<clang::LookupResult *>(R));
}

namespace {
// Collects what LookupVisibleDecls reports into the caller's buffer, counting only when the
// buffer is absent. Bounding the write is what keeps the protocol safe: the walk declares
// implicit members, so the fill pass can see more decls than the counting pass did.
class VisibleDeclCollector : public clang::VisibleDeclConsumer {
  CXNamedDecl *Buf;
  unsigned BufSize;

public:
  unsigned Count = 0;

  VisibleDeclCollector(CXNamedDecl *Buf, unsigned BufSize) : Buf(Buf), BufSize(BufSize) {}

  void FoundDecl(clang::NamedDecl *ND, clang::NamedDecl *Hiding, clang::DeclContext *Ctx,
                 bool InBaseClass) override {
    if (Buf) {
      if (Count >= BufSize)
        return;
      Buf[Count] = reinterpret_cast<CXNamedDecl>(ND);
    }
    ++Count;
  }
};
} // namespace

CXModule_ clang_Sema_getCurrentModule(CXSema S) {
  return reinterpret_cast<CXModule_>(reinterpret_cast<clang::Sema *>(S)->getCurrentModule());
}

bool clang_Sema_hasStructuralCompatLayout(CXSema S, CXDecl D, CXDecl Suggested) {
  return reinterpret_cast<clang::Sema *>(S)->hasStructuralCompatLayout(
      reinterpret_cast<clang::Decl *>(D), reinterpret_cast<clang::Decl *>(Suggested));
}

CXCXXSpecialMember clang_Sema_getSpecialMember(CXSema S, CXCXXMethodDecl MD) {
  return static_cast<CXCXXSpecialMember>(reinterpret_cast<clang::Sema *>(S)->getSpecialMember(
      reinterpret_cast<clang::CXXMethodDecl *>(MD)));
}

bool clang_Sema_IsOverload(CXSema S, CXFunctionDecl New, CXFunctionDecl Old,
                           bool UseMemberUsingDeclRules, bool ConsiderCudaAttrs) {
  return reinterpret_cast<clang::Sema *>(S)->IsOverload(
      reinterpret_cast<clang::FunctionDecl *>(New), reinterpret_cast<clang::FunctionDecl *>(Old),
      UseMemberUsingDeclRules, ConsiderCudaAttrs);
}

bool clang_Sema_IsOverride(CXSema S, CXFunctionDecl MD, CXFunctionDecl BaseMD,
                           bool UseMemberUsingDeclRules, bool ConsiderCudaAttrs) {
  return reinterpret_cast<clang::Sema *>(S)->IsOverride(
      reinterpret_cast<clang::FunctionDecl *>(MD), reinterpret_cast<clang::FunctionDecl *>(BaseMD),
      UseMemberUsingDeclRules, ConsiderCudaAttrs);
}

bool clang_Sema_IsComplexPromotion(CXSema S, CXQualType FromType, CXQualType ToType) {
  return reinterpret_cast<clang::Sema *>(S)->IsComplexPromotion(
      clang::QualType::getFromOpaquePtr(FromType),
      clang::QualType::getFromOpaquePtr(ToType));
}

bool clang_Sema_isKnownName(CXSema S, const char *Name) {
  return reinterpret_cast<clang::Sema *>(S)->isKnownName(llvm::StringRef(Name));
}

bool clang_Sema_isAcceptableNestedNameSpecifier(CXSema S, CXNamedDecl SD,
                                                bool *CanCorrect) {
  return reinterpret_cast<clang::Sema *>(S)->isAcceptableNestedNameSpecifier(
      reinterpret_cast<clang::NamedDecl *>(SD), CanCorrect);
}

bool clang_Sema_isValidPointerAttrType(CXSema S, CXQualType T, bool RefOkay) {
  return reinterpret_cast<clang::Sema *>(S)->isValidPointerAttrType(
      clang::QualType::getFromOpaquePtr(T), RefOkay);
}

bool clang_Sema_hasExplicitCallingConv(CXSema S, CXQualType T) {
  return reinterpret_cast<clang::Sema *>(S)->hasExplicitCallingConv(
      clang::QualType::getFromOpaquePtr(T));
}

CXAttributedType clang_Sema_getCallingConvAttributedType(CXSema S, CXQualType T) {
  return reinterpret_cast<CXAttributedType>(const_cast<clang::AttributedType *>(
      reinterpret_cast<clang::Sema *>(S)->getCallingConvAttributedType(
          clang::QualType::getFromOpaquePtr(T))));
}

CXQualType clang_Sema_getCurrentThisType(CXSema S) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)->getCurrentThisType().getAsOpaquePtr());
}

bool clang_Sema_isUnexpandedParameterPackPermitted(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->isUnexpandedParameterPackPermitted();
}

bool clang_Sema_inTemplateInstantiation(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->inTemplateInstantiation();
}

bool clang_Sema_isConstantEvaluatedContext(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->isConstantEvaluatedContext();
}

bool clang_Sema_isAlwaysConstantEvaluatedContext(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->isAlwaysConstantEvaluatedContext();
}

bool clang_Sema_isUnevaluatedContext(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->isUnevaluatedContext();
}

bool clang_Sema_isImmediateFunctionContext(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->isImmediateFunctionContext();
}

bool clang_Sema_isCheckingDefaultArgumentOrInitializer(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->isCheckingDefaultArgumentOrInitializer();
}

bool clang_Sema_isPreciseFPEnabled(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->isPreciseFPEnabled();
}

unsigned clang_Sema_LookupVisibleDeclsInContext(
    CXSema S, CXDeclContext Ctx, CXLookupNameKind Kind, bool IncludeGlobalScope,
    bool IncludeDependentBases, bool LoadExternal, CXNamedDecl *Buf, unsigned BufSize) {
  VisibleDeclCollector C(Buf, BufSize);
  reinterpret_cast<clang::Sema *>(S)->LookupVisibleDecls(
      reinterpret_cast<clang::DeclContext *>(Ctx),
      static_cast<clang::Sema::LookupNameKind>(Kind), C, IncludeGlobalScope,
      IncludeDependentBases, LoadExternal);
  return C.Count;
}

bool clang_Sema_RequireNonAbstractType(CXSema S, CXSourceLocation_ Loc, CXQualType T,
                                       unsigned DiagID) {
  return reinterpret_cast<clang::Sema *>(S)->RequireNonAbstractType(
      clang::SourceLocation::getFromPtrEncoding(Loc), clang::QualType::getFromOpaquePtr(T),
      DiagID);
}

bool clang_Sema_RequireStructuralType(CXSema S, CXQualType T, CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::Sema *>(S)->RequireStructuralType(
      clang::QualType::getFromOpaquePtr(T), clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXNamedDecl clang_Sema_findLocallyScopedExternCDecl(CXSema S, CXDeclarationName Name) {
  return reinterpret_cast<CXNamedDecl>(reinterpret_cast<clang::Sema *>(S)->findLocallyScopedExternCDecl(
      clang::DeclarationName::getFromOpaquePtr(Name)));
}

bool clang_Sema_findMacroSpelling(CXSema S, CXSourceLocation_ *Loc, const char *Name) {
  clang::SourceLocation L = clang::SourceLocation::getFromPtrEncoding(*Loc);
  if (!reinterpret_cast<clang::Sema *>(S)->findMacroSpelling(L, llvm::StringRef(Name)))
    return false;
  *Loc = reinterpret_cast<CXSourceLocation_>(L.getPtrEncoding());
  return true;
}

bool clang_Sema_handlerCanCatch(CXSema S, CXQualType HandlerType,
                                CXQualType ExceptionType) {
  return reinterpret_cast<clang::Sema *>(S)->handlerCanCatch(
      clang::QualType::getFromOpaquePtr(HandlerType),
      clang::QualType::getFromOpaquePtr(ExceptionType));
}

bool clang_Sema_currentModuleIsImplementation(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->currentModuleIsImplementation();
}

bool clang_Sema_currentModuleIsHeaderUnit(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->currentModuleIsHeaderUnit();
}

bool clang_Sema_shouldLinkDependentDeclWithPrevious(CXSema S, CXDecl D, CXDecl OldDecl) {
  return reinterpret_cast<clang::Sema *>(S)->shouldLinkDependentDeclWithPrevious(
      reinterpret_cast<clang::Decl *>(D), reinterpret_cast<clang::Decl *>(OldDecl));
}

bool clang_Sema_FunctionParamTypesAreEqual(CXSema S, CXFunctionProtoType OldType,
                                           CXFunctionProtoType NewType, unsigned *ArgPos,
                                           bool Reversed) {
  return reinterpret_cast<clang::Sema *>(S)->FunctionParamTypesAreEqual(
      reinterpret_cast<clang::FunctionProtoType *>(OldType),
      reinterpret_cast<clang::FunctionProtoType *>(NewType), ArgPos, Reversed);
}

bool clang_Sema_FunctionNonObjectParamTypesAreEqual(CXSema S, CXFunctionDecl OldFunction,
                                                    CXFunctionDecl NewFunction,
                                                    unsigned *ArgPos, bool Reversed) {
  return reinterpret_cast<clang::Sema *>(S)->FunctionNonObjectParamTypesAreEqual(
      reinterpret_cast<clang::FunctionDecl *>(OldFunction),
      reinterpret_cast<clang::FunctionDecl *>(NewFunction), ArgPos, Reversed);
}

bool clang_Sema_checkAddressOfFunctionIsAvailable(CXSema S, CXFunctionDecl Function,
                                                  bool Complain, CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::Sema *>(S)->checkAddressOfFunctionIsAvailable(
      reinterpret_cast<clang::FunctionDecl *>(Function), Complain,
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXQualType clang_Sema_ExtractUnqualifiedFunctionType(CXSema S,
                                                     CXQualType PossiblyAFunctionType) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->ExtractUnqualifiedFunctionType(
          clang::QualType::getFromOpaquePtr(PossiblyAFunctionType))
      .getAsOpaquePtr());
}

CXRedeclarationKind clang_Sema_forRedeclarationInCurContext(CXSema S) {
  return static_cast<CXRedeclarationKind>(
      reinterpret_cast<clang::Sema *>(S)->forRedeclarationInCurContext());
}

CXValueDecl clang_Sema_tryLookupUnambiguousFieldDecl(CXSema S, CXRecordDecl ClassDecl,
                                                     CXIdentifierInfo MemberOrBase) {
  return reinterpret_cast<CXValueDecl>(reinterpret_cast<clang::Sema *>(S)->tryLookupUnambiguousFieldDecl(
      reinterpret_cast<clang::RecordDecl *>(ClassDecl),
      reinterpret_cast<clang::IdentifierInfo *>(MemberOrBase)));
}

CXQualType clang_Sema_adjustCCAndNoReturn(CXSema S, CXQualType ArgFunctionType,
                                          CXQualType FunctionType,
                                          bool AdjustExceptionSpec) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->adjustCCAndNoReturn(clang::QualType::getFromOpaquePtr(ArgFunctionType),
                            clang::QualType::getFromOpaquePtr(FunctionType),
                            AdjustExceptionSpec)
      .getAsOpaquePtr());
}

CXCastKind clang_Sema_ScalarTypeToBooleanCastKind(CXQualType ScalarTy) {
  return static_cast<CXCastKind>(clang::Sema::ScalarTypeToBooleanCastKind(
      clang::QualType::getFromOpaquePtr(ScalarTy)));
}

CXExpr clang_Sema_IgnoredValueConversions(CXSema S, CXExpr E, bool *IsInvalid) {
  clang::ExprResult R =
      reinterpret_cast<clang::Sema *>(S)->IgnoredValueConversions(reinterpret_cast<clang::Expr *>(E));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_UsualUnaryConversions(CXSema S, CXExpr E, bool *IsInvalid) {
  clang::ExprResult R =
      reinterpret_cast<clang::Sema *>(S)->UsualUnaryConversions(reinterpret_cast<clang::Expr *>(E));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_DefaultFunctionArrayConversion(CXSema S, CXExpr E, bool Diagnose,
                                                 bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->DefaultFunctionArrayConversion(
      reinterpret_cast<clang::Expr *>(E), Diagnose);
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_DefaultFunctionArrayLvalueConversion(CXSema S, CXExpr E, bool Diagnose,
                                                       bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->DefaultFunctionArrayLvalueConversion(
      reinterpret_cast<clang::Expr *>(E), Diagnose);
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_DefaultLvalueConversion(CXSema S, CXExpr E, bool *IsInvalid) {
  clang::ExprResult R =
      reinterpret_cast<clang::Sema *>(S)->DefaultLvalueConversion(reinterpret_cast<clang::Expr *>(E));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_DefaultArgumentPromotion(CXSema S, CXExpr E, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->DefaultArgumentPromotion(
      reinterpret_cast<clang::Expr *>(E));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXQualType clang_Sema_GetSignedVectorType(CXSema S, CXQualType V) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->GetSignedVectorType(clang::QualType::getFromOpaquePtr(V))
      .getAsOpaquePtr());
}

CXReferenceCompareResult
clang_Sema_CompareReferenceRelationship(CXSema S, CXSourceLocation_ Loc, CXQualType T1,
                                        CXQualType T2, unsigned *Conv) {
  clang::Sema::ReferenceConversions RC = {};
  clang::Sema::ReferenceCompareResult Result =
      reinterpret_cast<clang::Sema *>(S)->CompareReferenceRelationship(
          clang::SourceLocation::getFromPtrEncoding(Loc),
          clang::QualType::getFromOpaquePtr(T1), clang::QualType::getFromOpaquePtr(T2),
          Conv ? &RC : nullptr);
  if (Conv)
    *Conv = static_cast<unsigned>(RC);
  return static_cast<CXReferenceCompareResult>(Result);
}

CXQualType clang_Sema_PreferredConditionType(CXSema S, CXConditionKind K) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->PreferredConditionType(static_cast<clang::Sema::ConditionKind>(K))
      .getAsOpaquePtr());
}

CXFormatStringType clang_Sema_GetFormatStringType(CXFormatAttr Format) {
  return static_cast<CXFormatStringType>(
      clang::Sema::GetFormatStringType(reinterpret_cast<clang::FormatAttr *>(Format)));
}

bool clang_Sema_GetFormatNSStringIdx(CXFormatAttr Format, unsigned *Idx) {
  return clang::Sema::GetFormatNSStringIdx(reinterpret_cast<clang::FormatAttr *>(Format), *Idx);
}

bool clang_Sema_FormatStringHasSArg(CXSema S, CXStringLiteral FExpr) {
  return reinterpret_cast<clang::Sema *>(S)->FormatStringHasSArg(
      reinterpret_cast<clang::StringLiteral *>(FExpr));
}

bool clang_Sema_TooManyArguments(size_t NumParams, size_t NumArgs,
                                 bool PartialOverloading) {
  return clang::Sema::TooManyArguments(NumParams, NumArgs, PartialOverloading);
}

CXExpr clang_Sema_PerformImplicitObjectArgumentInitialization(
    CXSema S, CXExpr From, CXNestedNameSpecifier Qualifier, CXNamedDecl FoundDecl,
    CXCXXMethodDecl Method, bool *IsInvalid) {
  clang::ExprResult R =
      reinterpret_cast<clang::Sema *>(S)->PerformImplicitObjectArgumentInitialization(
          reinterpret_cast<clang::Expr *>(From),
          reinterpret_cast<clang::NestedNameSpecifier *>(Qualifier),
          reinterpret_cast<clang::NamedDecl *>(FoundDecl),
          reinterpret_cast<clang::CXXMethodDecl *>(Method));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_PerformContextuallyConvertToBool(CXSema S, CXExpr From, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->PerformContextuallyConvertToBool(
      reinterpret_cast<clang::Expr *>(From));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_PerformMemberExprBaseConversion(CXSema S, CXExpr Base, bool IsArrow,
                                                  bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->PerformMemberExprBaseConversion(
      reinterpret_cast<clang::Expr *>(Base), IsArrow);
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_PerformObjectMemberConversion(CXSema S, CXExpr From,
                                                CXNestedNameSpecifier Qualifier,
                                                CXNamedDecl FoundDecl, CXNamedDecl Member,
                                                bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->PerformObjectMemberConversion(
      reinterpret_cast<clang::Expr *>(From),
      reinterpret_cast<clang::NestedNameSpecifier *>(Qualifier),
      reinterpret_cast<clang::NamedDecl *>(FoundDecl), reinterpret_cast<clang::NamedDecl *>(Member));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

void clang_Sema_MarkTypoCorrectedFunctionDefinition(CXSema S, CXNamedDecl F) {
  reinterpret_cast<clang::Sema *>(S)->MarkTypoCorrectedFunctionDefinition(
      reinterpret_cast<clang::NamedDecl *>(F));
}

void clang_Sema_MarkDeclRefReferenced(CXSema S, CXDeclRefExpr E, CXExpr Base) {
  reinterpret_cast<clang::Sema *>(S)->MarkDeclRefReferenced(
      reinterpret_cast<clang::DeclRefExpr *>(E), reinterpret_cast<const clang::Expr *>(Base));
}

void clang_Sema_MarkMemberReferenced(CXSema S, CXMemberExpr E) {
  reinterpret_cast<clang::Sema *>(S)->MarkMemberReferenced(reinterpret_cast<clang::MemberExpr *>(E));
}

void clang_Sema_MarkDeclarationsReferencedInExpr(CXSema S, CXExpr E,
                                                 bool SkipLocalVariables,
                                                 const CXExpr *StopAt, unsigned NumStopAt) {
  llvm::SmallVector<const clang::Expr *, 4> Stops;
  Stops.reserve(NumStopAt);
  for (unsigned I = 0; I != NumStopAt; ++I)
    Stops.push_back(reinterpret_cast<const clang::Expr *>(StopAt[I]));
  reinterpret_cast<clang::Sema *>(S)->MarkDeclarationsReferencedInExpr(
      reinterpret_cast<clang::Expr *>(E), SkipLocalVariables, Stops);
}

void clang_Sema_MarkVirtualBaseDestructorsReferenced(CXSema S, CXSourceLocation_ Location,
                                                     CXCXXRecordDecl ClassDecl) {
  reinterpret_cast<clang::Sema *>(S)->MarkVirtualBaseDestructorsReferenced(
      clang::SourceLocation::getFromPtrEncoding(Location),
      reinterpret_cast<clang::CXXRecordDecl *>(ClassDecl));
}

void clang_Sema_MarkUsedTemplateParameters(CXSema S, CXExpr E, bool OnlyDeduced,
                                           unsigned Depth, bool *Used, unsigned N) {
  llvm::SmallBitVector Bits(N);
  reinterpret_cast<clang::Sema *>(S)->MarkUsedTemplateParameters(
      reinterpret_cast<const clang::Expr *>(E), OnlyDeduced, Depth, Bits);
  unsigned Count = static_cast<unsigned>(Bits.size());
  if (N < Count)
    Count = N;
  for (unsigned I = 0; I != Count; ++I)
    Used[I] = Bits[I];
}

CXExpr clang_Sema_PerformImplicitConversion(CXSema S, CXExpr From, CXQualType ToType,
                                            CXAssignmentAction Action, bool AllowExplicit,
                                            bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->PerformImplicitConversion(
      reinterpret_cast<clang::Expr *>(From), clang::QualType::getFromOpaquePtr(ToType),
      static_cast<clang::Sema::AssignmentAction>(Action), AllowExplicit);
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_PerformQualificationConversion(CXSema S, CXExpr E, CXQualType Ty,
                                                 CXExprValueKind VK,
                                                 CXCheckedConversionKind CCK,
                                                 bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->PerformQualificationConversion(
      reinterpret_cast<clang::Expr *>(E), clang::QualType::getFromOpaquePtr(Ty),
      static_cast<clang::ExprValueKind>(VK),
      static_cast<clang::Sema::CheckedConversionKind>(CCK));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

bool clang_Sema_CheckQualifiedFunctionForTypeId(CXSema S, CXQualType T,
                                                CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::Sema *>(S)->CheckQualifiedFunctionForTypeId(
      clang::QualType::getFromOpaquePtr(T), clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_Sema_CheckSpecifiedExceptionType(CXSema S, CXQualType *T,
                                            CXSourceLocation_ Range_begin,
                                            CXSourceLocation_ Range_end) {
  clang::QualType Ty = clang::QualType::getFromOpaquePtr(*T);
  bool Bad = reinterpret_cast<clang::Sema *>(S)->CheckSpecifiedExceptionType(
      Ty, clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Range_begin),
                             clang::SourceLocation::getFromPtrEncoding(Range_end)));
  *T = reinterpret_cast<CXQualType>(Ty.getAsOpaquePtr());
  return Bad;
}

bool clang_Sema_CheckEquivalentExceptionSpec(CXSema S, CXFunctionDecl Old,
                                             CXFunctionDecl New) {
  return reinterpret_cast<clang::Sema *>(S)->CheckEquivalentExceptionSpec(
      reinterpret_cast<clang::FunctionDecl *>(Old), reinterpret_cast<clang::FunctionDecl *>(New));
}

bool clang_Sema_CheckConstexprFunctionDefinition(CXSema S, CXFunctionDecl FD,
                                                 CXCheckConstexprKind Kind) {
  return reinterpret_cast<clang::Sema *>(S)->CheckConstexprFunctionDefinition(
      reinterpret_cast<clang::FunctionDecl *>(FD),
      static_cast<clang::Sema::CheckConstexprKind>(Kind));
}

bool clang_Sema_CheckEnumUnderlyingType(CXSema S, CXTypeSourceInfo TI) {
  return reinterpret_cast<clang::Sema *>(S)->CheckEnumUnderlyingType(
      reinterpret_cast<clang::TypeSourceInfo *>(TI));
}

bool clang_Sema_CheckRedeclarationModuleOwnership(CXSema S, CXNamedDecl New,
                                                  CXNamedDecl Old) {
  return reinterpret_cast<clang::Sema *>(S)->CheckRedeclarationModuleOwnership(
      reinterpret_cast<clang::NamedDecl *>(New), reinterpret_cast<clang::NamedDecl *>(Old));
}

bool clang_Sema_CheckRedeclarationExported(CXSema S, CXNamedDecl New, CXNamedDecl Old) {
  return reinterpret_cast<clang::Sema *>(S)->CheckRedeclarationExported(
      reinterpret_cast<clang::NamedDecl *>(New), reinterpret_cast<clang::NamedDecl *>(Old));
}

bool clang_Sema_CheckRedeclarationInModule(CXSema S, CXNamedDecl New, CXNamedDecl Old) {
  return reinterpret_cast<clang::Sema *>(S)->CheckRedeclarationInModule(
      reinterpret_cast<clang::NamedDecl *>(New), reinterpret_cast<clang::NamedDecl *>(Old));
}

CXExpr clang_Sema_CheckPlaceholderExpr(CXSema S, CXExpr E, bool *IsInvalid) {
  clang::ExprResult R =
      reinterpret_cast<clang::Sema *>(S)->CheckPlaceholderExpr(reinterpret_cast<clang::Expr *>(E));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

bool clang_Sema_CheckAllocatedType(CXSema S, CXQualType AllocType, CXSourceLocation_ Loc,
                                   CXSourceLocation_ R_begin, CXSourceLocation_ R_end) {
  return reinterpret_cast<clang::Sema *>(S)->CheckAllocatedType(
      clang::QualType::getFromOpaquePtr(AllocType),
      clang::SourceLocation::getFromPtrEncoding(Loc),
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(R_begin),
                         clang::SourceLocation::getFromPtrEncoding(R_end)));
}

bool clang_Sema_CheckOverridingFunctionAttributes(CXSema S, CXCXXMethodDecl New,
                                                  CXCXXMethodDecl Old) {
  return reinterpret_cast<clang::Sema *>(S)->CheckOverridingFunctionAttributes(
      reinterpret_cast<clang::CXXMethodDecl *>(New), reinterpret_cast<clang::CXXMethodDecl *>(Old));
}

bool clang_Sema_CheckOverridingFunctionReturnType(CXSema S, CXCXXMethodDecl New,
                                                  CXCXXMethodDecl Old) {
  return reinterpret_cast<clang::Sema *>(S)->CheckOverridingFunctionReturnType(
      reinterpret_cast<clang::CXXMethodDecl *>(New), reinterpret_cast<clang::CXXMethodDecl *>(Old));
}

bool clang_Sema_CheckOverridingFunctionExceptionSpec(CXSema S, CXCXXMethodDecl New,
                                                     CXCXXMethodDecl Old) {
  return reinterpret_cast<clang::Sema *>(S)->CheckOverridingFunctionExceptionSpec(
      reinterpret_cast<clang::CXXMethodDecl *>(New), reinterpret_cast<clang::CXXMethodDecl *>(Old));
}

bool clang_Sema_CheckOverloadedOperatorDeclaration(CXSema S, CXFunctionDecl FnDecl) {
  return reinterpret_cast<clang::Sema *>(S)->CheckOverloadedOperatorDeclaration(
      reinterpret_cast<clang::FunctionDecl *>(FnDecl));
}

bool clang_Sema_CheckLiteralOperatorDeclaration(CXSema S, CXFunctionDecl FnDecl) {
  return reinterpret_cast<clang::Sema *>(S)->CheckLiteralOperatorDeclaration(
      reinterpret_cast<clang::FunctionDecl *>(FnDecl));
}

CXQualType clang_Sema_CheckNonTypeTemplateParameterType(CXSema S, CXQualType T,
                                                        CXSourceLocation_ Loc) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->CheckNonTypeTemplateParameterType(clang::QualType::getFromOpaquePtr(T),
                                          clang::SourceLocation::getFromPtrEncoding(Loc))
      .getAsOpaquePtr());
}

CXAssignConvertType clang_Sema_CheckAssignmentConstraints(CXSema S, CXSourceLocation_ Loc,
                                                          CXQualType LHSType,
                                                          CXQualType RHSType) {
  return static_cast<CXAssignConvertType>(
      reinterpret_cast<clang::Sema *>(S)->CheckAssignmentConstraints(
          clang::SourceLocation::getFromPtrEncoding(Loc),
          clang::QualType::getFromOpaquePtr(LHSType),
          clang::QualType::getFromOpaquePtr(RHSType)));
}

bool clang_Sema_CheckForConstantInitializer(CXSema S, CXExpr E, CXQualType T) {
  return reinterpret_cast<clang::Sema *>(S)->CheckForConstantInitializer(
      reinterpret_cast<clang::Expr *>(E), clang::QualType::getFromOpaquePtr(T));
}

CXExpr clang_Sema_CheckBooleanCondition(CXSema S, CXSourceLocation_ Loc, CXExpr E,
                                        bool IsConstexpr, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->CheckBooleanCondition(
      clang::SourceLocation::getFromPtrEncoding(Loc), reinterpret_cast<clang::Expr *>(E),
      IsConstexpr);
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_VerifyIntegerConstantExpression(CXSema S, CXExpr E,
                                                  CXAllowFoldKind CanFold,
                                                  bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->VerifyIntegerConstantExpression(
      reinterpret_cast<clang::Expr *>(E), static_cast<llvm::APSInt *>(nullptr),
      static_cast<clang::Sema::AllowFoldKind>(CanFold));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

void clang_Sema_FilterAcceptableTemplateNames(CXSema S, CXLookupResult R,
                                              bool AllowFunctionTemplates,
                                              bool AllowDependent) {
  reinterpret_cast<clang::Sema *>(S)->FilterAcceptableTemplateNames(
      *reinterpret_cast<clang::LookupResult *>(R), AllowFunctionTemplates, AllowDependent);
}

void clang_Sema_FilterLookupForScope(CXSema S, CXLookupResult R, CXDeclContext Ctx,
                                     CXScope Sp, bool ConsiderLinkage,
                                     bool AllowInlineNamespace) {
  reinterpret_cast<clang::Sema *>(S)->FilterLookupForScope(
      *reinterpret_cast<clang::LookupResult *>(R), reinterpret_cast<clang::DeclContext *>(Ctx),
      reinterpret_cast<clang::Scope *>(Sp), ConsiderLinkage, AllowInlineNamespace);
}

void clang_Sema_FilterUsingLookup(CXSema S, CXScope Sp, CXLookupResult R) {
  reinterpret_cast<clang::Sema *>(S)->FilterUsingLookup(reinterpret_cast<clang::Scope *>(Sp),
                                                   *reinterpret_cast<clang::LookupResult *>(R));
}

void clang_Sema_setTagNameForLinkagePurposes(CXSema S, CXTagDecl TagFromDeclSpec,
                                             CXTypedefNameDecl NewTD) {
  reinterpret_cast<clang::Sema *>(S)->setTagNameForLinkagePurposes(
      reinterpret_cast<clang::TagDecl *>(TagFromDeclSpec),
      reinterpret_cast<clang::TypedefNameDecl *>(NewTD));
}

void clang_Sema_RegisterTypeTagForDatatype(CXSema S, CXIdentifierInfo ArgumentKind,
                                           uint64_t MagicValue, CXQualType Type,
                                           bool LayoutCompatible, bool MustBeNull) {
  reinterpret_cast<clang::Sema *>(S)->RegisterTypeTagForDatatype(
      reinterpret_cast<const clang::IdentifierInfo *>(ArgumentKind), MagicValue,
      clang::QualType::getFromOpaquePtr(Type), LayoutCompatible, MustBeNull);
}

void clang_Sema_AddCFAuditedAttribute(CXSema S, CXDecl D) {
  reinterpret_cast<clang::Sema *>(S)->AddCFAuditedAttribute(reinterpret_cast<clang::Decl *>(D));
}

void clang_Sema_AddPragmaAttributes(CXSema S, CXScope Sp, CXDecl D) {
  reinterpret_cast<clang::Sema *>(S)->AddPragmaAttributes(reinterpret_cast<clang::Scope *>(Sp),
                                                     reinterpret_cast<clang::Decl *>(D));
}

CXDeclGroupRef clang_Sema_ConvertDeclToDeclGroup(CXSema S, CXDecl D, CXDecl OwnedType) {
  return reinterpret_cast<CXDeclGroupRef>(reinterpret_cast<clang::Sema *>(S)
      ->ConvertDeclToDeclGroup(reinterpret_cast<clang::Decl *>(D),
                               reinterpret_cast<clang::Decl *>(OwnedType))
      .getAsOpaquePtr());
}

CXExpr clang_Sema_ConvertParamDefaultArgument(CXSema S, CXParmVarDecl Param,
                                              CXExpr DefaultArg, CXSourceLocation_ EqualLoc,
                                              bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->ConvertParamDefaultArgument(
      reinterpret_cast<clang::ParmVarDecl *>(Param), reinterpret_cast<clang::Expr *>(DefaultArg),
      clang::SourceLocation::getFromPtrEncoding(EqualLoc));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_ConvertMemberDefaultInitExpression(CXSema S, CXFieldDecl FD,
                                                     CXExpr InitExpr,
                                                     CXSourceLocation_ InitLoc,
                                                     bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->ConvertMemberDefaultInitExpression(
      reinterpret_cast<clang::FieldDecl *>(FD), reinterpret_cast<clang::Expr *>(InitExpr),
      clang::SourceLocation::getFromPtrEncoding(InitLoc));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

bool clang_Sema_TemplateParameterListsAreEqual(CXSema S, CXTemplateParameterList New,
                                               CXTemplateParameterList Old, bool Complain,
                                               CXTemplateParameterListEqualKind Kind,
                                               CXSourceLocation_ TemplateArgLoc) {
  return reinterpret_cast<clang::Sema *>(S)->TemplateParameterListsAreEqual(
      reinterpret_cast<clang::TemplateParameterList *>(New),
      reinterpret_cast<clang::TemplateParameterList *>(Old), Complain,
      static_cast<clang::Sema::TemplateParameterListEqualKind>(Kind),
      clang::SourceLocation::getFromPtrEncoding(TemplateArgLoc));
}

CXTemplateDeductionResult clang_Sema_DeduceTemplateArguments(
    CXSema S, CXClassTemplatePartialSpecializationDecl Partial,
    CXTemplateArgumentList TemplateArgs, CXTemplateDeductionInfo Info) {
  return static_cast<CXTemplateDeductionResult>(
      reinterpret_cast<clang::Sema *>(S)->DeduceTemplateArguments(
          reinterpret_cast<clang::ClassTemplatePartialSpecializationDecl *>(Partial),
          *reinterpret_cast<clang::TemplateArgumentList *>(TemplateArgs),
          *reinterpret_cast<clang::sema::TemplateDeductionInfo *>(Info)));
}

CXTemplateDeductionResult clang_Sema_DeduceAutoType(CXSema S, CXTypeLoc AutoTypeLoc,
                                                    CXExpr Initializer, CXQualType *Result,
                                                    CXTemplateDeductionInfo Info,
                                                    bool DependentDeduction,
                                                    bool IgnoreConstraints) {
  clang::QualType Deduced;
  clang::Sema::TemplateDeductionResult R = reinterpret_cast<clang::Sema *>(S)->DeduceAutoType(
      *reinterpret_cast<clang::TypeLoc *>(AutoTypeLoc), reinterpret_cast<clang::Expr *>(Initializer),
      Deduced, *reinterpret_cast<clang::sema::TemplateDeductionInfo *>(Info), DependentDeduction,
      IgnoreConstraints);
  if (R == clang::Sema::TDK_Success)
    *Result = reinterpret_cast<CXQualType>(Deduced.getAsOpaquePtr());
  return static_cast<CXTemplateDeductionResult>(R);
}

void clang_Sema_TryImplicitConversion(CXSema S, CXExpr From, CXQualType ToType,
                                      bool SuppressUserConversions,
                                      CXAllowedExplicit AllowExplicit,
                                      bool InOverloadResolution, bool CStyle,
                                      bool AllowObjCWritebackConversion,
                                      CXImplicitConversionSequence Out) {
  *reinterpret_cast<clang::ImplicitConversionSequence *>(Out) =
      reinterpret_cast<clang::Sema *>(S)->TryImplicitConversion(
          reinterpret_cast<clang::Expr *>(From), clang::QualType::getFromOpaquePtr(ToType),
          SuppressUserConversions, static_cast<clang::Sema::AllowedExplicit>(AllowExplicit),
          InOverloadResolution, CStyle, AllowObjCWritebackConversion);
}

bool clang_Sema_CheckPointerConversion(CXSema S, CXExpr From, CXQualType ToType,
                                       CXCastKind *Kind, bool IgnoreBaseAccess,
                                       bool Diagnose) {
  clang::CastKind K = clang::CK_Dependent;
  clang::CXXCastPath BasePath;
  bool Failed = reinterpret_cast<clang::Sema *>(S)->CheckPointerConversion(
      reinterpret_cast<clang::Expr *>(From), clang::QualType::getFromOpaquePtr(ToType), K,
      BasePath, IgnoreBaseAccess, Diagnose);
  *Kind = static_cast<CXCastKind>(K);
  return Failed;
}

CXObjCLiteralKind clang_Sema_CheckLiteralKind(CXSema S, CXExpr FromE) {
  return static_cast<CXObjCLiteralKind>(
      reinterpret_cast<clang::Sema *>(S)->CheckLiteralKind(reinterpret_cast<clang::Expr *>(FromE)));
}

CXExpr clang_Sema_CheckUnevaluatedOperand(CXSema S, CXExpr E, bool *IsInvalid) {
  clang::ExprResult R =
      reinterpret_cast<clang::Sema *>(S)->CheckUnevaluatedOperand(reinterpret_cast<clang::Expr *>(E));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_CheckLValueToRValueConversionOperand(CXSema S, CXExpr E,
                                                       bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->CheckLValueToRValueConversionOperand(
      reinterpret_cast<clang::Expr *>(E));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

bool clang_Sema_CheckLoopHintExpr(CXSema S, CXExpr E, CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::Sema *>(S)->CheckLoopHintExpr(
      reinterpret_cast<clang::Expr *>(E), clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_Sema_CheckUnaryExprOrTypeTraitOperand(CXSema S, CXExpr E,
                                                 CXUnaryExprOrTypeTrait ExprKind) {
  return reinterpret_cast<clang::Sema *>(S)->CheckUnaryExprOrTypeTraitOperand(
      reinterpret_cast<clang::Expr *>(E), static_cast<clang::UnaryExprOrTypeTrait>(ExprKind));
}

CXAssignConvertType clang_Sema_CheckSingleAssignmentConstraints(
    CXSema S, CXQualType LHSType, CXExpr RHS, bool Diagnose, bool DiagnoseCFAudited,
    bool ConvertRHS, CXExpr *ConvertedRHS, bool *IsInvalid) {
  clang::ExprResult R(reinterpret_cast<clang::Expr *>(RHS));
  clang::Sema::AssignConvertType Result =
      reinterpret_cast<clang::Sema *>(S)->CheckSingleAssignmentConstraints(
          clang::QualType::getFromOpaquePtr(LHSType), R, Diagnose, DiagnoseCFAudited,
          ConvertRHS);
  *IsInvalid = R.isInvalid();
  *ConvertedRHS = reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
  return static_cast<CXAssignConvertType>(Result);
}

CXAssignConvertType clang_Sema_CheckTransparentUnionArgumentConstraints(
    CXSema S, CXQualType ArgType, CXExpr RHS, CXExpr *ConvertedRHS, bool *IsInvalid) {
  clang::ExprResult R(reinterpret_cast<clang::Expr *>(RHS));
  clang::Sema::AssignConvertType Result =
      reinterpret_cast<clang::Sema *>(S)->CheckTransparentUnionArgumentConstraints(
          clang::QualType::getFromOpaquePtr(ArgType), R);
  *IsInvalid = R.isInvalid();
  *ConvertedRHS = reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
  return static_cast<CXAssignConvertType>(Result);
}

bool clang_Sema_CheckExceptionSpecCompatibility(CXSema S, CXExpr From, CXQualType ToType) {
  return reinterpret_cast<clang::Sema *>(S)->CheckExceptionSpecCompatibility(
      reinterpret_cast<clang::Expr *>(From), clang::QualType::getFromOpaquePtr(ToType));
}

bool clang_Sema_CheckVectorCast(CXSema S, CXSourceLocation_ R_begin,
                                CXSourceLocation_ R_end, CXQualType VectorTy, CXQualType Ty,
                                CXCastKind *Kind) {
  clang::CastKind K = clang::CK_Dependent;
  bool Failed = reinterpret_cast<clang::Sema *>(S)->CheckVectorCast(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(R_begin),
                         clang::SourceLocation::getFromPtrEncoding(R_end)),
      clang::QualType::getFromOpaquePtr(VectorTy), clang::QualType::getFromOpaquePtr(Ty),
      K);
  *Kind = static_cast<CXCastKind>(K);
  return Failed;
}

bool clang_Sema_CheckObjCARCUnavailableWeakConversion(CXSema S, CXQualType CastType,
                                                      CXQualType ExprType) {
  return reinterpret_cast<clang::Sema *>(S)->CheckObjCARCUnavailableWeakConversion(
      clang::QualType::getFromOpaquePtr(CastType),
      clang::QualType::getFromOpaquePtr(ExprType));
}

CXExpr clang_Sema_CheckSwitchCondition(CXSema S, CXSourceLocation_ SwitchLoc, CXExpr Cond,
                                       bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->CheckSwitchCondition(
      clang::SourceLocation::getFromPtrEncoding(SwitchLoc),
      reinterpret_cast<clang::Expr *>(Cond));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_CheckCXXBooleanCondition(CXSema S, CXExpr CondExpr, bool IsConstexpr,
                                           bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->CheckCXXBooleanCondition(
      reinterpret_cast<clang::Expr *>(CondExpr), IsConstexpr);
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_VerifyBitField(CXSema S, CXSourceLocation_ FieldLoc,
                                 CXIdentifierInfo FieldName, CXQualType FieldTy,
                                 bool IsMsStruct, CXExpr BitWidth, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->VerifyBitField(
      clang::SourceLocation::getFromPtrEncoding(FieldLoc),
      reinterpret_cast<clang::IdentifierInfo *>(FieldName),
      clang::QualType::getFromOpaquePtr(FieldTy), IsMsStruct,
      reinterpret_cast<clang::Expr *>(BitWidth));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

// --- Type relationships, module visibility and literal locations -------------

bool clang_Sema_isExternalWithNoLinkageType(CXSema S, CXValueDecl VD) {
  return reinterpret_cast<clang::Sema *>(S)->isExternalWithNoLinkageType(
      reinterpret_cast<clang::ValueDecl *>(VD));
}

bool clang_Sema_hasVisibleDeclaration(CXSema S, CXNamedDecl D) {
  return reinterpret_cast<clang::Sema *>(S)->hasVisibleDeclaration(
      reinterpret_cast<clang::NamedDecl *>(D));
}

bool clang_Sema_hasReachableDeclaration(CXSema S, CXNamedDecl D) {
  return reinterpret_cast<clang::Sema *>(S)->hasReachableDeclaration(
      reinterpret_cast<clang::NamedDecl *>(D));
}

bool clang_Sema_hasVisibleDefinition(CXSema S, CXNamedDecl D, CXNamedDecl *Suggested,
                                     bool OnlyNeedComplete) {
  clang::NamedDecl *Hidden = nullptr;
  bool Found = reinterpret_cast<clang::Sema *>(S)->hasVisibleDefinition(
      reinterpret_cast<clang::NamedDecl *>(D), &Hidden, OnlyNeedComplete);
  *Suggested = reinterpret_cast<CXNamedDecl>(Hidden);
  return Found;
}

bool clang_Sema_hasReachableDefinition(CXSema S, CXNamedDecl D, CXNamedDecl *Suggested) {
  clang::NamedDecl *Hidden = nullptr;
  bool Found = reinterpret_cast<clang::Sema *>(S)->hasReachableDefinition(
      reinterpret_cast<clang::NamedDecl *>(D), &Hidden);
  *Suggested = reinterpret_cast<CXNamedDecl>(Hidden);
  return Found;
}

bool clang_Sema_IsIntegralPromotion(CXSema S, CXExpr From, CXQualType FromType,
                                    CXQualType ToType) {
  return reinterpret_cast<clang::Sema *>(S)->IsIntegralPromotion(
      reinterpret_cast<clang::Expr *>(From), clang::QualType::getFromOpaquePtr(FromType),
      clang::QualType::getFromOpaquePtr(ToType));
}

bool clang_Sema_IsBlockPointerConversion(CXSema S, CXQualType FromType, CXQualType ToType,
                                         CXQualType *ConvertedType) {
  clang::QualType Converted;
  bool Ok = reinterpret_cast<clang::Sema *>(S)->IsBlockPointerConversion(
      clang::QualType::getFromOpaquePtr(FromType),
      clang::QualType::getFromOpaquePtr(ToType), Converted);
  *ConvertedType = reinterpret_cast<CXQualType>(Converted.getAsOpaquePtr());
  return Ok;
}

bool clang_Sema_IsQualificationConversion(CXSema S, CXQualType FromType, CXQualType ToType,
                                          bool CStyle, bool *ObjCLifetimeConversion) {
  bool Lifetime = false;
  bool Ok = reinterpret_cast<clang::Sema *>(S)->IsQualificationConversion(
      clang::QualType::getFromOpaquePtr(FromType),
      clang::QualType::getFromOpaquePtr(ToType), CStyle, Lifetime);
  *ObjCLifetimeConversion = Lifetime;
  return Ok;
}

bool clang_Sema_IsFunctionConversion(CXSema S, CXQualType FromType, CXQualType ToType,
                                     CXQualType *ResultTy) {
  clang::QualType Result;
  bool Ok = reinterpret_cast<clang::Sema *>(S)->IsFunctionConversion(
      clang::QualType::getFromOpaquePtr(FromType),
      clang::QualType::getFromOpaquePtr(ToType), Result);
  *ResultTy = reinterpret_cast<CXQualType>(Result.getAsOpaquePtr());
  return Ok;
}

bool clang_Sema_isSameOrCompatibleFunctionType(CXSema S, CXQualType Param, CXQualType Arg) {
  return reinterpret_cast<clang::Sema *>(S)->isSameOrCompatibleFunctionType(
      clang::QualType::getFromOpaquePtr(Param), clang::QualType::getFromOpaquePtr(Arg));
}

CXSourceRange_ clang_Sema_getExprRange(CXSema S, CXExpr E) {
  clang::SourceRange R =
      reinterpret_cast<clang::Sema *>(S)->getExprRange(reinterpret_cast<clang::Expr *>(E));
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

bool clang_Sema_isStdInitializerList(CXSema S, CXQualType Ty, CXQualType *Element) {
  clang::QualType Elt;
  bool Found = reinterpret_cast<clang::Sema *>(S)->isStdInitializerList(
      clang::QualType::getFromOpaquePtr(Ty), &Elt);
  *Element = reinterpret_cast<CXQualType>(Elt.getAsOpaquePtr());
  return Found;
}

CXNamedDecl clang_Sema_getAsTemplateNameDecl(CXNamedDecl D, bool AllowFunctionTemplates,
                                             bool AllowDependent) {
  return reinterpret_cast<CXNamedDecl>(clang::Sema::getAsTemplateNameDecl(reinterpret_cast<clang::NamedDecl *>(D),
                                            AllowFunctionTemplates, AllowDependent));
}

CXSourceLocation_ clang_Sema_getOptimizeOffPragmaLocation(CXSema S) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Sema *>(S)->getOptimizeOffPragmaLocation().getPtrEncoding());
}

CXVarArgKind clang_Sema_isValidVarArgType(CXSema S, CXQualType Ty) {
  clang::QualType T = clang::QualType::getFromOpaquePtr(Ty);
  return static_cast<CXVarArgKind>(reinterpret_cast<clang::Sema *>(S)->isValidVarArgType(T));
}

bool clang_Sema_hasCStrMethod(CXSema S, CXExpr E) {
  return reinterpret_cast<clang::Sema *>(S)->hasCStrMethod(reinterpret_cast<clang::Expr *>(E));
}

bool clang_Sema_areVectorTypesSameSize(CXSema S, CXQualType SrcType, CXQualType DestType) {
  return reinterpret_cast<clang::Sema *>(S)->areVectorTypesSameSize(
      clang::QualType::getFromOpaquePtr(SrcType),
      clang::QualType::getFromOpaquePtr(DestType));
}

bool clang_Sema_areLaxCompatibleVectorTypes(CXSema S, CXQualType SrcType,
                                            CXQualType DestType) {
  return reinterpret_cast<clang::Sema *>(S)->areLaxCompatibleVectorTypes(
      clang::QualType::getFromOpaquePtr(SrcType),
      clang::QualType::getFromOpaquePtr(DestType));
}

bool clang_Sema_isLaxVectorConversion(CXSema S, CXQualType SrcType, CXQualType DestType) {
  return reinterpret_cast<clang::Sema *>(S)->isLaxVectorConversion(
      clang::QualType::getFromOpaquePtr(SrcType),
      clang::QualType::getFromOpaquePtr(DestType));
}

CXSourceLocation_ clang_Sema_getLocationOfStringLiteralByte(CXSema S, CXStringLiteral SL,
                                                            unsigned ByteNo) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Sema *>(S)
      ->getLocationOfStringLiteralByte(reinterpret_cast<clang::StringLiteral *>(SL), ByteNo)
      .getPtrEncoding());
}

unsigned clang_Sema_getNumWeakTopLevelDecls(CXSema S) {
  return static_cast<unsigned>(reinterpret_cast<clang::Sema *>(S)->WeakTopLevelDecls().size());
}

CXDecl clang_Sema_getWeakTopLevelDecl(CXSema S, unsigned I) {
  return reinterpret_cast<CXDecl>(reinterpret_cast<clang::Sema *>(S)->WeakTopLevelDecls()[I]);
}

CXIdentifierInfo
clang_Sema_InventAbbreviatedTemplateParameterTypeName(CXSema S, CXIdentifierInfo ParamName,
                                                      unsigned Index) {
  return reinterpret_cast<CXIdentifierInfo>(reinterpret_cast<clang::Sema *>(S)->InventAbbreviatedTemplateParameterTypeName(
      reinterpret_cast<clang::IdentifierInfo *>(ParamName), Index));
}

bool clang_Sema_mightBeIntendedToBeTemplateName(CXSema S, CXExpr E, bool *Dependent) {
  return reinterpret_cast<clang::Sema *>(S)->mightBeIntendedToBeTemplateName(
      reinterpret_cast<clang::Expr *>(E), *Dependent);
}

bool clang_Sema_adjustContextForLocalExternDecl(CXDeclContext *DC) {
  clang::DeclContext *Ctx = reinterpret_cast<clang::DeclContext *>(*DC);
  bool Adjusted = clang::Sema::adjustContextForLocalExternDecl(Ctx);
  *DC = reinterpret_cast<CXDeclContext>(Ctx);
  return Adjusted;
}

bool clang_Sema_NeedToCaptureVariable(CXSema S, CXValueDecl Var, CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::Sema *>(S)->NeedToCaptureVariable(
      reinterpret_cast<clang::ValueDecl *>(Var), clang::SourceLocation::getFromPtrEncoding(Loc));
}

bool clang_Sema_UseArgumentDependentLookup(CXSema S, CXCXXScopeSpec SS, CXLookupResult R,
                                           bool HasTrailingLParen) {
  return reinterpret_cast<clang::Sema *>(S)->UseArgumentDependentLookup(
      *reinterpret_cast<clang::CXXScopeSpec *>(SS), *reinterpret_cast<clang::LookupResult *>(R),
      HasTrailingLParen);
}

unsigned clang_Sema_LookupBinOp(CXSema S, CXScope Sc, CXSourceLocation_ OpLoc,
                                CXBinaryOperatorKind Opc, CXNamedDecl *Buf,
                                unsigned BufSize) {
  clang::UnresolvedSet<8> Functions;
  reinterpret_cast<clang::Sema *>(S)->LookupBinOp(
      reinterpret_cast<clang::Scope *>(Sc), clang::SourceLocation::getFromPtrEncoding(OpLoc),
      static_cast<clang::BinaryOperatorKind>(Opc), Functions);
  unsigned N = 0;
  for (clang::NamedDecl *ND : Functions) {
    if (Buf) {
      if (N >= BufSize)
        break;
      Buf[N] = reinterpret_cast<CXNamedDecl>(ND);
    }
    ++N;
  }
  return N;
}

uint64_t clang_Sema_CurFPFeatureOverrides(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->CurFPFeatureOverrides().getAsOpaqueInt();
}

bool clang_Sema_anyAltivecTypes(CXSema S, CXQualType SrcType, CXQualType DestType) {
  return reinterpret_cast<clang::Sema *>(S)->anyAltivecTypes(
      clang::QualType::getFromOpaquePtr(SrcType),
      clang::QualType::getFromOpaquePtr(DestType));
}

CXExpr clang_Sema_CallExprUnaryConversions(CXSema S, CXExpr E, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->CallExprUnaryConversions(
      reinterpret_cast<clang::Expr *>(E));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_TemporaryMaterializationConversion(CXSema S, CXExpr E, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->TemporaryMaterializationConversion(
      reinterpret_cast<clang::Expr *>(E));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_DefaultVariadicArgumentPromotion(CXSema S, CXExpr E,
                                                   CXVariadicCallType CT,
                                                   CXFunctionDecl FDecl, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->DefaultVariadicArgumentPromotion(
      reinterpret_cast<clang::Expr *>(E), static_cast<clang::Sema::VariadicCallType>(CT),
      reinterpret_cast<clang::FunctionDecl *>(FDecl));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXQualType clang_Sema_UsualArithmeticConversions(CXSema S, CXExpr LHS, CXExpr RHS,
                                                 CXSourceLocation_ Loc, CXArithConvKind ACK,
                                                 CXExpr *LHSOut, CXExpr *RHSOut) {
  clang::ExprResult L = reinterpret_cast<clang::Expr *>(LHS);
  clang::ExprResult R = reinterpret_cast<clang::Expr *>(RHS);
  clang::QualType T = reinterpret_cast<clang::Sema *>(S)->UsualArithmeticConversions(
      L, R, clang::SourceLocation::getFromPtrEncoding(Loc),
      static_cast<clang::Sema::ArithConvKind>(ACK));
  *LHSOut = reinterpret_cast<CXExpr>(L.isInvalid() ? nullptr : L.get());
  *RHSOut = reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

CXExpr clang_Sema_prepareVectorSplat(CXSema S, CXQualType VectorTy, CXExpr SplattedExpr,
                                     bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->prepareVectorSplat(
      clang::QualType::getFromOpaquePtr(VectorTy),
      reinterpret_cast<clang::Expr *>(SplattedExpr));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

bool clang_Sema_SpecialMemberIsTrivial(CXSema S, CXCXXMethodDecl MD, CXCXXSpecialMember CSM,
                                       CXTrivialABIHandling TAH, bool Diagnose) {
  return reinterpret_cast<clang::Sema *>(S)->SpecialMemberIsTrivial(
      reinterpret_cast<clang::CXXMethodDecl *>(MD),
      static_cast<clang::Sema::CXXSpecialMember>(CSM),
      static_cast<clang::Sema::TrivialABIHandling>(TAH), Diagnose);
}

namespace {
// Rebuild the ArrayRef<Expr *> clang's candidate collectors take from the (handle, count)
// pair the C surface carries (MARSHALLING.md section 11).
llvm::SmallVector<clang::Expr *, 8> makeExprArgs(const CXExpr *Args, unsigned NumArgs) {
  llvm::SmallVector<clang::Expr *, 8> Out;
  Out.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    Out.push_back(reinterpret_cast<clang::Expr *>(Args[I]));
  return Out;
}

// Rebuild the UnresolvedSetImpl those same collectors take from the parallel
// (declaration, access) component arrays: UnresolvedSetIterator's constructors are
// private, so a local set is the only way to mint the [begin, end) pair. clang copies the
// DeclAccessPairs it keeps, so the set need not outlive the call.
void fillUnresolvedSet(clang::UnresolvedSet<8> &Set, const CXNamedDecl *Decls,
                       const CXAccessSpecifier *Accesses, unsigned NumDecls) {
  for (unsigned I = 0; I < NumDecls; ++I)
    Set.addDecl(reinterpret_cast<clang::NamedDecl *>(Decls[I]),
                static_cast<clang::AccessSpecifier>(Accesses[I]));
}
} // namespace

unsigned clang_Sema_FindHiddenVirtualMethods(CXSema S, CXCXXMethodDecl MD,
                                             CXCXXMethodDecl *Buf, unsigned BufSize) {
  llvm::SmallVector<clang::CXXMethodDecl *, 8> Found;
  reinterpret_cast<clang::Sema *>(S)->FindHiddenVirtualMethods(
      reinterpret_cast<clang::CXXMethodDecl *>(MD), Found);
  if (Buf)
    for (unsigned I = 0; I < BufSize && I < Found.size(); ++I)
      Buf[I] = reinterpret_cast<CXCXXMethodDecl>(Found[I]);
  return static_cast<unsigned>(Found.size());
}

void clang_Sema_AddOverloadCandidate(CXSema S, CXFunctionDecl Function,
                                     CXNamedDecl FoundDecl, CXAccessSpecifier FoundAccess,
                                     const CXExpr *Args, unsigned NumArgs,
                                     CXOverloadCandidateSet CandidateSet,
                                     bool SuppressUserConversions, bool PartialOverloading,
                                     bool AllowExplicit, bool AllowExplicitConversion,
                                     bool IsADLCandidate, bool Reversed,
                                     bool AggregateCandidateDeduction) {
  llvm::SmallVector<clang::Expr *, 8> As = makeExprArgs(Args, NumArgs);
  reinterpret_cast<clang::Sema *>(S)->AddOverloadCandidate(
      reinterpret_cast<clang::FunctionDecl *>(Function),
      clang::DeclAccessPair::make(reinterpret_cast<clang::NamedDecl *>(FoundDecl),
                                  static_cast<clang::AccessSpecifier>(FoundAccess)),
      As, *reinterpret_cast<clang::OverloadCandidateSet *>(CandidateSet),
      SuppressUserConversions, PartialOverloading, AllowExplicit, AllowExplicitConversion,
      IsADLCandidate ? clang::CallExpr::UsesADL : clang::CallExpr::NotADL,
      clang::ConversionSequenceList(),
      Reversed ? clang::OverloadCandidateParamOrder::Reversed
               : clang::OverloadCandidateParamOrder::Normal,
      AggregateCandidateDeduction);
}

void clang_Sema_AddFunctionCandidates(CXSema S, const CXNamedDecl *Functions,
                                      const CXAccessSpecifier *Accesses,
                                      unsigned NumFunctions, const CXExpr *Args,
                                      unsigned NumArgs, CXOverloadCandidateSet CandidateSet,
                                      CXTemplateArgumentListInfo ExplicitTemplateArgs,
                                      bool SuppressUserConversions, bool PartialOverloading,
                                      bool FirstArgumentIsBase) {
  clang::UnresolvedSet<8> Fns;
  fillUnresolvedSet(Fns, Functions, Accesses, NumFunctions);
  llvm::SmallVector<clang::Expr *, 8> As = makeExprArgs(Args, NumArgs);
  reinterpret_cast<clang::Sema *>(S)->AddFunctionCandidates(
      Fns, As, *reinterpret_cast<clang::OverloadCandidateSet *>(CandidateSet),
      reinterpret_cast<clang::TemplateArgumentListInfo *>(ExplicitTemplateArgs),
      SuppressUserConversions, PartialOverloading, FirstArgumentIsBase);
}

void clang_Sema_AddMethodCandidate(CXSema S, CXCXXMethodDecl Method, CXNamedDecl FoundDecl,
                                   CXAccessSpecifier FoundAccess,
                                   CXCXXRecordDecl ActingContext, CXExpr Object,
                                   const CXExpr *Args, unsigned NumArgs,
                                   CXOverloadCandidateSet CandidateSet,
                                   bool SuppressUserConversions, bool PartialOverloading,
                                   bool Reversed) {
  clang::Sema *Sm = reinterpret_cast<clang::Sema *>(S);
  clang::Expr *Obj = reinterpret_cast<clang::Expr *>(Object);
  llvm::SmallVector<clang::Expr *, 8> As = makeExprArgs(Args, NumArgs);
  Sm->AddMethodCandidate(
      reinterpret_cast<clang::CXXMethodDecl *>(Method),
      clang::DeclAccessPair::make(reinterpret_cast<clang::NamedDecl *>(FoundDecl),
                                  static_cast<clang::AccessSpecifier>(FoundAccess)),
      reinterpret_cast<clang::CXXRecordDecl *>(ActingContext), Obj->getType(),
      Obj->Classify(Sm->getASTContext()), As,
      *reinterpret_cast<clang::OverloadCandidateSet *>(CandidateSet), SuppressUserConversions,
      PartialOverloading, clang::ConversionSequenceList(),
      Reversed ? clang::OverloadCandidateParamOrder::Reversed
               : clang::OverloadCandidateParamOrder::Normal);
}

void clang_Sema_AddTemplateOverloadCandidate(
    CXSema S, CXFunctionTemplateDecl FunctionTemplate, CXNamedDecl FoundDecl,
    CXAccessSpecifier FoundAccess, CXTemplateArgumentListInfo ExplicitTemplateArgs,
    const CXExpr *Args, unsigned NumArgs, CXOverloadCandidateSet CandidateSet,
    bool SuppressUserConversions, bool PartialOverloading, bool AllowExplicit,
    bool IsADLCandidate, bool Reversed, bool AggregateCandidateDeduction) {
  llvm::SmallVector<clang::Expr *, 8> As = makeExprArgs(Args, NumArgs);
  reinterpret_cast<clang::Sema *>(S)->AddTemplateOverloadCandidate(
      reinterpret_cast<clang::FunctionTemplateDecl *>(FunctionTemplate),
      clang::DeclAccessPair::make(reinterpret_cast<clang::NamedDecl *>(FoundDecl),
                                  static_cast<clang::AccessSpecifier>(FoundAccess)),
      reinterpret_cast<clang::TemplateArgumentListInfo *>(ExplicitTemplateArgs), As,
      *reinterpret_cast<clang::OverloadCandidateSet *>(CandidateSet), SuppressUserConversions,
      PartialOverloading, AllowExplicit,
      IsADLCandidate ? clang::CallExpr::UsesADL : clang::CallExpr::NotADL,
      Reversed ? clang::OverloadCandidateParamOrder::Reversed
               : clang::OverloadCandidateParamOrder::Normal,
      AggregateCandidateDeduction);
}

void clang_Sema_AddMemberOperatorCandidates(CXSema S, CXOverloadedOperatorKind Op,
                                            CXSourceLocation_ OpLoc, const CXExpr *Args,
                                            unsigned NumArgs,
                                            CXOverloadCandidateSet CandidateSet,
                                            bool Reversed) {
  llvm::SmallVector<clang::Expr *, 8> As = makeExprArgs(Args, NumArgs);
  reinterpret_cast<clang::Sema *>(S)->AddMemberOperatorCandidates(
      static_cast<clang::OverloadedOperatorKind>(Op),
      clang::SourceLocation::getFromPtrEncoding(OpLoc), As,
      *reinterpret_cast<clang::OverloadCandidateSet *>(CandidateSet),
      Reversed ? clang::OverloadCandidateParamOrder::Reversed
               : clang::OverloadCandidateParamOrder::Normal);
}

void clang_Sema_AddBuiltinCandidate(CXSema S, const CXQualType *ParamTys,
                                    const CXExpr *Args, unsigned NumArgs,
                                    CXOverloadCandidateSet CandidateSet,
                                    bool IsAssignmentOperator,
                                    unsigned NumContextualBoolArguments) {
  llvm::SmallVector<clang::QualType, 4> Ps;
  Ps.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    Ps.push_back(clang::QualType::getFromOpaquePtr(ParamTys[I]));
  llvm::SmallVector<clang::Expr *, 8> As = makeExprArgs(Args, NumArgs);
  reinterpret_cast<clang::Sema *>(S)->AddBuiltinCandidate(
      Ps.data(), As, *reinterpret_cast<clang::OverloadCandidateSet *>(CandidateSet),
      IsAssignmentOperator, NumContextualBoolArguments);
}

void clang_Sema_AddBuiltinOperatorCandidates(CXSema S, CXOverloadedOperatorKind Op,
                                             CXSourceLocation_ OpLoc, const CXExpr *Args,
                                             unsigned NumArgs,
                                             CXOverloadCandidateSet CandidateSet) {
  llvm::SmallVector<clang::Expr *, 8> As = makeExprArgs(Args, NumArgs);
  reinterpret_cast<clang::Sema *>(S)->AddBuiltinOperatorCandidates(
      static_cast<clang::OverloadedOperatorKind>(Op),
      clang::SourceLocation::getFromPtrEncoding(OpLoc), As,
      *reinterpret_cast<clang::OverloadCandidateSet *>(CandidateSet));
}

void clang_Sema_AddArgumentDependentLookupCandidates(
    CXSema S, CXDeclarationName Name, CXSourceLocation_ Loc, const CXExpr *Args,
    unsigned NumArgs, CXTemplateArgumentListInfo ExplicitTemplateArgs,
    CXOverloadCandidateSet CandidateSet, bool PartialOverloading) {
  llvm::SmallVector<clang::Expr *, 8> As = makeExprArgs(Args, NumArgs);
  reinterpret_cast<clang::Sema *>(S)->AddArgumentDependentLookupCandidates(
      clang::DeclarationName::getFromOpaquePtr(Name),
      clang::SourceLocation::getFromPtrEncoding(Loc), As,
      reinterpret_cast<clang::TemplateArgumentListInfo *>(ExplicitTemplateArgs),
      *reinterpret_cast<clang::OverloadCandidateSet *>(CandidateSet), PartialOverloading);
}

void clang_Sema_AddMethodTemplateCandidate(
    CXSema S, CXFunctionTemplateDecl MethodTmpl, CXNamedDecl FoundDecl,
    CXAccessSpecifier FoundAccess, CXCXXRecordDecl ActingContext,
    CXTemplateArgumentListInfo ExplicitTemplateArgs, CXExpr Object, const CXExpr *Args,
    unsigned NumArgs, CXOverloadCandidateSet CandidateSet, bool SuppressUserConversions,
    bool PartialOverloading, bool Reversed) {
  clang::Sema *Sm = reinterpret_cast<clang::Sema *>(S);
  clang::Expr *Obj = reinterpret_cast<clang::Expr *>(Object);
  llvm::SmallVector<clang::Expr *, 8> As = makeExprArgs(Args, NumArgs);
  Sm->AddMethodTemplateCandidate(
      reinterpret_cast<clang::FunctionTemplateDecl *>(MethodTmpl),
      clang::DeclAccessPair::make(reinterpret_cast<clang::NamedDecl *>(FoundDecl),
                                  static_cast<clang::AccessSpecifier>(FoundAccess)),
      reinterpret_cast<clang::CXXRecordDecl *>(ActingContext),
      reinterpret_cast<clang::TemplateArgumentListInfo *>(ExplicitTemplateArgs), Obj->getType(),
      Obj->Classify(Sm->getASTContext()), As,
      *reinterpret_cast<clang::OverloadCandidateSet *>(CandidateSet), SuppressUserConversions,
      PartialOverloading,
      Reversed ? clang::OverloadCandidateParamOrder::Reversed
               : clang::OverloadCandidateParamOrder::Normal);
}

void clang_Sema_AddConversionCandidate(CXSema S, CXCXXConversionDecl Conversion,
                                       CXNamedDecl FoundDecl, CXAccessSpecifier FoundAccess,
                                       CXCXXRecordDecl ActingContext, CXExpr From,
                                       CXQualType ToType,
                                       CXOverloadCandidateSet CandidateSet,
                                       bool AllowObjCConversionOnExplicit,
                                       bool AllowExplicit, bool AllowResultConversion) {
  reinterpret_cast<clang::Sema *>(S)->AddConversionCandidate(
      reinterpret_cast<clang::CXXConversionDecl *>(Conversion),
      clang::DeclAccessPair::make(reinterpret_cast<clang::NamedDecl *>(FoundDecl),
                                  static_cast<clang::AccessSpecifier>(FoundAccess)),
      reinterpret_cast<clang::CXXRecordDecl *>(ActingContext), reinterpret_cast<clang::Expr *>(From),
      clang::QualType::getFromOpaquePtr(ToType),
      *reinterpret_cast<clang::OverloadCandidateSet *>(CandidateSet),
      AllowObjCConversionOnExplicit, AllowExplicit, AllowResultConversion);
}

void clang_Sema_AddTemplateConversionCandidate(
    CXSema S, CXFunctionTemplateDecl FunctionTemplate, CXNamedDecl FoundDecl,
    CXAccessSpecifier FoundAccess, CXCXXRecordDecl ActingContext, CXExpr From,
    CXQualType ToType, CXOverloadCandidateSet CandidateSet,
    bool AllowObjCConversionOnExplicit, bool AllowExplicit, bool AllowResultConversion) {
  reinterpret_cast<clang::Sema *>(S)->AddTemplateConversionCandidate(
      reinterpret_cast<clang::FunctionTemplateDecl *>(FunctionTemplate),
      clang::DeclAccessPair::make(reinterpret_cast<clang::NamedDecl *>(FoundDecl),
                                  static_cast<clang::AccessSpecifier>(FoundAccess)),
      reinterpret_cast<clang::CXXRecordDecl *>(ActingContext), reinterpret_cast<clang::Expr *>(From),
      clang::QualType::getFromOpaquePtr(ToType),
      *reinterpret_cast<clang::OverloadCandidateSet *>(CandidateSet),
      AllowObjCConversionOnExplicit, AllowExplicit, AllowResultConversion);
}

void clang_Sema_AddSurrogateCandidate(CXSema S, CXCXXConversionDecl Conversion,
                                      CXNamedDecl FoundDecl, CXAccessSpecifier FoundAccess,
                                      CXCXXRecordDecl ActingContext,
                                      CXFunctionProtoType Proto, CXExpr Object,
                                      const CXExpr *Args, unsigned NumArgs,
                                      CXOverloadCandidateSet CandidateSet) {
  llvm::SmallVector<clang::Expr *, 8> As = makeExprArgs(Args, NumArgs);
  reinterpret_cast<clang::Sema *>(S)->AddSurrogateCandidate(
      reinterpret_cast<clang::CXXConversionDecl *>(Conversion),
      clang::DeclAccessPair::make(reinterpret_cast<clang::NamedDecl *>(FoundDecl),
                                  static_cast<clang::AccessSpecifier>(FoundAccess)),
      reinterpret_cast<clang::CXXRecordDecl *>(ActingContext),
      reinterpret_cast<clang::FunctionProtoType *>(Proto), reinterpret_cast<clang::Expr *>(Object),
      As, *reinterpret_cast<clang::OverloadCandidateSet *>(CandidateSet));
}

void clang_Sema_AddNonMemberOperatorCandidates(
    CXSema S, const CXNamedDecl *Functions, const CXAccessSpecifier *Accesses,
    unsigned NumFunctions, const CXExpr *Args, unsigned NumArgs,
    CXOverloadCandidateSet CandidateSet, CXTemplateArgumentListInfo ExplicitTemplateArgs) {
  clang::UnresolvedSet<8> Fns;
  fillUnresolvedSet(Fns, Functions, Accesses, NumFunctions);
  llvm::SmallVector<clang::Expr *, 8> As = makeExprArgs(Args, NumArgs);
  reinterpret_cast<clang::Sema *>(S)->AddNonMemberOperatorCandidates(
      Fns, As, *reinterpret_cast<clang::OverloadCandidateSet *>(CandidateSet),
      reinterpret_cast<clang::TemplateArgumentListInfo *>(ExplicitTemplateArgs));
}

CXFunctionDecl clang_Sema_ResolveAddressOfOverloadedFunction(
    CXSema S, CXExpr AddressOfExpr, CXQualType TargetType, bool Complain,
    CXNamedDecl *FoundDecl, CXAccessSpecifier *FoundAccess, bool *HadMultipleCandidates) {
  clang::DeclAccessPair Found = clang::DeclAccessPair::make(nullptr, clang::AS_none);
  bool Multiple = false;
  clang::FunctionDecl *FD =
      reinterpret_cast<clang::Sema *>(S)->ResolveAddressOfOverloadedFunction(
          reinterpret_cast<clang::Expr *>(AddressOfExpr),
          clang::QualType::getFromOpaquePtr(TargetType), Complain, Found, &Multiple);
  *FoundDecl = reinterpret_cast<CXNamedDecl>(Found.getDecl());
  *FoundAccess = static_cast<CXAccessSpecifier>(Found.getAccess());
  if (HadMultipleCandidates)
    *HadMultipleCandidates = Multiple;
  return reinterpret_cast<CXFunctionDecl>(FD);
}

void clang_Sema_AddOverloadedCallCandidates(CXSema S, CXUnresolvedLookupExpr ULE,
                                            const CXExpr *Args, unsigned NumArgs,
                                            CXOverloadCandidateSet CandidateSet,
                                            bool PartialOverloading) {
  llvm::SmallVector<clang::Expr *, 8> As = makeExprArgs(Args, NumArgs);
  reinterpret_cast<clang::Sema *>(S)->AddOverloadedCallCandidates(
      reinterpret_cast<clang::UnresolvedLookupExpr *>(ULE), As,
      *reinterpret_cast<clang::OverloadCandidateSet *>(CandidateSet), PartialOverloading);
}

void clang_Sema_AddOverloadedCallCandidatesWithLookupResult(
    CXSema S, CXLookupResult R, CXTemplateArgumentListInfo ExplicitTemplateArgs,
    const CXExpr *Args, unsigned NumArgs, CXOverloadCandidateSet CandidateSet) {
  llvm::SmallVector<clang::Expr *, 8> As = makeExprArgs(Args, NumArgs);
  reinterpret_cast<clang::Sema *>(S)->AddOverloadedCallCandidates(
      *reinterpret_cast<clang::LookupResult *>(R),
      reinterpret_cast<clang::TemplateArgumentListInfo *>(ExplicitTemplateArgs), As,
      *reinterpret_cast<clang::OverloadCandidateSet *>(CandidateSet));
}

void clang_Sema_FindAssociatedClassesAndNamespaces(
    CXSema S, CXSourceLocation_ InstantiationLoc, const CXExpr *Args, unsigned NumArgs,
    CXDeclContext *NamespaceBuf, unsigned NamespaceBufSize, unsigned *NumNamespaces,
    CXCXXRecordDecl *ClassBuf, unsigned ClassBufSize, unsigned *NumClasses) {
  llvm::SmallVector<clang::Expr *, 8> As = makeExprArgs(Args, NumArgs);
  clang::Sema::AssociatedNamespaceSet Namespaces;
  clang::Sema::AssociatedClassSet Classes;
  reinterpret_cast<clang::Sema *>(S)->FindAssociatedClassesAndNamespaces(
      clang::SourceLocation::getFromPtrEncoding(InstantiationLoc), As, Namespaces, Classes);
  if (NamespaceBuf) {
    unsigned I = 0;
    for (clang::DeclContext *DC : Namespaces) {
      if (I >= NamespaceBufSize)
        break;
      NamespaceBuf[I++] = reinterpret_cast<CXDeclContext>(DC);
    }
  }
  if (ClassBuf) {
    unsigned I = 0;
    for (clang::CXXRecordDecl *RD : Classes) {
      if (I >= ClassBufSize)
        break;
      ClassBuf[I++] = reinterpret_cast<CXCXXRecordDecl>(RD);
    }
  }
  *NumNamespaces = static_cast<unsigned>(Namespaces.size());
  *NumClasses = static_cast<unsigned>(Classes.size());
}

bool clang_Sema_CompleteConstructorCall(CXSema S, CXCXXConstructorDecl Constructor,
                                        CXQualType DeclInitType, const CXExpr *Args,
                                        unsigned NumArgs, CXSourceLocation_ Loc,
                                        CXExpr *ConvertedArgs, unsigned ConvertedArgsSize,
                                        unsigned *NumConvertedArgs, bool AllowExplicit,
                                        bool IsListInitialization) {
  llvm::SmallVector<clang::Expr *, 8> As = makeExprArgs(Args, NumArgs);
  llvm::SmallVector<clang::Expr *, 8> Converted;
  bool Invalid = reinterpret_cast<clang::Sema *>(S)->CompleteConstructorCall(
      reinterpret_cast<clang::CXXConstructorDecl *>(Constructor),
      clang::QualType::getFromOpaquePtr(DeclInitType), As,
      clang::SourceLocation::getFromPtrEncoding(Loc), Converted, AllowExplicit,
      IsListInitialization);
  if (ConvertedArgs)
    for (unsigned I = 0; I < ConvertedArgsSize && I < Converted.size(); ++I)
      ConvertedArgs[I] = reinterpret_cast<CXExpr>(Converted[I]);
  *NumConvertedArgs = static_cast<unsigned>(Converted.size());
  return Invalid;
}

bool clang_Sema_GatherArgumentsForCall(CXSema S, CXSourceLocation_ CallLoc,
                                       CXFunctionDecl FDecl, CXFunctionProtoType Proto,
                                       unsigned FirstParam, const CXExpr *Args,
                                       unsigned NumArgs, CXExpr *AllArgs,
                                       unsigned AllArgsSize, unsigned *NumAllArgs,
                                       CXVariadicCallType CallType, bool AllowExplicit,
                                       bool IsListInitialization) {
  llvm::SmallVector<clang::Expr *, 8> As = makeExprArgs(Args, NumArgs);
  llvm::SmallVector<clang::Expr *, 8> Gathered;
  bool Invalid = reinterpret_cast<clang::Sema *>(S)->GatherArgumentsForCall(
      clang::SourceLocation::getFromPtrEncoding(CallLoc),
      reinterpret_cast<clang::FunctionDecl *>(FDecl),
      reinterpret_cast<clang::FunctionProtoType *>(Proto), FirstParam, As, Gathered,
      static_cast<clang::Sema::VariadicCallType>(CallType), AllowExplicit,
      IsListInitialization);
  if (AllArgs)
    for (unsigned I = 0; I < AllArgsSize && I < Gathered.size(); ++I)
      AllArgs[I] = reinterpret_cast<CXExpr>(Gathered[I]);
  *NumAllArgs = static_cast<unsigned>(Gathered.size());
  return Invalid;
}

void clang_Sema_AddKnownFunctionAttributesForReplaceableGlobalAllocationFunction(
    CXSema S, CXFunctionDecl FD) {
  reinterpret_cast<clang::Sema *>(S)
      ->AddKnownFunctionAttributesForReplaceableGlobalAllocationFunction(
          reinterpret_cast<clang::FunctionDecl *>(FD));
}

void clang_Sema_DeclareGlobalAllocationFunction(CXSema S, CXDeclarationName Name,
                                                CXQualType Return, const CXQualType *Params,
                                                unsigned NumParams) {
  llvm::SmallVector<clang::QualType, 4> Ps;
  Ps.reserve(NumParams);
  for (unsigned I = 0; I < NumParams; ++I)
    Ps.push_back(clang::QualType::getFromOpaquePtr(Params[I]));
  reinterpret_cast<clang::Sema *>(S)->DeclareGlobalAllocationFunction(
      clang::DeclarationName::getFromOpaquePtr(Name),
      clang::QualType::getFromOpaquePtr(Return), Ps);
}

bool clang_Sema_FindDeallocationFunction(CXSema S, CXSourceLocation_ StartLoc,
                                         CXCXXRecordDecl RD, CXDeclarationName Name,
                                         CXFunctionDecl *Operator, bool Diagnose,
                                         bool WantSize, bool WantAligned) {
  clang::FunctionDecl *Op = nullptr;
  bool Failed = reinterpret_cast<clang::Sema *>(S)->FindDeallocationFunction(
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      reinterpret_cast<clang::CXXRecordDecl *>(RD),
      clang::DeclarationName::getFromOpaquePtr(Name), Op, Diagnose, WantSize, WantAligned);
  *Operator = reinterpret_cast<CXFunctionDecl>(Op);
  return Failed;
}

void clang_Sema_CheckDelegatingCtorCycles(CXSema S) {
  reinterpret_cast<clang::Sema *>(S)->CheckDelegatingCtorCycles();
}

void clang_Sema_CheckCastAlign(CXSema S, CXExpr Op, CXQualType T,
                               CXSourceLocation_ TRange_begin,
                               CXSourceLocation_ TRange_end) {
  reinterpret_cast<clang::Sema *>(S)->CheckCastAlign(
      reinterpret_cast<clang::Expr *>(Op), clang::QualType::getFromOpaquePtr(T),
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(TRange_begin),
                         clang::SourceLocation::getFromPtrEncoding(TRange_end)));
}

bool clang_Sema_CheckNontrivialField(CXSema S, CXFieldDecl FD) {
  return reinterpret_cast<clang::Sema *>(S)->CheckNontrivialField(
      reinterpret_cast<clang::FieldDecl *>(FD));
}

bool clang_Sema_CheckEnumRedeclaration(CXSema S, CXSourceLocation_ EnumLoc, bool IsScoped,
                                       CXQualType EnumUnderlyingTy, bool IsFixed,
                                       CXEnumDecl Prev) {
  return reinterpret_cast<clang::Sema *>(S)->CheckEnumRedeclaration(
      clang::SourceLocation::getFromPtrEncoding(EnumLoc), IsScoped,
      clang::QualType::getFromOpaquePtr(EnumUnderlyingTy), IsFixed,
      reinterpret_cast<clang::EnumDecl *>(Prev));
}

bool clang_Sema_CheckCallReturnType(CXSema S, CXQualType ReturnType, CXSourceLocation_ Loc,
                                    CXCallExpr CE, CXFunctionDecl FD) {
  return reinterpret_cast<clang::Sema *>(S)->CheckCallReturnType(
      clang::QualType::getFromOpaquePtr(ReturnType),
      clang::SourceLocation::getFromPtrEncoding(Loc), reinterpret_cast<clang::CallExpr *>(CE),
      reinterpret_cast<clang::FunctionDecl *>(FD));
}

void clang_Sema_CheckCXXDefaultArguments(CXSema S, CXFunctionDecl FD) {
  reinterpret_cast<clang::Sema *>(S)->CheckCXXDefaultArguments(
      reinterpret_cast<clang::FunctionDecl *>(FD));
}

void clang_Sema_CheckAlignasUnderalignment(CXSema S, CXDecl D) {
  reinterpret_cast<clang::Sema *>(S)->CheckAlignasUnderalignment(reinterpret_cast<clang::Decl *>(D));
}

void clang_Sema_CheckUnusedVolatileAssignment(CXSema S, CXExpr E) {
  reinterpret_cast<clang::Sema *>(S)->CheckUnusedVolatileAssignment(
      reinterpret_cast<clang::Expr *>(E));
}

bool clang_Sema_CheckVecStepExpr(CXSema S, CXExpr E) {
  return reinterpret_cast<clang::Sema *>(S)->CheckVecStepExpr(reinterpret_cast<clang::Expr *>(E));
}

void clang_Sema_CheckStaticArrayArgument(CXSema S, CXSourceLocation_ CallLoc,
                                         CXParmVarDecl Param, CXExpr ArgExpr) {
  reinterpret_cast<clang::Sema *>(S)->CheckStaticArrayArgument(
      clang::SourceLocation::getFromPtrEncoding(CallLoc),
      reinterpret_cast<clang::ParmVarDecl *>(Param), reinterpret_cast<clang::Expr *>(ArgExpr));
}

void clang_Sema_CheckCompatibleReinterpretCast(CXSema S, CXQualType SrcType,
                                               CXQualType DestType, bool IsDereference,
                                               CXSourceLocation_ Range_begin,
                                               CXSourceLocation_ Range_end) {
  reinterpret_cast<clang::Sema *>(S)->CheckCompatibleReinterpretCast(
      clang::QualType::getFromOpaquePtr(SrcType),
      clang::QualType::getFromOpaquePtr(DestType), IsDereference,
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Range_begin),
                         clang::SourceLocation::getFromPtrEncoding(Range_end)));
}

bool clang_Sema_CheckConstraintExpression(CXSema S, CXExpr CE, bool *PossibleNonPrimary,
                                          bool IsTrailingRequiresClause) {
  clang::Token NextToken;
  NextToken.startToken();
  return reinterpret_cast<clang::Sema *>(S)->CheckConstraintExpression(
      reinterpret_cast<clang::Expr *>(CE), NextToken, PossibleNonPrimary,
      IsTrailingRequiresClause);
}

void clang_Sema_CheckConstructor(CXSema S, CXCXXConstructorDecl Constructor) {
  reinterpret_cast<clang::Sema *>(S)->CheckConstructor(
      reinterpret_cast<clang::CXXConstructorDecl *>(Constructor));
}

void clang_Sema_CheckOverrideControl(CXSema S, CXNamedDecl D) {
  reinterpret_cast<clang::Sema *>(S)->CheckOverrideControl(reinterpret_cast<clang::NamedDecl *>(D));
}

void clang_Sema_CheckFloatComparison(CXSema S, CXSourceLocation_ Loc, CXExpr LHS,
                                     CXExpr RHS, CXBinaryOperatorKind Opcode) {
  reinterpret_cast<clang::Sema *>(S)->CheckFloatComparison(
      clang::SourceLocation::getFromPtrEncoding(Loc), reinterpret_cast<clang::Expr *>(LHS),
      reinterpret_cast<clang::Expr *>(RHS), static_cast<clang::BinaryOperatorKind>(Opcode));
}

// --- Sema state queries: current context, modules and type classification ---

CXASTConsumer clang_Sema_getASTConsumer(CXSema S) {
  return reinterpret_cast<CXASTConsumer>(&reinterpret_cast<clang::Sema *>(S)->getASTConsumer());
}

CXScope clang_Sema_getScopeForContext(CXSema S, CXDeclContext Ctx) {
  return reinterpret_cast<CXScope>(reinterpret_cast<clang::Sema *>(S)->getScopeForContext(
      reinterpret_cast<clang::DeclContext *>(Ctx)));
}

bool clang_Sema_hasCurFunction(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->getCurFunction() != nullptr;
}

bool clang_Sema_hasAnyUnrecoverableErrorsInThisFunction(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->hasAnyUnrecoverableErrorsInThisFunction();
}

bool clang_Sema_isModuleVisible(CXSema S, CXModule_ M, bool ModulePrivate) {
  return reinterpret_cast<clang::Sema *>(S)->isModuleVisible(reinterpret_cast<clang::Module *>(M),
                                                        ModulePrivate);
}

bool clang_Sema_hasMergedDefinitionInCurrentModule(CXSema S, CXNamedDecl Def) {
  return reinterpret_cast<clang::Sema *>(S)->hasMergedDefinitionInCurrentModule(
      reinterpret_cast<clang::NamedDecl *>(Def));
}

CXQualType clang_Sema_getDecltypeForExpr(CXSema S, CXExpr E) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->getDecltypeForExpr(reinterpret_cast<clang::Expr *>(E))
      .getAsOpaquePtr());
}

bool clang_Sema_isSimpleTypeSpecifier(CXSema S, unsigned Kind) {
  return reinterpret_cast<clang::Sema *>(S)->isSimpleTypeSpecifier(
      static_cast<clang::tok::TokenKind>(Kind));
}

bool clang_Sema_isDeclInScope(CXSema S, CXNamedDecl D, CXDeclContext Ctx, CXScope Sc,
                              bool AllowInlineNamespace) {
  return reinterpret_cast<clang::Sema *>(S)->isDeclInScope(
      reinterpret_cast<clang::NamedDecl *>(D), reinterpret_cast<clang::DeclContext *>(Ctx),
      reinterpret_cast<clang::Scope *>(Sc), AllowInlineNamespace);
}

bool clang_Sema_IsStringInit(CXSema S, CXExpr Init, CXArrayType AT) {
  return reinterpret_cast<clang::Sema *>(S)->IsStringInit(reinterpret_cast<clang::Expr *>(Init),
                                                     reinterpret_cast<clang::ArrayType *>(AT));
}

CXFunctionEmissionStatus clang_Sema_getEmissionStatus(CXSema S, CXFunctionDecl FD,
                                                      bool Final) {
  return static_cast<CXFunctionEmissionStatus>(
      reinterpret_cast<clang::Sema *>(S)->getEmissionStatus(
          reinterpret_cast<clang::FunctionDecl *>(FD), Final));
}

CXLangAS clang_Sema_getDefaultCXXMethodAddrSpace(CXSema S) {
  return static_cast<CXLangAS>(
      reinterpret_cast<clang::Sema *>(S)->getDefaultCXXMethodAddrSpace());
}

CXEnumDecl clang_Sema_getStdAlignValT(CXSema S) {
  return reinterpret_cast<CXEnumDecl>(reinterpret_cast<clang::Sema *>(S)->getStdAlignValT());
}

bool clang_Sema_isThisOutsideMemberFunctionBody(CXSema S, CXQualType BaseType) {
  return reinterpret_cast<clang::Sema *>(S)->isThisOutsideMemberFunctionBody(
      clang::QualType::getFromOpaquePtr(BaseType));
}

bool clang_Sema_isUnavailableAlignedAllocationFunction(CXSema S, CXFunctionDecl FD) {
  return reinterpret_cast<clang::Sema *>(S)->isUnavailableAlignedAllocationFunction(
      *reinterpret_cast<clang::FunctionDecl *>(FD));
}

bool clang_Sema_IsInsideALocalClassWithinATemplateFunction(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->IsInsideALocalClassWithinATemplateFunction();
}

bool clang_Sema_CanBeGetReturnObject(CXFunctionDecl FD) {
  return clang::Sema::CanBeGetReturnObject(reinterpret_cast<clang::FunctionDecl *>(FD));
}

bool clang_Sema_IsStringLiteralToNonConstPointerConversion(CXSema S, CXExpr From,
                                                           CXQualType ToType) {
  return reinterpret_cast<clang::Sema *>(S)->IsStringLiteralToNonConstPointerConversion(
      reinterpret_cast<clang::Expr *>(From), clang::QualType::getFromOpaquePtr(ToType));
}

bool clang_Sema_isValidSveBitcast(CXSema S, CXQualType SrcType, CXQualType DestType) {
  return reinterpret_cast<clang::Sema *>(S)->isValidSveBitcast(
      clang::QualType::getFromOpaquePtr(SrcType),
      clang::QualType::getFromOpaquePtr(DestType));
}

bool clang_Sema_isValidRVVBitcast(CXSema S, CXQualType SrcType, CXQualType DestType) {
  return reinterpret_cast<clang::Sema *>(S)->isValidRVVBitcast(
      clang::QualType::getFromOpaquePtr(SrcType),
      clang::QualType::getFromOpaquePtr(DestType));
}

CXDeclContext clang_Sema_getCurObjCLexicalContext(CXSema S) {
  return reinterpret_cast<CXDeclContext>(const_cast<clang::DeclContext *>(
      reinterpret_cast<clang::Sema *>(S)->getCurObjCLexicalContext()));
}

// Sema::AlignPackInfo
CXAlignPackInfo clang_AlignPackInfo_createPack(CXAlignPackInfo_Mode M, unsigned Num,
                                               bool IsXL) {
  return reinterpret_cast<CXAlignPackInfo>(new clang::Sema::AlignPackInfo( // NOLINT(*-owning-memory)
      static_cast<clang::Sema::AlignPackInfo::Mode>(M), Num, IsXL));
}

CXAlignPackInfo clang_AlignPackInfo_createAlign(CXAlignPackInfo_Mode M, bool IsXL) {
  return reinterpret_cast<CXAlignPackInfo>(new clang::Sema::AlignPackInfo( // NOLINT(*-owning-memory)
      static_cast<clang::Sema::AlignPackInfo::Mode>(M), IsXL));
}

void clang_AlignPackInfo_dispose(CXAlignPackInfo Info) {
  delete reinterpret_cast<clang::Sema::AlignPackInfo *>(Info);
}

unsigned clang_AlignPackInfo_getRawEncoding(CXAlignPackInfo Info) {
  return clang::Sema::AlignPackInfo::getRawEncoding(
      *reinterpret_cast<clang::Sema::AlignPackInfo *>(Info));
}

CXAlignPackInfo clang_AlignPackInfo_getFromRawEncoding(unsigned Encoding) {
  return reinterpret_cast<CXAlignPackInfo>(new clang::Sema::AlignPackInfo( // NOLINT(*-owning-memory)
      clang::Sema::AlignPackInfo::getFromRawEncoding(Encoding)));
}

bool clang_AlignPackInfo_IsPackAttr(CXAlignPackInfo Info) {
  return reinterpret_cast<clang::Sema::AlignPackInfo *>(Info)->IsPackAttr();
}

bool clang_AlignPackInfo_IsAlignAttr(CXAlignPackInfo Info) {
  return reinterpret_cast<clang::Sema::AlignPackInfo *>(Info)->IsAlignAttr();
}

CXAlignPackInfo_Mode clang_AlignPackInfo_getAlignMode(CXAlignPackInfo Info) {
  return static_cast<CXAlignPackInfo_Mode>(
      reinterpret_cast<clang::Sema::AlignPackInfo *>(Info)->getAlignMode());
}

unsigned clang_AlignPackInfo_getPackNumber(CXAlignPackInfo Info) {
  return reinterpret_cast<clang::Sema::AlignPackInfo *>(Info)->getPackNumber();
}

bool clang_AlignPackInfo_IsPackSet(CXAlignPackInfo Info) {
  return reinterpret_cast<clang::Sema::AlignPackInfo *>(Info)->IsPackSet();
}

bool clang_AlignPackInfo_IsXLStack(CXAlignPackInfo Info) {
  return reinterpret_cast<clang::Sema::AlignPackInfo *>(Info)->IsXLStack();
}

// Sema::DefaultedFunctionKind
CXDefaultedFunctionKind clang_Sema_getDefaultedFunctionKind(CXSema S, CXFunctionDecl FD) {
  return reinterpret_cast<CXDefaultedFunctionKind>(new clang::Sema::DefaultedFunctionKind( // NOLINT(*-owning-memory)
      reinterpret_cast<clang::Sema *>(S)->getDefaultedFunctionKind(
          reinterpret_cast<clang::FunctionDecl *>(FD))));
}

void clang_DefaultedFunctionKind_dispose(CXDefaultedFunctionKind DFK) {
  delete reinterpret_cast<clang::Sema::DefaultedFunctionKind *>(DFK);
}

bool clang_DefaultedFunctionKind_isSpecialMember(CXDefaultedFunctionKind DFK) {
  return reinterpret_cast<clang::Sema::DefaultedFunctionKind *>(DFK)->isSpecialMember();
}

bool clang_DefaultedFunctionKind_isComparison(CXDefaultedFunctionKind DFK) {
  return reinterpret_cast<clang::Sema::DefaultedFunctionKind *>(DFK)->isComparison();
}

CXCXXSpecialMember
clang_DefaultedFunctionKind_asSpecialMember(CXDefaultedFunctionKind DFK) {
  return static_cast<CXCXXSpecialMember>(
      reinterpret_cast<clang::Sema::DefaultedFunctionKind *>(DFK)->asSpecialMember());
}

CXDefaultedComparisonKind
clang_DefaultedFunctionKind_asComparison(CXDefaultedFunctionKind DFK) {
  return static_cast<CXDefaultedComparisonKind>(
      reinterpret_cast<clang::Sema::DefaultedFunctionKind *>(DFK)->asComparison());
}

unsigned clang_DefaultedFunctionKind_getDiagnosticIndex(CXDefaultedFunctionKind DFK) {
  return reinterpret_cast<clang::Sema::DefaultedFunctionKind *>(DFK)->getDiagnosticIndex();
}

// Sema::SFINAETrap
CXSFINAETrap clang_SFINAETrap_create(CXSema S, bool AccessCheckingSFINAE) {
  return reinterpret_cast<CXSFINAETrap>(new clang::Sema::SFINAETrap( // NOLINT(*-owning-memory)
      *reinterpret_cast<clang::Sema *>(S), AccessCheckingSFINAE));
}

void clang_SFINAETrap_dispose(CXSFINAETrap Trap) {
  delete reinterpret_cast<clang::Sema::SFINAETrap *>(Trap);
}

bool clang_SFINAETrap_hasErrorOccurred(CXSFINAETrap Trap) {
  return reinterpret_cast<clang::Sema::SFINAETrap *>(Trap)->hasErrorOccurred();
}

namespace {
// The expression-evaluation record's qualified name is too long to spell at every use.
using EvalCtxRecord = clang::Sema::ExpressionEvaluationContextRecord;

// Shared out-parameter half of the two optional<InitializationContext> accessors below.
bool unpackInitContext(const std::optional<EvalCtxRecord::InitializationContext> &Opt,
                       CXSourceLocation_ *Loc, CXValueDecl *Decl, CXDeclContext *Ctx) {
  if (!Opt)
    return false;
  *Loc = reinterpret_cast<CXSourceLocation_>(Opt->Loc.getPtrEncoding());
  *Decl = reinterpret_cast<CXValueDecl>(Opt->Decl);
  *Ctx = reinterpret_cast<CXDeclContext>(Opt->Context);
  return true;
}
} // namespace

unsigned clang_Sema_LookupOverloadedOperatorName(CXSema S, CXOverloadedOperatorKind Op,
                                                 CXScope Sc, CXNamedDecl *Buf,
                                                 unsigned BufSize) {
  clang::UnresolvedSet<8> Functions;
  reinterpret_cast<clang::Sema *>(S)->LookupOverloadedOperatorName(
      static_cast<clang::OverloadedOperatorKind>(Op), reinterpret_cast<clang::Scope *>(Sc),
      Functions);
  unsigned N = 0;
  for (clang::NamedDecl *ND : Functions) {
    if (Buf) {
      if (N >= BufSize)
        break;
      Buf[N] = reinterpret_cast<CXNamedDecl>(ND);
    }
    ++N;
  }
  return N;
}

void clang_Sema_LookupOverloadedBinOp(CXSema S, CXOverloadCandidateSet CandidateSet,
                                      CXOverloadedOperatorKind Op,
                                      const CXNamedDecl *Functions,
                                      const CXAccessSpecifier *Accesses,
                                      unsigned NumFunctions, const CXExpr *Args,
                                      unsigned NumArgs, bool RequiresADL) {
  clang::UnresolvedSet<8> Fns;
  fillUnresolvedSet(Fns, Functions, Accesses, NumFunctions);
  llvm::SmallVector<clang::Expr *, 8> As = makeExprArgs(Args, NumArgs);
  reinterpret_cast<clang::Sema *>(S)->LookupOverloadedBinOp(
      *reinterpret_cast<clang::OverloadCandidateSet *>(CandidateSet),
      static_cast<clang::OverloadedOperatorKind>(Op), Fns, As, RequiresADL);
}

CXExpressionEvaluationContextRecord clang_Sema_currentEvaluationContext(CXSema S) {
  return reinterpret_cast<CXExpressionEvaluationContextRecord>(const_cast<EvalCtxRecord *>(
      &reinterpret_cast<clang::Sema *>(S)->currentEvaluationContext()));
}

CXExpressionEvaluationContext clang_ExpressionEvaluationContextRecord_getContext(
    CXExpressionEvaluationContextRecord Rec) {
  return static_cast<CXExpressionEvaluationContext>(
      reinterpret_cast<EvalCtxRecord *>(Rec)->Context);
}

unsigned clang_ExpressionEvaluationContextRecord_getNumCleanupObjects(
    CXExpressionEvaluationContextRecord Rec) {
  return reinterpret_cast<EvalCtxRecord *>(Rec)->NumCleanupObjects;
}

unsigned clang_ExpressionEvaluationContextRecord_getNumTypos(
    CXExpressionEvaluationContextRecord Rec) {
  return reinterpret_cast<EvalCtxRecord *>(Rec)->NumTypos;
}

CXDecl clang_ExpressionEvaluationContextRecord_getManglingContextDecl(
    CXExpressionEvaluationContextRecord Rec) {
  return reinterpret_cast<CXDecl>(reinterpret_cast<EvalCtxRecord *>(Rec)->ManglingContextDecl);
}

CXExpressionKind clang_ExpressionEvaluationContextRecord_getExprContext(
    CXExpressionEvaluationContextRecord Rec) {
  return static_cast<CXExpressionKind>(reinterpret_cast<EvalCtxRecord *>(Rec)->ExprContext);
}

bool clang_ExpressionEvaluationContextRecord_isDiscardedStatementContext(
    CXExpressionEvaluationContextRecord Rec) {
  return reinterpret_cast<EvalCtxRecord *>(Rec)->isDiscardedStatementContext();
}

bool clang_ExpressionEvaluationContextRecord_getDelayedDefaultInitializationContext(
    CXExpressionEvaluationContextRecord Rec, CXSourceLocation_ *Loc, CXValueDecl *Decl,
    CXDeclContext *Ctx) {
  return unpackInitContext(
      reinterpret_cast<EvalCtxRecord *>(Rec)->DelayedDefaultInitializationContext, Loc, Decl,
      Ctx);
}

bool clang_Sema_InnermostDeclarationWithDelayedImmediateInvocations(CXSema S,
                                                                    CXSourceLocation_ *Loc,
                                                                    CXValueDecl *Decl,
                                                                    CXDeclContext *Ctx) {
  return unpackInitContext(
      reinterpret_cast<clang::Sema *>(S)->InnermostDeclarationWithDelayedImmediateInvocations(),
      Loc, Decl, Ctx);
}

bool clang_Sema_OutermostDeclarationWithDelayedImmediateInvocations(CXSema S,
                                                                    CXSourceLocation_ *Loc,
                                                                    CXValueDecl *Decl,
                                                                    CXDeclContext *Ctx) {
  return unpackInitContext(
      reinterpret_cast<clang::Sema *>(S)->OutermostDeclarationWithDelayedImmediateInvocations(),
      Loc, Decl, Ctx);
}

CXCUDAFunctionTarget clang_Sema_IdentifyCUDATarget(CXSema S, CXFunctionDecl D,
                                                   bool IgnoreImplicitHDAttr) {
  return static_cast<CXCUDAFunctionTarget>(
      reinterpret_cast<clang::Sema *>(S)->IdentifyCUDATarget(
          reinterpret_cast<clang::FunctionDecl *>(D), IgnoreImplicitHDAttr));
}

CXCUDAFunctionTarget clang_Sema_CurrentCUDATarget(CXSema S) {
  return static_cast<CXCUDAFunctionTarget>(
      reinterpret_cast<clang::Sema *>(S)->CurrentCUDATarget());
}

CXCUDAFunctionPreference clang_Sema_IdentifyCUDAPreference(CXSema S, CXFunctionDecl Caller,
                                                           CXFunctionDecl Callee) {
  return static_cast<CXCUDAFunctionPreference>(
      reinterpret_cast<clang::Sema *>(S)->IdentifyCUDAPreference(
          reinterpret_cast<clang::FunctionDecl *>(Caller),
          reinterpret_cast<clang::FunctionDecl *>(Callee)));
}

bool clang_Sema_FindAllocationFunctions(
    CXSema S, CXSourceLocation_ StartLoc, CXSourceLocation_ Range_begin,
    CXSourceLocation_ Range_end, CXAllocationFunctionScope NewScope,
    CXAllocationFunctionScope DeleteScope, CXQualType AllocType, bool IsArray,
    bool *PassAlignment, const CXExpr *PlaceArgs, unsigned NumPlaceArgs,
    CXFunctionDecl *OperatorNew, CXFunctionDecl *OperatorDelete, bool Diagnose) {
  llvm::SmallVector<clang::Expr *, 8> Args = makeExprArgs(PlaceArgs, NumPlaceArgs);
  clang::FunctionDecl *New = nullptr;
  clang::FunctionDecl *Delete = nullptr;
  bool Failed = reinterpret_cast<clang::Sema *>(S)->FindAllocationFunctions(
      clang::SourceLocation::getFromPtrEncoding(StartLoc),
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Range_begin),
                         clang::SourceLocation::getFromPtrEncoding(Range_end)),
      static_cast<clang::Sema::AllocationFunctionScope>(NewScope),
      static_cast<clang::Sema::AllocationFunctionScope>(DeleteScope),
      clang::QualType::getFromOpaquePtr(AllocType), IsArray, *PassAlignment, Args, New,
      Delete, Diagnose);
  *OperatorNew = reinterpret_cast<CXFunctionDecl>(New);
  *OperatorDelete = reinterpret_cast<CXFunctionDecl>(Delete);
  return Failed;
}

CXQualType clang_Sema_FindCompositePointerType(CXSema S, CXSourceLocation_ Loc, CXExpr *E1,
                                               CXExpr *E2, bool ConvertArgs) {
  clang::Expr *A = reinterpret_cast<clang::Expr *>(*E1);
  clang::Expr *B = reinterpret_cast<clang::Expr *>(*E2);
  clang::QualType T = reinterpret_cast<clang::Sema *>(S)->FindCompositePointerType(
      clang::SourceLocation::getFromPtrEncoding(Loc), A, B, ConvertArgs);
  *E1 = reinterpret_cast<CXExpr>(A);
  *E2 = reinterpret_cast<CXExpr>(B);
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

CXNamedDecl clang_Sema_FindInstantiatedDecl(CXSema S, CXSourceLocation_ Loc, CXNamedDecl D,
                                            CXMultiLevelTemplateArgumentList TemplateArgs,
                                            bool FindingInstantiatedContext) {
  return reinterpret_cast<CXNamedDecl>(reinterpret_cast<clang::Sema *>(S)->FindInstantiatedDecl(
      clang::SourceLocation::getFromPtrEncoding(Loc), reinterpret_cast<clang::NamedDecl *>(D),
      extra::unboxMultiLevelTemplateArgumentList(TemplateArgs), FindingInstantiatedContext));
}

CXDeclContext
clang_Sema_FindInstantiatedContext(CXSema S, CXSourceLocation_ Loc, CXDeclContext DC,
                                   CXMultiLevelTemplateArgumentList TemplateArgs) {
  return reinterpret_cast<CXDeclContext>(reinterpret_cast<clang::Sema *>(S)->FindInstantiatedContext(
      clang::SourceLocation::getFromPtrEncoding(Loc), reinterpret_cast<clang::DeclContext *>(DC),
      extra::unboxMultiLevelTemplateArgumentList(TemplateArgs)));
}

CXFunctionDecl clang_Sema_ResolveSingleFunctionTemplateSpecialization(
    CXSema S, CXOverloadExpr Ovl, bool Complain, CXNamedDecl *FoundDecl,
    CXAccessSpecifier *FoundAccess) {
  clang::DeclAccessPair Found = clang::DeclAccessPair::make(nullptr, clang::AS_none);
  clang::FunctionDecl *FD =
      reinterpret_cast<clang::Sema *>(S)->ResolveSingleFunctionTemplateSpecialization(
          reinterpret_cast<clang::OverloadExpr *>(Ovl), Complain, &Found);
  *FoundDecl = reinterpret_cast<CXNamedDecl>(Found.getDecl());
  *FoundAccess = static_cast<CXAccessSpecifier>(Found.getAccess());
  return reinterpret_cast<CXFunctionDecl>(FD);
}

CXQualType clang_Sema_AdjustParameterTypeForObjCAutoRefCount(CXSema S, CXQualType T,
                                                             CXSourceLocation_ NameLoc,
                                                             CXTypeSourceInfo TSInfo) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->AdjustParameterTypeForObjCAutoRefCount(
          clang::QualType::getFromOpaquePtr(T),
          clang::SourceLocation::getFromPtrEncoding(NameLoc),
          reinterpret_cast<clang::TypeSourceInfo *>(TSInfo))
      .getAsOpaquePtr());
}

void clang_Sema_SetFunctionBodyKind(CXSema S, CXDecl D, CXSourceLocation_ Loc,
                                    CXFnBodyKind BodyKind) {
  reinterpret_cast<clang::Sema *>(S)->SetFunctionBodyKind(
      reinterpret_cast<clang::Decl *>(D), clang::SourceLocation::getFromPtrEncoding(Loc),
      static_cast<clang::Sema::FnBodyKind>(BodyKind));
}

void clang_Sema_setExceptionMode(CXSema S, CXSourceLocation_ Loc,
                                 CXFPExceptionModeKind FPE) {
  reinterpret_cast<clang::Sema *>(S)->setExceptionMode(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      static_cast<clang::LangOptions::FPExceptionModeKind>(FPE));
}

void clang_Sema_RegisterLocallyScopedExternCDecl(CXSema S, CXNamedDecl ND, CXScope Sc) {
  reinterpret_cast<clang::Sema *>(S)->RegisterLocallyScopedExternCDecl(
      reinterpret_cast<clang::NamedDecl *>(ND), reinterpret_cast<clang::Scope *>(Sc));
}

void clang_Sema_MergeVarDeclTypes(CXSema S, CXVarDecl New, CXVarDecl Old,
                                  bool MergeTypeWithOld) {
  reinterpret_cast<clang::Sema *>(S)->MergeVarDeclTypes(reinterpret_cast<clang::VarDecl *>(New),
                                                   reinterpret_cast<clang::VarDecl *>(Old),
                                                   MergeTypeWithOld);
}

void clang_Sema_MergeVarDeclExceptionSpecs(CXSema S, CXVarDecl New, CXVarDecl Old) {
  reinterpret_cast<clang::Sema *>(S)->MergeVarDeclExceptionSpecs(
      reinterpret_cast<clang::VarDecl *>(New), reinterpret_cast<clang::VarDecl *>(Old));
}

CXQualType clang_Sema_CheckMultiplyDivideOperands(CXSema S, CXExpr *LHS, CXExpr *RHS,
                                                  CXSourceLocation_ Loc, bool IsCompAssign,
                                                  bool IsDivide) {
  clang::ExprResult L = reinterpret_cast<clang::Expr *>(*LHS);
  clang::ExprResult R = reinterpret_cast<clang::Expr *>(*RHS);
  clang::QualType T = reinterpret_cast<clang::Sema *>(S)->CheckMultiplyDivideOperands(
      L, R, clang::SourceLocation::getFromPtrEncoding(Loc), IsCompAssign, IsDivide);
  *LHS = reinterpret_cast<CXExpr>(L.isInvalid() ? nullptr : L.get());
  *RHS = reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

CXQualType clang_Sema_CheckRemainderOperands(CXSema S, CXExpr *LHS, CXExpr *RHS,
                                             CXSourceLocation_ Loc, bool IsCompAssign) {
  clang::ExprResult L = reinterpret_cast<clang::Expr *>(*LHS);
  clang::ExprResult R = reinterpret_cast<clang::Expr *>(*RHS);
  clang::QualType T = reinterpret_cast<clang::Sema *>(S)->CheckRemainderOperands(
      L, R, clang::SourceLocation::getFromPtrEncoding(Loc), IsCompAssign);
  *LHS = reinterpret_cast<CXExpr>(L.isInvalid() ? nullptr : L.get());
  *RHS = reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

CXQualType clang_Sema_CheckAdditionOperands(CXSema S, CXExpr *LHS, CXExpr *RHS,
                                            CXSourceLocation_ Loc, CXBinaryOperatorKind Opc,
                                            bool IsCompAssign, CXQualType *CompLHSTy) {
  clang::ExprResult L = reinterpret_cast<clang::Expr *>(*LHS);
  clang::ExprResult R = reinterpret_cast<clang::Expr *>(*RHS);
  clang::QualType Comp;
  clang::QualType T = reinterpret_cast<clang::Sema *>(S)->CheckAdditionOperands(
      L, R, clang::SourceLocation::getFromPtrEncoding(Loc),
      static_cast<clang::BinaryOperatorKind>(Opc), IsCompAssign ? &Comp : nullptr);
  *LHS = reinterpret_cast<CXExpr>(L.isInvalid() ? nullptr : L.get());
  *RHS = reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
  if (IsCompAssign)
    *CompLHSTy = reinterpret_cast<CXQualType>(Comp.getAsOpaquePtr());
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

CXQualType clang_Sema_CheckSubtractionOperands(CXSema S, CXExpr *LHS, CXExpr *RHS,
                                               CXSourceLocation_ Loc, bool IsCompAssign,
                                               CXQualType *CompLHSTy) {
  clang::ExprResult L = reinterpret_cast<clang::Expr *>(*LHS);
  clang::ExprResult R = reinterpret_cast<clang::Expr *>(*RHS);
  clang::QualType Comp;
  clang::QualType T = reinterpret_cast<clang::Sema *>(S)->CheckSubtractionOperands(
      L, R, clang::SourceLocation::getFromPtrEncoding(Loc), IsCompAssign ? &Comp : nullptr);
  *LHS = L.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(L.get());
  *RHS = R.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(R.get());
  if (IsCompAssign)
    *CompLHSTy = reinterpret_cast<CXQualType>(Comp.getAsOpaquePtr());
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

CXQualType clang_Sema_CheckShiftOperands(CXSema S, CXExpr *LHS, CXExpr *RHS,
                                         CXSourceLocation_ Loc, CXBinaryOperatorKind Opc,
                                         bool IsCompAssign) {
  clang::ExprResult L = reinterpret_cast<clang::Expr *>(*LHS);
  clang::ExprResult R = reinterpret_cast<clang::Expr *>(*RHS);
  clang::QualType T = reinterpret_cast<clang::Sema *>(S)->CheckShiftOperands(
      L, R, clang::SourceLocation::getFromPtrEncoding(Loc),
      static_cast<clang::BinaryOperatorKind>(Opc), IsCompAssign);
  *LHS = L.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(L.get());
  *RHS = R.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(R.get());
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

CXNamedReturnInfo_Status clang_Sema_getNamedReturnInfo(CXSema S, CXVarDecl VD) {
  clang::Sema::NamedReturnInfo NRI = reinterpret_cast<clang::Sema *>(S)->getNamedReturnInfo(
      reinterpret_cast<clang::VarDecl *>(VD));
  return static_cast<CXNamedReturnInfo_Status>(NRI.S);
}


CXTemplateDeductionResult clang_Sema_DeduceTemplateArgumentsVarPartial(
    CXSema S, CXVarTemplatePartialSpecializationDecl Partial,
    CXTemplateArgumentList TemplateArgs, CXTemplateDeductionInfo Info) {
  return static_cast<CXTemplateDeductionResult>(
      reinterpret_cast<clang::Sema *>(S)->DeduceTemplateArguments(
          reinterpret_cast<clang::VarTemplatePartialSpecializationDecl *>(Partial),
          *reinterpret_cast<clang::TemplateArgumentList *>(TemplateArgs),
          *reinterpret_cast<clang::sema::TemplateDeductionInfo *>(Info)));
}

CXTemplateDeductionResult clang_Sema_DeduceTemplateArgumentsFunctionTemplate(
    CXSema S, CXFunctionTemplateDecl FunctionTemplate,
    CXTemplateArgumentListInfo ExplicitTemplateArgs, CXQualType ArgFunctionType,
    CXFunctionDecl *Specialization, CXTemplateDeductionInfo Info, bool IsAddressOfFunction) {
  clang::FunctionDecl *Spec =
      Specialization ? reinterpret_cast<clang::FunctionDecl *>(*Specialization) : nullptr;
  auto R = reinterpret_cast<clang::Sema *>(S)->DeduceTemplateArguments(
          reinterpret_cast<clang::FunctionTemplateDecl *>(FunctionTemplate),
          reinterpret_cast<clang::TemplateArgumentListInfo *>(ExplicitTemplateArgs),
          clang::QualType::getFromOpaquePtr(ArgFunctionType), Spec,
          *reinterpret_cast<clang::sema::TemplateDeductionInfo *>(Info), IsAddressOfFunction);
  if (Specialization && R == clang::Sema::TDK_Success)
    *Specialization = reinterpret_cast<CXFunctionDecl>(Spec);
  return static_cast<CXTemplateDeductionResult>(R);
}

CXExpr clang_Sema_BuildCXXUuidof(CXSema S, CXQualType TypeInfoType, CXSourceLocation_ TypeidLoc,
                                 CXTypeSourceInfo Operand, CXSourceLocation_ RParenLoc,
                                 bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildCXXUuidof(
      clang::QualType::getFromOpaquePtr(TypeInfoType),
      clang::SourceLocation::getFromPtrEncoding(TypeidLoc),
      reinterpret_cast<clang::TypeSourceInfo *>(Operand),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

bool clang_Sema_isAbstractType(CXSema S, CXSourceLocation_ Loc, CXQualType T) {
  return reinterpret_cast<clang::Sema *>(S)->isAbstractType(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      clang::QualType::getFromOpaquePtr(T));
}

void clang_Sema_CheckPtrComparisonWithNullChar(CXSema S, CXExpr *E, CXExpr *NullE) {
  clang::ExprResult L = reinterpret_cast<clang::Expr *>(*E);
  clang::ExprResult R = reinterpret_cast<clang::Expr *>(*NullE);
  reinterpret_cast<clang::Sema *>(S)->CheckPtrComparisonWithNullChar(L, R);
  *E = L.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(L.get());
  *NullE = R.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(R.get());
}

CXQualType clang_Sema_CheckCompareOperands(CXSema S, CXExpr *LHS, CXExpr *RHS,
                                           CXSourceLocation_ Loc,
                                           CXBinaryOperatorKind Opc) {
  clang::ExprResult L = reinterpret_cast<clang::Expr *>(*LHS);
  clang::ExprResult R = reinterpret_cast<clang::Expr *>(*RHS);
  clang::QualType T = reinterpret_cast<clang::Sema *>(S)->CheckCompareOperands(
      L, R, clang::SourceLocation::getFromPtrEncoding(Loc),
      static_cast<clang::BinaryOperatorKind>(Opc));
  *LHS = L.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(L.get());
  *RHS = R.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(R.get());
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

CXQualType clang_Sema_CheckAssignmentOperands(CXSema S, CXExpr LHSExpr, CXExpr *RHS,
                                              CXSourceLocation_ Loc,
                                              CXQualType CompoundType,
                                              CXBinaryOperatorKind Opc) {
  clang::ExprResult R = reinterpret_cast<clang::Expr *>(*RHS);
  clang::QualType T = reinterpret_cast<clang::Sema *>(S)->CheckAssignmentOperands(
      reinterpret_cast<clang::Expr *>(LHSExpr), R,
      clang::SourceLocation::getFromPtrEncoding(Loc),
      clang::QualType::getFromOpaquePtr(CompoundType),
      static_cast<clang::BinaryOperatorKind>(Opc));
  *RHS = R.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(R.get());
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

CXQualType clang_Sema_CheckPointerToMemberOperands(CXSema S, CXExpr *LHS, CXExpr *RHS,
                                                   CXExprValueKind *VK,
                                                   CXSourceLocation_ OpLoc,
                                                   bool IsIndirect) {
  clang::ExprResult L = reinterpret_cast<clang::Expr *>(*LHS);
  clang::ExprResult R = reinterpret_cast<clang::Expr *>(*RHS);
  clang::ExprValueKind K = clang::VK_PRValue;
  clang::QualType T = reinterpret_cast<clang::Sema *>(S)->CheckPointerToMemberOperands(
      L, R, K, clang::SourceLocation::getFromPtrEncoding(OpLoc), IsIndirect);
  *LHS = L.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(L.get());
  *RHS = R.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(R.get());
  *VK = static_cast<CXExprValueKind>(K);
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

CXQualType clang_Sema_CheckAddressOfOperand(CXSema S, CXExpr *Operand,
                                            CXSourceLocation_ OpLoc) {
  clang::ExprResult Op = reinterpret_cast<clang::Expr *>(*Operand);
  clang::QualType T = reinterpret_cast<clang::Sema *>(S)->CheckAddressOfOperand(
      Op, clang::SourceLocation::getFromPtrEncoding(OpLoc));
  *Operand = Op.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(Op.get());
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

CXExpr clang_Sema_CheckExtVectorCast(CXSema S, CXSourceLocation_ R_begin,
                                     CXSourceLocation_ R_end, CXQualType DestTy,
                                     CXExpr CastExpr, CXCastKind *Kind, bool *IsInvalid) {
  clang::CastKind K = clang::CK_Dependent;
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->CheckExtVectorCast(
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(R_begin),
                         clang::SourceLocation::getFromPtrEncoding(R_end)),
      clang::QualType::getFromOpaquePtr(DestTy), reinterpret_cast<clang::Expr *>(CastExpr), K);
  *Kind = static_cast<CXCastKind>(K);
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

bool clang_Sema_CheckMemberPointerConversion(CXSema S, CXExpr From, CXQualType ToType,
                                             CXCastKind *Kind, bool IgnoreBaseAccess) {
  clang::CastKind K = clang::CK_Dependent;
  clang::CXXCastPath BasePath;
  bool Failed = reinterpret_cast<clang::Sema *>(S)->CheckMemberPointerConversion(
      reinterpret_cast<clang::Expr *>(From), clang::QualType::getFromOpaquePtr(ToType), K,
      BasePath, IgnoreBaseAccess);
  *Kind = static_cast<CXCastKind>(K);
  return Failed;
}

bool clang_Sema_CheckExplicitObjectOverride(CXSema S, CXCXXMethodDecl New,
                                            CXCXXMethodDecl Old) {
  return reinterpret_cast<clang::Sema *>(S)->CheckExplicitObjectOverride(
      reinterpret_cast<clang::CXXMethodDecl *>(New), reinterpret_cast<clang::CXXMethodDecl *>(Old));
}

void clang_Sema_CheckDelayedMemberExceptionSpecs(CXSema S) {
  reinterpret_cast<clang::Sema *>(S)->CheckDelayedMemberExceptionSpecs();
}

void clang_Sema_CheckCoroutineWrapper(CXSema S, CXFunctionDecl FD) {
  reinterpret_cast<clang::Sema *>(S)->CheckCoroutineWrapper(
      reinterpret_cast<clang::FunctionDecl *>(FD));
}

CXExpr clang_Sema_CreateOverloadedArraySubscriptExpr(CXSema S, CXSourceLocation_ LLoc,
                                                     CXSourceLocation_ RLoc, CXExpr Base,
                                                     const CXExpr *Args, unsigned NumArgs,
                                                     bool *IsInvalid) {
  llvm::SmallVector<clang::Expr *, 4> ArgVec;
  ArgVec.reserve(NumArgs);
  for (unsigned I = 0; I != NumArgs; ++I)
    ArgVec.push_back(reinterpret_cast<clang::Expr *>(Args[I]));
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->CreateOverloadedArraySubscriptExpr(
      clang::SourceLocation::getFromPtrEncoding(LLoc),
      clang::SourceLocation::getFromPtrEncoding(RLoc), reinterpret_cast<clang::Expr *>(Base),
      ArgVec);
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildCallToObjectOfClassType(CXSema S, CXScope Sp, CXExpr Object,
                                               CXSourceLocation_ LParenLoc,
                                               const CXExpr *Args, unsigned NumArgs,
                                               CXSourceLocation_ RParenLoc,
                                               bool *IsInvalid) {
  llvm::SmallVector<clang::Expr *, 4> ArgVec;
  ArgVec.reserve(NumArgs);
  for (unsigned I = 0; I != NumArgs; ++I)
    ArgVec.push_back(reinterpret_cast<clang::Expr *>(Args[I]));
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildCallToObjectOfClassType(
      reinterpret_cast<clang::Scope *>(Sp), reinterpret_cast<clang::Expr *>(Object),
      clang::SourceLocation::getFromPtrEncoding(LParenLoc), ArgVec,
      clang::SourceLocation::getFromPtrEncoding(RParenLoc));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildOverloadedArrowExpr(CXSema S, CXScope Sp, CXExpr Base,
                                           CXSourceLocation_ OpLoc,
                                           bool *NoArrowOperatorFound, bool *IsInvalid) {
  bool NoArrow = false;
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildOverloadedArrowExpr(
      reinterpret_cast<clang::Scope *>(Sp), reinterpret_cast<clang::Expr *>(Base),
      clang::SourceLocation::getFromPtrEncoding(OpLoc), &NoArrow);
  *NoArrowOperatorFound = NoArrow;
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXStmt clang_Sema_BuildAttributedStmt(CXSema S, CXSourceLocation_ AttrsLoc,
                                      const CXAttr *Attrs, unsigned NumAttrs,
                                      CXStmt SubStmt, bool *IsInvalid) {
  llvm::SmallVector<const clang::Attr *, 4> AttrVec;
  AttrVec.reserve(NumAttrs);
  for (unsigned I = 0; I != NumAttrs; ++I)
    AttrVec.push_back(reinterpret_cast<const clang::Attr *>(Attrs[I]));
  clang::StmtResult R = reinterpret_cast<clang::Sema *>(S)->BuildAttributedStmt(
      clang::SourceLocation::getFromPtrEncoding(AttrsLoc), AttrVec,
      reinterpret_cast<clang::Stmt *>(SubStmt));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXStmt>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_CreateGenericSelectionExpr(
    CXSema S, CXSourceLocation_ KeyLoc, CXSourceLocation_ DefaultLoc,
    CXSourceLocation_ RParenLoc, bool PredicateIsExpr, void *ControllingExprOrType,
    const CXTypeSourceInfo *Types, const CXExpr *Exprs, unsigned NumAssocs,
    bool *IsInvalid) {
  llvm::SmallVector<clang::TypeSourceInfo *, 4> TypeVec;
  llvm::SmallVector<clang::Expr *, 4> ExprVec;
  TypeVec.reserve(NumAssocs);
  ExprVec.reserve(NumAssocs);
  for (unsigned I = 0; I != NumAssocs; ++I) {
    TypeVec.push_back(reinterpret_cast<clang::TypeSourceInfo *>(Types[I]));
    ExprVec.push_back(reinterpret_cast<clang::Expr *>(Exprs[I]));
  }
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->CreateGenericSelectionExpr(
      clang::SourceLocation::getFromPtrEncoding(KeyLoc),
      clang::SourceLocation::getFromPtrEncoding(DefaultLoc),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc), PredicateIsExpr,
      ControllingExprOrType, TypeVec, ExprVec);
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildResolvedCallExpr(CXSema S, CXExpr Fn, CXNamedDecl NDecl,
                                        CXSourceLocation_ LParenLoc, const CXExpr *Args,
                                        unsigned NumArgs, CXSourceLocation_ RParenLoc,
                                        CXExpr Config, bool IsExecConfig, bool UsesADL,
                                        bool *IsInvalid) {
  llvm::SmallVector<clang::Expr *, 4> ArgVec;
  ArgVec.reserve(NumArgs);
  for (unsigned I = 0; I != NumArgs; ++I)
    ArgVec.push_back(reinterpret_cast<clang::Expr *>(Args[I]));
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildResolvedCallExpr(
      reinterpret_cast<clang::Expr *>(Fn), reinterpret_cast<clang::NamedDecl *>(NDecl),
      clang::SourceLocation::getFromPtrEncoding(LParenLoc), ArgVec,
      clang::SourceLocation::getFromPtrEncoding(RParenLoc),
      reinterpret_cast<clang::Expr *>(Config), IsExecConfig,
      UsesADL ? clang::Sema::ADLCallKind::UsesADL : clang::Sema::ADLCallKind::NotADL);
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildCXXDefaultInitExpr(CXSema S, CXSourceLocation_ Loc,
                                          CXFieldDecl Field, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildCXXDefaultInitExpr(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      reinterpret_cast<clang::FieldDecl *>(Field));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildCXXDefaultArgExpr(CXSema S, CXSourceLocation_ CallLoc,
                                         CXFunctionDecl FD, CXParmVarDecl Param,
                                         CXExpr Init, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildCXXDefaultArgExpr(
      clang::SourceLocation::getFromPtrEncoding(CallLoc),
      reinterpret_cast<clang::FunctionDecl *>(FD), reinterpret_cast<clang::ParmVarDecl *>(Param),
      reinterpret_cast<clang::Expr *>(Init));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildCXXMemberCallExpr(CXSema S, CXExpr Exp, CXNamedDecl FoundDecl,
                                         CXCXXConversionDecl Method,
                                         bool HadMultipleCandidates, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildCXXMemberCallExpr(
      reinterpret_cast<clang::Expr *>(Exp), reinterpret_cast<clang::NamedDecl *>(FoundDecl),
      reinterpret_cast<clang::CXXConversionDecl *>(Method), HadMultipleCandidates);
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXCXXCtorInitializer clang_Sema_BuildMemberInitializer(CXSema S, CXValueDecl Member,
                                                       CXExpr Init, CXSourceLocation_ IdLoc,
                                                       bool *IsInvalid) {
  clang::MemInitResult R = reinterpret_cast<clang::Sema *>(S)->BuildMemberInitializer(
      reinterpret_cast<clang::ValueDecl *>(Member), reinterpret_cast<clang::Expr *>(Init),
      clang::SourceLocation::getFromPtrEncoding(IdLoc));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXCXXCtorInitializer>(R.isInvalid() ? nullptr : R.get());
}

bool clang_Sema_isObjCMethodDecl(CXSema S, CXDecl D) {
  return reinterpret_cast<clang::Sema *>(S)->isObjCMethodDecl(reinterpret_cast<clang::Decl *>(D));
}

bool clang_Sema_canSkipFunctionBody(CXSema S, CXDecl D) {
  return reinterpret_cast<clang::Sema *>(S)->canSkipFunctionBody(reinterpret_cast<clang::Decl *>(D));
}

bool clang_Sema_IsRedefinitionInModule(CXSema S, CXNamedDecl New, CXNamedDecl Old) {
  return reinterpret_cast<clang::Sema *>(S)->IsRedefinitionInModule(
      reinterpret_cast<clang::NamedDecl *>(New), reinterpret_cast<clang::NamedDecl *>(Old));
}

bool clang_Sema_isValidSectionSpecifier(CXSema S, const char *Str) {
  llvm::Error E = reinterpret_cast<clang::Sema *>(S)->isValidSectionSpecifier(Str);
  if (!E)
    return true;
  llvm::consumeError(std::move(E));
  return false;
}

bool clang_Sema_ShouldWarnIfUnusedFileScopedDecl(CXSema S, CXDeclaratorDecl D) {
  return reinterpret_cast<clang::Sema *>(S)->ShouldWarnIfUnusedFileScopedDecl(
      reinterpret_cast<clang::DeclaratorDecl *>(D));
}

CXNonOdrUseReason clang_Sema_getNonOdrUseReasonInCurrentContext(CXSema S, CXValueDecl D) {
  return static_cast<CXNonOdrUseReason>(
      reinterpret_cast<clang::Sema *>(S)->getNonOdrUseReasonInCurrentContext(
          reinterpret_cast<clang::ValueDecl *>(D)));
}

bool clang_Sema_isQualifiedMemberAccess(CXSema S, CXExpr E) {
  return reinterpret_cast<clang::Sema *>(S)->isQualifiedMemberAccess(
      reinterpret_cast<clang::Expr *>(E));
}

CXQualType clang_Sema_getLambdaConversionFunctionResultType(CXSema S,
                                                            CXFunctionProtoType CallOpType,
                                                            CXCallingConv_ CC) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->getLambdaConversionFunctionResultType(
          reinterpret_cast<clang::FunctionProtoType *>(CallOpType),
          static_cast<clang::CallingConv>(CC))
      .getAsOpaquePtr());
}

bool clang_Sema_IsSimplyAccessible(CXSema S, CXNamedDecl D, CXCXXRecordDecl NamingClass,
                                   CXQualType BaseType) {
  return reinterpret_cast<clang::Sema *>(S)->IsSimplyAccessible(
      reinterpret_cast<clang::NamedDecl *>(D), reinterpret_cast<clang::CXXRecordDecl *>(NamingClass),
      clang::QualType::getFromOpaquePtr(BaseType));
}

CXSourceLocation_ clang_Sema_getTopMostPointOfInstantiation(CXSema S, CXNamedDecl ND) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Sema *>(S)
      ->getTopMostPointOfInstantiation(reinterpret_cast<clang::NamedDecl *>(ND))
      .getPtrEncoding());
}

bool clang_Sema_isSFINAEContext(CXSema S, CXTemplateDeductionInfo *Info) {
  std::optional<clang::sema::TemplateDeductionInfo *> R =
      reinterpret_cast<clang::Sema *>(S)->isSFINAEContext();
  if (!R)
    return false;
  if (Info)
    *Info = reinterpret_cast<CXTemplateDeductionInfo>(*R);
  return true;
}

bool clang_Sema_CanBeGetReturnTypeOnAllocFailure(CXFunctionDecl FD) {
  return clang::Sema::CanBeGetReturnTypeOnAllocFailure(
      reinterpret_cast<clang::FunctionDecl *>(FD));
}

bool clang_Sema_isInOpenMPAssumeScope(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->isInOpenMPAssumeScope();
}

bool clang_Sema_hasGlobalOpenMPAssumes(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->hasGlobalOpenMPAssumes();
}

bool clang_Sema_isCast(CXCheckedConversionKind CCK) {
  return clang::Sema::isCast(static_cast<clang::Sema::CheckedConversionKind>(CCK));
}

CXVariadicCallType clang_Sema_getVariadicCallType(CXSema S, CXFunctionDecl FDecl,
                                                  CXFunctionProtoType Proto, CXExpr Fn) {
  return static_cast<CXVariadicCallType>(reinterpret_cast<clang::Sema *>(S)->getVariadicCallType(
      reinterpret_cast<clang::FunctionDecl *>(FDecl),
      reinterpret_cast<clang::FunctionProtoType *>(Proto), reinterpret_cast<clang::Expr *>(Fn)));
}

bool clang_Sema_isCUDAImplicitHostDeviceFunction(CXFunctionDecl D) {
  return clang::Sema::isCUDAImplicitHostDeviceFunction(
      reinterpret_cast<clang::FunctionDecl *>(D));
}

CXString clang_Sema_getCudaConfigureFuncName(CXSema S) {
  return extra::makeCXString(reinterpret_cast<clang::Sema *>(S)->getCudaConfigureFuncName());
}

CXIdentifierInfo clang_Sema_getNSErrorIdent(CXSema S) {
  return reinterpret_cast<CXIdentifierInfo>(reinterpret_cast<clang::Sema *>(S)->getNSErrorIdent());
}

CXIdentifierInfo clang_Sema_getSuperIdentifier(CXSema S) {
  return reinterpret_cast<CXIdentifierInfo>(reinterpret_cast<clang::Sema *>(S)->getSuperIdentifier());
}

void clang_Sema_LoadExternalWeakUndeclaredIdentifiers(CXSema S) {
  reinterpret_cast<clang::Sema *>(S)->LoadExternalWeakUndeclaredIdentifiers();
}

CXString clang_Sema_findFailedBooleanCondition(CXSema S, CXExpr Cond, CXExpr *FailedCond) {
  std::pair<clang::Expr *, std::string> R =
      reinterpret_cast<clang::Sema *>(S)->findFailedBooleanCondition(
          reinterpret_cast<clang::Expr *>(Cond));
  *FailedCond = reinterpret_cast<CXExpr>(R.first);
  return extra::makeCXString(R.second);
}

bool clang_Sema_shouldIgnoreInHostDeviceCheck(CXSema S, CXFunctionDecl Callee) {
  return reinterpret_cast<clang::Sema *>(S)->shouldIgnoreInHostDeviceCheck(
      reinterpret_cast<clang::FunctionDecl *>(Callee));
}

CXQualType clang_Sema_adjustMemberFunctionCC(CXSema S, CXQualType T, bool HasThisPointer,
                                             bool IsCtorOrDtor, CXSourceLocation_ Loc) {
  clang::QualType QT = clang::QualType::getFromOpaquePtr(T);
  reinterpret_cast<clang::Sema *>(S)->adjustMemberFunctionCC(
      QT, HasThisPointer, IsCtorOrDtor, clang::SourceLocation::getFromPtrEncoding(Loc));
  return reinterpret_cast<CXQualType>(QT.getAsOpaquePtr());
}

CXExpr clang_Sema_HandleExprEvaluationContextForTypeof(CXSema S, CXExpr E,
                                                       bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->HandleExprEvaluationContextForTypeof(
      reinterpret_cast<clang::Expr *>(E));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_tryConvertExprToType(CXSema S, CXExpr E, CXQualType Ty, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->tryConvertExprToType(
      reinterpret_cast<clang::Expr *>(E), clang::QualType::getFromOpaquePtr(Ty));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXCastKind clang_Sema_PrepareScalarCast(CXSema S, CXExpr Src, CXQualType DestTy,
                                        CXExpr *Adjusted) {
  clang::ExprResult E(reinterpret_cast<clang::Expr *>(Src));
  clang::CastKind CK = reinterpret_cast<clang::Sema *>(S)->PrepareScalarCast(
      E, clang::QualType::getFromOpaquePtr(DestTy));
  *Adjusted = E.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(E.get());
  return static_cast<CXCastKind>(CK);
}

CXExpr clang_Sema_MaybeCreateExprWithCleanups(CXSema S, CXExpr SubExpr) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::Sema *>(S)->MaybeCreateExprWithCleanups(
      reinterpret_cast<clang::Expr *>(SubExpr)));
}

CXStmt clang_Sema_MaybeCreateStmtWithCleanups(CXSema S, CXStmt SubStmt) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::Sema *>(S)->MaybeCreateStmtWithCleanups(
      reinterpret_cast<clang::Stmt *>(SubStmt)));
}

void clang_Sema_LoadExternalVTableUses(CXSema S) {
  reinterpret_cast<clang::Sema *>(S)->LoadExternalVTableUses();
}

CXString clang_Sema_EvaluateStaticAssertMessageAsString(CXSema S, CXExpr Message,
                                                        CXASTContext Ctx,
                                                        bool ErrorOnInvalidMessage,
                                                        bool *Ok) {
  std::string Str;
  *Ok = reinterpret_cast<clang::Sema *>(S)->EvaluateStaticAssertMessageAsString(
      reinterpret_cast<clang::Expr *>(Message), Str, *reinterpret_cast<clang::ASTContext *>(Ctx),
      ErrorOnInvalidMessage);
  return extra::makeCXString(Str);
}

bool clang_Sema_AreConstraintExpressionsEqual(CXSema S, CXNamedDecl Old, CXExpr OldConstr,
                                              CXNamedDecl New, CXExpr NewConstr) {
  return reinterpret_cast<clang::Sema *>(S)->AreConstraintExpressionsEqual(
      reinterpret_cast<clang::NamedDecl *>(Old), reinterpret_cast<clang::Expr *>(OldConstr),
      clang::Sema::TemplateCompareNewDeclInfo(reinterpret_cast<clang::NamedDecl *>(New)),
      reinterpret_cast<clang::Expr *>(NewConstr));
}

CXExpr clang_Sema_ImpCastExprToType(CXSema S, CXExpr E, CXQualType Type, CXCastKind CK,
                                    CXExprValueKind VK, CXCheckedConversionKind CCK,
                                    bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->ImpCastExprToType(
      reinterpret_cast<clang::Expr *>(E), clang::QualType::getFromOpaquePtr(Type),
      static_cast<clang::CastKind>(CK), static_cast<clang::ExprValueKind>(VK), nullptr,
      static_cast<clang::Sema::CheckedConversionKind>(CCK));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

bool clang_Sema_CheckArgsForPlaceholders(CXSema S, CXExpr *Args, unsigned NumArgs) {
  llvm::SmallVector<clang::Expr *, 8> Buf;
  Buf.reserve(NumArgs);
  for (unsigned I = 0; I != NumArgs; ++I)
    Buf.push_back(reinterpret_cast<clang::Expr *>(Args[I]));
  bool Failed = reinterpret_cast<clang::Sema *>(S)->CheckArgsForPlaceholders(Buf);
  for (unsigned I = 0; I != NumArgs; ++I)
    Args[I] = reinterpret_cast<CXExpr>(Buf[I]);
  return Failed;
}

CXAttr clang_Sema_CheckEnableIf(CXSema S, CXFunctionDecl Function,
                                CXSourceLocation_ CallLoc, const CXExpr *Args,
                                unsigned NumArgs, bool MissingImplicitThis) {
  llvm::SmallVector<clang::Expr *, 8> Buf;
  Buf.reserve(NumArgs);
  for (unsigned I = 0; I != NumArgs; ++I)
    Buf.push_back(reinterpret_cast<clang::Expr *>(Args[I]));
  return reinterpret_cast<CXAttr>(reinterpret_cast<clang::Sema *>(S)->CheckEnableIf(
      reinterpret_cast<clang::FunctionDecl *>(Function),
      clang::SourceLocation::getFromPtrEncoding(CallLoc), Buf, MissingImplicitThis));
}

bool clang_Sema_CheckAlignasTypeArgument(CXSema S, const char *KWName,
                                         CXTypeSourceInfo TInfo, CXSourceLocation_ OpLoc,
                                         CXSourceLocation_ R_begin,
                                         CXSourceLocation_ R_end) {
  return reinterpret_cast<clang::Sema *>(S)->CheckAlignasTypeArgument(
      llvm::StringRef(KWName), reinterpret_cast<clang::TypeSourceInfo *>(TInfo),
      clang::SourceLocation::getFromPtrEncoding(OpLoc),
      clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(R_begin),
                         clang::SourceLocation::getFromPtrEncoding(R_end)));
}

bool clang_Sema_CheckCXXThrowOperand(CXSema S, CXSourceLocation_ ThrowLoc,
                                     CXQualType ThrowTy, CXExpr E) {
  return reinterpret_cast<clang::Sema *>(S)->CheckCXXThrowOperand(
      clang::SourceLocation::getFromPtrEncoding(ThrowLoc),
      clang::QualType::getFromOpaquePtr(ThrowTy), reinterpret_cast<clang::Expr *>(E));
}

CXAccessResult clang_Sema_CheckMemberAccess(CXSema S, CXSourceLocation_ UseLoc,
                                            CXCXXRecordDecl NamingClass, CXNamedDecl Found,
                                            CXAccessSpecifier FoundAccess) {
  return static_cast<CXAccessResult>(reinterpret_cast<clang::Sema *>(S)->CheckMemberAccess(
      clang::SourceLocation::getFromPtrEncoding(UseLoc),
      reinterpret_cast<clang::CXXRecordDecl *>(NamingClass),
      clang::DeclAccessPair::make(reinterpret_cast<clang::NamedDecl *>(Found),
                                  static_cast<clang::AccessSpecifier>(FoundAccess))));
}

CXAccessResult clang_Sema_CheckStructuredBindingMemberAccess(
    CXSema S, CXSourceLocation_ UseLoc, CXCXXRecordDecl DecomposedClass, CXNamedDecl Field,
    CXAccessSpecifier FieldAccess) {
  return static_cast<CXAccessResult>(
      reinterpret_cast<clang::Sema *>(S)->CheckStructuredBindingMemberAccess(
          clang::SourceLocation::getFromPtrEncoding(UseLoc),
          reinterpret_cast<clang::CXXRecordDecl *>(DecomposedClass),
          clang::DeclAccessPair::make(reinterpret_cast<clang::NamedDecl *>(Field),
                                      static_cast<clang::AccessSpecifier>(FieldAccess))));
}

// CheckBitwiseOperands, CheckLogicalOperands -- not wrapped, see the header.

CXQualType clang_Sema_CheckConditionalOperands(CXSema S, CXExpr *Cond, CXExpr *LHS,
                                               CXExpr *RHS, CXExprValueKind *VK,
                                               CXExprObjectKind *OK,
                                               CXSourceLocation_ QuestionLoc) {
  clang::ExprResult C = reinterpret_cast<clang::Expr *>(*Cond);
  clang::ExprResult L = reinterpret_cast<clang::Expr *>(*LHS);
  clang::ExprResult R = reinterpret_cast<clang::Expr *>(*RHS);
  clang::ExprValueKind K = clang::VK_PRValue;
  clang::ExprObjectKind O = clang::OK_Ordinary;
  clang::QualType T = reinterpret_cast<clang::Sema *>(S)->CheckConditionalOperands(
      C, L, R, K, O, clang::SourceLocation::getFromPtrEncoding(QuestionLoc));
  *Cond = C.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(C.get());
  *LHS = L.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(L.get());
  *RHS = R.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(R.get());
  *VK = static_cast<CXExprValueKind>(K);
  *OK = static_cast<CXExprObjectKind>(O);
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

CXQualType clang_Sema_CXXCheckConditionalOperands(CXSema S, CXExpr *Cond, CXExpr *LHS,
                                                  CXExpr *RHS, CXExprValueKind *VK,
                                                  CXExprObjectKind *OK,
                                                  CXSourceLocation_ QuestionLoc) {
  clang::ExprResult C = reinterpret_cast<clang::Expr *>(*Cond);
  clang::ExprResult L = reinterpret_cast<clang::Expr *>(*LHS);
  clang::ExprResult R = reinterpret_cast<clang::Expr *>(*RHS);
  clang::ExprValueKind K = clang::VK_PRValue;
  clang::ExprObjectKind O = clang::OK_Ordinary;
  clang::QualType T = reinterpret_cast<clang::Sema *>(S)->CXXCheckConditionalOperands(
      C, L, R, K, O, clang::SourceLocation::getFromPtrEncoding(QuestionLoc));
  *Cond = C.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(C.get());
  *LHS = L.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(L.get());
  *RHS = R.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(R.get());
  *VK = static_cast<CXExprValueKind>(K);
  *OK = static_cast<CXExprObjectKind>(O);
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

CXQualType clang_Sema_CheckVectorConditionalTypes(CXSema S, CXExpr *Cond, CXExpr *LHS,
                                                  CXExpr *RHS,
                                                  CXSourceLocation_ QuestionLoc) {
  clang::ExprResult C = reinterpret_cast<clang::Expr *>(*Cond);
  clang::ExprResult L = reinterpret_cast<clang::Expr *>(*LHS);
  clang::ExprResult R = reinterpret_cast<clang::Expr *>(*RHS);
  clang::QualType T = reinterpret_cast<clang::Sema *>(S)->CheckVectorConditionalTypes(
      C, L, R, clang::SourceLocation::getFromPtrEncoding(QuestionLoc));
  *Cond = C.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(C.get());
  *LHS = L.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(L.get());
  *RHS = R.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(R.get());
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

CXQualType clang_Sema_CheckVectorOperands(CXSema S, CXExpr *LHS, CXExpr *RHS,
                                          CXSourceLocation_ Loc, bool IsCompAssign,
                                          bool AllowBothBool, bool AllowBoolConversion,
                                          bool AllowBoolOperation, bool ReportInvalid) {
  clang::ExprResult L = reinterpret_cast<clang::Expr *>(*LHS);
  clang::ExprResult R = reinterpret_cast<clang::Expr *>(*RHS);
  clang::QualType T = reinterpret_cast<clang::Sema *>(S)->CheckVectorOperands(
      L, R, clang::SourceLocation::getFromPtrEncoding(Loc), IsCompAssign, AllowBothBool,
      AllowBoolConversion, AllowBoolOperation, ReportInvalid);
  *LHS = L.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(L.get());
  *RHS = R.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(R.get());
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

CXQualType clang_Sema_CheckVectorCompareOperands(CXSema S, CXExpr *LHS, CXExpr *RHS,
                                                 CXSourceLocation_ Loc,
                                                 CXBinaryOperatorKind Opc) {
  clang::ExprResult L = reinterpret_cast<clang::Expr *>(*LHS);
  clang::ExprResult R = reinterpret_cast<clang::Expr *>(*RHS);
  clang::QualType T = reinterpret_cast<clang::Sema *>(S)->CheckVectorCompareOperands(
      L, R, clang::SourceLocation::getFromPtrEncoding(Loc),
      static_cast<clang::BinaryOperatorKind>(Opc));
  *LHS = L.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(L.get());
  *RHS = R.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(R.get());
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

CXQualType clang_Sema_CheckVectorLogicalOperands(CXSema S, CXExpr *LHS, CXExpr *RHS,
                                                 CXSourceLocation_ Loc) {
  clang::ExprResult L = reinterpret_cast<clang::Expr *>(*LHS);
  clang::ExprResult R = reinterpret_cast<clang::Expr *>(*RHS);
  clang::QualType T = reinterpret_cast<clang::Sema *>(S)->CheckVectorLogicalOperands(
      L, R, clang::SourceLocation::getFromPtrEncoding(Loc));
  *LHS = L.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(L.get());
  *RHS = R.isInvalid() ? nullptr : reinterpret_cast<CXExpr>(R.get());
  return reinterpret_cast<CXQualType>(T.getAsOpaquePtr());
}

CXFunctionDecl clang_Sema_CreateBuiltin(CXSema S, CXIdentifierInfo II, CXQualType Type,
                                        unsigned ID, CXSourceLocation_ Loc) {
  return reinterpret_cast<CXFunctionDecl>(reinterpret_cast<clang::Sema *>(S)->CreateBuiltin(
      reinterpret_cast<clang::IdentifierInfo *>(II), clang::QualType::getFromOpaquePtr(Type), ID,
      clang::SourceLocation::getFromPtrEncoding(Loc)));
}

CXRecordDecl clang_Sema_CreateCapturedStmtRecordDecl(CXSema S, CXCapturedDecl *CD,
                                                     CXSourceLocation_ Loc,
                                                     unsigned NumParams) {
  clang::CapturedDecl *Captured = nullptr;
  clang::RecordDecl *RD = reinterpret_cast<clang::Sema *>(S)->CreateCapturedStmtRecordDecl(
      Captured, clang::SourceLocation::getFromPtrEncoding(Loc), NumParams);
  *CD = reinterpret_cast<CXCapturedDecl>(Captured);
  return reinterpret_cast<CXRecordDecl>(RD);
}

CXExpr clang_Sema_BuildStmtExpr(CXSema S, CXSourceLocation_ LPLoc, CXStmt SubStmt,
                                CXSourceLocation_ RPLoc, unsigned TemplateDepth,
                                bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildStmtExpr(
      clang::SourceLocation::getFromPtrEncoding(LPLoc), reinterpret_cast<clang::Stmt *>(SubStmt),
      clang::SourceLocation::getFromPtrEncoding(RPLoc), TemplateDepth);
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXStmt clang_Sema_BuildMSDependentExistsStmt(CXSema S, CXSourceLocation_ KeywordLoc,
                                             bool IsIfExists,
                                             CXNestedNameSpecifierLoc QualifierLoc,
                                             CXDeclarationNameInfo NameInfo, CXStmt Nested,
                                             bool *IsInvalid) {
  clang::StmtResult R = reinterpret_cast<clang::Sema *>(S)->BuildMSDependentExistsStmt(
      clang::SourceLocation::getFromPtrEncoding(KeywordLoc), IsIfExists,
      *reinterpret_cast<clang::NestedNameSpecifierLoc *>(QualifierLoc),
      *reinterpret_cast<clang::DeclarationNameInfo *>(NameInfo),
      reinterpret_cast<clang::Stmt *>(Nested));
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXStmt>(R.isInvalid() ? nullptr : R.get());
}

CXQualType clang_Sema_BuildStdInitializerList(CXSema S, CXQualType Element,
                                              CXSourceLocation_ Loc) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->BuildStdInitializerList(clang::QualType::getFromOpaquePtr(Element),
                                clang::SourceLocation::getFromPtrEncoding(Loc))
      .getAsOpaquePtr());
}

CXNamedDecl clang_Sema_BuildUsingPackDecl(CXSema S, CXNamedDecl InstantiatedFrom,
                                          const CXNamedDecl *Expansions,
                                          unsigned NumExpansions) {
  llvm::SmallVector<clang::NamedDecl *, 4> Expanded;
  Expanded.reserve(NumExpansions);
  for (unsigned I = 0; I != NumExpansions; ++I)
    Expanded.push_back(reinterpret_cast<clang::NamedDecl *>(Expansions[I]));
  return reinterpret_cast<CXNamedDecl>(reinterpret_cast<clang::Sema *>(S)->BuildUsingPackDecl(
      reinterpret_cast<clang::NamedDecl *>(InstantiatedFrom), Expanded));
}

CXExpr clang_Sema_BuildCXXFoldExpr(CXSema S, CXUnresolvedLookupExpr Callee,
                                   CXSourceLocation_ LParenLoc, CXExpr LHS,
                                   CXBinaryOperatorKind Operator,
                                   CXSourceLocation_ EllipsisLoc, CXExpr RHS,
                                   CXSourceLocation_ RParenLoc, bool HasNumExpansions,
                                   unsigned NumExpansions, bool *IsInvalid) {
  clang::ExprResult R = reinterpret_cast<clang::Sema *>(S)->BuildCXXFoldExpr(
      reinterpret_cast<clang::UnresolvedLookupExpr *>(Callee),
      clang::SourceLocation::getFromPtrEncoding(LParenLoc), reinterpret_cast<clang::Expr *>(LHS),
      static_cast<clang::BinaryOperatorKind>(Operator),
      clang::SourceLocation::getFromPtrEncoding(EllipsisLoc),
      reinterpret_cast<clang::Expr *>(RHS), clang::SourceLocation::getFromPtrEncoding(RParenLoc),
      HasNumExpansions ? std::optional<unsigned>(NumExpansions) : std::nullopt);
  *IsInvalid = R.isInvalid();
  return reinterpret_cast<CXExpr>(R.isInvalid() ? nullptr : R.get());
}

CXExpr clang_Sema_BuildCXXThisExpr(CXSema S, CXSourceLocation_ Loc, CXQualType Type,
                                   bool IsImplicit) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::Sema *>(S)->BuildCXXThisExpr(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      clang::QualType::getFromOpaquePtr(Type), IsImplicit));
}

unsigned clang_Sema_getUndefinedButUsed(CXSema S, CXNamedDecl *Decls,
                                        CXSourceLocation_ *Locs, unsigned Capacity) {
  llvm::SmallVector<std::pair<clang::NamedDecl *, clang::SourceLocation>, 8> Undefined;
  reinterpret_cast<clang::Sema *>(S)->getUndefinedButUsed(Undefined);
  unsigned Total = static_cast<unsigned>(Undefined.size());
  if (Decls && Locs) {
    unsigned N = Capacity < Total ? Capacity : Total;
    for (unsigned I = 0; I != N; ++I) {
      Decls[I] = reinterpret_cast<CXNamedDecl>(Undefined[I].first);
      Locs[I] = reinterpret_cast<CXSourceLocation_>(Undefined[I].second.getPtrEncoding());
    }
  }
  return Total;
}

CXCanThrowResult clang_Sema_canCalleeThrow(CXSema S, CXExpr E, CXDecl D,
                                           CXSourceLocation_ Loc) {
  return static_cast<CXCanThrowResult>(clang::Sema::canCalleeThrow(
      *reinterpret_cast<clang::Sema *>(S), reinterpret_cast<clang::Expr *>(E),
      reinterpret_cast<clang::Decl *>(D), clang::SourceLocation::getFromPtrEncoding(Loc)));
}

CXTemplateNameKindForDiagnostics
clang_Sema_getTemplateNameKindForDiagnostics(CXSema S, CXTemplateName Name) {
  return static_cast<CXTemplateNameKindForDiagnostics>(
      reinterpret_cast<clang::Sema *>(S)->getTemplateNameKindForDiagnostics(
          clang::TemplateName::getFromVoidPointer(Name)));
}

CXNonTagKind clang_Sema_getNonTagTypeDeclKind(CXSema S, CXDecl D, CXTagTypeKind TTK) {
  return static_cast<CXNonTagKind>(reinterpret_cast<clang::Sema *>(S)->getNonTagTypeDeclKind(
      reinterpret_cast<clang::Decl *>(D), static_cast<clang::TagTypeKind>(TTK)));
}

CXFieldDecl clang_Sema_getSelfAssignmentClassMemberCandidate(CXSema S,
                                                             CXValueDecl SelfAssigned) {
  return reinterpret_cast<CXFieldDecl>(const_cast<clang::FieldDecl *>(
      reinterpret_cast<clang::Sema *>(S)->getSelfAssignmentClassMemberCandidate(
          reinterpret_cast<clang::ValueDecl *>(SelfAssigned))));
}

bool clang_Sema_CanUseDecl(CXSema S, CXNamedDecl D, bool TreatUnavailableAsInvalid) {
  return reinterpret_cast<clang::Sema *>(S)->CanUseDecl(reinterpret_cast<clang::NamedDecl *>(D),
                                                   TreatUnavailableAsInvalid);
}

bool clang_Sema_ShouldSplatAltivecScalarInCast(CXSema S, CXVectorType VecTy) {
  return reinterpret_cast<clang::Sema *>(S)->ShouldSplatAltivecScalarInCast(
      reinterpret_cast<clang::VectorType *>(VecTy));
}

bool clang_Sema_IsInvalidSMECallConversion(CXSema S, CXQualType FromType,
                                           CXQualType ToType) {
  return reinterpret_cast<clang::Sema *>(S)->IsInvalidSMECallConversion(
      clang::QualType::getFromOpaquePtr(FromType),
      clang::QualType::getFromOpaquePtr(ToType));
}

bool clang_Sema_hasAnyAcceptableTemplateNames(CXSema S, CXLookupResult R,
                                              bool AllowFunctionTemplates,
                                              bool AllowDependent,
                                              bool AllowNonTemplateFunctions) {
  return reinterpret_cast<clang::Sema *>(S)->hasAnyAcceptableTemplateNames(
      *reinterpret_cast<clang::LookupResult *>(R), AllowFunctionTemplates, AllowDependent,
      AllowNonTemplateFunctions);
}

CXTypeLoc clang_Sema_getReturnTypeLoc(CXSema S, CXFunctionDecl FD) {
  return reinterpret_cast<CXTypeLoc>(new clang::TypeLoc( // NOLINT(*-owning-memory)
      reinterpret_cast<clang::Sema *>(S)->getReturnTypeLoc(
          reinterpret_cast<clang::FunctionDecl *>(FD))));
}

CXClassTemplatePartialSpecializationDecl clang_Sema_getMoreSpecializedPartialSpecialization(
    CXSema S, CXClassTemplatePartialSpecializationDecl PS1,
    CXClassTemplatePartialSpecializationDecl PS2, CXSourceLocation_ Loc) {
  return reinterpret_cast<CXClassTemplatePartialSpecializationDecl>(reinterpret_cast<clang::Sema *>(S)->getMoreSpecializedPartialSpecialization(
      reinterpret_cast<clang::ClassTemplatePartialSpecializationDecl *>(PS1),
      reinterpret_cast<clang::ClassTemplatePartialSpecializationDecl *>(PS2),
      clang::SourceLocation::getFromPtrEncoding(Loc)));
}

bool clang_Sema_isMoreSpecializedThanPrimary(CXSema S,
                                             CXClassTemplatePartialSpecializationDecl T,
                                             CXTemplateDeductionInfo Info) {
  return reinterpret_cast<clang::Sema *>(S)->isMoreSpecializedThanPrimary(
      reinterpret_cast<clang::ClassTemplatePartialSpecializationDecl *>(T),
      *reinterpret_cast<clang::sema::TemplateDeductionInfo *>(Info));
}

bool clang_Sema_isInOpenMPDeclareVariantScope(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->isInOpenMPDeclareVariantScope();
}

bool clang_Sema_isInOpenMPDeclareTargetContext(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->isInOpenMPDeclareTargetContext();
}

CXIdentifierInfo clang_Sema_getNullabilityKeyword(CXSema S, CXNullabilityKind Nullability) {
  return reinterpret_cast<CXIdentifierInfo>(reinterpret_cast<clang::Sema *>(S)->getNullabilityKeyword(
      static_cast<clang::NullabilityKind>(Nullability)));
}

bool clang_Sema_isCFError(CXSema S, CXRecordDecl D) {
  return reinterpret_cast<clang::Sema *>(S)->isCFError(reinterpret_cast<clang::RecordDecl *>(D));
}

void clang_Sema_PushDeclContext(CXSema S, CXScope Sc, CXDeclContext DC) {
  reinterpret_cast<clang::Sema *>(S)->PushDeclContext(reinterpret_cast<clang::Scope *>(Sc),
                                                 reinterpret_cast<clang::DeclContext *>(DC));
}

void clang_Sema_PopDeclContext(CXSema S) {
  reinterpret_cast<clang::Sema *>(S)->PopDeclContext();
}

void clang_Sema_PushFunctionScope(CXSema S) {
  reinterpret_cast<clang::Sema *>(S)->PushFunctionScope();
}

void clang_Sema_PushBlockScope(CXSema S, CXScope BlockScope, CXBlockDecl Block) {
  reinterpret_cast<clang::Sema *>(S)->PushBlockScope(reinterpret_cast<clang::Scope *>(BlockScope),
                                                reinterpret_cast<clang::BlockDecl *>(Block));
}

void clang_Sema_PushCapturedRegionScope(CXSema S, CXScope RegionScope, CXCapturedDecl CD,
                                        CXRecordDecl RD, CXCapturedRegionKind K,
                                        unsigned OpenMPCaptureLevel) {
  reinterpret_cast<clang::Sema *>(S)->PushCapturedRegionScope(
      reinterpret_cast<clang::Scope *>(RegionScope), reinterpret_cast<clang::CapturedDecl *>(CD),
      reinterpret_cast<clang::RecordDecl *>(RD), static_cast<clang::CapturedRegionKind>(K),
      OpenMPCaptureLevel);
}

void clang_Sema_PushCompoundScope(CXSema S, bool IsStmtExpr) {
  reinterpret_cast<clang::Sema *>(S)->PushCompoundScope(IsStmtExpr);
}

void clang_Sema_PopCompoundScope(CXSema S) {
  reinterpret_cast<clang::Sema *>(S)->PopCompoundScope();
}

void clang_Sema_PushExpressionEvaluationContext(CXSema S,
                                                CXExpressionEvaluationContext NewContext,
                                                CXDecl LambdaContextDecl,
                                                CXExpressionKind Type) {
  reinterpret_cast<clang::Sema *>(S)->PushExpressionEvaluationContext(
      static_cast<clang::Sema::ExpressionEvaluationContext>(NewContext),
      reinterpret_cast<clang::Decl *>(LambdaContextDecl),
      static_cast<clang::Sema::ExpressionEvaluationContextRecord::ExpressionKind>(Type));
}

void clang_Sema_PopExpressionEvaluationContext(CXSema S) {
  reinterpret_cast<clang::Sema *>(S)->PopExpressionEvaluationContext();
}

void clang_Sema_PushForceCUDAHostDevice(CXSema S) {
  reinterpret_cast<clang::Sema *>(S)->PushForceCUDAHostDevice();
}

bool clang_Sema_PopForceCUDAHostDevice(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->PopForceCUDAHostDevice();
}

void clang_Sema_PopPragmaVisibility(CXSema S, bool IsNamespaceEnd,
                                    CXSourceLocation_ EndLoc) {
  reinterpret_cast<clang::Sema *>(S)->PopPragmaVisibility(
      IsNamespaceEnd, clang::SourceLocation::getFromPtrEncoding(EndLoc));
}

void clang_Sema_PushOnScopeChains(CXSema S, CXNamedDecl D, CXScope Sc, bool AddToContext) {
  reinterpret_cast<clang::Sema *>(S)->PushOnScopeChains(
      reinterpret_cast<clang::NamedDecl *>(D), reinterpret_cast<clang::Scope *>(Sc), AddToContext);
}

void clang_Sema_PushUsingDirective(CXSema S, CXScope Sc, CXUsingDirectiveDecl UDir) {
  reinterpret_cast<clang::Sema *>(S)->PushUsingDirective(
      reinterpret_cast<clang::Scope *>(Sc), reinterpret_cast<clang::UsingDirectiveDecl *>(UDir));
}

void clang_Sema_PushNamespaceVisibilityAttr(CXSema S, CXVisibilityAttr Attr,
                                            CXSourceLocation_ Loc) {
  reinterpret_cast<clang::Sema *>(S)->PushNamespaceVisibilityAttr(
      reinterpret_cast<clang::VisibilityAttr *>(Attr),
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXCXXRecordDecl clang_Sema_getCurrentInstantiationOf(CXSema S, CXNestedNameSpecifier NNS) {
  return reinterpret_cast<CXCXXRecordDecl>(reinterpret_cast<clang::Sema *>(S)->getCurrentInstantiationOf(
      reinterpret_cast<clang::NestedNameSpecifier *>(NNS)));
}

CXDefaultedComparisonKind clang_Sema_getDefaultedComparisonKind(CXSema S,
                                                                CXFunctionDecl FD) {
  return static_cast<CXDefaultedComparisonKind>(
      reinterpret_cast<clang::Sema *>(S)->getDefaultedComparisonKind(
          reinterpret_cast<clang::FunctionDecl *>(FD)));
}

CXScope clang_Sema_getNonFieldDeclScope(CXSema S, CXScope Sc) {
  return reinterpret_cast<CXScope>(reinterpret_cast<clang::Sema *>(S)->getNonFieldDeclScope(
      reinterpret_cast<clang::Scope *>(Sc)));
}

CXNamespaceDecl clang_Sema_getOrCreateStdNamespace(CXSema S) {
  return reinterpret_cast<CXNamespaceDecl>(reinterpret_cast<clang::Sema *>(S)->getOrCreateStdNamespace());
}

CXModule_ clang_Sema_getOwningModule(CXSema S, CXDecl Entity) {
  return reinterpret_cast<CXModule_>(reinterpret_cast<clang::Sema *>(S)->getOwningModule(reinterpret_cast<clang::Decl *>(Entity)));
}

CXScope clang_Sema_getScopeForDeclContext(CXScope Sc, CXDeclContext DC) {
  return reinterpret_cast<CXScope>(clang::Sema::getScopeForDeclContext(reinterpret_cast<clang::Scope *>(Sc),
                                             reinterpret_cast<clang::DeclContext *>(DC)));
}

unsigned clang_Sema_getTemplateDepth(CXSema S, CXScope Sc) {
  return reinterpret_cast<clang::Sema *>(S)->getTemplateDepth(reinterpret_cast<clang::Scope *>(Sc));
}

CXModuleLoader clang_Sema_getModuleLoader(CXSema S) {
  return reinterpret_cast<CXModuleLoader>(&reinterpret_cast<clang::Sema *>(S)->getModuleLoader());
}

CXQualType clang_Sema_getCapturedDeclRefType(CXSema S, CXValueDecl Var,
                                             CXSourceLocation_ Loc) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Sema *>(S)
      ->getCapturedDeclRefType(reinterpret_cast<clang::ValueDecl *>(Var),
                               clang::SourceLocation::getFromPtrEncoding(Loc))
      .getAsOpaquePtr());
}

CXAttr clang_Sema_getImplicitCodeSegOrSectionAttrForFunction(CXSema S, CXFunctionDecl FD,
                                                             bool IsDefinition) {
  return reinterpret_cast<CXAttr>(reinterpret_cast<clang::Sema *>(S)->getImplicitCodeSegOrSectionAttrForFunction(
      reinterpret_cast<clang::FunctionDecl *>(FD), IsDefinition));
}

bool clang_Sema_isAcceptable(CXSema S, CXNamedDecl D, CXAcceptableKind Kind) {
  return reinterpret_cast<clang::Sema *>(S)->isAcceptable(
      reinterpret_cast<clang::NamedDecl *>(D), static_cast<clang::Sema::AcceptableKind>(Kind));
}

bool clang_Sema_hasAcceptableDefinition(CXSema S, CXNamedDecl D, CXNamedDecl *Suggested,
                                        CXAcceptableKind Kind, bool OnlyNeedComplete) {
  clang::NamedDecl *Hidden = nullptr;
  bool Result = reinterpret_cast<clang::Sema *>(S)->hasAcceptableDefinition(
      reinterpret_cast<clang::NamedDecl *>(D), &Hidden,
      static_cast<clang::Sema::AcceptableKind>(Kind), OnlyNeedComplete);
  // Hidden is only written on the false path; zero it otherwise so the out-parameter is
  // never a stale stack value the caller could mistake for a suggestion.
  *Suggested = reinterpret_cast<CXNamedDecl>(Result ? nullptr : Hidden);
  return Result;
}

bool clang_Sema_areMatrixTypesOfTheSameDimension(CXSema S, CXQualType SrcTy,
                                                 CXQualType DestTy) {
  return reinterpret_cast<clang::Sema *>(S)->areMatrixTypesOfTheSameDimension(
      clang::QualType::getFromOpaquePtr(SrcTy), clang::QualType::getFromOpaquePtr(DestTy));
}

CXString clang_Sema_getTemplateArgumentBindingsText(CXSema S, CXTemplateParameterList Params,
                                                    CXTemplateArgumentList Args) {
  return extra::makeCXString(
      reinterpret_cast<clang::Sema *>(S)->getTemplateArgumentBindingsText(
          reinterpret_cast<clang::TemplateParameterList *>(Params),
          *reinterpret_cast<clang::TemplateArgumentList *>(Args)));
}

bool clang_Sema_getFullyPackExpandedSize(CXSema S, CXTemplateArgument Arg, unsigned *Size) {
  std::optional<unsigned> N = reinterpret_cast<clang::Sema *>(S)->getFullyPackExpandedSize(
      *reinterpret_cast<clang::TemplateArgument *>(Arg));
  if (!N)
    return false;
  *Size = *N;
  return true;
}

unsigned clang_Sema_getCurFPFeatures(CXSema S) {
  return reinterpret_cast<clang::Sema *>(S)->getCurFPFeatures().getAsOpaqueInt();
}

bool clang_Sema_isTemplateTemplateParameterAtLeastAsSpecializedAs(
    CXSema S, CXTemplateParameterList PParam, CXTemplateDecl AArg,
    CXSourceLocation_ Loc) {
  return reinterpret_cast<clang::Sema *>(S)->isTemplateTemplateParameterAtLeastAsSpecializedAs(
      reinterpret_cast<clang::TemplateParameterList *>(PParam),
      reinterpret_cast<clang::TemplateDecl *>(AArg),
      clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXTemplateArgumentLoc clang_Sema_getIdentityTemplateArgumentLoc(CXSema S, CXNamedDecl Param,
                                                                CXSourceLocation_ Location) {
  return reinterpret_cast<CXTemplateArgumentLoc>(std::make_unique<clang::TemplateArgumentLoc>(
             reinterpret_cast<clang::Sema *>(S)->getIdentityTemplateArgumentLoc(
                 reinterpret_cast<clang::NamedDecl *>(Param),
                 clang::SourceLocation::getFromPtrEncoding(Location)))
      .release());
}

CXTemplateArgumentLoc clang_Sema_getTemplateArgumentPackExpansionPattern(
    CXSema S, CXTemplateArgumentLoc OrigLoc, CXSourceLocation_ *Ellipsis,
    bool *HasNumExpansions, unsigned *NumExpansions) {
  clang::SourceLocation E;
  std::optional<unsigned> N;
  clang::TemplateArgumentLoc R =
      reinterpret_cast<clang::Sema *>(S)->getTemplateArgumentPackExpansionPattern(
          *reinterpret_cast<clang::TemplateArgumentLoc *>(OrigLoc), E, N);
  if (Ellipsis)
    *Ellipsis = reinterpret_cast<CXSourceLocation_>(E.getPtrEncoding());
  if (HasNumExpansions)
    *HasNumExpansions = N.has_value();
  if (NumExpansions && N)
    *NumExpansions = *N;
  return reinterpret_cast<CXTemplateArgumentLoc>(std::make_unique<clang::TemplateArgumentLoc>(R).release());
}

void clang_TemplateArgumentLoc_dispose(CXTemplateArgumentLoc TAL) {
  delete reinterpret_cast<clang::TemplateArgumentLoc *>(TAL);
}

bool clang_Sema_IsPointerConversion(CXSema S, CXExpr From, CXQualType FromType,
                                    CXQualType ToType, bool InOverloadResolution,
                                    CXQualType *ConvertedType, bool *IncompatibleObjC) {
  clang::QualType Converted;
  bool Incompatible = false;
  bool R = reinterpret_cast<clang::Sema *>(S)->IsPointerConversion(
      reinterpret_cast<clang::Expr *>(From), clang::QualType::getFromOpaquePtr(FromType),
      clang::QualType::getFromOpaquePtr(ToType), InOverloadResolution, Converted,
      Incompatible);
  if (ConvertedType)
    *ConvertedType = reinterpret_cast<CXQualType>(Converted.getAsOpaquePtr());
  if (IncompatibleObjC)
    *IncompatibleObjC = Incompatible;
  return R;
}

CXFunctionTemplateDecl clang_Sema_getMoreSpecializedTemplate(
    CXSema S, CXFunctionTemplateDecl FT1, CXFunctionTemplateDecl FT2, CXSourceLocation_ Loc,
    CXTPOC TPOC, unsigned NumCallArguments1, unsigned NumCallArguments2, bool Reversed) {
  return reinterpret_cast<CXFunctionTemplateDecl>(reinterpret_cast<clang::Sema *>(S)->getMoreSpecializedTemplate(
      reinterpret_cast<clang::FunctionTemplateDecl *>(FT1),
      reinterpret_cast<clang::FunctionTemplateDecl *>(FT2),
      clang::SourceLocation::getFromPtrEncoding(Loc),
      clang::TemplatePartialOrderingContext(static_cast<clang::TPOC>(TPOC)),
      NumCallArguments1, NumCallArguments2, Reversed));
}

bool clang_Sema_getFormatStringInfo(CXFormatAttr Format, bool IsCXXMember, bool IsVariadic,
                                    unsigned *FormatIdx, unsigned *FirstDataArg,
                                    CXFormatArgumentPassingKind *ArgPassingKind) {
  clang::Sema::FormatStringInfo FSI;
  bool R = clang::Sema::getFormatStringInfo(reinterpret_cast<clang::FormatAttr *>(Format),
                                            IsCXXMember, IsVariadic, &FSI);
  if (FormatIdx)
    *FormatIdx = FSI.FormatIdx;
  if (FirstDataArg)
    *FirstDataArg = FSI.FirstDataArg;
  if (ArgPassingKind)
    *ArgPassingKind = static_cast<CXFormatArgumentPassingKind>(FSI.ArgPassingKind);
  return R;
}

void clang_Sema_DefineDefaultedComparison(CXSema S, CXSourceLocation_ Loc,
                                          CXFunctionDecl FD,
                                          CXDefaultedComparisonKind DCK) {
  reinterpret_cast<clang::Sema *>(S)->DefineDefaultedComparison(
      clang::SourceLocation::getFromPtrEncoding(Loc),
      reinterpret_cast<clang::FunctionDecl *>(FD),
      static_cast<clang::Sema::DefaultedComparisonKind>(DCK));
}

CXMultiLevelTemplateArgumentList clang_Sema_getTemplateInstantiationArgs(
    CXSema S, CXNamedDecl D, CXDeclContext DC, bool Final, CXTemplateArgumentList Innermost,
    bool RelativeToPrimary, CXFunctionDecl Pattern, bool ForConstraintInstantiation,
    bool SkipForSpecialization) {
  return reinterpret_cast<CXMultiLevelTemplateArgumentList>(std::make_unique<clang::MultiLevelTemplateArgumentList>(
             reinterpret_cast<clang::Sema *>(S)->getTemplateInstantiationArgs(
                 reinterpret_cast<clang::NamedDecl *>(D),
                 reinterpret_cast<clang::DeclContext *>(DC), Final,
                 reinterpret_cast<clang::TemplateArgumentList *>(Innermost), RelativeToPrimary,
                 reinterpret_cast<clang::FunctionDecl *>(Pattern), ForConstraintInstantiation,
                 SkipForSpecialization))
      .release());
}

CXFunctionDecl clang_Sema_resolveAddressOfSingleOverloadCandidate(
    CXSema S, CXExpr E, CXNamedDecl *FoundDecl, CXAccessSpecifier *FoundAccess) {
  clang::DeclAccessPair Found;
  clang::FunctionDecl *R =
      reinterpret_cast<clang::Sema *>(S)->resolveAddressOfSingleOverloadCandidate(
          reinterpret_cast<clang::Expr *>(E), Found);
  if (FoundDecl)
    *FoundDecl = reinterpret_cast<CXNamedDecl>(Found.getDecl());
  if (FoundAccess)
    *FoundAccess = static_cast<CXAccessSpecifier>(Found.getAccess());
  return reinterpret_cast<CXFunctionDecl>(R);
}

bool clang_Sema_IsValueInFlagEnum(CXSema S, CXEnumDecl ED, LLVMGenericValueRef Val,
                                  bool AllowMask) {
  return reinterpret_cast<clang::Sema *>(S)->IsValueInFlagEnum(
      reinterpret_cast<clang::EnumDecl *>(ED),
      reinterpret_cast<llvm::GenericValue *>(Val)->IntVal, AllowMask);
}

CXPrintingPolicy_ clang_Sema_getPrintingPolicy(CXSema S) {
  // Returned by value, so the box is the caller's; the ASTContext getter borrows instead.
  auto P = std::make_unique<clang::PrintingPolicy>(
      reinterpret_cast<clang::Sema *>(S)->getPrintingPolicy());
  return reinterpret_cast<CXPrintingPolicy_>(P.release());
}

