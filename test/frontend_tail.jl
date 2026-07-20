using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Libdl
using Test

# Frontend/infra tail: the deferred wrappers that must never run against the live
# interpreter's state. Every testset builds throwaway objects (fresh CompilerInstance,
# builder, options, managers) and disposes them in reverse-dependency order; interpreters
# created here are themselves throwaways owned by the testset.

@testset "FrontendTail | Driver resources path" begin
    path = CC.GetResourcesPath(Libdl.dlpath(CC.libclangex))
    @test path isa String
    @test !isempty(path)
    @test occursin("clang", path)
end

@testset "FrontendTail | option object lifecycles" begin
    cgo = CC.CodeGenOptions()
    @test cgo.ptr != C_NULL
    dispose(cgo)

    tgo = CC.TargetOptions()
    CC.setTriple(tgo, "x86_64-unknown-linux-gnu")
    dispose(tgo)

    dgo = CC.DiagnosticOptions()
    CC.setShowColors(dgo, false)
    dispose(dgo)

    ids = CC.DiagnosticIDs()
    @test ids.ptr != C_NULL
    dispose(ids)

    inv = CC.CompilerInvocation(CC.LibClangEx.clang_CompilerInvocation_create())
    @test inv.ptr != C_NULL
    dispose(inv)
end

@testset "FrontendTail | file manager, entries, buffers" begin
    fm = CC.FileManager()

    dir = CC.getDirectory(fm, @__DIR__)
    @test dir isa CC.DirectoryEntry
    @test dir.ptr != C_NULL

    file = @__FILE__
    fe = CC.getFileEntry(fm, file)
    @test CC.getModificationTime(fe) > 0
    de = CC.getDir(fe)
    @test de isa CC.DirectoryEntry
    @test de.ptr != C_NULL

    fer = CC.getFileRef(fm, file)
    @test fer isa CC.FileEntryRef
    @test occursin("frontend_tail", CC.getName(CC.getFileEntry(fer)))
    buf = CC.getBufferForFile(fm, fer)
    @test buf isa CC.LLVM.MemoryBuffer
    @test length(buf) == filesize(file)
    CC.LLVM.dispose(buf)

    diag = CC.DiagnosticsEngine()
    sm = CC.SourceManager(fm, diag)
    ov = CC.LLVM.MemoryBuffer(Vector{UInt8}(codeunits("int overridden;")), "override", true)
    CC.overrideFileContents(sm, fer, ov)   # consumes ov: do not dispose the buffer

    dispose(fer)
    dispose(sm)    # the source manager stores references: dispose before fm/diag
    dispose(fm)
    dispose(diag)
end

@testset "FrontendTail | VFS-backed PCH file manager" begin
    ci = CC.CompilerInstance()
    vpath = joinpath(@__DIR__, "virtual_prefix_header.pch")  # exists only in the overlay
    payload = "not a real PCH"
    pch = CC.LLVM.MemoryBuffer(Vector{UInt8}(codeunits(payload)), "pch", true)
    fm = CC.createFileManagerWithVOFS4PCH(ci, vpath, 42, pch)  # consumes pch
    @test fm isa CC.FileManager
    @test fm.ptr != C_NULL
    fer = CC.getFileRef(fm, vpath)
    @test fer isa CC.FileEntryRef
    buf = CC.getBufferForFile(fm, fer; requires_null_terminator=false)
    @test buf isa CC.LLVM.MemoryBuffer
    @test length(buf) == sizeof(payload)
    CC.LLVM.dispose(buf)
    dispose(fer)
    dispose(ci)    # the instance owns the file manager it created
end

@testset "FrontendTail | codegen emit actions" begin
    llvm_ctx = CC.LLVM.Context()
    for T in (CC.EmitAssemblyAction, CC.EmitBCAction, CC.EmitLLVMAction,
              CC.EmitCodeGenOnlyAction, CC.EmitObjAction)
        act = T(llvm_ctx)
        @test act isa T
        @test act.ptr != C_NULL
        dispose(act)
    end
    CC.LLVM.dispose(llvm_ctx)
end

@testset "FrontendTail | ASTConsumer Initialize on a throwaway interpreter" begin
    # Initialize rewires the consumer to an ASTContext; re-initializing a
    # throwaway interpreter's own consumer against its own context is a benign
    # re-init (a fresh CodeGenModule over the same context), and the interpreter
    # is disposed immediately after without parsing again.
    I = create_interpreter(String[])
    ci = CC.get_instance(I)
    @test CC.hasASTConsumer(ci)
    cg = CC.get_codegen(ci)                      # borrowed consumer
    @test CC.Initialize(cg, CC.get_ast_context(I)) === nothing
    dispose(I)
end

@testset "FrontendTail | raw lexer lifecycle" begin
    ci = CC.CompilerInstance()  # only used as the provider of default language options
    lang_opts = CC.getLangOpts(ci)
    fm = CC.FileManager()
    diag = CC.DiagnosticsEngine()
    sm = CC.SourceManager(fm, diag)
    code = "int lexer_probe = 1;"
    fid_buf = CC.LLVM.MemoryBuffer(Vector{UInt8}(codeunits(code)), "lexbuf", true)
    fid = CC.FileID(sm, fid_buf)  # the source manager takes ownership of this buffer
    lex_buf = CC.LLVM.MemoryBuffer(Vector{UInt8}(codeunits(code)), "lexbuf", true)
    lex = CC.Lexer(fid, lex_buf, sm, lang_opts)
    @test lex isa CC.Lexer
    @test lex.ptr != C_NULL
    dispose(lex)
    CC.LLVM.dispose(lex_buf)  # the lexer only borrowed it
    dispose(fid)
    dispose(sm)
    dispose(fm)
    dispose(diag)
    dispose(ci)
end

@testset "FrontendTail | header search resource dir round-trip" begin
    ci = CC.CompilerInstance()
    hso = CC.getHeaderSearchOpts(ci)
    CC.SetResourceDir(hso, "/tmp/clangcompiler-fake-resource-dir")
    @test CC.GetResourceDir(hso) == "/tmp/clangcompiler-fake-resource-dir"
    dispose(ci)
end

@testset "FrontendTail | preprocessor includes round-trip" begin
    I = create_interpreter(["-include", "cstddef"])
    ppo = CC.getPreprocessorOpts(get_instance(I))
    incs = CC.getIncludes(ppo)
    @test incs isa Vector{String}
    @test "cstddef" in incs
    dispose(I)
end

@testset "FrontendTail | CUDA builder knobs (throwaway builder)" begin
    builder = CC.IncrementalCompilerBuilder()
    @test CC.SetCudaSDK(builder, "/nonexistent/cuda/sdk") === nothing
    @test CC.SetOffloadArch(builder, "sm_80") === nothing
    dispose(builder)
end

@testset "FrontendTail | interpreter dtor call and dynamic library" begin
    I = create_interpreter(String[])
    @test CC.LoadDynamicLibrary(I.interp, Libdl.dlpath(CC.libclangex)) === nothing
    CC.compile(I, """
        struct FtTrivial { int x; };
        struct FtNontrivial { int y; ~FtNontrivial(); };
        FtNontrivial::~FtNontrivial() {}
        FtTrivial ft_trivial_probe;
    """)
    f = DeclFinder(I)
    @test f(I, "FtTrivial")
    triv = CC.CXXRecordDecl(get_decl(f).ptr)
    @test CC.CompileDtorCall(I.interp, triv) == 0  # irrelevant destructor -> null address
    @test f(I, "FtNontrivial")
    nontriv = CC.CXXRecordDecl(get_decl(f).ptr)
    @test CC.CompileDtorCall(I.interp, nontriv) isa UInt64
    dispose(f)
    dispose(I)
end

@testset "FrontendTail | value from type" begin
    I = create_interpreter(String[])
    CC.parse(I, "int ft_value_probe = 0; double ft_value_probe2 = 0.0;")
    f = DeclFinder(I)
    @test f(I, "ft_value_probe")
    qt_int = CC.getType(CC.VarDecl(get_decl(f).ptr))
    @test f(I, "ft_value_probe2")
    qt_double = CC.getType(CC.VarDecl(get_decl(f).ptr))

    v = CC.createValueFromType(I.interp, qt_int)
    @test v isa CC.Value
    @test CC.isValid(v)
    @test CC.getKind(v) == CC.LibClangEx.CXValue_Int
    @test CC.getType(v) == qt_int.ptr   # opaque encoding round-trip
    CC.setOpaqueType(v, qt_double)
    @test CC.getType(v) == qt_double.ptr
    dispose(v)
    dispose(f)
    dispose(I)
end

@testset "FrontendTail | mangling name generator surface" begin
    # No creator for clang::ASTNameGenerator crosses the C boundary yet, so only the
    # method surface is checkable here.
    @test hasmethod(CC.getAllManglings, Tuple{CC.ASTNameGenerator,CC.FunctionDecl})
end
