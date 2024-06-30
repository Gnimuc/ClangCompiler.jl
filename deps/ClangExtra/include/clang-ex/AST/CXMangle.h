#ifndef LLVM_CLANG_C_EXTRA_CXMANGLE_H
#define LLVM_CLANG_C_EXTRA_CXMANGLE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

typedef enum CXMangleContext_ManglerKind {
  CXMangleContext_MK_Itanium,
  CXMangleContext_MK_Microsoft
} CXMangleContext_ManglerKind;

// MangleContext
CXMangleContext_ManglerKind clang_MangleContext_getKind(CXMangleContext MC);

CXASTContext clang_MangleContext_getASTContext(CXMangleContext MC);

CXDiagnosticsEngine clang_MangleContext_getDiags(CXMangleContext MC);

// startNewFunction
// getBlockId

uint64_t clang_MangleContext_getAnonymousStructId(CXMangleContext MC, CXNamedDecl D);

bool clang_MangleContext_shouldMangleDeclName(CXMangleContext MC, CXNamedDecl D);

bool clang_MangleContext_shouldMangleCXXName(CXMangleContext MC, CXNamedDecl D);

bool clang_MangleContext_shouldMangleStringLiteral(CXMangleContext MC, CXStringLiteral SL);

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

CXString clang_ASTNameGenerator_getName(CXASTNameGenerator G, CXDecl D);

CXStringSet *clang_ASTNameGenerator_getAllManglings(CXASTNameGenerator G, CXDecl D);

LLVM_CLANG_C_EXTERN_C_END

#endif