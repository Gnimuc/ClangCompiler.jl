"""
    struct TypeLoc
Hold a pointer to a heap-boxed `clang::TypeLoc` object.
"""
struct TypeLoc
    ptr::CXTypeLoc
end

Base.unsafe_convert(::Type{CXTypeLoc}, x::TypeLoc) = x.ptr
Base.cconvert(::Type{CXTypeLoc}, x::TypeLoc) = x
# The payload carriers below hold the SAME kind of handle as `TypeLoc` — a
# heap-boxed `clang::TypeLoc` — because clang's TypeLoc subclasses are value
# views over one two-word object, not distinct pointees. A carrier's Julia type
# records its established TypeLoc class (faithful-carrier invariant): construct
# one only through the class-checked castTo wrappers (NULL carrier on a class
# mismatch) or `resolve`. Every non-NULL carrier is an owned box and `dispose`
# works uniformly across the family. `TypeLoc` itself predates the hierarchy
# and stays outside the abstract tree; `AnyTypeLoc` is the receiver type for
# methods `clang::TypeLoc` declares.
abstract type AbstractTypeLoc end
const AnyTypeLoc = Union{TypeLoc,AbstractTypeLoc}

for sym in [:QualifiedTypeLoc,
            :TypeSpecTypeLoc,
            :BuiltinTypeLoc,
            :AttributedTypeLoc,
            :ParenTypeLoc,
            :AdjustedTypeLoc,
            :PointerTypeLoc,
            :MemberPointerTypeLoc,
            :LValueReferenceTypeLoc,
            :RValueReferenceTypeLoc,
            :FunctionTypeLoc,
            :ArrayTypeLoc,
            :TemplateSpecializationTypeLoc,
            :ElaboratedTypeLoc]
    asym = Symbol("Abstract", sym)

    @eval begin
        abstract type $asym <: AbstractTypeLoc end

        struct $sym <: $asym
            ptr::CXTypeLoc
        end

        Base.unsafe_convert(::Type{CXTypeLoc}, x::$sym) = x.ptr
        Base.cconvert(::Type{CXTypeLoc}, x::$sym) = x
    end
end
