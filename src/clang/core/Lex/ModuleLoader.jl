abstract type AbstractModuleLoader end

"""
    struct ModuleLoader <: AbstractModuleLoader
Hold a pointer to a `clang::ModuleLoader` object.
"""
struct ModuleLoader <: AbstractModuleLoader
    ptr::CXModuleLoader
end

"""
    abstract type AbstractTrivialModuleLoader <: AbstractModuleLoader
Supertype for `clang::TrivialModuleLoader`s.
"""
abstract type AbstractTrivialModuleLoader <: AbstractModuleLoader end

"""
    struct TrivialModuleLoader <: AbstractTrivialModuleLoader
Hold a pointer to a `clang::TrivialModuleLoader` object.

A separate carrier from `ModuleLoader` because only this one is owned: the loader a
preprocessor or a Sema hands back is borrowed, and `dispose` is defined here alone so that
it cannot reach one.
"""
struct TrivialModuleLoader <: AbstractTrivialModuleLoader
    ptr::CXModuleLoader
end
