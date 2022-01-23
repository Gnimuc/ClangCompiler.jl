"""
    struct TemplateArgument <: Any
Hold a pointer to a `clang::TemplateArgument` object.
"""
struct TemplateArgument
    ptr::CXTemplateArgument
end

Base.unsafe_convert(::Type{CXTemplateArgument}, x::TemplateArgument) = x.ptr
Base.cconvert(::Type{CXTemplateArgument}, x::TemplateArgument) = x

"""
    struct TemplateArgumentLocInfo <: Any
Hold a pointer to a `clang::TemplateArgumentLocInfo` object.
"""
struct TemplateArgumentLocInfo
    ptr::CXTemplateArgumentLocInfo
end

Base.unsafe_convert(::Type{CXTemplateArgumentLocInfo}, x::TemplateArgumentLocInfo) = x.ptr
Base.cconvert(::Type{CXTemplateArgumentLocInfo}, x::TemplateArgumentLocInfo) = x

"""
    struct TemplateArgumentLoc <: Any
Hold a pointer to a `clang::TemplateArgumentLoc` object.
"""
struct TemplateArgumentLoc
    ptr::CXTemplateArgumentLoc
end

Base.unsafe_convert(::Type{CXTemplateArgumentLoc}, x::TemplateArgumentLoc) = x.ptr
Base.cconvert(::Type{CXTemplateArgumentLoc}, x::TemplateArgumentLoc) = x

"""
    struct TemplateArgumentListInfo <: Any
Hold a pointer to a `clang::TemplateArgumentListInfo` object.
"""
struct TemplateArgumentListInfo
    ptr::CXTemplateArgumentListInfo
end

Base.unsafe_convert(::Type{CXTemplateArgumentListInfo}, x::TemplateArgumentListInfo) = x.ptr
Base.cconvert(::Type{CXTemplateArgumentListInfo}, x::TemplateArgumentListInfo) = x

"""
    struct ASTTemplateArgumentListInfo <: Any
Hold a pointer to a `clang::ASTTemplateArgumentListInfo` object.
"""
struct ASTTemplateArgumentListInfo
    ptr::CXASTTemplateArgumentListInfo
end

Base.unsafe_convert(::Type{CXASTTemplateArgumentListInfo}, x::ASTTemplateArgumentListInfo) = x.ptr
Base.cconvert(::Type{CXASTTemplateArgumentListInfo}, x::ASTTemplateArgumentListInfo) = x
