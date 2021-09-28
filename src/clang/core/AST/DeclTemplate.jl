"""
    struct TemplateParameterList <: Any
Hold a pointer to a `clang::TemplateParameterList` object.
"""
struct TemplateParameterList
    ptr::CXTemplateParameterList
end

Base.unsafe_convert(::Type{CXTemplateParameterList}, x::TemplateParameterList) = x.ptr
Base.cconvert(::Type{CXTemplateParameterList}, x::TemplateParameterList) = x

"""
    struct TemplateArgumentList <: Any
Hold a pointer to a `clang::TemplateArgumentList` object.
"""
struct TemplateArgumentList
    ptr::CXTemplateArgumentList
end

Base.unsafe_convert(::Type{CXTemplateArgumentList}, x::TemplateArgumentList) = x.ptr
Base.cconvert(::Type{CXTemplateArgumentList}, x::TemplateArgumentList) = x

"""
    abstract type AbstractTemplateDecl <: AbstractNamedDecl
Supertype for `TemplateDecl`s.
"""
abstract type AbstractTemplateDecl <: AbstractNamedDecl end

"""
    struct TemplateDecl <: AbstractTemplateDecl
Hold a pointer to a `clang::TemplateDecl` object.
"""
struct TemplateDecl <: AbstractTemplateDecl
    ptr::CXTemplateDecl
end

Base.unsafe_convert(::Type{CXTemplateDecl}, x::TemplateDecl) = x.ptr
Base.cconvert(::Type{CXTemplateDecl}, x::TemplateDecl) = x

"""
    abstract type AbstractRedeclarableTemplateDecl <: AbstractTemplateDecl
Supertype for `RedeclarableTemplateDecl`s.
"""
abstract type AbstractRedeclarableTemplateDecl <: AbstractTemplateDecl end

"""
    struct RedeclarableTemplateDecl <: AbstractRedeclarableTemplateDecl
Hold a pointer to a `clang::RedeclarableTemplateDecl` object.
"""
struct RedeclarableTemplateDecl <: AbstractRedeclarableTemplateDecl
    ptr::CXRedeclarableTemplateDecl
end

Base.unsafe_convert(::Type{CXRedeclarableTemplateDecl}, x::RedeclarableTemplateDecl) = x.ptr
Base.cconvert(::Type{CXRedeclarableTemplateDecl}, x::RedeclarableTemplateDecl) = x

"""
    abstract type AbstractClassTemplateDecl <: AbstractRedeclarableTemplateDecl
Supertype for `ClassTemplateDecl`s.
"""
abstract type AbstractClassTemplateDecl <: AbstractRedeclarableTemplateDecl end

"""
    struct ClassTemplateDecl <: AbstractClassTemplateDecl
Hold a pointer to a `clang::ClassTemplateDecl` object.
"""
struct ClassTemplateDecl <: AbstractClassTemplateDecl
    ptr::CXClassTemplateDecl
end

Base.unsafe_convert(::Type{CXClassTemplateDecl}, x::ClassTemplateDecl) = x.ptr
Base.cconvert(::Type{CXClassTemplateDecl}, x::ClassTemplateDecl) = x

"""
    struct ClassTemplateSpecializationDecl <: AbstractCXXRecordDecl
Hold a pointer to a `clang::ClassTemplateSpecializationDecl` object.
"""
struct ClassTemplateSpecializationDecl <: AbstractCXXRecordDecl
    ptr::CXClassTemplateSpecializationDecl
end

Base.unsafe_convert(::Type{CXClassTemplateSpecializationDecl}, x::ClassTemplateSpecializationDecl) = x.ptr
Base.cconvert(::Type{CXClassTemplateSpecializationDecl}, x::ClassTemplateSpecializationDecl) = x
