"""
    abstract type AbstractCommit <: Any
Supertype for `Commit`s.
"""
abstract type AbstractCommit end

"""
    struct Commit <: AbstractCommit
Hold a pointer to a `clang::edit::Commit` object.
"""
struct Commit <: AbstractCommit
    ptr::CXCommit
end
