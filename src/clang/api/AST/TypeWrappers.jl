# Generated from deps/ClangExtra/include/clang-ex/AST/TypeNodes.inc by gen/type_nodes.jl — do not edit.
# Per-class checked cast: the `<Name>Type` constructor is C++'s `cast<T>`, resting on
# clang's own `classof`, so a type node can never become a carrier naming another class.
#
# These are exact-class casts. A `TypedefType` that sugars a struct is not a
# `RecordType` and `RecordType(t)` raises on one, even though `isRecordType(t)` —
# clang's own predicate, which desugars — is true. Canonicalise first, or use one of
# the `getAs*` accessors, when the question is what a type denotes rather than which
# node it is. To test without raising: `resolve(t) isa Abstract<Name>Type`.

function AdjustedType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToAdjustedType(x)
    p == C_NULL && _cast_failed(AdjustedType, x)
    return AdjustedType(p)
end

function DecayedType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToDecayedType(x)
    p == C_NULL && _cast_failed(DecayedType, x)
    return DecayedType(p)
end

function ArrayType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToArrayType(x)
    p == C_NULL && _cast_failed(ArrayType, x)
    return ArrayType(p)
end

function ConstantArrayType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToConstantArrayType(x)
    p == C_NULL && _cast_failed(ConstantArrayType, x)
    return ConstantArrayType(p)
end

function ArrayParameterType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToArrayParameterType(x)
    p == C_NULL && _cast_failed(ArrayParameterType, x)
    return ArrayParameterType(p)
end

function DependentSizedArrayType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToDependentSizedArrayType(x)
    p == C_NULL && _cast_failed(DependentSizedArrayType, x)
    return DependentSizedArrayType(p)
end

function IncompleteArrayType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToIncompleteArrayType(x)
    p == C_NULL && _cast_failed(IncompleteArrayType, x)
    return IncompleteArrayType(p)
end

function VariableArrayType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToVariableArrayType(x)
    p == C_NULL && _cast_failed(VariableArrayType, x)
    return VariableArrayType(p)
end

function AtomicType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToAtomicType(x)
    p == C_NULL && _cast_failed(AtomicType, x)
    return AtomicType(p)
end

function AttributedType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToAttributedType(x)
    p == C_NULL && _cast_failed(AttributedType, x)
    return AttributedType(p)
end

function BitIntType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToBitIntType(x)
    p == C_NULL && _cast_failed(BitIntType, x)
    return BitIntType(p)
end

function BlockPointerType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToBlockPointerType(x)
    p == C_NULL && _cast_failed(BlockPointerType, x)
    return BlockPointerType(p)
end

function BoundsAttributedType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToBoundsAttributedType(x)
    p == C_NULL && _cast_failed(BoundsAttributedType, x)
    return BoundsAttributedType(p)
end

function CountAttributedType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToCountAttributedType(x)
    p == C_NULL && _cast_failed(CountAttributedType, x)
    return CountAttributedType(p)
end

function BuiltinType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToBuiltinType(x)
    p == C_NULL && _cast_failed(BuiltinType, x)
    return BuiltinType(CXType_(p))
end

function ComplexType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToComplexType(x)
    p == C_NULL && _cast_failed(ComplexType, x)
    return ComplexType(p)
end

function DecltypeType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToDecltypeType(x)
    p == C_NULL && _cast_failed(DecltypeType, x)
    return DecltypeType(p)
end

function DeducedType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToDeducedType(x)
    p == C_NULL && _cast_failed(DeducedType, x)
    return DeducedType(p)
end

function AutoType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToAutoType(x)
    p == C_NULL && _cast_failed(AutoType, x)
    return AutoType(p)
end

function DeducedTemplateSpecializationType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToDeducedTemplateSpecializationType(x)
    p == C_NULL && _cast_failed(DeducedTemplateSpecializationType, x)
    return DeducedTemplateSpecializationType(p)
end

function DependentAddressSpaceType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToDependentAddressSpaceType(x)
    p == C_NULL && _cast_failed(DependentAddressSpaceType, x)
    return DependentAddressSpaceType(p)
end

function DependentBitIntType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToDependentBitIntType(x)
    p == C_NULL && _cast_failed(DependentBitIntType, x)
    return DependentBitIntType(p)
end

function DependentNameType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToDependentNameType(x)
    p == C_NULL && _cast_failed(DependentNameType, x)
    return DependentNameType(p)
end

function DependentSizedExtVectorType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToDependentSizedExtVectorType(x)
    p == C_NULL && _cast_failed(DependentSizedExtVectorType, x)
    return DependentSizedExtVectorType(p)
end

function DependentTemplateSpecializationType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToDependentTemplateSpecializationType(x)
    p == C_NULL && _cast_failed(DependentTemplateSpecializationType, x)
    return DependentTemplateSpecializationType(p)
end

function DependentVectorType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToDependentVectorType(x)
    p == C_NULL && _cast_failed(DependentVectorType, x)
    return DependentVectorType(p)
end

function ElaboratedType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToElaboratedType(x)
    p == C_NULL && _cast_failed(ElaboratedType, x)
    return ElaboratedType(p)
end

function FunctionType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToFunctionType(x)
    p == C_NULL && _cast_failed(FunctionType, x)
    return FunctionType(p)
end

function FunctionNoProtoType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToFunctionNoProtoType(x)
    p == C_NULL && _cast_failed(FunctionNoProtoType, x)
    return FunctionNoProtoType(p)
end

function FunctionProtoType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToFunctionProtoType(x)
    p == C_NULL && _cast_failed(FunctionProtoType, x)
    return FunctionProtoType(p)
end

function HLSLAttributedResourceType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToHLSLAttributedResourceType(x)
    p == C_NULL && _cast_failed(HLSLAttributedResourceType, x)
    return HLSLAttributedResourceType(p)
end

function InjectedClassNameType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToInjectedClassNameType(x)
    p == C_NULL && _cast_failed(InjectedClassNameType, x)
    return InjectedClassNameType(p)
end

function MacroQualifiedType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToMacroQualifiedType(x)
    p == C_NULL && _cast_failed(MacroQualifiedType, x)
    return MacroQualifiedType(p)
end

function MatrixType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToMatrixType(x)
    p == C_NULL && _cast_failed(MatrixType, x)
    return MatrixType(p)
end

function ConstantMatrixType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToConstantMatrixType(x)
    p == C_NULL && _cast_failed(ConstantMatrixType, x)
    return ConstantMatrixType(p)
end

function DependentSizedMatrixType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToDependentSizedMatrixType(x)
    p == C_NULL && _cast_failed(DependentSizedMatrixType, x)
    return DependentSizedMatrixType(p)
end

function MemberPointerType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToMemberPointerType(x)
    p == C_NULL && _cast_failed(MemberPointerType, x)
    return MemberPointerType(p)
end

function ObjCObjectPointerType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToObjCObjectPointerType(x)
    p == C_NULL && _cast_failed(ObjCObjectPointerType, x)
    return ObjCObjectPointerType(p)
end

function ObjCObjectType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToObjCObjectType(x)
    p == C_NULL && _cast_failed(ObjCObjectType, x)
    return ObjCObjectType(p)
end

function ObjCInterfaceType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToObjCInterfaceType(x)
    p == C_NULL && _cast_failed(ObjCInterfaceType, x)
    return ObjCInterfaceType(p)
end

function ObjCTypeParamType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToObjCTypeParamType(x)
    p == C_NULL && _cast_failed(ObjCTypeParamType, x)
    return ObjCTypeParamType(p)
end

function PackExpansionType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToPackExpansionType(x)
    p == C_NULL && _cast_failed(PackExpansionType, x)
    return PackExpansionType(p)
end

function PackIndexingType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToPackIndexingType(x)
    p == C_NULL && _cast_failed(PackIndexingType, x)
    return PackIndexingType(p)
end

function ParenType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToParenType(x)
    p == C_NULL && _cast_failed(ParenType, x)
    return ParenType(p)
end

function PipeType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToPipeType(x)
    p == C_NULL && _cast_failed(PipeType, x)
    return PipeType(p)
end

function PointerType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToPointerType(x)
    p == C_NULL && _cast_failed(PointerType, x)
    return PointerType(p)
end

function ReferenceType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToReferenceType(x)
    p == C_NULL && _cast_failed(ReferenceType, x)
    return ReferenceType(p)
end

function LValueReferenceType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToLValueReferenceType(x)
    p == C_NULL && _cast_failed(LValueReferenceType, x)
    return LValueReferenceType(p)
end

function RValueReferenceType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToRValueReferenceType(x)
    p == C_NULL && _cast_failed(RValueReferenceType, x)
    return RValueReferenceType(p)
end

function SubstTemplateTypeParmPackType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToSubstTemplateTypeParmPackType(x)
    p == C_NULL && _cast_failed(SubstTemplateTypeParmPackType, x)
    return SubstTemplateTypeParmPackType(p)
end

function SubstTemplateTypeParmType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToSubstTemplateTypeParmType(x)
    p == C_NULL && _cast_failed(SubstTemplateTypeParmType, x)
    return SubstTemplateTypeParmType(p)
end

function TagType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToTagType(x)
    p == C_NULL && _cast_failed(TagType, x)
    return TagType(p)
end

function EnumType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToEnumType(x)
    p == C_NULL && _cast_failed(EnumType, x)
    return EnumType(p)
end

function RecordType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToRecordType(x)
    p == C_NULL && _cast_failed(RecordType, x)
    return RecordType(p)
end

function TemplateSpecializationType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToTemplateSpecializationType(x)
    p == C_NULL && _cast_failed(TemplateSpecializationType, x)
    return TemplateSpecializationType(p)
end

function TemplateTypeParmType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToTemplateTypeParmType(x)
    p == C_NULL && _cast_failed(TemplateTypeParmType, x)
    return TemplateTypeParmType(p)
end

function TypeOfExprType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToTypeOfExprType(x)
    p == C_NULL && _cast_failed(TypeOfExprType, x)
    return TypeOfExprType(p)
end

function TypeOfType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToTypeOfType(x)
    p == C_NULL && _cast_failed(TypeOfType, x)
    return TypeOfType(p)
end

function TypedefType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToTypedefType(x)
    p == C_NULL && _cast_failed(TypedefType, x)
    return TypedefType(p)
end

function UnaryTransformType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToUnaryTransformType(x)
    p == C_NULL && _cast_failed(UnaryTransformType, x)
    return UnaryTransformType(p)
end

function UnresolvedUsingType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToUnresolvedUsingType(x)
    p == C_NULL && _cast_failed(UnresolvedUsingType, x)
    return UnresolvedUsingType(p)
end

function UsingType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToUsingType(x)
    p == C_NULL && _cast_failed(UsingType, x)
    return UsingType(p)
end

function VectorType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToVectorType(x)
    p == C_NULL && _cast_failed(VectorType, x)
    return VectorType(p)
end

function ExtVectorType(x::AbstractType)
    @check_ptrs x
    p = clang_Type_castToExtVectorType(x)
    p == C_NULL && _cast_failed(ExtVectorType, x)
    return ExtVectorType(p)
end
