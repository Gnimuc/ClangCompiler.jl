abstract type AbstractOptTable end

"""
    struct OptTable <: AbstractOptTable
Hold a pointer to an `llvm::opt::OptTable` object.

The driver's table is a function-local singleton with static storage duration, so an
`OptTable` obtained from [`getDriverOptTable`](@ref) is borrowed and never disposed.
"""
struct OptTable <: AbstractOptTable
    ptr::CXOptTable
end

abstract type AbstractOption end

"""
    struct Option <: AbstractOption
Hold a pointer to an owned `llvm::opt::Option` value.

`llvm::opt::Option` is a two-pointer value class, so the handle is a heap-boxed copy and is
caller-owned: release it with `dispose`.
"""
struct Option <: AbstractOption
    ptr::CXOption
end
