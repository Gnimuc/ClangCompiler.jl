#include "clang-ex/AST/CXASTContext.h"
#include "clang/AST/ASTContext.h"

// ASTContext

// getInterpContext
// getParentMapContext
// getTraversalScope
// setTraversalScope
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

#if LLVM_VERSION_MAJOR >= 14
CXQualType clang_ASTContext_getRealTypeForBitwidth(CXASTContext Ctx, unsigned DestWidth,
                                                   clang::FloatModeKind ExplicitType) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getRealTypeForBitwidth(DestWidth, ExplicitType)
      .getAsOpaquePtr();
}
#else
CXQualType clang_ASTContext_getRealTypeForBitwidth(CXASTContext Ctx, unsigned DestWidth,
                                                   bool ExplicitIEEE) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getRealTypeForBitwidth(DestWidth, ExplicitIEEE)
      .getAsOpaquePtr();
}
#endif

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
// cacheRawCommentForDecl
// getRawCommentForDeclNoCacheImpl
// getRawCommentForDeclNoCache
// addComment
// getRawCommentForAnyRedecl
// attachCommentsToJustParsedDecl
// getCommentForDecl
// getLocalCommentForDeclUncached
// cloneFullComment
// getCommentCommandTraits
// getDeclAttrs

void clang_ASTContext_eraseDeclAttrs(CXASTContext Ctx, CXDecl D) {
  static_cast<clang::ASTContext *>(Ctx)->eraseDeclAttrs(static_cast<clang::Decl *>(D));
}

// getTemplateOrSpecializationInfo
// setInstantiatedFromStaticDataMember
// setTemplateOrSpecializationInfo

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

void clang_ASTContext_addedLocalImportDecl(CXASTContext Ctx, CXImportDecl Import) {
  static_cast<clang::ASTContext *>(Ctx)->addedLocalImportDecl(
      static_cast<clang::ImportDecl *>(Import));
}

// getNextLocalImport

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

// getModuleInitializers

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
// buildBuiltinTemplateDecl

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

// getAddrSpaceQualType

CXQualType clang_ASTContext_removeAddrSpaceQualType(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->removeAddrSpaceQualType(clang::QualType::getFromOpaquePtr(T))
      .getAsOpaquePtr();
}

// applyObjCProtocolQualifiers
// getObjCGCQualType

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

// adjustFunctionType
// getCanonicalFunctionResultType

void clang_ASTContext_adjustDeducedFunctionResultType(CXASTContext Ctx, CXFunctionDecl FD,
                                                      CXQualType ResultType) {
  static_cast<clang::ASTContext *>(Ctx)->adjustDeducedFunctionResultType(
      static_cast<clang::FunctionDecl *>(FD),
      clang::QualType::getFromOpaquePtr(ResultType));
}

// getFunctionTypeWithExceptionSpec

bool clang_ASTContext_hasSameFunctionTypeIgnoringExceptionSpec(CXASTContext Ctx,
                                                               CXQualType T, CXQualType U) {
  return static_cast<clang::ASTContext *>(Ctx)->hasSameFunctionTypeIgnoringExceptionSpec(
      clang::QualType::getFromOpaquePtr(T), clang::QualType::getFromOpaquePtr(U));
}

// adjustExceptionSpec

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

#if LLVM_VERSION_MAJOR >= 14
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
#else
CXQualType clang_ASTContext_getExtIntType(CXASTContext Ctx, bool Unsigned,
                                          unsigned NumBits) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getExtIntType(Unsigned, NumBits)
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getDependentExtIntType(CXASTContext Ctx, bool Unsigned,
                                                   CXExpr BitsExpr) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getDependentExtIntType(Unsigned, static_cast<clang::Expr *>(BitsExpr))
      .getAsOpaquePtr();
}
#endif

CXQualType clang_ASTContext_getBlockDescriptorExtendedType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getBlockDescriptorExtendedType()
      .getAsOpaquePtr();
}

// getOpenCLTypeKind
// getOpenCLTypeAddrSpace

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
// getConstantArrayType
// getStringLiteralArrayType

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

// getVectorType
// getDependentVectorType

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

// getFunctionType

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

CXQualType clang_ASTContext_getInjectedClassNameType(CXASTContext Ctx, CXCXXRecordDecl Decl,
                                                     CXQualType TST) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getInjectedClassNameType(static_cast<clang::CXXRecordDecl *>(Decl),
                                 clang::QualType::getFromOpaquePtr(TST))
      .getAsOpaquePtr();
}

// getAttributedType

CXQualType clang_ASTContext_getSubstTemplateTypeParmType(CXASTContext Ctx,
                                                         CXTemplateTypeParmType Replaced,
                                                         CXQualType Replacement) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getSubstTemplateTypeParmType(static_cast<clang::TemplateTypeParmType *>(Replaced),
                                     clang::QualType::getFromOpaquePtr(Replacement))
      .getAsOpaquePtr();
}

// getSubstTemplateTypeParmPackType

CXQualType clang_ASTContext_getTemplateTypeParmType(CXASTContext Ctx, unsigned Depth,
                                                    unsigned Index, bool ParameterPack,
                                                    CXTemplateTypeParmType ParmDecl) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getTemplateTypeParmType(Depth, Index, ParameterPack,
                                static_cast<clang::TemplateTypeParmDecl *>(ParmDecl))
      .getAsOpaquePtr();
}

// getTemplateSpecializationType
// getCanonicalTemplateSpecializationType
// getTemplateSpecializationType
// getTemplateSpecializationTypeInfo

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

// getElaboratedType
// getDependentNameType
// getDependentTemplateSpecializationType
// getInjectedTempalteArgs
// getPackExpansionType
// getObjCInterfaceType
// gvetObjCObjectType
// getObjCTypeParamType
// adjustObjCTypeParamBoundType
// ObjCObjectAdoptsQTypeProtocols
// QIdProtocolsAdoptObjCObjectProtocols
// getObjCObjectPointerType

CXQualType clang_ASTContext_getTypeOfExprType(CXASTContext Ctx, CXExpr Expr) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getTypeOfExprType(static_cast<clang::Expr *>(Expr))
      .getAsOpaquePtr();
}

CXQualType clang_ASTContext_getTypeOfType(CXASTContext Ctx, CXType_ T) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getTypeOfType(clang::QualType::getFromOpaquePtr(T))
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

CXQualType clang_ASTContext_getAutoDeductType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getAutoDeductType().getAsOpaquePtr();
}

CXQualType clang_ASTContext_getAutoRRefDeductType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getAutoRRefDeductType().getAsOpaquePtr();
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
// getIntMaxType
// getUIntMaxType

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

CXIdentifierInfo clang_ASTContext_getNSCopyingName(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getNSCopyingName();
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

CXQualType clang_ASTContext_getLogicalOperationType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->getLogicalOperationType().getAsOpaquePtr();
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
// getLifetimeQualifiedType
// getUnqualifiedObjCPointerType

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
// getNameForTemplate
// getOverloadedTemplateName

CXTemplateName clang_ASTContext_getAssumedTemplateName(CXASTContext Ctx,
                                                       CXDeclarationName Name) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getAssumedTemplateName(clang::DeclarationName::getFromOpaquePtr(Name))
      .getAsVoidPointer();
}

CXTemplateName clang_ASTContext_getQualifiedTemplateName(CXASTContext Ctx,
                                                         CXNestedNameSpecifier NNS,
                                                         bool TemplateKeyword,
                                                         CXTemplateDecl Template) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getQualifiedTemplateName(static_cast<clang::NestedNameSpecifier *>(NNS),
                                 TemplateKeyword,
                                 static_cast<clang::TemplateDecl *>(Template))
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

CXTemplateName clang_ASTContext_getSubstTemplateTemplateParm(
    CXASTContext Ctx, CXTemplateTemplateParmDecl param, CXTemplateName replacement) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getSubstTemplateTemplateParm(static_cast<clang::TemplateTemplateParmDecl *>(param),
                                     clang::TemplateName::getFromVoidPointer(replacement))
      .getAsVoidPointer();
}

// getSubstTemplateTemplateParmPack
// DecodeTypeStr
// GetBuiltinType
// getObjCGCAttrKind

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

bool clang_ASTContext_hasDirectOwnershipQualifier(CXASTContext Ctx, CXQualType Ty) {
  return static_cast<clang::ASTContext *>(Ctx)->hasDirectOwnershipQualifier(
      clang::QualType::getFromOpaquePtr(Ty));
}

// isObjCNSObjectType
// getFloatTypeSemantics
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

// getAlignOfGlobalVarInChars
// getDeclAlign
// getExnObjectAlignment
// getASTRecordLayout
// getASTObjCInterfaceLayout
// DumpRecordLayout
// getASTObjCImplementationLayout
// getCurrentKeyFunction
// setNonKeyFunction
// getOffsetOfBaseWithVBPtr

uint64_t clang_ASTContext_getFieldOffset(CXASTContext Ctx, CXValueDecl FD) {
  return static_cast<clang::ASTContext *>(Ctx)->getFieldOffset(
      static_cast<clang::ValueDecl *>(FD));
}

// lookupFieldBitOffset
// getMemberPointerPathAdjustment

bool clang_ASTContext_isNearlyEmpty(CXASTContext Ctx, CXCXXRecordDecl RD) {
  return static_cast<clang::ASTContext *>(Ctx)->isNearlyEmpty(
      static_cast<clang::CXXRecordDecl *>(RD));
}

// getVTableContext

CXMangleContext clang_ASTContext_createMangleContext(CXASTContext Ctx, CXTargetInfo_ T) {
  return static_cast<clang::ASTContext *>(Ctx)->createMangleContext(
      static_cast<clang::TargetInfo *>(T));
}

// DeepCollectObjCIvars
// CountNonClassIvars
// CollectInheritedProtocols

bool clang_ASTContext_hasUniqueObjectRepresentations(CXASTContext Ctx, CXQualType Ty) {
  return static_cast<clang::ASTContext *>(Ctx)->hasUniqueObjectRepresentations(
      clang::QualType::getFromOpaquePtr(Ty));
}

// getCanonicalType
// getCanonicalParamType

bool clang_ASTContext_hasSameType(CXASTContext Ctx, CXQualType T1, CXQualType T2) {
  return static_cast<clang::ASTContext *>(Ctx)->hasSameType(
      clang::QualType::getFromOpaquePtr(T1), clang::QualType::getFromOpaquePtr(T2));
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

// getDefaultCallingConvention

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

// getCanonicalTemplateArgument

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

// getInnerObjCOwnership

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

CXQualType clang_ASTContext_getFloatingTypeOfSizeWithinDomain(CXASTContext Ctx,
                                                              CXQualType typeSize,
                                                              CXQualType typeDomain) {
  return static_cast<clang::ASTContext *>(Ctx)
      ->getFloatingTypeOfSizeWithinDomain(clang::QualType::getFromOpaquePtr(typeSize),
                                          clang::QualType::getFromOpaquePtr(typeDomain))
      .getAsOpaquePtr();
}

unsigned clang_ASTContext_getTargetAddressSpace(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)->getTargetAddressSpace(
      clang::QualType::getFromOpaquePtr(T));
}

// getLangASForBuiltinAddressSpace

uint64_t clang_ASTContext_getTargetNullPointerValue(CXASTContext Ctx, CXQualType T) {
  return static_cast<clang::ASTContext *>(Ctx)->getTargetNullPointerValue(
      clang::QualType::getFromOpaquePtr(T));
}

// clang_ASTContext_addressSpaceMapManglingFor

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

// MakeIntValue

bool clang_ASTContext_isSentinelNullExpr(CXASTContext Ctx, CXExpr E) {
  return static_cast<clang::ASTContext *>(Ctx)->isSentinelNullExpr(
      static_cast<clang::Expr *>(E));
}

// getObjCImplementation
// AnyObjCImplementation
// setObjCImplementation
// getObjCMethodRedeclaration
// setObjCMethodRedeclaration
// getObjContainingInterface
// setBlockVarCopyInit
// getBlockVarCopyInit

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
// filterFunctionTargetAttrs
// getFunctionFeatureMap

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

// getInlineVariableDefinitionKind

bool clang_ASTContext_mayExternalizeStaticVar(CXASTContext Ctx, CXDecl D) {
  return static_cast<clang::ASTContext *>(Ctx)->mayExternalizeStaticVar(
      static_cast<clang::Decl *>(D));
}

bool clang_ASTContext_shouldExternalizeStaticVar(CXASTContext Ctx, CXDecl D) {
  return static_cast<clang::ASTContext *>(Ctx)->shouldExternalizeStaticVar(
      static_cast<clang::Decl *>(D));
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

#if LLVM_VERSION_MAJOR >= 14
#else
CXQualType clang_ASTContext_FloatComplexTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->FloatComplexTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_DoubleComplexTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->DoubleComplexTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_LongDoubleComplexTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->LongDoubleComplexTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_Float128ComplexTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->Float128ComplexTy.getAsOpaquePtr();
}
#endif

CXQualType clang_ASTContext_VoidPtrTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->VoidPtrTy.getAsOpaquePtr();
}

CXQualType clang_ASTContext_NullPtrTy_getAsQualType(CXASTContext Ctx) {
  return static_cast<clang::ASTContext *>(Ctx)->NullPtrTy.getAsOpaquePtr();
}
