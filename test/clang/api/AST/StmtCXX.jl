using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

@testset "StmtCXX range-for and coroutine accessors" begin
    function find_node(::Type{T}, x) where {T}
        x isa T && return x
        for c in CC.children(x)
            r = find_node(T, c)
            r === nothing || return r
        end
        return nothing
    end

    # --- CXXForRangeStmt: range-based for over an array ---
    I = create_interpreter(["-std=c++20"])
    CC.parse(I, """
    int sum_range() {
        int arr[3] = {1, 2, 3};
        int total = 0;
        for (int x : arr) { total += x; }
        return total;
    }
    """)
    finder = DeclFinder(I)
    @test finder(I, "sum_range")
    fd = CC.FunctionDecl(get_decl(finder).ptr)
    frs = find_node(CC.CXXForRangeStmt, CC.resolve(CC.getBody(fd)))
    @test frs isa CC.CXXForRangeStmt
    if frs isa CC.CXXForRangeStmt
        # no init-statement in this form -> a null carrier, still an AbstractStmt
        @test CC.getInit(frs) isa CC.AbstractStmt
        @test CC.getRangeStmt(frs) isa CC.DeclStmt
        @test CC.getLoopVarStmt(frs) isa CC.DeclStmt
        @test CC.getCond(frs) isa CC.Expr_   # implicit __begin != __end
        @test CC.getInc(frs) isa CC.Expr_    # implicit ++__begin
    end
    dispose(I)

    # --- CoroutineBodyStmt / CoreturnStmt: a minimal coroutine ---
    # The interpreter runs -nostdinc, so <coroutine> is not on the include path on
    # any host. Provide the minimal coroutine support library inline (the same shim
    # clang's own coroutine tests use) so the coroutine actually lowers everywhere.
    J = create_interpreter(["-std=c++20"])
    CC.parse(J, """
    namespace std {
    template <class Ret, class... Args> struct coroutine_traits {
        using promise_type = typename Ret::promise_type;
    };
    template <class Promise = void> struct coroutine_handle;
    template <> struct coroutine_handle<void> {
        static coroutine_handle from_address(void *) noexcept { return {}; }
        void *address() const noexcept { return nullptr; }
    };
    template <class Promise> struct coroutine_handle {
        operator coroutine_handle<>() const noexcept { return {}; }
        static coroutine_handle from_address(void *) noexcept { return {}; }
        static coroutine_handle from_promise(Promise &) noexcept { return {}; }
        void *address() const noexcept { return nullptr; }
        Promise &promise() const noexcept { return *static_cast<Promise *>(nullptr); }
    };
    struct suspend_always {
        bool await_ready() const noexcept { return false; }
        void await_suspend(coroutine_handle<>) const noexcept {}
        void await_resume() const noexcept {}
    };
    }
    struct task {
        struct promise_type {
            task get_return_object() { return {}; }
            std::suspend_always initial_suspend() noexcept { return {}; }
            std::suspend_always final_suspend() noexcept { return {}; }
            void return_void() noexcept {}
            void unhandled_exception() noexcept {}
        };
    };
    task coro() {
        co_await std::suspend_always{};
        co_return;
    }
    """)
    cfinder = DeclFinder(J)
    @test cfinder(J, "coro")
    cfd = CC.FunctionDecl(get_decl(cfinder).ptr)
    root = CC.resolve(CC.getBody(cfd))
    cbs = find_node(CC.CoroutineBodyStmt, root)
    @test cbs isa CC.CoroutineBodyStmt
    if cbs isa CC.CoroutineBodyStmt
        @test CC.hasDependentPromiseType(cbs) isa Bool
        @test CC.hasDependentPromiseType(cbs) == false
        @test CC.resolve(CC.getBody(cbs)) isa CC.CompoundStmt
        @test CC.getPromiseDecl(cbs) isa CC.VarDecl
        @test CC.getInitSuspendStmt(cbs) isa CC.AbstractStmt
        @test CC.getFinalSuspendStmt(cbs) isa CC.AbstractStmt
        @test CC.getExceptionHandler(cbs) isa CC.AbstractStmt
        @test CC.getAllocate(cbs) isa CC.Expr_
        @test CC.getDeallocate(cbs) isa CC.Expr_
        @test CC.getReturnStmt(cbs) isa CC.AbstractStmt

        crs = find_node(CC.CoreturnStmt, root)
        @test crs isa CC.CoreturnStmt
        if crs isa CC.CoreturnStmt
            @test CC.getKeywordLoc(crs) isa CC.SourceLocation
            @test CC.isImplicit(crs) isa Bool
            # `co_return;` has no operand -> null carrier
            @test CC.getOperand(crs) isa CC.Expr_
            @test CC.getPromiseCall(crs) isa CC.Expr_
        end
    end
    dispose(J)
end
