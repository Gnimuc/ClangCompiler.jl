abstract type AbstractModuleLoader end

"""
    struct ModuleLoader <: AbstractModuleLoader
Hold a pointer to a `clang::ModuleLoader` object.
"""
struct ModuleLoader <: AbstractModuleLoader
    ptr::CXModuleLoader
end

Base.unsafe_convert(::Type{CXModuleLoader}, x::ModuleLoader) = x.ptr
Base.cconvert(::Type{CXModuleLoader}, x::ModuleLoader) = x
