"""
    struct MacroInfo <: AbstractMacroInfo
Hold a pointer to a `clang::MacroInfo` object.
"""
struct MacroInfo <: AbstractMacroInfo
    ptr::CXMacroInfo
end

Base.unsafe_convert(::Type{CXMacroInfo}, x::MacroInfo) = x.ptr
Base.cconvert(::Type{CXMacroInfo}, x::MacroInfo) = x
