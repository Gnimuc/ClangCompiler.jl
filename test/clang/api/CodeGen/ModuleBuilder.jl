using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: LLVM
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Libdl
using Test

const LX = CC.LibClangEx

# Frontend/infra tail: the deferred wrappers that must never run against the live
# interpreter's state. Every testset builds throwaway objects (fresh CompilerInstance,
# builder, options, managers) and disposes them in reverse-dependency order; interpreters
# created here are themselves throwaways owned by the testset.

@testset "CUDA builder knobs (throwaway builder)" begin
    builder = CC.IncrementalCompilerBuilder()
    @test CC.SetCudaSDK(builder, "/nonexistent/cuda/sdk") === nothing
    @test CC.SetOffloadArch(builder, "sm_80") === nothing
    dispose(builder)
end

@testset "GetMangledName is the name codegen actually used" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             extern "C" int mb_c_fn(int x) { return x; }
             int mb_cxx_fn(int x) { return x; }
             """)
    cg = CC.getCodeGen(I.interp)
    f = DeclFinder(I)

    # an extern "C" function is its own IR name, with no target decoration -- that is added
    # by the object writer, not by codegen
    @test f(I, "mb_c_fn")
    @test CC.GetMangledName(cg, CC.FunctionDecl(get_decl(f))) == "mb_c_fn"

    # a C++ function is mangled, and the name round-trips back to the declaration through
    # the very table codegen recorded it in
    @test f(I, "mb_cxx_fn")
    fd = CC.FunctionDecl(get_decl(f))
    mangled = CC.GetMangledName(cg, fd)
    @test mangled != "mb_cxx_fn"
    @test !CC.is_null_handle(CC.GetDeclForMangledName(cg, mangled))

    dispose(f)
    dispose(I)
end

@testset "GetMangledName / GetAddrOfGlobal split constructors and destructors out" begin
    I = create_interpreter(String[])
    CC.parse(I, "struct mb_k { mb_k(); ~mb_k(); int v; };")
    cg = CC.getCodeGen(I.interp)
    f = DeclFinder(I)
    @test f(I, "mb_k")
    rd = CC.CXXRecordDecl(get_decl(f))

    ctors = CC.getCtors(rd)
    @test !isempty(ctors)
    ctor = first(ctors)
    dtor = CC.getDestructor(rd)
    @test !CC.is_null_handle(dtor)

    # clang's GlobalDecl(NamedDecl *) rejects them outright: several bodies, no single name
    @test_throws AssertionError CC.GetMangledName(cg, ctor)
    @test_throws AssertionError CC.GetMangledName(cg, dtor)
    @test_throws AssertionError CC.GetAddrOfGlobal(cg, ctor)
    @test_throws AssertionError CC.GetAddrOfGlobal(cg, dtor)

    cname = CC.GetMangledName(cg, ctor, LX.CXCXXCtorType_Ctor_Complete)
    dname = CC.GetMangledName(cg, dtor, LX.CXCXXDtorType_Dtor_Complete)
    @test !isempty(cname)
    @test !isempty(dname)
    @test cname != dname
    # the mangling is a function of the variant, so asking twice answers the same thing
    @test cname == CC.GetMangledName(cg, ctor, LX.CXCXXCtorType_Ctor_Complete)

    dispose(f)
    dispose(I)
end

@testset "GetAddrOfGlobal names the emitted entity" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             extern "C" int mb_addr_fn(int x) { return x; }
             extern "C" int mb_addr_gv = 3;
             """)
    cg = CC.getCodeGen(I.interp)
    f = DeclFinder(I)

    @test f(I, "mb_addr_fn")
    fd = CC.FunctionDecl(get_decl(f))
    fn = CC.GetAddrOfGlobal(cg, fd, true)
    @test fn isa LLVM.Function
    @test LLVM.name(fn) == CC.GetMangledName(cg, fd)
    # the same entity whichever way it is asked for
    @test LLVM.name(CC.GetAddrOfGlobal(cg, fd, false)) == LLVM.name(fn)

    @test f(I, "mb_addr_gv")
    vd = CC.VarDecl(get_decl(f))
    gv = CC.GetAddrOfGlobal(cg, vd, true)
    @test gv !== nothing
    @test !(gv isa LLVM.Function)
    @test LLVM.name(gv) == "mb_addr_gv"

    dispose(f)
    dispose(I)
end

@testset "CreateLLVMCodeGen builds a code generator with no action driving it" begin
    I = create_interpreter(String[])
    ci = get_instance(I)
    lctx = LLVM.Context()

    cg = CC.CodeGenerator(ci, "standalone_cgen", lctx)
    @test cg isa CC.CodeGenerator
    # the generator owns a module of its own from the moment it is built -- that module is
    # the whole point of driving a Parser into it
    mod = CC.GetModule(cg)
    @test LLVM.name(mod) == "standalone_cgen"
    # The llvm::Module exists from construction, but the clang::CodeGenModule does not:
    # clang materialises it in CodeGenerator::Initialize(ASTContext), which is what an
    # action would call. Until then CGM is NULL -- the partition below is the whole
    # lifecycle, and asserting only the "after" half would miss a generator that handed
    # out a module it had not built yet.
    @test CC.is_null_handle(CC.CGM(cg))
    CC.Initialize(cg, CC.get_ast_context(I))
    @test !CC.is_null_handle(CC.CGM(cg))
    # and it is its own, not a view onto the interpreter's
    @test CC.CGM(cg).ptr != CC.get_codegen_module(I).ptr
    dispose(cg)

    # ... and the LLVM 20 signature takes a virtual file system, which only a configured
    # file manager can supply
    bare = CC.CompilerInstance()
    @test_throws AssertionError CC.CodeGenerator(bare, "no_fm", lctx)
    dispose(bare)

    LLVM.dispose(lctx)
    dispose(I)
end
