using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: LLVM, getMessage, create_irgenerator, create_compiler, take_module, has_module, compile, link_process_symbols, get_function_pointer, get_symbol_address, get_jit, get_dylib, get_instance, get_context, get_irgenerator, dispose
using Test

# The batch drivers: `IRGenerator` (source in, one LLVM module out) and `CxxCompiler`
# (that module on an LLJIT). Both run a real frontend, so every assertion below is on
# something clang or LLVM decided.
#
# Two things this file must not assert, because CI runs macOS, Linux and Windows:
# a mangled name (the interpreter's standard library is libc++ on macOS and libstdc++
# elsewhere) and anything the host target decides. Every snippet here is `extern "C"`
# for the first reason; the one target-dependent assertion pins `PIN_TRIPLE`, which is
# the same target test/clang/pinned_target.jl pins so the suite downloads one shard.

const IRGEN_ERR = CC.CXTextDiagnosticBuffer_Error
const IRGEN_WARN = CC.CXTextDiagnosticBuffer_Warning
const PIN_TRIPLE = "x86_64-linux-gnu"

"Compile `code` and hand back its module's IR as text, disposing everything else."
function irgen_text(code; kwargs...)
    gen = create_irgenerator(code; kwargs...)
    mod = take_module(gen)
    text = string(mod)
    LLVM.dispose(mod)
    dispose(gen)
    return text
end

"Whether `code` compiles, with its diagnostics swallowed rather than printed."
function irgen_compiles(code; kwargs...)
    buf = CC.TextDiagnosticBuffer()
    try
        gen = create_irgenerator(code; diag_consumer=buf, kwargs...)
        dispose(gen)
        return true
    catch
        return false
    finally
        dispose(buf)
    end
end

@testset "IRGenerator | the module holds what the source defined" begin
    gen = create_irgenerator("""
        extern "C" int irg_elsewhere();
        extern "C" int irg_add(int a, int b) { return a + b; }
        extern "C" int irg_calls() { return irg_elsewhere(); }
    """)
    # The module belongs to the generator until it is taken.
    @test has_module(gen)
    mod = take_module(gen)
    @test !has_module(gen)

    # Clang emits a body for what the snippet defined and a bare declaration for what it
    # only referenced -- the partition is the frontend's decision, not this wrapper's.
    bodies = Dict{String,Bool}()
    for f in LLVM.functions(mod)
        bodies[LLVM.name(f)] = !isempty(LLVM.blocks(f))
    end
    @test bodies["irg_add"] == true
    @test bodies["irg_calls"] == true
    @test bodies["irg_elsewhere"] == false

    # The module is named after the main file, which is the one this call named -- so this
    # also says the in-memory buffer was mapped in under that name and found.
    @test LLVM.name(mod) == "input.cc"

    LLVM.dispose(mod)

    # Moved out, there is nothing left to hand over.
    @test_throws ErrorException take_module(gen)
    dispose(gen)
end

@testset "IRGenerator | the snippet is the source, not the file of that name" begin
    # `filename` names a file clang never opens: the snippet is mapped in over it. Pointing
    # it at a file that really exists and holds something else is what shows which of the two
    # was compiled.
    mktempdir() do dir
        path = joinpath(dir, "irg_real.cpp")
        write(path, """extern "C" int irg_from_disk() { return 1; }\n""")

        text = irgen_text("""extern "C" int irg_from_memory() { return 2; }"""; filename=path)
        @test occursin("@irg_from_memory", text)
        @test !occursin("@irg_from_disk", text)
        # and the file itself is untouched
        @test occursin("irg_from_disk", read(path, String))
    end

    # A name with nothing behind it at all works the same way: clang's driver is told not to
    # check that its inputs exist, and the remapping creates the file entry rather than
    # looking one up.
    text = irgen_text("""extern "C" int irg_nowhere() { return 3; }"""; filename="no_such_dir/no_such_file.cpp")
    @test occursin("@irg_nowhere", text)
end

@testset "IRGenerator | the flags reach clang" begin
    # -O2 versus the default is the optimiser answering: the stack slots a plain frontend
    # emits for the parameters are gone once mem2reg has run.
    plain = irgen_text("""extern "C" int irg_o(int a, int b) { return a + b; }""")
    opt = irgen_text("""extern "C" int irg_o(int a, int b) { return a + b; }"""; args=["-O2"])
    @test occursin("alloca", plain)
    @test !occursin("alloca", opt)

    # -D reaches the preprocessor, and the snippet insists on it.
    guarded = """
        #ifndef IRG_D
        #error IRG_D was not defined
        #endif
        extern "C" int irg_d() { return IRG_D; }
    """
    @test irgen_compiles(guarded; args=["-DIRG_D=7"])
    @test !irgen_compiles(guarded)

    # -Werror promotes this session's warnings. `int f() { }` falls off the end of a
    # non-void function, which is a warning clang has on by default on every target.
    buf = CC.TextDiagnosticBuffer()
    gen = create_irgenerator("int irg_noret() { }"; diag_consumer=buf)
    @test Base.size(buf, IRGEN_WARN) >= 1
    @test Base.size(buf, IRGEN_ERR) == 0
    dispose(gen)
    dispose(buf)
    @test !irgen_compiles("int irg_noret() { }"; args=["-Werror"])
end

@testset "IRGenerator | the language comes from `language`, and only from it" begin
    # A snippet that is C and is not C++. Compiling it under each in turn is the partition:
    # a `-x` that never reached clang would give the same answer twice.
    c_only = """
        #ifdef __cplusplus
        #error compiled as C++
        #endif
        int irg_c_only(void) { return 0; }
    """
    @test irgen_compiles(c_only; language=:c)
    @test !irgen_compiles(c_only; language=:cxx)

    # `language` is appended after `args`, so a `-x` of the caller's own is overridden
    # rather than honoured -- which is what the docstring promises.
    @test irgen_compiles(c_only; language=:c, args=["-x", "c++"])

    # Each language has a main-file name whose extension agrees with it, so a diagnostic
    # reads the way a compiler user expects. A snippet that is only C compiles under all
    # four, which is what makes this a check of the name rather than of the dialect -- the
    # Objective-C ones need no `-fobjc-runtime` because nothing here is an Objective-C
    # construct, so no runtime metadata is emitted.
    for (language, name) in pairs(CC.SOURCE_NAMES)
        gen = create_irgenerator("int irg_lang(void) { return 0; }"; language)
        mod = take_module(gen)
        @test LLVM.name(mod) == name
        LLVM.dispose(mod)
        dispose(gen)
    end

    @test_throws ArgumentError create_irgenerator("int f(void){return 0;}"; language=:fortran)
end

@testset "IRGenerator | a pinned triple emits for that target, not this machine" begin
    # The module carries the pinned target's triple and data layout, so these two equalities
    # read the same on all three runners. Only the IR crosses: nothing here executes.
    gen = create_irgenerator("""extern "C" long irg_size() { return sizeof(long); }"""; triple=PIN_TRIPLE)
    mod = take_module(gen)
    @test LLVM.triple(mod) == "x86_64-unknown-linux-gnu"
    # `p270`/`p271`/`p272` are the x86 address spaces, and `f80:128` is the x87 long double
    # -- neither appears in an AArch64 or a Windows layout string.
    layout = string(LLVM.datalayout(mod))
    @test occursin("p270:32:32", layout)
    @test occursin("f80:128", layout)
    LLVM.dispose(mod)
    dispose(gen)
end

@testset "IRGenerator | what fails, fails before anything is handed back" begin
    # Arguments the driver rejects are caught where they are reported, because the engine
    # that received them is about to be replaced.
    @test_throws ArgumentError create_irgenerator("int f(void){return 0;}"; args=["--irg-not-a-flag"])

    # A snippet that does not compile raises rather than handing back a generator with no
    # module in it.
    buf = CC.TextDiagnosticBuffer()
    @test_throws ErrorException create_irgenerator("int irg_bad() { return irg_nosuch; }"; diag_consumer=buf)
    # ... and a recording consumer is quoted in that error rather than only counted, so the
    # caller who swallowed the diagnostics still learns what clang said.
    @test Base.size(buf, IRGEN_ERR) == 1
    err = try
        create_irgenerator("int irg_bad2() { return irg_nosuch; }"; diag_consumer=buf)
        nothing
    catch e
        sprint(showerror, e)
    end
    @test err !== nothing
    @test occursin("irg_nosuch", err)
    dispose(buf)

    # Arguments the driver rejects reach the consumer too, so a caller who passed one to
    # swallow clang's output is not left with a count and no text.
    argbuf = CC.TextDiagnosticBuffer()
    argerr = try
        create_irgenerator("int f(void){return 0;}"; args=["--irg-not-a-flag"], diag_consumer=argbuf)
        nothing
    catch e
        sprint(showerror, e)
    end
    @test argerr !== nothing
    @test occursin("--irg-not-a-flag", argerr)
    @test Base.size(argbuf, IRGEN_ERR) >= 1
    dispose(argbuf)

    # A driver-only flag is the other shape of a bad argument list: clang prints and builds no
    # compilation job, so there is no invocation to hand back. It reports as a rejected
    # argument list rather than as the assertion the wrapper raises underneath.
    @test_throws ArgumentError create_irgenerator("int f(void){return 0;}"; args=["-###"])
end

@testset "IRGenerator | the AST is freed rather than buried" begin
    # Clang's driver puts `-disable-free` on every cc1 line it builds, and the invocation keeps
    # it twice. Under the FrontendOptions copy, `EndSourceFile` unlinks the Sema and the
    # ASTContext without destroying them; under the CodeGenOptions one, `~EmitAssemblyHelper`
    # buries the TargetMachine. Sound for a process about to exit, a per-call leak inside a
    # Julia session. The leak itself shows only as RSS, which no assertion can pin -- what is
    # assertable is that this driver overrode the driver's choice, in both places.
    #
    # Building the same invocation by hand first is what makes that a partition: without the
    # "before" half, two `== false` assertions would pass just as happily if clang had never
    # set the flags at all.
    probe = CC.CompilerInstance()
    CC.setShowColors(probe, false)
    CC.createDiagnostics(probe)
    CC.setInvocation(probe, CC.createFromCommandLine("input.cc", CC.get_default_args(), CC.getDiagnostics(probe)))
    @test CC.getDisableFree(CC.getFrontendOpts(probe)) == true
    @test CC.getDisableFree(CC.getCodeGenOpts(probe)) == true
    dispose(probe)

    gen = create_irgenerator("""extern "C" int irg_df() { return 0; }""")
    @test CC.getDisableFree(CC.getFrontendOpts(get_instance(gen))) == false
    @test CC.getDisableFree(CC.getCodeGenOpts(get_instance(gen))) == false
    # ... and the neighbouring flag this driver deliberately leaves set, because releasing the
    # AST arena before codegen is what a driver that never traverses the AST wants
    @test CC.getClearASTBeforeBackend(CC.getCodeGenOpts(get_instance(gen))) == true
    dispose(gen)

    # ... and the frontend really did finish: the module came out, and the AST is gone either
    # way, which is what the docstring warns about.
    gen2 = create_irgenerator("""extern "C" int irg_df2() { return 0; }""")
    @test CC.hasASTContext(get_instance(gen2)) == false
    @test CC.hasSema(get_instance(gen2)) == false
    # the preprocessor and target outlive the action, and are what a diagnostic's
    # SourceLocation still resolves against
    @test CC.hasPreprocessor(get_instance(gen2)) == true
    @test CC.hasSourceManager(get_instance(gen2)) == true
    @test CC.hasTarget(get_instance(gen2)) == true
    mod = take_module(gen2)
    @test any(LLVM.name(f) == "irg_df2" for f in LLVM.functions(mod))
    LLVM.dispose(mod)
    dispose(gen2)
end

@testset "IRGenerator | a consumer used before does not condemn the next compile" begin
    # Clang's diagnostic consumers latch: `DiagnosticConsumer` counts its own errors and only
    # `clear` resets them. `CompilerInstance::ExecuteAction` reports success from that CLIENT
    # count rather than from the engine's, so a consumer reused across calls carries the first
    # call's verdict into the second -- a snippet that compiles cleanly is rejected, and the
    # error quotes a diagnostic from the previous compile. Only a reuse across a FAILING call
    # and then a PASSING one shows it; two failures in a row look identical either way.
    buf = CC.TextDiagnosticBuffer()
    @test_throws ErrorException create_irgenerator("int irg_r1() { return irg_nosuch; }"; diag_consumer=buf)
    @test Base.size(buf, IRGEN_ERR) == 1

    gen = create_irgenerator("""extern "C" int irg_r2() { return 1; }"""; diag_consumer=buf)
    mod = take_module(gen)
    @test any(LLVM.name(f) == "irg_r2" for f in LLVM.functions(mod))
    LLVM.dispose(mod)
    dispose(gen)

    # The clean call added nothing, and the messages the failing one left are still readable.
    @test Base.size(buf, IRGEN_ERR) == 1
    @test occursin("irg_nosuch", getMessage(buf, IRGEN_ERR, 0))

    # ... and a second failure quotes only its own diagnostic, not the earlier one.
    err = try
        create_irgenerator("int irg_r3() { return irg_other; }"; diag_consumer=buf)
        nothing
    catch e
        sprint(showerror, e)
    end
    @test err !== nothing
    @test occursin("irg_other", err)
    @test !occursin("irg_nosuch", err)
    dispose(buf)
end

@testset "CxxCompiler | JIT-compiled C++ agrees with Julia" begin
    cc = create_compiler("""
        #include <vector>

        static float irg_sum(std::vector<float> &data) {
            float acc = 0;
            for (float v : data) acc += v;
            return acc;
        }

        extern "C" float irg_c_sum(float* data, int n) {
            std::vector<float> vec(data, data + n);
            return irg_sum(vec);
        }
    """)
    compile(cc)

    v = Cfloat[1.5, -2.25, 3.0, 4.75, 0.5]
    p = get_function_pointer(cc, "irg_c_sum")
    @test ccall(p, Cfloat, (Ptr{Cfloat}, Cint), v, length(v)) == sum(v)

    # The two ways of naming the same symbol answer with the same address.
    @test Ptr{Cvoid}(get_symbol_address(cc, "irg_c_sum")) == p

    # The compiler forwards to the generator it was built on rather than holding its own.
    @test get_instance(cc) === get_instance(get_irgenerator(cc))
    @test get_context(cc) === get_context(get_irgenerator(cc))
    @test !has_module(cc)                    # `compile` took it

    # ... and taking it a second time is the same error the generator raises.
    @test_throws ErrorException compile(cc)
    dispose(cc)
end

@testset "CxxCompiler | the module can be inspected between the two halves" begin
    # The gap between "compiled" and "running" is what a batch driver has and an incremental
    # one does not: the whole unit arrives as one module, and `compile(cc, mod)` takes it back.
    cc = create_compiler("""extern "C" int irg_mul(int a, int b) { return a * b; }""")
    mod = take_module(cc)
    @test any(LLVM.name(f) == "irg_mul" for f in LLVM.functions(mod))

    # A function added by hand reaches the JIT with the rest of the module, which is the
    # point of handing the module back at all. The module's context has to be made the
    # active one first: an `IRGenerator` keeps it inside a `ThreadSafeContext`, which is a
    # different stack from the one `Int32Type()` and `IRBuilder()` read.
    LLVM.context!(LLVM.context(mod)) do
        i32 = LLVM.Int32Type()
        fn = LLVM.Function(mod, "irg_grafted", LLVM.FunctionType(i32, [i32]))
        entry = LLVM.BasicBlock(fn, "entry")
        builder = LLVM.IRBuilder()
        try
            LLVM.position!(builder, entry)
            LLVM.ret!(builder, LLVM.mul!(builder, LLVM.parameters(fn)[1], LLVM.ConstantInt(i32, 3)))
        finally
            LLVM.dispose(builder)
        end
    end

    compile(cc, mod)
    @test ccall(get_function_pointer(cc, "irg_mul"), Cint, (Cint, Cint), 6, 7) == 42
    @test ccall(get_function_pointer(cc, "irg_grafted"), Cint, (Cint,), 14) == 42
    dispose(cc)
end

@testset "CxxCompiler | process symbols are linked in, by default or by hand" begin
    # What the process search generator adds is *name resolution through ORC*, and the
    # partition is a process symbol the module never defines. Naming one before the generator
    # is added fails and after it succeeds; that is the only observable difference, which is
    # why this asserts on `malloc` rather than on a snippet that allocates.
    src = """
        #include <vector>
        extern "C" int irg_uses_new(int n) {
            std::vector<int> v(n, 1);
            int acc = 0;
            for (int x : v) acc += x;
            return acc;
        }
    """
    cc = create_compiler(src; link_process=false)
    compile(cc)
    @test_throws LLVM.LLVMException get_symbol_address(cc, "malloc")

    # Code that needs the C library runs anyway: LLJIT already has a process-symbols dylib in
    # the main dylib's link order, so a module's externals resolve against the host with or
    # without the generator, and only a direct lookup -- which searches the main dylib alone --
    # needs it. Asserting this is what stops the testset from reading as "the generator is what
    # makes C++ work", which it is not.
    @test ccall(get_function_pointer(cc, "irg_uses_new"), Cint, (Cint,), 9) == 9

    @test link_process_symbols(cc) === cc
    @test get_symbol_address(cc, "malloc") != 0

    # The dylib and the JIT are the JIT's, handed out for lookups rather than for disposal.
    @test get_dylib(cc).ref == LLVM.JITDylib(get_jit(cc)).ref
    dispose(cc)

    # And the default gets there without being asked.
    linked = create_compiler(src)
    compile(linked)
    @test get_symbol_address(linked, "malloc") != 0
    dispose(linked)
end

@testset "CxxCompiler | a failing snippet leaves nothing to dispose" begin
    buf = CC.TextDiagnosticBuffer()
    @test_throws ErrorException create_compiler("int irg_broken() { return irg_nope; }"; diag_consumer=buf)
    @test Base.size(buf, IRGEN_ERR) >= 1
    dispose(buf)
end

@testset "a failed construction leaves LLVM.jl's context stack where it found it" begin
    # An `LLVM.ThreadSafeContext` activates itself onto a task-local stack when it is created
    # and is popped only by `dispose`. A failure that dropped one would leave it active
    # forever, and a later `dispose` in this task would then be popping something that is no
    # longer on top -- an error raised by a call that has nothing to do with the failure.
    # Comparing the top of that stack across each failing call is what catches it.
    top() = (c=LLVM.ts_context(; throw_error=false); c === nothing ? nothing : c.ref)
    before = top()

    buf = CC.TextDiagnosticBuffer()
    @test_throws ErrorException create_irgenerator("int irg_s1() { return irg_no; }"; diag_consumer=buf)
    @test top() === before
    @test_throws ErrorException create_compiler("int irg_s2() { return irg_no; }"; diag_consumer=buf)
    @test top() === before
    # ... and for the two argument-rejection shapes, which fail before any context exists
    @test_throws ArgumentError create_irgenerator("int f(void){return 0;}"; args=["--irg-nope"], diag_consumer=buf)
    @test top() === before
    @test_throws ArgumentError create_irgenerator("int f(void){return 0;}"; args=["-###"], diag_consumer=buf)
    @test top() === before
    dispose(buf)

    # A live generator is on top while it exists, and off again once disposed -- which is what
    # makes the four assertions above discriminate rather than read `nothing === nothing`.
    gen = create_irgenerator("""extern "C" int irg_after() { return 1; }""")
    @test top() !== before
    dispose(gen)
    @test top() === before
end
