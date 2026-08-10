# CallGraph — the AST-based call graph of a translation unit (clang/Analysis/CallGraph.h):
# one node per function definition clang can see, plus a virtual root with an edge to every
# externally reachable one. Build it with `CallGraph()`, feed it declarations with
# `addToCallGraph`, then walk it with `getNodes` / `getCallee`. The graph is caller-owned
# and points into the AST it was built from, so `dispose` it before the interpreter goes.

"""
    CallGraph() -> CallGraph
Return an empty call graph, holding nothing but its virtual root.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
CallGraph() = CallGraph(clang_CallGraph_create())

dispose(x::CallGraph) = clang_CallGraph_dispose(x)

"""
    addToCallGraph(x::AbstractCallGraph, decl::AbstractDecl)
Walk `decl` — recursively, template instantiations and implicit code included — and add
every function definition inside it, together with the calls its body makes. Pass the
translation-unit declaration to graph a whole translation unit. May be called repeatedly;
the graph accumulates.
"""
function addToCallGraph(x::AbstractCallGraph, decl::AbstractDecl)
    @check_ptrs x decl
    return clang_CallGraph_addToCallGraph(x, decl)
end

"""
    includeInGraph(decl::AbstractDecl) -> Bool
Return whether `decl` is a definition the call graph would give a node of its own. This is
`clang::CallGraph::includeInGraph`, a static predicate needing no graph.
"""
function includeInGraph(decl::AbstractDecl)
    @check_ptrs decl
    return clang_CallGraph_includeInGraph(decl)
end

"""
    includeCalleeInGraph(decl::AbstractDecl) -> Bool
Return whether `decl` may be the target of a callee edge — `includeInGraph` relaxed to
permit a declaration that has no definition here.
"""
function includeCalleeInGraph(decl::AbstractDecl)
    @check_ptrs decl
    return clang_CallGraph_includeCalleeInGraph(decl)
end

"""
    getNode(x::AbstractCallGraph, decl::AbstractDecl) -> CallGraphNode
Return the node standing for `decl`; the wrapped pointer is NULL when the graph has none.

Unlike [`getOrInsertNode`](@ref) this does not canonicalize `decl` first, so a
non-canonical redeclaration of a graphed function misses.
"""
function getNode(x::AbstractCallGraph, decl::AbstractDecl)
    @check_ptrs x decl
    return CallGraphNode(clang_CallGraph_getNode(x, decl))
end

"""
    getOrInsertNode(x::AbstractCallGraph, decl::AbstractDecl) -> CallGraphNode
Return the node standing for `decl`, creating it — and linking it as a callee of the root —
when the graph has none. `decl` is canonicalized first, except for an Objective-C method.
"""
function getOrInsertNode(x::AbstractCallGraph, decl::AbstractDecl)
    @check_ptrs x decl
    return CallGraphNode(clang_CallGraph_getOrInsertNode(x, decl))
end

# The number of nodes in the graph, the virtual root included.
function Base.size(x::AbstractCallGraph)
    @check_ptrs x
    return clang_CallGraph_size(x)
end

"""
    getRoot(x::AbstractCallGraph) -> CallGraphNode
Return the graph's virtual root: the node with no declaration, whose callees are every
function the graph knows could be called from outside.
"""
function getRoot(x::AbstractCallGraph)
    @check_ptrs x
    return CallGraphNode(clang_CallGraph_getRoot(x))
end

function printAsString(x::AbstractCallGraph)
    @check_ptrs x
    return get_string(clang_CallGraph_printAsString(x))
end

function dump(x::AbstractCallGraph)
    @check_ptrs x
    return clang_CallGraph_dump(x)
end

"""
    addNodesForBlocks(x::AbstractCallGraph, dc::AnyDeclContext)
Add a node for every block literal declared directly inside `dc`. `addToCallGraph` already
does this for each function it visits.
"""
function addNodesForBlocks(x::AbstractCallGraph, dc::AnyDeclContext)
    @check_ptrs x dc
    return clang_CallGraph_addNodesForBlocks(x, dc)
end

"""
    getNodes(x::AbstractCallGraph) -> Vector{CallGraphNode}
Return every node of the graph, the virtual root included.

The backing container is an `llvm::DenseMap`, so the ORDER IS UNSPECIFIED and must not be
relied on — only the set is meaningful. The root is the one entry whose `getDecl` carrier
is NULL.
"""
function getNodes(x::AbstractCallGraph)
    @check_ptrs x
    n = Int(size(x))
    buf = Vector{CXCallGraphNode}(undef, n)
    n > 0 && clang_CallGraph_getNodes(x, buf, n)
    return [CallGraphNode(p) for p in buf]
end

# CallGraphNode — one function of the graph plus its outgoing call edges. The carrier is
# borrowed from the parent `CallGraph` and dies with it.
function Base.isempty(x::AbstractCallGraphNode)
    @check_ptrs x
    return clang_CallGraphNode_empty(x)
end

# The number of callee edges leaving this node.
function Base.size(x::AbstractCallGraphNode)
    @check_ptrs x
    return clang_CallGraphNode_size(x)
end

"""
    getCallee(x::AbstractCallGraphNode, i::Integer) -> CallGraphNode
Return the destination of the `i`-th callee edge (0-based, `i < size(x)`).

`clang::CallGraphNode::CallRecord` is a pair, and this is its first half; `getCallExpr`
returns the call site that produced the same edge.
"""
function getCallee(x::AbstractCallGraphNode, i::Integer)
    @check_ptrs x
    @assert 0 <= i < size(x) "callee index $i out of range"
    return CallGraphNode(clang_CallGraphNode_getCallee(x, i))
end

"""
    getCallExpr(x::AbstractCallGraphNode, i::Integer) -> Expr_
Return the call expression that produced the `i`-th callee edge (0-based, `i < size(x)`).
The wrapped pointer is NULL for the root node's edges, which clang creates with no call
site; `resolve` it to refine the expression class.
"""
function getCallExpr(x::AbstractCallGraphNode, i::Integer)
    @check_ptrs x
    @assert 0 <= i < size(x) "callee index $i out of range"
    return Expr_(clang_CallGraphNode_getCallExpr(x, i))
end

"""
    addCallee(x::AbstractCallGraphNode, callee::AbstractCallGraphNode, call_expr::AbstractExpr)
Append a callee edge from `x` to `callee`, recording `call_expr` as its call site. This is
`clang::CallGraphNode::addCallee` with the `CallRecord` pair spread over two arguments.
"""
function addCallee(x::AbstractCallGraphNode, callee::AbstractCallGraphNode, call_expr::AbstractExpr)
    @check_ptrs x callee
    return clang_CallGraphNode_addCallee(x, callee, call_expr)
end

"""
    getDecl(x::AbstractCallGraphNode) -> Decl
Return the function or method this node stands for. The wrapped pointer is NULL for the
graph's virtual root, and for no other node.
"""
function getDecl(x::AbstractCallGraphNode)
    @check_ptrs x
    return Decl(clang_CallGraphNode_getDecl(x))
end

"""
    getDefinition(x::AbstractCallGraphNode) -> FunctionDecl
Return the defining `FunctionDecl` behind this node. The wrapped pointer is NULL for the
virtual root (no declaration), for a node whose declaration is not a function (an
Objective-C method or a block), and for a function with no definition in this translation
unit — clang's own accessor dereferences the first two unguarded, so the shim answers NULL
instead.
"""
function getDefinition(x::AbstractCallGraphNode)
    @check_ptrs x
    return FunctionDecl(clang_CallGraphNode_getDefinition(x))
end

# The qualified name of the node's declaration, or "< >" for the virtual root.
function printAsString(x::AbstractCallGraphNode)
    @check_ptrs x
    return get_string(clang_CallGraphNode_printAsString(x))
end

function dump(x::AbstractCallGraphNode)
    @check_ptrs x
    return clang_CallGraphNode_dump(x)
end
