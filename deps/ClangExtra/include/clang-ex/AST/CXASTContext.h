#ifndef LLVM_CLANG_C_EXTRA_CXASTCONTEXT_H
#define LLVM_CLANG_C_EXTRA_CXASTCONTEXT_H

#include "clang-ex/AST/CXType.h"
#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// ASTContext

// getInterpContext
// getParentMapContext
// getTraversalScope
// setTraversalScope
// getParents
// getPrintingPolicy
// setPrintingPolicy

CXSourceManager clang_ASTContext_getSourceManager(CXASTContext Ctx);

// getAllocator
// Allocate
// Deallocate

size_t clang_ASTContext_getASTAllocatedMemory(CXASTContext Ctx);

size_t clang_ASTContext_getSideTableAllocatedMemory(CXASTContext Ctx);

// getDiagAllocator

CXTargetInfo_ clang_ASTContext_getTargetInfo(CXASTContext Ctx);

CXTargetInfo_ clang_ASTContext_getAuxTargetInfo(CXASTContext Ctx);

CXQualType clang_ASTContext_getIntTypeForBitwidth(CXASTContext Ctx, unsigned DestWidth,
                                                  unsigned Signed);

// CXQualType clang_ASTContext_getRealTypeForBitwidth(CXASTContext Ctx, unsigned DestWidth,
//                                                    clang::FloatModeKind ExplicitType);

bool clang_ASTContext_AtomicUsesUnsupportedLibcall(CXASTContext Ctx, CXAtomicExpr E);

CXLangOptions clang_ASTContext_getLangOpts(CXASTContext Ctx);

bool clang_ASTContext_isDependceAllowed(CXASTContext Ctx);

// getSanitizerBlacklist
// getXRayFilter
// getProfileList

CXDiagnosticsEngine clang_ASTContext_getDiagnostics(CXASTContext Ctx);

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

void clang_ASTContext_eraseDeclAttrs(CXASTContext Ctx, CXDecl D);

// getTemplateOrSpecializationInfo
// setInstantiatedFromStaticDataMember
// setTemplateOrSpecializationInfo

CXNamedDecl clang_ASTContext_getInstantiatedFromUsingDecl(CXASTContext Ctx,
                                                          CXNamedDecl Inst);

void clang_ASTContext_setInstantiatedFromUsingDecl(CXASTContext Ctx, CXNamedDecl Inst,
                                                   CXNamedDecl Pattern);

void clang_ASTContext_setInstantiatedFromUsingShadowDecl(CXASTContext Ctx,
                                                         CXUsingShadowDecl Inst,
                                                         CXUsingShadowDecl Pattern);

CXUsingShadowDecl
clang_ASTContext_getInstantiatedFromUsingShadowDecl(CXASTContext Ctx,
                                                    CXUsingShadowDecl Inst);

CXFieldDecl clang_ASTContext_getInstantiatedFromUnnamedFieldDecl(CXASTContext Ctx,
                                                                 CXFieldDecl Field);

void clang_ASTContext_setInstantiatedFromUnnamedFieldDecl(CXASTContext Ctx,
                                                          CXFieldDecl Inst,
                                                          CXFieldDecl Tmpl);

void clang_ASTContext_addOverriddenMethod(CXASTContext Ctx, CXCXXMethodDecl Method,
                                          CXCXXMethodDecl Overridden);

// getOverriddenMethods

void clang_ASTContext_addedLocalImportDecl(CXASTContext Ctx, CXImportDecl Import);

// getNextLocalImport

CXDecl clang_ASTContext_getPrimaryMergedDecl(CXASTContext Ctx, CXDecl D);

void clang_ASTContext_setPrimaryMergedDecl(CXASTContext Ctx, CXDecl D, CXDecl Primary);

void clang_ASTContext_mergeDefinitionIntoModule(CXASTContext Ctx, CXNamedDecl ND,
                                                CXModule Module, bool NotifyListeners);

void clang_ASTContext_deduplicateMergedDefinitonsFor(CXASTContext Ctx, CXNamedDecl ND);

// getModuleInitializers

CXTranslationUnitDecl clang_ASTContext_getTranslationUnitDecl(CXASTContext Ctx);

CXExternCContextDecl clang_ASTContext_getExternCContextDecl(CXASTContext Ctx);

CXBuiltinTemplateDecl clang_ASTContext_getMakeIntegerSeqDecl(CXASTContext Ctx);

CXBuiltinTemplateDecl clang_ASTContext_getTypePackElementDecl(CXASTContext Ctx);

// setExternalSource
// getExternalSource
// setASTMutationListener
// getASTMutationListener

void clang_ASTContext_PrintStats(CXASTContext Ctx);

// getTypes
// buildBuiltinTemplateDecl

CXRecordDecl clang_ASTContext_buildImplicitRecord(CXASTContext Ctx, const char *Name,
                                                  CXTagTypeKind TK);

CXTypedefDecl clang_ASTContext_buildImplicitTypedef(CXASTContext Ctx, CXQualType T,
                                                    const char *Name);

CXTypedefDecl clang_ASTContext_getInt128Decl(CXASTContext Ctx);

CXTypedefDecl clang_ASTContext_getUInt128Decl(CXASTContext Ctx);

// getAddrSpaceQualType

CXQualType clang_ASTContext_removeAddrSpaceQualType(CXASTContext Ctx, CXQualType T);

// applyObjCProtocolQualifiers
// getObjCGCQualType

CXQualType clang_ASTContext_removePtrSizeAddrSpace(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getRestrictType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getVolatileType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getConstType(CXASTContext Ctx, CXQualType T);

// adjustFunctionType
// getCanonicalFunctionResultType

void clang_ASTContext_adjustDeducedFunctionResultType(CXASTContext Ctx, CXFunctionDecl FD,
                                                      CXQualType ResultType);

// getFunctionTypeWithExceptionSpec

bool clang_ASTContext_hasSameFunctionTypeIgnoringExceptionSpec(CXASTContext Ctx,
                                                               CXQualType T, CXQualType U);

// adjustExceptionSpec

CXQualType clang_ASTContext_getFunctionTypeWithoutPtrSizes(CXASTContext Ctx, CXQualType T);

bool clang_ASTContext_hasSameFunctionTypeIgnoringPtrSizes(CXASTContext Ctx, CXQualType T,
                                                          CXQualType U);

CXQualType clang_ASTContext_getComplexType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getPointerType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getAdjustedType(CXASTContext Ctx, CXQualType Orig,
                                            CXQualType New);

CXQualType clang_ASTContext_getDecayedType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getAtomicType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getBlockPointerType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getBlockDescriptorType(CXASTContext Ctx);

CXQualType clang_ASTContext_getReadPipeType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getWritePipeType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getBitIntType(CXASTContext Ctx, bool Unsigned,
                                          unsigned NumBits);

CXQualType clang_ASTContext_getDependentBitIntType(CXASTContext Ctx, bool Unsigned,
                                                   CXExpr BitsExpr);

CXQualType clang_ASTContext_getBlockDescriptorExtendedType(CXASTContext Ctx);

// getOpenCLTypeKind
// getOpenCLTypeAddrSpace

void clang_ASTContext_setcudaConfigureCallDecl(CXASTContext Ctx, CXFunctionDecl FD);

CXFunctionDecl clang_ASTContext_getcudaConfigureCallDecl(CXASTContext Ctx);

bool clang_ASTContext_BlockRequiresCopying(CXASTContext Ctx, CXQualType T, CXVarDecl D);

// getByrefLifeTime

CXQualType clang_ASTContext_getLValueReferenceType(CXASTContext Ctx, CXQualType T,
                                                   bool SpelledAsLValue);

CXQualType clang_ASTContext_getRValueReferenceType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getMemberPointerType(CXASTContext Ctx, CXQualType T,
                                                 CXType_ Cls);

// getVariableArrayType
// getDependentSizedArrayType
// getIncompleteArrayType
// getConstantArrayType
// getStringLiteralArrayType

CXQualType clang_ASTContext_getStringLiteralArrayType(CXASTContext Ctx, CXQualType EltTy,
                                                      unsigned Length);

CXQualType clang_ASTContext_getVariableArrayDecayedType(CXASTContext Ctx, CXQualType T);

// getBuiltinVectorTypeInfo

CXQualType clang_ASTContext_getScalableVectorType(CXASTContext Ctx, CXQualType EltTy,
                                                  unsigned NumElts);

// getVectorType
// getDependentVectorType

CXQualType clang_ASTContext_getExtVectorType(CXASTContext Ctx, CXQualType VectorType,
                                             unsigned NumElts);

CXQualType clang_ASTContext_getDependentSizedExtVectorType(CXASTContext Ctx,
                                                           CXQualType VectorType,
                                                           CXExpr SizeExpr,
                                                           CXSourceLocation_ AttrLoc);

CXQualType clang_ASTContext_getConstantMatrixType(CXASTContext Ctx, CXQualType ElementType,
                                                  unsigned NumRows, unsigned NumCols);

CXQualType clang_ASTContext_getDependentSizedMatrixType(CXASTContext Ctx,
                                                        CXQualType ElementType,
                                                        CXExpr RowsExpr, CXExpr ColsExpr,
                                                        CXSourceLocation_ AttrLoc);

CXQualType clang_ASTContext_getDependentAddressSpaceType(CXASTContext Ctx,
                                                         CXQualType PointeeType,
                                                         CXExpr AddrSpaceExpr,
                                                         CXSourceLocation_ AddrSpace);

CXQualType clang_ASTContext_getFunctionNoProtoType(CXASTContext Ctx, CXQualType ResultTy);

// getFunctionType

CXQualType clang_ASTContext_adjustStringLiteralBaseType(CXASTContext Ctx,
                                                        CXQualType StrLTy);

CXQualType clang_ASTContext_getTypeDeclType(CXASTContext Ctx, CXTypeDecl Decl,
                                            CXTypeDecl PrevDecl);

CXQualType clang_ASTContext_getTypedefType(CXASTContext Ctx, CXTypedefNameDecl Decl,
                                           CXQualType Underlying);

CXQualType clang_ASTContext_getRecordType(CXASTContext Ctx, CXRecordDecl Decl);

CXQualType clang_ASTContext_getEnumType(CXASTContext Ctx, CXEnumDecl Decl);

CXQualType clang_ASTContext_getInjectedClassNameType(CXASTContext Ctx, CXCXXRecordDecl Decl,
                                                     CXQualType TST);

// getAttributedType

// CXQualType clang_ASTContext_getSubstTemplateTypeParmType(CXASTContext Ctx,
//                                                          CXTemplateTypeParmType Replaced,
//                                                          CXQualType Replacement);

// getSubstTemplateTypeParmPackType

CXQualType clang_ASTContext_getTemplateTypeParmType(CXASTContext Ctx, unsigned Depth,
                                                    unsigned Index, bool ParameterPack,
                                                    CXTemplateTypeParmType ParmDecl);

// getTemplateSpecializationType
// getCanonicalTemplateSpecializationType
// getTemplateSpecializationType
// getTemplateSpecializationTypeInfo

CXQualType clang_ASTContext_getParenType(CXASTContext Ctx, CXQualType NamedType);

CXQualType clang_ASTContext_getMacroQualifiedType(CXASTContext Ctx, CXQualType UnderlyingTy,
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

// CXQualType clang_ASTContext_getTypeOfExprType(CXASTContext Ctx, CXExpr Expr);

// CXQualType clang_ASTContext_getTypeOfType(CXASTContext Ctx, CXType_ T);

CXQualType clang_ASTContext_getDecltypeType(CXASTContext Ctx, CXExpr Expr,
                                            CXQualType UnderlyingType);

// getUnaryTransformType
// getAutoType

CXQualType clang_ASTContext_getAutoDeductType(CXASTContext Ctx);

CXQualType clang_ASTContext_getAutoRRefDeductType(CXASTContext Ctx);

CXQualType clang_ASTContext_getDeducedTemplateSpecializationType(CXASTContext Ctx,
                                                                 CXTemplateName Template,
                                                                 CXQualType DeducedType,
                                                                 bool IsDependent);

CXQualType clang_ASTContext_getTagDeclType(CXASTContext Ctx, CXTagDecl Decl);

// getSizeType
// getSignedSizeType
// getIntMaxType
// getUIntMaxType

CXQualType clang_ASTContext_getWCharType(CXASTContext Ctx);

CXQualType clang_ASTContext_getWideCharType(CXASTContext Ctx);

CXQualType clang_ASTContext_getSignedWCharType(CXASTContext Ctx);

CXQualType clang_ASTContext_getUnsignedWCharType(CXASTContext Ctx);

CXQualType clang_ASTContext_getWIntType(CXASTContext Ctx);

CXQualType clang_ASTContext_getIntPtrType(CXASTContext Ctx);

CXQualType clang_ASTContext_getUIntPtrType(CXASTContext Ctx);

CXQualType clang_ASTContext_getPointerDiffType(CXASTContext Ctx);

CXQualType clang_ASTContext_getUnsignedPointerDiffType(CXASTContext Ctx);

CXQualType clang_ASTContext_getProcessIDType(CXASTContext Ctx);

CXQualType clang_ASTContext_getCFConstantStringType(CXASTContext Ctx);

CXQualType clang_ASTContext_getObjCSuperType(CXASTContext Ctx);

CXQualType clang_ASTContext_getRawCFConstantStringType(CXASTContext Ctx);

void clang_ASTContext_setCFConstantStringType(CXASTContext Ctx, CXQualType T);

CXTypedefDecl clang_ASTContext_getCFContantStringDecl(CXASTContext Ctx);

CXRecordDecl clang_ASTContext_getCFConstantStringTagDecl(CXASTContext Ctx);

// getObjCConstantStringInterface
// getObjCNSStringType
// setObjCNSStringType

CXQualType clang_ASTContext_getObjCIdRedefinitionType(CXASTContext Ctx);

void clang_ASTContext_setObjCIdRedefinitionType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getObjCClassRedefinitionType(CXASTContext Ctx);

void clang_ASTContext_setObjCClassRedefinitionType(CXASTContext Ctx, CXQualType T);

CXIdentifierInfo clang_ASTContext_getNSCopyingName(CXASTContext Ctx);

// getNSUIntegerType
// getNSIntegerType

CXIdentifierInfo clang_ASTContext_getBoolName(CXASTContext Ctx);

CXIdentifierInfo clang_ASTContext_getMakeIntegerSeqName(CXASTContext Ctx);

CXIdentifierInfo clang_ASTContext_getTypePackElementName(CXASTContext Ctx);

CXQualType clang_ASTContext_getObjCInstanceType(CXASTContext Ctx);

CXTypedefDecl clang_ASTContext_getObjCInstanceTypeDecl(CXASTContext Ctx);

void clang_ASTContext_setFILEDecl(CXASTContext Ctx, CXTypeDecl FILEDecl);

CXQualType clang_ASTContext_getFILEType(CXASTContext Ctx);

CXQualType clang_ASTContext_getLogicalOperationType(CXASTContext Ctx);

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

CXTypedefDecl clang_ASTContext_getBOOLDecl(CXASTContext Ctx);

void clang_ASTContext_setBOOLDecl(CXASTContext Ctx, CXTypedefDecl TD);

CXQualType clang_ASTContext_getBOOLType(CXASTContext Ctx);

CXQualType clang_ASTContext_getObjCProtoType(CXASTContext Ctx);

CXTypedefDecl clang_ASTContext_getBuiltinVaListDecl(CXASTContext Ctx);

CXDecl clang_ASTContext_getVaListTagDecl(CXASTContext Ctx);

CXTypedefDecl clang_ASTContext_getBuiltinMSVaListDecl(CXASTContext Ctx);

CXQualType clang_ASTContext_getBuiltinMSVaListType(CXASTContext Ctx);

CXTagDecl clang_ASTContext_getMSGuidTagDecl(CXASTContext Ctx);

CXTagType clang_ASTContext_getMSGuidType(CXASTContext Ctx);

bool clang_ASTContext_canBuiltinBeRedeclared(CXASTContext Ctx, CXFunctionDecl D);

CXQualType clang_ASTContext_getCVRQualifiedType(CXASTContext Ctx, CXQualType T,
                                                unsigned CVR);

// getQualifiedType
// getLifetimeQualifiedType
// getUnqualifiedObjCPointerType

unsigned char clang_ASTContext_getFixedPointScale(CXASTContext Ctx, CXQualType Ty);

unsigned char clang_ASTContext_getFixedPointIBits(CXASTContext Ctx, CXQualType Ty);

// getFixedPointSemantics
// getFixedPointMax
// getFixedPointMin
// getNameForTemplate
// getOverloadedTemplateName

CXTemplateName clang_ASTContext_getAssumedTemplateName(CXASTContext Ctx,
                                                       CXDeclarationName Name);

// CXTemplateName clang_ASTContext_getQualifiedTemplateName(CXASTContext Ctx,
//                                                          CXNestedNameSpecifier NNS,
//                                                          bool TemplateKeyword,
//                                                          CXTemplateDecl Template);

CXTemplateName clang_ASTContext_getDependentTemplateName(CXASTContext Ctx,
                                                         CXNestedNameSpecifier NNS,
                                                         CXIdentifierInfo Name);

// CXTemplateName clang_ASTContext_getSubstTemplateTemplateParm(
//     CXASTContext Ctx, CXTemplateTemplateParmDecl param, CXTemplateName replacement);

// getSubstTemplateTemplateParmPack
// DecodeTypeStr
// GetBuiltinType
// getObjCGCAttrKind

bool clang_ASTContext_areCompatibleVectorTypes(CXASTContext Ctx, CXQualType FirstVec,
                                               CXQualType SecondVec);

bool clang_ASTContext_areCompatibleSveTypes(CXASTContext Ctx, CXQualType FirstVec,
                                            CXQualType SecondVec);

bool clang_ASTContext_areLaxCompatibleSveTypes(CXASTContext Ctx, CXQualType FirstVec,
                                               CXQualType SecondVec);

bool clang_ASTContext_hasDirectOwnershipQualifier(CXASTContext Ctx, CXQualType Ty);

// isObjCNSObjectType
// getFloatTypeSemantics
// getTypeInfo

unsigned clang_ASTContext_getOpenMPDefaultSimdAlign(CXASTContext Ctx, CXQualType T);

uint64_t clang_ASTContext_getTypeSize(CXASTContext Ctx, CXQualType T);

uint64_t clang_ASTContext_getCharWidth(CXASTContext Ctx);

// toCharUnitsFromBits
// toBits
// getTypeSizeInChars
// getTypeSizeInCharsIfKnown

uint64_t clang_ASTContext_getSizeOf(CXASTContext Ctx, CXQualType T);

unsigned clang_ASTContext_getTypeAlign(CXASTContext Ctx, CXQualType T);

unsigned clang_ASTContext_getTypeUnadjustedAlign(CXASTContext Ctx, CXQualType T);

unsigned clang_ASTContext_getTypeAlignIfKnown(CXASTContext Ctx, CXQualType T,
                                              bool NeedsPreferredAlignment);

// getTypeAlignInChars
// getPreferredTypeAlignInChars
// getTypeUnadjustedAlignInChars
// getTypeInfoDataSizeInChars
// getTypeInfoInChars

bool clang_ASTContext_isAlignmentRequired(CXASTContext Ctx, CXQualType T);

unsigned clang_ASTContext_getPreferredTypeAlign(CXASTContext Ctx, CXQualType T);

unsigned clang_ASTContext_getTargetDefaultAlignForAttributeAligned(CXASTContext Ctx);

unsigned clang_ASTContext_getAlignOfGlobalVar(CXASTContext Ctx, CXQualType T);

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

uint64_t clang_ASTContext_getFieldOffset(CXASTContext Ctx, CXValueDecl FD);

// lookupFieldBitOffset
// getMemberPointerPathAdjustment

bool clang_ASTContext_isNearlyEmpty(CXASTContext Ctx, CXCXXRecordDecl RD);

// getVTableContext

CXMangleContext clang_ASTContext_createMangleContext(CXASTContext Ctx, CXTargetInfo_ T);

// DeepCollectObjCIvars
// CountNonClassIvars
// CollectInheritedProtocols

bool clang_ASTContext_hasUniqueObjectRepresentations(CXASTContext Ctx, CXQualType Ty);

// getCanonicalType
// getCanonicalParamType

bool clang_ASTContext_hasSameType(CXASTContext Ctx, CXQualType T1, CXQualType T2);

// getUnqualifiedArrayType

bool clang_ASTContext_hasSameUnqualifiedType(CXASTContext Ctx, CXQualType T1,
                                             CXQualType T2);

bool clang_ASTContext_hasSameNullabilityTypeQualifier(CXASTContext Ctx, CXQualType SubT,
                                                      CXQualType SuperT, bool IsParam);

// ObjCMethodsAreEqual
// UnwrapSimilarTypes
// UnwrapSimilarArrayTypes

bool clang_ASTContext_hasSimilarType(CXASTContext Ctx, CXQualType T1, CXQualType T2);

bool clang_ASTContext_hasCvrSimilarType(CXASTContext Ctx, CXQualType T1, CXQualType T2);

CXNestedNameSpecifier
clang_ASTContext_getCanonicalNestedNameSpecifier(CXASTContext Ctx,
                                                 CXNestedNameSpecifier NNS);

// getDefaultCallingConvention

CXTemplateName clang_ASTContext_getCanonicalTemplateName(CXASTContext Ctx,
                                                         CXTemplateName TemplateName);

bool clang_ASTContext_hasSameTempalteName(CXASTContext Ctx, CXTemplateName T1,
                                          CXTemplateName T2);

// getCanonicalTemplateArgument

CXArrayType clang_ASTContext_getAsArrayType(CXASTContext Ctx, CXQualType T);

CXConstantArrayType clang_ASTContext_getAsConstantArrayType(CXASTContext Ctx, CXQualType T);

CXVariableArrayType clang_ASTContext_getAsVariableArrayType(CXASTContext Ctx, CXQualType T);

CXIncompleteArrayType clang_ASTContext_getAsIncompleteArrayType(CXASTContext Ctx,
                                                                CXQualType T);

CXDependentSizedArrayType clang_ASTContext_getAsDependentSizedArrayType(CXASTContext Ctx,
                                                                        CXQualType T);

// CXQualType clang_ASTContext_getBaseElementType(CXASTContext Ctx, CXArrayType VAT);
//   return static_cast<clang::ASTContext *>(Ctx)
//       ->getBaseElementType(static_cast<clang::ArrayType *>(VAT))
//       .getAsOpaquePtr();
// }

CXQualType clang_ASTContext_getBaseElementType(CXASTContext Ctx, CXQualType QT);

uint64_t clang_ASTContext_getConstantArrayElementCount(CXASTContext Ctx,
                                                       CXConstantArrayType CAT);

CXQualType clang_ASTContext_getAdjustedParameterType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getSignatureParameterType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getExceptionObjectType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getArrayDecayedType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getPromotedIntegerType(CXASTContext Ctx, CXQualType T);

// getInnerObjCOwnership

CXQualType clang_ASTContext_isPromotableBitField(CXASTContext Ctx, CXExpr E);

int clang_ASTContext_getIntegerTypeOrder(CXASTContext Ctx, CXQualType LHS, CXQualType RHS);

int clang_ASTContext_getFloatingTypeOrder(CXASTContext Ctx, CXQualType LHS, CXQualType RHS);

int clang_ASTContext_getFloatingTypeSemanticOrder(CXASTContext Ctx, CXQualType LHS,
                                                  CXQualType RHS);

// CXQualType clang_ASTContext_getFloatingTypeOfSizeWithinDomain(CXASTContext Ctx,
//                                                               CXQualType typeSize,
//                                                               CXQualType typeDomain);

// unsigned clang_ASTContext_getTargetAddressSpace(CXASTContext Ctx, CXQualType T);

// getLangASForBuiltinAddressSpace

uint64_t clang_ASTContext_getTargetNullPointerValue(CXASTContext Ctx, CXQualType T);

// clang_ASTContext_addressSpaceMapManglingFor

bool clang_ASTContext_typesAreCompatible(CXASTContext Ctx, CXQualType T1, CXQualType T2,
                                         bool CompareUnqualified);

bool clang_ASTContext_propertyTypesAreCompatible(CXASTContext Ctx, CXQualType T1,
                                                 CXQualType T2);

bool clang_ASTContext_typesAreBlockPointerCompatible(CXASTContext Ctx, CXQualType T1,
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

CXQualType clang_ASTContext_mergeTypes(CXASTContext Ctx, CXQualType T1, CXQualType T2,
                                       bool OfBlockPointer, bool Unqualified,
                                       bool BlockReturnType);

CXQualType clang_ASTContext_mergeFunctionTypes(CXASTContext Ctx, CXQualType T1,
                                               CXQualType T2, bool OfBlockPointer,
                                               bool Unqualified, bool AllowCXX);

CXQualType clang_ASTContext_mergeFunctionParameterTypes(CXASTContext Ctx, CXQualType T1,
                                                        CXQualType T2, bool OfBlockPointer,
                                                        bool Unqualified);

CXQualType clang_ASTContext_mergeTransparentUnionType(CXASTContext Ctx, CXQualType T1,
                                                      CXQualType T2, bool OfBlockPointer,
                                                      bool Unqualified);

CXQualType clang_ASTContext_mergeObjCGCQualifiers(CXASTContext Ctx, CXQualType T1,
                                                  CXQualType T2);

// mergeExtParameterInfo
// ResetObjCLayout

unsigned clang_ASTContext_getIntWidth(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getCorrespondingUnsignedType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getCorrespondingSaturatedType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getCorrespondingSignedFixedPointType(CXASTContext Ctx,
                                                                 CXQualType T);

CXIdentifierTable clang_ASTContext_getIdents(CXASTContext Ctx);

// MakeIntValue

bool clang_ASTContext_isSentinelNullExpr(CXASTContext Ctx, CXExpr E);

// getObjCImplementation
// AnyObjCImplementation
// setObjCImplementation
// getObjCMethodRedeclaration
// setObjCMethodRedeclaration
// getObjContainingInterface
// setBlockVarCopyInit
// getBlockVarCopyInit

CXTypeSourceInfo clang_ASTContext_CreateTypeSourceInfo(CXASTContext Ctx, CXQualType T,
                                                       unsigned Size);

CXTypeSourceInfo clang_ASTContext_getTrivialTypeSourceInfo(CXASTContext Ctx, CXQualType T,
                                                           CXSourceLocation_ Loc);

CXCXXConstructorDecl
clang_ASTContext_getCopyConstructorForExceptionObject(CXASTContext Ctx, CXCXXRecordDecl RD);

void clang_ASTContext_addCopyConstructorForExceptionObject(CXASTContext Ctx,
                                                           CXCXXRecordDecl RD,
                                                           CXCXXConstructorDecl CD);

void clang_ASTContext_addTypedefNameForUnnamedTagDecl(CXASTContext Ctx, CXTagDecl TD,
                                                      CXTypedefNameDecl TND);

CXTypedefNameDecl clang_ASTContext_getTypedefNameForUnnamedTagDecl(CXASTContext Ctx,
                                                                   CXTagDecl TD);

void clang_ASTContext_addDeclaratorForUnnamedTagDecl(CXASTContext Ctx, CXTagDecl TD,
                                                     CXDeclaratorDecl D);

CXDeclaratorDecl clang_ASTContext_getDeclaratorForUnnamedTagDecl(CXASTContext Ctx,
                                                                 CXTagDecl TD);

void clang_ASTContext_setManglingNumber(CXASTContext Ctx, CXNamedDecl ND, unsigned Number);

unsigned clang_ASTContext_getManglingNumber(CXASTContext Ctx, CXNamedDecl ND);

void clang_ASTContext_setStaticLocalNumber(CXASTContext Ctx, CXVarDecl ND, unsigned Number);

unsigned clang_ASTContext_getStaticLocalNumber(CXASTContext Ctx, CXVarDecl ND);

// getManglingNumberContext
// createManglingNumberingContext

void clang_ASTContext_setParameterIndex(CXASTContext Ctx, CXParmVarDecl D, unsigned index);

unsigned clang_ASTContext_getParameterIndex(CXASTContext Ctx, CXParmVarDecl D);

CXStringLiteral clang_ASTContext_getPredefinedStringLiteralFromCache(CXASTContext Ctx,
                                                                     const char *Key);

// getMSGuidDecl
// getTemplateParamObjectDecl
// filterFunctionTargetAttrs
// getFunctionFeatureMap

void clang_ASTContext_InitBuiltinTypes(CXASTContext Ctx, CXTargetInfo_ Target,
                                       CXTargetInfo_ AuxTarget);

// getObjCEncodingForMethodParameter

bool clang_ASTContext_isMSStaticDataMemberInlineDefinition(CXASTContext Ctx, CXVarDecl VD);

// getInlineVariableDefinitionKind

// bool clang_ASTContext_mayExternalizeStaticVar(CXASTContext Ctx, CXDecl D);

// bool clang_ASTContext_shouldExternalizeStaticVar(CXASTContext Ctx, CXDecl D);

// Builtin Types
CXQualType clang_ASTContext_VoidTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_BoolTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_CharTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_WCharTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_WideCharTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_WIntTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_Char8Ty_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_Char16Ty_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_Char32Ty_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_SignedCharTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_ShortTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_IntTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_LongTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_LongLongTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_Int128Ty_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_UnsignedCharTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_UnsignedShortTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_UnsignedIntTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_UnsignedLongTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_UnsignedLongLongTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_UnsignedInt128Ty_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_FloatTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_DoubleTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_LongDoubleTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_Float128Ty_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_HalfTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_BFloat16Ty_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_Float16Ty_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_VoidPtrTy_getAsQualType(CXASTContext Ctx);
CXQualType clang_ASTContext_NullPtrTy_getAsQualType(CXASTContext Ctx);

LLVM_CLANG_C_EXTERN_C_END

#endif