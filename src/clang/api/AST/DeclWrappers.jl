# Generated from deps/ClangExtra/include/clang-ex/AST/DeclNodes.inc by gen/decl_nodes.jl — do not edit.
# Per-class checked cast: the `<Name>Decl` constructor is C++'s `cast<T>` and the
# `is<Name>Decl` predicate beside it is `isa<T>`. Both come from clang's own
# `classof`, so a declaration can never become a carrier that names another class.
#
# The shim types each cast at that class's own handle, so pairing a cast with the
# wrong carrier is a Julia type error here rather than a bad pointer reaching clang.

function isTranslationUnitDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTranslationUnitDecl(x)
end

function TranslationUnitDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToTranslationUnitDecl(x)
    p == C_NULL && _cast_failed(TranslationUnitDecl, x)
    return TranslationUnitDecl(p)
end

function isRequiresExprBodyDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isRequiresExprBodyDecl(x)
end

function RequiresExprBodyDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToRequiresExprBodyDecl(x)
    p == C_NULL && _cast_failed(RequiresExprBodyDecl, x)
    return RequiresExprBodyDecl(p)
end

function isLinkageSpecDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isLinkageSpecDecl(x)
end

function LinkageSpecDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToLinkageSpecDecl(x)
    p == C_NULL && _cast_failed(LinkageSpecDecl, x)
    return LinkageSpecDecl(p)
end

function isExternCContextDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isExternCContextDecl(x)
end

function ExternCContextDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToExternCContextDecl(x)
    p == C_NULL && _cast_failed(ExternCContextDecl, x)
    return ExternCContextDecl(p)
end

function isExportDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isExportDecl(x)
end

function ExportDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToExportDecl(x)
    p == C_NULL && _cast_failed(ExportDecl, x)
    return ExportDecl(p)
end

function isCapturedDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isCapturedDecl(x)
end

function CapturedDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToCapturedDecl(x)
    p == C_NULL && _cast_failed(CapturedDecl, x)
    return CapturedDecl(p)
end

function isBlockDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isBlockDecl(x)
end

function BlockDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToBlockDecl(x)
    p == C_NULL && _cast_failed(BlockDecl, x)
    return BlockDecl(p)
end

function isTopLevelStmtDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTopLevelStmtDecl(x)
end

function TopLevelStmtDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToTopLevelStmtDecl(x)
    p == C_NULL && _cast_failed(TopLevelStmtDecl, x)
    return TopLevelStmtDecl(p)
end

function isStaticAssertDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isStaticAssertDecl(x)
end

function StaticAssertDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToStaticAssertDecl(x)
    p == C_NULL && _cast_failed(StaticAssertDecl, x)
    return StaticAssertDecl(p)
end

function isPragmaDetectMismatchDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isPragmaDetectMismatchDecl(x)
end

function PragmaDetectMismatchDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToPragmaDetectMismatchDecl(x)
    p == C_NULL && _cast_failed(PragmaDetectMismatchDecl, x)
    return PragmaDetectMismatchDecl(p)
end

function isPragmaCommentDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isPragmaCommentDecl(x)
end

function PragmaCommentDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToPragmaCommentDecl(x)
    p == C_NULL && _cast_failed(PragmaCommentDecl, x)
    return PragmaCommentDecl(p)
end

function isObjCPropertyImplDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isObjCPropertyImplDecl(x)
end

function ObjCPropertyImplDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToObjCPropertyImplDecl(x)
    p == C_NULL && _cast_failed(ObjCPropertyImplDecl, x)
    return ObjCPropertyImplDecl(p)
end

function isNamedDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isNamedDecl(x)
end

function NamedDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToNamedDecl(x)
    p == C_NULL && _cast_failed(NamedDecl, x)
    return NamedDecl(p)
end

function isObjCMethodDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isObjCMethodDecl(x)
end

function ObjCMethodDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToObjCMethodDecl(x)
    p == C_NULL && _cast_failed(ObjCMethodDecl, x)
    return ObjCMethodDecl(p)
end

function isObjCContainerDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isObjCContainerDecl(x)
end

function ObjCContainerDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToObjCContainerDecl(x)
    p == C_NULL && _cast_failed(ObjCContainerDecl, x)
    return ObjCContainerDecl(p)
end

function isObjCProtocolDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isObjCProtocolDecl(x)
end

function ObjCProtocolDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToObjCProtocolDecl(x)
    p == C_NULL && _cast_failed(ObjCProtocolDecl, x)
    return ObjCProtocolDecl(p)
end

function isObjCInterfaceDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isObjCInterfaceDecl(x)
end

function ObjCInterfaceDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToObjCInterfaceDecl(x)
    p == C_NULL && _cast_failed(ObjCInterfaceDecl, x)
    return ObjCInterfaceDecl(p)
end

function isObjCImplDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isObjCImplDecl(x)
end

function ObjCImplDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToObjCImplDecl(x)
    p == C_NULL && _cast_failed(ObjCImplDecl, x)
    return ObjCImplDecl(p)
end

function isObjCImplementationDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isObjCImplementationDecl(x)
end

function ObjCImplementationDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToObjCImplementationDecl(x)
    p == C_NULL && _cast_failed(ObjCImplementationDecl, x)
    return ObjCImplementationDecl(p)
end

function isObjCCategoryImplDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isObjCCategoryImplDecl(x)
end

function ObjCCategoryImplDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToObjCCategoryImplDecl(x)
    p == C_NULL && _cast_failed(ObjCCategoryImplDecl, x)
    return ObjCCategoryImplDecl(p)
end

function isObjCCategoryDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isObjCCategoryDecl(x)
end

function ObjCCategoryDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToObjCCategoryDecl(x)
    p == C_NULL && _cast_failed(ObjCCategoryDecl, x)
    return ObjCCategoryDecl(p)
end

function isNamespaceDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isNamespaceDecl(x)
end

function NamespaceDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToNamespaceDecl(x)
    p == C_NULL && _cast_failed(NamespaceDecl, x)
    return NamespaceDecl(p)
end

function isHLSLBufferDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isHLSLBufferDecl(x)
end

function HLSLBufferDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToHLSLBufferDecl(x)
    p == C_NULL && _cast_failed(HLSLBufferDecl, x)
    return HLSLBufferDecl(p)
end

function isValueDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isValueDecl(x)
end

function ValueDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToValueDecl(x)
    p == C_NULL && _cast_failed(ValueDecl, x)
    return ValueDecl(p)
end

function isUnresolvedUsingValueDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isUnresolvedUsingValueDecl(x)
end

function UnresolvedUsingValueDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToUnresolvedUsingValueDecl(x)
    p == C_NULL && _cast_failed(UnresolvedUsingValueDecl, x)
    return UnresolvedUsingValueDecl(p)
end

function isUnnamedGlobalConstantDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isUnnamedGlobalConstantDecl(x)
end

function UnnamedGlobalConstantDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToUnnamedGlobalConstantDecl(x)
    p == C_NULL && _cast_failed(UnnamedGlobalConstantDecl, x)
    return UnnamedGlobalConstantDecl(p)
end

function isTemplateParamObjectDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTemplateParamObjectDecl(x)
end

function TemplateParamObjectDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToTemplateParamObjectDecl(x)
    p == C_NULL && _cast_failed(TemplateParamObjectDecl, x)
    return TemplateParamObjectDecl(p)
end

function isMSGuidDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isMSGuidDecl(x)
end

function MSGuidDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToMSGuidDecl(x)
    p == C_NULL && _cast_failed(MSGuidDecl, x)
    return MSGuidDecl(p)
end

function isIndirectFieldDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isIndirectFieldDecl(x)
end

function IndirectFieldDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToIndirectFieldDecl(x)
    p == C_NULL && _cast_failed(IndirectFieldDecl, x)
    return IndirectFieldDecl(p)
end

function isEnumConstantDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isEnumConstantDecl(x)
end

function EnumConstantDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToEnumConstantDecl(x)
    p == C_NULL && _cast_failed(EnumConstantDecl, x)
    return EnumConstantDecl(p)
end

function isDeclaratorDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isDeclaratorDecl(x)
end

function DeclaratorDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToDeclaratorDecl(x)
    p == C_NULL && _cast_failed(DeclaratorDecl, x)
    return DeclaratorDecl(p)
end

function isFunctionDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isFunctionDecl(x)
end

function FunctionDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToFunctionDecl(x)
    p == C_NULL && _cast_failed(FunctionDecl, x)
    return FunctionDecl(p)
end

function isCXXMethodDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isCXXMethodDecl(x)
end

function CXXMethodDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToCXXMethodDecl(x)
    p == C_NULL && _cast_failed(CXXMethodDecl, x)
    return CXXMethodDecl(p)
end

function isCXXDestructorDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isCXXDestructorDecl(x)
end

function CXXDestructorDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToCXXDestructorDecl(x)
    p == C_NULL && _cast_failed(CXXDestructorDecl, x)
    return CXXDestructorDecl(p)
end

function isCXXConversionDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isCXXConversionDecl(x)
end

function CXXConversionDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToCXXConversionDecl(x)
    p == C_NULL && _cast_failed(CXXConversionDecl, x)
    return CXXConversionDecl(p)
end

function isCXXConstructorDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isCXXConstructorDecl(x)
end

function CXXConstructorDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToCXXConstructorDecl(x)
    p == C_NULL && _cast_failed(CXXConstructorDecl, x)
    return CXXConstructorDecl(p)
end

function isCXXDeductionGuideDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isCXXDeductionGuideDecl(x)
end

function CXXDeductionGuideDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToCXXDeductionGuideDecl(x)
    p == C_NULL && _cast_failed(CXXDeductionGuideDecl, x)
    return CXXDeductionGuideDecl(p)
end

function isVarDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isVarDecl(x)
end

function VarDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToVarDecl(x)
    p == C_NULL && _cast_failed(VarDecl, x)
    return VarDecl(p)
end

function isVarTemplateSpecializationDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isVarTemplateSpecializationDecl(x)
end

function VarTemplateSpecializationDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToVarTemplateSpecializationDecl(x)
    p == C_NULL && _cast_failed(VarTemplateSpecializationDecl, x)
    return VarTemplateSpecializationDecl(p)
end

function isVarTemplatePartialSpecializationDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isVarTemplatePartialSpecializationDecl(x)
end

function VarTemplatePartialSpecializationDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToVarTemplatePartialSpecializationDecl(x)
    p == C_NULL && _cast_failed(VarTemplatePartialSpecializationDecl, x)
    return VarTemplatePartialSpecializationDecl(p)
end

function isParmVarDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isParmVarDecl(x)
end

function ParmVarDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToParmVarDecl(x)
    p == C_NULL && _cast_failed(ParmVarDecl, x)
    return ParmVarDecl(p)
end

function isImplicitParamDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isImplicitParamDecl(x)
end

function ImplicitParamDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToImplicitParamDecl(x)
    p == C_NULL && _cast_failed(ImplicitParamDecl, x)
    return ImplicitParamDecl(p)
end

function isDecompositionDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isDecompositionDecl(x)
end

function DecompositionDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToDecompositionDecl(x)
    p == C_NULL && _cast_failed(DecompositionDecl, x)
    return DecompositionDecl(p)
end

function isNonTypeTemplateParmDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isNonTypeTemplateParmDecl(x)
end

function NonTypeTemplateParmDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToNonTypeTemplateParmDecl(x)
    p == C_NULL && _cast_failed(NonTypeTemplateParmDecl, x)
    return NonTypeTemplateParmDecl(p)
end

function isMSPropertyDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isMSPropertyDecl(x)
end

function MSPropertyDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToMSPropertyDecl(x)
    p == C_NULL && _cast_failed(MSPropertyDecl, x)
    return MSPropertyDecl(p)
end

function isFieldDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isFieldDecl(x)
end

function FieldDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToFieldDecl(x)
    p == C_NULL && _cast_failed(FieldDecl, x)
    return FieldDecl(p)
end

function isObjCIvarDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isObjCIvarDecl(x)
end

function ObjCIvarDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToObjCIvarDecl(x)
    p == C_NULL && _cast_failed(ObjCIvarDecl, x)
    return ObjCIvarDecl(p)
end

function isObjCAtDefsFieldDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isObjCAtDefsFieldDecl(x)
end

function ObjCAtDefsFieldDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToObjCAtDefsFieldDecl(x)
    p == C_NULL && _cast_failed(ObjCAtDefsFieldDecl, x)
    return ObjCAtDefsFieldDecl(p)
end

function isBindingDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isBindingDecl(x)
end

function BindingDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToBindingDecl(x)
    p == C_NULL && _cast_failed(BindingDecl, x)
    return BindingDecl(p)
end

function isUsingShadowDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isUsingShadowDecl(x)
end

function UsingShadowDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToUsingShadowDecl(x)
    p == C_NULL && _cast_failed(UsingShadowDecl, x)
    return UsingShadowDecl(p)
end

function isConstructorUsingShadowDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isConstructorUsingShadowDecl(x)
end

function ConstructorUsingShadowDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToConstructorUsingShadowDecl(x)
    p == C_NULL && _cast_failed(ConstructorUsingShadowDecl, x)
    return ConstructorUsingShadowDecl(p)
end

function isUsingPackDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isUsingPackDecl(x)
end

function UsingPackDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToUsingPackDecl(x)
    p == C_NULL && _cast_failed(UsingPackDecl, x)
    return UsingPackDecl(p)
end

function isUsingDirectiveDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isUsingDirectiveDecl(x)
end

function UsingDirectiveDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToUsingDirectiveDecl(x)
    p == C_NULL && _cast_failed(UsingDirectiveDecl, x)
    return UsingDirectiveDecl(p)
end

function isUnresolvedUsingIfExistsDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isUnresolvedUsingIfExistsDecl(x)
end

function UnresolvedUsingIfExistsDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToUnresolvedUsingIfExistsDecl(x)
    p == C_NULL && _cast_failed(UnresolvedUsingIfExistsDecl, x)
    return UnresolvedUsingIfExistsDecl(p)
end

function isTypeDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTypeDecl(x)
end

function TypeDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToTypeDecl(x)
    p == C_NULL && _cast_failed(TypeDecl, x)
    return TypeDecl(p)
end

function isTagDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTagDecl(x)
end

function TagDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToTagDecl(x)
    p == C_NULL && _cast_failed(TagDecl, x)
    return TagDecl(p)
end

function isRecordDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isRecordDecl(x)
end

function RecordDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToRecordDecl(x)
    p == C_NULL && _cast_failed(RecordDecl, x)
    return RecordDecl(p)
end

function isCXXRecordDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isCXXRecordDecl(x)
end

function CXXRecordDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToCXXRecordDecl(x)
    p == C_NULL && _cast_failed(CXXRecordDecl, x)
    return CXXRecordDecl(p)
end

function isClassTemplateSpecializationDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isClassTemplateSpecializationDecl(x)
end

function ClassTemplateSpecializationDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToClassTemplateSpecializationDecl(x)
    p == C_NULL && _cast_failed(ClassTemplateSpecializationDecl, x)
    return ClassTemplateSpecializationDecl(p)
end

function isClassTemplatePartialSpecializationDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isClassTemplatePartialSpecializationDecl(x)
end

function ClassTemplatePartialSpecializationDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToClassTemplatePartialSpecializationDecl(x)
    p == C_NULL && _cast_failed(ClassTemplatePartialSpecializationDecl, x)
    return ClassTemplatePartialSpecializationDecl(p)
end

function isEnumDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isEnumDecl(x)
end

function EnumDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToEnumDecl(x)
    p == C_NULL && _cast_failed(EnumDecl, x)
    return EnumDecl(p)
end

function isUnresolvedUsingTypenameDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isUnresolvedUsingTypenameDecl(x)
end

function UnresolvedUsingTypenameDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToUnresolvedUsingTypenameDecl(x)
    p == C_NULL && _cast_failed(UnresolvedUsingTypenameDecl, x)
    return UnresolvedUsingTypenameDecl(p)
end

function isTypedefNameDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTypedefNameDecl(x)
end

function TypedefNameDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToTypedefNameDecl(x)
    p == C_NULL && _cast_failed(TypedefNameDecl, x)
    return TypedefNameDecl(p)
end

function isTypedefDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTypedefDecl(x)
end

function TypedefDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToTypedefDecl(x)
    p == C_NULL && _cast_failed(TypedefDecl, x)
    return TypedefDecl(p)
end

function isTypeAliasDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTypeAliasDecl(x)
end

function TypeAliasDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToTypeAliasDecl(x)
    p == C_NULL && _cast_failed(TypeAliasDecl, x)
    return TypeAliasDecl(p)
end

function isObjCTypeParamDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isObjCTypeParamDecl(x)
end

function ObjCTypeParamDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToObjCTypeParamDecl(x)
    p == C_NULL && _cast_failed(ObjCTypeParamDecl, x)
    return ObjCTypeParamDecl(p)
end

function isTemplateTypeParmDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTemplateTypeParmDecl(x)
end

function TemplateTypeParmDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToTemplateTypeParmDecl(x)
    p == C_NULL && _cast_failed(TemplateTypeParmDecl, x)
    return TemplateTypeParmDecl(p)
end

function isTemplateDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTemplateDecl(x)
end

function TemplateDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToTemplateDecl(x)
    p == C_NULL && _cast_failed(TemplateDecl, x)
    return TemplateDecl(p)
end

function isTemplateTemplateParmDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTemplateTemplateParmDecl(x)
end

function TemplateTemplateParmDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToTemplateTemplateParmDecl(x)
    p == C_NULL && _cast_failed(TemplateTemplateParmDecl, x)
    return TemplateTemplateParmDecl(p)
end

function isRedeclarableTemplateDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isRedeclarableTemplateDecl(x)
end

function RedeclarableTemplateDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToRedeclarableTemplateDecl(x)
    p == C_NULL && _cast_failed(RedeclarableTemplateDecl, x)
    return RedeclarableTemplateDecl(p)
end

function isVarTemplateDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isVarTemplateDecl(x)
end

function VarTemplateDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToVarTemplateDecl(x)
    p == C_NULL && _cast_failed(VarTemplateDecl, x)
    return VarTemplateDecl(p)
end

function isTypeAliasTemplateDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isTypeAliasTemplateDecl(x)
end

function TypeAliasTemplateDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToTypeAliasTemplateDecl(x)
    p == C_NULL && _cast_failed(TypeAliasTemplateDecl, x)
    return TypeAliasTemplateDecl(p)
end

function isFunctionTemplateDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isFunctionTemplateDecl(x)
end

function FunctionTemplateDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToFunctionTemplateDecl(x)
    p == C_NULL && _cast_failed(FunctionTemplateDecl, x)
    return FunctionTemplateDecl(p)
end

function isClassTemplateDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isClassTemplateDecl(x)
end

function ClassTemplateDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToClassTemplateDecl(x)
    p == C_NULL && _cast_failed(ClassTemplateDecl, x)
    return ClassTemplateDecl(p)
end

function isConceptDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isConceptDecl(x)
end

function ConceptDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToConceptDecl(x)
    p == C_NULL && _cast_failed(ConceptDecl, x)
    return ConceptDecl(p)
end

function isBuiltinTemplateDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isBuiltinTemplateDecl(x)
end

function BuiltinTemplateDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToBuiltinTemplateDecl(x)
    p == C_NULL && _cast_failed(BuiltinTemplateDecl, x)
    return BuiltinTemplateDecl(p)
end

function isObjCPropertyDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isObjCPropertyDecl(x)
end

function ObjCPropertyDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToObjCPropertyDecl(x)
    p == C_NULL && _cast_failed(ObjCPropertyDecl, x)
    return ObjCPropertyDecl(p)
end

function isObjCCompatibleAliasDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isObjCCompatibleAliasDecl(x)
end

function ObjCCompatibleAliasDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToObjCCompatibleAliasDecl(x)
    p == C_NULL && _cast_failed(ObjCCompatibleAliasDecl, x)
    return ObjCCompatibleAliasDecl(p)
end

function isNamespaceAliasDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isNamespaceAliasDecl(x)
end

function NamespaceAliasDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToNamespaceAliasDecl(x)
    p == C_NULL && _cast_failed(NamespaceAliasDecl, x)
    return NamespaceAliasDecl(p)
end

function isLabelDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isLabelDecl(x)
end

function LabelDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToLabelDecl(x)
    p == C_NULL && _cast_failed(LabelDecl, x)
    return LabelDecl(p)
end

function isBaseUsingDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isBaseUsingDecl(x)
end

function BaseUsingDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToBaseUsingDecl(x)
    p == C_NULL && _cast_failed(BaseUsingDecl, x)
    return BaseUsingDecl(p)
end

function isUsingEnumDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isUsingEnumDecl(x)
end

function UsingEnumDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToUsingEnumDecl(x)
    p == C_NULL && _cast_failed(UsingEnumDecl, x)
    return UsingEnumDecl(p)
end

function isUsingDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isUsingDecl(x)
end

function UsingDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToUsingDecl(x)
    p == C_NULL && _cast_failed(UsingDecl, x)
    return UsingDecl(p)
end

function isLifetimeExtendedTemporaryDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isLifetimeExtendedTemporaryDecl(x)
end

function LifetimeExtendedTemporaryDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToLifetimeExtendedTemporaryDecl(x)
    p == C_NULL && _cast_failed(LifetimeExtendedTemporaryDecl, x)
    return LifetimeExtendedTemporaryDecl(p)
end

function isImportDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isImportDecl(x)
end

function ImportDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToImportDecl(x)
    p == C_NULL && _cast_failed(ImportDecl, x)
    return ImportDecl(p)
end

function isImplicitConceptSpecializationDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isImplicitConceptSpecializationDecl(x)
end

function ImplicitConceptSpecializationDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToImplicitConceptSpecializationDecl(x)
    p == C_NULL && _cast_failed(ImplicitConceptSpecializationDecl, x)
    return ImplicitConceptSpecializationDecl(p)
end

function isFriendTemplateDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isFriendTemplateDecl(x)
end

function FriendTemplateDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToFriendTemplateDecl(x)
    p == C_NULL && _cast_failed(FriendTemplateDecl, x)
    return FriendTemplateDecl(p)
end

function isFriendDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isFriendDecl(x)
end

function FriendDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToFriendDecl(x)
    p == C_NULL && _cast_failed(FriendDecl, x)
    return FriendDecl(p)
end

function isFileScopeAsmDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isFileScopeAsmDecl(x)
end

function FileScopeAsmDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToFileScopeAsmDecl(x)
    p == C_NULL && _cast_failed(FileScopeAsmDecl, x)
    return FileScopeAsmDecl(p)
end

function isEmptyDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isEmptyDecl(x)
end

function EmptyDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToEmptyDecl(x)
    p == C_NULL && _cast_failed(EmptyDecl, x)
    return EmptyDecl(p)
end

function isAccessSpecDecl(x::AbstractDecl)
    @check_ptrs x
    return clang_Decl_isAccessSpecDecl(x)
end

function AccessSpecDecl(x::AbstractDecl)
    @check_ptrs x
    p = clang_Decl_castToAccessSpecDecl(x)
    p == C_NULL && _cast_failed(AccessSpecDecl, x)
    return AccessSpecDecl(p)
end
