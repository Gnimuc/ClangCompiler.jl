"""
	AbstractIncrementalCompilerBuilder <: Any
Supertype for `clang::IncrementalCompilerBuilder`s.
"""
abstract type AbstractIncrementalCompilerBuilder end

"""
	struct IncrementalCompilerBuilder <: AbstractIncrementalCompilerBuilder
"""
struct IncrementalCompilerBuilder <: AbstractIncrementalCompilerBuilder
    ptr::CXIncrementalCompilerBuilder
end

Base.unsafe_convert(::Type{CXIncrementalCompilerBuilder}, x::IncrementalCompilerBuilder) = x.ptr
Base.cconvert(::Type{CXIncrementalCompilerBuilder}, x::IncrementalCompilerBuilder) = x

"""
	abstract type AbstractInterpreter <: Any
Supertype for `clang::Interpreter`s.
"""
abstract type AbstractInterpreter end

"""
	struct Interpreter <: AbstractInterpreter
A Clang interpreter.
"""
struct Interpreter <: AbstractInterpreter
    ptr::CXInterpreter
end

Base.unsafe_convert(::Type{CXInterpreter}, x::Interpreter) = x.ptr
Base.cconvert(::Type{CXInterpreter}, x::Interpreter) = x
