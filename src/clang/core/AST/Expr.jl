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
    struct FullExpr <: AbstractExpr
Hold a pointer to a `clang::FullExpr` object.
"""
struct FullExpr <: AbstractExpr
    ptr::CXFullExpr
end

Base.unsafe_convert(::Type{CXFullExpr}, x::FullExpr) = x.ptr
Base.cconvert(::Type{CXFullExpr}, x::FullExpr) = x

"""
    struct ConstantExpr <: AbstractExpr
Hold a pointer to a `clang::ConstantExpr` object.
"""
struct ConstantExpr <: AbstractExpr
    ptr::CXConstantExpr
end

Base.unsafe_convert(::Type{CXConstantExpr}, x::ConstantExpr) = x.ptr
Base.cconvert(::Type{CXConstantExpr}, x::ConstantExpr) = x

"""
    struct OpaqueValueExpr <: AbstractExpr
Hold a pointer to a `clang::OpaqueValueExpr` object.
"""
struct OpaqueValueExpr <: AbstractExpr
    ptr::CXOpaqueValueExpr
end

Base.unsafe_convert(::Type{CXOpaqueValueExpr}, x::OpaqueValueExpr) = x.ptr
Base.cconvert(::Type{CXOpaqueValueExpr}, x::OpaqueValueExpr) = x

"""
    struct DeclRefExpr <: AbstractExpr
Hold a pointer to a `clang::DeclRefExpr` object.
"""
struct DeclRefExpr <: AbstractExpr
    ptr::CXDeclRefExpr
end

Base.unsafe_convert(::Type{CXDeclRefExpr}, x::DeclRefExpr) = x.ptr
Base.cconvert(::Type{CXDeclRefExpr}, x::DeclRefExpr) = x

"""
    struct IntegerLiteral <: AbstractExpr
Hold a pointer to a `clang::IntegerLiteral` object.
"""
struct IntegerLiteral <: AbstractExpr
    ptr::CXIntegerLiteral
end

Base.unsafe_convert(::Type{CXIntegerLiteral}, x::IntegerLiteral) = x.ptr
Base.cconvert(::Type{CXIntegerLiteral}, x::IntegerLiteral) = x

"""
    struct FixedPointLiteral <: AbstractExpr
Hold a pointer to a `clang::FixedPointLiteral` object.
"""
struct FixedPointLiteral <: AbstractExpr
    ptr::CXFixedPointLiteral
end

Base.unsafe_convert(::Type{CXFixedPointLiteral}, x::FixedPointLiteral) = x.ptr
Base.cconvert(::Type{CXFixedPointLiteral}, x::FixedPointLiteral) = x

"""
    struct CharacterLiteral <: AbstractExpr
Hold a pointer to a `clang::CharacterLiteral` object.
"""
struct CharacterLiteral <: AbstractExpr
    ptr::CXCharacterLiteral
end

Base.unsafe_convert(::Type{CXCharacterLiteral}, x::CharacterLiteral) = x.ptr
Base.cconvert(::Type{CXCharacterLiteral}, x::CharacterLiteral) = x

"""
    struct FloatingLiteral <: AbstractExpr
Hold a pointer to a `clang::FloatingLiteral` object.
"""
struct FloatingLiteral <: AbstractExpr
    ptr::CXFloatingLiteral
end

Base.unsafe_convert(::Type{CXFloatingLiteral}, x::FloatingLiteral) = x.ptr
Base.cconvert(::Type{CXFloatingLiteral}, x::FloatingLiteral) = x

"""
    struct ImaginaryLiteral <: AbstractExpr
Hold a pointer to a `clang::ImaginaryLiteral` object.
"""
struct ImaginaryLiteral <: AbstractExpr
    ptr::CXImaginaryLiteral
end

Base.unsafe_convert(::Type{CXImaginaryLiteral}, x::ImaginaryLiteral) = x.ptr
Base.cconvert(::Type{CXImaginaryLiteral}, x::ImaginaryLiteral) = x

"""
    struct StringLiteral <: AbstractExpr
Hold a pointer to a `clang::StringLiteral` object.
"""
struct StringLiteral <: AbstractExpr
    ptr::CXStringLiteral
end

Base.unsafe_convert(::Type{CXStringLiteral}, x::StringLiteral) = x.ptr
Base.cconvert(::Type{CXStringLiteral}, x::StringLiteral) = x

"""
    struct PredefinedExpr <: AbstractExpr
Hold a pointer to a `clang::PredefinedExpr` object.
"""
struct PredefinedExpr <: AbstractExpr
    ptr::CXPredefinedExpr
end

Base.unsafe_convert(::Type{CXPredefinedExpr}, x::PredefinedExpr) = x.ptr
Base.cconvert(::Type{CXPredefinedExpr}, x::PredefinedExpr) = x

"""
    struct ParenExpr <: AbstractExpr
Hold a pointer to a `clang::ParenExpr` object.
"""
struct ParenExpr <: AbstractExpr
    ptr::CXParenExpr
end

Base.unsafe_convert(::Type{CXParenExpr}, x::ParenExpr) = x.ptr
Base.cconvert(::Type{CXParenExpr}, x::ParenExpr) = x

"""
    struct UnaryOperator <: AbstractExpr
Hold a pointer to a `clang::UnaryOperator` object.
"""
struct UnaryOperator <: AbstractExpr
    ptr::CXUnaryOperator
end

Base.unsafe_convert(::Type{CXUnaryOperator}, x::UnaryOperator) = x.ptr
Base.cconvert(::Type{CXUnaryOperator}, x::UnaryOperator) = x

"""
    struct UnaryExprOrTypeTraitExpr <: AbstractExpr
Hold a pointer to a `clang::UnaryExprOrTypeTraitExpr` object.
"""
struct UnaryExprOrTypeTraitExpr <: AbstractExpr
    ptr::CXUnaryExprOrTypeTraitExpr
end

Base.unsafe_convert(::Type{CXUnaryExprOrTypeTraitExpr}, x::UnaryExprOrTypeTraitExpr) = x.ptr
Base.cconvert(::Type{CXUnaryExprOrTypeTraitExpr}, x::UnaryExprOrTypeTraitExpr) = x

"""
    struct ArraySubscriptExpr <: AbstractExpr
Hold a pointer to a `clang::ArraySubscriptExpr` object.
"""
struct ArraySubscriptExpr <: AbstractExpr
    ptr::CXArraySubscriptExpr
end

Base.unsafe_convert(::Type{CXArraySubscriptExpr}, x::ArraySubscriptExpr) = x.ptr
Base.cconvert(::Type{CXArraySubscriptExpr}, x::ArraySubscriptExpr) = x

"""
    struct MatrixSubscriptExpr <: AbstractExpr
Hold a pointer to a `clang::MatrixSubscriptExpr` object.
"""
struct MatrixSubscriptExpr <: AbstractExpr
    ptr::CXMatrixSubscriptExpr
end

Base.unsafe_convert(::Type{CXMatrixSubscriptExpr}, x::MatrixSubscriptExpr) = x.ptr
Base.cconvert(::Type{CXMatrixSubscriptExpr}, x::MatrixSubscriptExpr) = x

"""
    struct CallExpr <: AbstractExpr
Hold a pointer to a `clang::CallExpr` object.
"""
struct CallExpr <: AbstractExpr
    ptr::CXCallExpr
end

Base.unsafe_convert(::Type{CXCallExpr}, x::CallExpr) = x.ptr
Base.cconvert(::Type{CXCallExpr}, x::CallExpr) = x

"""
    struct MemberExpr <: AbstractExpr
Hold a pointer to a `clang::MemberExpr` object.
"""
struct MemberExpr <: AbstractExpr
    ptr::CXMemberExpr
end

Base.unsafe_convert(::Type{CXMemberExpr}, x::MemberExpr) = x.ptr
Base.cconvert(::Type{CXMemberExpr}, x::MemberExpr) = x

"""
    struct CompoundLiteralExpr <: AbstractExpr
Hold a pointer to a `clang::CompoundLiteralExpr` object.
"""
struct CompoundLiteralExpr <: AbstractExpr
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
    struct ImplicitCastExpr <: AbstractCastExpr
Hold a pointer to a `clang::ImplicitCastExpr` object.
"""
struct ImplicitCastExpr <: AbstractCastExpr
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
    struct CompoundAssignOperator <: AbstractBinaryOperator
Hold a pointer to a `clang::CompoundAssignOperator` object.
"""
struct CompoundAssignOperator <: AbstractBinaryOperator
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
    struct BinaryConditionalOperator <: AbstractConditionalOperator
Hold a pointer to a `clang::BinaryConditionalOperator` object.
"""
struct BinaryConditionalOperator <: AbstractConditionalOperator
    ptr::CXBinaryConditionalOperator
end

Base.unsafe_convert(::Type{CXBinaryConditionalOperator}, x::BinaryConditionalOperator) = x.ptr
Base.cconvert(::Type{CXBinaryConditionalOperator}, x::BinaryConditionalOperator) = x

"""
    struct AddrLabelExpr <: AbstractExpr
Hold a pointer to a `clang::AddrLabelExpr` object.
"""
struct AddrLabelExpr <: AbstractExpr
    ptr::CXAddrLabelExpr
end

Base.unsafe_convert(::Type{CXAddrLabelExpr}, x::AddrLabelExpr) = x.ptr
Base.cconvert(::Type{CXAddrLabelExpr}, x::AddrLabelExpr) = x

"""
    struct StmtExpr <: AbstractExpr
Hold a pointer to a `clang::StmtExpr` object.
"""
struct StmtExpr <: AbstractExpr
    ptr::CXStmtExpr
end

Base.unsafe_convert(::Type{CXStmtExpr}, x::StmtExpr) = x.ptr
Base.cconvert(::Type{CXStmtExpr}, x::StmtExpr) = x

"""
    struct ShuffleVectorExpr <: AbstractExpr
Hold a pointer to a `clang::ShuffleVectorExpr` object.
"""
struct ShuffleVectorExpr <: AbstractExpr
    ptr::CXShuffleVectorExpr
end

Base.unsafe_convert(::Type{CXShuffleVectorExpr}, x::ShuffleVectorExpr) = x.ptr
Base.cconvert(::Type{CXShuffleVectorExpr}, x::ShuffleVectorExpr) = x

"""
    struct ConvertVectorExpr <: AbstractExpr
Hold a pointer to a `clang::ConvertVectorExpr` object.
"""
struct ConvertVectorExpr <: AbstractExpr
    ptr::CXConvertVectorExpr
end

Base.unsafe_convert(::Type{CXConvertVectorExpr}, x::ConvertVectorExpr) = x.ptr
Base.cconvert(::Type{CXConvertVectorExpr}, x::ConvertVectorExpr) = x

"""
    struct ChooseExpr <: AbstractExpr
Hold a pointer to a `clang::ChooseExpr` object.
"""
struct ChooseExpr <: AbstractExpr
    ptr::CXChooseExpr
end

Base.unsafe_convert(::Type{CXChooseExpr}, x::ChooseExpr) = x.ptr
Base.cconvert(::Type{CXChooseExpr}, x::ChooseExpr) = x

"""
    struct GNUNullExpr <: AbstractExpr
Hold a pointer to a `clang::GNUNullExpr` object.
"""
struct GNUNullExpr <: AbstractExpr
    ptr::CXGNUNullExpr
end

Base.unsafe_convert(::Type{CXGNUNullExpr}, x::GNUNullExpr) = x.ptr
Base.cconvert(::Type{CXGNUNullExpr}, x::GNUNullExpr) = x

"""
    struct VAArgExpr <: AbstractExpr
Hold a pointer to a `clang::VAArgExpr` object.
"""
struct VAArgExpr <: AbstractExpr
    ptr::CXVAArgExpr
end

Base.unsafe_convert(::Type{CXVAArgExpr}, x::VAArgExpr) = x.ptr
Base.cconvert(::Type{CXVAArgExpr}, x::VAArgExpr) = x

"""
    struct SourceLocExpr <: AbstractExpr
Hold a pointer to a `clang::SourceLocExpr` object.
"""
struct SourceLocExpr <: AbstractExpr
    ptr::CXSourceLocExpr
end

Base.unsafe_convert(::Type{CXSourceLocExpr}, x::SourceLocExpr) = x.ptr
Base.cconvert(::Type{CXSourceLocExpr}, x::SourceLocExpr) = x

"""
    struct InitListExpr <: AbstractExpr
Hold a pointer to a `clang::InitListExpr` object.
"""
struct InitListExpr <: AbstractExpr
    ptr::CXInitListExpr
end

Base.unsafe_convert(::Type{CXInitListExpr}, x::InitListExpr) = x.ptr
Base.cconvert(::Type{CXInitListExpr}, x::InitListExpr) = x

"""
    struct DesignatedInitExpr <: AbstractExpr
Hold a pointer to a `clang::DesignatedInitExpr` object.
"""
struct DesignatedInitExpr <: AbstractExpr
    ptr::CXDesignatedInitExpr
end

Base.unsafe_convert(::Type{CXDesignatedInitExpr}, x::DesignatedInitExpr) = x.ptr
Base.cconvert(::Type{CXDesignatedInitExpr}, x::DesignatedInitExpr) = x

"""
    struct NoInitExpr <: AbstractExpr
Hold a pointer to a `clang::NoInitExpr` object.
"""
struct NoInitExpr <: AbstractExpr
    ptr::CXNoInitExpr
end

Base.unsafe_convert(::Type{CXNoInitExpr}, x::NoInitExpr) = x.ptr
Base.cconvert(::Type{CXNoInitExpr}, x::NoInitExpr) = x

"""
    struct DesignatedInitUpdateExpr <: AbstractExpr
Hold a pointer to a `clang::DesignatedInitUpdateExpr` object.
"""
struct DesignatedInitUpdateExpr <: AbstractExpr
    ptr::CXDesignatedInitUpdateExpr
end

Base.unsafe_convert(::Type{CXDesignatedInitUpdateExpr}, x::DesignatedInitUpdateExpr) = x.ptr
Base.cconvert(::Type{CXDesignatedInitUpdateExpr}, x::DesignatedInitUpdateExpr) = x

"""
    struct ArrayInitLoopExpr <: AbstractExpr
Hold a pointer to a `clang::ArrayInitLoopExpr` object.
"""
struct ArrayInitLoopExpr <: AbstractExpr
    ptr::CXArrayInitLoopExpr
end

Base.unsafe_convert(::Type{CXArrayInitLoopExpr}, x::ArrayInitLoopExpr) = x.ptr
Base.cconvert(::Type{CXArrayInitLoopExpr}, x::ArrayInitLoopExpr) = x

"""
    struct ArrayInitIndexExpr <: AbstractExpr
Hold a pointer to a `clang::ArrayInitIndexExpr` object.
"""
struct ArrayInitIndexExpr <: AbstractExpr
    ptr::CXArrayInitIndexExpr
end

Base.unsafe_convert(::Type{CXArrayInitIndexExpr}, x::ArrayInitIndexExpr) = x.ptr
Base.cconvert(::Type{CXArrayInitIndexExpr}, x::ArrayInitIndexExpr) = x

"""
    struct ImplicitValueInitExpr <: AbstractExpr
Hold a pointer to a `clang::ImplicitValueInitExpr` object.
"""
struct ImplicitValueInitExpr <: AbstractExpr
    ptr::CXImplicitValueInitExpr
end

Base.unsafe_convert(::Type{CXImplicitValueInitExpr}, x::ImplicitValueInitExpr) = x.ptr
Base.cconvert(::Type{CXImplicitValueInitExpr}, x::ImplicitValueInitExpr) = x

"""
    struct ParenListExpr <: AbstractExpr
Hold a pointer to a `clang::ParenListExpr` object.
"""
struct ParenListExpr <: AbstractExpr
    ptr::CXParenListExpr
end

Base.unsafe_convert(::Type{CXParenListExpr}, x::ParenListExpr) = x.ptr
Base.cconvert(::Type{CXParenListExpr}, x::ParenListExpr) = x

"""
    struct GenericSelectionExpr <: AbstractExpr
Hold a pointer to a `clang::GenericSelectionExpr` object.
"""
struct GenericSelectionExpr <: AbstractExpr
    ptr::CXGenericSelectionExpr
end

Base.unsafe_convert(::Type{CXGenericSelectionExpr}, x::GenericSelectionExpr) = x.ptr
Base.cconvert(::Type{CXGenericSelectionExpr}, x::GenericSelectionExpr) = x

"""
    struct ExtVectorElementExpr <: AbstractExpr
Hold a pointer to a `clang::ExtVectorElementExpr` object.
"""
struct ExtVectorElementExpr <: AbstractExpr
    ptr::CXExtVectorElementExpr
end

Base.unsafe_convert(::Type{CXExtVectorElementExpr}, x::ExtVectorElementExpr) = x.ptr
Base.cconvert(::Type{CXExtVectorElementExpr}, x::ExtVectorElementExpr) = x

"""
    struct BlockExpr <: AbstractExpr
Hold a pointer to a `clang::BlockExpr` object.
"""
struct BlockExpr <: AbstractExpr
    ptr::CXBlockExpr
end

Base.unsafe_convert(::Type{CXBlockExpr}, x::BlockExpr) = x.ptr
Base.cconvert(::Type{CXBlockExpr}, x::BlockExpr) = x

"""
    struct AsTypeExpr <: AbstractExpr
Hold a pointer to a `clang::AsTypeExpr` object.
"""
struct AsTypeExpr <: AbstractExpr
    ptr::CXAsTypeExpr
end

Base.unsafe_convert(::Type{CXAsTypeExpr}, x::AsTypeExpr) = x.ptr
Base.cconvert(::Type{CXAsTypeExpr}, x::AsTypeExpr) = x

"""
    struct PseudoObjectExpr <: AbstractExpr
Hold a pointer to a `clang::PseudoObjectExpr` object.
"""
struct PseudoObjectExpr <: AbstractExpr
    ptr::CXPseudoObjectExpr
end

Base.unsafe_convert(::Type{CXPseudoObjectExpr}, x::PseudoObjectExpr) = x.ptr
Base.cconvert(::Type{CXPseudoObjectExpr}, x::PseudoObjectExpr) = x

"""
    struct AtomicExpr <: AbstractExpr
Hold a pointer to a `clang::AtomicExpr` object.
"""
struct AtomicExpr <: AbstractExpr
    ptr::CXAtomicExpr
end

Base.unsafe_convert(::Type{CXAtomicExpr}, x::AtomicExpr) = x.ptr
Base.cconvert(::Type{CXAtomicExpr}, x::AtomicExpr) = x

"""
    struct TypoExpr <: AbstractExpr
Hold a pointer to a `clang::TypoExpr` object.
"""
struct TypoExpr <: AbstractExpr
    ptr::CXTypoExpr
end

Base.unsafe_convert(::Type{CXTypoExpr}, x::TypoExpr) = x.ptr
Base.cconvert(::Type{CXTypoExpr}, x::TypoExpr) = x

"""
    struct RecoveryExpr <: AbstractExpr
Hold a pointer to a `clang::RecoveryExpr` object.
"""
struct RecoveryExpr <: AbstractExpr
    ptr::CXRecoveryExpr
end

Base.unsafe_convert(::Type{CXRecoveryExpr}, x::RecoveryExpr) = x.ptr
Base.cconvert(::Type{CXRecoveryExpr}, x::RecoveryExpr) = x
