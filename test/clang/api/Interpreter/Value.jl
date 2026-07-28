using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Libdl
using Test

# Frontend/infra tail: the deferred wrappers that must never run against the live
# interpreter's state. Every testset builds throwaway objects (fresh CompilerInstance,
# builder, options, managers) and disposes them in reverse-dependency order; interpreters
# created here are themselves throwaways owned by the testset.

@testset "value from type" begin
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

using ClangCompiler: get_tag
@testset "coverage tail: value-interp" begin
    @testset "value kind and primitive round-trips" begin
        v = CC.create_value()
        @test v isa CC.Value
        @test !(CC.isManuallyAlloc(v))
        @test CC.hasValue(v) == false
        @test CC.isVoid(v) == false

        CC.setKind(v, CC.LibClangEx.CXValue_Void)
        @test CC.getKind(v) == CC.LibClangEx.CXValue_Void
        @test CC.isVoid(v) == true
        @test CC.hasValue(v) == false

        CC.setKind(v, CC.LibClangEx.CXValue_Bool)
        CC.setBool(v, true)
        @test CC.getBool(v) == true
        @test CC.hasValue(v) == true

        CC.setKind(v, CC.LibClangEx.CXValue_Char_S)
        CC.setChar_S(v, Int8(65))
        @test CC.getChar_S(v) == Int8(65)

        CC.setKind(v, CC.LibClangEx.CXValue_SChar)
        CC.setSChar(v, Int8(-12))
        @test CC.getSChar(v) == Int8(-12)

        CC.setKind(v, CC.LibClangEx.CXValue_UChar)
        CC.setUChar(v, UInt8(200))
        @test CC.getUChar(v) == UInt8(200)

        CC.setKind(v, CC.LibClangEx.CXValue_Short)
        CC.setShort(v, Int16(-321))
        @test CC.getShort(v) == Int16(-321)

        CC.setKind(v, CC.LibClangEx.CXValue_UShort)
        CC.setUShort(v, UInt16(4321))
        @test CC.getUShort(v) == UInt16(4321)

        CC.setKind(v, CC.LibClangEx.CXValue_Int)
        CC.setInt(v, Int32(-42))
        @test CC.getInt(v) == Int32(-42)

        CC.setKind(v, CC.LibClangEx.CXValue_UInt)
        CC.setUInt(v, UInt32(42))
        @test CC.getUInt(v) == UInt32(42)

        CC.setKind(v, CC.LibClangEx.CXValue_Long)
        CC.setLong(v, 123456)
        @test CC.getLong(v) == 123456

        CC.setKind(v, CC.LibClangEx.CXValue_ULong)
        CC.setULong(v, 654321)
        @test CC.getULong(v) == 654321

        CC.setKind(v, CC.LibClangEx.CXValue_LongLong)
        CC.setLongLong(v, Int64(1) << 40)
        @test CC.getLongLong(v) == Int64(1) << 40

        CC.setKind(v, CC.LibClangEx.CXValue_ULongLong)
        CC.setULongLong(v, UInt64(1) << 41)
        @test CC.getULongLong(v) == UInt64(1) << 41

        CC.setKind(v, CC.LibClangEx.CXValue_Float)
        CC.setFloat(v, 1.5f0)
        @test CC.getFloat(v) == 1.5f0

        CC.setKind(v, CC.LibClangEx.CXValue_Double)
        CC.setDouble(v, -2.25)
        @test CC.getDouble(v) == -2.25

        CC.setKind(v, CC.LibClangEx.CXValue_LongDouble)
        CC.setLongDouble(v, 2.5)
        @test CC.getLongDouble(v) == 2.5

        CC.setKind(v, CC.LibClangEx.CXValue_PtrOrObj)
        p = Ptr{Cvoid}(UInt(0x1234))
        CC.setPtr(v, p)
        @test CC.getPtr(v) == p

        dispose(v)
    end

    @testset "ParseAndExecute, linker-name lookup, raw-handle CxxInterpreter" begin
        # Value capture needs the interpreter runtime
        # (__clang_Interpreter_SetValueNoAlloc) resolvable by the ORC JIT;
        # JLLShim.__init__ promotes libclang-cpp to the global namespace so
        # this works on every platform.
        I = create_interpreter(String[])
        # a declaration-only increment produces no result value
        v = CC.ParseAndExecute(I.interp, "extern \"C\" int vi_pae_fn() { return 42; }")
        @test v isa CC.Value
        @test CC.hasValue(v) == false
        dispose(v)
        # a top-level expression increment captures its value
        v2 = CC.ParseAndExecute(I.interp, "vi_pae_fn()")
        @test v2 isa CC.Value
        @test CC.hasValue(v2) == true
        @test CC.getKind(v2) == CC.LibClangEx.CXValue_Int
        @test CC.getInt(v2) == Int32(42)
        dispose(v2)

        # the linker-level name carries the platform global prefix (Mach-O: "_")
        lname = (Sys.isapple() ? "_" : "") * "vi_pae_fn"
        addr = CC.get_symbol_address_from_linker_name(I, lname)
        @test addr isa UInt64
        @test addr != 0
        @test addr == CC.getSymbolAddress(I.interp, "vi_pae_fn")

        # wrapping the raw handle yields a second view on the same interpreter
        I2 = CC.CxxInterpreter(I.interp.ptr)
        @test I2 isa CC.CxxInterpreter
        @test I2.interp.ptr == I.interp.ptr

        dispose(I)
    end

    @testset "codegen module lifecycle" begin
        I = create_interpreter(String[])
        CC.compile(I, "extern \"C\" int vi_cg_add(int a, int b) { return a + b; }")
        cg = CC.getCodeGen(I.interp)
        mod = CC.get_llvm_module(cg)
        @test mod isa CC.LLVM.Module
        @test mod.ref != C_NULL
        d = CC.get_decl(cg, "vi_cg_add")
        @test d isa CC.Decl
        @test d.ptr != C_NULL
        # mimic the incremental parser: release the current module, start a fresh one
        llvm_ctx = CC.LLVM.context(mod)
        released = CC.release_llvm_module(cg)
        @test released isa CC.LLVM.Module
        @test released.ref == mod.ref
        started = CC.start_llvm_module(cg, llvm_ctx, "vi_cg_started")
        @test started isa CC.LLVM.Module
        @test started.ref != C_NULL
        CC.LLVM.dispose(released)  # release transfers ownership to us
        dispose(I)
    end

    @testset "CUDA builder create paths" begin
        builder = CC.IncrementalCompilerBuilder()
        CC.SetCompilerArgs(builder, CC.get_default_args())
        CC.SetCudaSDK(builder, "/nonexistent-vi-cuda-sdk")
        CC.SetOffloadArch(builder, "sm_80")
        host = CC.CreateCudaHost(builder)
        @test host isa CC.CompilerInstance
        dev = CC.CreateCudaDevice(builder)
        @test dev isa CC.CompilerInstance
        if host.ptr != C_NULL && dev.ptr != C_NULL
            # adopts both instances (freed on failure too) — never dispose them below
            interp = CC.createWithCUDA(host, dev)
            @test interp isa CC.Interpreter  # NULL handle without a real CUDA SDK
            interp.ptr != C_NULL && dispose(interp)
        else
            host.ptr != C_NULL && dispose(host)
            dev.ptr != C_NULL && dispose(dev)
        end
        dispose(builder)
    end

    @testset "LLVMOnlyAction execute and takeModule" begin
        mktempdir() do dir
            src = joinpath(dir, "vi_act_main.cpp")
            write(src, "extern \"C\" int vi_act_fn(int x) { return x * 3; }\n")
            llvm_ctx = CC.LLVM.Context()
            instance = CC.CompilerInstance()
            CC.setShowColors(instance, false)
            CC.createDiagnostics(instance)
            diag = CC.getDiagnostics(instance)
            args = CC.get_default_args()
            push!(args, "-fno-use-cxa-atexit")
            invok = CC.create_compiler_invocation_from_cmd(src, args, diag)
            CC.setInvocation(instance, invok)  # adopts invok — no dispose
            act = CC.LLVMOnlyAction(llvm_ctx)
            @test act isa CC.LLVMOnlyAction
            @test act.ptr != C_NULL
            @test CC.ExecuteAction(instance, act) == true
            m = CC.takeModule(act)
            @test m isa CC.LLVM.Module
            @test m.ref != C_NULL
            CC.LLVM.dispose(m)  # takeModule transfers ownership to us
            dispose(act)
            dispose(instance)
            CC.LLVM.dispose(llvm_ctx)
        end
    end
end

@testset "value printing, clear and owning interpreter" begin
    I = create_interpreter(String[])
    CC.parse(I, "int mv_value_probe = 7;")
    f = DeclFinder(I)
    @test f(I, "mv_value_probe")
    qt = CC.getType(CC.VarDecl(get_decl(f).ptr))

    v = CC.createValueFromType(I.interp, qt)
    @test !CC.is_null_handle(CC.getInterpreter(v))
    @test CC.getInterpreter(v).ptr == I.interp.ptr
    @test !CC.is_null_handle(CC.getASTContext(v))
    @test CC.getASTContext(v).ptr != C_NULL

    # clang 18 ships placeholder bodies for these three, so only the shape is stable
    @test !isempty(CC.print(v))
    @test !isempty(CC.printData(v))
    @test !isempty(CC.printType(v))
    @test CC.dump(v) === nothing

    # clear() resets the kind, the opaque type and the owning interpreter
    @test CC.clear(v) === nothing
    @test CC.getKind(v) == CC.LibClangEx.CXValue_Unspecified
    @test CC.isValid(v) == false
    @test CC.isManuallyAlloc(v) == false
    @test CC.getInterpreter(v).ptr == C_NULL
    # with no interpreter left the AST-context accessor must refuse instead of faulting
    @test_throws AssertionError CC.getASTContext(v)

    dispose(v)
    dispose(f)
    dispose(I)
end

@testset "default-constructed value carries no interpreter" begin
    v = CC.create_value()
    @test CC.is_null_handle(CC.getInterpreter(v))
    @test CC.getInterpreter(v).ptr == C_NULL
    @test_throws AssertionError CC.getASTContext(v)
    dispose(v)
end
