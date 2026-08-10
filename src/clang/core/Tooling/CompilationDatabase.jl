"""
    abstract type AbstractCompileCommand <: Any
Supertype for `CompileCommand`s.
"""
abstract type AbstractCompileCommand end

"""
    struct CompileCommand <: AbstractCompileCommand
Hold a pointer to a `clang::tooling::CompileCommand` object.
"""
struct CompileCommand <: AbstractCompileCommand
    ptr::CXCompileCommand
end

"""
    abstract type AbstractCompileCommandList <: Any
Supertype for `CompileCommandList`s.
"""
abstract type AbstractCompileCommandList end

"""
    struct CompileCommandList <: AbstractCompileCommandList
Hold a pointer to the `std::vector<clang::tooling::CompileCommand>` a database query returned.

Clang answers `getCompileCommands`/`getAllCompileCommands` by value, so the shim boxes the
vector and hands back this handle; there is no `clang::tooling` class of that name.
"""
struct CompileCommandList <: AbstractCompileCommandList
    ptr::CXCompileCommandList
end

"""
    abstract type AbstractCompilationDatabase <: Any
Supertype for `CompilationDatabase`s.
"""
abstract type AbstractCompilationDatabase end

"""
    struct CompilationDatabase <: AbstractCompilationDatabase
Hold a pointer to a `clang::tooling::CompilationDatabase` object.
"""
struct CompilationDatabase <: AbstractCompilationDatabase
    ptr::CXCompilationDatabase
end

"""
    abstract type AbstractFixedCompilationDatabase <: AbstractCompilationDatabase
Supertype for `FixedCompilationDatabase`s.
"""
abstract type AbstractFixedCompilationDatabase <: AbstractCompilationDatabase end

"""
    struct FixedCompilationDatabase <: AbstractFixedCompilationDatabase
Hold a pointer to a `clang::tooling::FixedCompilationDatabase` object.
"""
struct FixedCompilationDatabase <: AbstractFixedCompilationDatabase
    ptr::CXFixedCompilationDatabase
end
