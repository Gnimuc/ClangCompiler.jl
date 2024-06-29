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

bool clang_Sema_LookupParsedName(CXSema S, CXLookupResult R, CXScope Sp, CXCXXScopeSpec SS,
                                 bool AllowBuiltinCreation, bool EnteringContext) {
  return static_cast<clang::Sema *>(S)->LookupParsedName(
      *static_cast<clang::LookupResult *>(R), static_cast<clang::Scope *>(Sp),
      static_cast<clang::CXXScopeSpec *>(SS), AllowBuiltinCreation, EnteringContext);
}

bool clang_Sema_LookupName(CXSema S, CXLookupResult R, CXScope Sp,
                           bool AllowBuiltinCreation) {
  return static_cast<clang::Sema *>(S)->LookupName(*static_cast<clang::LookupResult *>(R),
                                                   static_cast<clang::Scope *>(Sp),
                                                   AllowBuiltinCreation);
}

void clang_Sema_processWeakTopLevelDecls(CXSema Sema, CXCodeGenerator CodeGen) {
  auto S = static_cast<clang::Sema *>(Sema);
  auto CG = static_cast<clang::CodeGenerator *>(CodeGen);
  for (clang::Decl *D : S->WeakTopLevelDecls())
    CG->HandleTopLevelDecl(clang::DeclGroupRef(D));
}