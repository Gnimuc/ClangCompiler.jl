"""
    abstract type AbstractMigratorOptions <: Any
Supertype for `clang::MigratorOptions`.
"""
abstract type AbstractMigratorOptions end

"""
    struct MigratorOptions <: AbstractMigratorOptions
Hold a pointer to a `clang::MigratorOptions` object.
"""
struct MigratorOptions <: AbstractMigratorOptions
    ptr::CXMigratorOptions
end

