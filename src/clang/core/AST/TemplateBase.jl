"""
    struct TemplateArgument <: AbstractTemplateArgument
Hold a pointer to a `clang::TemplateArgument` object.
"""
struct TemplateArgument <: AbstractTemplateArgument
    ptr::CXTemplateArgument
end

"""
    struct TemplateArgumentLocInfo <: AbstractTemplateArgumentLocInfo
Hold a pointer to a `clang::TemplateArgumentLocInfo` object.
"""
struct TemplateArgumentLocInfo <: AbstractTemplateArgumentLocInfo
    ptr::CXTemplateArgumentLocInfo
end

"""
    struct TemplateArgumentLoc <: AbstractTemplateArgumentLoc
Hold a pointer to a `clang::TemplateArgumentLoc` object.
"""
struct TemplateArgumentLoc <: AbstractTemplateArgumentLoc
    ptr::CXTemplateArgumentLoc
end

"""
    struct TemplateArgumentListInfo <: AbstractTemplateArgumentListInfo
Hold a pointer to a `clang::TemplateArgumentListInfo` object.
"""
struct TemplateArgumentListInfo <: AbstractTemplateArgumentListInfo
    ptr::CXTemplateArgumentListInfo
end

"""
    struct ASTTemplateArgumentListInfo <: AbstractASTTemplateArgumentListInfo
Hold a pointer to a `clang::ASTTemplateArgumentListInfo` object.
"""
struct ASTTemplateArgumentListInfo <: AbstractASTTemplateArgumentListInfo
    ptr::CXASTTemplateArgumentListInfo
end
