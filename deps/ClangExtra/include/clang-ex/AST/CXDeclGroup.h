#ifndef LIBCLANGEX_CXDECLGROUP_H
#define LIBCLANGEX_CXDECLGROUP_H

#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

CINDEX_LINKAGE CXDeclGroupRef clang_DeclGroupRef_fromeDecl(CXDecl D);

CINDEX_LINKAGE bool clang_DeclGroupRef_isNull(CXDeclGroupRef DG);

CINDEX_LINKAGE bool clang_DeclGroupRef_isSingleDecl(CXDeclGroupRef DG);

CINDEX_LINKAGE bool clang_DeclGroupRef_isDeclGroup(CXDeclGroupRef DG);

CINDEX_LINKAGE CXDecl clang_DeclGroupRef_getSingleDecl(CXDeclGroupRef DG);

#ifdef __cplusplus
}
#endif
#endif