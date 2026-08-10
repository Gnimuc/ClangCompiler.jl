"""
    abstract type AbstractPPConditionalDirectiveRecord <: Any
Supertype for `clang::PPConditionalDirectiveRecord`s.
"""
abstract type AbstractPPConditionalDirectiveRecord end

"""
    struct PPConditionalDirectiveRecord <: AbstractPPConditionalDirectiveRecord
Hold a pointer to a `clang::PPConditionalDirectiveRecord` object.

The record is a `PPCallbacks` the preprocessor adopts, so it is borrowed: there is no
`dispose`.
"""
struct PPConditionalDirectiveRecord <: AbstractPPConditionalDirectiveRecord
    ptr::CXPPConditionalDirectiveRecord
end
