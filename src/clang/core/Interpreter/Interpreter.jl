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


"""
	abstract type AbstractPartialTranslationUnit <: Any
Supertype for `clang::PartialTranslationUnit`s.
"""
abstract type AbstractPartialTranslationUnit end

"""
	struct PartialTranslationUnit <: AbstractPartialTranslationUnit
A Clang partial translation unit.
"""
struct PartialTranslationUnit <: AbstractPartialTranslationUnit
    ptr::CXPartialTranslationUnit
end

Base.unsafe_convert(::Type{CXPartialTranslationUnit}, x::PartialTranslationUnit) = x.ptr
Base.cconvert(::Type{CXPartialTranslationUnit}, x::PartialTranslationUnit) = x
