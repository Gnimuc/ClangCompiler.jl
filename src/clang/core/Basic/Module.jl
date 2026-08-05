"""
    abstract type AbstractModule <: Any
Supertype for `clang::Module`s (the header-modules type, not `llvm::Module`).
"""
abstract type AbstractModule end

"""
    struct Module_ <: AbstractModule
Hold a pointer to a `clang::Module` object.
"""
struct Module_ <: AbstractModule
    ptr::CXModule_
end
