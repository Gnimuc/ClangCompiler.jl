"""
    struct TemplateParameterList <: AbstractTemplateParameterList
Hold a pointer to a `clang::TemplateParameterList` object.
"""
struct TemplateParameterList <: AbstractTemplateParameterList
    ptr::CXTemplateParameterList
end

Base.unsafe_convert(::Type{CXTemplateParameterList}, x::TemplateParameterList) = x.ptr
Base.cconvert(::Type{CXTemplateParameterList}, x::TemplateParameterList) = x

"""
    struct TemplateArgumentList <: AbstractTemplateArgumentList
Hold a pointer to a `clang::TemplateArgumentList` object.
"""
struct TemplateArgumentList <: AbstractTemplateArgumentList
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
    struct FunctionTemplateSpecializationInfo <: AbstractFunctionTemplateSpecializationInfo
Hold a pointer to a `clang::FunctionTemplateSpecializationInfo` object.
"""
struct FunctionTemplateSpecializationInfo <: AbstractFunctionTemplateSpecializationInfo
    ptr::CXFunctionTemplateSpecializationInfo
end

Base.unsafe_convert(::Type{CXFunctionTemplateSpecializationInfo}, x::FunctionTemplateSpecializationInfo) = x.ptr
Base.cconvert(::Type{CXFunctionTemplateSpecializationInfo}, x::FunctionTemplateSpecializationInfo) = x

"""
    struct MemberSpecializationInfo <: AbstractMemberSpecializationInfo
Hold a pointer to a `clang::MemberSpecializationInfo` object.
"""
struct MemberSpecializationInfo <: AbstractMemberSpecializationInfo
    ptr::CXMemberSpecializationInfo
end

Base.unsafe_convert(::Type{CXMemberSpecializationInfo}, x::MemberSpecializationInfo) = x.ptr
Base.cconvert(::Type{CXMemberSpecializationInfo}, x::MemberSpecializationInfo) = x

"""
    struct DependentFunctionTemplateSpecializationInfo <: AbstractDependentFunctionTemplateSpecializationInfo
Hold a pointer to a `clang::DependentFunctionTemplateSpecializationInfo` object.
"""
struct DependentFunctionTemplateSpecializationInfo <: AbstractDependentFunctionTemplateSpecializationInfo
    ptr::CXDependentFunctionTemplateSpecializationInfo
end

function Base.unsafe_convert(::Type{CXDependentFunctionTemplateSpecializationInfo},
                             x::DependentFunctionTemplateSpecializationInfo)
    x.ptr
end
Base.cconvert(::Type{CXDependentFunctionTemplateSpecializationInfo}, x::DependentFunctionTemplateSpecializationInfo) = x

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
    struct FunctionTemplateDecl <: AbstractFunctionTemplateDecl
Hold a pointer to a `clang::FunctionTemplateDecl` object.
"""
struct FunctionTemplateDecl <: AbstractFunctionTemplateDecl
    ptr::CXFunctionTemplateDecl
end

Base.unsafe_convert(::Type{CXFunctionTemplateDecl}, x::FunctionTemplateDecl) = x.ptr
Base.cconvert(::Type{CXFunctionTemplateDecl}, x::FunctionTemplateDecl) = x

"""
    struct TemplateTypeParmDecl <: AbstractTemplateTypeParmDecl
Hold a pointer to a `clang::TemplateTypeParmDecl` object.
"""
struct TemplateTypeParmDecl <: AbstractTemplateTypeParmDecl
    ptr::CXTemplateTypeParmDecl
end

Base.unsafe_convert(::Type{CXTemplateTypeParmDecl}, x::TemplateTypeParmDecl) = x.ptr
Base.cconvert(::Type{CXTemplateTypeParmDecl}, x::TemplateTypeParmDecl) = x

"""
    struct NonTypeTemplateParmDecl <: AbstractNonTypeTemplateParmDecl
Hold a pointer to a `clang::NonTypeTemplateParmDecl` object.
"""
struct NonTypeTemplateParmDecl <: AbstractNonTypeTemplateParmDecl
    ptr::CXNonTypeTemplateParmDecl
end

Base.unsafe_convert(::Type{CXNonTypeTemplateParmDecl}, x::NonTypeTemplateParmDecl) = x.ptr
Base.cconvert(::Type{CXNonTypeTemplateParmDecl}, x::NonTypeTemplateParmDecl) = x

"""
    struct TemplateTemplateParmDecl <: AbstractTemplateTemplateParmDecl
Hold a pointer to a `clang::TemplateTemplateParmDecl` object.
"""
struct TemplateTemplateParmDecl <: AbstractTemplateTemplateParmDecl
    ptr::CXTemplateTemplateParmDecl
end

Base.unsafe_convert(::Type{CXTemplateTemplateParmDecl}, x::TemplateTemplateParmDecl) = x.ptr
Base.cconvert(::Type{CXTemplateTemplateParmDecl}, x::TemplateTemplateParmDecl) = x

"""
    struct BuiltinTemplateDecl <: AbstractBuiltinTemplateDecl
Hold a pointer to a `clang::BuiltinTemplateDecl` object.
"""
struct BuiltinTemplateDecl <: AbstractBuiltinTemplateDecl
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
    struct ClassTemplatePartialSpecializationDecl <: AbstractClassTemplatePartialSpecializationDecl
Hold a pointer to a `clang::ClassTemplatePartialSpecializationDecl` object.
"""
struct ClassTemplatePartialSpecializationDecl <: AbstractClassTemplatePartialSpecializationDecl
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
    struct FriendTemplateDecl <: AbstractFriendTemplateDecl
Hold a pointer to a `clang::FriendTemplateDecl` object.
"""
struct FriendTemplateDecl <: AbstractFriendTemplateDecl
    ptr::CXFriendTemplateDecl
end

Base.unsafe_convert(::Type{CXFriendTemplateDecl}, x::FriendTemplateDecl) = x.ptr
Base.cconvert(::Type{CXFriendTemplateDecl}, x::FriendTemplateDecl) = x

"""
    struct TypeAliasTemplateDecl <: AbstractTypeAliasTemplateDecl
Hold a pointer to a `clang::TypeAliasTemplateDecl` object.
"""
struct TypeAliasTemplateDecl <: AbstractTypeAliasTemplateDecl
    ptr::CXTypeAliasTemplateDecl
end

Base.unsafe_convert(::Type{CXTypeAliasTemplateDecl}, x::TypeAliasTemplateDecl) = x.ptr
Base.cconvert(::Type{CXTypeAliasTemplateDecl}, x::TypeAliasTemplateDecl) = x

"""
    struct ClassScopeFunctionSpecializationDecl <: AbstractClassScopeFunctionSpecializationDecl
Hold a pointer to a `clang::ClassScopeFunctionSpecializationDecl` object.
"""
struct ClassScopeFunctionSpecializationDecl <: AbstractClassScopeFunctionSpecializationDecl
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
    struct VarTemplatePartialSpecializationDecl <: AbstractVarTemplatePartialSpecializationDecl
Hold a pointer to a `clang::VarTemplatePartialSpecializationDecl` object.
"""
struct VarTemplatePartialSpecializationDecl <: AbstractVarTemplatePartialSpecializationDecl
    ptr::CXVarTemplatePartialSpecializationDecl
end

Base.unsafe_convert(::Type{CXVarTemplatePartialSpecializationDecl}, x::VarTemplatePartialSpecializationDecl) = x.ptr
Base.cconvert(::Type{CXVarTemplatePartialSpecializationDecl}, x::VarTemplatePartialSpecializationDecl) = x

"""
    struct VarTemplateDecl <: AbstractVarTemplateDecl
Hold a pointer to a `clang::VarTemplateDecl` object.
"""
struct VarTemplateDecl <: AbstractVarTemplateDecl
    ptr::CXVarTemplateDecl
end

Base.unsafe_convert(::Type{CXVarTemplateDecl}, x::VarTemplateDecl) = x.ptr
Base.cconvert(::Type{CXVarTemplateDecl}, x::VarTemplateDecl) = x

"""
    struct ConceptDecl <: AbstractConceptDecl
Hold a pointer to a `clang::ConceptDecl` object.
"""
struct ConceptDecl <: AbstractConceptDecl
    ptr::CXConceptDecl
end

Base.unsafe_convert(::Type{CXConceptDecl}, x::ConceptDecl) = x.ptr
Base.cconvert(::Type{CXConceptDecl}, x::ConceptDecl) = x

"""
    struct TemplateParamObjectDecl <: AbstractTemplateParamObjectDecl
Hold a pointer to a `clang::TemplateParamObjectDecl` object.
"""
struct TemplateParamObjectDecl <: AbstractTemplateParamObjectDecl
    ptr::CXTemplateParamObjectDecl
end

Base.unsafe_convert(::Type{CXTemplateParamObjectDecl}, x::TemplateParamObjectDecl) = x.ptr
Base.cconvert(::Type{CXTemplateParamObjectDecl}, x::TemplateParamObjectDecl) = x


"""
    struct ImplicitConceptSpecializationDecl <: AbstractImplicitConceptSpecializationDecl
Hold a pointer to a `clang::ImplicitConceptSpecializationDecl` object.
"""
struct ImplicitConceptSpecializationDecl <: AbstractImplicitConceptSpecializationDecl
    ptr::CXImplicitConceptSpecializationDecl
end

function Base.unsafe_convert(::Type{CXImplicitConceptSpecializationDecl},
                             x::ImplicitConceptSpecializationDecl)
    return x.ptr
end
Base.cconvert(::Type{CXImplicitConceptSpecializationDecl}, x::ImplicitConceptSpecializationDecl) = x
