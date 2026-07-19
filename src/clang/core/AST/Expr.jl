"""
    struct Expr_ <: AbstractExpr
Hold a pointer to a `clang::Expr` object.
"""
struct Expr_ <: AbstractExpr
    ptr::CXExpr
end

Base.unsafe_convert(::Type{CXExpr}, x::Expr_) = x.ptr
Base.cconvert(::Type{CXExpr}, x::Expr_) = x

"""
    struct FullExpr <: AbstractFullExpr
Hold a pointer to a `clang::FullExpr` object.
"""
struct FullExpr <: AbstractFullExpr
    ptr::CXFullExpr
end

Base.unsafe_convert(::Type{CXFullExpr}, x::FullExpr) = x.ptr
Base.cconvert(::Type{CXFullExpr}, x::FullExpr) = x

"""
    struct ConstantExpr <: AbstractConstantExpr
Hold a pointer to a `clang::ConstantExpr` object.
"""
struct ConstantExpr <: AbstractConstantExpr
    ptr::CXConstantExpr
end

Base.unsafe_convert(::Type{CXConstantExpr}, x::ConstantExpr) = x.ptr
Base.cconvert(::Type{CXConstantExpr}, x::ConstantExpr) = x

"""
    struct OpaqueValueExpr <: AbstractOpaqueValueExpr
Hold a pointer to a `clang::OpaqueValueExpr` object.
"""
struct OpaqueValueExpr <: AbstractOpaqueValueExpr
    ptr::CXOpaqueValueExpr
end

Base.unsafe_convert(::Type{CXOpaqueValueExpr}, x::OpaqueValueExpr) = x.ptr
Base.cconvert(::Type{CXOpaqueValueExpr}, x::OpaqueValueExpr) = x

"""
    struct DeclRefExpr <: AbstractDeclRefExpr
Hold a pointer to a `clang::DeclRefExpr` object.
"""
struct DeclRefExpr <: AbstractDeclRefExpr
    ptr::CXDeclRefExpr
end

Base.unsafe_convert(::Type{CXDeclRefExpr}, x::DeclRefExpr) = x.ptr
Base.cconvert(::Type{CXDeclRefExpr}, x::DeclRefExpr) = x

"""
    struct IntegerLiteral <: AbstractIntegerLiteral
Hold a pointer to a `clang::IntegerLiteral` object.
"""
struct IntegerLiteral <: AbstractIntegerLiteral
    ptr::CXIntegerLiteral
end

Base.unsafe_convert(::Type{CXIntegerLiteral}, x::IntegerLiteral) = x.ptr
Base.cconvert(::Type{CXIntegerLiteral}, x::IntegerLiteral) = x

"""
    struct FixedPointLiteral <: AbstractFixedPointLiteral
Hold a pointer to a `clang::FixedPointLiteral` object.
"""
struct FixedPointLiteral <: AbstractFixedPointLiteral
    ptr::CXFixedPointLiteral
end

Base.unsafe_convert(::Type{CXFixedPointLiteral}, x::FixedPointLiteral) = x.ptr
Base.cconvert(::Type{CXFixedPointLiteral}, x::FixedPointLiteral) = x

"""
    struct CharacterLiteral <: AbstractCharacterLiteral
Hold a pointer to a `clang::CharacterLiteral` object.
"""
struct CharacterLiteral <: AbstractCharacterLiteral
    ptr::CXCharacterLiteral
end

Base.unsafe_convert(::Type{CXCharacterLiteral}, x::CharacterLiteral) = x.ptr
Base.cconvert(::Type{CXCharacterLiteral}, x::CharacterLiteral) = x

"""
    struct FloatingLiteral <: AbstractFloatingLiteral
Hold a pointer to a `clang::FloatingLiteral` object.
"""
struct FloatingLiteral <: AbstractFloatingLiteral
    ptr::CXFloatingLiteral
end

Base.unsafe_convert(::Type{CXFloatingLiteral}, x::FloatingLiteral) = x.ptr
Base.cconvert(::Type{CXFloatingLiteral}, x::FloatingLiteral) = x

"""
    struct ImaginaryLiteral <: AbstractImaginaryLiteral
Hold a pointer to a `clang::ImaginaryLiteral` object.
"""
struct ImaginaryLiteral <: AbstractImaginaryLiteral
    ptr::CXImaginaryLiteral
end

Base.unsafe_convert(::Type{CXImaginaryLiteral}, x::ImaginaryLiteral) = x.ptr
Base.cconvert(::Type{CXImaginaryLiteral}, x::ImaginaryLiteral) = x

"""
    struct StringLiteral <: AbstractStringLiteral
Hold a pointer to a `clang::StringLiteral` object.
"""
struct StringLiteral <: AbstractStringLiteral
    ptr::CXStringLiteral
end

Base.unsafe_convert(::Type{CXStringLiteral}, x::StringLiteral) = x.ptr
Base.cconvert(::Type{CXStringLiteral}, x::StringLiteral) = x

"""
    struct PredefinedExpr <: AbstractPredefinedExpr
Hold a pointer to a `clang::PredefinedExpr` object.
"""
struct PredefinedExpr <: AbstractPredefinedExpr
    ptr::CXPredefinedExpr
end

Base.unsafe_convert(::Type{CXPredefinedExpr}, x::PredefinedExpr) = x.ptr
Base.cconvert(::Type{CXPredefinedExpr}, x::PredefinedExpr) = x

"""
    struct ParenExpr <: AbstractParenExpr
Hold a pointer to a `clang::ParenExpr` object.
"""
struct ParenExpr <: AbstractParenExpr
    ptr::CXParenExpr
end

Base.unsafe_convert(::Type{CXParenExpr}, x::ParenExpr) = x.ptr
Base.cconvert(::Type{CXParenExpr}, x::ParenExpr) = x

"""
    struct UnaryOperator <: AbstractUnaryOperator
Hold a pointer to a `clang::UnaryOperator` object.
"""
struct UnaryOperator <: AbstractUnaryOperator
    ptr::CXUnaryOperator
end

Base.unsafe_convert(::Type{CXUnaryOperator}, x::UnaryOperator) = x.ptr
Base.cconvert(::Type{CXUnaryOperator}, x::UnaryOperator) = x

"""
    struct UnaryExprOrTypeTraitExpr <: AbstractUnaryExprOrTypeTraitExpr
Hold a pointer to a `clang::UnaryExprOrTypeTraitExpr` object.
"""
struct UnaryExprOrTypeTraitExpr <: AbstractUnaryExprOrTypeTraitExpr
    ptr::CXUnaryExprOrTypeTraitExpr
end

Base.unsafe_convert(::Type{CXUnaryExprOrTypeTraitExpr}, x::UnaryExprOrTypeTraitExpr) = x.ptr
Base.cconvert(::Type{CXUnaryExprOrTypeTraitExpr}, x::UnaryExprOrTypeTraitExpr) = x

"""
    struct ArraySubscriptExpr <: AbstractArraySubscriptExpr
Hold a pointer to a `clang::ArraySubscriptExpr` object.
"""
struct ArraySubscriptExpr <: AbstractArraySubscriptExpr
    ptr::CXArraySubscriptExpr
end

Base.unsafe_convert(::Type{CXArraySubscriptExpr}, x::ArraySubscriptExpr) = x.ptr
Base.cconvert(::Type{CXArraySubscriptExpr}, x::ArraySubscriptExpr) = x

"""
    struct MatrixSubscriptExpr <: AbstractMatrixSubscriptExpr
Hold a pointer to a `clang::MatrixSubscriptExpr` object.
"""
struct MatrixSubscriptExpr <: AbstractMatrixSubscriptExpr
    ptr::CXMatrixSubscriptExpr
end

Base.unsafe_convert(::Type{CXMatrixSubscriptExpr}, x::MatrixSubscriptExpr) = x.ptr
Base.cconvert(::Type{CXMatrixSubscriptExpr}, x::MatrixSubscriptExpr) = x

"""
    struct CallExpr <: AbstractCallExpr
Hold a pointer to a `clang::CallExpr` object.
"""
struct CallExpr <: AbstractCallExpr
    ptr::CXCallExpr
end

Base.unsafe_convert(::Type{CXCallExpr}, x::CallExpr) = x.ptr
Base.cconvert(::Type{CXCallExpr}, x::CallExpr) = x

"""
    struct MemberExpr <: AbstractMemberExpr
Hold a pointer to a `clang::MemberExpr` object.
"""
struct MemberExpr <: AbstractMemberExpr
    ptr::CXMemberExpr
end

Base.unsafe_convert(::Type{CXMemberExpr}, x::MemberExpr) = x.ptr
Base.cconvert(::Type{CXMemberExpr}, x::MemberExpr) = x

"""
    struct CompoundLiteralExpr <: AbstractCompoundLiteralExpr
Hold a pointer to a `clang::CompoundLiteralExpr` object.
"""
struct CompoundLiteralExpr <: AbstractCompoundLiteralExpr
    ptr::CXCompoundLiteralExpr
end

Base.unsafe_convert(::Type{CXCompoundLiteralExpr}, x::CompoundLiteralExpr) = x.ptr
Base.cconvert(::Type{CXCompoundLiteralExpr}, x::CompoundLiteralExpr) = x

"""
    struct CastExpr <: AbstractCastExpr
Hold a pointer to a `clang::CastExpr` object.
"""
struct CastExpr <: AbstractCastExpr
    ptr::CXCastExpr
end

Base.unsafe_convert(::Type{CXCastExpr}, x::CastExpr) = x.ptr
Base.cconvert(::Type{CXCastExpr}, x::CastExpr) = x

"""
    struct ImplicitCastExpr <: AbstractImplicitCastExpr
Hold a pointer to a `clang::ImplicitCastExpr` object.
"""
struct ImplicitCastExpr <: AbstractImplicitCastExpr
    ptr::CXImplicitCastExpr
end

Base.unsafe_convert(::Type{CXImplicitCastExpr}, x::ImplicitCastExpr) = x.ptr
Base.cconvert(::Type{CXImplicitCastExpr}, x::ImplicitCastExpr) = x

"""
    struct ExplicitCastExpr <: AbstractExplicitCastExpr
Hold a pointer to a `clang::ExplicitCastExpr` object.
"""
struct ExplicitCastExpr <: AbstractExplicitCastExpr
    ptr::CXExplicitCastExpr
end

Base.unsafe_convert(::Type{CXExplicitCastExpr}, x::ExplicitCastExpr) = x.ptr
Base.cconvert(::Type{CXExplicitCastExpr}, x::ExplicitCastExpr) = x

"""
    struct BinaryOperator <: AbstractBinaryOperator
Hold a pointer to a `clang::BinaryOperator` object.
"""
struct BinaryOperator <: AbstractBinaryOperator
    ptr::CXBinaryOperator
end

Base.unsafe_convert(::Type{CXBinaryOperator}, x::BinaryOperator) = x.ptr
Base.cconvert(::Type{CXBinaryOperator}, x::BinaryOperator) = x

"""
    struct CompoundAssignOperator <: AbstractCompoundAssignOperator
Hold a pointer to a `clang::CompoundAssignOperator` object.
"""
struct CompoundAssignOperator <: AbstractCompoundAssignOperator
    ptr::CXCompoundAssignOperator
end

Base.unsafe_convert(::Type{CXCompoundAssignOperator}, x::CompoundAssignOperator) = x.ptr
Base.cconvert(::Type{CXCompoundAssignOperator}, x::CompoundAssignOperator) = x

# AbstractConditionalOperator # FIXME: do we really need to wrap this?

"""
    struct ConditionalOperator <: AbstractConditionalOperator
Hold a pointer to a `clang::ConditionalOperator` object.
"""
struct ConditionalOperator <: AbstractConditionalOperator
    ptr::CXConditionalOperator
end

Base.unsafe_convert(::Type{CXConditionalOperator}, x::ConditionalOperator) = x.ptr
Base.cconvert(::Type{CXConditionalOperator}, x::ConditionalOperator) = x

"""
    struct BinaryConditionalOperator <: AbstractBinaryConditionalOperator
Hold a pointer to a `clang::BinaryConditionalOperator` object.
"""
struct BinaryConditionalOperator <: AbstractBinaryConditionalOperator
    ptr::CXBinaryConditionalOperator
end

Base.unsafe_convert(::Type{CXBinaryConditionalOperator}, x::BinaryConditionalOperator) = x.ptr
Base.cconvert(::Type{CXBinaryConditionalOperator}, x::BinaryConditionalOperator) = x

"""
    struct AddrLabelExpr <: AbstractAddrLabelExpr
Hold a pointer to a `clang::AddrLabelExpr` object.
"""
struct AddrLabelExpr <: AbstractAddrLabelExpr
    ptr::CXAddrLabelExpr
end

Base.unsafe_convert(::Type{CXAddrLabelExpr}, x::AddrLabelExpr) = x.ptr
Base.cconvert(::Type{CXAddrLabelExpr}, x::AddrLabelExpr) = x

"""
    struct StmtExpr <: AbstractStmtExpr
Hold a pointer to a `clang::StmtExpr` object.
"""
struct StmtExpr <: AbstractStmtExpr
    ptr::CXStmtExpr
end

Base.unsafe_convert(::Type{CXStmtExpr}, x::StmtExpr) = x.ptr
Base.cconvert(::Type{CXStmtExpr}, x::StmtExpr) = x

"""
    struct ShuffleVectorExpr <: AbstractShuffleVectorExpr
Hold a pointer to a `clang::ShuffleVectorExpr` object.
"""
struct ShuffleVectorExpr <: AbstractShuffleVectorExpr
    ptr::CXShuffleVectorExpr
end

Base.unsafe_convert(::Type{CXShuffleVectorExpr}, x::ShuffleVectorExpr) = x.ptr
Base.cconvert(::Type{CXShuffleVectorExpr}, x::ShuffleVectorExpr) = x

"""
    struct ConvertVectorExpr <: AbstractConvertVectorExpr
Hold a pointer to a `clang::ConvertVectorExpr` object.
"""
struct ConvertVectorExpr <: AbstractConvertVectorExpr
    ptr::CXConvertVectorExpr
end

Base.unsafe_convert(::Type{CXConvertVectorExpr}, x::ConvertVectorExpr) = x.ptr
Base.cconvert(::Type{CXConvertVectorExpr}, x::ConvertVectorExpr) = x

"""
    struct ChooseExpr <: AbstractChooseExpr
Hold a pointer to a `clang::ChooseExpr` object.
"""
struct ChooseExpr <: AbstractChooseExpr
    ptr::CXChooseExpr
end

Base.unsafe_convert(::Type{CXChooseExpr}, x::ChooseExpr) = x.ptr
Base.cconvert(::Type{CXChooseExpr}, x::ChooseExpr) = x

"""
    struct GNUNullExpr <: AbstractGNUNullExpr
Hold a pointer to a `clang::GNUNullExpr` object.
"""
struct GNUNullExpr <: AbstractGNUNullExpr
    ptr::CXGNUNullExpr
end

Base.unsafe_convert(::Type{CXGNUNullExpr}, x::GNUNullExpr) = x.ptr
Base.cconvert(::Type{CXGNUNullExpr}, x::GNUNullExpr) = x

"""
    struct VAArgExpr <: AbstractVAArgExpr
Hold a pointer to a `clang::VAArgExpr` object.
"""
struct VAArgExpr <: AbstractVAArgExpr
    ptr::CXVAArgExpr
end

Base.unsafe_convert(::Type{CXVAArgExpr}, x::VAArgExpr) = x.ptr
Base.cconvert(::Type{CXVAArgExpr}, x::VAArgExpr) = x

"""
    struct SourceLocExpr <: AbstractSourceLocExpr
Hold a pointer to a `clang::SourceLocExpr` object.
"""
struct SourceLocExpr <: AbstractSourceLocExpr
    ptr::CXSourceLocExpr
end

Base.unsafe_convert(::Type{CXSourceLocExpr}, x::SourceLocExpr) = x.ptr
Base.cconvert(::Type{CXSourceLocExpr}, x::SourceLocExpr) = x

"""
    struct InitListExpr <: AbstractInitListExpr
Hold a pointer to a `clang::InitListExpr` object.
"""
struct InitListExpr <: AbstractInitListExpr
    ptr::CXInitListExpr
end

Base.unsafe_convert(::Type{CXInitListExpr}, x::InitListExpr) = x.ptr
Base.cconvert(::Type{CXInitListExpr}, x::InitListExpr) = x

"""
    struct DesignatedInitExpr <: AbstractDesignatedInitExpr
Hold a pointer to a `clang::DesignatedInitExpr` object.
"""
struct DesignatedInitExpr <: AbstractDesignatedInitExpr
    ptr::CXDesignatedInitExpr
end

Base.unsafe_convert(::Type{CXDesignatedInitExpr}, x::DesignatedInitExpr) = x.ptr
Base.cconvert(::Type{CXDesignatedInitExpr}, x::DesignatedInitExpr) = x

"""
    struct NoInitExpr <: AbstractNoInitExpr
Hold a pointer to a `clang::NoInitExpr` object.
"""
struct NoInitExpr <: AbstractNoInitExpr
    ptr::CXNoInitExpr
end

Base.unsafe_convert(::Type{CXNoInitExpr}, x::NoInitExpr) = x.ptr
Base.cconvert(::Type{CXNoInitExpr}, x::NoInitExpr) = x

"""
    struct DesignatedInitUpdateExpr <: AbstractDesignatedInitUpdateExpr
Hold a pointer to a `clang::DesignatedInitUpdateExpr` object.
"""
struct DesignatedInitUpdateExpr <: AbstractDesignatedInitUpdateExpr
    ptr::CXDesignatedInitUpdateExpr
end

Base.unsafe_convert(::Type{CXDesignatedInitUpdateExpr}, x::DesignatedInitUpdateExpr) = x.ptr
Base.cconvert(::Type{CXDesignatedInitUpdateExpr}, x::DesignatedInitUpdateExpr) = x

"""
    struct ArrayInitLoopExpr <: AbstractArrayInitLoopExpr
Hold a pointer to a `clang::ArrayInitLoopExpr` object.
"""
struct ArrayInitLoopExpr <: AbstractArrayInitLoopExpr
    ptr::CXArrayInitLoopExpr
end

Base.unsafe_convert(::Type{CXArrayInitLoopExpr}, x::ArrayInitLoopExpr) = x.ptr
Base.cconvert(::Type{CXArrayInitLoopExpr}, x::ArrayInitLoopExpr) = x

"""
    struct ArrayInitIndexExpr <: AbstractArrayInitIndexExpr
Hold a pointer to a `clang::ArrayInitIndexExpr` object.
"""
struct ArrayInitIndexExpr <: AbstractArrayInitIndexExpr
    ptr::CXArrayInitIndexExpr
end

Base.unsafe_convert(::Type{CXArrayInitIndexExpr}, x::ArrayInitIndexExpr) = x.ptr
Base.cconvert(::Type{CXArrayInitIndexExpr}, x::ArrayInitIndexExpr) = x

"""
    struct ImplicitValueInitExpr <: AbstractImplicitValueInitExpr
Hold a pointer to a `clang::ImplicitValueInitExpr` object.
"""
struct ImplicitValueInitExpr <: AbstractImplicitValueInitExpr
    ptr::CXImplicitValueInitExpr
end

Base.unsafe_convert(::Type{CXImplicitValueInitExpr}, x::ImplicitValueInitExpr) = x.ptr
Base.cconvert(::Type{CXImplicitValueInitExpr}, x::ImplicitValueInitExpr) = x

"""
    struct ParenListExpr <: AbstractParenListExpr
Hold a pointer to a `clang::ParenListExpr` object.
"""
struct ParenListExpr <: AbstractParenListExpr
    ptr::CXParenListExpr
end

Base.unsafe_convert(::Type{CXParenListExpr}, x::ParenListExpr) = x.ptr
Base.cconvert(::Type{CXParenListExpr}, x::ParenListExpr) = x

"""
    struct GenericSelectionExpr <: AbstractGenericSelectionExpr
Hold a pointer to a `clang::GenericSelectionExpr` object.
"""
struct GenericSelectionExpr <: AbstractGenericSelectionExpr
    ptr::CXGenericSelectionExpr
end

Base.unsafe_convert(::Type{CXGenericSelectionExpr}, x::GenericSelectionExpr) = x.ptr
Base.cconvert(::Type{CXGenericSelectionExpr}, x::GenericSelectionExpr) = x

"""
    struct ExtVectorElementExpr <: AbstractExtVectorElementExpr
Hold a pointer to a `clang::ExtVectorElementExpr` object.
"""
struct ExtVectorElementExpr <: AbstractExtVectorElementExpr
    ptr::CXExtVectorElementExpr
end

Base.unsafe_convert(::Type{CXExtVectorElementExpr}, x::ExtVectorElementExpr) = x.ptr
Base.cconvert(::Type{CXExtVectorElementExpr}, x::ExtVectorElementExpr) = x

"""
    struct BlockExpr <: AbstractBlockExpr
Hold a pointer to a `clang::BlockExpr` object.
"""
struct BlockExpr <: AbstractBlockExpr
    ptr::CXBlockExpr
end

Base.unsafe_convert(::Type{CXBlockExpr}, x::BlockExpr) = x.ptr
Base.cconvert(::Type{CXBlockExpr}, x::BlockExpr) = x

"""
    struct AsTypeExpr <: AbstractAsTypeExpr
Hold a pointer to a `clang::AsTypeExpr` object.
"""
struct AsTypeExpr <: AbstractAsTypeExpr
    ptr::CXAsTypeExpr
end

Base.unsafe_convert(::Type{CXAsTypeExpr}, x::AsTypeExpr) = x.ptr
Base.cconvert(::Type{CXAsTypeExpr}, x::AsTypeExpr) = x

"""
    struct PseudoObjectExpr <: AbstractPseudoObjectExpr
Hold a pointer to a `clang::PseudoObjectExpr` object.
"""
struct PseudoObjectExpr <: AbstractPseudoObjectExpr
    ptr::CXPseudoObjectExpr
end

Base.unsafe_convert(::Type{CXPseudoObjectExpr}, x::PseudoObjectExpr) = x.ptr
Base.cconvert(::Type{CXPseudoObjectExpr}, x::PseudoObjectExpr) = x

"""
    struct AtomicExpr <: AbstractAtomicExpr
Hold a pointer to a `clang::AtomicExpr` object.
"""
struct AtomicExpr <: AbstractAtomicExpr
    ptr::CXAtomicExpr
end

Base.unsafe_convert(::Type{CXAtomicExpr}, x::AtomicExpr) = x.ptr
Base.cconvert(::Type{CXAtomicExpr}, x::AtomicExpr) = x

"""
    struct TypoExpr <: AbstractTypoExpr
Hold a pointer to a `clang::TypoExpr` object.
"""
struct TypoExpr <: AbstractTypoExpr
    ptr::CXTypoExpr
end

Base.unsafe_convert(::Type{CXTypoExpr}, x::TypoExpr) = x.ptr
Base.cconvert(::Type{CXTypoExpr}, x::TypoExpr) = x

"""
    struct RecoveryExpr <: AbstractRecoveryExpr
Hold a pointer to a `clang::RecoveryExpr` object.
"""
struct RecoveryExpr <: AbstractRecoveryExpr
    ptr::CXRecoveryExpr
end

Base.unsafe_convert(::Type{CXRecoveryExpr}, x::RecoveryExpr) = x.ptr
Base.cconvert(::Type{CXRecoveryExpr}, x::RecoveryExpr) = x
