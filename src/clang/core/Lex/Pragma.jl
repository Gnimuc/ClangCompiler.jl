"""
    abstract type AbstractPragmaHandler <: Any
Supertype for `clang::PragmaHandler`s.
"""
abstract type AbstractPragmaHandler end

"""
    struct PragmaHandler <: AbstractPragmaHandler
Hold a pointer to a `clang::PragmaHandler` object.

This is the base carrier a lookup in a `PragmaNamespace` hands back; the two concrete
handlers below are what can be constructed.
"""
struct PragmaHandler <: AbstractPragmaHandler
    ptr::CXPragmaHandler
end

"""
    abstract type AbstractEmptyPragmaHandler <: AbstractPragmaHandler
Supertype for `clang::EmptyPragmaHandler`s.
"""
abstract type AbstractEmptyPragmaHandler <: AbstractPragmaHandler end

"""
    struct EmptyPragmaHandler <: AbstractEmptyPragmaHandler
Hold a pointer to a `clang::EmptyPragmaHandler` object.
"""
struct EmptyPragmaHandler <: AbstractEmptyPragmaHandler
    ptr::CXEmptyPragmaHandler
end

"""
    abstract type AbstractPragmaNamespace <: AbstractPragmaHandler
Supertype for `clang::PragmaNamespace`s.
"""
abstract type AbstractPragmaNamespace <: AbstractPragmaHandler end

"""
    struct PragmaNamespace <: AbstractPragmaNamespace
Hold a pointer to a `clang::PragmaNamespace` object.
"""
struct PragmaNamespace <: AbstractPragmaNamespace
    ptr::CXPragmaNamespace
end
