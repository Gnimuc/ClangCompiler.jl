#include "clang-ex/AST/CXMangle.h"
#include "utils.h"
#include "clang/AST/GlobalDecl.h"
#include "clang/AST/Mangle.h"
#include "llvm/Support/raw_ostream.h"
#include "clang/AST/DeclCXX.h"
#include "clang/Basic/Module.h"

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

CXString clang_MangleContext_mangleName(CXMangleContext MC, CXNamedDecl D) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::MangleContext *>(MC)->mangleName(
      clang::GlobalDecl(static_cast<clang::NamedDecl *>(D)), OS);
  return extra::makeCXString(OS.str());
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

bool clang_MangleContext_isAux(CXMangleContext MC) {
  return static_cast<clang::MangleContext *>(MC)->isAux();
}

void clang_MangleContext_startNewFunction(CXMangleContext MC) {
  static_cast<clang::MangleContext *>(MC)->startNewFunction();
}

uint64_t clang_MangleContext_getAnonymousStructIdForDebugInfo(CXMangleContext MC,
                                                              CXNamedDecl D) {
  return static_cast<clang::MangleContext *>(MC)->getAnonymousStructIdForDebugInfo(
      static_cast<clang::NamedDecl *>(D));
}

CXString clang_MangleContext_mangleCXXRTTIName(CXMangleContext MC, CXQualType T,
                                               bool NormalizeIntegers) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::MangleContext *>(MC)->mangleCXXRTTIName(
      clang::QualType::getFromOpaquePtr(T), OS, NormalizeIntegers);
  return extra::makeCXString(OS.str());
}

CXString clang_MangleContext_mangleCanonicalTypeName(CXMangleContext MC, CXQualType T,
                                                     bool NormalizeIntegers) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::MangleContext *>(MC)->mangleCanonicalTypeName(
      clang::QualType::getFromOpaquePtr(T), OS, NormalizeIntegers);
  return extra::makeCXString(OS.str());
}

bool clang_MangleContext_isUniqueInternalLinkageDecl(CXMangleContext MC, CXNamedDecl ND) {
  return static_cast<clang::MangleContext *>(MC)->isUniqueInternalLinkageDecl(
      static_cast<clang::NamedDecl *>(ND));
}

void clang_MangleContext_needsUniqueInternalLinkageNames(CXMangleContext MC) {
  static_cast<clang::MangleContext *>(MC)->needsUniqueInternalLinkageNames();
}

CXString clang_MangleContext_getLambdaString(CXMangleContext MC, CXCXXRecordDecl Lambda) {
  return extra::makeCXString(static_cast<clang::MangleContext *>(MC)->getLambdaString(
      static_cast<clang::CXXRecordDecl *>(Lambda)));
}

CXString clang_MangleContext_mangleCXXRTTI(CXMangleContext MC, CXQualType T) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::MangleContext *>(MC)->mangleCXXRTTI(
      clang::QualType::getFromOpaquePtr(T), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_MangleContext_mangleStaticGuardVariable(CXMangleContext MC, CXVarDecl D) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::MangleContext *>(MC)->mangleStaticGuardVariable(
      static_cast<clang::VarDecl *>(D), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_MangleContext_mangleDynamicInitializer(CXMangleContext MC, CXVarDecl D) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::MangleContext *>(MC)->mangleDynamicInitializer(
      static_cast<clang::VarDecl *>(D), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_MangleContext_mangleCXXName(CXMangleContext MC, CXNamedDecl D) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::MangleContext *>(MC)->mangleCXXName(
      clang::GlobalDecl(static_cast<clang::NamedDecl *>(D)), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_MangleContext_mangleReferenceTemporary(CXMangleContext MC, CXVarDecl D,
                                                      unsigned ManglingNumber) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::MangleContext *>(MC)->mangleReferenceTemporary(
      static_cast<clang::VarDecl *>(D), ManglingNumber, OS);
  return extra::makeCXString(OS.str());
}

CXString clang_MangleContext_mangleDynamicAtExitDestructor(CXMangleContext MC,
                                                           CXVarDecl D) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::MangleContext *>(MC)->mangleDynamicAtExitDestructor(
      static_cast<clang::VarDecl *>(D), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_MangleContext_mangleSEHFilterExpression(CXMangleContext MC,
                                                       CXFunctionDecl EnclosingDecl) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::MangleContext *>(MC)->mangleSEHFilterExpression(
      clang::GlobalDecl(static_cast<clang::FunctionDecl *>(EnclosingDecl)), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_MangleContext_mangleSEHFinallyBlock(CXMangleContext MC,
                                                   CXFunctionDecl EnclosingDecl) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::MangleContext *>(MC)->mangleSEHFinallyBlock(
      clang::GlobalDecl(static_cast<clang::FunctionDecl *>(EnclosingDecl)), OS);
  return extra::makeCXString(OS.str());
}

// MangleContext Cast
CXItaniumMangleContext clang_MangleContext_castToItaniumMangleContext(CXMangleContext MC) {
  return llvm::dyn_cast_or_null<clang::ItaniumMangleContext>(
      static_cast<clang::MangleContext *>(MC));
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
  static_cast<clang::ItaniumMangleContext *>(MC)->mangleCXXVTable(
      static_cast<clang::CXXRecordDecl *>(RD), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_ItaniumMangleContext_mangleCXXVTT(CXItaniumMangleContext MC,
                                                 CXCXXRecordDecl RD) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::ItaniumMangleContext *>(MC)->mangleCXXVTT(
      static_cast<clang::CXXRecordDecl *>(RD), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_ItaniumMangleContext_mangleCXXCtorVTable(CXItaniumMangleContext MC,
                                                        CXCXXRecordDecl RD, int64_t Offset,
                                                        CXCXXRecordDecl Type) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::ItaniumMangleContext *>(MC)->mangleCXXCtorVTable(
      static_cast<clang::CXXRecordDecl *>(RD), Offset,
      static_cast<clang::CXXRecordDecl *>(Type), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_ItaniumMangleContext_mangleItaniumThreadLocalInit(CXItaniumMangleContext MC,
                                                                 CXVarDecl D) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::ItaniumMangleContext *>(MC)->mangleItaniumThreadLocalInit(
      static_cast<clang::VarDecl *>(D), OS);
  return extra::makeCXString(OS.str());
}

CXString
clang_ItaniumMangleContext_mangleItaniumThreadLocalWrapper(CXItaniumMangleContext MC,
                                                           CXVarDecl D) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::ItaniumMangleContext *>(MC)->mangleItaniumThreadLocalWrapper(
      static_cast<clang::VarDecl *>(D), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_ItaniumMangleContext_mangleCXXCtorComdat(CXItaniumMangleContext MC,
                                                        CXCXXConstructorDecl D) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::ItaniumMangleContext *>(MC)->mangleCXXCtorComdat(
      static_cast<clang::CXXConstructorDecl *>(D), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_ItaniumMangleContext_mangleCXXDtorComdat(CXItaniumMangleContext MC,
                                                        CXCXXDestructorDecl D) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::ItaniumMangleContext *>(MC)->mangleCXXDtorComdat(
      static_cast<clang::CXXDestructorDecl *>(D), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_ItaniumMangleContext_mangleLambdaSig(CXItaniumMangleContext MC,
                                                    CXCXXRecordDecl Lambda) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::ItaniumMangleContext *>(MC)->mangleLambdaSig(
      static_cast<clang::CXXRecordDecl *>(Lambda), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_ItaniumMangleContext_mangleDynamicStermFinalizer(CXItaniumMangleContext MC,
                                                                CXVarDecl D) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::ItaniumMangleContext *>(MC)->mangleDynamicStermFinalizer(
      static_cast<clang::VarDecl *>(D), OS);
  return extra::makeCXString(OS.str());
}

CXString clang_ItaniumMangleContext_mangleModuleInitializer(CXItaniumMangleContext MC,
                                                            CXModule M) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::ItaniumMangleContext *>(MC)->mangleModuleInitializer(
      static_cast<clang::Module *>(M), OS);
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
      static_cast<clang::ASTNameGenerator *>(G)->getName(static_cast<clang::Decl *>(D)));
}

CXStringSet *clang_ASTNameGenerator_getAllManglings(CXASTNameGenerator G, CXDecl D) {
  return extra::makeCXStringSet(static_cast<clang::ASTNameGenerator *>(G)->getAllManglings(
      static_cast<clang::Decl *>(D)));
}