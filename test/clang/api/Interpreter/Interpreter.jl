using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Libdl
using LLVM
using Test

# Frontend/infra tail: the deferred wrappers that must never run against the live
# interpreter's state. Every testset builds throwaway objects (fresh CompilerInstance,
# builder, options, managers) and disposes them in reverse-dependency order; interpreters
# created here are themselves throwaways owned by the testset.

@testset "interpreter dtor call and dynamic library" begin
    I = create_interpreter(String[])
    # An empty message is the success report; the void this used to return could not
    # distinguish a load that worked from one that silently did not.
    @test isempty(CC.LoadDynamicLibrary(I.interp, Libdl.dlpath(CC.libclangex)))
    @test !isempty(CC.LoadDynamicLibrary(I.interp, joinpath(mktempdir(), "no_such_lib.dylib")))
    CC.compile(I, """
        struct FtTrivial { int x; };
        struct FtNontrivial { int y; ~FtNontrivial(); };
        FtNontrivial::~FtNontrivial() {}
        FtTrivial ft_trivial_probe;
    """)
    f = DeclFinder(I)
    @test f(I, "FtTrivial")
    triv = CC.CXXRecordDecl(get_decl(f))
    @test CC.CompileDtorCall(I.interp, triv) == 0  # irrelevant destructor -> null address
    @test f(I, "FtNontrivial")
    nontriv = CC.CXXRecordDecl(get_decl(f))
    @test CC.CompileDtorCall(I.interp, nontriv) isa UInt64
    dispose(f)
    dispose(I)
end

@testset "undo" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    CC.parse(I, "int cii_gone = 2;")
    @test f(I, "cii_gone")
    # retract the most recent partial translation unit; an empty message reports success
    @test isempty(CC.undo(I.interp))
    # What proves the retraction happened is that the definition can be made again: a
    # redefinition is rejected while the first one stands (asserted below), so accepting
    # one here means the increment really was unwound. The decl stays reachable through
    # lookup either way -- Undo drops the increment, it does not erase the AST nodes.
    @test CC.parse(I, "int cii_gone = 3;").ptr != C_NULL
    # unwinding past the first increment is the caller's error to notice, and the message is
    # the only place it is reported -- clang does not expose the count to check against
    @test !isempty(CC.undo(I.interp, 10_000))
    dispose(f)
    dispose(I)
end

@testset "undo | a redefinition is what the retraction makes room for" begin
    # The control for the test above: without an undo in between, the second definition is
    # rejected and Parse hands back NULL.
    I = create_interpreter(String[])
    @test CC.parse(I, "int cii_dup = 2;").ptr != C_NULL
    @test CC.parse(I, "int cii_dup = 3;").ptr == C_NULL
    dispose(I)
end

@testset "PartialTranslationUnit | increment decls and IR module" begin
    I = create_interpreter(String[])
    ptu = CC.parse(I, "int ptu_probe_var = 7;")
    tu = CC.getTUPart(ptu)
    # the increment's own translation unit carries the decl just parsed, and nothing from
    # a later one -- that separation is the whole point of a partial translation unit
    names = [CC.getNameAsString(d) for d in CC.DeclIterator(tu) if d isa CC.AbstractNamedDecl]
    @test "ptu_probe_var" in names
    ptu2 = CC.parse(I, "int ptu_probe_other = 8;")
    names2 = [CC.getNameAsString(d) for d in CC.DeclIterator(CC.getTUPart(ptu2)) if d isa CC.AbstractNamedDecl]
    @test "ptu_probe_other" in names2
    @test "ptu_probe_var" ∉ names2
    dispose(I)
end

@testset "PartialTranslationUnit | Execute moves the module out" begin
    I = create_interpreter(String[])
    ptu = CC.parse(I, "int ptu_exec_probe = 9;")
    before = CC.getModule(ptu)
    # the increment's own IR carries the variable it declared
    @test before !== nothing
    @test occursin("ptu_exec_probe", string(LLVM.name.(collect(LLVM.globals(before)))))
    # Execute hands the module to the JIT, so the increment no longer owns one
    @test isempty(CC.Execute(I.interp, ptu))
    @test CC.getModule(ptu) === nothing
    dispose(I)
end

@testset "Interpreter | decl-keyed symbol address" begin
    I = create_interpreter(String[])
    CC.compile(I, "extern \"C\" int isa_probe_fn(void) { return 41; }")
    f = DeclFinder(I)
    @test f(I, "isa_probe_fn")
    fd = CC.FunctionDecl(get_decl(f))
    addr = CC.getSymbolAddress(I.interp, fd)
    # the decl route must land on the same address the mangled-name route does, which is
    # the property that makes it safe to skip the mangling step
    @test addr != 0
    @test addr == CC.getSymbolAddress(I.interp, "isa_probe_fn")
    # calling through it is what proves the address is the function rather than some other
    # symbol that happens to be resolvable
    @test ccall(reinterpret(Ptr{Cvoid}, addr), Cint, ()) == 41
    dispose(f)
    dispose(I)
end

@testset "Interpreter | direct ASTContext accessor" begin
    I = create_interpreter(String[])
    CC.parse(I, "int interp_ctx_probe = 1;")
    # the context reached directly is the same object the compiler instance holds
    direct = CC.getASTContext(I.interp)
    viaci = CC.getASTContext(CC.getCompilerInstance(I.interp))
    @test direct.ptr == viaci.ptr
    # and it is the one the package's own helper returns
    @test direct.ptr == CC.get_ast_context(I).ptr
    dispose(I)
end
