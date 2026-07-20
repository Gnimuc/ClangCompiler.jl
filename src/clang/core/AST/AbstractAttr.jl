# The Attr category base classes from clang/AST/Attr.h, as abstract types.
# Front-loaded via abstract.jl so the generated attribute carriers (AttrCarriers.jl)
# can subtype their category before those carriers are included.

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
