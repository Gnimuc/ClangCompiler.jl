"""
    struct Interpreter <: Any
Hold a pointer to a `clang::Interpreter` object.
"""
struct Interpreter
    ptr::CXInterpreter
end

Base.unsafe_convert(::Type{CXInterpreter}, x::Interpreter) = x.ptr
Base.cconvert(::Type{CXInterpreter}, x::Interpreter) = x
