"""
    struct IncrementalCompilerBuilder <: AbstractIncrementalCompilerBuilder
"""
struct IncrementalCompilerBuilder <: AbstractIncrementalCompilerBuilder
    ptr::CXIncrementalCompilerBuilder
end

"""
    struct Interpreter <: AbstractInterpreter
A Clang interpreter.
"""
struct Interpreter <: AbstractInterpreter
    ptr::CXInterpreter
end

"""
    struct PartialTranslationUnit <: AbstractPartialTranslationUnit
A Clang partial translation unit.
"""
struct PartialTranslationUnit <: AbstractPartialTranslationUnit
    ptr::CXPartialTranslationUnit
end

