"""
    struct MangleContext <: AbstractMangleContext
Hold a pointer to a `clang::MangleContext` object.
"""
struct MangleContext <: AbstractMangleContext
    ptr::CXMangleContext
end

Base.unsafe_convert(::Type{CXMangleContext}, x::MangleContext) = x.ptr
Base.cconvert(::Type{CXMangleContext}, x::MangleContext) = x

"""
    struct ASTNameGenerator <: AbstractASTNameGenerator
Hold a pointer to a `clang::ASTNameGenerator` object.
"""
struct ASTNameGenerator <: AbstractASTNameGenerator
    ptr::CXASTNameGenerator
end

Base.unsafe_convert(::Type{CXASTNameGenerator}, x::ASTNameGenerator) = x.ptr
Base.cconvert(::Type{CXASTNameGenerator}, x::ASTNameGenerator) = x


"""
    struct ItaniumMangleContext <: AbstractItaniumMangleContext
Hold a pointer to a `clang::ItaniumMangleContext` object.
"""
struct ItaniumMangleContext <: AbstractItaniumMangleContext
    ptr::CXItaniumMangleContext
end

Base.unsafe_convert(::Type{CXItaniumMangleContext}, x::ItaniumMangleContext) = x.ptr
Base.cconvert(::Type{CXItaniumMangleContext}, x::ItaniumMangleContext) = x
