#ifndef LLVM_CLANG_C_EXTRA_CXASTCONTEXT_H
#define LLVM_CLANG_C_EXTRA_CXASTCONTEXT_H

#include "clang-ex/AST/CXType.h"
#include "clang-ex/Basic/CXSpecifiers.h"
#include "clang-ex/CXTypes.h"
#include "clang-ex/AST/CXAttr.h"
#include "clang-ex/Basic/CXAddressSpaces.h"
#include "clang-ex/Basic/CXLinkage.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-ex/Basic/CXTargetCXXABI.h"
#include "clang-ex/Basic/CXTargetInfo.h"
#include "llvm-c/ExecutionEngine.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Mirrors clang::AlignRequirementKind (clang/AST/ASTContext.h) — the third field
// of TypeInfo/TypeInfoChars, which cross as out-params (MARSHALLING.md §7).
typedef enum CXAlignRequirementKind {
  CXAlignRequirementKind_None,
  CXAlignRequirementKind_RequiredByTypedef,
  CXAlignRequirementKind_RequiredByRecord,
  CXAlignRequirementKind_RequiredByEnum
} CXAlignRequirementKind;

// Mirrors clang::ASTContext::InlineVariableDefinitionKind
// (clang/AST/ASTContext.h) — the class-local enum returned by
// getInlineVariableDefinitionKind.
typedef enum CXInlineVariableDefinitionKind {
  CXInlineVariableDefinitionKind_None,
  CXInlineVariableDefinitionKind_Weak,
  CXInlineVariableDefinitionKind_WeakUnknown,
  CXInlineVariableDefinitionKind_Strong
} CXInlineVariableDefinitionKind;

// ASTContext

// getInterpContext
// getParentMapContext
// getTraversalScope

// helper — how many decls clang_ASTContext_getTraversalScopeDecls will write
// (MARSHALLING.md §6, count+fill). The scope defaults to {getTranslationUnitDecl()}, so
// the count is at least 1 until setTraversalScope narrows it.
unsigned clang_ASTContext_getNumTraversalScopeDecls(CXASTContext Ctx);

// Fills Buf with exactly clang_ASTContext_getNumTraversalScopeDecls entries; the count is
// exact and no slot is null. Buf is caller-allocated; the decls it receives are borrowed
// interior pointers into the ASTContext arena.
void clang_ASTContext_getTraversalScopeDecls(CXASTContext Ctx, CXDecl *Buf);
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

// The C++ ABI in effect: -fc++-abi= when it was given, the target's default otherwise.
CXTargetCXXABI_Kind clang_ASTContext_getCXXABIKind(CXASTContext Ctx);
// cacheRawCommentForDecl
// getRawCommentForDeclNoCacheImpl
// getRawCommentForDeclNoCache
// addComment
// getRawCommentForAnyRedecl

// getRawCommentForAnyRedecl is exposed as two composite helpers rather than a
// CXRawComment handle: the comment text (already resolved against the
// ASTContext's own SourceManager) and the redeclaration the comment was attached
// to. Both report "no comment" out of band — an empty string (a RawComment always
// spans at least its introducer, so empty is unambiguous) and a null handle.
// clang 18 declares getRawCommentForDeclNoCache private; it cannot be wrapped.
// The RawComment handle itself, for callers that need more than the text (kind,
// attachment/trailing flags, range). Returns NULL when no comment is attached.
CXRawComment clang_ASTContext_getRawCommentForAnyRedecl(CXASTContext Ctx, CXDecl D);
CXString clang_ASTContext_getRawCommentTextForAnyRedecl(CXASTContext Ctx,
                                                        CXDecl D); // helper

CXDecl clang_ASTContext_getRawCommentOriginalDeclForAnyRedecl(CXASTContext Ctx,
                                                              CXDecl D); // helper
// attachCommentsToJustParsedDecl
// getCommentForDecl
// Parsed documentation comment tree for D, or NULL when none is attached. PP may
// be NULL when no Preprocessor is available.
CXFullComment clang_ASTContext_getCommentForDecl(CXASTContext Ctx, CXDecl D,
                                                 CXPreprocessor PP);
// getLocalCommentForDeclUncached

// The parsed documentation comment attached to D itself — no redeclaration lookup
// and no cache. NULL when none is attached.
CXFullComment clang_ASTContext_getLocalCommentForDeclUncached(CXASTContext Ctx, CXDecl D);
// cloneFullComment
// getCommentCommandTraits
// getDeclAttrs

void clang_ASTContext_eraseDeclAttrs(CXASTContext Ctx, CXDecl D);

// Partial (the Julia wrapper restates the precondition): clang asserts Var is a
// static data member. NULL when Var is not an instantiated one.
CXMemberSpecializationInfo
clang_ASTContext_getInstantiatedFromStaticDataMember(CXASTContext Ctx, CXVarDecl Var);

// getTemplateOrSpecializationInfo
// setInstantiatedFromStaticDataMember
// setTemplateOrSpecializationInfo

CXNamedDecl clang_ASTContext_getInstantiatedFromUsingDecl(CXASTContext Ctx,
                                                          CXNamedDecl Inst);

void clang_ASTContext_setInstantiatedFromUsingDecl(CXASTContext Ctx, CXNamedDecl Inst,
                                                   CXNamedDecl Pattern);

CXUsingEnumDecl clang_ASTContext_getInstantiatedFromUsingEnumDecl(CXASTContext Ctx,
                                                                  CXUsingEnumDecl Inst);

// PRECONDITION: Inst must not already carry a recorded pattern — clang asserts it. The
// Julia layer restates this by checking the getter first.
void clang_ASTContext_setInstantiatedFromUsingEnumDecl(CXASTContext Ctx,
                                                       CXUsingEnumDecl Inst,
                                                       CXUsingEnumDecl Pattern);

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

unsigned clang_ASTContext_overridden_methods_size(CXASTContext Ctx, CXCXXMethodDecl Method);

// helper — walks ASTContext::getOverriddenMethods once and reports how many entries
// clang_ASTContext_getOverriddenMethods will write (MARSHALLING.md §6, count+fill).
unsigned clang_ASTContext_getNumOverriddenMethods(CXASTContext Ctx, CXNamedDecl Method);

// Fills Buf with exactly clang_ASTContext_getNumOverriddenMethods entries; the count is
// exact and no slot is null. Buf is caller-allocated; the decls it receives are borrowed
// interior pointers into the ASTContext arena.
void clang_ASTContext_getOverriddenMethods(CXASTContext Ctx, CXNamedDecl Method,
                                           CXNamedDecl *Buf);

void clang_ASTContext_addedLocalImportDecl(CXASTContext Ctx, CXImportDecl Import);

// getNextLocalImport

// Static — ImportDecl's own accessor is private in clang 18, so this ASTContext entry
// point is the only path to the next link of the translation unit's local import chain.
// NULL at the end of the chain.
CXImportDecl clang_ASTContext_getNextLocalImport(CXImportDecl Import);

CXDecl clang_ASTContext_getPrimaryMergedDecl(CXASTContext Ctx, CXDecl D);

void clang_ASTContext_setPrimaryMergedDecl(CXASTContext Ctx, CXDecl D, CXDecl Primary);

void clang_ASTContext_mergeDefinitionIntoModule(CXASTContext Ctx, CXNamedDecl ND,
                                                CXModule Module, bool NotifyListeners);

void clang_ASTContext_deduplicateMergedDefinitonsFor(CXASTContext Ctx, CXNamedDecl ND);

// getModuleInitializers

// The C++20 named module under construction; NULL outside a named-module build.
CXModule clang_ASTContext_getCurrentNamedModule(CXASTContext Ctx);

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

// helper — the number of clang::Type nodes this context has created (MARSHALLING.md §6,
// count+index over ASTContext::getTypes(), which is contiguous storage).
unsigned clang_ASTContext_getNumTypes(CXASTContext Ctx);

// PRECONDITION: I < clang_ASTContext_getNumTypes(Ctx) — the index is unchecked; restated
// as an @assert in the Julia layer. The Type is a borrowed pointer into the ASTContext
// arena.
CXType_ clang_ASTContext_getType(CXASTContext Ctx, unsigned I);
// buildBuiltinTemplateDecl

CXRecordDecl clang_ASTContext_buildImplicitRecord(CXASTContext Ctx, const char *Name,
                                                  CXTagTypeKind TK);

CXTypedefDecl clang_ASTContext_buildImplicitTypedef(CXASTContext Ctx, CXQualType T,
                                                    const char *Name);

CXTypedefDecl clang_ASTContext_getInt128Decl(CXASTContext Ctx);

CXTypedefDecl clang_ASTContext_getUInt128Decl(CXASTContext Ctx);

// getAddrSpaceQualType

// Any address space already on T is silently replaced.
CXQualType clang_ASTContext_getAddrSpaceQualType(CXASTContext Ctx, CXQualType T,
                                                 CXLangAS AddressSpace);

CXQualType clang_ASTContext_removeAddrSpaceQualType(CXASTContext Ctx, CXQualType T);

// applyObjCProtocolQualifiers
// getObjCGCQualType

CXQualType clang_ASTContext_removePtrSizeAddrSpace(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getRestrictType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getVolatileType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getConstType(CXASTContext Ctx, CXQualType T);

// adjustFunctionType
// getCanonicalFunctionResultType

CXQualType clang_ASTContext_getCanonicalFunctionResultType(CXASTContext Ctx,
                                                           CXQualType ResultType);

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

// Qualifiers cross as their opaque value — the same encoding
// clang_QualType_getQualifiersAsOpaqueValue produces.
CXQualType clang_ASTContext_getQualifiedType(CXASTContext Ctx, CXQualType T,
                                             unsigned Quals);

// Peels the qualifiers off the (possibly nested) array element type; *Quals
// receives them as the opaque Qualifiers value. Total: on a non-array it yields
// T.getUnqualifiedType() and the qualifiers it stripped.
CXQualType clang_ASTContext_getUnqualifiedArrayType(CXASTContext Ctx, CXQualType T,
                                                    unsigned *Quals);

CXQualType clang_ASTContext_getAttributedType(CXASTContext Ctx, CXAttrKind AttrKind,
                                              CXQualType ModifiedType,
                                              CXQualType EquivalentType);

CXQualType clang_ASTContext_getIncompleteArrayType(CXASTContext Ctx, CXQualType EltTy,
                                                   CXArraySizeModifier ASM,
                                                   unsigned IndexTypeQuals);

bool clang_ASTContext_isPromotableIntegerType(CXASTContext Ctx, CXQualType T);

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

// The OpenCL type family T belongs to; OCLTK_Default for every type that is not one of
// OpenCL's opaque builtins (so, for every ordinary C/C++ type).
CXOpenCLTypeKind clang_ASTContext_getOpenCLTypeKind(CXASTContext Ctx, CXType_ T);

// The address space the target assigns to T's OpenCL type family.
CXLangAS clang_ASTContext_getOpenCLTypeAddrSpace(CXASTContext Ctx, CXType_ T);

CXLangAS clang_ASTContext_getDefaultOpenCLPointeeAddrSpace(CXASTContext Ctx);

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

// NumElts is stored on the type, never evaluated; the result is deliberately non-unique
// (a fresh type node per call), matching the C++ API.
CXQualType clang_ASTContext_getVariableArrayType(CXASTContext Ctx, CXQualType EltTy,
                                                 CXExpr NumElts, CXArraySizeModifier ASM,
                                                 unsigned IndexTypeQuals,
                                                 CXSourceRange_ Brackets);

// Same shape as getVariableArrayType, for a dependently-sized array; also non-unique.
CXQualType clang_ASTContext_getDependentSizedArrayType(CXASTContext Ctx, CXQualType EltTy,
                                                       CXExpr NumElts,
                                                       CXArraySizeModifier ASM,
                                                       unsigned IndexTypeQuals,
                                                       CXSourceRange_ Brackets);

// The APInt size is built inside the shim from `Size` at the target's size_t
// width; SizeExpr is always null.
CXQualType clang_ASTContext_getConstantArrayType(CXASTContext Ctx, CXQualType EltTy,
                                                 uint64_t Size, CXArraySizeModifier ASM,
                                                 unsigned IndexTypeQuals);

// getStringLiteralArrayType

CXQualType clang_ASTContext_getStringLiteralArrayType(CXASTContext Ctx, CXQualType EltTy,
                                                      unsigned Length);

CXQualType clang_ASTContext_getVariableArrayDecayedType(CXASTContext Ctx, CXQualType T);

// getBuiltinVectorTypeInfo

CXQualType clang_ASTContext_getScalableVectorType(CXASTContext Ctx, CXQualType EltTy,
                                                  unsigned NumElts);

CXQualType clang_ASTContext_getVectorType(CXASTContext Ctx, CXQualType VectorType,
                                          unsigned NumElts, CXVectorKind VecKind);

// getVectorType
// getDependentVectorType

CXQualType clang_ASTContext_getDependentVectorType(CXASTContext Ctx, CXQualType VectorType,
                                                   CXExpr SizeExpr,
                                                   CXSourceLocation_ AttrLoc,
                                                   CXVectorKind VecKind);

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

// ExtProtoInfo flattened to the FFI-relevant subset (variadic + calling
// convention; everything else defaulted). `ArgTys` is a (handle-buffer, count)
// array of CXQualType encodings rebuilt into an ArrayRef inside the shim.
CXQualType clang_ASTContext_getFunctionType(CXASTContext Ctx, CXQualType ResultTy,
                                            const CXQualType *ArgTys, unsigned NumArgs,
                                            bool IsVariadic, CXCallingConv_ CC);

CXQualType clang_ASTContext_adjustStringLiteralBaseType(CXASTContext Ctx,
                                                        CXQualType StrLTy);

CXQualType clang_ASTContext_getTypeDeclType(CXASTContext Ctx, CXTypeDecl Decl,
                                            CXTypeDecl PrevDecl);

// PRECONDITION (documented in the Julia wrapper; the C API exposes no cheap proxy for
// it): Found's target declaration must be a TypeDecl — clang casts it unchecked — and
// Underlying must be unqualified and canonically identical to that declaration's type,
// both of which clang asserts.
CXQualType clang_ASTContext_getUsingType(CXASTContext Ctx, CXUsingShadowDecl Found,
                                         CXQualType Underlying);

CXQualType clang_ASTContext_getTypedefType(CXASTContext Ctx, CXTypedefNameDecl Decl,
                                           CXQualType Underlying);

CXQualType clang_ASTContext_getRecordType(CXASTContext Ctx, CXRecordDecl Decl);

CXQualType clang_ASTContext_getEnumType(CXASTContext Ctx, CXEnumDecl Decl);

// Builds (and caches on the declaration) the UnresolvedUsingType of a dependent
// `using typename T::x;` declaration.
CXQualType clang_ASTContext_getUnresolvedUsingType(CXASTContext Ctx,
                                                   CXUnresolvedUsingTypenameDecl Decl);

CXQualType clang_ASTContext_getInjectedClassNameType(CXASTContext Ctx, CXCXXRecordDecl Decl,
                                                     CXQualType TST);

// getAttributedType

// CXQualType clang_ASTContext_getSubstTemplateTypeParmType(CXASTContext Ctx,
//                                                          CXTemplateTypeParmType Replaced,
//                                                          CXQualType Replacement);

// getSubstTemplateTypeParmPackType

CXQualType clang_ASTContext_getTemplateTypeParmType(CXASTContext Ctx, unsigned Depth,
                                                    unsigned Index, bool ParameterPack,
                                                    CXTemplateTypeParmDecl ParmDecl);

// `Args` is a (handle-buffer, count) pair of CXTemplateArgument encodings
// (each handle is dereferenced — the buffer is handles, not a contiguous
// value array). `Underlying` may be null; it is only consulted for alias
// templates.
CXQualType clang_ASTContext_getTemplateSpecializationType(
    CXASTContext Ctx, CXTemplateName T, const CXTemplateArgument *Args,
    unsigned NumArgs, CXQualType Underlying);

// getCanonicalTemplateSpecializationType
// getTemplateSpecializationType (TemplateArgumentLoc overload)
// getTemplateSpecializationTypeInfo

CXQualType clang_ASTContext_getParenType(CXASTContext Ctx, CXQualType NamedType);

CXQualType clang_ASTContext_getMacroQualifiedType(CXASTContext Ctx, CXQualType UnderlyingTy,
                                                  CXIdentifierInfo MacroII);

CXQualType clang_ASTContext_getElaboratedType(CXASTContext Ctx,
                                              CXElaboratedTypeKeyword Keyword,
                                              CXNestedNameSpecifier NNS,
                                              CXQualType NamedType, CXTagDecl OwnedTagDecl);

// NumExpansions crosses as (bool HasNumExpansions, unsigned NumExpansions)
// (MARSHALLING.md, section 8): pass HasNumExpansions=false for a disengaged optional.
// When ExpectPackInType is true, Pattern must contain an unexpanded parameter pack.
CXQualType clang_ASTContext_getPackExpansionType(CXASTContext Ctx, CXQualType Pattern,
                                                 bool HasNumExpansions,
                                                 unsigned NumExpansions,
                                                 bool ExpectPackInType);

// getElaboratedType
// getDependentNameType
// getDependentTemplateSpecializationType

// PRECONDITION: ParamDecl must be a template parameter (TemplateTypeParmDecl,
// NonTypeTemplateParmDecl or TemplateTemplateParmDecl); clang cast<>s it unchecked.
// Restated as an @assert in the Julia layer. The TemplateArgument is returned as an owned
// box (it has no pointer encoding); release it with clang_TemplateArgument_dispose.
CXTemplateArgument clang_ASTContext_getInjectedTemplateArg(CXASTContext Ctx,
                                                           CXNamedDecl ParamDecl);
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

// Unqualified picks clang::TypeOfKind::Unqualified over ::Qualified; the two-state enum
// class crosses as a bool.
CXQualType clang_ASTContext_getTypeOfExprType(CXASTContext Ctx, CXExpr E, bool Unqualified);

CXQualType clang_ASTContext_getTypeOfType(CXASTContext Ctx, CXQualType QT,
                                          bool Unqualified);

CXQualType clang_ASTContext_getReferenceQualifiedType(CXASTContext Ctx, CXExpr E);

CXQualType clang_ASTContext_getDecltypeType(CXASTContext Ctx, CXExpr Expr,
                                            CXQualType UnderlyingType);

// getUnaryTransformType
// getAutoType

// The type of a unary type transform (__underlying_type and the __add_*/__remove_*
// family): BaseType is the operand, UnderlyingType the transformed result. A dependent
// BaseType yields a DependentUnaryTransformType instead.
CXQualType clang_ASTContext_getUnaryTransformType(CXASTContext Ctx, CXQualType BaseType,
                                                  CXQualType UnderlyingType,
                                                  CXUTTKind UKind);

CXQualType clang_ASTContext_getAutoDeductType(CXASTContext Ctx);

CXQualType clang_ASTContext_getAutoRRefDeductType(CXASTContext Ctx);

CXQualType clang_ASTContext_getUnconstrainedType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getDeducedTemplateSpecializationType(CXASTContext Ctx,
                                                                 CXTemplateName Template,
                                                                 CXQualType DeducedType,
                                                                 bool IsDependent);

CXQualType clang_ASTContext_getTagDeclType(CXASTContext Ctx, CXTagDecl Decl);

// getSizeType
// getSignedSizeType
// getIntMaxType

CXQualType clang_ASTContext_getIntMaxType(CXASTContext Ctx);
// getUIntMaxType

CXQualType clang_ASTContext_getSizeType(CXASTContext Ctx);

CXQualType clang_ASTContext_getSignedSizeType(CXASTContext Ctx);

CXQualType clang_ASTContext_getUIntMaxType(CXASTContext Ctx);

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

CXIdentifierInfo clang_ASTContext_getNSObjectName(CXASTContext Ctx);

CXIdentifierInfo clang_ASTContext_getNSCopyingName(CXASTContext Ctx);

CXQualType clang_ASTContext_getNSUIntegerType(CXASTContext Ctx);

CXQualType clang_ASTContext_getNSIntegerType(CXASTContext Ctx);

// getNSUIntegerType
// getNSIntegerType

CXIdentifierInfo clang_ASTContext_getBoolName(CXASTContext Ctx);

CXIdentifierInfo clang_ASTContext_getMakeIntegerSeqName(CXASTContext Ctx);

CXIdentifierInfo clang_ASTContext_getTypePackElementName(CXASTContext Ctx);

CXQualType clang_ASTContext_getObjCInstanceType(CXASTContext Ctx);

CXTypedefDecl clang_ASTContext_getObjCInstanceTypeDecl(CXASTContext Ctx);

void clang_ASTContext_setFILEDecl(CXASTContext Ctx, CXTypeDecl FILEDecl);

CXQualType clang_ASTContext_getFILEType(CXASTContext Ctx);

// The three C library types below are null QualTypes until the matching setter has run
// (the decl is looked up by Sema when <setjmp.h>/<ucontext.h> is seen).
CXQualType clang_ASTContext_getjmp_bufType(CXASTContext Ctx);

CXQualType clang_ASTContext_getsigjmp_bufType(CXASTContext Ctx);

CXQualType clang_ASTContext_getucontext_tType(CXASTContext Ctx);

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

CXQualType clang_ASTContext_getBuiltinVaListType(CXASTContext Ctx);

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

// The DeclarationNameInfo is returned as an owned box (the class has no opaque encoding);
// release it with clang_DeclarationNameInfo_dispose.
CXDeclarationNameInfo clang_ASTContext_getNameForTemplate(CXASTContext Ctx,
                                                          CXTemplateName Name,
                                                          CXSourceLocation_ NameLoc);
// getOverloadedTemplateName

CXTemplateName clang_ASTContext_getAssumedTemplateName(CXASTContext Ctx,
                                                       CXDeclarationName Name);

// CXTemplateName clang_ASTContext_getQualifiedTemplateName(CXASTContext Ctx,
//                                                          CXNestedNameSpecifier NNS,
//                                                          bool TemplateKeyword,
//                                                          CXTemplateDecl Template);

// The qualified spelling NNS::[template] Template. NNS must be non-null (clang asserts).
CXTemplateName clang_ASTContext_getQualifiedTemplateName(CXASTContext Ctx,
                                                         CXNestedNameSpecifier NNS,
                                                         bool TemplateKeyword,
                                                         CXTemplateName Template);

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

bool clang_ASTContext_areCompatibleRVVTypes(CXASTContext Ctx, CXQualType FirstType,
                                            CXQualType SecondType);

bool clang_ASTContext_areLaxCompatibleRVVTypes(CXASTContext Ctx, CXQualType FirstType,
                                               CXQualType SecondType);

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

// TypeInfo / TypeInfoChars cross as out-params (MARSHALLING.md §7). getTypeInfo
// reports BITS; every other quantity below is a CharUnits value in BYTES.
// PRECONDITION for this whole family, restated as an @assert in the Julia layer:
// T must not be a dependent type (ASTContext::getTypeInfoImpl is llvm_unreachable
// on those) and record/enum types must be complete, because the query lays the
// record out eagerly. The shim checks neither, by contract.
void clang_ASTContext_getTypeInfo(CXASTContext Ctx, CXQualType T, uint64_t *Width,
                                  unsigned *Align,
                                  CXAlignRequirementKind *AlignRequirement);

void clang_ASTContext_getTypeInfoInChars(CXASTContext Ctx, CXQualType T,
                                         int64_t *Width, int64_t *Align,
                                         CXAlignRequirementKind *AlignRequirement);

int64_t clang_ASTContext_getTypeSizeInChars(CXASTContext Ctx, CXQualType T);

int64_t clang_ASTContext_getTypeAlignInChars(CXASTContext Ctx, CXQualType T);

int64_t clang_ASTContext_getPreferredTypeAlignInChars(CXASTContext Ctx, CXQualType T);

int64_t clang_ASTContext_getTypeUnadjustedAlignInChars(CXASTContext Ctx, CXQualType T);

// Returns false and leaves *Size untouched when the size is not known — T incomplete or
// dependent (MARSHALLING.md §8). Unlike the rest of this family it is total.
bool clang_ASTContext_getTypeSizeInCharsIfKnown(CXASTContext Ctx, CXQualType T,
                                                int64_t *Size);

// Data size in BYTES (a record's tail padding is excluded) instead of sizeof; inherits
// the completeness/non-dependence precondition of the getTypeInfo family above.
void clang_ASTContext_getTypeInfoDataSizeInChars(CXASTContext Ctx, CXQualType T,
                                                 int64_t *Width, int64_t *Align,
                                                 CXAlignRequirementKind *AlignRequirement);

int64_t clang_ASTContext_toCharUnitsFromBits(CXASTContext Ctx, int64_t BitSize);

int64_t clang_ASTContext_toBits(CXASTContext Ctx, int64_t CharSize);

// ForAlignof selects alignof() semantics over the ABI alignment. Routes through
// getTypeInfo, so it inherits the completeness precondition above.
int64_t clang_ASTContext_getDeclAlign(CXASTContext Ctx, CXDecl D, bool ForAlignof);

int64_t clang_ASTContext_getAlignOfGlobalVarInChars(CXASTContext Ctx, CXQualType T);

int64_t clang_ASTContext_getExnObjectAlignment(CXASTContext Ctx);

// getAlignOfGlobalVarInChars
// getDeclAlign
// getExnObjectAlignment

// Borrowed, ASTContext-arena owned — no dispose. Precondition (checked by the
// Julia layer, per the axiom): `RD` has a complete definition.
CXASTRecordLayout clang_ASTContext_getASTRecordLayout(CXASTContext Ctx, CXRecordDecl RD);
// getASTObjCInterfaceLayout
// DumpRecordLayout

// The layout dump clang writes to a raw_ostream, returned as a CXString (MARSHALLING.md
// §5). Simple selects the one-line form. PRECONDITION: RD has a complete definition —
// clang asserts it through getASTRecordLayout; restated as an @assert in the Julia layer.
CXString clang_ASTContext_DumpRecordLayout(CXASTContext Ctx, CXRecordDecl RD, bool Simple);
// getASTObjCImplementationLayout
// getCurrentKeyFunction

// Partial (the Julia wrapper restates the precondition): clang asserts RD has a
// definition. NULL when the class has no key function.
CXCXXMethodDecl clang_ASTContext_getCurrentKeyFunction(CXASTContext Ctx,
                                                       CXCXXRecordDecl RD);
// setNonKeyFunction
// getOffsetOfBaseWithVBPtr

uint64_t clang_ASTContext_getFieldOffset(CXASTContext Ctx, CXValueDecl FD);

// lookupFieldBitOffset
// getMemberPointerPathAdjustment

// The `this` adjustment a member pointer's inheritance path implies, in bytes (the
// CharUnits convention of the ASTRecordLayout family). PRECONDITION: MP must hold a
// member pointer — APValue's accessor asserts on the kind; restated as an @assert in
// the Julia layer.
int64_t clang_ASTContext_getMemberPointerPathAdjustment(CXASTContext Ctx, CXAPValue MP);

bool clang_ASTContext_isNearlyEmpty(CXASTContext Ctx, CXCXXRecordDecl RD);

// getVTableContext

CXMangleContext clang_ASTContext_createMangleContext(CXASTContext Ctx, CXTargetInfo_ T);

// PRECONDITION: T's C++ ABI must not be Microsoft — clang asserts it and the mangler
// switch has no Microsoft arm. Restated as an @assert in the Julia layer.
// Caller-owned heap object with no dispose entry point (the same known leak as
// clang_ASTContext_createMangleContext).
CXMangleContext clang_ASTContext_createDeviceMangleContext(CXASTContext Ctx,
                                                           CXTargetInfo_ T);

// DeepCollectObjCIvars
// CountNonClassIvars
// CollectInheritedProtocols

bool clang_ASTContext_hasUniqueObjectRepresentations(CXASTContext Ctx, CXQualType Ty);

// getCanonicalType

CXQualType clang_ASTContext_getCanonicalType(CXASTContext Ctx, CXQualType T);
// getCanonicalParamType

CXQualType clang_ASTContext_getCanonicalParamType(CXASTContext Ctx, CXQualType T);

bool clang_ASTContext_hasSameType(CXASTContext Ctx, CXQualType T1, CXQualType T2);

bool clang_ASTContext_hasSameExpr(CXASTContext Ctx, CXExpr X, CXExpr Y);

// getUnqualifiedArrayType

bool clang_ASTContext_hasSameUnqualifiedType(CXASTContext Ctx, CXQualType T1,
                                             CXQualType T2);

bool clang_ASTContext_hasSameNullabilityTypeQualifier(CXASTContext Ctx, CXQualType SubT,
                                                      CXQualType SuperT, bool IsParam);

// ObjCMethodsAreEqual
// UnwrapSimilarTypes
// UnwrapSimilarArrayTypes

// T1 and T2 are in/out: the C++ methods take them by reference and rewrite them to the
// unwrapped pointee/element types, so they cross as pointers to the QualType opaque
// encodings (MARSHALLING.md §7). UnwrapSimilarTypes reports whether a layer was peeled.
bool clang_ASTContext_UnwrapSimilarTypes(CXASTContext Ctx, CXQualType *T1, CXQualType *T2,
                                         bool AllowPiMismatch);

void clang_ASTContext_UnwrapSimilarArrayTypes(CXASTContext Ctx, CXQualType *T1,
                                              CXQualType *T2, bool AllowPiMismatch);

bool clang_ASTContext_hasSimilarType(CXASTContext Ctx, CXQualType T1, CXQualType T2);

bool clang_ASTContext_hasCvrSimilarType(CXASTContext Ctx, CXQualType T1, CXQualType T2);

CXNestedNameSpecifier
clang_ASTContext_getCanonicalNestedNameSpecifier(CXASTContext Ctx,
                                                 CXNestedNameSpecifier NNS);

// getDefaultCallingConvention

CXCallingConv_ clang_ASTContext_getDefaultCallingConvention(CXASTContext Ctx,
                                                            bool IsVariadic,
                                                            bool IsCXXMethod,
                                                            bool IsBuiltin);

CXTemplateName clang_ASTContext_getCanonicalTemplateName(CXASTContext Ctx,
                                                         CXTemplateName TemplateName);

bool clang_ASTContext_hasSameTempalteName(CXASTContext Ctx, CXTemplateName T1,
                                          CXTemplateName T2);

bool clang_ASTContext_isSameEntity(CXASTContext Ctx, CXNamedDecl X, CXNamedDecl Y);

bool clang_ASTContext_isSameTemplateParameterList(CXASTContext Ctx,
                                                  CXTemplateParameterList X,
                                                  CXTemplateParameterList Y);

bool clang_ASTContext_isSameTemplateParameter(CXASTContext Ctx, CXNamedDecl X,
                                              CXNamedDecl Y);

bool clang_ASTContext_isSameConstraintExpr(CXASTContext Ctx, CXExpr XCE, CXExpr YCE);

// PRECONDITION: X and Y must have the same Decl kind (clang asserts it); restated as an
// @assert in the Julia layer.
bool clang_ASTContext_isSameDefaultTemplateArgument(CXASTContext Ctx, CXNamedDecl X,
                                                    CXNamedDecl Y);

// getCanonicalTemplateArgument

// The TemplateArgument is returned as an owned box (it has no pointer encoding); release
// it with clang_TemplateArgument_dispose.
CXTemplateArgument clang_ASTContext_getCanonicalTemplateArgument(CXASTContext Ctx,
                                                                 CXTemplateArgument Arg);

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

// The number of elements the implicit initialization loop AILE covers — the loop clang
// synthesizes for array copy-initialization and for array captures of a lambda.
uint64_t clang_ASTContext_getArrayInitLoopExprElementCount(CXASTContext Ctx,
                                                           CXArrayInitLoopExpr AILE);

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

unsigned clang_ASTContext_getTargetAddressSpace(CXASTContext Ctx, CXLangAS AS);

// getLangASForBuiltinAddressSpace

CXLangAS clang_ASTContext_getLangASForBuiltinAddressSpace(CXASTContext Ctx, unsigned AS);

uint64_t clang_ASTContext_getTargetNullPointerValue(CXASTContext Ctx, CXQualType T);

// clang_ASTContext_addressSpaceMapManglingFor

bool clang_ASTContext_addressSpaceMapManglingFor(CXASTContext Ctx, CXLangAS AS);

// mergeExceptionSpecs

// Partial (the Julia wrapper restates the precondition): X and Y must be the same
// type — the same unqualified type when Unqualified is true.
CXQualType clang_ASTContext_getCommonSugaredType(CXASTContext Ctx, CXQualType X,
                                                 CXQualType Y, bool Unqualified);

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

// Partial (the Julia wrapper restates the precondition): T must be an unsigned
// integer type or an unsigned fixed-point type.
CXQualType clang_ASTContext_getCorrespondingSignedType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getCorrespondingSaturatedType(CXASTContext Ctx, CXQualType T);

CXQualType clang_ASTContext_getCorrespondingSignedFixedPointType(CXASTContext Ctx,
                                                                 CXQualType T);

CXIdentifierTable clang_ASTContext_getIdents(CXASTContext Ctx);

// MakeIntValue

// Value as an APSInt of Type's width and signedness, boxed in a caller-owned
// LLVMGenericValueRef (APSInt in GV->IntVal, released via llvm-c). See MARSHALLING.md §1.
// PRECONDITION: Type must be a complete integral or enumeration type — getIntWidth
// reaches getTypeSize, which asserts otherwise; restated as an @assert in the Julia layer.
LLVMGenericValueRef clang_ASTContext_MakeIntValue(CXASTContext Ctx, uint64_t Value,
                                                  CXQualType Type);

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

CXGVALinkage clang_ASTContext_GetGVALinkageForFunction(CXASTContext Ctx, CXFunctionDecl FD);

CXGVALinkage clang_ASTContext_GetGVALinkageForVariable(CXASTContext Ctx, CXVarDecl VD);

bool clang_ASTContext_DeclMustBeEmitted(CXASTContext Ctx, CXDecl D);

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

CXInlineVariableDefinitionKind
clang_ASTContext_getInlineVariableDefinitionKind(CXASTContext Ctx, CXVarDecl VD);

// bool clang_ASTContext_mayExternalizeStaticVar(CXASTContext Ctx, CXDecl D);

// bool clang_ASTContext_shouldExternalizeStaticVar(CXASTContext Ctx, CXDecl D);

bool clang_ASTContext_mayExternalize(CXASTContext Ctx, CXDecl D);

bool clang_ASTContext_shouldExternalize(CXASTContext Ctx, CXDecl D);

// Hash of the CUDA/HIP compilation-unit ID; the empty string when -fcuid was not
// given.
CXString clang_ASTContext_getCUIDHash(CXASTContext Ctx);

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