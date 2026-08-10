# Local abstract types: `clang::CallGraph` and `clang::CallGraphNode` are standalone
# classes in clang/Analysis/CallGraph.h. CallGraph's `RecursiveASTVisitor<CallGraph>`
# base is a CRTP mixin rather than a hierarchy a carrier could mirror, so neither type
# belongs in core/abstract.jl.
abstract type AbstractCallGraph end
abstract type AbstractCallGraphNode end

"""
    struct CallGraph <: AbstractCallGraph
Hold a pointer to a `clang::CallGraph` object.

The pointee is caller-owned (`CallGraph()` heap-allocates it) — call `dispose` after use.
It owns every `CallGraphNode` it hands out, so those carriers are invalidated by the
dispose, and it points into the AST it was built from, so it must not outlive the
`ASTContext`.
"""
struct CallGraph <: AbstractCallGraph
    ptr::CXCallGraph
end

"""
    struct CallGraphNode <: AbstractCallGraphNode
Hold a pointer to a `clang::CallGraphNode` object.

The pointee is owned by its parent `CallGraph` — there is no `dispose`, and
`dispose(::CallGraph)` invalidates it. The graph's virtual root is the one node whose
`getDecl` carrier is NULL.
"""
struct CallGraphNode <: AbstractCallGraphNode
    ptr::CXCallGraphNode
end
