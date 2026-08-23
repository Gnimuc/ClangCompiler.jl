using ClangCompiler
import ClangCompiler as CC
using Test

@testset "Analysis | Dominators" begin
    I = CC.create_interpreter(String[])
    f = CC.DeclFinder(I)
    try
        CC.parse(I, """
            int dom_fn(int x) {
                int acc = 0;
                if (x > 0) { acc = 1; } else { acc = 2; }
                while (acc < 10) { acc += x; }
                return acc;
            }
            """)
        @assert f(I, "dom_fn")
        fd = CC.getAsFunction(CC.get_decl(f))
        ctx = CC.get_ast_context(I)
        cfg = CC.buildCFG(fd, CC.getBody(fd), ctx)
        @test !CC.is_null_handle(cfg)
        try
            n = Int(CC.getNumBlocks(cfg))
            entry = CC.getEntry(cfg)
            exit_ = CC.getExit(cfg)
            # the branch and the loop make this more than a straight line, which is what
            # gives the trees below anything to say
            @test !CC.isLinear(cfg)

            dt = CC.CFGDomTree(cfg)
            try
                @test CC.getCFG(dt).ptr == cfg.ptr
                @test CC.getNumRoots(dt) == 1
                @test CC.getRoot(dt).ptr == entry.ptr

                # the entry dominates every block of a graph whose blocks are all reachable
                reached = 0
                for i = 0:(n - 1)
                    b = CC.getBlock(cfg, i)
                    CC.hasNode(dt, b) || continue
                    reached += 1
                    @test CC.dominates(dt, entry, b)
                    @test CC.isReachableFromEntry(dt, b)
                end
                @test reached == n

                # reflexivity, and the partition properlyDominates draws through it
                @test CC.dominates(dt, entry, entry)
                @test !CC.properlyDominates(dt, entry, entry)
                @test CC.dominates(dt, entry, exit_)
                @test CC.properlyDominates(dt, entry, exit_)
                # ... and dominance is antisymmetric on two distinct blocks
                @test !CC.dominates(dt, exit_, entry)

                # UPSTREAM QUIRK, asserted as it behaves rather than as it reads.
                # llvm::DominatorTreeBase::findNearestCommonDominator opens with a
                # shortcut -- `NodeT &Entry = A->getParent()->front(); if (A == &Entry ||
                # B == &Entry) return &Entry;` -- which assumes the parent container's
                # first element is the entry node. clang's CFG puts the EXIT block at
                # front() (it is built first, and carries ID 0), so the shortcut fires for
                # any pair involving the exit and hands back the exit.
                #
                # The result is that the answer does not dominate its arguments there: over
                # this graph 26 pairs are sound and the 10 unsound ones are exactly those
                # involving block 0. Sound everywhere else, so the queries below that stay
                # away from the exit mean what they say.
                @test CC.getBlockID(exit_) == 0
                @test CC.findNearestCommonDominator(dt, entry, exit_).ptr == exit_.ptr
                @test !CC.dominates(dt, exit_, entry)   # ...and so is not a dominator of both
                @test CC.findNearestCommonDominator(dt, exit_, exit_).ptr == exit_.ptr

                # away from the exit block the answer is a genuine common dominator
                unsound = 0
                for i = 0:(n - 1), j = 0:(n - 1)
                    a, b = CC.getBlock(cfg, i), CC.getBlock(cfg, j)
                    (CC.hasNode(dt, a) && CC.hasNode(dt, b)) || continue
                    (CC.getBlockID(a) == 0 || CC.getBlockID(b) == 0) && continue
                    d = CC.findNearestCommonDominator(dt, a, b)
                    CC.is_null_handle(d) && continue
                    (CC.dominates(dt, d, a) && CC.dominates(dt, d, b)) || (unsound += 1)
                end
                @test unsound == 0

                # the two arms of the `if` are dominated by their branch block but by
                # neither each other; their nearest common dominator is that branch
                branch = nothing
                for i = 0:(n - 1)
                    b = CC.getBlock(cfg, i)
                    CC.hasTerminator(b) && Int(CC.succ_size(b)) == 2 || continue
                    s0, s1 = CC.getSucc(b, 0), CC.getSucc(b, 1)
                    (CC.is_null_handle(s0) || CC.is_null_handle(s1)) && continue
                    if !CC.dominates(dt, s0, s1) && !CC.dominates(dt, s1, s0)
                        branch = (b, s0, s1)
                        break
                    end
                end
                @test branch !== nothing
                if branch !== nothing
                    b, s0, s1 = branch
                    @test CC.properlyDominates(dt, b, s0)
                    @test CC.properlyDominates(dt, b, s1)
                    @test CC.findNearestCommonDominator(dt, s0, s1).ptr == b.ptr
                end

                @test !isempty(CC.printAsString(dt))

                # the other half of the same gate: a block of another CFG is not in this
                # tree, and llvm's getNode asserts on it rather than answering
                cfg2 = CC.buildCFG(fd, CC.getBody(fd), ctx)
                try
                    e2 = CC.getEntry(cfg2)
                    @test_throws AssertionError CC.dominates(dt, entry, e2)
                    @test_throws AssertionError CC.isReachableFromEntry(dt, e2)
                finally
                    CC.dispose(cfg2)
                end

                # releaseMemory really drops the tree: no block has a node afterwards, and
                # the dump gate — which exists because clang dereferences those nodes —
                # refuses instead of crashing
                CC.releaseMemory(dt)
                @test CC.getNumRoots(dt) == 0
                @test !CC.hasNode(dt, entry)
                @test_throws AssertionError CC.dump(dt)
                # the same gate on the three wrappers that reach llvm's `getNode` directly
                @test_throws AssertionError CC.dominates(dt, entry, exit_)
                @test_throws AssertionError CC.properlyDominates(dt, entry, exit_)
                @test_throws AssertionError CC.isReachableFromEntry(dt, entry)
                # ... and rebuilding restores it
                CC.buildDominatorTree(dt, cfg)
                @test CC.getNumRoots(dt) == 1
                @test CC.hasNode(dt, entry)
                @test CC.getRoot(dt).ptr == entry.ptr
            finally
                CC.dispose(dt)
            end

            pdt = CC.CFGPostDomTree(cfg)
            try
                @test CC.getCFG(pdt).ptr == cfg.ptr
                # post-dominance is dominance on the reversed graph: the exit block
                # post-dominates the entry, and not the other way round
                @test CC.dominates(pdt, exit_, entry)
                @test !CC.dominates(pdt, entry, exit_)
                @test CC.dominates(pdt, exit_, exit_)
                @test !CC.properlyDominates(pdt, exit_, exit_)
                @test CC.hasNode(pdt, entry)
                @test CC.findNearestCommonDominator(pdt, entry, entry).ptr == entry.ptr
                @test !isempty(CC.printAsString(pdt))

                # the parent-mismatch clause on the post-dominator pair
                pcfg2 = CC.buildCFG(fd, CC.getBody(fd), ctx)
                try
                    p2 = CC.getEntry(pcfg2)
                    @test_throws AssertionError CC.dominates(pdt, exit_, p2)
                    @test_throws AssertionError CC.properlyDominates(pdt, exit_, p2)
                finally
                    CC.dispose(pcfg2)
                end
                CC.releaseMemory(pdt)
                @test !CC.hasNode(pdt, entry)
                @test_throws AssertionError CC.dominates(pdt, exit_, entry)
                @test_throws AssertionError CC.properlyDominates(pdt, exit_, entry)
                CC.buildDominatorTree(pdt, cfg)
                @test CC.hasNode(pdt, entry)
            finally
                CC.dispose(pdt)
            end

            cdc = CC.ControlDependencyCalculator(cfg)
            try
                # the calculator's own post-dominator tree is over the same graph, and is
                # borrowed — it is a member, never disposed here
                @test CC.getCFG(CC.getCFGPostDomTree(cdc)).ptr == cfg.ptr

                # the two queries are the same relation: the membership test agrees with
                # the listing for every ordered pair of blocks
                total = 0
                for i = 0:(n - 1)
                    b = CC.getBlock(cfg, i)
                    deps = Set(d.ptr for d in CC.getControlDependencies(cdc, b))
                    total += length(deps)
                    @test Int(CC.getNumControlDependencies(cdc, b)) >= length(deps)
                    for j = 0:(n - 1)
                        c = CC.getBlock(cfg, j)
                        @test CC.isControlDependent(cdc, b, c) == (c.ptr in deps)
                    end
                end
                # a branch and a loop mean somebody is control dependent on something
                @test total > 0
            finally
                CC.dispose(cdc)
            end
        finally
            CC.dispose(cfg)
        end
    finally
        CC.dispose(f)
        CC.dispose(I)
    end
end
