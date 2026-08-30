using ClangCompiler
import ClangCompiler as CC
using Test

@testset "Analysis | CallGraph" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    try
        CC.parse(I, """
            int cg_leaf(int x) { return x + 1; }
            int cg_mid(int x) { return cg_leaf(x) + cg_leaf(x + 1); }
            int cg_top(int x) { return cg_mid(x); }
            int cg_never_defined(int x);
            """)
        tu = CC.translation_unit(I)

        g = CC.CallGraph()
        try
            # a fresh graph holds only its virtual root, and the root has no Decl
            @test CC.size(g) == 1
            root = CC.getRoot(g)
            @test CC.is_null_handle(CC.getDecl(root))
            @test CC.is_null_handle(CC.getDefinition(root))
            @test isempty(root)
            @test CC.printAsString(root) == "< >"

            CC.addToCallGraph(g, tu)

            nodes = CC.getNodes(g)
            @test length(nodes) == Int(CC.size(g))
            # the flattened array is the whole map, so it contains the root exactly once
            @test count(n -> CC.is_null_handle(CC.getDecl(n)), nodes) == 1
            @test count(n -> n.ptr == CC.getRoot(g).ptr, nodes) == 1

            byname = Dict{String,CC.CallGraphNode}()
            for n in nodes
                CC.is_null_handle(CC.getDecl(n)) && continue
                byname[CC.printAsString(n)] = n
            end
            @test haskey(byname, "cg_leaf")
            @test haskey(byname, "cg_mid")
            @test haskey(byname, "cg_top")
            # a declaration with no body never becomes a node of its own
            @test !haskey(byname, "cg_never_defined")

            leaf, mid, top = byname["cg_leaf"], byname["cg_mid"], byname["cg_top"]

            # the map really is keyed on each node's own Decl
            for (_, n) in byname
                @test CC.getNode(g, CC.getDecl(n)).ptr == n.ptr
                @test CC.getOrInsertNode(g, CC.getDecl(n)).ptr == n.ptr
            end
            # ... and getOrInsertNode inserted nothing while checking that
            @test length(CC.getNodes(g)) == length(nodes)

            # who calls whom: cg_top -> cg_mid -> cg_leaf twice, and cg_leaf calls nothing
            @test CC.size(top) == 1
            @test CC.getCallee(top, 0).ptr == mid.ptr
            @test CC.size(mid) == 2
            @test CC.getCallee(mid, 0).ptr == leaf.ptr
            @test CC.getCallee(mid, 1).ptr == leaf.ptr
            @test CC.size(leaf) == 0
            @test isempty(leaf)
            @test !isempty(mid)

            # every real call edge carries the call site that produced it, and the two
            # edges out of cg_mid are two distinct calls
            e0 = CC.getCallExpr(mid, 0)
            e1 = CC.getCallExpr(mid, 1)
            @test e0.ptr != e1.ptr
            @test CC.resolve(e0) isa CC.AbstractCallExpr
            @test CC.resolve(e1) isa CC.AbstractCallExpr

            # the root's edges are synthetic: one per node, each with no call site
            @test CC.size(root) == CC.size(g) - 1
            root_callees = Set(CC.getCallee(root, i).ptr for i = 0:(Int(CC.size(root)) - 1))
            @test issubset(Set([leaf.ptr, mid.ptr, top.ptr]), root_callees)
            for i = 0:(Int(CC.size(root)) - 1)
                @test CC.is_null_handle(CC.getCallExpr(root, i))
            end

            # getDefinition resolves to the defining FunctionDecl of the node's Decl
            @test CC.getDefinition(mid).ptr == CC.getDecl(mid).ptr
            @test CC.getName(CC.getAsFunction(CC.getDecl(mid))) == "cg_mid"

            # the static predicates partition definitions from bare declarations
            @assert f(I, "cg_leaf")
            leaf_fd = CC.getAsFunction(CC.get_decl(f))
            CC.reset(f)
            @assert f(I, "cg_never_defined")
            undef_fd = CC.getAsFunction(CC.get_decl(f))
            @test CC.includeInGraph(leaf_fd)
            @test !CC.includeInGraph(undef_fd)
            @test CC.includeCalleeInGraph(leaf_fd)
            @test CC.includeCalleeInGraph(undef_fd)
            # ... and the graph agrees with them
            @test !CC.is_null_handle(CC.getNode(g, leaf_fd))
            @test CC.is_null_handle(CC.getNode(g, undef_fd))

            # a decl context with no block literals adds nothing
            before = Int(CC.size(g))
            CC.addNodesForBlocks(g, tu)
            @test Int(CC.size(g)) == before

            # addCallee appends an edge with the record clang would have built
            null_expr = CC.getCallExpr(root, 0)
            CC.addCallee(leaf, top, null_expr)
            @test CC.size(leaf) == 1
            @test CC.getCallee(leaf, 0).ptr == top.ptr
            @test CC.is_null_handle(CC.getCallExpr(leaf, 0))
            @test !isempty(leaf)

            rendered = CC.printAsString(g)
            @test occursin("cg_mid", rendered)
            @test occursin("cg_leaf", rendered)
            @test occursin("< root >", rendered)
        finally
            CC.dispose(g)
        end
    finally
        CC.dispose(f)
        CC.dispose(I)
    end
end
