#include "clang-ex/AST/CXMangle.h"
#include "utils.h"
#include "clang/AST/GlobalDecl.h"
#include "clang/AST/Mangle.h"
#include "llvm/Support/raw_ostream.h"
#include "clang/AST/DeclCXX.h"
#include "clang/Basic/Module.h"

// MangleContext
void clang_MangleContext_dispose(CXMangleContext MC) {
  delete reinterpret_cast<clang::MangleContext *>(MC);
}

CXMangleContext_ManglerKind clang_MangleContext_getKind(CXMangleContext MC) {
  return static_cast<CXMangleContext_ManglerKind>(
      reinterpret_cast<clang::MangleContext *>(MC)->getKind());
}

CXASTContext clang_MangleContext_getASTContext(CXMangleContext MC) {
  return reinterpret_cast<CXASTContext>(&reinterpret_cast<clang::MangleContext *>(MC)->getASTContext());
}

CXDiagnosticsEngine clang_MangleContext_getDiags(CXMangleContext MC) {
  return reinterpret_cast<CXDiagnosticsEngine>(&reinterpret_cast<clang::MangleContext *>(MC)->getDiags());
}

// startNewFunction
// getBlockId

uint64_t clang_MangleContext_getAnonymousStructId(CXMangleContext MC, CXNamedDecl D) {
  return reinterpret_cast<clang::MangleContext *>(MC)->getAnonymousStructId(
      reinterpret_cast<clang::NamedDecl *>(D));
}

bool clang_MangleContext_shouldMangleDeclName(CXMangleContext MC, CXNamedDecl D) {
  return reinterpret_cast<clang::MangleContext *>(MC)->shouldMangleDeclName(
      reinterpret_cast<clang::NamedDecl *>(D));
}

CXString clang_MangleContext_mangleName(CXMangleContext MC, CXNamedDecl D) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::MangleContext *>(MC)->mangleName(
      clang::GlobalDecl(reinterpret_cast<clang::NamedDecl *>(D)), OS);
  return extra::makeCXString(OS.str());
}

bool clang_MangleContext_shouldMangleCXXName(CXMangleContext MC, CXNamedDecl D) {
  return reinterpret_cast<clang::MangleContext *>(MC)->shouldMangleCXXName(
      reinterpret_cast<clang::NamedDecl *>(D));
}

bool clang_MangleContext_shouldMangleStringLiteral(CXMangleContext MC, CXStringLiteral SL) {
  return reinterpret_cast<clang::MangleContext *>(MC)->shouldMangleStringLiteral(
      reinterpret_cast<clang::StringLiteral *>(SL));
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

bool clang_MangleContext_isAux(CXMangleContext MC) {
  return reinterpret_cast<clang::MangleContext *>(MC)->isAux();
}

void clang_MangleContext_startNewFunction(CXMangleContext MC) {
  reinterpret_cast<clang::MangleContext *>(MC)->startNewFunction();
}

uint64_t clang_MangleContext_getAnonymousStructIdForDebugInfo(CXMangleContext MC,
                                                              CXNamedDecl D) {
  return reinterpret_cast<clang::MangleContext *>(MC)->getAnonymousStructIdForDebugInfo(
      reinterpret_cast<clang::NamedDecl *>(D));
}

CXString clang_MangleContext_mangleCXXRTTIName(CXMangleContext MC, CXQualType T,
                                               bool NormalizeIntegers) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::MangleContext *>(MC)->mangleCXXRTTIName(
      clang::QualType::getFromOpaquePtr(T), OS, NormalizeIntegers);
  return extra::makeCXString(OS.str());
}

CXString clang_MangleContext_mangleCanonicalTypeName(CXMangleContext MC, CXQualType T,
                                                     bool NormalizeIntegers) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::MangleContext *>(MC)->mangleCanonicalTypeName(
      clang::QualType::getFromOpaquePtr(T), OS, NormalizeIntegers);
  return extra::makeCXString(OS.str());
}

bool clang_MangleContext_isUniqueInternalLinkageDecl(CXMangleContext MC, CXNamedDecl ND) {
  return reinterpret_cast<clang::MangleContext *>(MC)->isUniqueInternalLinkageDecl(
      reinterpret_cast<clang::NamedDecl *>(ND));
}

void clang_MangleContext_needsUniqueInternalLinkageNames(CXMangleContext MC) {
  reinterpret_cast<clang::MangleContext *>(MC)->needsUniqueInternalLinkageNames();
}

CXString clang_MangleContext_getLambdaString(CXMangleContext MC, CXCXXRecordDecl Lambda) {
  return extra::makeCXString(reinterpret_cast<clang::MangleContext *>(MC)->getLambdaString(
      reinterpret_cast<clang::CXXRecordDecl *>(Lambda)));
}

CXString clang_MangleContext_mangleCXXRTTI(CXMangleContext MC, CXQualType T) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::MangleContext *>(MC)->mangleCXXRTTI(
      clang::QualType::getFromOpaquePtr(T), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_MangleContext_mangleStaticGuardVariable(CXMangleContext MC, CXVarDecl D) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::MangleContext *>(MC)->mangleStaticGuardVariable(
      reinterpret_cast<clang::VarDecl *>(D), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_MangleContext_mangleDynamicInitializer(CXMangleContext MC, CXVarDecl D) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::MangleContext *>(MC)->mangleDynamicInitializer(
      reinterpret_cast<clang::VarDecl *>(D), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_MangleContext_mangleCXXName(CXMangleContext MC, CXNamedDecl D) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::MangleContext *>(MC)->mangleCXXName(
      clang::GlobalDecl(reinterpret_cast<clang::NamedDecl *>(D)), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_MangleContext_mangleReferenceTemporary(CXMangleContext MC, CXVarDecl D,
                                                      unsigned ManglingNumber) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::MangleContext *>(MC)->mangleReferenceTemporary(
      reinterpret_cast<clang::VarDecl *>(D), ManglingNumber, OS);
  return extra::makeCXString(OS.str());
}

CXString clang_MangleContext_mangleDynamicAtExitDestructor(CXMangleContext MC,
                                                           CXVarDecl D) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::MangleContext *>(MC)->mangleDynamicAtExitDestructor(
      reinterpret_cast<clang::VarDecl *>(D), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_MangleContext_mangleSEHFilterExpression(CXMangleContext MC,
                                                       CXFunctionDecl EnclosingDecl) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::MangleContext *>(MC)->mangleSEHFilterExpression(
      clang::GlobalDecl(reinterpret_cast<clang::FunctionDecl *>(EnclosingDecl)), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_MangleContext_mangleSEHFinallyBlock(CXMangleContext MC,
                                                   CXFunctionDecl EnclosingDecl) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::MangleContext *>(MC)->mangleSEHFinallyBlock(
      clang::GlobalDecl(reinterpret_cast<clang::FunctionDecl *>(EnclosingDecl)), OS);
  return extra::makeCXString(OS.str());
}

// MangleContext Cast
CXItaniumMangleContext clang_MangleContext_castToItaniumMangleContext(CXMangleContext MC) {
  return reinterpret_cast<CXItaniumMangleContext>(llvm::dyn_cast_or_null<clang::ItaniumMangleContext>(
      reinterpret_cast<clang::MangleContext *>(MC)));
}

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

CXString clang_ItaniumMangleContext_mangleCXXVTable(CXItaniumMangleContext MC,
                                                    CXCXXRecordDecl RD) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::ItaniumMangleContext *>(MC)->mangleCXXVTable(
      reinterpret_cast<clang::CXXRecordDecl *>(RD), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_ItaniumMangleContext_mangleCXXVTT(CXItaniumMangleContext MC,
                                                 CXCXXRecordDecl RD) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::ItaniumMangleContext *>(MC)->mangleCXXVTT(
      reinterpret_cast<clang::CXXRecordDecl *>(RD), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_ItaniumMangleContext_mangleCXXCtorVTable(CXItaniumMangleContext MC,
                                                        CXCXXRecordDecl RD, int64_t Offset,
                                                        CXCXXRecordDecl Type) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::ItaniumMangleContext *>(MC)->mangleCXXCtorVTable(
      reinterpret_cast<clang::CXXRecordDecl *>(RD), Offset,
      reinterpret_cast<clang::CXXRecordDecl *>(Type), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_ItaniumMangleContext_mangleItaniumThreadLocalInit(CXItaniumMangleContext MC,
                                                                 CXVarDecl D) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::ItaniumMangleContext *>(MC)->mangleItaniumThreadLocalInit(
      reinterpret_cast<clang::VarDecl *>(D), OS);
  return extra::makeCXString(OS.str());
}

CXString
clang_ItaniumMangleContext_mangleItaniumThreadLocalWrapper(CXItaniumMangleContext MC,
                                                           CXVarDecl D) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::ItaniumMangleContext *>(MC)->mangleItaniumThreadLocalWrapper(
      reinterpret_cast<clang::VarDecl *>(D), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_ItaniumMangleContext_mangleCXXCtorComdat(CXItaniumMangleContext MC,
                                                        CXCXXConstructorDecl D) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::ItaniumMangleContext *>(MC)->mangleCXXCtorComdat(
      reinterpret_cast<clang::CXXConstructorDecl *>(D), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_ItaniumMangleContext_mangleCXXDtorComdat(CXItaniumMangleContext MC,
                                                        CXCXXDestructorDecl D) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::ItaniumMangleContext *>(MC)->mangleCXXDtorComdat(
      reinterpret_cast<clang::CXXDestructorDecl *>(D), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_ItaniumMangleContext_mangleLambdaSig(CXItaniumMangleContext MC,
                                                    CXCXXRecordDecl Lambda) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::ItaniumMangleContext *>(MC)->mangleLambdaSig(
      reinterpret_cast<clang::CXXRecordDecl *>(Lambda), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_ItaniumMangleContext_mangleDynamicStermFinalizer(CXItaniumMangleContext MC,
                                                                CXVarDecl D) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::ItaniumMangleContext *>(MC)->mangleDynamicStermFinalizer(
      reinterpret_cast<clang::VarDecl *>(D), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_ItaniumMangleContext_mangleModuleInitializer(CXItaniumMangleContext MC,
                                                            CXModule_ M) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::ItaniumMangleContext *>(MC)->mangleModuleInitializer(
      reinterpret_cast<clang::Module *>(M), OS);
  return extra::makeCXString(OS.str());
}

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
  return extra::makeCXString(
      reinterpret_cast<clang::ASTNameGenerator *>(G)->getName(reinterpret_cast<clang::Decl *>(D)));
}

CXStringSet *clang_ASTNameGenerator_getAllManglings(CXASTNameGenerator G, CXDecl D) {
  return extra::makeCXStringSet(reinterpret_cast<clang::ASTNameGenerator *>(G)->getAllManglings(
      reinterpret_cast<clang::Decl *>(D)));
}

unsigned clang_MangleContext_getBlockId(CXMangleContext MC, CXBlockDecl BD, bool Local) {
  return reinterpret_cast<clang::MangleContext *>(MC)->getBlockId(
      reinterpret_cast<clang::BlockDecl *>(BD), Local);
}
