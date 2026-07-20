# The Attr hierarchy: clang::Attr plus the category base classes from
# clang/AST/Attr.h as abstract types, and one carrier struct per concrete
# attribute stamped from the ATTR_NODES table (generated from the vendored
# AttrList.inc — see gen/attr_nodes.jl). Attribute classes are leaves in clang
# (no attribute derives from another), so each carrier subtypes its category
# abstract directly and there is no per-attribute abstract layer.

"""
    abstract type AbstractAttr <: Any
Supertype for all attribute carriers, mirroring `clang::Attr`.
"""
abstract type AbstractAttr end

"""
    abstract type AbstractTypeAttr <: AbstractAttr
Supertype for type-attribute carriers, mirroring `clang::TypeAttr`.
"""
abstract type AbstractTypeAttr <: AbstractAttr end

"""
    abstract type AbstractStmtAttr <: AbstractAttr
Supertype for statement-attribute carriers, mirroring `clang::StmtAttr`.
"""
abstract type AbstractStmtAttr <: AbstractAttr end

"""
    abstract type AbstractInheritableAttr <: AbstractAttr
Supertype for inheritable-attribute carriers, mirroring `clang::InheritableAttr`.
"""
abstract type AbstractInheritableAttr <: AbstractAttr end

"""
    abstract type AbstractDeclOrStmtAttr <: AbstractInheritableAttr
Supertype for decl-or-statement-attribute carriers, mirroring `clang::DeclOrStmtAttr`.
"""
abstract type AbstractDeclOrStmtAttr <: AbstractInheritableAttr end

"""
    abstract type AbstractInheritableParamAttr <: AbstractInheritableAttr
Supertype for inheritable-parameter-attribute carriers, mirroring `clang::InheritableParamAttr`.
"""
abstract type AbstractInheritableParamAttr <: AbstractInheritableAttr end

"""
    abstract type AbstractParameterABIAttr <: AbstractInheritableParamAttr
Supertype for parameter-ABI-attribute carriers, mirroring `clang::ParameterABIAttr`.
"""
abstract type AbstractParameterABIAttr <: AbstractInheritableParamAttr end

"""
    abstract type AbstractHLSLAnnotationAttr <: AbstractInheritableAttr
Supertype for HLSL-annotation-attribute carriers, mirroring `clang::HLSLAnnotationAttr`.
"""
abstract type AbstractHLSLAnnotationAttr <: AbstractInheritableAttr end

"""
    struct Attr <: AbstractAttr
Hold a pointer to a `clang::Attr` object.
"""
struct Attr <: AbstractAttr
    ptr::CXAttr
end

Base.unsafe_convert(::Type{CXAttr}, x::Attr) = x.ptr
Base.cconvert(::Type{CXAttr}, x::Attr) = x

# Carrier struct names append "Attr" to the bare AttrList.inc spelling
# (matching the clang class name); `category` names the attribute's C++ base
# class (DeclOrTypeAttr entries carry `:InheritableAttr` — clang defines no
# DeclOrTypeAttr class).
attr_carrier_name(name::Symbol) = Symbol(name, "Attr")
attr_category_name(category::Symbol) = category === :Attr ? :AbstractAttr :
                                       Symbol("Abstract", category)

for node in ATTR_NODES
    sym = attr_carrier_name(node.name)
    asym = attr_category_name(node.category)
    @eval begin
        """
            struct $($(QuoteNode(sym))) <: $($(QuoteNode(asym)))
        Hold a pointer to a `clang::$($(QuoteNode(sym)))` object.
        """
        struct $sym <: $asym
            ptr::CXAttr
        end
        Base.unsafe_convert(::Type{CXAttr}, x::$sym) = x.ptr
        Base.cconvert(::Type{CXAttr}, x::$sym) = x
    end
end
