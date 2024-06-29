#ifndef LIBCLANGEX_CXSEMA_H
#define LIBCLANGEX_CXSEMA_H

#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE void clang_Sema_setCollectStats(CXSema S, bool ShouldCollect);

CINDEX_LINKAGE void clang_Sema_PrintStats(CXSema S);

CINDEX_LINKAGE void clang_Sema_RestoreNestedNameSpecifierAnnotation(
    CXSema S, void *Annotation, CXSourceLocation_ AnnotationRange_begin,
    CXSourceLocation_ AnnotationRange_end, CXCXXScopeSpec SS);

CINDEX_LINKAGE bool clang_Sema_LookupParsedName(CXSema S, CXLookupResult R, CXScope Sp,
                                                CXCXXScopeSpec SS,
                                                bool AllowBuiltinCreation,
                                                bool EnteringContext);

CINDEX_LINKAGE bool clang_Sema_LookupName(CXSema S, CXLookupResult R, CXScope Sp,
                                          bool AllowBuiltinCreation);

CINDEX_LINKAGE void clang_Sema_processWeakTopLevelDecls(CXSema Sema,
                                                        CXCodeGenerator CodeGen);

#ifdef __cplusplus
}
#endif
#endif