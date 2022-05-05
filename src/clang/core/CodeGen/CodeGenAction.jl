"""
    abstract type AbstractCodeGenAction <: AbstractFrontendAction
Supertype for `CodeGenAction`s.
"""
abstract type AbstractCodeGenAction <: AbstractFrontendAction end

Base.unsafe_convert(::Type{CXCodeGenAction}, x::T) where {T<:AbstractCodeGenAction} = x.ptr
Base.cconvert(::Type{CXCodeGenAction}, x::T) where {T<:AbstractCodeGenAction} = x

struct LLVMOnlyAction <: AbstractCodeGenAction
    ptr::CXCodeGenAction
end

"""
    abstract type AbstractWrapperFrontendAction <: AbstractFrontendAction
Supertype for `WrapperFrontendAction`s.
"""
abstract type AbstractWrapperFrontendAction <: AbstractFrontendAction end
