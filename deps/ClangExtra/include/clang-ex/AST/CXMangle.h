#ifndef LIBCLANGEX_CXMANGLE_H
#define LIBCLANGEX_CXMANGLE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

typedef enum CXMangleContext_ManglerKind {
  CXMangleContext_MK_Itanium,
  CXMangleContext_MK_Microsoft
} CXMangleContext_ManglerKind;

// MangleContext
CINDEX_LINKAGE CXMangleContext_ManglerKind clang_MangleContext_getKind(CXMangleContext MC);

CINDEX_LINKAGE CXASTContext clang_MangleContext_getASTContext(CXMangleContext MC);

CINDEX_LINKAGE CXDiagnosticsEngine clang_MangleContext_getDiags(CXMangleContext MC);

// startNewFunction
// getBlockId

CINDEX_LINKAGE uint64_t clang_MangleContext_getAnonymousStructId(CXMangleContext MC, CXNamedDecl D);

CINDEX_LINKAGE bool clang_MangleContext_shouldMangleDeclName(CXMangleContext MC, CXNamedDecl D);

CINDEX_LINKAGE bool clang_MangleContext_shouldMangleCXXName(CXMangleContext MC, CXNamedDecl D);

CINDEX_LINKAGE bool clang_MangleContext_shouldMangleStringLiteral(CXMangleContext MC, CXStringLiteral SL);

// mangleName
// mangleCXXName
// mangleCXXDtorThunk
// mangleReferenceTemporary
// mangleCXXRTTI
// mangleCXXRTTIName
// mangleStringLiteral
// mangleMSGuidDecl
// mangleGlobalBlock
// mangleCtorBlock
// mangleDtorBlock
// mangleBlock
// mangleObjCMethodName
// mangleObjCMethodNameAsSourceName
// mangleStaticGuardVariable
// mangleStaticGuardVariable
// mangleDynamicInitializer
// mangleDynamicAtExitDestructor
// mangleSEHFilterExpression
// mangleSEHFinallyBlock
// mangleTypeName

// ItaniumMangleContext
// mangleCXXVTable
// mangleCXXVTT
// mangleCXXCtorVTable
// mangleItaniumThreadLocalInit
// mangleItaniumThreadLocalWrapper
// mangleCXXCtorComdat
// mangleCXXDtorComdat
// mangleLambdaSig
// mangleDynamicStermFinalizer

// MicrosoftMangleContext
// mangleCXXVFTable
// mangleCXXVBTable
// mangleThreadSafeStaticGuardVariable
// mangleVirtualMemPtrThunk
// mangleCXXVirtualDisplacementMap
// mangleCXXThrowInfo
// mangleCXXCatchableTypeArray
// mangleCXXCatchableType
// mangleCXXRTTIBaseClassDescriptor
// mangleCXXRTTIBaseClassArray
// mangleCXXRTTIClassHierarchyDescriptor
// mangleCXXRTTICompleteObjectLocator

// ASTNameGenerator
// writeName

CINDEX_LINKAGE CXString clang_ASTNameGenerator_getName(CXASTNameGenerator G, CXDecl D);

CINDEX_LINKAGE CXStringSet *clang_ASTNameGenerator_getAllManglings(CXASTNameGenerator G, CXDecl D);

#ifdef __cplusplus
}
#endif
#endif