"""
    abstract type AbstractClangCompiler <: Any
Supertype for Clang compilers.
"""
abstract type AbstractClangCompiler end

"""
    abstract type AbstractCxxInterpreter <: AbstractClangCompiler
Supertype for C/C++ interpreters.
"""
abstract type AbstractCxxInterpreter <: AbstractClangCompiler end

"""
    abstract type AbstractIncrementalParser <: AbstractClangCompiler
Supertype for incremental parsers.
"""
abstract type AbstractIncrementalParser <: AbstractClangCompiler end

"""
    abstract type AbstractIRGenerator <: AbstractClangCompiler
Supertype for LLVM IR generators.
"""
abstract type AbstractIRGenerator <: AbstractClangCompiler end

"""
    abstract type AbstractCxxCompiler <: AbstractClangCompiler
Supertype for C++ compilers.
"""
abstract type AbstractCxxCompiler <: AbstractClangCompiler end
