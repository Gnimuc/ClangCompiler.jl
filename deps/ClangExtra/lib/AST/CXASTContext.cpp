#include "clang-ex/AST/CXASTContext.h"
#include "utils.h"

#include "clang/AST/CharUnits.h"
#include "clang/AST/RawCommentList.h"
#include "clang/Basic/AttrKinds.h"
#include "clang/Basic/SourceManager.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/TemplateBase.h"
#include "clang/Basic/TargetInfo.h"
#include "clang/AST/APValue.h"
#include "clang/AST/DeclCXX.h"
#include "clang/AST/Expr.h"
#include "llvm/ExecutionEngine/GenericValue.h"
#include "llvm/Support/raw_ostream.h"
#include "clang/Basic/Builtins.h"
#include "llvm/ADT/APFloat.h"
#include "clang/AST/DeclTemplate.h"

#include <memory>
#include <vector>

// ASTContext

// getInterpContext
// getParentMapContext
// getTraversalScope

unsigned clang_ASTContext_getNumTraversalScopeDecls(CXASTContext Ctx) {
  return static_cast<unsigned>(
      static_cast<clang::ASTContext *>(Ctx)->getTraversalScope().size());
}

void clang_ASTContext_getTraversalScopeDecls(CXASTContext Ctx, CXDecl *Buf) {
  auto Scope = static_cast<clang::ASTContext *>(Ctx)->getTraversalScope();
  unsigned I = 0;
  for (clang::Decl *D : Scope)
    Buf[I++] = D;
}

void clang_ASTContext_setTraversalScope(CXASTContext Ctx, CXDecl *Decls,
                                        unsigned NumDecls) {
  std::vector<clang::Decl *> Scope;
  Scope.reserve(NumDecls);
  for (unsigned I = 0; I != NumDecls; ++I)
    Scope.push_back(static_cast<clang::Decl *>(Decls[I]));
  static_cast<clang::ASTContext *>(Ctx)->setTraversalScope(Scope);
}
// getParents
// getPrintingPolicy
// setPrintingPolicy

CXSourceManager clang_ASTContext_getSourceManager(CXASTContext Ctx) {
  return &static_cast<clang::ASTContext *>(Ctx)->getSourceManager();
}

// getAllocator
// Allocate
// Deallocate

size_t clang_ASTContext_getASTAllocatedMemory(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getASTAllocatedMemory();
}

size_t clang_ASTContext_getSideTableAllocatedMemory(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getSideTableAllocatedMemory();
}

// getDiagAllocator

CXTargetInfo_ clang_ASTContext_getTargetInfo(CXASTContext Ctx) {
  return const_cast<clang::TargetInfo *>(
      &static_cast<clang::ASTContext *>(Ctx)->getTargetInfo());
}

CXTargetInfo_ clang_ASTContext_getAuxTargetInfo(CXASTContext Ctx) {
  return const_cast<clang::TargetInfo *>(
      static_cast<clang::ASTContext *>(Ctx)->getAuxTargetInfo());
}

CXQualType clang_ASTContext_getIntTypeForBitwidth(CXASTContext Ctx, unsigned DestWidth,
                                                  unsigned Signed) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getIntTypeForBitwidth(DestWidth, Signed)
      .getAsOpaquePtr();
}

// CXQualType clang_ASTContext_getRealTypeForBitwidth(CXASTContext Ctx, unsigned DestWidth,
//                                                    clang::FloatModeKind ExplicitType) {
//   return static_cast<clang::ASTContext *>(Ctx)
//       ->getRealTypeForBitwidth(DestWidth, ExplicitType)
//       .getAsOpaquePtr();
// }

CXQualType clang_ASTContext_getRealTypeForBitwidth(CXASTContext Ctx, unsigned DestWidth,
                                                   CXFloatModeKind ExplicitType) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getRealTypeForBitwidth(DestWidth, static_cast<clang::FloatModeKind>(ExplicitType))
      .getAsOpaquePtr();
}

bool clang_ASTContext_AtomicUsesUnsupportedLibcall(CXASTContext Ctx, CXAtomicExpr E) {
  return static_cast<clang::ASTContext *>(Ctx)->AtomicUsesUnsupportedLibcall(
      static_cast<clang::AtomicExpr *>(E));
}

CXLangOptions clang_ASTContext_getLangOpts(CXASTContext Ctx) {
  return const_cast<clang::LangOptions *>(
      &static_cast<clang::ASTContext *>(Ctx)->getLangOpts());
}

bool clang_ASTContext_isDependceAllowed(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->isDependenceAllowed();
}

// getSanitizerBlacklist
// getXRayFilter
// getProfileList

CXDiagnosticsEngine clang_ASTContext_getDiagnostics(CXASTContext Ctx) {
  return &static_cast<clang::ASTContext *>(Ctx)->getDiagnostics();
}

// getFullLoc

CXTargetCXXABI_Kind clang_ASTContext_getCXXABIKind(CXASTContext Ctx) {
  return static_cast<CXTargetCXXABI_Kind>(
      static_cast<clang::ASTContext *>(Ctx)->getCXXABIKind());
}
// cacheRawCommentForDecl
// getRawCommentForDeclNoCacheImpl
// addComment

CXRawComment clang_ASTContext_getRawCommentForAnyRedecl(CXASTContext Ctx, CXDecl D) {
  auto *C = static_cast<clang::ASTContext *>(Ctx);
  return const_cast<clang::RawComment *>(
      C->getRawCommentForAnyRedecl(static_cast<clang::Decl *>(D)));
}

CXString clang_ASTContext_getRawCommentTextForAnyRedecl(CXASTContext Ctx, CXDecl D) {
  auto *C = static_cast<clang::ASTContext *>(Ctx);
  const clang::RawComment *RC =
      C->getRawCommentForAnyRedecl(static_cast<clang::Decl *>(D));
  if (!RC)
    return extra::makeCXString(std::string());
  return extra::makeCXString(RC->getRawText(C->getSourceManager()).str());
}

CXDecl clang_ASTContext_getRawCommentOriginalDeclForAnyRedecl(CXASTContext Ctx,
                                                              CXDecl D) {
  auto *C = static_cast<clang::ASTContext *>(Ctx);
  const clang::Decl *OriginalDecl = nullptr;
  if (!C->getRawCommentForAnyRedecl(static_cast<clang::Decl *>(D), &OriginalDecl))
    return nullptr;
  return const_cast<clang::Decl *>(OriginalDecl);
}
// attachCommentsToJustParsedDecl

CXFullComment clang_ASTContext_getCommentForDecl(CXASTContext Ctx, CXDecl D,
                                                 CXPreprocessor PP) {
  auto *C = static_cast<clang::ASTContext *>(Ctx);
  return C->getCommentForDecl(static_cast<clang::Decl *>(D),
                              static_cast<clang::Preprocessor *>(PP));
}

CXFullComment clang_ASTContext_getLocalCommentForDeclUncached(CXASTContext Ctx, CXDecl D) {
  return static_cast<clang::ASTContext *>(Ctx)->getLocalCommentForDeclUncached(
      static_cast<clang::Decl *>(D));
}

CXFullComment clang_ASTContext_cloneFullComment(CXASTContext Ctx, CXFullComment FC,
                                                CXDecl D) {
  return static_cast<clang::ASTContext *>(Ctx)->cloneFullComment(
      static_cast<clang::comments::FullComment *>(FC), static_cast<clang::Decl *>(D));
}
// getCommentCommandTraits
// getDeclAttrs

void clang_ASTContext_eraseDeclAttrs(CXASTContext Ctx, CXDecl D) {
  static_cast<clang::ASTContext *>(Ctx)->eraseDeclAttrs(static_cast<clang::Decl *>(D));
}

CXMemberSpecializationInfo
clang_ASTContext_getInstantiatedFromStaticDataMember(CXASTContext Ctx, CXVarDecl Var) {
  return static_cast<clang::ASTContext *>(Ctx)->getInstantiatedFromStaticDataMember(
      static_cast<clang::VarDecl *>(Var));
}

// getTemplateOrSpecializationInfo

CXVarTemplateDecl
clang_ASTContext_getTemplateOrSpecializationInfoAsVarTemplate(CXASTContext Ctx,
                                                              CXVarDecl Var) {
  clang::ASTContext::TemplateOrSpecializationInfo Info =
      static_cast<clang::ASTContext *>(Ctx)->getTemplateOrSpecializationInfo(
          static_cast<clang::VarDecl *>(Var));
  return Info.dyn_cast<clang::VarTemplateDecl *>();
}

CXMemberSpecializationInfo
clang_ASTContext_getTemplateOrSpecializationInfoAsMemberSpecialization(CXASTContext Ctx,
                                                                       CXVarDecl Var) {
  clang::ASTContext::TemplateOrSpecializationInfo Info =
      static_cast<clang::ASTContext *>(Ctx)->getTemplateOrSpecializationInfo(
          static_cast<clang::VarDecl *>(Var));
  return Info.dyn_cast<clang::MemberSpecializationInfo *>();
}

void clang_ASTContext_setInstantiatedFromStaticDataMember(
    CXASTContext Ctx, CXVarDecl Inst, CXVarDecl Tmpl, CXTemplateSpecializationKind TSK,
    CXSourceLocation_ PointOfInstantiation) {
  static_cast<clang::ASTContext *>(Ctx)->setInstantiatedFromStaticDataMember(
      static_cast<clang::VarDecl *>(Inst), static_cast<clang::VarDecl *>(Tmpl),
      static_cast<clang::TemplateSpecializationKind>(TSK),
      clang::SourceLocation::getFromPtrEncoding(PointOfInstantiation));
}
// setTemplateOrSpecializationInfo

void clang_ASTContext_setTemplateOrSpecializationInfoAsVarTemplate(CXASTContext Ctx,
                                                                   CXVarDecl Inst,
                                                                   CXVarTemplateDecl Tmpl) {
  static_cast<clang::ASTContext *>(Ctx)->setTemplateOrSpecializationInfo(
      static_cast<clang::VarDecl *>(Inst), static_cast<clang::VarTemplateDecl *>(Tmpl));
}

CXNamedDecl clang_ASTContext_getInstantiatedFromUsingDecl(CXASTContext Ctx,
                                                          CXNamedDecl Inst) {
  return static_cast<clang::ASTContext *>(Ctx)->getInstantiatedFromUsingDecl(
      static_cast<clang::NamedDecl *>(Inst));
}

void clang_ASTContext_setInstantiatedFromUsingDecl(CXASTContext Ctx, CXNamedDecl Inst,
                                                   CXNamedDecl Pattern) {
  static_cast<clang::ASTContext *>(Ctx)->setInstantiatedFromUsingDecl(
      static_cast<clang::NamedDecl *>(Inst), static_cast<clang::NamedDecl *>(Pattern));
}

CXUsingEnumDecl clang_ASTContext_getInstantiatedFromUsingEnumDecl(CXASTContext Ctx,
                                                                  CXUsingEnumDecl Inst) {
  return static_cast<clang::ASTContext *>(Ctx)->getInstantiatedFromUsingEnumDecl(
      static_cast<clang::UsingEnumDecl *>(Inst));
}

void clang_ASTContext_setInstantiatedFromUsingEnumDecl(CXASTContext Ctx,
                                                       CXUsingEnumDecl Inst,
                                                       CXUsingEnumDecl Pattern) {
  static_cast<clang::ASTContext *>(Ctx)->setInstantiatedFromUsingEnumDecl(
      static_cast<clang::UsingEnumDecl *>(Inst),
      static_cast<clang::UsingEnumDecl *>(Pattern));
}

void clang_ASTContext_setInstantiatedFromUsingShadowDecl(CXASTContext Ctx,
                                                         CXUsingShadowDecl Inst,
                                                         CXUsingShadowDecl Pattern) {
  static_cast<clang::ASTContext *>(Ctx)->setInstantiatedFromUsingShadowDecl(
      static_cast<clang::UsingShadowDecl *>(Inst),
      static_cast<clang::UsingShadowDecl *>(Pattern));
}

CXUsingShadowDecl
clang_ASTContext_getInstantiatedFromUsingShadowDecl(CXASTContext Ctx,
                                                    CXUsingShadowDecl Inst) {
  return static_cast<clang::ASTContext *>(Ctx)->getInstantiatedFromUsingShadowDecl(
      static_cast<clang::UsingShadowDecl *>(Inst));
}

CXFieldDecl clang_ASTContext_getInstantiatedFromUnnamedFieldDecl(CXASTContext Ctx,
                                                                 CXFieldDecl Field) {
  return static_cast<clang::ASTContext *>(Ctx)->getInstantiatedFromUnnamedFieldDecl(
      static_cast<clang::FieldDecl *>(Field));
}

void clang_ASTContext_setInstantiatedFromUnnamedFieldDecl(CXASTContext Ctx,
                                                          CXFieldDecl Inst,
                                                          CXFieldDecl Tmpl) {
  static_cast<clang::ASTContext *>(Ctx)->setInstantiatedFromUnnamedFieldDecl(
      static_cast<clang::FieldDecl *>(Inst), static_cast<clang::FieldDecl *>(Tmpl));
}

void clang_ASTContext_addOverriddenMethod(CXASTContext Ctx, CXCXXMethodDecl Method,
                                          CXCXXMethodDecl Overridden) {
  static_cast<clang::ASTContext *>(Ctx)->addOverriddenMethod(
      static_cast<clang::CXXMethodDecl *>(Method),
      static_cast<clang::CXXMethodDecl *>(Overridden));
}

// getOverriddenMethods

unsigned clang_ASTContext_overridden_methods_size(CXASTContext Ctx,
                                                  CXCXXMethodDecl Method) {
  return static_cast<clang::ASTContext *>(Ctx)->overridden_methods_size(
      static_cast<clang::CXXMethodDecl *>(Method));
}

unsigned clang_ASTContext_getNumOverriddenMethods(CXASTContext Ctx, CXNamedDecl Method) {
  llvm::SmallVector<const clang::NamedDecl *, 8> Overridden;
  static_cast<clang::ASTContext *>(Ctx)->getOverriddenMethods(
      static_cast<clang::NamedDecl *>(Method), Overridden);
  return Overridden.size();
}

void clang_ASTContext_getOverriddenMethods(CXASTContext Ctx, CXNamedDecl Method,
                                           CXNamedDecl *Buf) {
  llvm::SmallVector<const clang::NamedDecl *, 8> Overridden;
  static_cast<clang::ASTContext *>(Ctx)->getOverriddenMethods(
      static_cast<clang::NamedDecl *>(Method), Overridden);
  for (unsigned I = 0, N = Overridden.size(); I != N; ++I)
    Buf[I] = const_cast<clang::NamedDecl *>(Overridden[I]);
}

void clang_ASTContext_addedLocalImportDecl(CXASTContext Ctx, CXImportDecl Import) {
  static_cast<clang::ASTContext *>(Ctx)->addedLocalImportDecl(
      static_cast<clang::ImportDecl *>(Import));
}


CXImportDecl clang_ASTContext_getNextLocalImport(CXImportDecl Import) {
  return clang::ASTContext::getNextLocalImport(static_cast<clang::ImportDecl *>(Import));
}

// local_imports

CXImportDecl clang_ASTContext_getFirstLocalImport(CXASTContext Ctx) {
  for (clang::ImportDecl *Import : static_cast<clang::ASTContext *>(Ctx)->local_imports())
    return Import;
  return nullptr;
}

CXDecl clang_ASTContext_getPrimaryMergedDecl(CXASTContext Ctx, CXDecl D) {
  return static_cast<clang::ASTContext *>(Ctx)->getPrimaryMergedDecl(
      static_cast<clang::Decl *>(D));
}

void clang_ASTContext_setPrimaryMergedDecl(CXASTContext Ctx, CXDecl D, CXDecl Primary) {
  static_cast<clang::ASTContext *>(Ctx)->setPrimaryMergedDecl(
      static_cast<clang::Decl *>(D), static_cast<clang::Decl *>(Primary));
}

void clang_ASTContext_mergeDefinitionIntoModule(CXASTContext Ctx, CXNamedDecl ND,
                                                CXModule Module, bool NotifyListeners) {
  static_cast<clang::ASTContext *>(Ctx)->mergeDefinitionIntoModule(
      static_cast<clang::NamedDecl *>(ND), static_cast<clang::Module *>(Module),
      NotifyListeners);
}

void clang_ASTContext_deduplicateMergedDefinitonsFor(CXASTContext Ctx, CXNamedDecl ND) {
  static_cast<clang::ASTContext *>(Ctx)->deduplicateMergedDefinitonsFor(
      static_cast<clang::NamedDecl *>(ND));
}

unsigned clang_ASTContext_getNumModulesWithMergedDefinition(CXASTContext Ctx,
                                                            CXNamedDecl Def) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getModulesWithMergedDefinition(static_cast<clang::NamedDecl *>(Def))
      .size();
}

CXModule clang_ASTContext_getModuleWithMergedDefinition(CXASTContext Ctx, CXNamedDecl Def,
                                                        unsigned I) {
  return static_cast<clang::ASTContext *>(Ctx)->getModulesWithMergedDefinition(
      static_cast<clang::NamedDecl *>(Def))[I];
}

// getModuleInitializers

void clang_ASTContext_addModuleInitializer(CXASTContext Ctx, CXModule M, CXDecl Init) {
  static_cast<clang::ASTContext *>(Ctx)->addModuleInitializer(
      static_cast<clang::Module *>(M), static_cast<clang::Decl *>(Init));
}

unsigned clang_ASTContext_getNumModuleInitializers(CXASTContext Ctx, CXModule M) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getModuleInitializers(static_cast<clang::Module *>(M))
      .size();
}

CXDecl clang_ASTContext_getModuleInitializer(CXASTContext Ctx, CXModule M, unsigned I) {
  return static_cast<clang::ASTContext *>(Ctx)->getModuleInitializers(
      static_cast<clang::Module *>(M))[I];
}

CXModule clang_ASTContext_getCurrentNamedModule(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getCurrentNamedModule();
}

CXTranslationUnitDecl clang_ASTContext_getTranslationUnitDecl(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getTranslationUnitDecl();
}

CXExternCContextDecl clang_ASTContext_getExternCContextDecl(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getExternCContextDecl();
}

CXBuiltinTemplateDecl clang_ASTContext_getMakeIntegerSeqDecl(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getMakeIntegerSeqDecl();
}

CXBuiltinTemplateDecl clang_ASTContext_getTypePackElementDecl(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getTypePackElementDecl();
}

// setExternalSource
// getExternalSource
// setASTMutationListener
// getASTMutationListener

void clang_ASTContext_PrintStats(CXASTContext Ctx) {
  static_cast<clang::ASTContext *>(Ctx)->PrintStats();
}

// getTypes

unsigned clang_ASTContext_getNumTypes(CXASTContext Ctx) {
  return static_cast<unsigned>(static_cast<clang::ASTContext *>(Ctx)->getTypes().size());
}

CXType_ clang_ASTContext_getType(CXASTContext Ctx, unsigned I) {
  return static_cast<clang::ASTContext *>(Ctx)->getTypes()[I];
}

CXBuiltinTemplateDecl clang_ASTContext_buildBuiltinTemplateDecl(CXASTContext Ctx,
                                                                CXBuiltinTemplateKind BTK,
                                                                CXIdentifierInfo II) {
  return static_cast<clang::ASTContext *>(Ctx)->buildBuiltinTemplateDecl(
      static_cast<clang::BuiltinTemplateKind>(BTK),
      static_cast<clang::IdentifierInfo *>(II));
}

CXRecordDecl clang_ASTContext_buildImplicitRecord(CXASTContext Ctx, const char *Name,
                                                  CXTagTypeKind TK) {
  return static_cast<clang::ASTContext *>(Ctx)->buildImplicitRecord(
      llvm::StringRef(Name), static_cast<clang::RecordDecl::TagKind>(TK));
}

CXTypedefDecl clang_ASTContext_buildImplicitTypedef(CXASTContext Ctx, CXQualType T,
                                                    const char *Name) {
  return static_cast<clang::ASTContext *>(Ctx)->buildImplicitTypedef(
      clang::QualType::getFromOpaquePtr(T), llvm::StringRef(Name));
}

CXTypedefDecl clang_ASTContext_getInt128Decl(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getInt128Decl();
}

CXTypedefDecl clang_ASTContext_getUInt128Decl(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getUInt128Decl();
}


CXQualType clang_ASTContext_getAddrSpaceQualType(CXASTContext Ctx, CXQualType T,
                                                 CXLangAS AddressSpace) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getAddrSpaceQualType(clang::QualType::getFromOpaquePtr(T),
                             static_cast<clang::LangAS>(AddressSpace))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_removeAddrSpaceQualType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->removeAddrSpaceQualType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

// applyObjCProtocolQualifiers

CXQualType clang_ASTContext_getObjCGCQualType(CXASTContext Ctx, CXQualType T,
                                              CXQualifiers_GC GCAttr) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getObjCGCQualType(clang::QualType::getFromOpaquePtr(T),
                          static_cast<clang::Qualifiers::GC>(GCAttr))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_removePtrSizeAddrSpace(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->removePtrSizeAddrSpace(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getRestrictType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getRestrictType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getVolatileType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getVolatileType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getConstType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getConstType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}


CXFunctionType clang_ASTContext_adjustFunctionType(CXASTContext Ctx, CXFunctionType Fn,
                                                   CXCallingConv_ CC, bool NoReturn,
                                                   bool ProducesResult) {
  auto *FT = static_cast<clang::FunctionType *>(Fn);
  clang::FunctionType::ExtInfo EI =
      FT->getExtInfo()
          .withCallingConv(static_cast<clang::CallingConv>(CC))
          .withNoReturn(NoReturn)
          .withProducesResult(ProducesResult);
  return const_cast<clang::FunctionType *>(
      static_cast<clang::ASTContext *>(Ctx)->adjustFunctionType(FT, EI));
}

CXQualType clang_ASTContext_getCanonicalFunctionResultType(CXASTContext Ctx,
                                                           CXQualType ResultType) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getCanonicalFunctionResultType(clang::QualType::getFromOpaquePtr(ResultType))
      .getAsOpaquePtr();
}

void clang_ASTContext_adjustDeducedFunctionResultType(CXASTContext Ctx, CXFunctionDecl FD,
                                                      CXQualType ResultType) {
  static_cast<clang::ASTContext *>(Ctx)->adjustDeducedFunctionResultType(
      static_cast<clang::FunctionDecl *>(FD),
      clang::QualType::getFromOpaquePtr(ResultType));
}


CXQualType
clang_ASTContext_getFunctionTypeWithExceptionSpec(CXASTContext Ctx, CXQualType Orig,
                                                  CXExceptionSpecificationType EST) {
  clang::FunctionProtoType::ExceptionSpecInfo ESI(
      static_cast<clang::ExceptionSpecificationType>(EST));
  return static_cast<clang::ASTContext *>(Ctx)
      ->getFunctionTypeWithExceptionSpec(clang::QualType::getFromOpaquePtr(Orig), ESI)
      .getAsOpaquePtr();
}

bool clang_ASTContext_hasSameFunctionTypeIgnoringExceptionSpec(CXASTContext Ctx,
                                                               CXQualType T, CXQualType U) {
  return static_cast<clang::ASTContext *>(Ctx)->hasSameFunctionTypeIgnoringExceptionSpec(
      clang::QualType::getFromOpaquePtr(T), clang::QualType::getFromOpaquePtr(U));
}


void clang_ASTContext_adjustExceptionSpec(CXASTContext Ctx, CXFunctionDecl FD,
                                          CXExceptionSpecificationType EST,
                                          bool AsWritten) {
  clang::FunctionProtoType::ExceptionSpecInfo ESI(
      static_cast<clang::ExceptionSpecificationType>(EST));
  static_cast<clang::ASTContext *>(Ctx)->adjustExceptionSpec(
      static_cast<clang::FunctionDecl *>(FD), ESI, AsWritten);
}

CXQualType clang_ASTContext_getFunctionTypeWithoutPtrSizes(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getFunctionTypeWithoutPtrSizes(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

bool clang_ASTContext_hasSameFunctionTypeIgnoringPtrSizes(CXASTContext Ctx, CXQualType T,
                                                          CXQualType U) {
  return static_cast<clang::ASTContext *>(Ctx)->hasSameFunctionTypeIgnoringPtrSizes(
      clang::QualType::getFromOpaquePtr(T), clang::QualType::getFromOpaquePtr(U));
}

CXQualType clang_ASTContext_getComplexType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getComplexType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getPointerType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getPointerType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getAdjustedType(CXASTContext Ctx, CXQualType Orig,
                                            CXQualType New) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getAdjustedType(clang::QualType::getFromOpaquePtr(Orig),
                        clang::QualType::getFromOpaquePtr(New))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getDecayedType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getDecayedType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getAtomicType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getAtomicType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getQualifiedType(CXASTContext Ctx, CXQualType T,
                                             unsigned Quals) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getQualifiedType(clang::QualType::getFromOpaquePtr(T),
                         clang::Qualifiers::fromOpaqueValue(Quals))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getUnqualifiedArrayType(CXASTContext Ctx, CXQualType T,
                                                    unsigned *Quals) {
  clang::Qualifiers Qs;
  clang::QualType Result =
      static_cast<clang::ASTContext *>(Ctx)->getUnqualifiedArrayType(
          clang::QualType::getFromOpaquePtr(T), Qs);
  *Quals = Qs.getAsOpaqueValue();
  return Result.getAsOpaquePtr();
}

CXQualType clang_ASTContext_getAttributedType(CXASTContext Ctx, CXAttrKind AttrKind,
                                              CXQualType ModifiedType,
                                              CXQualType EquivalentType) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getAttributedType(static_cast<clang::attr::Kind>(AttrKind),
                          clang::QualType::getFromOpaquePtr(ModifiedType),
                          clang::QualType::getFromOpaquePtr(EquivalentType))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getIncompleteArrayType(CXASTContext Ctx, CXQualType EltTy,
                                                   CXArraySizeModifier ASM,
                                                   unsigned IndexTypeQuals) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getIncompleteArrayType(clang::QualType::getFromOpaquePtr(EltTy),
                               static_cast<clang::ArraySizeModifier>(ASM),
                               IndexTypeQuals)
      .getAsOpaquePtr();
}

bool clang_ASTContext_isPromotableIntegerType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)->isPromotableIntegerType(
      clang::QualType::getFromOpaquePtr(T));
}

CXQualType clang_ASTContext_getBlockPointerType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getBlockPointerType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getBlockDescriptorType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getBlockDescriptorType().getAsOpaquePtr();
}

CXQualType clang_ASTContext_getReadPipeType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getReadPipeType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getWritePipeType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getWritePipeType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getBitIntType(CXASTContext Ctx, bool Unsigned,
                                          unsigned NumBits) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getBitIntType(Unsigned, NumBits)
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getDependentBitIntType(CXASTContext Ctx, bool Unsigned,
                                                   CXExpr BitsExpr) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getDependentBitIntType(Unsigned, static_cast<clang::Expr *>(BitsExpr))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getBlockDescriptorExtendedType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getBlockDescriptorExtendedType()
      .getAsOpaquePtr();
}

// getOpenCLTypeKind
// getOpenCLTypeAddrSpace

CXOpenCLTypeKind clang_ASTContext_getOpenCLTypeKind(CXASTContext Ctx, CXType_ T) {
  return static_cast<CXOpenCLTypeKind>(
      static_cast<clang::ASTContext *>(Ctx)->getOpenCLTypeKind(
          static_cast<clang::Type *>(T)));
}

CXLangAS clang_ASTContext_getOpenCLTypeAddrSpace(CXASTContext Ctx, CXType_ T) {
  return static_cast<CXLangAS>(
      static_cast<clang::ASTContext *>(Ctx)->getOpenCLTypeAddrSpace(
          static_cast<clang::Type *>(T)));
}

CXLangAS clang_ASTContext_getDefaultOpenCLPointeeAddrSpace(CXASTContext Ctx) {
  return static_cast<CXLangAS>(
      static_cast<clang::ASTContext *>(Ctx)->getDefaultOpenCLPointeeAddrSpace());
}

void clang_ASTContext_setcudaConfigureCallDecl(CXASTContext Ctx, CXFunctionDecl FD) {
  static_cast<clang::ASTContext *>(Ctx)->setcudaConfigureCallDecl(
      static_cast<clang::FunctionDecl *>(FD));
}

CXFunctionDecl clang_ASTContext_getcudaConfigureCallDecl(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getcudaConfigureCallDecl();
}

bool clang_ASTContext_BlockRequiresCopying(CXASTContext Ctx, CXQualType T, CXVarDecl D) {
  return static_cast<clang::ASTContext *>(Ctx)->BlockRequiresCopying(
      clang::QualType::getFromOpaquePtr(T), static_cast<clang::VarDecl *>(D));
}

// getByrefLifeTime

bool clang_ASTContext_getByrefLifetime(CXASTContext Ctx, CXQualType Ty,
                                       CXQualifiers_ObjCLifetime *Lifetime,
                                       bool *HasByrefExtendedLayout) {
  clang::Qualifiers::ObjCLifetime LT = clang::Qualifiers::OCL_None;
  bool Extended = false;
  if (!static_cast<clang::ASTContext *>(Ctx)->getByrefLifetime(
          clang::QualType::getFromOpaquePtr(Ty), LT, Extended))
    return false;
  *Lifetime = static_cast<CXQualifiers_ObjCLifetime>(LT);
  *HasByrefExtendedLayout = Extended;
  return true;
}

CXQualType clang_ASTContext_getLValueReferenceType(CXASTContext Ctx, CXQualType T,
                                                   bool SpelledAsLValue) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getLValueReferenceType(clang::QualType::getFromOpaquePtr(T), SpelledAsLValue)
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getRValueReferenceType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getRValueReferenceType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getMemberPointerType(CXASTContext Ctx, CXQualType T,
                                                 CXType_ Cls) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getMemberPointerType(clang::QualType::getFromOpaquePtr(T),
                             static_cast<clang::Type *>(Cls))
      .getAsOpaquePtr();
}

// getVariableArrayType
// getDependentSizedArrayType
// getIncompleteArrayType

CXQualType clang_ASTContext_getVariableArrayType(CXASTContext Ctx, CXQualType EltTy,
                                                 CXExpr NumElts, CXArraySizeModifier ASM,
                                                 unsigned IndexTypeQuals,
                                                 CXSourceRange_ Brackets) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getVariableArrayType(
          clang::QualType::getFromOpaquePtr(EltTy), static_cast<clang::Expr *>(NumElts),
          static_cast<clang::ArraySizeModifier>(ASM), IndexTypeQuals,
          clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Brackets.B),
                             clang::SourceLocation::getFromPtrEncoding(Brackets.E)))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getDependentSizedArrayType(CXASTContext Ctx, CXQualType EltTy,
                                                       CXExpr NumElts,
                                                       CXArraySizeModifier ASM,
                                                       unsigned IndexTypeQuals,
                                                       CXSourceRange_ Brackets) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getDependentSizedArrayType(
          clang::QualType::getFromOpaquePtr(EltTy), static_cast<clang::Expr *>(NumElts),
          static_cast<clang::ArraySizeModifier>(ASM), IndexTypeQuals,
          clang::SourceRange(clang::SourceLocation::getFromPtrEncoding(Brackets.B),
                             clang::SourceLocation::getFromPtrEncoding(Brackets.E)))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getConstantArrayType(CXASTContext Ctx, CXQualType EltTy,
                                                 uint64_t Size, CXArraySizeModifier ASM,
                                                 unsigned IndexTypeQuals) {
  auto *C = static_cast<clang::ASTContext *>(Ctx);
  llvm::APInt ArySize(C->getTypeSize(C->getSizeType()), Size);
  return C
      ->getConstantArrayType(clang::QualType::getFromOpaquePtr(EltTy), ArySize,
                             /*SizeExpr=*/nullptr,
                             static_cast<clang::ArraySizeModifier>(ASM), IndexTypeQuals)
      .getAsOpaquePtr();
}


CXQualType clang_ASTContext_getStringLiteralArrayType(CXASTContext Ctx, CXQualType EltTy,
                                                      unsigned Length) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getStringLiteralArrayType(clang::QualType::getFromOpaquePtr(EltTy), Length)
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getVariableArrayDecayedType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getVariableArrayDecayedType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

// getBuiltinVectorTypeInfo

CXQualType clang_ASTContext_getScalableVectorType(CXASTContext Ctx, CXQualType EltTy,
                                                  unsigned NumElts) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getScalableVectorType(clang::QualType::getFromOpaquePtr(EltTy), NumElts)
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getVectorType(CXASTContext Ctx, CXQualType VectorType,
                                          unsigned NumElts, CXVectorKind VecKind) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getVectorType(clang::QualType::getFromOpaquePtr(VectorType), NumElts,
                      static_cast<clang::VectorKind>(VecKind))
      .getAsOpaquePtr();
}

// getVectorType

CXQualType clang_ASTContext_getDependentVectorType(CXASTContext Ctx, CXQualType VectorType,
                                                   CXExpr SizeExpr,
                                                   CXSourceLocation_ AttrLoc,
                                                   CXVectorKind VecKind) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getDependentVectorType(clang::QualType::getFromOpaquePtr(VectorType),
                               static_cast<clang::Expr *>(SizeExpr),
                               clang::SourceLocation::getFromPtrEncoding(AttrLoc),
                               static_cast<clang::VectorKind>(VecKind))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getExtVectorType(CXASTContext Ctx, CXQualType VectorType,
                                             unsigned NumElts) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getExtVectorType(clang::QualType::getFromOpaquePtr(VectorType), NumElts)
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getDependentSizedExtVectorType(CXASTContext Ctx,
                                                           CXQualType VectorType,
                                                           CXExpr SizeExpr,
                                                           CXSourceLocation_ AttrLoc) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getDependentSizedExtVectorType(clang::QualType::getFromOpaquePtr(VectorType),
                                       static_cast<clang::Expr *>(SizeExpr),
                                       clang::SourceLocation::getFromPtrEncoding(AttrLoc))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getConstantMatrixType(CXASTContext Ctx, CXQualType ElementType,
                                                  unsigned NumRows, unsigned NumCols) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getConstantMatrixType(clang::QualType::getFromOpaquePtr(ElementType), NumRows,
                              NumCols)
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getDependentSizedMatrixType(CXASTContext Ctx,
                                                        CXQualType ElementType,
                                                        CXExpr RowsExpr, CXExpr ColsExpr,
                                                        CXSourceLocation_ AttrLoc) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getDependentSizedMatrixType(clang::QualType::getFromOpaquePtr(ElementType),
                                    static_cast<clang::Expr *>(RowsExpr),
                                    static_cast<clang::Expr *>(ColsExpr),
                                    clang::SourceLocation::getFromPtrEncoding(AttrLoc))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getDependentAddressSpaceType(CXASTContext Ctx,
                                                         CXQualType PointeeType,
                                                         CXExpr AddrSpaceExpr,
                                                         CXSourceLocation_ AddrSpace) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getDependentAddressSpaceType(clang::QualType::getFromOpaquePtr(PointeeType),
                                     static_cast<clang::Expr *>(AddrSpaceExpr),
                                     clang::SourceLocation::getFromPtrEncoding(AddrSpace))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getFunctionNoProtoType(CXASTContext Ctx, CXQualType ResultTy) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getFunctionNoProtoType(clang::QualType::getFromOpaquePtr(ResultTy))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getFunctionType(CXASTContext Ctx, CXQualType ResultTy,
                                            const CXQualType *ArgTys, unsigned NumArgs,
                                            bool IsVariadic, CXCallingConv_ CC) {
  llvm::SmallVector<clang::QualType, 8> Args;
  Args.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    Args.push_back(clang::QualType::getFromOpaquePtr(ArgTys[I]));
  clang::FunctionProtoType::ExtProtoInfo EPI;
  EPI.Variadic = IsVariadic;
  EPI.ExtInfo = EPI.ExtInfo.withCallingConv(static_cast<clang::CallingConv>(CC));
  return static_cast<clang::ASTContext *>(Ctx)
      ->getFunctionType(clang::QualType::getFromOpaquePtr(ResultTy), Args, EPI)
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_adjustStringLiteralBaseType(CXASTContext Ctx,
                                                        CXQualType StrLTy) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->adjustStringLiteralBaseType(clang::QualType::getFromOpaquePtr(StrLTy))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getTypeDeclType(CXASTContext Ctx, CXTypeDecl Decl,
                                            CXTypeDecl PrevDecl) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getTypeDeclType(static_cast<clang::TypeDecl *>(Decl),
                        static_cast<clang::TypeDecl *>(PrevDecl))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getUsingType(CXASTContext Ctx, CXUsingShadowDecl Found,
                                         CXQualType Underlying) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getUsingType(static_cast<clang::UsingShadowDecl *>(Found),
                     clang::QualType::getFromOpaquePtr(Underlying))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getTypedefType(CXASTContext Ctx, CXTypedefNameDecl Decl,
                                           CXQualType Underlying) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getTypedefType(static_cast<clang::TypedefNameDecl *>(Decl),
                       clang::QualType::getFromOpaquePtr(Underlying))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getRecordType(CXASTContext Ctx, CXRecordDecl Decl) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getRecordType(static_cast<clang::RecordDecl *>(Decl))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getEnumType(CXASTContext Ctx, CXEnumDecl Decl) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getEnumType(static_cast<clang::EnumDecl *>(Decl))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getUnresolvedUsingType(CXASTContext Ctx,
                                                   CXUnresolvedUsingTypenameDecl Decl) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getUnresolvedUsingType(static_cast<clang::UnresolvedUsingTypenameDecl *>(Decl))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getInjectedClassNameType(CXASTContext Ctx, CXCXXRecordDecl Decl,
                                                     CXQualType TST) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getInjectedClassNameType(static_cast<clang::CXXRecordDecl *>(Decl),
                                 clang::QualType::getFromOpaquePtr(TST))
      .getAsOpaquePtr();
}

// getAttributedType

// CXQualType clang_ASTContext_getSubstTemplateTypeParmType(CXASTContext Ctx,
//                                                          CXTemplateTypeParmType Replaced,
//                                                          CXQualType Replacement) {
//   return static_cast<clang::ASTContext *>(Ctx)
//       ->getSubstTemplateTypeParmType(static_cast<clang::TemplateTypeParmType
//       *>(Replaced),
//                                      clang::QualType::getFromOpaquePtr(Replacement))
//       .getAsOpaquePtr();
// }

// getSubstTemplateTypeParmPackType

CXQualType clang_ASTContext_getSubstTemplateTypeParmType(CXASTContext Ctx,
                                                         CXQualType Replacement,
                                                         CXDecl AssociatedDecl,
                                                         unsigned Index, bool HasPackIndex,
                                                         unsigned PackIndex) {
  std::optional<unsigned> PI;
  if (HasPackIndex)
    PI = PackIndex;
  return static_cast<clang::ASTContext *>(Ctx)
      ->getSubstTemplateTypeParmType(clang::QualType::getFromOpaquePtr(Replacement),
                                     static_cast<clang::Decl *>(AssociatedDecl), Index, PI)
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getSubstTemplateTypeParmPackType(CXASTContext Ctx,
                                                             CXDecl AssociatedDecl,
                                                             unsigned Index, bool Final,
                                                             CXTemplateArgument ArgPack) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getSubstTemplateTypeParmPackType(static_cast<clang::Decl *>(AssociatedDecl), Index,
                                         Final,
                                         *static_cast<clang::TemplateArgument *>(ArgPack))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getTemplateTypeParmType(CXASTContext Ctx, unsigned Depth,
                                                    unsigned Index, bool ParameterPack,
                                                    CXTemplateTypeParmDecl ParmDecl) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getTemplateTypeParmType(Depth, Index, ParameterPack,
                                static_cast<clang::TemplateTypeParmDecl *>(ParmDecl))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getTemplateSpecializationType(
    CXASTContext Ctx, CXTemplateName T, const CXTemplateArgument *Args,
    unsigned NumArgs, CXQualType Underlying) {
  llvm::SmallVector<clang::TemplateArgument, 8> ArgVec;
  ArgVec.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    ArgVec.push_back(
        *static_cast<clang::TemplateArgument *>(const_cast<void *>(Args[I])));
  return static_cast<clang::ASTContext *>(Ctx)
      ->getTemplateSpecializationType(
          clang::TemplateName::getFromVoidPointer(const_cast<void *>(T)), ArgVec,
          clang::QualType::getFromOpaquePtr(Underlying))
      .getAsOpaquePtr();
}


CXQualType clang_ASTContext_getCanonicalTemplateSpecializationType(
    CXASTContext Ctx, CXTemplateName T, const CXTemplateArgument *Args, unsigned NumArgs) {
  llvm::SmallVector<clang::TemplateArgument, 8> ArgVec;
  ArgVec.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    ArgVec.push_back(*static_cast<clang::TemplateArgument *>(const_cast<void *>(Args[I])));
  return static_cast<clang::ASTContext *>(Ctx)
      ->getCanonicalTemplateSpecializationType(
          clang::TemplateName::getFromVoidPointer(const_cast<void *>(T)), ArgVec)
      .getAsOpaquePtr();
}
// getTemplateSpecializationType (TemplateArgumentLoc overload)

CXTypeSourceInfo clang_ASTContext_getTemplateSpecializationTypeInfo(
    CXASTContext Ctx, CXTemplateName T, CXSourceLocation_ TLoc,
    CXTemplateArgumentListInfo Args, CXQualType Canon) {
  return static_cast<clang::ASTContext *>(Ctx)->getTemplateSpecializationTypeInfo(
      clang::TemplateName::getFromVoidPointer(T),
      clang::SourceLocation::getFromPtrEncoding(TLoc),
      *static_cast<clang::TemplateArgumentListInfo *>(Args),
      clang::QualType::getFromOpaquePtr(Canon));
}

CXQualType clang_ASTContext_getParenType(CXASTContext Ctx, CXQualType NamedType) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getParenType(clang::QualType::getFromOpaquePtr(NamedType))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getMacroQualifiedType(CXASTContext Ctx, CXQualType UnderlyingTy,
                                                  CXIdentifierInfo MacroII) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getMacroQualifiedType(clang::QualType::getFromOpaquePtr(UnderlyingTy),
                              static_cast<clang::IdentifierInfo *>(MacroII))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getElaboratedType(CXASTContext Ctx,
                                              CXElaboratedTypeKeyword Keyword,
                                              CXNestedNameSpecifier NNS,
                                              CXQualType NamedType,
                                              CXTagDecl OwnedTagDecl) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getElaboratedType(static_cast<clang::ElaboratedTypeKeyword>(Keyword),
                          static_cast<clang::NestedNameSpecifier *>(NNS),
                          clang::QualType::getFromOpaquePtr(NamedType),
                          static_cast<clang::TagDecl *>(OwnedTagDecl))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getPackExpansionType(CXASTContext Ctx, CXQualType Pattern,
                                                 bool HasNumExpansions,
                                                 unsigned NumExpansions,
                                                 bool ExpectPackInType) {
  std::optional<unsigned> Num =
      HasNumExpansions ? std::optional<unsigned>(NumExpansions) : std::nullopt;
  return static_cast<clang::ASTContext *>(Ctx)
      ->getPackExpansionType(clang::QualType::getFromOpaquePtr(Pattern), Num,
                             ExpectPackInType)
      .getAsOpaquePtr();
}

// getElaboratedType

CXQualType clang_ASTContext_getDependentNameType(CXASTContext Ctx,
                                                 CXElaboratedTypeKeyword Keyword,
                                                 CXNestedNameSpecifier NNS,
                                                 CXIdentifierInfo Name, CXQualType Canon) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getDependentNameType(static_cast<clang::ElaboratedTypeKeyword>(Keyword),
                             static_cast<clang::NestedNameSpecifier *>(NNS),
                             static_cast<clang::IdentifierInfo *>(Name),
                             clang::QualType::getFromOpaquePtr(Canon))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getDependentTemplateSpecializationType(
    CXASTContext Ctx, CXElaboratedTypeKeyword Keyword, CXNestedNameSpecifier NNS,
    CXIdentifierInfo Name, const CXTemplateArgument *Args, unsigned NumArgs) {
  llvm::SmallVector<clang::TemplateArgument, 8> ArgVec;
  ArgVec.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    ArgVec.push_back(*static_cast<clang::TemplateArgument *>(const_cast<void *>(Args[I])));
  return static_cast<clang::ASTContext *>(Ctx)
      ->getDependentTemplateSpecializationType(
          static_cast<clang::ElaboratedTypeKeyword>(Keyword),
          static_cast<clang::NestedNameSpecifier *>(NNS),
          static_cast<clang::IdentifierInfo *>(Name),
          llvm::ArrayRef<clang::TemplateArgument>(ArgVec))
      .getAsOpaquePtr();
}

CXTemplateArgument clang_ASTContext_getInjectedTemplateArg(CXASTContext Ctx,
                                                           CXNamedDecl ParamDecl) {
  std::unique_ptr<clang::TemplateArgument> ptr = std::make_unique<clang::TemplateArgument>(
      static_cast<clang::ASTContext *>(Ctx)->getInjectedTemplateArg(
          static_cast<clang::NamedDecl *>(ParamDecl)));
  return ptr.release();
}
// getInjectedTempalteArgs

void clang_ASTContext_getInjectedTemplateArgs(CXASTContext Ctx,
                                              CXTemplateParameterList Params,
                                              CXTemplateArgument *Buf) {
  llvm::SmallVector<clang::TemplateArgument, 4> Args;
  static_cast<clang::ASTContext *>(Ctx)->getInjectedTemplateArgs(
      static_cast<clang::TemplateParameterList *>(Params), Args);
  for (unsigned I = 0; I < Args.size(); ++I)
    Buf[I] = std::make_unique<clang::TemplateArgument>(Args[I]).release();
}
// getPackExpansionType
// getObjCInterfaceType
// gvetObjCObjectType
// getObjCTypeParamType
// adjustObjCTypeParamBoundType
// ObjCObjectAdoptsQTypeProtocols
// QIdProtocolsAdoptObjCObjectProtocols
// getObjCObjectPointerType

// CXQualType clang_ASTContext_getTypeOfExprType(CXASTContext Ctx, CXExpr Expr) {
//   return static_cast<clang::ASTContext *>(Ctx)
//       ->getTypeOfExprType(static_cast<clang::Expr *>(Expr))
//       .getAsOpaquePtr();
// }

// CXQualType clang_ASTContext_getTypeOfType(CXASTContext Ctx, CXType_ T) {
//   return static_cast<clang::ASTContext *>(Ctx)
//       ->getTypeOfType(clang::QualType::getFromOpaquePtr(T))
//       .getAsOpaquePtr();
// }

CXQualType clang_ASTContext_getTypeOfExprType(CXASTContext Ctx, CXExpr E,
                                              bool Unqualified) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getTypeOfExprType(static_cast<clang::Expr *>(E),
                          Unqualified ? clang::TypeOfKind::Unqualified
                                      : clang::TypeOfKind::Qualified)
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getTypeOfType(CXASTContext Ctx, CXQualType QT,
                                          bool Unqualified) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getTypeOfType(clang::QualType::getFromOpaquePtr(QT),
                      Unqualified ? clang::TypeOfKind::Unqualified
                                  : clang::TypeOfKind::Qualified)
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getReferenceQualifiedType(CXASTContext Ctx, CXExpr E) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getReferenceQualifiedType(static_cast<clang::Expr *>(E))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getDecltypeType(CXASTContext Ctx, CXExpr Expr,
                                            CXQualType UnderlyingType) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getDecltypeType(static_cast<clang::Expr *>(Expr),
                        clang::QualType::getFromOpaquePtr(UnderlyingType))
      .getAsOpaquePtr();
}

// getUnaryTransformType
// getAutoType

CXQualType clang_ASTContext_getUnaryTransformType(CXASTContext Ctx, CXQualType BaseType,
                                                  CXQualType UnderlyingType,
                                                  CXUTTKind UKind) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getUnaryTransformType(clang::QualType::getFromOpaquePtr(BaseType),
                              clang::QualType::getFromOpaquePtr(UnderlyingType),
                              static_cast<clang::UnaryTransformType::UTTKind>(UKind))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getAutoType(CXASTContext Ctx, CXQualType DeducedType,
                                        CXAutoTypeKeyword Keyword, bool IsDependent,
                                        bool IsPack, CXConceptDecl TypeConstraintConcept,
                                        const CXTemplateArgument *TypeConstraintArgs,
                                        unsigned NumArgs) {
  llvm::SmallVector<clang::TemplateArgument, 8> ArgVec;
  ArgVec.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    ArgVec.push_back(
        *static_cast<clang::TemplateArgument *>(const_cast<void *>(TypeConstraintArgs[I])));
  return static_cast<clang::ASTContext *>(Ctx)
      ->getAutoType(clang::QualType::getFromOpaquePtr(DeducedType),
                    static_cast<clang::AutoTypeKeyword>(Keyword), IsDependent, IsPack,
                    static_cast<clang::ConceptDecl *>(TypeConstraintConcept), ArgVec)
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getAutoDeductType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getAutoDeductType().getAsOpaquePtr();
}

CXQualType clang_ASTContext_getAutoRRefDeductType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getAutoRRefDeductType().getAsOpaquePtr();
}

CXQualType clang_ASTContext_getUnconstrainedType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getUnconstrainedType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getDeducedTemplateSpecializationType(CXASTContext Ctx,
                                                                 CXTemplateName Template,
                                                                 CXQualType DeducedType,
                                                                 bool IsDependent) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getDeducedTemplateSpecializationType(
          clang::TemplateName::getFromVoidPointer(Template),
          clang::QualType::getFromOpaquePtr(DeducedType), IsDependent)
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getTagDeclType(CXASTContext Ctx, CXTagDecl Decl) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getTagDeclType(static_cast<clang::TagDecl *>(Decl))
      .getAsOpaquePtr();
}

// getSizeType
// getSignedSizeType

CXQualType clang_ASTContext_getIntMaxType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getIntMaxType().getAsOpaquePtr();
}
// getUIntMaxType

CXQualType clang_ASTContext_getSizeType(CXASTContext Ctx) {
  return clang::QualType(static_cast<clang::ASTContext *>(Ctx)->getSizeType())
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getSignedSizeType(CXASTContext Ctx) {
  return clang::QualType(static_cast<clang::ASTContext *>(Ctx)->getSignedSizeType())
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getUIntMaxType(CXASTContext Ctx) {
  return clang::QualType(static_cast<clang::ASTContext *>(Ctx)->getUIntMaxType())
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getWCharType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getWCharType().getAsOpaquePtr();
}

CXQualType clang_ASTContext_getWideCharType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getWideCharType().getAsOpaquePtr();
}

CXQualType clang_ASTContext_getSignedWCharType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getSignedWCharType().getAsOpaquePtr();
}

CXQualType clang_ASTContext_getUnsignedWCharType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getUnsignedWCharType().getAsOpaquePtr();
}

CXQualType clang_ASTContext_getWIntType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getWIntType().getAsOpaquePtr();
}

CXQualType clang_ASTContext_getIntPtrType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getIntPtrType().getAsOpaquePtr();
}

CXQualType clang_ASTContext_getUIntPtrType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getUIntPtrType().getAsOpaquePtr();
}

CXQualType clang_ASTContext_getPointerDiffType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getPointerDiffType().getAsOpaquePtr();
}

CXQualType clang_ASTContext_getUnsignedPointerDiffType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getUnsignedPointerDiffType()
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getProcessIDType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getProcessIDType().getAsOpaquePtr();
}

CXQualType clang_ASTContext_getCFConstantStringType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getCFConstantStringType().getAsOpaquePtr();
}

CXQualType clang_ASTContext_getObjCSuperType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getObjCSuperType().getAsOpaquePtr();
}

void clang_ASTContext_setObjCSuperType(CXASTContext Ctx, CXQualType ST) {
  static_cast<clang::ASTContext *>(Ctx)->setObjCSuperType(
      clang::QualType::getFromOpaquePtr(ST));
}

CXQualType clang_ASTContext_getRawCFConstantStringType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getRawCFConstantStringType()
      .getAsOpaquePtr();
}

void clang_ASTContext_setCFConstantStringType(CXASTContext Ctx, CXQualType T) {
  static_cast<clang::ASTContext *>(Ctx)->setCFConstantStringType(
      clang::QualType::getFromOpaquePtr(T));
}

CXTypedefDecl clang_ASTContext_getCFContantStringDecl(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getCFConstantStringDecl();
}

CXRecordDecl clang_ASTContext_getCFConstantStringTagDecl(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getCFConstantStringTagDecl();
}

// void clang_ASTContext_setObjCConstantStringInterface(CXASTContext Ctx,
//                                                      CXObjCInterfaceDecl ID) {
//   static_cast<clang::ASTContext *>(Ctx)->setObjCConstantStringInterface(
//       static_cast<clang::ObjCInterfaceDecl *>(ID));
// }

// getObjCConstantStringInterface
// getObjCNSStringType
// setObjCNSStringType

CXQualType clang_ASTContext_getObjCConstantStringInterface(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getObjCConstantStringInterface()
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getObjCNSStringType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getObjCNSStringType().getAsOpaquePtr();
}

void clang_ASTContext_setObjCNSStringType(CXASTContext Ctx, CXQualType T) {
  static_cast<clang::ASTContext *>(Ctx)->setObjCNSStringType(
      clang::QualType::getFromOpaquePtr(T));
}

CXQualType clang_ASTContext_getObjCIdRedefinitionType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getObjCIdRedefinitionType()
      .getAsOpaquePtr();
}

void clang_ASTContext_setObjCIdRedefinitionType(CXASTContext Ctx, CXQualType T) {
  static_cast<clang::ASTContext *>(Ctx)->setObjCIdRedefinitionType(
      clang::QualType::getFromOpaquePtr(T));
}

CXQualType clang_ASTContext_getObjCClassRedefinitionType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getObjCClassRedefinitionType()
      .getAsOpaquePtr();
}

void clang_ASTContext_setObjCClassRedefinitionType(CXASTContext Ctx, CXQualType T) {
  static_cast<clang::ASTContext *>(Ctx)->setObjCClassRedefinitionType(
      clang::QualType::getFromOpaquePtr(T));
}

CXQualType clang_ASTContext_getObjCSelRedefinitionType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getObjCSelRedefinitionType()
      .getAsOpaquePtr();
}

void clang_ASTContext_setObjCSelRedefinitionType(CXASTContext Ctx, CXQualType T) {
  static_cast<clang::ASTContext *>(Ctx)->setObjCSelRedefinitionType(
      clang::QualType::getFromOpaquePtr(T));
}

CXIdentifierInfo clang_ASTContext_getNSObjectName(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getNSObjectName();
}

CXIdentifierInfo clang_ASTContext_getNSCopyingName(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getNSCopyingName();
}

CXQualType clang_ASTContext_getNSUIntegerType(CXASTContext Ctx) {
  return clang::QualType(static_cast<clang::ASTContext *>(Ctx)->getNSUIntegerType())
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getNSIntegerType(CXASTContext Ctx) {
  return clang::QualType(static_cast<clang::ASTContext *>(Ctx)->getNSIntegerType())
      .getAsOpaquePtr();
}

// getNSUIntegerType
// getNSIntegerType

CXIdentifierInfo clang_ASTContext_getBoolName(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getBoolName();
}

CXIdentifierInfo clang_ASTContext_getMakeIntegerSeqName(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getMakeIntegerSeqName();
}

CXIdentifierInfo clang_ASTContext_getTypePackElementName(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getTypePackElementName();
}

CXQualType clang_ASTContext_getObjCInstanceType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getObjCInstanceType().getAsOpaquePtr();
}

CXTypedefDecl clang_ASTContext_getObjCInstanceTypeDecl(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getObjCInstanceTypeDecl();
}

void clang_ASTContext_setFILEDecl(CXASTContext Ctx, CXTypeDecl FILEDecl) {
  static_cast<clang::ASTContext *>(Ctx)->setFILEDecl(
      static_cast<clang::TypeDecl *>(FILEDecl));
}

CXQualType clang_ASTContext_getFILEType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getFILEType().getAsOpaquePtr();
}

void clang_ASTContext_setjmp_bufDecl(CXASTContext Ctx, CXTypeDecl D) {
  static_cast<clang::ASTContext *>(Ctx)->setjmp_bufDecl(static_cast<clang::TypeDecl *>(D));
}

void clang_ASTContext_setsigjmp_bufDecl(CXASTContext Ctx, CXTypeDecl D) {
  static_cast<clang::ASTContext *>(Ctx)->setsigjmp_bufDecl(
      static_cast<clang::TypeDecl *>(D));
}

void clang_ASTContext_setucontext_tDecl(CXASTContext Ctx, CXTypeDecl D) {
  static_cast<clang::ASTContext *>(Ctx)->setucontext_tDecl(
      static_cast<clang::TypeDecl *>(D));
}

CXQualType clang_ASTContext_getjmp_bufType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getjmp_bufType().getAsOpaquePtr();
}

CXQualType clang_ASTContext_getsigjmp_bufType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getsigjmp_bufType().getAsOpaquePtr();
}

CXQualType clang_ASTContext_getucontext_tType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getucontext_tType().getAsOpaquePtr();
}

CXQualType clang_ASTContext_getLogicalOperationType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getLogicalOperationType().getAsOpaquePtr();
}

CXString clang_ASTContext_getObjCEncodingForType(CXASTContext Ctx, CXQualType T) {
  std::string S;
  static_cast<clang::ASTContext *>(Ctx)->getObjCEncodingForType(
      clang::QualType::getFromOpaquePtr(T), S);
  return extra::makeCXString(S);
}

CXString clang_ASTContext_getObjCEncodingForPropertyType(CXASTContext Ctx, CXQualType T) {
  std::string S;
  static_cast<clang::ASTContext *>(Ctx)->getObjCEncodingForPropertyType(
      clang::QualType::getFromOpaquePtr(T), S);
  return extra::makeCXString(S);
}

CXQualType clang_ASTContext_getLegacyIntegralTypeEncoding(CXASTContext Ctx, CXQualType T) {
  clang::QualType QT = clang::QualType::getFromOpaquePtr(T);
  static_cast<clang::ASTContext *>(Ctx)->getLegacyIntegralTypeEncoding(QT);
  return QT.getAsOpaquePtr();
}

CXString clang_ASTContext_getObjCEncodingForFunctionDecl(CXASTContext Ctx,
                                                         CXFunctionDecl D) {
  return extra::makeCXString(
      static_cast<clang::ASTContext *>(Ctx)->getObjCEncodingForFunctionDecl(
          static_cast<clang::FunctionDecl *>(D)));
}

int64_t clang_ASTContext_getObjCEncodingTypeSize(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getObjCEncodingTypeSize(clang::QualType::getFromOpaquePtr(T))
      .getQuantity();
}

// getObjCEncodingForType
// getObjCEncodingForPropertyType
// getLegacyIntegralTypeEncoding
// getObjCEncodingForTypeQualifier
// getObjCEncodingForFunctionDecl
// getObjCEncodingForMethodDecl
// getObjCEncodingForBlock
// getObjCEncodingForPropertyDecl
// ProtocolCompatibleWithProtocol
// getObjCPropertyImplDeclForPropertyDecl
// getObjCEncodingTypeSize
// getObjCIdDecl
// getObjCIdType
// getObjCSelDecl
// getObjCSelType
// getObjCClassDecl
// getObjCClassType

CXTypedefDecl clang_ASTContext_getObjCIdDecl(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getObjCIdDecl();
}

CXQualType clang_ASTContext_getObjCIdType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getObjCIdType().getAsOpaquePtr();
}

CXTypedefDecl clang_ASTContext_getObjCSelDecl(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getObjCSelDecl();
}

CXQualType clang_ASTContext_getObjCSelType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getObjCSelType().getAsOpaquePtr();
}

CXTypedefDecl clang_ASTContext_getObjCClassDecl(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getObjCClassDecl();
}

CXQualType clang_ASTContext_getObjCClassType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getObjCClassType().getAsOpaquePtr();
}
// getObjCProtocolDecl

CXTypedefDecl clang_ASTContext_getBOOLDecl(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getBOOLDecl();
}

void clang_ASTContext_setBOOLDecl(CXASTContext Ctx, CXTypedefDecl TD) {
  static_cast<clang::ASTContext *>(Ctx)->setBOOLDecl(static_cast<clang::TypedefDecl *>(TD));
}

CXQualType clang_ASTContext_getBOOLType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getBOOLType().getAsOpaquePtr();
}

CXQualType clang_ASTContext_getObjCProtoType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getObjCProtoType().getAsOpaquePtr();
}

CXTypedefDecl clang_ASTContext_getBuiltinVaListDecl(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getBuiltinVaListDecl();
}

CXQualType clang_ASTContext_getBuiltinVaListType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getBuiltinVaListType().getAsOpaquePtr();
}

CXDecl clang_ASTContext_getVaListTagDecl(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getVaListTagDecl();
}

CXTypedefDecl clang_ASTContext_getBuiltinMSVaListDecl(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getBuiltinMSVaListDecl();
}

CXQualType clang_ASTContext_getBuiltinMSVaListType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getBuiltinMSVaListType().getAsOpaquePtr();
}

CXTagDecl clang_ASTContext_getMSGuidTagDecl(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getMSGuidTagDecl();
}

CXTagType clang_ASTContext_getMSGuidType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getMSGuidType().getAsOpaquePtr();
}

bool clang_ASTContext_canBuiltinBeRedeclared(CXASTContext Ctx, CXFunctionDecl D) {
  return static_cast<clang::ASTContext *>(Ctx)->canBuiltinBeRedeclared(
      static_cast<clang::FunctionDecl *>(D));
}

CXQualType clang_ASTContext_getCVRQualifiedType(CXASTContext Ctx, CXQualType T,
                                                unsigned CVR) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getCVRQualifiedType(clang::QualType::getFromOpaquePtr(T), CVR)
      .getAsOpaquePtr();
}

// getQualifiedType

CXQualType clang_ASTContext_getLifetimeQualifiedType(CXASTContext Ctx, CXQualType T,
                                                     CXQualifiers_ObjCLifetime Lifetime) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getLifetimeQualifiedType(clang::QualType::getFromOpaquePtr(T),
                                 static_cast<clang::Qualifiers::ObjCLifetime>(Lifetime))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getUnqualifiedObjCPointerType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getUnqualifiedObjCPointerType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

unsigned char clang_ASTContext_getFixedPointScale(CXASTContext Ctx, CXQualType Ty) {
  return static_cast<clang::ASTContext *>(Ctx)->getFixedPointScale(
      clang::QualType::getFromOpaquePtr(Ty));
}

unsigned char clang_ASTContext_getFixedPointIBits(CXASTContext Ctx, CXQualType Ty) {
  return static_cast<clang::ASTContext *>(Ctx)->getFixedPointIBits(
      clang::QualType::getFromOpaquePtr(Ty));
}

// getFixedPointSemantics
// getFixedPointMax
// getFixedPointMin

CXDeclarationNameInfo clang_ASTContext_getNameForTemplate(CXASTContext Ctx,
                                                          CXTemplateName Name,
                                                          CXSourceLocation_ NameLoc) {
  std::unique_ptr<clang::DeclarationNameInfo> ptr =
      std::make_unique<clang::DeclarationNameInfo>(
          static_cast<clang::ASTContext *>(Ctx)->getNameForTemplate(
              clang::TemplateName::getFromVoidPointer(Name),
              clang::SourceLocation::getFromPtrEncoding(NameLoc)));
  return ptr.release();
}

CXTemplateName clang_ASTContext_getOverloadedTemplateName(CXASTContext Ctx,
                                                          const CXNamedDecl *Decls,
                                                          unsigned NumDecls) {
  clang::UnresolvedSet<8> Set;
  for (unsigned I = 0; I < NumDecls; ++I)
    Set.addDecl(static_cast<clang::NamedDecl *>(Decls[I]));
  return static_cast<clang::ASTContext *>(Ctx)
      ->getOverloadedTemplateName(Set.begin(), Set.end())
      .getAsVoidPointer();
}

CXTemplateName clang_ASTContext_getAssumedTemplateName(CXASTContext Ctx,
                                                       CXDeclarationName Name) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getAssumedTemplateName(clang::DeclarationName::getFromOpaquePtr(Name))
      .getAsVoidPointer();
}

// CXTemplateName clang_ASTContext_getQualifiedTemplateName(CXASTContext Ctx,
//                                                          CXNestedNameSpecifier NNS,
//                                                          bool TemplateKeyword,
//                                                          CXTemplateDecl Template) {
//   return static_cast<clang::ASTContext *>(Ctx)
//       ->getQualifiedTemplateName(static_cast<clang::NestedNameSpecifier *>(NNS),
//                                  TemplateKeyword,
//                                  static_cast<clang::TemplateDecl *>(Template))
//       .getAsVoidPointer();
// }

CXTemplateName clang_ASTContext_getQualifiedTemplateName(CXASTContext Ctx,
                                                         CXNestedNameSpecifier NNS,
                                                         bool TemplateKeyword,
                                                         CXTemplateName Template) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getQualifiedTemplateName(static_cast<clang::NestedNameSpecifier *>(NNS),
                                 TemplateKeyword,
                                 clang::TemplateName::getFromVoidPointer(Template))
      .getAsVoidPointer();
}

CXTemplateName clang_ASTContext_getDependentTemplateName(CXASTContext Ctx,
                                                         CXNestedNameSpecifier NNS,
                                                         CXIdentifierInfo Name) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getDependentTemplateName(static_cast<clang::NestedNameSpecifier *>(NNS),
                                 static_cast<clang::IdentifierInfo *>(Name))
      .getAsVoidPointer();
}

// CXTemplateName clang_ASTContext_getSubstTemplateTemplateParm(
//     CXASTContext Ctx, CXTemplateTemplateParmDecl param, CXTemplateName replacement) {
//   return static_cast<clang::ASTContext *>(Ctx)
//       ->getSubstTemplateTemplateParm(static_cast<clang::TemplateTemplateParmDecl
//       *>(param),
//                                      clang::TemplateName::getFromVoidPointer(replacement))
//       .getAsVoidPointer();
// }

// getSubstTemplateTemplateParmPack

CXTemplateName
clang_ASTContext_getSubstTemplateTemplateParm(CXASTContext Ctx, CXTemplateName Replacement,
                                              CXDecl AssociatedDecl, unsigned Index,
                                              bool HasPackIndex, unsigned PackIndex) {
  std::optional<unsigned> PI;
  if (HasPackIndex)
    PI = PackIndex;
  return static_cast<clang::ASTContext *>(Ctx)
      ->getSubstTemplateTemplateParm(clang::TemplateName::getFromVoidPointer(Replacement),
                                     static_cast<clang::Decl *>(AssociatedDecl), Index, PI)
      .getAsVoidPointer();
}

CXTemplateName clang_ASTContext_getSubstTemplateTemplateParmPack(CXASTContext Ctx,
                                                                 CXTemplateArgument ArgPack,
                                                                 CXDecl AssociatedDecl,
                                                                 unsigned Index,
                                                                 bool Final) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getSubstTemplateTemplateParmPack(*static_cast<clang::TemplateArgument *>(ArgPack),
                                         static_cast<clang::Decl *>(AssociatedDecl), Index,
                                         Final)
      .getAsVoidPointer();
}
// DecodeTypeStr

CXQualType clang_ASTContext_GetBuiltinType(CXASTContext Ctx, unsigned ID,
                                           CXGetBuiltinTypeError *Error,
                                           unsigned *IntegerConstantArgs) {
  clang::ASTContext::GetBuiltinTypeError Err = clang::ASTContext::GE_None;
  // clang only ORs bits into this out-param, so the zeroing is part of the protocol.
  if (IntegerConstantArgs)
    *IntegerConstantArgs = 0;
  clang::QualType T =
      static_cast<clang::ASTContext *>(Ctx)->GetBuiltinType(ID, Err, IntegerConstantArgs);
  *Error = static_cast<CXGetBuiltinTypeError>(Err);
  return T.getAsOpaquePtr();
}

CXQualifiers_GC clang_ASTContext_getObjCGCAttrKind(CXASTContext Ctx, CXQualType Ty) {
  return static_cast<CXQualifiers_GC>(
      static_cast<clang::ASTContext *>(Ctx)->getObjCGCAttrKind(
          clang::QualType::getFromOpaquePtr(Ty)));
}

bool clang_ASTContext_areCompatibleVectorTypes(CXASTContext Ctx, CXQualType FirstVec,
                                               CXQualType SecondVec) {
  return static_cast<clang::ASTContext *>(Ctx)->areCompatibleVectorTypes(
      clang::QualType::getFromOpaquePtr(FirstVec),
      clang::QualType::getFromOpaquePtr(SecondVec));
}

bool clang_ASTContext_areCompatibleSveTypes(CXASTContext Ctx, CXQualType FirstVec,
                                            CXQualType SecondVec) {
  return static_cast<clang::ASTContext *>(Ctx)->areCompatibleSveTypes(
      clang::QualType::getFromOpaquePtr(FirstVec),
      clang::QualType::getFromOpaquePtr(SecondVec));
}

bool clang_ASTContext_areLaxCompatibleSveTypes(CXASTContext Ctx, CXQualType FirstVec,
                                               CXQualType SecondVec) {
  return static_cast<clang::ASTContext *>(Ctx)->areLaxCompatibleSveTypes(
      clang::QualType::getFromOpaquePtr(FirstVec),
      clang::QualType::getFromOpaquePtr(SecondVec));
}

bool clang_ASTContext_areCompatibleRVVTypes(CXASTContext Ctx, CXQualType FirstType,
                                            CXQualType SecondType) {
  return static_cast<clang::ASTContext *>(Ctx)->areCompatibleRVVTypes(
      clang::QualType::getFromOpaquePtr(FirstType),
      clang::QualType::getFromOpaquePtr(SecondType));
}

bool clang_ASTContext_areLaxCompatibleRVVTypes(CXASTContext Ctx, CXQualType FirstType,
                                               CXQualType SecondType) {
  return static_cast<clang::ASTContext *>(Ctx)->areLaxCompatibleRVVTypes(
      clang::QualType::getFromOpaquePtr(FirstType),
      clang::QualType::getFromOpaquePtr(SecondType));
}

bool clang_ASTContext_hasDirectOwnershipQualifier(CXASTContext Ctx, CXQualType Ty) {
  return static_cast<clang::ASTContext *>(Ctx)->hasDirectOwnershipQualifier(
      clang::QualType::getFromOpaquePtr(Ty));
}

bool clang_ASTContext_isObjCNSObjectType(CXQualType Ty) {
  return clang::ASTContext::isObjCNSObjectType(clang::QualType::getFromOpaquePtr(Ty));
}

// isObjCNSObjectType
// getFloatTypeSemantics

unsigned clang_ASTContext_getFloatTypeSemanticsPrecision(CXASTContext Ctx, CXQualType T) {
  return llvm::APFloat::semanticsPrecision(
      static_cast<clang::ASTContext *>(Ctx)->getFloatTypeSemantics(
          clang::QualType::getFromOpaquePtr(T)));
}

unsigned clang_ASTContext_getFloatTypeSemanticsSizeInBits(CXASTContext Ctx, CXQualType T) {
  return llvm::APFloat::semanticsSizeInBits(
      static_cast<clang::ASTContext *>(Ctx)->getFloatTypeSemantics(
          clang::QualType::getFromOpaquePtr(T)));
}
// getTypeInfo

unsigned clang_ASTContext_getOpenMPDefaultSimdAlign(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)->getOpenMPDefaultSimdAlign(
      clang::QualType::getFromOpaquePtr(T));
}

uint64_t clang_ASTContext_getTypeSize(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)->getTypeSize(
      clang::QualType::getFromOpaquePtr(T));
}

uint64_t clang_ASTContext_getCharWidth(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getCharWidth();
}

// toCharUnitsFromBits
// toBits
// getTypeSizeInChars
// getTypeSizeInCharsIfKnown

uint64_t clang_ASTContext_getSizeOf(CXASTContext Ctx, CXQualType T) {
  auto QT = clang::QualType::getFromOpaquePtr(T);
  if (QT->isReferenceType())
    QT = QT.getNonReferenceType();
  auto S = static_cast<clang::ASTContext *>(Ctx)->getTypeSizeInCharsIfKnown(QT).value_or(
      clang::CharUnits::Zero());
  return S.getQuantity();
}

unsigned clang_ASTContext_getTypeAlign(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)->getTypeAlign(
      clang::QualType::getFromOpaquePtr(T));
}

unsigned clang_ASTContext_getTypeUnadjustedAlign(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)->getTypeUnadjustedAlign(
      clang::QualType::getFromOpaquePtr(T));
}

unsigned clang_ASTContext_getTypeAlignIfKnown(CXASTContext Ctx, CXQualType T,
                                              bool NeedsPreferredAlignment) {
  return static_cast<clang::ASTContext *>(Ctx)->getTypeAlignIfKnown(
      clang::QualType::getFromOpaquePtr(T), NeedsPreferredAlignment);
}

// getTypeAlignInChars
// getPreferredTypeAlignInChars
// getTypeUnadjustedAlignInChars
// getTypeInfoDataSizeInChars
// getTypeInfoInChars

bool clang_ASTContext_isAlignmentRequired(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)->isAlignmentRequired(
      clang::QualType::getFromOpaquePtr(T));
}

unsigned clang_ASTContext_getPreferredTypeAlign(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)->getPreferredTypeAlign(
      clang::QualType::getFromOpaquePtr(T));
}

unsigned clang_ASTContext_getTargetDefaultAlignForAttributeAligned(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getTargetDefaultAlignForAttributeAligned();
}

unsigned clang_ASTContext_getAlignOfGlobalVar(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)->getAlignOfGlobalVar(
      clang::QualType::getFromOpaquePtr(T));
}

void clang_ASTContext_getTypeInfo(CXASTContext Ctx, CXQualType T, uint64_t *Width,
                                  unsigned *Align,
                                  CXAlignRequirementKind *AlignRequirement) {
  clang::TypeInfo Info = static_cast<clang::ASTContext *>(Ctx)->getTypeInfo(
      clang::QualType::getFromOpaquePtr(T));
  *Width = Info.Width;
  *Align = Info.Align;
  *AlignRequirement = static_cast<CXAlignRequirementKind>(Info.AlignRequirement);
}

void clang_ASTContext_getTypeInfoInChars(CXASTContext Ctx, CXQualType T,
                                         int64_t *Width, int64_t *Align,
                                         CXAlignRequirementKind *AlignRequirement) {
  clang::TypeInfoChars Info =
      static_cast<clang::ASTContext *>(Ctx)->getTypeInfoInChars(
          clang::QualType::getFromOpaquePtr(T));
  *Width = Info.Width.getQuantity();
  *Align = Info.Align.getQuantity();
  *AlignRequirement = static_cast<CXAlignRequirementKind>(Info.AlignRequirement);
}

int64_t clang_ASTContext_getTypeSizeInChars(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getTypeSizeInChars(clang::QualType::getFromOpaquePtr(T))
      .getQuantity();
}

int64_t clang_ASTContext_getTypeAlignInChars(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getTypeAlignInChars(clang::QualType::getFromOpaquePtr(T))
      .getQuantity();
}

int64_t clang_ASTContext_getPreferredTypeAlignInChars(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getPreferredTypeAlignInChars(clang::QualType::getFromOpaquePtr(T))
      .getQuantity();
}

int64_t clang_ASTContext_getTypeUnadjustedAlignInChars(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getTypeUnadjustedAlignInChars(clang::QualType::getFromOpaquePtr(T))
      .getQuantity();
}

bool clang_ASTContext_getTypeSizeInCharsIfKnown(CXASTContext Ctx, CXQualType T,
                                                int64_t *Size) {
  auto S = static_cast<clang::ASTContext *>(Ctx)->getTypeSizeInCharsIfKnown(
      clang::QualType::getFromOpaquePtr(T));
  if (!S)
    return false;
  *Size = S->getQuantity();
  return true;
}

void clang_ASTContext_getTypeInfoDataSizeInChars(CXASTContext Ctx, CXQualType T,
                                                 int64_t *Width, int64_t *Align,
                                                 CXAlignRequirementKind *AlignRequirement) {
  clang::TypeInfoChars Info =
      static_cast<clang::ASTContext *>(Ctx)->getTypeInfoDataSizeInChars(
          clang::QualType::getFromOpaquePtr(T));
  *Width = Info.Width.getQuantity();
  *Align = Info.Align.getQuantity();
  *AlignRequirement = static_cast<CXAlignRequirementKind>(Info.AlignRequirement);
}

int64_t clang_ASTContext_toCharUnitsFromBits(CXASTContext Ctx, int64_t BitSize) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->toCharUnitsFromBits(BitSize)
      .getQuantity();
}

int64_t clang_ASTContext_toBits(CXASTContext Ctx, int64_t CharSize) {
  return static_cast<clang::ASTContext *>(Ctx)->toBits(
      clang::CharUnits::fromQuantity(CharSize));
}

int64_t clang_ASTContext_getDeclAlign(CXASTContext Ctx, CXDecl D, bool ForAlignof) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getDeclAlign(static_cast<clang::Decl *>(D), ForAlignof)
      .getQuantity();
}

int64_t clang_ASTContext_getAlignOfGlobalVarInChars(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getAlignOfGlobalVarInChars(clang::QualType::getFromOpaquePtr(T))
      .getQuantity();
}

int64_t clang_ASTContext_getExnObjectAlignment(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getExnObjectAlignment().getQuantity();
}

// getAlignOfGlobalVarInChars
// getDeclAlign
// getExnObjectAlignment

CXASTRecordLayout clang_ASTContext_getASTRecordLayout(CXASTContext Ctx,
                                                      CXRecordDecl RD) {
  return const_cast<clang::ASTRecordLayout *>(
      &static_cast<clang::ASTContext *>(Ctx)->getASTRecordLayout(
          static_cast<clang::RecordDecl *>(RD)));
}
// getASTObjCInterfaceLayout

CXString clang_ASTContext_DumpRecordLayout(CXASTContext Ctx, CXRecordDecl RD, bool Simple) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  static_cast<clang::ASTContext *>(Ctx)->DumpRecordLayout(
      static_cast<clang::RecordDecl *>(RD), OS, Simple);
  return extra::makeCXString(OS.str());
}
// getASTObjCImplementationLayout

CXCXXMethodDecl clang_ASTContext_getCurrentKeyFunction(CXASTContext Ctx,
                                                       CXCXXRecordDecl RD) {
  return const_cast<clang::CXXMethodDecl *>(
      static_cast<clang::ASTContext *>(Ctx)->getCurrentKeyFunction(
          static_cast<clang::CXXRecordDecl *>(RD)));
}
// setNonKeyFunction
// getOffsetOfBaseWithVBPtr

uint64_t clang_ASTContext_getFieldOffset(CXASTContext Ctx, CXValueDecl FD) {
  return static_cast<clang::ASTContext *>(Ctx)->getFieldOffset(
      static_cast<clang::ValueDecl *>(FD));
}

// lookupFieldBitOffset

int64_t clang_ASTContext_getMemberPointerPathAdjustment(CXASTContext Ctx, CXAPValue MP) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getMemberPointerPathAdjustment(*static_cast<clang::APValue *>(MP))
      .getQuantity();
}

bool clang_ASTContext_isNearlyEmpty(CXASTContext Ctx, CXCXXRecordDecl RD) {
  return static_cast<clang::ASTContext *>(Ctx)->isNearlyEmpty(
      static_cast<clang::CXXRecordDecl *>(RD));
}

// getVTableContext

CXMangleContext clang_ASTContext_createMangleContext(CXASTContext Ctx, CXTargetInfo_ T) {
  return static_cast<clang::ASTContext *>(Ctx)->createMangleContext(
      static_cast<clang::TargetInfo *>(T));
}

CXMangleContext clang_ASTContext_createDeviceMangleContext(CXASTContext Ctx,
                                                           CXTargetInfo_ T) {
  return static_cast<clang::ASTContext *>(Ctx)->createDeviceMangleContext(
      *static_cast<clang::TargetInfo *>(T));
}

// DeepCollectObjCIvars
// CountNonClassIvars
// CollectInheritedProtocols

bool clang_ASTContext_hasUniqueObjectRepresentations(CXASTContext Ctx, CXQualType Ty) {
  return static_cast<clang::ASTContext *>(Ctx)->hasUniqueObjectRepresentations(
      clang::QualType::getFromOpaquePtr(Ty));
}


CXQualType clang_ASTContext_getCanonicalType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getCanonicalType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getCanonicalParamType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getCanonicalParamType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

bool clang_ASTContext_hasSameType(CXASTContext Ctx, CXQualType T1, CXQualType T2) {
  return static_cast<clang::ASTContext *>(Ctx)->hasSameType(
      clang::QualType::getFromOpaquePtr(T1), clang::QualType::getFromOpaquePtr(T2));
}

bool clang_ASTContext_hasSameExpr(CXASTContext Ctx, CXExpr X, CXExpr Y) {
  return static_cast<clang::ASTContext *>(Ctx)->hasSameExpr(static_cast<clang::Expr *>(X),
                                                            static_cast<clang::Expr *>(Y));
}

// getUnqualifiedArrayType

bool clang_ASTContext_hasSameUnqualifiedType(CXASTContext Ctx, CXQualType T1,
                                             CXQualType T2) {
  return static_cast<clang::ASTContext *>(Ctx)->hasSameUnqualifiedType(
      clang::QualType::getFromOpaquePtr(T1), clang::QualType::getFromOpaquePtr(T2));
}

bool clang_ASTContext_hasSameNullabilityTypeQualifier(CXASTContext Ctx, CXQualType SubT,
                                                      CXQualType SuperT, bool IsParam) {
  return static_cast<clang::ASTContext *>(Ctx)->hasSameNullabilityTypeQualifier(
      clang::QualType::getFromOpaquePtr(SubT), clang::QualType::getFromOpaquePtr(SuperT),
      IsParam);
}

// ObjCMethodsAreEqual
// UnwrapSimilarTypes
// UnwrapSimilarArrayTypes

bool clang_ASTContext_UnwrapSimilarTypes(CXASTContext Ctx, CXQualType *T1, CXQualType *T2,
                                         bool AllowPiMismatch) {
  clang::QualType QT1 = clang::QualType::getFromOpaquePtr(*T1);
  clang::QualType QT2 = clang::QualType::getFromOpaquePtr(*T2);
  bool Unwrapped =
      static_cast<clang::ASTContext *>(Ctx)->UnwrapSimilarTypes(QT1, QT2, AllowPiMismatch);
  *T1 = QT1.getAsOpaquePtr();
  *T2 = QT2.getAsOpaquePtr();
  return Unwrapped;
}

void clang_ASTContext_UnwrapSimilarArrayTypes(CXASTContext Ctx, CXQualType *T1,
                                              CXQualType *T2, bool AllowPiMismatch) {
  clang::QualType QT1 = clang::QualType::getFromOpaquePtr(*T1);
  clang::QualType QT2 = clang::QualType::getFromOpaquePtr(*T2);
  static_cast<clang::ASTContext *>(Ctx)->UnwrapSimilarArrayTypes(QT1, QT2, AllowPiMismatch);
  *T1 = QT1.getAsOpaquePtr();
  *T2 = QT2.getAsOpaquePtr();
}

bool clang_ASTContext_hasSimilarType(CXASTContext Ctx, CXQualType T1, CXQualType T2) {
  return static_cast<clang::ASTContext *>(Ctx)->hasSimilarType(
      clang::QualType::getFromOpaquePtr(T1), clang::QualType::getFromOpaquePtr(T2));
}

bool clang_ASTContext_hasCvrSimilarType(CXASTContext Ctx, CXQualType T1, CXQualType T2) {
  return static_cast<clang::ASTContext *>(Ctx)->hasCvrSimilarType(
      clang::QualType::getFromOpaquePtr(T1), clang::QualType::getFromOpaquePtr(T2));
}

CXNestedNameSpecifier
clang_ASTContext_getCanonicalNestedNameSpecifier(CXASTContext Ctx,
                                                 CXNestedNameSpecifier NNS) {
  return static_cast<clang::ASTContext *>(Ctx)->getCanonicalNestedNameSpecifier(
      static_cast<clang::NestedNameSpecifier *>(NNS));
}


CXCallingConv_ clang_ASTContext_getDefaultCallingConvention(CXASTContext Ctx,
                                                            bool IsVariadic,
                                                            bool IsCXXMethod,
                                                            bool IsBuiltin) {
  return static_cast<CXCallingConv_>(
      static_cast<clang::ASTContext *>(Ctx)->getDefaultCallingConvention(
          IsVariadic, IsCXXMethod, IsBuiltin));
}

CXTemplateName clang_ASTContext_getCanonicalTemplateName(CXASTContext Ctx,
                                                         CXTemplateName TemplateName) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getCanonicalTemplateName(clang::TemplateName::getFromVoidPointer(TemplateName))
      .getAsVoidPointer();
}

bool clang_ASTContext_hasSameTempalteName(CXASTContext Ctx, CXTemplateName T1,
                                          CXTemplateName T2) {
  return static_cast<clang::ASTContext *>(Ctx)->hasSameTemplateName(
      clang::TemplateName::getFromVoidPointer(T1),
      clang::TemplateName::getFromVoidPointer(T2));
}

bool clang_ASTContext_isSameEntity(CXASTContext Ctx, CXNamedDecl X, CXNamedDecl Y) {
  return static_cast<clang::ASTContext *>(Ctx)->isSameEntity(
      static_cast<clang::NamedDecl *>(X), static_cast<clang::NamedDecl *>(Y));
}

bool clang_ASTContext_isSameTemplateParameterList(CXASTContext Ctx,
                                                  CXTemplateParameterList X,
                                                  CXTemplateParameterList Y) {
  return static_cast<clang::ASTContext *>(Ctx)->isSameTemplateParameterList(
      static_cast<clang::TemplateParameterList *>(X),
      static_cast<clang::TemplateParameterList *>(Y));
}

bool clang_ASTContext_isSameTemplateParameter(CXASTContext Ctx, CXNamedDecl X,
                                              CXNamedDecl Y) {
  return static_cast<clang::ASTContext *>(Ctx)->isSameTemplateParameter(
      static_cast<clang::NamedDecl *>(X), static_cast<clang::NamedDecl *>(Y));
}

bool clang_ASTContext_isSameConstraintExpr(CXASTContext Ctx, CXExpr XCE, CXExpr YCE) {
  return static_cast<clang::ASTContext *>(Ctx)->isSameConstraintExpr(
      static_cast<clang::Expr *>(XCE), static_cast<clang::Expr *>(YCE));
}

bool clang_ASTContext_isSameDefaultTemplateArgument(CXASTContext Ctx, CXNamedDecl X,
                                                    CXNamedDecl Y) {
  return static_cast<clang::ASTContext *>(Ctx)->isSameDefaultTemplateArgument(
      static_cast<clang::NamedDecl *>(X), static_cast<clang::NamedDecl *>(Y));
}


CXTemplateArgument clang_ASTContext_getCanonicalTemplateArgument(CXASTContext Ctx,
                                                                 CXTemplateArgument Arg) {
  std::unique_ptr<clang::TemplateArgument> ptr = std::make_unique<clang::TemplateArgument>(
      static_cast<clang::ASTContext *>(Ctx)->getCanonicalTemplateArgument(
          *static_cast<clang::TemplateArgument *>(Arg)));
  return ptr.release();
}

CXArrayType clang_ASTContext_getAsArrayType(CXASTContext Ctx, CXQualType T) {
  return const_cast<clang::ArrayType *>(
      static_cast<clang::ASTContext *>(Ctx)->getAsArrayType(
          clang::QualType::getFromOpaquePtr(T)));
}

CXConstantArrayType clang_ASTContext_getAsConstantArrayType(CXASTContext Ctx,
                                                            CXQualType T) {
  return const_cast<clang::ConstantArrayType *>(
      static_cast<clang::ASTContext *>(Ctx)->getAsConstantArrayType(
          clang::QualType::getFromOpaquePtr(T)));
}

CXVariableArrayType clang_ASTContext_getAsVariableArrayType(CXASTContext Ctx,
                                                            CXQualType T) {
  return const_cast<clang::VariableArrayType *>(
      static_cast<clang::ASTContext *>(Ctx)->getAsVariableArrayType(
          clang::QualType::getFromOpaquePtr(T)));
}

CXIncompleteArrayType clang_ASTContext_getAsIncompleteArrayType(CXASTContext Ctx,
                                                                CXQualType T) {
  return const_cast<clang::IncompleteArrayType *>(
      static_cast<clang::ASTContext *>(Ctx)->getAsIncompleteArrayType(
          clang::QualType::getFromOpaquePtr(T)));
}

CXDependentSizedArrayType clang_ASTContext_getAsDependentSizedArrayType(CXASTContext Ctx,
                                                                        CXQualType T) {
  return const_cast<clang::DependentSizedArrayType *>(
      static_cast<clang::ASTContext *>(Ctx)->getAsDependentSizedArrayType(
          clang::QualType::getFromOpaquePtr(T)));
}

// CXQualType clang_ASTContext_getBaseElementType(CXASTContext Ctx, CXArrayType VAT) {
//   return static_cast<clang::ASTContext *>(Ctx)
//       ->getBaseElementType(static_cast<clang::ArrayType *>(VAT))
//       .getAsOpaquePtr();
// }

CXQualType clang_ASTContext_getBaseElementType(CXASTContext Ctx, CXQualType QT) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getBaseElementType(clang::QualType::getFromOpaquePtr(QT))
      .getAsOpaquePtr();
}

uint64_t clang_ASTContext_getConstantArrayElementCount(CXASTContext Ctx,
                                                       CXConstantArrayType CAT) {
  return static_cast<clang::ASTContext *>(Ctx)->getConstantArrayElementCount(
      static_cast<clang::ConstantArrayType *>(CAT));
}

uint64_t clang_ASTContext_getArrayInitLoopExprElementCount(CXASTContext Ctx,
                                                           CXArrayInitLoopExpr AILE) {
  return static_cast<clang::ASTContext *>(Ctx)->getArrayInitLoopExprElementCount(
      static_cast<clang::ArrayInitLoopExpr *>(AILE));
}

CXQualType clang_ASTContext_getAdjustedParameterType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getAdjustedParameterType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getSignatureParameterType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getSignatureParameterType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getExceptionObjectType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getExceptionObjectType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getArrayDecayedType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getArrayDecayedType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getPromotedIntegerType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getPromotedIntegerType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}


CXQualifiers_ObjCLifetime clang_ASTContext_getInnerObjCOwnership(CXASTContext Ctx,
                                                                 CXQualType T) {
  return static_cast<CXQualifiers_ObjCLifetime>(
      static_cast<clang::ASTContext *>(Ctx)->getInnerObjCOwnership(
          clang::QualType::getFromOpaquePtr(T)));
}

CXQualType clang_ASTContext_isPromotableBitField(CXASTContext Ctx, CXExpr E) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->isPromotableBitField(static_cast<clang::Expr *>(E))
      .getAsOpaquePtr();
}

int clang_ASTContext_getIntegerTypeOrder(CXASTContext Ctx, CXQualType LHS, CXQualType RHS) {
  return static_cast<clang::ASTContext *>(Ctx)->getIntegerTypeOrder(
      clang::QualType::getFromOpaquePtr(LHS), clang::QualType::getFromOpaquePtr(RHS));
}

int clang_ASTContext_getFloatingTypeOrder(CXASTContext Ctx, CXQualType LHS,
                                          CXQualType RHS) {
  return static_cast<clang::ASTContext *>(Ctx)->getFloatingTypeOrder(
      clang::QualType::getFromOpaquePtr(LHS), clang::QualType::getFromOpaquePtr(RHS));
}

int clang_ASTContext_getFloatingTypeSemanticOrder(CXASTContext Ctx, CXQualType LHS,
                                                  CXQualType RHS) {
  return static_cast<clang::ASTContext *>(Ctx)->getFloatingTypeSemanticOrder(
      clang::QualType::getFromOpaquePtr(LHS), clang::QualType::getFromOpaquePtr(RHS));
}

// CXQualType clang_ASTContext_getFloatingTypeOfSizeWithinDomain(CXASTContext Ctx,
//                                                               CXQualType typeSize,
//                                                               CXQualType typeDomain) {
//   return static_cast<clang::ASTContext *>(Ctx)
//       ->getFloatingTypeOfSizeWithinDomain(clang::QualType::getFromOpaquePtr(typeSize),
//                                           clang::QualType::getFromOpaquePtr(typeDomain))
//       .getAsOpaquePtr();
// }

// unsigned clang_ASTContext_getTargetAddressSpace(CXASTContext Ctx, CXQualType T) {
//   return static_cast<clang::ASTContext *>(Ctx)->getTargetAddressSpace(
//       clang::QualType::getFromOpaquePtr(T));
// }

unsigned clang_ASTContext_getTargetAddressSpace(CXASTContext Ctx, CXLangAS AS) {
  return static_cast<clang::ASTContext *>(Ctx)->getTargetAddressSpace(
      static_cast<clang::LangAS>(AS));
}


CXLangAS clang_ASTContext_getLangASForBuiltinAddressSpace(CXASTContext Ctx, unsigned AS) {
  return static_cast<CXLangAS>(
      static_cast<clang::ASTContext *>(Ctx)->getLangASForBuiltinAddressSpace(AS));
}

uint64_t clang_ASTContext_getTargetNullPointerValue(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)->getTargetNullPointerValue(
      clang::QualType::getFromOpaquePtr(T));
}

// clang_ASTContext_addressSpaceMapManglingFor

bool clang_ASTContext_addressSpaceMapManglingFor(CXASTContext Ctx, CXLangAS AS) {
  return static_cast<clang::ASTContext *>(Ctx)->addressSpaceMapManglingFor(
      static_cast<clang::LangAS>(AS));
}

// mergeExceptionSpecs

CXQualType clang_ASTContext_getCommonSugaredType(CXASTContext Ctx, CXQualType X,
                                                 CXQualType Y, bool Unqualified) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getCommonSugaredType(clang::QualType::getFromOpaquePtr(X),
                             clang::QualType::getFromOpaquePtr(Y), Unqualified)
      .getAsOpaquePtr();
}

bool clang_ASTContext_typesAreCompatible(CXASTContext Ctx, CXQualType T1, CXQualType T2,
                                         bool CompareUnqualified) {
  return static_cast<clang::ASTContext *>(Ctx)->typesAreCompatible(
      clang::QualType::getFromOpaquePtr(T1), clang::QualType::getFromOpaquePtr(T2),
      CompareUnqualified);
}

bool clang_ASTContext_propertyTypesAreCompatible(CXASTContext Ctx, CXQualType T1,
                                                 CXQualType T2) {
  return static_cast<clang::ASTContext *>(Ctx)->propertyTypesAreCompatible(
      clang::QualType::getFromOpaquePtr(T1), clang::QualType::getFromOpaquePtr(T2));
}

bool clang_ASTContext_typesAreBlockPointerCompatible(CXASTContext Ctx, CXQualType T1,
                                                     CXQualType T2) {
  return static_cast<clang::ASTContext *>(Ctx)->typesAreBlockPointerCompatible(
      clang::QualType::getFromOpaquePtr(T1), clang::QualType::getFromOpaquePtr(T2));
}

// isObjCIdType
// isObjCClassType
// isObjCSelType

bool clang_ASTContext_isObjCIdType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)->isObjCIdType(
      clang::QualType::getFromOpaquePtr(T));
}

bool clang_ASTContext_isObjCClassType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)->isObjCClassType(
      clang::QualType::getFromOpaquePtr(T));
}

bool clang_ASTContext_isObjCSelType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)->isObjCSelType(
      clang::QualType::getFromOpaquePtr(T));
}

bool clang_ASTContext_areComparableObjCPointerTypes(CXASTContext Ctx, CXQualType LHS,
                                                    CXQualType RHS) {
  return static_cast<clang::ASTContext *>(Ctx)->areComparableObjCPointerTypes(
      clang::QualType::getFromOpaquePtr(LHS), clang::QualType::getFromOpaquePtr(RHS));
}
// ObjCQualifiedIdTypesAreCompatible
// ObjCQualifiedClassTypesAreCompatible
// canAssignObjCInterfaces
// canAssignObjCInterfacesInBlockPointer
// areComparableObjCPointerTypes
// canBindObjCObjectType

CXQualType clang_ASTContext_mergeTypes(CXASTContext Ctx, CXQualType T1, CXQualType T2,
                                       bool OfBlockPointer, bool Unqualified,
                                       bool BlockReturnType) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->mergeTypes(clang::QualType::getFromOpaquePtr(T1),
                   clang::QualType::getFromOpaquePtr(T2), OfBlockPointer, Unqualified,
                   BlockReturnType)
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_mergeFunctionTypes(CXASTContext Ctx, CXQualType T1,
                                               CXQualType T2, bool OfBlockPointer,
                                               bool Unqualified, bool AllowCXX) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->mergeFunctionTypes(clang::QualType::getFromOpaquePtr(T1),
                           clang::QualType::getFromOpaquePtr(T2), OfBlockPointer,
                           Unqualified, AllowCXX)
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_mergeFunctionParameterTypes(CXASTContext Ctx, CXQualType T1,
                                                        CXQualType T2, bool OfBlockPointer,
                                                        bool Unqualified) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->mergeFunctionParameterTypes(clang::QualType::getFromOpaquePtr(T1),
                                    clang::QualType::getFromOpaquePtr(T2), OfBlockPointer,
                                    Unqualified)
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_mergeTransparentUnionType(CXASTContext Ctx, CXQualType T1,
                                                      CXQualType T2, bool OfBlockPointer,
                                                      bool Unqualified) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->mergeTransparentUnionType(clang::QualType::getFromOpaquePtr(T1),
                                  clang::QualType::getFromOpaquePtr(T2), OfBlockPointer,
                                  Unqualified)
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_mergeObjCGCQualifiers(CXASTContext Ctx, CXQualType T1,
                                                  CXQualType T2) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->mergeObjCGCQualifiers(clang::QualType::getFromOpaquePtr(T1),
                              clang::QualType::getFromOpaquePtr(T2))
      .getAsOpaquePtr();
}

// mergeExtParameterInfo
// ResetObjCLayout

unsigned clang_ASTContext_getIntWidth(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)->getIntWidth(
      clang::QualType::getFromOpaquePtr(T));
}

CXQualType clang_ASTContext_getCorrespondingUnsignedType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getCorrespondingUnsignedType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getCorrespondingSignedType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getCorrespondingSignedType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getCorrespondingSaturatedType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getCorrespondingSaturatedType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getCorrespondingSignedFixedPointType(CXASTContext Ctx,
                                                                 CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getCorrespondingSignedFixedPointType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

CXIdentifierTable clang_ASTContext_getIdents(CXASTContext Ctx) {
  return &static_cast<clang::ASTContext *>(Ctx)->Idents;
}


LLVMGenericValueRef clang_ASTContext_MakeIntValue(CXASTContext Ctx, uint64_t Value,
                                                  CXQualType Type) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = static_cast<clang::ASTContext *>(Ctx)->MakeIntValue(
      Value, clang::QualType::getFromOpaquePtr(Type));
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

bool clang_ASTContext_isSentinelNullExpr(CXASTContext Ctx, CXExpr E) {
  return static_cast<clang::ASTContext *>(Ctx)->isSentinelNullExpr(
      static_cast<clang::Expr *>(E));
}

bool clang_ASTContext_AnyObjCImplementation(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->AnyObjCImplementation();
}

// getObjCImplementation
// AnyObjCImplementation
// setObjCImplementation
// getObjCMethodRedeclaration
// setObjCMethodRedeclaration
// getObjContainingInterface
// setBlockVarCopyInit

CXTypeSourceInfo clang_ASTContext_CreateTypeSourceInfo(CXASTContext Ctx, CXQualType T,
                                                       unsigned Size) {
  return static_cast<clang::ASTContext *>(Ctx)->CreateTypeSourceInfo(
      clang::QualType::getFromOpaquePtr(T), Size);
}

CXTypeSourceInfo clang_ASTContext_getTrivialTypeSourceInfo(CXASTContext Ctx, CXQualType T,
                                                           CXSourceLocation_ Loc) {
  return static_cast<clang::ASTContext *>(Ctx)->getTrivialTypeSourceInfo(
      clang::QualType::getFromOpaquePtr(T), clang::SourceLocation::getFromPtrEncoding(Loc));
}

CXGVALinkage clang_ASTContext_GetGVALinkageForFunction(CXASTContext Ctx,
                                                       CXFunctionDecl FD) {
  return static_cast<CXGVALinkage>(
      static_cast<clang::ASTContext *>(Ctx)->GetGVALinkageForFunction(
          static_cast<clang::FunctionDecl *>(FD)));
}

CXGVALinkage clang_ASTContext_GetGVALinkageForVariable(CXASTContext Ctx, CXVarDecl VD) {
  return static_cast<CXGVALinkage>(
      static_cast<clang::ASTContext *>(Ctx)->GetGVALinkageForVariable(
          static_cast<clang::VarDecl *>(VD)));
}

bool clang_ASTContext_DeclMustBeEmitted(CXASTContext Ctx, CXDecl D) {
  return static_cast<clang::ASTContext *>(Ctx)->DeclMustBeEmitted(
      static_cast<clang::Decl *>(D));
}

CXCXXConstructorDecl
clang_ASTContext_getCopyConstructorForExceptionObject(CXASTContext Ctx,
                                                      CXCXXRecordDecl RD) {
  return const_cast<clang::CXXConstructorDecl *>(
      static_cast<clang::ASTContext *>(Ctx)->getCopyConstructorForExceptionObject(
          static_cast<clang::CXXRecordDecl *>(RD)));
}

void clang_ASTContext_addCopyConstructorForExceptionObject(CXASTContext Ctx,
                                                           CXCXXRecordDecl RD,
                                                           CXCXXConstructorDecl CD) {
  static_cast<clang::ASTContext *>(Ctx)->addCopyConstructorForExceptionObject(
      static_cast<clang::CXXRecordDecl *>(RD),
      static_cast<clang::CXXConstructorDecl *>(CD));
}

void clang_ASTContext_addTypedefNameForUnnamedTagDecl(CXASTContext Ctx, CXTagDecl TD,
                                                      CXTypedefNameDecl TND) {
  static_cast<clang::ASTContext *>(Ctx)->addTypedefNameForUnnamedTagDecl(
      static_cast<clang::TagDecl *>(TD), static_cast<clang::TypedefNameDecl *>(TND));
}

CXTypedefNameDecl clang_ASTContext_getTypedefNameForUnnamedTagDecl(CXASTContext Ctx,
                                                                   CXTagDecl TD) {
  return static_cast<clang::ASTContext *>(Ctx)->getTypedefNameForUnnamedTagDecl(
      static_cast<clang::TagDecl *>(TD));
}

void clang_ASTContext_addDeclaratorForUnnamedTagDecl(CXASTContext Ctx, CXTagDecl TD,
                                                     CXDeclaratorDecl D) {
  static_cast<clang::ASTContext *>(Ctx)->addDeclaratorForUnnamedTagDecl(
      static_cast<clang::TagDecl *>(TD), static_cast<clang::DeclaratorDecl *>(D));
}

CXDeclaratorDecl clang_ASTContext_getDeclaratorForUnnamedTagDecl(CXASTContext Ctx,
                                                                 CXTagDecl TD) {
  return static_cast<clang::ASTContext *>(Ctx)->getDeclaratorForUnnamedTagDecl(
      static_cast<clang::TagDecl *>(TD));
}

void clang_ASTContext_setManglingNumber(CXASTContext Ctx, CXNamedDecl ND, unsigned Number) {
  static_cast<clang::ASTContext *>(Ctx)->setManglingNumber(
      static_cast<clang::NamedDecl *>(ND), Number);
}

unsigned clang_ASTContext_getManglingNumber(CXASTContext Ctx, CXNamedDecl ND) {
  return static_cast<clang::ASTContext *>(Ctx)->getManglingNumber(
      static_cast<clang::NamedDecl *>(ND));
}

void clang_ASTContext_setStaticLocalNumber(CXASTContext Ctx, CXVarDecl ND,
                                           unsigned Number) {
  static_cast<clang::ASTContext *>(Ctx)->setStaticLocalNumber(
      static_cast<clang::VarDecl *>(ND), Number);
}

unsigned clang_ASTContext_getStaticLocalNumber(CXASTContext Ctx, CXVarDecl ND) {
  return static_cast<clang::ASTContext *>(Ctx)->getStaticLocalNumber(
      static_cast<clang::VarDecl *>(ND));
}

// getManglingNumberContext
// createManglingNumberingContext

void clang_ASTContext_setParameterIndex(CXASTContext Ctx, CXParmVarDecl D, unsigned index) {
  static_cast<clang::ASTContext *>(Ctx)->setParameterIndex(
      static_cast<clang::ParmVarDecl *>(D), index);
}

unsigned clang_ASTContext_getParameterIndex(CXASTContext Ctx, CXParmVarDecl D) {
  return static_cast<clang::ASTContext *>(Ctx)->getParameterIndex(
      static_cast<clang::ParmVarDecl *>(D));
}

CXStringLiteral clang_ASTContext_getPredefinedStringLiteralFromCache(CXASTContext Ctx,
                                                                     const char *Key) {
  return static_cast<clang::ASTContext *>(Ctx)->getPredefinedStringLiteralFromCache(
      llvm::StringRef(Key));
}

// getMSGuidDecl
// getTemplateParamObjectDecl

CXMSGuidDecl clang_ASTContext_getMSGuidDecl(CXASTContext Ctx, uint32_t Part1,
                                            uint16_t Part2, uint16_t Part3,
                                            const uint8_t *Part4And5) {
  clang::MSGuidDeclParts Parts;
  Parts.Part1 = Part1;
  Parts.Part2 = Part2;
  Parts.Part3 = Part3;
  for (unsigned I = 0; I < 8; ++I)
    Parts.Part4And5[I] = Part4And5[I];
  return static_cast<clang::ASTContext *>(Ctx)->getMSGuidDecl(Parts);
}

CXUnnamedGlobalConstantDecl clang_ASTContext_getUnnamedGlobalConstantDecl(CXASTContext Ctx,
                                                                          CXQualType Ty,
                                                                          CXAPValue Value) {
  return static_cast<clang::ASTContext *>(Ctx)->getUnnamedGlobalConstantDecl(
      clang::QualType::getFromOpaquePtr(Ty), *static_cast<clang::APValue *>(Value));
}

CXTemplateParamObjectDecl
clang_ASTContext_getTemplateParamObjectDecl(CXASTContext Ctx, CXQualType T, CXAPValue V) {
  return static_cast<clang::ASTContext *>(Ctx)->getTemplateParamObjectDecl(
      clang::QualType::getFromOpaquePtr(T), *static_cast<clang::APValue *>(V));
}
// filterFunctionTargetAttrs
// getFunctionFeatureMap

unsigned clang_ASTContext_getNumFunctionFeatures(CXASTContext Ctx, CXFunctionDecl FD) {
  llvm::StringMap<bool> FeatureMap;
  static_cast<clang::ASTContext *>(Ctx)->getFunctionFeatureMap(
      FeatureMap, static_cast<clang::FunctionDecl *>(FD));
  return static_cast<unsigned>(FeatureMap.size());
}

CXString clang_ASTContext_getFunctionFeature(CXASTContext Ctx, CXFunctionDecl FD,
                                             unsigned I, bool *IsEnabled) {
  llvm::StringMap<bool> FeatureMap;
  static_cast<clang::ASTContext *>(Ctx)->getFunctionFeatureMap(
      FeatureMap, static_cast<clang::FunctionDecl *>(FD));
  unsigned J = 0;
  for (const auto &Entry : FeatureMap) {
    if (J++ != I)
      continue;
    *IsEnabled = Entry.getValue();
    return extra::makeCXString(Entry.getKey().str());
  }
  *IsEnabled = false;
  return extra::makeCXString(std::string());
}

void clang_ASTContext_InitBuiltinTypes(CXASTContext Ctx, CXTargetInfo_ Target,
                                       CXTargetInfo_ AuxTarget) {
  static_cast<clang::ASTContext *>(Ctx)->InitBuiltinTypes(
      *static_cast<clang::TargetInfo *>(Target),
      static_cast<clang::TargetInfo *>(AuxTarget));
}

// getObjCEncodingForMethodParameter

bool clang_ASTContext_isMSStaticDataMemberInlineDefinition(CXASTContext Ctx, CXVarDecl VD) {
  return static_cast<clang::ASTContext *>(Ctx)->isMSStaticDataMemberInlineDefinition(
      static_cast<clang::VarDecl *>(VD));
}


CXInlineVariableDefinitionKind
clang_ASTContext_getInlineVariableDefinitionKind(CXASTContext Ctx, CXVarDecl VD) {
  return static_cast<CXInlineVariableDefinitionKind>(
      static_cast<clang::ASTContext *>(Ctx)->getInlineVariableDefinitionKind(
          static_cast<clang::VarDecl *>(VD)));
}

// bool clang_ASTContext_mayExternalizeStaticVar(CXASTContext Ctx, CXDecl D) {
//   return static_cast<clang::ASTContext *>(Ctx)->mayExternalizeStaticVar(
//       static_cast<clang::Decl *>(D));
// }

// bool clang_ASTContext_shouldExternalizeStaticVar(CXASTContext Ctx, CXDecl D) {
//   return static_cast<clang::ASTContext *>(Ctx)->shouldExternalizeStaticVar(
//       static_cast<clang::Decl *>(D));
// }

bool clang_ASTContext_mayExternalize(CXASTContext Ctx, CXDecl D) {
  return static_cast<clang::ASTContext *>(Ctx)->mayExternalize(
      static_cast<clang::Decl *>(D));
}

bool clang_ASTContext_shouldExternalize(CXASTContext Ctx, CXDecl D) {
  return static_cast<clang::ASTContext *>(Ctx)->shouldExternalize(
      static_cast<clang::Decl *>(D));
}

CXString clang_ASTContext_getCUIDHash(CXASTContext Ctx) {
  return extra::makeCXString(static_cast<clang::ASTContext *>(Ctx)->getCUIDHash().str());
}

// Builtin Types
CXQualType clang_ASTContext_VoidTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->VoidTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_BoolTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->BoolTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_CharTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->CharTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_WCharTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->WCharTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_WideCharTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->WideCharTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_WIntTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->WIntTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_Char8Ty_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->Char8Ty.getAsOpaquePtr();
}

CXQualType clang_ASTContext_Char16Ty_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->Char16Ty.getAsOpaquePtr();
}

CXQualType clang_ASTContext_Char32Ty_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->Char32Ty.getAsOpaquePtr();
}

CXQualType clang_ASTContext_SignedCharTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->SignedCharTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_ShortTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->ShortTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_IntTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->IntTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_LongTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->LongTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_LongLongTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->LongLongTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_Int128Ty_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->Int128Ty.getAsOpaquePtr();
}

CXQualType clang_ASTContext_UnsignedCharTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->UnsignedCharTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_UnsignedShortTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->UnsignedShortTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_UnsignedIntTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->UnsignedIntTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_UnsignedLongTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->UnsignedLongTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_UnsignedLongLongTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->UnsignedLongLongTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_UnsignedInt128Ty_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->UnsignedInt128Ty.getAsOpaquePtr();
}

CXQualType clang_ASTContext_FloatTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->FloatTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_DoubleTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->DoubleTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_LongDoubleTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->LongDoubleTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_Float128Ty_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->Float128Ty.getAsOpaquePtr();
}

CXQualType clang_ASTContext_HalfTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->HalfTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_BFloat16Ty_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->BFloat16Ty.getAsOpaquePtr();
}

CXQualType clang_ASTContext_Float16Ty_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->Float16Ty.getAsOpaquePtr();
}

CXQualType clang_ASTContext_VoidPtrTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->VoidPtrTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_NullPtrTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->NullPtrTy.getAsOpaquePtr();
}

CXTranslationUnitKind clang_ASTContext_getTranslationUnitKind(CXASTContext Ctx) {
  return static_cast<CXTranslationUnitKind>(static_cast<clang::ASTContext *>(Ctx)->TUKind);
}

void clang_ASTContext_addTranslationUnitDecl(CXASTContext Ctx) {
  static_cast<clang::ASTContext *>(Ctx)->addTranslationUnitDecl();
}

CXRawComment clang_ASTContext_getRawCommentForDeclNoCache(CXASTContext Ctx, CXDecl D) {
  return static_cast<clang::ASTContext *>(Ctx)->getRawCommentForDeclNoCache(
      static_cast<clang::Decl *>(D));
}

CXBlockVarCopyInit clang_ASTContext_getBlockVarCopyInit(CXASTContext Ctx, CXVarDecl VD) {
  return std::make_unique<clang::BlockVarCopyInit>(
             static_cast<clang::ASTContext *>(Ctx)->getBlockVarCopyInit(
                 static_cast<clang::VarDecl *>(VD)))
      .release();
}
