"""
    struct TypeLoc <: AbstractTypeLoc
Hold a pointer to a heap-boxed `clang::TypeLoc` object.
"""
struct TypeLoc <: AbstractTypeLoc
    ptr::CXTypeLoc
end

# The payload carriers below hold the SAME kind of handle as `TypeLoc` — a
# heap-boxed `clang::TypeLoc` — because clang's TypeLoc subclasses are value
# views over one two-word object, not distinct pointees. A carrier's Julia type
# records its established TypeLoc class (faithful-carrier invariant): construct
# one only through the class-checked castTo wrappers (NULL carrier on a class
# mismatch) or `resolve`. Every non-NULL carrier is an owned box and `dispose`
# works uniformly across the family. `TypeLoc` itself predates the hierarchy
# and stays outside the abstract tree; `AnyTypeLoc` is the receiver type for
# methods `clang::TypeLoc` declares.
const AnyTypeLoc = Union{TypeLoc,AbstractTypeLoc}

"""
    struct QualifiedTypeLoc <: AbstractQualifiedTypeLoc
Hold a pointer to a `clang::QualifiedTypeLoc` object.
"""
struct QualifiedTypeLoc <: AbstractQualifiedTypeLoc
    ptr::CXQualifiedTypeLoc
end

"""
    struct TypeSpecTypeLoc <: AbstractTypeSpecTypeLoc
Hold a pointer to a `clang::TypeSpecTypeLoc` object.
"""
struct TypeSpecTypeLoc <: AbstractTypeSpecTypeLoc
    ptr::CXTypeSpecTypeLoc
end

"""
    struct BuiltinTypeLoc <: AbstractBuiltinTypeLoc
Hold a pointer to a `clang::BuiltinTypeLoc` object.
"""
struct BuiltinTypeLoc <: AbstractBuiltinTypeLoc
    ptr::CXBuiltinTypeLoc
end

"""
    struct AttributedTypeLoc <: AbstractAttributedTypeLoc
Hold a pointer to a `clang::AttributedTypeLoc` object.
"""
struct AttributedTypeLoc <: AbstractAttributedTypeLoc
    ptr::CXAttributedTypeLoc
end

"""
    struct ParenTypeLoc <: AbstractParenTypeLoc
Hold a pointer to a `clang::ParenTypeLoc` object.
"""
struct ParenTypeLoc <: AbstractParenTypeLoc
    ptr::CXParenTypeLoc
end

"""
    struct AdjustedTypeLoc <: AbstractAdjustedTypeLoc
Hold a pointer to a `clang::AdjustedTypeLoc` object.
"""
struct AdjustedTypeLoc <: AbstractAdjustedTypeLoc
    ptr::CXAdjustedTypeLoc
end

"""
    struct PointerTypeLoc <: AbstractPointerTypeLoc
Hold a pointer to a `clang::PointerTypeLoc` object.
"""
struct PointerTypeLoc <: AbstractPointerTypeLoc
    ptr::CXPointerTypeLoc
end

"""
    struct MemberPointerTypeLoc <: AbstractMemberPointerTypeLoc
Hold a pointer to a `clang::MemberPointerTypeLoc` object.
"""
struct MemberPointerTypeLoc <: AbstractMemberPointerTypeLoc
    ptr::CXMemberPointerTypeLoc
end

"""
    struct LValueReferenceTypeLoc <: AbstractLValueReferenceTypeLoc
Hold a pointer to a `clang::LValueReferenceTypeLoc` object.
"""
struct LValueReferenceTypeLoc <: AbstractLValueReferenceTypeLoc
    ptr::CXLValueReferenceTypeLoc
end

"""
    struct RValueReferenceTypeLoc <: AbstractRValueReferenceTypeLoc
Hold a pointer to a `clang::RValueReferenceTypeLoc` object.
"""
struct RValueReferenceTypeLoc <: AbstractRValueReferenceTypeLoc
    ptr::CXRValueReferenceTypeLoc
end

"""
    struct FunctionTypeLoc <: AbstractFunctionTypeLoc
Hold a pointer to a `clang::FunctionTypeLoc` object.
"""
struct FunctionTypeLoc <: AbstractFunctionTypeLoc
    ptr::CXFunctionTypeLoc
end

"""
    struct ArrayTypeLoc <: AbstractArrayTypeLoc
Hold a pointer to a `clang::ArrayTypeLoc` object.
"""
struct ArrayTypeLoc <: AbstractArrayTypeLoc
    ptr::CXArrayTypeLoc
end

"""
    struct TemplateSpecializationTypeLoc <: AbstractTemplateSpecializationTypeLoc
Hold a pointer to a `clang::TemplateSpecializationTypeLoc` object.
"""
struct TemplateSpecializationTypeLoc <: AbstractTemplateSpecializationTypeLoc
    ptr::CXTemplateSpecializationTypeLoc
end

"""
    struct ElaboratedTypeLoc <: AbstractElaboratedTypeLoc
Hold a pointer to a `clang::ElaboratedTypeLoc` object.
"""
struct ElaboratedTypeLoc <: AbstractElaboratedTypeLoc
    ptr::CXElaboratedTypeLoc
end
