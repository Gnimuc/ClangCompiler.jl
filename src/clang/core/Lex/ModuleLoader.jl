abstract type AbstractModuleLoader end

"""
    struct ModuleLoader <: AbstractModuleLoader
Hold a pointer to a `clang::ModuleLoader` object.
"""
struct ModuleLoader <: AbstractModuleLoader
    ptr::CXModuleLoader
end
