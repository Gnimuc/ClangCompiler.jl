"""
    struct TemplateParameterList <: AbstractTemplateParameterList
Hold a pointer to a `clang::TemplateParameterList` object.
"""
struct TemplateParameterList <: AbstractTemplateParameterList
    ptr::CXTemplateParameterList
end

"""
    struct TemplateArgumentList <: AbstractTemplateArgumentList
Hold a pointer to a `clang::TemplateArgumentList` object.
"""
struct TemplateArgumentList <: AbstractTemplateArgumentList
    ptr::CXTemplateArgumentList
end

"""
    struct TemplateDecl <: AbstractTemplateDecl
Hold a pointer to a `clang::TemplateDecl` object.
"""
struct TemplateDecl <: AbstractTemplateDecl
    ptr::CXTemplateDecl
end

"""
    struct FunctionTemplateSpecializationInfo <: AbstractFunctionTemplateSpecializationInfo
Hold a pointer to a `clang::FunctionTemplateSpecializationInfo` object.
"""
struct FunctionTemplateSpecializationInfo <: AbstractFunctionTemplateSpecializationInfo
    ptr::CXFunctionTemplateSpecializationInfo
end

"""
    struct MemberSpecializationInfo <: AbstractMemberSpecializationInfo
Hold a pointer to a `clang::MemberSpecializationInfo` object.
"""
struct MemberSpecializationInfo <: AbstractMemberSpecializationInfo
    ptr::CXMemberSpecializationInfo
end

"""
    struct DependentFunctionTemplateSpecializationInfo <: AbstractDependentFunctionTemplateSpecializationInfo
Hold a pointer to a `clang::DependentFunctionTemplateSpecializationInfo` object.
"""
struct DependentFunctionTemplateSpecializationInfo <: AbstractDependentFunctionTemplateSpecializationInfo
    ptr::CXDependentFunctionTemplateSpecializationInfo
end

"""
    struct RedeclarableTemplateDecl <: AbstractRedeclarableTemplateDecl
Hold a pointer to a `clang::RedeclarableTemplateDecl` object.
"""
struct RedeclarableTemplateDecl <: AbstractRedeclarableTemplateDecl
    ptr::CXRedeclarableTemplateDecl
end

"""
    struct FunctionTemplateDecl <: AbstractFunctionTemplateDecl
Hold a pointer to a `clang::FunctionTemplateDecl` object.
"""
struct FunctionTemplateDecl <: AbstractFunctionTemplateDecl
    ptr::CXFunctionTemplateDecl
end

"""
    struct TemplateTypeParmDecl <: AbstractTemplateTypeParmDecl
Hold a pointer to a `clang::TemplateTypeParmDecl` object.
"""
struct TemplateTypeParmDecl <: AbstractTemplateTypeParmDecl
    ptr::CXTemplateTypeParmDecl
end

"""
    struct NonTypeTemplateParmDecl <: AbstractNonTypeTemplateParmDecl
Hold a pointer to a `clang::NonTypeTemplateParmDecl` object.
"""
struct NonTypeTemplateParmDecl <: AbstractNonTypeTemplateParmDecl
    ptr::CXNonTypeTemplateParmDecl
end

"""
    struct TemplateTemplateParmDecl <: AbstractTemplateTemplateParmDecl
Hold a pointer to a `clang::TemplateTemplateParmDecl` object.
"""
struct TemplateTemplateParmDecl <: AbstractTemplateTemplateParmDecl
    ptr::CXTemplateTemplateParmDecl
end

"""
    struct BuiltinTemplateDecl <: AbstractBuiltinTemplateDecl
Hold a pointer to a `clang::BuiltinTemplateDecl` object.
"""
struct BuiltinTemplateDecl <: AbstractBuiltinTemplateDecl
    ptr::CXBuiltinTemplateDecl
end

"""
    struct ClassTemplateSpecializationDecl <: AbstractClassTemplateSpecializationDecl
Hold a pointer to a `clang::ClassTemplateSpecializationDecl` object.
"""
struct ClassTemplateSpecializationDecl <: AbstractClassTemplateSpecializationDecl
    ptr::CXClassTemplateSpecializationDecl
end

"""
    struct ClassTemplatePartialSpecializationDecl <: AbstractClassTemplatePartialSpecializationDecl
Hold a pointer to a `clang::ClassTemplatePartialSpecializationDecl` object.
"""
struct ClassTemplatePartialSpecializationDecl <: AbstractClassTemplatePartialSpecializationDecl
    ptr::CXClassTemplatePartialSpecializationDecl
end

"""
    struct ClassTemplateDecl <: AbstractClassTemplateDecl
Hold a pointer to a `clang::ClassTemplateDecl` object.
"""
struct ClassTemplateDecl <: AbstractClassTemplateDecl
    ptr::CXClassTemplateDecl
end

"""
    struct FriendTemplateDecl <: AbstractFriendTemplateDecl
Hold a pointer to a `clang::FriendTemplateDecl` object.
"""
struct FriendTemplateDecl <: AbstractFriendTemplateDecl
    ptr::CXFriendTemplateDecl
end

"""
    struct TypeAliasTemplateDecl <: AbstractTypeAliasTemplateDecl
Hold a pointer to a `clang::TypeAliasTemplateDecl` object.
"""
struct TypeAliasTemplateDecl <: AbstractTypeAliasTemplateDecl
    ptr::CXTypeAliasTemplateDecl
end

"""
    struct ClassScopeFunctionSpecializationDecl <: AbstractClassScopeFunctionSpecializationDecl
Hold a pointer to a `clang::ClassScopeFunctionSpecializationDecl` object.
"""
struct ClassScopeFunctionSpecializationDecl <: AbstractClassScopeFunctionSpecializationDecl
    ptr::CXClassScopeFunctionSpecializationDecl
end

"""
    struct VarTemplateSpecializationDecl <: AbstractVarTemplateSpecializationDecl
Hold a pointer to a `clang::VarTemplateSpecializationDecl` object.
"""
struct VarTemplateSpecializationDecl <: AbstractVarTemplateSpecializationDecl
    ptr::CXVarTemplateSpecializationDecl
end

"""
    struct VarTemplatePartialSpecializationDecl <: AbstractVarTemplatePartialSpecializationDecl
Hold a pointer to a `clang::VarTemplatePartialSpecializationDecl` object.
"""
struct VarTemplatePartialSpecializationDecl <: AbstractVarTemplatePartialSpecializationDecl
    ptr::CXVarTemplatePartialSpecializationDecl
end

"""
    struct VarTemplateDecl <: AbstractVarTemplateDecl
Hold a pointer to a `clang::VarTemplateDecl` object.
"""
struct VarTemplateDecl <: AbstractVarTemplateDecl
    ptr::CXVarTemplateDecl
end

"""
    struct ConceptDecl <: AbstractConceptDecl
Hold a pointer to a `clang::ConceptDecl` object.
"""
struct ConceptDecl <: AbstractConceptDecl
    ptr::CXConceptDecl
end

"""
    struct TemplateParamObjectDecl <: AbstractTemplateParamObjectDecl
Hold a pointer to a `clang::TemplateParamObjectDecl` object.
"""
struct TemplateParamObjectDecl <: AbstractTemplateParamObjectDecl
    ptr::CXTemplateParamObjectDecl
end

"""
    struct ImplicitConceptSpecializationDecl <: AbstractImplicitConceptSpecializationDecl
Hold a pointer to a `clang::ImplicitConceptSpecializationDecl` object.
"""
struct ImplicitConceptSpecializationDecl <: AbstractImplicitConceptSpecializationDecl
    ptr::CXImplicitConceptSpecializationDecl
end

