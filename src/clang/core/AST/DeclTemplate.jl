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
    struct TemplateDecl <: AbstractTemplateDecl
Hold a pointer to a `clang::TemplateDecl` object.
"""
struct TemplateDecl <: AbstractTemplateDecl
    ptr::CXTemplateDecl
end

Base.unsafe_convert(::Type{CXTemplateDecl}, x::TemplateDecl) = x.ptr
Base.cconvert(::Type{CXTemplateDecl}, x::TemplateDecl) = x

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
    struct FunctionTemplateDecl <: AbstractRedeclarableTemplateDecl
Hold a pointer to a `clang::FunctionTemplateDecl` object.
"""
struct FunctionTemplateDecl <: AbstractRedeclarableTemplateDecl
    ptr::CXFunctionTemplateDecl
end

Base.unsafe_convert(::Type{CXFunctionTemplateDecl}, x::FunctionTemplateDecl) = x.ptr
Base.cconvert(::Type{CXFunctionTemplateDecl}, x::FunctionTemplateDecl) = x

"""
    struct TemplateTypeParmDecl <: AbstractTypeDecl
Hold a pointer to a `clang::TemplateTypeParmDecl` object.
"""
struct TemplateTypeParmDecl <: AbstractTypeDecl
    ptr::CXTemplateTypeParmDecl
end

Base.unsafe_convert(::Type{CXTemplateTypeParmDecl}, x::TemplateTypeParmDecl) = x.ptr
Base.cconvert(::Type{CXTemplateTypeParmDecl}, x::TemplateTypeParmDecl) = x

"""
    struct NonTypeTemplateParmDecl <: AbstractDeclaratorDecl
Hold a pointer to a `clang::NonTypeTemplateParmDecl` object.
"""
struct NonTypeTemplateParmDecl <: AbstractDeclaratorDecl
    ptr::CXNonTypeTemplateParmDecl
end

Base.unsafe_convert(::Type{CXNonTypeTemplateParmDecl}, x::NonTypeTemplateParmDecl) = x.ptr
Base.cconvert(::Type{CXNonTypeTemplateParmDecl}, x::NonTypeTemplateParmDecl) = x

"""
    struct TemplateTemplateParmDecl <: AbstractTemplateDecl
Hold a pointer to a `clang::TemplateTemplateParmDecl` object.
"""
struct TemplateTemplateParmDecl <: AbstractTemplateDecl
    ptr::CXTemplateTemplateParmDecl
end

Base.unsafe_convert(::Type{CXTemplateTemplateParmDecl}, x::TemplateTemplateParmDecl) = x.ptr
Base.cconvert(::Type{CXTemplateTemplateParmDecl}, x::TemplateTemplateParmDecl) = x


"""
    struct BuiltinTemplateDecl <: AbstractTemplateDecl
Hold a pointer to a `clang::BuiltinTemplateDecl` object.
"""
struct BuiltinTemplateDecl <: AbstractTemplateDecl
    ptr::CXBuiltinTemplateDecl
end

Base.unsafe_convert(::Type{CXBuiltinTemplateDecl}, x::BuiltinTemplateDecl) = x.ptr
Base.cconvert(::Type{CXBuiltinTemplateDecl}, x::BuiltinTemplateDecl) = x

"""
    struct ClassTemplateSpecializationDecl <: AbstractClassTemplateSpecializationDecl
Hold a pointer to a `clang::ClassTemplateSpecializationDecl` object.
"""
struct ClassTemplateSpecializationDecl <: AbstractClassTemplateSpecializationDecl
    ptr::CXClassTemplateSpecializationDecl
end

Base.unsafe_convert(::Type{CXClassTemplateSpecializationDecl}, x::ClassTemplateSpecializationDecl) = x.ptr
Base.cconvert(::Type{CXClassTemplateSpecializationDecl}, x::ClassTemplateSpecializationDecl) = x

"""
    struct ClassTemplatePartialSpecializationDecl <: AbstractClassTemplateSpecializationDecl
Hold a pointer to a `clang::ClassTemplatePartialSpecializationDecl` object.
"""
struct ClassTemplatePartialSpecializationDecl <: AbstractClassTemplateSpecializationDecl
    ptr::CXClassTemplatePartialSpecializationDecl
end

Base.unsafe_convert(::Type{CXClassTemplatePartialSpecializationDecl}, x::ClassTemplatePartialSpecializationDecl) = x.ptr
Base.cconvert(::Type{CXClassTemplatePartialSpecializationDecl}, x::ClassTemplatePartialSpecializationDecl) = x

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
    struct FriendTemplateDecl <: AbstractDecl
Hold a pointer to a `clang::FriendTemplateDecl` object.
"""
struct FriendTemplateDecl <: AbstractDecl
    ptr::CXFriendTemplateDecl
end

Base.unsafe_convert(::Type{CXFriendTemplateDecl}, x::FriendTemplateDecl) = x.ptr
Base.cconvert(::Type{CXFriendTemplateDecl}, x::FriendTemplateDecl) = x

"""
    struct TypeAliasTemplateDecl <: AbstractRedeclarableTemplateDecl
Hold a pointer to a `clang::TypeAliasTemplateDecl` object.
"""
struct TypeAliasTemplateDecl <: AbstractRedeclarableTemplateDecl
    ptr::CXTypeAliasTemplateDecl
end

Base.unsafe_convert(::Type{CXTypeAliasTemplateDecl}, x::TypeAliasTemplateDecl) = x.ptr
Base.cconvert(::Type{CXTypeAliasTemplateDecl}, x::TypeAliasTemplateDecl) = x

"""
    struct ClassScopeFunctionSpecializationDecl <: AbstractDecl
Hold a pointer to a `clang::ClassScopeFunctionSpecializationDecl` object.
"""
struct ClassScopeFunctionSpecializationDecl <: AbstractDecl
    ptr::CXClassScopeFunctionSpecializationDecl
end

Base.unsafe_convert(::Type{CXClassScopeFunctionSpecializationDecl}, x::ClassScopeFunctionSpecializationDecl) = x.ptr
Base.cconvert(::Type{CXClassScopeFunctionSpecializationDecl}, x::ClassScopeFunctionSpecializationDecl) = x

"""
    struct VarTemplateSpecializationDecl <: AbstractVarTemplateSpecializationDecl
Hold a pointer to a `clang::VarTemplateSpecializationDecl` object.
"""
struct VarTemplateSpecializationDecl <: AbstractVarTemplateSpecializationDecl
    ptr::CXVarTemplateSpecializationDecl
end

Base.unsafe_convert(::Type{CXVarTemplateSpecializationDecl}, x::VarTemplateSpecializationDecl) = x.ptr
Base.cconvert(::Type{CXVarTemplateSpecializationDecl}, x::VarTemplateSpecializationDecl) = x

"""
    struct VarTemplatePartialSpecializationDecl <: AbstractVarTemplateSpecializationDecl
Hold a pointer to a `clang::VarTemplatePartialSpecializationDecl` object.
"""
struct VarTemplatePartialSpecializationDecl <: AbstractVarTemplateSpecializationDecl
    ptr::CXVarTemplatePartialSpecializationDecl
end

Base.unsafe_convert(::Type{CXVarTemplatePartialSpecializationDecl}, x::VarTemplatePartialSpecializationDecl) = x.ptr
Base.cconvert(::Type{CXVarTemplatePartialSpecializationDecl}, x::VarTemplatePartialSpecializationDecl) = x

"""
    struct VarTemplateDecl <: AbstractRedeclarableTemplateDecl
Hold a pointer to a `clang::VarTemplateDecl` object.
"""
struct VarTemplateDecl <: AbstractRedeclarableTemplateDecl
    ptr::CXVarTemplateDecl
end

Base.unsafe_convert(::Type{CXVarTemplateDecl}, x::VarTemplateDecl) = x.ptr
Base.cconvert(::Type{CXVarTemplateDecl}, x::VarTemplateDecl) = x

"""
    struct ConceptDecl <: AbstractTemplateDecl
Hold a pointer to a `clang::ConceptDecl` object.
"""
struct ConceptDecl <: AbstractTemplateDecl
    ptr::CXConceptDecl
end

Base.unsafe_convert(::Type{CXConceptDecl}, x::ConceptDecl) = x.ptr
Base.cconvert(::Type{CXConceptDecl}, x::ConceptDecl) = x

"""
    struct TemplateParamObjectDecl <: AbstractValueDecl
Hold a pointer to a `clang::TemplateParamObjectDecl` object.
"""
struct TemplateParamObjectDecl <: AbstractValueDecl
    ptr::CXTemplateParamObjectDecl
end

Base.unsafe_convert(::Type{CXTemplateParamObjectDecl}, x::TemplateParamObjectDecl) = x.ptr
Base.cconvert(::Type{CXTemplateParamObjectDecl}, x::TemplateParamObjectDecl) = x
