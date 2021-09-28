"""
    abstract type AbstractDecl <: Any
Supertype for `Decl`s.
"""
abstract type AbstractDecl end

"""
    struct Decl <: AbstractDecl
Hold a pointer to a `clang::Decl` object.
"""
struct Decl <: AbstractDecl
    ptr::CXDecl
end

Base.unsafe_convert(::Type{CXDecl}, x::Decl) = x.ptr
Base.cconvert(::Type{CXDecl}, x::Decl) = x

"""
    abstract type AbstractNamedDecl <: AbstractDecl
Supertype for `NamedDecl`s.
"""
abstract type AbstractNamedDecl <: AbstractDecl end

"""
    struct NamedDecl <: AbstractNamedDecl
Hold a pointer to a `clang::NamedDecl` object.
"""
struct NamedDecl <: AbstractNamedDecl
    ptr::CXNamedDecl
end

Base.unsafe_convert(::Type{CXNamedDecl}, x::NamedDecl) = x.ptr
Base.cconvert(::Type{CXNamedDecl}, x::NamedDecl) = x

"""
    abstract type AbstractValueDecl <: AbstractNamedDecl
Supertype for `ValueDecl`s.
"""
abstract type AbstractValueDecl <: AbstractNamedDecl end

"""
    struct ValueDecl <: AbstractValueDecl
Hold a pointer to a `clang::ValueDecl` object.
"""
struct ValueDecl <: AbstractValueDecl
    ptr::CXValueDecl
end

Base.unsafe_convert(::Type{CXValueDecl}, x::ValueDecl) = x.ptr
Base.cconvert(::Type{CXValueDecl}, x::ValueDecl) = x

"""
    abstract type AbstractTagDecl <: AbstractNamedDecl
Supertype for `TypeDecl`s.
"""
abstract type AbstractTypeDecl <: AbstractNamedDecl end

"""
    struct TypeDecl <: AbstractTypeDecl
Hold a pointer to a `clang::TypeDecl` object.
"""
struct TypeDecl <: AbstractTypeDecl
    ptr::CXTypeDecl
end

Base.unsafe_convert(::Type{CXTypeDecl}, x::TypeDecl) = x.ptr
Base.cconvert(::Type{CXTypeDecl}, x::TypeDecl) = x

"""
    abstract type AbstractTypedefNameDecl <: AbstractTypeDecl
Supertype for `TypedefNameDecl`s.
"""
abstract type AbstractTypedefNameDecl <: AbstractTypeDecl end

"""
    struct TypedefNameDecl <: AbstractTypedefNameDecl
Hold a pointer to a `clang::TypedefNameDecl` object.
"""
struct TypedefNameDecl <: AbstractTypedefNameDecl
    ptr::CXTypedefNameDecl
end

Base.unsafe_convert(::Type{CXTypedefNameDecl}, x::TypedefNameDecl) = x.ptr
Base.cconvert(::Type{CXTypedefNameDecl}, x::TypedefNameDecl) = x

"""
    abstract type AbstractTagDecl <: AbstractTypeDecl
Supertype for `TagDecl`s.
"""
abstract type AbstractTagDecl <: AbstractTypeDecl end

"""
    struct TagDecl <: AbstractTagDecl
Hold a pointer to a `clang::TagDecl` object.
"""
struct TagDecl <: AbstractTagDecl
    ptr::CXTagDecl
end

Base.unsafe_convert(::Type{CXTagDecl}, x::TagDecl) = x.ptr
Base.cconvert(::Type{CXTagDecl}, x::TagDecl) = x

"""
    struct EnumDecl <: AbstractTagDecl
Hold a pointer to a `clang::EnumDecl` object.
"""
struct EnumDecl <: AbstractTagDecl
    ptr::CXEnumDecl
end

Base.unsafe_convert(::Type{CXEnumDecl}, x::EnumDecl) = x.ptr
Base.cconvert(::Type{CXEnumDecl}, x::EnumDecl) = x

"""
    abstract type AbstractRecordDecl <: AbstractTagDecl
Supertype for `RecordDecl`s.
"""
abstract type AbstractRecordDecl <: AbstractTagDecl end

"""
    struct RecordDecl <: AbstractRecordDecl
Hold a pointer to a `clang::RecordDecl` object.
"""
struct RecordDecl <: AbstractRecordDecl
    ptr::CXRecordDecl
end

Base.unsafe_convert(::Type{CXRecordDecl}, x::RecordDecl) = x.ptr
Base.cconvert(::Type{CXRecordDecl}, x::RecordDecl) = x
