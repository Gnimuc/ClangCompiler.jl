abstract type AbstractBuiltinContext end

"""
    struct BuiltinContext <: AbstractBuiltinContext
Hold a pointer to a `clang::Builtin::Context` object.
"""
struct BuiltinContext <: AbstractBuiltinContext
    ptr::CXBuiltinContext
end

Base.unsafe_convert(::Type{CXBuiltinContext}, x::BuiltinContext) = x.ptr
Base.cconvert(::Type{CXBuiltinContext}, x::BuiltinContext) = x
