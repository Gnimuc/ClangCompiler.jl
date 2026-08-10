"""
    abstract type AbstractBoundNodes <: Any
Supertype for `BoundNodes`.
"""
abstract type AbstractBoundNodes end

"""
    struct BoundNodes <: AbstractBoundNodes
Hold a pointer to a `clang::ast_matchers::BoundNodes` object.

One match of a matcher expression: the map from every `bind("id")` in the expression to the
AST node that id matched.
"""
struct BoundNodes <: AbstractBoundNodes
    ptr::CXBoundNodes
end
