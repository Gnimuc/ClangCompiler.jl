#ifndef LLVM_CLANG_C_EXTRA_CXSEMA_H
#define LLVM_CLANG_C_EXTRA_CXSEMA_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

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

LLVM_CLANG_C_EXTERN_C_END

#endif