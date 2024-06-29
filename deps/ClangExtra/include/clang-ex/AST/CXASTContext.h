#ifndef LIBCLANGEX_CXASTCONTEXT_H
#define LIBCLANGEX_CXASTCONTEXT_H

#include "clang-ex/AST/CXType.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/Platform.h"

#ifdef __cplusplus
extern "C" {
#endif

// ASTContext

// getInterpContext
// getParentMapContext
// getTraversalScope
// setTraversalScope
// getParents
// getPrintingPolicy
// setPrintingPolicy

CINDEX_LINKAGE CXSourceManager clang_ASTContext_getSourceManager(CXASTContext Ctx);

// getAllocator
// Allocate
// Deallocate

CINDEX_LINKAGE size_t clang_ASTContext_getASTAllocatedMemory(CXASTContext Ctx);

CINDEX_LINKAGE size_t clang_ASTContext_getSideTableAllocatedMemory(CXASTContext Ctx);

// getDiagAllocator

CINDEX_LINKAGE CXTargetInfo_ clang_ASTContext_getTargetInfo(CXASTContext Ctx);

CINDEX_LINKAGE CXTargetInfo_ clang_ASTContext_getAuxTargetInfo(CXASTContext Ctx);

CINDEX_LINKAGE CXQualType clang_ASTContext_getIntTypeForBitwidth(CXASTContext Ctx,
                                                                 unsigned DestWidth,
                                                                 unsigned Signed);

#if LLVM_VERSION_MAJOR >= 14
CINDEX_LINKAGE CXQualType clang_ASTContext_getRealTypeForBitwidth(CXASTContext Ctx,
                                                   unsigned DestWidth,
                                                   clang::FloatModeKind ExplicitType);
#else
CINDEX_LINKAGE CXQualType clang_ASTContext_getRealTypeForBitwidth(CXASTContext Ctx,
                                                                  unsigned DestWidth,
                                                                  bool ExplicitIEEE);
#endif

CINDEX_LINKAGE bool clang_ASTContext_AtomicUsesUnsupportedLibcall(CXASTContext Ctx,
                                                                  CXAtomicExpr E);

CINDEX_LINKAGE CXLangOptions clang_ASTContext_getLangOpts(CXASTContext Ctx);

CINDEX_LINKAGE bool clang_ASTContext_isDependceAllowed(CXASTContext Ctx);

// getSanitizerBlacklist
// getXRayFilter
// getProfileList

CINDEX_LINKAGE CXDiagnosticsEngine clang_ASTContext_getDiagnostics(CXASTContext Ctx);

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

CINDEX_LINKAGE void clang_ASTContext_eraseDeclAttrs(CXASTContext Ctx, CXDecl D);

// getTemplateOrSpecializationInfo
// setInstantiatedFromStaticDataMember
// setTemplateOrSpecializationInfo

CINDEX_LINKAGE CXNamedDecl clang_ASTContext_getInstantiatedFromUsingDecl(CXASTContext Ctx,
                                                                         CXNamedDecl Inst);

CINDEX_LINKAGE void clang_ASTContext_setInstantiatedFromUsingDecl(CXASTContext Ctx,
                                                                  CXNamedDecl Inst,
                                                                  CXNamedDecl Pattern);

CINDEX_LINKAGE void clang_ASTContext_setInstantiatedFromUsingShadowDecl(
    CXASTContext Ctx, CXUsingShadowDecl Inst, CXUsingShadowDecl Pattern);

CINDEX_LINKAGE CXUsingShadowDecl clang_ASTContext_getInstantiatedFromUsingShadowDecl(
    CXASTContext Ctx, CXUsingShadowDecl Inst);

CINDEX_LINKAGE CXFieldDecl
clang_ASTContext_getInstantiatedFromUnnamedFieldDecl(CXASTContext Ctx, CXFieldDecl Field);

CINDEX_LINKAGE void clang_ASTContext_setInstantiatedFromUnnamedFieldDecl(CXASTContext Ctx,
                                                                         CXFieldDecl Inst,
                                                                         CXFieldDecl Tmpl);

CINDEX_LINKAGE void clang_ASTContext_addOverriddenMethod(CXASTContext Ctx,
                                                         CXCXXMethodDecl Method,
                                                         CXCXXMethodDecl Overridden);

// getOverriddenMethods

CINDEX_LINKAGE void clang_ASTContext_addedLocalImportDecl(CXASTContext Ctx,
                                                          CXImportDecl Import);

// getNextLocalImport

CINDEX_LINKAGE CXDecl clang_ASTContext_getPrimaryMergedDecl(CXASTContext Ctx, CXDecl D);

CINDEX_LINKAGE void clang_ASTContext_setPrimaryMergedDecl(CXASTContext Ctx, CXDecl D,
                                                          CXDecl Primary);

CINDEX_LINKAGE void clang_ASTContext_mergeDefinitionIntoModule(CXASTContext Ctx,
                                                               CXNamedDecl ND,
                                                               CXModule Module,
                                                               bool NotifyListeners);

CINDEX_LINKAGE void clang_ASTContext_deduplicateMergedDefinitonsFor(CXASTContext Ctx,
                                                                    CXNamedDecl ND);

// getModuleInitializers

CINDEX_LINKAGE CXTranslationUnitDecl
clang_ASTContext_getTranslationUnitDecl(CXASTContext Ctx);

CINDEX_LINKAGE CXExternCContextDecl
clang_ASTContext_getExternCContextDecl(CXASTContext Ctx);

CINDEX_LINKAGE CXBuiltinTemplateDecl
clang_ASTContext_getMakeIntegerSeqDecl(CXASTContext Ctx);

CINDEX_LINKAGE CXBuiltinTemplateDecl
clang_ASTContext_getTypePackElementDecl(CXASTContext Ctx);

// setExternalSource
// getExternalSource
// setASTMutationListener
// getASTMutationListener

CINDEX_LINKAGE void clang_ASTContext_PrintStats(CXASTContext Ctx);

// getTypes
// buildBuiltinTemplateDecl

CINDEX_LINKAGE CXRecordDecl clang_ASTContext_buildImplicitRecord(CXASTContext Ctx,
                                                                 const char *Name,
                                                                 CXTagTypeKind TK);

CINDEX_LINKAGE CXTypedefDecl clang_ASTContext_buildImplicitTypedef(CXASTContext Ctx,
                                                                   CXQualType T,
                                                                   const char *Name);

CINDEX_LINKAGE CXTypedefDecl clang_ASTContext_getInt128Decl(CXASTContext Ctx);

CINDEX_LINKAGE CXTypedefDecl clang_ASTContext_getUInt128Decl(CXASTContext Ctx);

// getAddrSpaceQualType

CINDEX_LINKAGE CXQualType clang_ASTContext_removeAddrSpaceQualType(CXASTContext Ctx,
                                                                   CXQualType T);

// applyObjCProtocolQualifiers
// getObjCGCQualType

CINDEX_LINKAGE CXQualType clang_ASTContext_removePtrSizeAddrSpace(CXASTContext Ctx,
                                                                  CXQualType T);

CINDEX_LINKAGE CXQualType clang_ASTContext_getRestrictType(CXASTContext Ctx, CXQualType T);

CINDEX_LINKAGE CXQualType clang_ASTContext_getVolatileType(CXASTContext Ctx, CXQualType T);

CINDEX_LINKAGE CXQualType clang_ASTContext_getConstType(CXASTContext Ctx, CXQualType T);

// adjustFunctionType
// getCanonicalFunctionResultType

CINDEX_LINKAGE void clang_ASTContext_adjustDeducedFunctionResultType(CXASTContext Ctx,
                                                                     CXFunctionDecl FD,
                                                                     CXQualType ResultType);

// getFunctionTypeWithExceptionSpec

CINDEX_LINKAGE bool
clang_ASTContext_hasSameFunctionTypeIgnoringExceptionSpec(CXASTContext Ctx, CXQualType T,
                                                          CXQualType U);

// adjustExceptionSpec

CINDEX_LINKAGE CXQualType clang_ASTContext_getFunctionTypeWithoutPtrSizes(CXASTContext Ctx,
                                                                          CXQualType T);

CINDEX_LINKAGE bool clang_ASTContext_hasSameFunctionTypeIgnoringPtrSizes(CXASTContext Ctx,
                                                                         CXQualType T,
                                                                         CXQualType U);

CINDEX_LINKAGE CXQualType clang_ASTContext_getComplexType(CXASTContext Ctx, CXQualType T);

CINDEX_LINKAGE CXQualType clang_ASTContext_getPointerType(CXASTContext Ctx, CXQualType T);

CINDEX_LINKAGE CXQualType clang_ASTContext_getAdjustedType(CXASTContext Ctx,
                                                           CXQualType Orig, CXQualType New);

CINDEX_LINKAGE CXQualType clang_ASTContext_getDecayedType(CXASTContext Ctx, CXQualType T);

CINDEX_LINKAGE CXQualType clang_ASTContext_getAtomicType(CXASTContext Ctx, CXQualType T);

CINDEX_LINKAGE CXQualType clang_ASTContext_getBlockPointerType(CXASTContext Ctx,
                                                               CXQualType T);

CINDEX_LINKAGE CXQualType clang_ASTContext_getBlockDescriptorType(CXASTContext Ctx);

CINDEX_LINKAGE CXQualType clang_ASTContext_getReadPipeType(CXASTContext Ctx, CXQualType T);

CINDEX_LINKAGE CXQualType clang_ASTContext_getWritePipeType(CXASTContext Ctx, CXQualType T);

// LLVM < 14
#if LLVM_VERSION_MAJOR >= 14
CINDEX_LINKAGE CXQualType clang_ASTContext_getBitIntType(CXASTContext Ctx, bool Unsigned,
                                                         unsigned NumBits);

CINDEX_LINKAGE CXQualType clang_ASTContext_getDependentBitIntType(CXASTContext Ctx,
                                                                  bool Unsigned,
                                                                  CXExpr BitsExpr);
#else
CINDEX_LINKAGE CXQualType clang_ASTContext_getExtIntType(CXASTContext Ctx, bool Unsigned,
                                                         unsigned NumBits);

CINDEX_LINKAGE CXQualType clang_ASTContext_getDependentExtIntType(CXASTContext Ctx,
                                                                  bool Unsigned,
                                                                  CXExpr BitsExpr);
#endif

CINDEX_LINKAGE CXQualType clang_ASTContext_getBlockDescriptorExtendedType(CXASTContext Ctx);

// getOpenCLTypeKind
// getOpenCLTypeAddrSpace

CINDEX_LINKAGE void clang_ASTContext_setcudaConfigureCallDecl(CXASTContext Ctx,
                                                              CXFunctionDecl FD);

CINDEX_LINKAGE CXFunctionDecl clang_ASTContext_getcudaConfigureCallDecl(CXASTContext Ctx);

CINDEX_LINKAGE bool clang_ASTContext_BlockRequiresCopying(CXASTContext Ctx, CXQualType T,
                                                          CXVarDecl D);

// getByrefLifeTime

CINDEX_LINKAGE CXQualType clang_ASTContext_getLValueReferenceType(CXASTContext Ctx,
                                                                  CXQualType T,
                                                                  bool SpelledAsLValue);

CINDEX_LINKAGE CXQualType clang_ASTContext_getRValueReferenceType(CXASTContext Ctx,
                                                                  CXQualType T);

CINDEX_LINKAGE CXQualType clang_ASTContext_getMemberPointerType(CXASTContext Ctx,
                                                                CXQualType T, CXType_ Cls);

// getVariableArrayType
// getDependentSizedArrayType
// getIncompleteArrayType
// getConstantArrayType
// getStringLiteralArrayType

CINDEX_LINKAGE CXQualType clang_ASTContext_getStringLiteralArrayType(CXASTContext Ctx,
                                                                     CXQualType EltTy,
                                                                     unsigned Length);

CINDEX_LINKAGE CXQualType clang_ASTContext_getVariableArrayDecayedType(CXASTContext Ctx,
                                                                       CXQualType T);

// getBuiltinVectorTypeInfo

CINDEX_LINKAGE CXQualType clang_ASTContext_getScalableVectorType(CXASTContext Ctx,
                                                                 CXQualType EltTy,
                                                                 unsigned NumElts);

// getVectorType
// getDependentVectorType

CINDEX_LINKAGE CXQualType clang_ASTContext_getExtVectorType(CXASTContext Ctx,
                                                            CXQualType VectorType,
                                                            unsigned NumElts);

CINDEX_LINKAGE CXQualType clang_ASTContext_getDependentSizedExtVectorType(
    CXASTContext Ctx, CXQualType VectorType, CXExpr SizeExpr, CXSourceLocation_ AttrLoc);

CINDEX_LINKAGE CXQualType clang_ASTContext_getConstantMatrixType(CXASTContext Ctx,
                                                                 CXQualType ElementType,
                                                                 unsigned NumRows,
                                                                 unsigned NumCols);

CINDEX_LINKAGE CXQualType clang_ASTContext_getDependentSizedMatrixType(
    CXASTContext Ctx, CXQualType ElementType, CXExpr RowsExpr, CXExpr ColsExpr,
    CXSourceLocation_ AttrLoc);

CINDEX_LINKAGE CXQualType clang_ASTContext_getDependentAddressSpaceType(
    CXASTContext Ctx, CXQualType PointeeType, CXExpr AddrSpaceExpr,
    CXSourceLocation_ AddrSpace);

CINDEX_LINKAGE CXQualType clang_ASTContext_getFunctionNoProtoType(CXASTContext Ctx,
                                                                  CXQualType ResultTy);

// getFunctionType

CINDEX_LINKAGE CXQualType clang_ASTContext_adjustStringLiteralBaseType(CXASTContext Ctx,
                                                                       CXQualType StrLTy);

CINDEX_LINKAGE CXQualType clang_ASTContext_getTypeDeclType(CXASTContext Ctx,
                                                           CXTypeDecl Decl,
                                                           CXTypeDecl PrevDecl);

CINDEX_LINKAGE CXQualType clang_ASTContext_getTypedefType(CXASTContext Ctx,
                                                          CXTypedefNameDecl Decl,
                                                          CXQualType Underlying);

CINDEX_LINKAGE CXQualType clang_ASTContext_getRecordType(CXASTContext Ctx, CXRecordDecl Decl);

CINDEX_LINKAGE CXQualType clang_ASTContext_getEnumType(CXASTContext Ctx, CXEnumDecl Decl);

CINDEX_LINKAGE CXQualType clang_ASTContext_getInjectedClassNameType(CXASTContext Ctx,
                                                                    CXCXXRecordDecl Decl,
                                                                    CXQualType TST);

// getAttributedType

CINDEX_LINKAGE CXQualType clang_ASTContext_getSubstTemplateTypeParmType(
    CXASTContext Ctx, CXTemplateTypeParmType Replaced, CXQualType Replacement);

// getSubstTemplateTypeParmPackType

CINDEX_LINKAGE CXQualType clang_ASTContext_getTemplateTypeParmType(
    CXASTContext Ctx, unsigned Depth, unsigned Index, bool ParameterPack,
    CXTemplateTypeParmType ParmDecl);

// getTemplateSpecializationType
// getCanonicalTemplateSpecializationType
// getTemplateSpecializationType
// getTemplateSpecializationTypeInfo

CINDEX_LINKAGE CXQualType clang_ASTContext_getParenType(CXASTContext Ctx,
                                                        CXQualType NamedType);

CINDEX_LINKAGE CXQualType clang_ASTContext_getMacroQualifiedType(CXASTContext Ctx,
                                                                 CXQualType UnderlyingTy,
                                                                 CXIdentifierInfo MacroII);

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

CINDEX_LINKAGE CXQualType clang_ASTContext_getTypeOfExprType(CXASTContext Ctx, CXExpr Expr);

CINDEX_LINKAGE CXQualType clang_ASTContext_getTypeOfType(CXASTContext Ctx, CXType_ T);

CINDEX_LINKAGE CXQualType clang_ASTContext_getDecltypeType(CXASTContext Ctx, CXExpr Expr,
                                                           CXQualType UnderlyingType);

// getUnaryTransformType
// getAutoType

CINDEX_LINKAGE CXQualType clang_ASTContext_getAutoDeductType(CXASTContext Ctx);

CINDEX_LINKAGE CXQualType clang_ASTContext_getAutoRRefDeductType(CXASTContext Ctx);

CINDEX_LINKAGE CXQualType clang_ASTContext_getDeducedTemplateSpecializationType(
    CXASTContext Ctx, CXTemplateName Template, CXQualType DeducedType, bool IsDependent);

CINDEX_LINKAGE CXQualType clang_ASTContext_getTagDeclType(CXASTContext Ctx, CXTagDecl Decl);

// getSizeType
// getSignedSizeType
// getIntMaxType
// getUIntMaxType

CINDEX_LINKAGE CXQualType clang_ASTContext_getWCharType(CXASTContext Ctx);

CINDEX_LINKAGE CXQualType clang_ASTContext_getWideCharType(CXASTContext Ctx);

CINDEX_LINKAGE CXQualType clang_ASTContext_getSignedWCharType(CXASTContext Ctx);

CINDEX_LINKAGE CXQualType clang_ASTContext_getUnsignedWCharType(CXASTContext Ctx);

CINDEX_LINKAGE CXQualType clang_ASTContext_getWIntType(CXASTContext Ctx);

CINDEX_LINKAGE CXQualType clang_ASTContext_getIntPtrType(CXASTContext Ctx);

CINDEX_LINKAGE CXQualType clang_ASTContext_getUIntPtrType(CXASTContext Ctx);

CINDEX_LINKAGE CXQualType clang_ASTContext_getPointerDiffType(CXASTContext Ctx);

CINDEX_LINKAGE CXQualType clang_ASTContext_getUnsignedPointerDiffType(CXASTContext Ctx);

CINDEX_LINKAGE CXQualType clang_ASTContext_getProcessIDType(CXASTContext Ctx);

CINDEX_LINKAGE CXQualType clang_ASTContext_getCFConstantStringType(CXASTContext Ctx);

CINDEX_LINKAGE CXQualType clang_ASTContext_getObjCSuperType(CXASTContext Ctx);

CINDEX_LINKAGE CXQualType clang_ASTContext_getRawCFConstantStringType(CXASTContext Ctx);

CINDEX_LINKAGE void clang_ASTContext_setCFConstantStringType(CXASTContext Ctx,
                                                             CXQualType T);

CINDEX_LINKAGE CXTypedefDecl clang_ASTContext_getCFContantStringDecl(CXASTContext Ctx);

CINDEX_LINKAGE CXRecordDecl clang_ASTContext_getCFConstantStringTagDecl(CXASTContext Ctx);

// getObjCConstantStringInterface
// getObjCNSStringType
// setObjCNSStringType

CINDEX_LINKAGE CXQualType clang_ASTContext_getObjCIdRedefinitionType(CXASTContext Ctx);

CINDEX_LINKAGE void clang_ASTContext_setObjCIdRedefinitionType(CXASTContext Ctx,
                                                               CXQualType T);

CINDEX_LINKAGE CXQualType clang_ASTContext_getObjCClassRedefinitionType(CXASTContext Ctx);

CINDEX_LINKAGE void clang_ASTContext_setObjCClassRedefinitionType(CXASTContext Ctx,
                                                                  CXQualType T);

CINDEX_LINKAGE CXIdentifierInfo clang_ASTContext_getNSCopyingName(CXASTContext Ctx);

// getNSUIntegerType
// getNSIntegerType

CINDEX_LINKAGE CXIdentifierInfo clang_ASTContext_getBoolName(CXASTContext Ctx);

CINDEX_LINKAGE CXIdentifierInfo clang_ASTContext_getMakeIntegerSeqName(CXASTContext Ctx);

CINDEX_LINKAGE CXIdentifierInfo clang_ASTContext_getTypePackElementName(CXASTContext Ctx);

CINDEX_LINKAGE CXQualType clang_ASTContext_getObjCInstanceType(CXASTContext Ctx);

CINDEX_LINKAGE CXTypedefDecl clang_ASTContext_getObjCInstanceTypeDecl(CXASTContext Ctx);

CINDEX_LINKAGE void clang_ASTContext_setFILEDecl(CXASTContext Ctx, CXTypeDecl FILEDecl);

CINDEX_LINKAGE CXQualType clang_ASTContext_getFILEType(CXASTContext Ctx);

CINDEX_LINKAGE CXQualType clang_ASTContext_getLogicalOperationType(CXASTContext Ctx);

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

CINDEX_LINKAGE CXTypedefDecl clang_ASTContext_getBOOLDecl(CXASTContext Ctx);

CINDEX_LINKAGE void clang_ASTContext_setBOOLDecl(CXASTContext Ctx, CXTypedefDecl TD);

CINDEX_LINKAGE CXQualType clang_ASTContext_getBOOLType(CXASTContext Ctx);

CINDEX_LINKAGE CXQualType clang_ASTContext_getObjCProtoType(CXASTContext Ctx);

CINDEX_LINKAGE CXTypedefDecl clang_ASTContext_getBuiltinVaListDecl(CXASTContext Ctx);

CINDEX_LINKAGE CXDecl clang_ASTContext_getVaListTagDecl(CXASTContext Ctx);

CINDEX_LINKAGE CXTypedefDecl clang_ASTContext_getBuiltinMSVaListDecl(CXASTContext Ctx);

CINDEX_LINKAGE CXQualType clang_ASTContext_getBuiltinMSVaListType(CXASTContext Ctx);

CINDEX_LINKAGE CXTagDecl clang_ASTContext_getMSGuidTagDecl(CXASTContext Ctx);

CINDEX_LINKAGE CXTagType clang_ASTContext_getMSGuidType(CXASTContext Ctx);

CINDEX_LINKAGE bool clang_ASTContext_canBuiltinBeRedeclared(CXASTContext Ctx,
                                                            CXFunctionDecl D);

CINDEX_LINKAGE CXQualType clang_ASTContext_getCVRQualifiedType(CXASTContext Ctx,
                                                               CXQualType T, unsigned CVR);

// getQualifiedType
// getLifetimeQualifiedType
// getUnqualifiedObjCPointerType

CINDEX_LINKAGE unsigned char clang_ASTContext_getFixedPointScale(CXASTContext Ctx,
                                                                 CXQualType Ty);

CINDEX_LINKAGE unsigned char clang_ASTContext_getFixedPointIBits(CXASTContext Ctx,
                                                                 CXQualType Ty);

// getFixedPointSemantics
// getFixedPointMax
// getFixedPointMin
// getNameForTemplate
// getOverloadedTemplateName

CINDEX_LINKAGE CXTemplateName
clang_ASTContext_getAssumedTemplateName(CXASTContext Ctx, CXDeclarationName Name);

CINDEX_LINKAGE CXTemplateName
clang_ASTContext_getQualifiedTemplateName(CXASTContext Ctx, CXNestedNameSpecifier NNS,
                                          bool TemplateKeyword, CXTemplateDecl Template);

CINDEX_LINKAGE CXTemplateName clang_ASTContext_getDependentTemplateName(
    CXASTContext Ctx, CXNestedNameSpecifier NNS, CXIdentifierInfo Name);

CINDEX_LINKAGE CXTemplateName clang_ASTContext_getSubstTemplateTemplateParm(
    CXASTContext Ctx, CXTemplateTemplateParmDecl param, CXTemplateName replacement);

// getSubstTemplateTemplateParmPack
// DecodeTypeStr
// GetBuiltinType
// getObjCGCAttrKind

CINDEX_LINKAGE bool clang_ASTContext_areCompatibleVectorTypes(CXASTContext Ctx,
                                                              CXQualType FirstVec,
                                                              CXQualType SecondVec);

CINDEX_LINKAGE bool clang_ASTContext_areCompatibleSveTypes(CXASTContext Ctx,
                                                           CXQualType FirstVec,
                                                           CXQualType SecondVec);

CINDEX_LINKAGE bool clang_ASTContext_areLaxCompatibleSveTypes(CXASTContext Ctx,
                                                              CXQualType FirstVec,
                                                              CXQualType SecondVec);

CINDEX_LINKAGE bool clang_ASTContext_hasDirectOwnershipQualifier(CXASTContext Ctx,
                                                                 CXQualType Ty);

// isObjCNSObjectType
// getFloatTypeSemantics
// getTypeInfo

CINDEX_LINKAGE unsigned clang_ASTContext_getOpenMPDefaultSimdAlign(CXASTContext Ctx,
                                                                   CXQualType T);

CINDEX_LINKAGE uint64_t clang_ASTContext_getTypeSize(CXASTContext Ctx, CXQualType T);

CINDEX_LINKAGE uint64_t clang_ASTContext_getCharWidth(CXASTContext Ctx);

// toCharUnitsFromBits
// toBits
// getTypeSizeInChars
// getTypeSizeInCharsIfKnown

CINDEX_LINKAGE unsigned clang_ASTContext_getTypeAlign(CXASTContext Ctx, CXQualType T);

CINDEX_LINKAGE unsigned clang_ASTContext_getTypeUnadjustedAlign(CXASTContext Ctx,
                                                                CXQualType T);

CINDEX_LINKAGE unsigned clang_ASTContext_getTypeAlignIfKnown(CXASTContext Ctx, CXQualType T,
                                                             bool NeedsPreferredAlignment);

// getTypeAlignInChars
// getPreferredTypeAlignInChars
// getTypeUnadjustedAlignInChars
// getTypeInfoDataSizeInChars
// getTypeInfoInChars

CINDEX_LINKAGE bool clang_ASTContext_isAlignmentRequired(CXASTContext Ctx, CXQualType T);

CINDEX_LINKAGE unsigned clang_ASTContext_getPreferredTypeAlign(CXASTContext Ctx,
                                                               CXQualType T);

CINDEX_LINKAGE unsigned
clang_ASTContext_getTargetDefaultAlignForAttributeAligned(CXASTContext Ctx);

CINDEX_LINKAGE unsigned clang_ASTContext_getAlignOfGlobalVar(CXASTContext Ctx,
                                                             CXQualType T);

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

CINDEX_LINKAGE uint64_t clang_ASTContext_getFieldOffset(CXASTContext Ctx, CXValueDecl FD);

// lookupFieldBitOffset
// getMemberPointerPathAdjustment

CINDEX_LINKAGE bool clang_ASTContext_isNearlyEmpty(CXASTContext Ctx, CXCXXRecordDecl RD);

// getVTableContext

CINDEX_LINKAGE CXMangleContext clang_ASTContext_createMangleContext(CXASTContext Ctx,
                                                                    CXTargetInfo_ T);

// DeepCollectObjCIvars
// CountNonClassIvars
// CollectInheritedProtocols

CINDEX_LINKAGE bool clang_ASTContext_hasUniqueObjectRepresentations(CXASTContext Ctx,
                                                                    CXQualType Ty);

// getCanonicalType
// getCanonicalParamType

CINDEX_LINKAGE bool clang_ASTContext_hasSameType(CXASTContext Ctx, CXQualType T1,
                                                 CXQualType T2);

// getUnqualifiedArrayType

CINDEX_LINKAGE bool clang_ASTContext_hasSameUnqualifiedType(CXASTContext Ctx, CXQualType T1,
                                                            CXQualType T2);

CINDEX_LINKAGE bool clang_ASTContext_hasSameNullabilityTypeQualifier(CXASTContext Ctx,
                                                                     CXQualType SubT,
                                                                     CXQualType SuperT,
                                                                     bool IsParam);

// ObjCMethodsAreEqual
// UnwrapSimilarTypes
// UnwrapSimilarArrayTypes

CINDEX_LINKAGE bool clang_ASTContext_hasSimilarType(CXASTContext Ctx, CXQualType T1,
                                                    CXQualType T2);

CINDEX_LINKAGE bool clang_ASTContext_hasCvrSimilarType(CXASTContext Ctx, CXQualType T1,
                                                       CXQualType T2);

CINDEX_LINKAGE CXNestedNameSpecifier clang_ASTContext_getCanonicalNestedNameSpecifier(
    CXASTContext Ctx, CXNestedNameSpecifier NNS);

// getDefaultCallingConvention

CINDEX_LINKAGE CXTemplateName
clang_ASTContext_getCanonicalTemplateName(CXASTContext Ctx, CXTemplateName TemplateName);

CINDEX_LINKAGE bool clang_ASTContext_hasSameTempalteName(CXASTContext Ctx,
                                                         CXTemplateName T1,
                                                         CXTemplateName T2);

// getCanonicalTemplateArgument

CINDEX_LINKAGE CXArrayType clang_ASTContext_getAsArrayType(CXASTContext Ctx, CXQualType T);

CINDEX_LINKAGE CXConstantArrayType clang_ASTContext_getAsConstantArrayType(CXASTContext Ctx,
                                                                           CXQualType T);

CINDEX_LINKAGE CXVariableArrayType clang_ASTContext_getAsVariableArrayType(CXASTContext Ctx,
                                                                           CXQualType T);

CINDEX_LINKAGE CXIncompleteArrayType
clang_ASTContext_getAsIncompleteArrayType(CXASTContext Ctx, CXQualType T);

CINDEX_LINKAGE CXDependentSizedArrayType
clang_ASTContext_getAsDependentSizedArrayType(CXASTContext Ctx, CXQualType T);

// CXQualType clang_ASTContext_getBaseElementType(CXASTContext Ctx, CXArrayType VAT);
//   return static_cast<clang::ASTContext *>(Ctx)
//       ->getBaseElementType(static_cast<clang::ArrayType *>(VAT))
//       .getAsOpaquePtr();
// }

CINDEX_LINKAGE CXQualType clang_ASTContext_getBaseElementType(CXASTContext Ctx,
                                                              CXQualType QT);

CINDEX_LINKAGE uint64_t
clang_ASTContext_getConstantArrayElementCount(CXASTContext Ctx, CXConstantArrayType CAT);

CINDEX_LINKAGE CXQualType clang_ASTContext_getAdjustedParameterType(CXASTContext Ctx,
                                                                    CXQualType T);

CINDEX_LINKAGE CXQualType clang_ASTContext_getSignatureParameterType(CXASTContext Ctx,
                                                                     CXQualType T);

CINDEX_LINKAGE CXQualType clang_ASTContext_getExceptionObjectType(CXASTContext Ctx,
                                                                  CXQualType T);

CINDEX_LINKAGE CXQualType clang_ASTContext_getArrayDecayedType(CXASTContext Ctx,
                                                               CXQualType T);

CINDEX_LINKAGE CXQualType clang_ASTContext_getPromotedIntegerType(CXASTContext Ctx,
                                                                  CXQualType T);

// getInnerObjCOwnership

CINDEX_LINKAGE CXQualType clang_ASTContext_isPromotableBitField(CXASTContext Ctx, CXExpr E);

CINDEX_LINKAGE int clang_ASTContext_getIntegerTypeOrder(CXASTContext Ctx, CXQualType LHS,
                                                        CXQualType RHS);

CINDEX_LINKAGE int clang_ASTContext_getFloatingTypeOrder(CXASTContext Ctx, CXQualType LHS,
                                                         CXQualType RHS);

CINDEX_LINKAGE int clang_ASTContext_getFloatingTypeSemanticOrder(CXASTContext Ctx,
                                                                 CXQualType LHS,
                                                                 CXQualType RHS);

CINDEX_LINKAGE CXQualType clang_ASTContext_getFloatingTypeOfSizeWithinDomain(
    CXASTContext Ctx, CXQualType typeSize, CXQualType typeDomain);

CINDEX_LINKAGE unsigned clang_ASTContext_getTargetAddressSpace(CXASTContext Ctx,
                                                               CXQualType T);

// getLangASForBuiltinAddressSpace

CINDEX_LINKAGE uint64_t clang_ASTContext_getTargetNullPointerValue(CXASTContext Ctx,
                                                                   CXQualType T);

// clang_ASTContext_addressSpaceMapManglingFor

CINDEX_LINKAGE bool clang_ASTContext_typesAreCompatible(CXASTContext Ctx, CXQualType T1,
                                                        CXQualType T2,
                                                        bool CompareUnqualified);

CINDEX_LINKAGE bool
clang_ASTContext_propertyTypesAreCompatible(CXASTContext Ctx, CXQualType T1, CXQualType T2);

CINDEX_LINKAGE bool clang_ASTContext_typesAreBlockPointerCompatible(CXASTContext Ctx,
                                                                    CXQualType T1,
                                                                    CXQualType T2);

// isObjCIdType
// isObjCClassType
// isObjCSelType
// ObjCQualifiedIdTypesAreCompatible
// ObjCQualifiedClassTypesAreCompatible
// canAssignObjCInterfaces
// canAssignObjCInterfacesInBlockPointer
// areComparableObjCPointerTypes
// canBindObjCObjectType

CINDEX_LINKAGE CXQualType clang_ASTContext_mergeTypes(CXASTContext Ctx, CXQualType T1,
                                                      CXQualType T2, bool OfBlockPointer,
                                                      bool Unqualified,
                                                      bool BlockReturnType);

CINDEX_LINKAGE CXQualType clang_ASTContext_mergeFunctionTypes(CXASTContext Ctx,
                                                              CXQualType T1, CXQualType T2,
                                                              bool OfBlockPointer,
                                                              bool Unqualified,
                                                              bool AllowCXX);

CINDEX_LINKAGE CXQualType clang_ASTContext_mergeFunctionParameterTypes(
    CXASTContext Ctx, CXQualType T1, CXQualType T2, bool OfBlockPointer, bool Unqualified);

CINDEX_LINKAGE CXQualType clang_ASTContext_mergeTransparentUnionType(
    CXASTContext Ctx, CXQualType T1, CXQualType T2, bool OfBlockPointer, bool Unqualified);

CINDEX_LINKAGE CXQualType clang_ASTContext_mergeObjCGCQualifiers(CXASTContext Ctx,
                                                                 CXQualType T1,
                                                                 CXQualType T2);

// mergeExtParameterInfo
// ResetObjCLayout

CINDEX_LINKAGE unsigned clang_ASTContext_getIntWidth(CXASTContext Ctx, CXQualType T);

CINDEX_LINKAGE CXQualType clang_ASTContext_getCorrespondingUnsignedType(CXASTContext Ctx,
                                                                        CXQualType T);

CINDEX_LINKAGE CXQualType clang_ASTContext_getCorrespondingSaturatedType(CXASTContext Ctx,
                                                                         CXQualType T);

CINDEX_LINKAGE CXQualType
clang_ASTContext_getCorrespondingSignedFixedPointType(CXASTContext Ctx, CXQualType T);

CINDEX_LINKAGE CXIdentifierTable clang_ASTContext_getIdents(CXASTContext Ctx);

// MakeIntValue

CINDEX_LINKAGE bool clang_ASTContext_isSentinelNullExpr(CXASTContext Ctx, CXExpr E);

// getObjCImplementation
// AnyObjCImplementation
// setObjCImplementation
// getObjCMethodRedeclaration
// setObjCMethodRedeclaration
// getObjContainingInterface
// setBlockVarCopyInit
// getBlockVarCopyInit

CINDEX_LINKAGE CXTypeSourceInfo clang_ASTContext_CreateTypeSourceInfo(CXASTContext Ctx,
                                                                      CXQualType T,
                                                                      unsigned Size);

CINDEX_LINKAGE CXTypeSourceInfo clang_ASTContext_getTrivialTypeSourceInfo(
    CXASTContext Ctx, CXQualType T, CXSourceLocation_ Loc);

CINDEX_LINKAGE CXCXXConstructorDecl
clang_ASTContext_getCopyConstructorForExceptionObject(CXASTContext Ctx, CXCXXRecordDecl RD);

CINDEX_LINKAGE void
clang_ASTContext_addCopyConstructorForExceptionObject(CXASTContext Ctx, CXCXXRecordDecl RD,
                                                      CXCXXConstructorDecl CD);

CINDEX_LINKAGE void clang_ASTContext_addTypedefNameForUnnamedTagDecl(CXASTContext Ctx,
                                                                     CXTagDecl TD,
                                                                     CXTypedefNameDecl TND);

CINDEX_LINKAGE CXTypedefNameDecl
clang_ASTContext_getTypedefNameForUnnamedTagDecl(CXASTContext Ctx, CXTagDecl TD);

CINDEX_LINKAGE void clang_ASTContext_addDeclaratorForUnnamedTagDecl(CXASTContext Ctx,
                                                                    CXTagDecl TD,
                                                                    CXDeclaratorDecl D);

CINDEX_LINKAGE CXDeclaratorDecl
clang_ASTContext_getDeclaratorForUnnamedTagDecl(CXASTContext Ctx, CXTagDecl TD);

CINDEX_LINKAGE void clang_ASTContext_setManglingNumber(CXASTContext Ctx, CXNamedDecl ND,
                                                       unsigned Number);

CINDEX_LINKAGE unsigned clang_ASTContext_getManglingNumber(CXASTContext Ctx,
                                                           CXNamedDecl ND);

CINDEX_LINKAGE void clang_ASTContext_setStaticLocalNumber(CXASTContext Ctx, CXVarDecl ND,
                                                          unsigned Number);

CINDEX_LINKAGE unsigned clang_ASTContext_getStaticLocalNumber(CXASTContext Ctx,
                                                              CXVarDecl ND);

// getManglingNumberContext
// createManglingNumberingContext

CINDEX_LINKAGE void clang_ASTContext_setParameterIndex(CXASTContext Ctx, CXParmVarDecl D,
                                                       unsigned index);

CINDEX_LINKAGE unsigned clang_ASTContext_getParameterIndex(CXASTContext Ctx,
                                                           CXParmVarDecl D);

CINDEX_LINKAGE CXStringLiteral
clang_ASTContext_getPredefinedStringLiteralFromCache(CXASTContext Ctx, const char *Key);

// getMSGuidDecl
// getTemplateParamObjectDecl
// filterFunctionTargetAttrs
// getFunctionFeatureMap

CINDEX_LINKAGE void clang_ASTContext_InitBuiltinTypes(CXASTContext Ctx,
                                                      CXTargetInfo_ Target,
                                                      CXTargetInfo_ AuxTarget);

// getObjCEncodingForMethodParameter

CINDEX_LINKAGE bool clang_ASTContext_isMSStaticDataMemberInlineDefinition(CXASTContext Ctx,
                                                                          CXVarDecl VD);

// getInlineVariableDefinitionKind

CINDEX_LINKAGE bool clang_ASTContext_mayExternalizeStaticVar(CXASTContext Ctx, CXDecl D);

CINDEX_LINKAGE bool clang_ASTContext_shouldExternalizeStaticVar(CXASTContext Ctx, CXDecl D);

// Builtin Types
CINDEX_LINKAGE CXQualType clang_ASTContext_VoidTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_BoolTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_CharTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_WCharTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_WideCharTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_WIntTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_Char8Ty_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_Char16Ty_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_Char32Ty_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_SignedCharTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_ShortTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_IntTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_LongTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_LongLongTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_Int128Ty_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_UnsignedCharTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_UnsignedShortTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_UnsignedIntTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_UnsignedLongTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType
clang_ASTContext_UnsignedLongLongTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_UnsignedInt128Ty_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_FloatTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_DoubleTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_LongDoubleTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_Float128Ty_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_HalfTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_BFloat16Ty_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_Float16Ty_getAsQualType(CXASTContext Ctx);
#if LLVM_VERSION_MAJOR >= 14
#else
CINDEX_LINKAGE CXQualType clang_ASTContext_FloatComplexTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_DoubleComplexTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType
clang_ASTContext_LongDoubleComplexTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType
clang_ASTContext_Float128ComplexTy_getAsQualType(CXASTContext Ctx);
#endif
CINDEX_LINKAGE CXQualType clang_ASTContext_VoidPtrTy_getAsQualType(CXASTContext Ctx);
CINDEX_LINKAGE CXQualType clang_ASTContext_NullPtrTy_getAsQualType(CXASTContext Ctx);

#ifdef __cplusplus
}
#endif
#endif