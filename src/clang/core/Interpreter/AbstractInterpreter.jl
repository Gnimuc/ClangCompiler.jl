# Abstract types for the Interpreter subsystem, front-loaded via abstract.jl.

"""
    abstract type AbstractIncrementalCompilerBuilder <: Any
Supertype for `clang::IncrementalCompilerBuilder`s.
"""
abstract type AbstractIncrementalCompilerBuilder end

"""
    abstract type AbstractInterpreter <: Any
Supertype for `clang::Interpreter`s.
"""
abstract type AbstractInterpreter end

"""
    abstract type AbstractPartialTranslationUnit <: Any
Supertype for `clang::PartialTranslationUnit`s.
"""
abstract type AbstractPartialTranslationUnit end

"""
    abstract type AbstractValue <: Any
Supertype for `clang::Value`s.
"""
abstract type AbstractValue end
