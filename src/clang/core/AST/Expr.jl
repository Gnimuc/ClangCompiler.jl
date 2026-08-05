"""
    struct Expr_ <: AbstractExpr_
Hold a pointer to a `clang::Expr` object.
"""
struct Expr_ <: AbstractExpr_
    ptr::CXExpr
end

"""
    struct FullExpr <: AbstractFullExpr
Hold a pointer to a `clang::FullExpr` object.
"""
struct FullExpr <: AbstractFullExpr
    ptr::CXFullExpr
end

"""
    struct ConstantExpr <: AbstractConstantExpr
Hold a pointer to a `clang::ConstantExpr` object.
"""
struct ConstantExpr <: AbstractConstantExpr
    ptr::CXConstantExpr
end

"""
    struct OpaqueValueExpr <: AbstractOpaqueValueExpr
Hold a pointer to a `clang::OpaqueValueExpr` object.
"""
struct OpaqueValueExpr <: AbstractOpaqueValueExpr
    ptr::CXOpaqueValueExpr
end

"""
    struct DeclRefExpr <: AbstractDeclRefExpr
Hold a pointer to a `clang::DeclRefExpr` object.
"""
struct DeclRefExpr <: AbstractDeclRefExpr
    ptr::CXDeclRefExpr
end

"""
    struct IntegerLiteral <: AbstractIntegerLiteral
Hold a pointer to a `clang::IntegerLiteral` object.
"""
struct IntegerLiteral <: AbstractIntegerLiteral
    ptr::CXIntegerLiteral
end

"""
    struct FixedPointLiteral <: AbstractFixedPointLiteral
Hold a pointer to a `clang::FixedPointLiteral` object.
"""
struct FixedPointLiteral <: AbstractFixedPointLiteral
    ptr::CXFixedPointLiteral
end

"""
    struct CharacterLiteral <: AbstractCharacterLiteral
Hold a pointer to a `clang::CharacterLiteral` object.
"""
struct CharacterLiteral <: AbstractCharacterLiteral
    ptr::CXCharacterLiteral
end

"""
    struct FloatingLiteral <: AbstractFloatingLiteral
Hold a pointer to a `clang::FloatingLiteral` object.
"""
struct FloatingLiteral <: AbstractFloatingLiteral
    ptr::CXFloatingLiteral
end

"""
    struct ImaginaryLiteral <: AbstractImaginaryLiteral
Hold a pointer to a `clang::ImaginaryLiteral` object.
"""
struct ImaginaryLiteral <: AbstractImaginaryLiteral
    ptr::CXImaginaryLiteral
end

"""
    struct StringLiteral <: AbstractStringLiteral
Hold a pointer to a `clang::StringLiteral` object.
"""
struct StringLiteral <: AbstractStringLiteral
    ptr::CXStringLiteral
end

"""
    struct PredefinedExpr <: AbstractPredefinedExpr
Hold a pointer to a `clang::PredefinedExpr` object.
"""
struct PredefinedExpr <: AbstractPredefinedExpr
    ptr::CXPredefinedExpr
end

"""
    struct ParenExpr <: AbstractParenExpr
Hold a pointer to a `clang::ParenExpr` object.
"""
struct ParenExpr <: AbstractParenExpr
    ptr::CXParenExpr
end

"""
    struct UnaryOperator <: AbstractUnaryOperator
Hold a pointer to a `clang::UnaryOperator` object.
"""
struct UnaryOperator <: AbstractUnaryOperator
    ptr::CXUnaryOperator
end

"""
    struct UnaryExprOrTypeTraitExpr <: AbstractUnaryExprOrTypeTraitExpr
Hold a pointer to a `clang::UnaryExprOrTypeTraitExpr` object.
"""
struct UnaryExprOrTypeTraitExpr <: AbstractUnaryExprOrTypeTraitExpr
    ptr::CXUnaryExprOrTypeTraitExpr
end

"""
    struct ArraySubscriptExpr <: AbstractArraySubscriptExpr
Hold a pointer to a `clang::ArraySubscriptExpr` object.
"""
struct ArraySubscriptExpr <: AbstractArraySubscriptExpr
    ptr::CXArraySubscriptExpr
end

"""
    struct MatrixSubscriptExpr <: AbstractMatrixSubscriptExpr
Hold a pointer to a `clang::MatrixSubscriptExpr` object.
"""
struct MatrixSubscriptExpr <: AbstractMatrixSubscriptExpr
    ptr::CXMatrixSubscriptExpr
end

"""
    struct CallExpr <: AbstractCallExpr
Hold a pointer to a `clang::CallExpr` object.
"""
struct CallExpr <: AbstractCallExpr
    ptr::CXCallExpr
end

"""
    struct MemberExpr <: AbstractMemberExpr
Hold a pointer to a `clang::MemberExpr` object.
"""
struct MemberExpr <: AbstractMemberExpr
    ptr::CXMemberExpr
end

"""
    struct CompoundLiteralExpr <: AbstractCompoundLiteralExpr
Hold a pointer to a `clang::CompoundLiteralExpr` object.
"""
struct CompoundLiteralExpr <: AbstractCompoundLiteralExpr
    ptr::CXCompoundLiteralExpr
end

"""
    struct CastExpr <: AbstractCastExpr
Hold a pointer to a `clang::CastExpr` object.
"""
struct CastExpr <: AbstractCastExpr
    ptr::CXCastExpr
end

"""
    struct ImplicitCastExpr <: AbstractImplicitCastExpr
Hold a pointer to a `clang::ImplicitCastExpr` object.
"""
struct ImplicitCastExpr <: AbstractImplicitCastExpr
    ptr::CXImplicitCastExpr
end

"""
    struct ExplicitCastExpr <: AbstractExplicitCastExpr
Hold a pointer to a `clang::ExplicitCastExpr` object.
"""
struct ExplicitCastExpr <: AbstractExplicitCastExpr
    ptr::CXExplicitCastExpr
end

"""
    struct BinaryOperator <: AbstractBinaryOperator
Hold a pointer to a `clang::BinaryOperator` object.
"""
struct BinaryOperator <: AbstractBinaryOperator
    ptr::CXBinaryOperator
end

"""
    struct CompoundAssignOperator <: AbstractCompoundAssignOperator
Hold a pointer to a `clang::CompoundAssignOperator` object.
"""
struct CompoundAssignOperator <: AbstractCompoundAssignOperator
    ptr::CXCompoundAssignOperator
end

"""
    struct ConditionalOperator <: AbstractConditionalOperator
Hold a pointer to a `clang::ConditionalOperator` object.
"""
struct ConditionalOperator <: AbstractConditionalOperator
    ptr::CXConditionalOperator
end

# `clang::AbstractConditionalOperator` is the base both conditional spellings share, and it is
# not mirrored: it cannot be instantiated, and `Abstract` + `ConditionalOperator` is the same
# string as its own mirror would be, so one of the two classes had to give up its natural name.
# What it declares is exposed on the two spellings below it instead (`getCond`, `getTrueExpr`,
# `getFalseExpr`, `getQuestionLoc`, `getColonLoc` in api/AST/Expr.jl).
#
# Those wrappers still call the base's C entry points, so its handle needs a route from each
# spelling. There is no single abstract type over both -- that is precisely the level that was
# dropped -- so the two methods are written out rather than keyed on a shared supertype.
Base.unsafe_convert(::Type{CXAbstractConditionalOperator}, x::AbstractConditionalOperator) = CXAbstractConditionalOperator(x.ptr)
Base.cconvert(::Type{CXAbstractConditionalOperator}, x::AbstractConditionalOperator) = x

Base.unsafe_convert(::Type{CXAbstractConditionalOperator}, x::AbstractBinaryConditionalOperator) = CXAbstractConditionalOperator(x.ptr)
Base.cconvert(::Type{CXAbstractConditionalOperator}, x::AbstractBinaryConditionalOperator) = x

"""
    struct BinaryConditionalOperator <: AbstractBinaryConditionalOperator
Hold a pointer to a `clang::BinaryConditionalOperator` object.
"""
struct BinaryConditionalOperator <: AbstractBinaryConditionalOperator
    ptr::CXBinaryConditionalOperator
end

"""
    struct AddrLabelExpr <: AbstractAddrLabelExpr
Hold a pointer to a `clang::AddrLabelExpr` object.
"""
struct AddrLabelExpr <: AbstractAddrLabelExpr
    ptr::CXAddrLabelExpr
end

"""
    struct StmtExpr <: AbstractStmtExpr
Hold a pointer to a `clang::StmtExpr` object.
"""
struct StmtExpr <: AbstractStmtExpr
    ptr::CXStmtExpr
end

"""
    struct ShuffleVectorExpr <: AbstractShuffleVectorExpr
Hold a pointer to a `clang::ShuffleVectorExpr` object.
"""
struct ShuffleVectorExpr <: AbstractShuffleVectorExpr
    ptr::CXShuffleVectorExpr
end

"""
    struct ConvertVectorExpr <: AbstractConvertVectorExpr
Hold a pointer to a `clang::ConvertVectorExpr` object.
"""
struct ConvertVectorExpr <: AbstractConvertVectorExpr
    ptr::CXConvertVectorExpr
end

"""
    struct ChooseExpr <: AbstractChooseExpr
Hold a pointer to a `clang::ChooseExpr` object.
"""
struct ChooseExpr <: AbstractChooseExpr
    ptr::CXChooseExpr
end

"""
    struct GNUNullExpr <: AbstractGNUNullExpr
Hold a pointer to a `clang::GNUNullExpr` object.
"""
struct GNUNullExpr <: AbstractGNUNullExpr
    ptr::CXGNUNullExpr
end

"""
    struct VAArgExpr <: AbstractVAArgExpr
Hold a pointer to a `clang::VAArgExpr` object.
"""
struct VAArgExpr <: AbstractVAArgExpr
    ptr::CXVAArgExpr
end

"""
    struct SourceLocExpr <: AbstractSourceLocExpr
Hold a pointer to a `clang::SourceLocExpr` object.
"""
struct SourceLocExpr <: AbstractSourceLocExpr
    ptr::CXSourceLocExpr
end

"""
    struct InitListExpr <: AbstractInitListExpr
Hold a pointer to a `clang::InitListExpr` object.
"""
struct InitListExpr <: AbstractInitListExpr
    ptr::CXInitListExpr
end

"""
    struct DesignatedInitExpr <: AbstractDesignatedInitExpr
Hold a pointer to a `clang::DesignatedInitExpr` object.
"""
struct DesignatedInitExpr <: AbstractDesignatedInitExpr
    ptr::CXDesignatedInitExpr
end

"""
    struct NoInitExpr <: AbstractNoInitExpr
Hold a pointer to a `clang::NoInitExpr` object.
"""
struct NoInitExpr <: AbstractNoInitExpr
    ptr::CXNoInitExpr
end

"""
    struct DesignatedInitUpdateExpr <: AbstractDesignatedInitUpdateExpr
Hold a pointer to a `clang::DesignatedInitUpdateExpr` object.
"""
struct DesignatedInitUpdateExpr <: AbstractDesignatedInitUpdateExpr
    ptr::CXDesignatedInitUpdateExpr
end

"""
    struct ArrayInitLoopExpr <: AbstractArrayInitLoopExpr
Hold a pointer to a `clang::ArrayInitLoopExpr` object.
"""
struct ArrayInitLoopExpr <: AbstractArrayInitLoopExpr
    ptr::CXArrayInitLoopExpr
end

"""
    struct ArrayInitIndexExpr <: AbstractArrayInitIndexExpr
Hold a pointer to a `clang::ArrayInitIndexExpr` object.
"""
struct ArrayInitIndexExpr <: AbstractArrayInitIndexExpr
    ptr::CXArrayInitIndexExpr
end

"""
    struct ImplicitValueInitExpr <: AbstractImplicitValueInitExpr
Hold a pointer to a `clang::ImplicitValueInitExpr` object.
"""
struct ImplicitValueInitExpr <: AbstractImplicitValueInitExpr
    ptr::CXImplicitValueInitExpr
end

"""
    struct ParenListExpr <: AbstractParenListExpr
Hold a pointer to a `clang::ParenListExpr` object.
"""
struct ParenListExpr <: AbstractParenListExpr
    ptr::CXParenListExpr
end

"""
    struct GenericSelectionExpr <: AbstractGenericSelectionExpr
Hold a pointer to a `clang::GenericSelectionExpr` object.
"""
struct GenericSelectionExpr <: AbstractGenericSelectionExpr
    ptr::CXGenericSelectionExpr
end

"""
    struct ExtVectorElementExpr <: AbstractExtVectorElementExpr
Hold a pointer to a `clang::ExtVectorElementExpr` object.
"""
struct ExtVectorElementExpr <: AbstractExtVectorElementExpr
    ptr::CXExtVectorElementExpr
end

"""
    struct BlockExpr <: AbstractBlockExpr
Hold a pointer to a `clang::BlockExpr` object.
"""
struct BlockExpr <: AbstractBlockExpr
    ptr::CXBlockExpr
end

"""
    struct AsTypeExpr <: AbstractAsTypeExpr
Hold a pointer to a `clang::AsTypeExpr` object.
"""
struct AsTypeExpr <: AbstractAsTypeExpr
    ptr::CXAsTypeExpr
end

"""
    struct PseudoObjectExpr <: AbstractPseudoObjectExpr
Hold a pointer to a `clang::PseudoObjectExpr` object.
"""
struct PseudoObjectExpr <: AbstractPseudoObjectExpr
    ptr::CXPseudoObjectExpr
end

"""
    struct AtomicExpr <: AbstractAtomicExpr
Hold a pointer to a `clang::AtomicExpr` object.
"""
struct AtomicExpr <: AbstractAtomicExpr
    ptr::CXAtomicExpr
end

"""
    struct TypoExpr <: AbstractTypoExpr
Hold a pointer to a `clang::TypoExpr` object.
"""
struct TypoExpr <: AbstractTypoExpr
    ptr::CXTypoExpr
end

"""
    struct RecoveryExpr <: AbstractRecoveryExpr
Hold a pointer to a `clang::RecoveryExpr` object.
"""
struct RecoveryExpr <: AbstractRecoveryExpr
    ptr::CXRecoveryExpr
end

"""
    abstract type AbstractDesignator end
Supertype for `Designator`s.
"""
abstract type AbstractDesignator end

"""
    struct Designator <: AbstractDesignator
Hold a pointer to a `clang::DesignatedInitExpr::Designator` object.
"""
struct Designator <: AbstractDesignator
    ptr::CXDesignator
end

"""
    abstract type AbstractOffsetOfNode end
Supertype for `OffsetOfNode`s.
"""
abstract type AbstractOffsetOfNode end

"""
    struct OffsetOfNode <: AbstractOffsetOfNode
Hold a pointer to a `clang::OffsetOfNode` object.
"""
struct OffsetOfNode <: AbstractOffsetOfNode
    ptr::CXOffsetOfNode
end

"""
    abstract type AbstractClassification end
Supertype for `Classification`s.
"""
abstract type AbstractClassification end

"""
    struct Classification <: AbstractClassification
Hold a pointer to an owned `clang::Expr::Classification` value. The value is a by-value pair
of small enums with no pointer form, so libclangex heap-boxes it together with the flag
recording whether modifiability was tested (see `isModifiableTested`).
"""
struct Classification <: AbstractClassification
    ptr::CXClassification
end

"""
    abstract type AbstractEvalStatus end
Supertype for `EvalStatus`es.
"""
abstract type AbstractEvalStatus end

"""
    abstract type AbstractEvalResult <: AbstractEvalStatus end
Supertype for `EvalResult`s.
"""
abstract type AbstractEvalResult <: AbstractEvalStatus end

"""
    struct EvalResult <: AbstractEvalResult
Hold a pointer to an owned `clang::Expr::EvalResult` value. The value is a by-value struct —
the folded `APValue` plus the status flags of the fold that produced it — with no pointer
form, so libclangex heap-boxes it.
"""
struct EvalResult <: AbstractEvalResult
    ptr::CXEvalResult_
end

"""
    abstract type AbstractBlockVarCopyInit end
Supertype for `BlockVarCopyInit`s.
"""
abstract type AbstractBlockVarCopyInit end

"""
    struct BlockVarCopyInit <: AbstractBlockVarCopyInit
Hold a pointer to an owned `clang::BlockVarCopyInit` value. The value is a by-value pointer
plus flag pair with no pointer form, so libclangex heap-boxes it.
"""
struct BlockVarCopyInit <: AbstractBlockVarCopyInit
    ptr::CXBlockVarCopyInit
end
