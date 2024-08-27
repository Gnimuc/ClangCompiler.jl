#include "clang-ex/Sema/CXSema.h"
#include "clang/CodeGen/ModuleBuilder.h"
#include "clang/Sema/Sema.h"

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