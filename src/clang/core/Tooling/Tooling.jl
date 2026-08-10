"""
    abstract type AbstractClangTool <: Any
Supertype for `ClangTool`s.
"""
abstract type AbstractClangTool end

"""
    struct ClangTool <: AbstractClangTool
Hold a pointer to a `clang::tooling::ClangTool` object.
"""
struct ClangTool <: AbstractClangTool
    ptr::CXClangTool
end

"""
    abstract type AbstractToolInvocation <: Any
Supertype for `ToolInvocation`s.
"""
abstract type AbstractToolInvocation end

"""
    struct ToolInvocation <: AbstractToolInvocation
Hold a pointer to a `clang::tooling::ToolInvocation` object.
"""
struct ToolInvocation <: AbstractToolInvocation
    ptr::CXToolInvocation
end
