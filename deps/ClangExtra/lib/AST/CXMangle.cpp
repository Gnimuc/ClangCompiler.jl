#include "clang-ex/AST/CXMangle.h"
#include "libclang/CXString.h"
#include "clang/AST/Mangle.h"

// MangleContext
CXMangleContext_ManglerKind clang_MangleContext_getKind(CXMangleContext MC) {
  return static_cast<CXMangleContext_ManglerKind>(
      static_cast<clang::MangleContext *>(MC)->getKind());
}

CXASTContext clang_MangleContext_getASTContext(CXMangleContext MC) {
  return &static_cast<clang::MangleContext *>(MC)->getASTContext();
}

CXDiagnosticsEngine clang_MangleContext_getDiags(CXMangleContext MC) {
  return &static_cast<clang::MangleContext *>(MC)->getDiags();
}

// startNewFunction
// getBlockId

uint64_t clang_MangleContext_getAnonymousStructId(CXMangleContext MC, CXNamedDecl D) {
  return static_cast<clang::MangleContext *>(MC)->getAnonymousStructId(
      static_cast<clang::NamedDecl *>(D));
}

bool clang_MangleContext_shouldMangleDeclName(CXMangleContext MC, CXNamedDecl D) {
  return static_cast<clang::MangleContext *>(MC)->shouldMangleDeclName(
      static_cast<clang::NamedDecl *>(D));
}

bool clang_MangleContext_shouldMangleCXXName(CXMangleContext MC, CXNamedDecl D) {
  return static_cast<clang::MangleContext *>(MC)->shouldMangleCXXName(
      static_cast<clang::NamedDecl *>(D));
}

bool clang_MangleContext_shouldMangleStringLiteral(CXMangleContext MC, CXStringLiteral SL) {
  return static_cast<clang::MangleContext *>(MC)->shouldMangleStringLiteral(
      static_cast<clang::StringLiteral *>(SL));
}

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

CXString clang_ASTNameGenerator_getName(CXASTNameGenerator G, CXDecl D) {
  return clang::cxstring::createDup(
      static_cast<clang::ASTNameGenerator *>(G)->getName(static_cast<clang::Decl *>(D)));
}

CXStringSet *clang_ASTNameGenerator_getAllManglings(CXASTNameGenerator G, CXDecl D) {
  return clang::cxstring::createSet(
      static_cast<clang::ASTNameGenerator *>(G)->getAllManglings(
          static_cast<clang::Decl *>(D)));
}