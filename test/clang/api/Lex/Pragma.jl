using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

# The pragma handler tree. Everything here is built on a throwaway CompilerInstance: a
# handler registered with a preprocessor is OWNED by it, so a live interpreter must never
# be handed one that this file then disposes.

"A CompilerInstance carried far enough to own a Preprocessor, and nothing further."
function pragma_bare_instance()
    ci = CC.CompilerInstance()
    CC.createDiagnostics(ci)
    CC.createFileManager(ci)
    CC.createSourceManager(ci, CC.getFileManager(ci))
    topts = CC.TargetOptions()
    CC.setTriple(topts, "x86_64-unknown-linux-gnu")
    CC.setTarget(ci, CC.TargetInfo(topts, CC.getDiagnostics(ci)))  # absorbs topts
    CC.createPreprocessor(ci)
    return ci
end

@testset "PragmaNamespace | the handler table" begin
    ns = CC.PragmaNamespace("probe_ns")
    @test CC.getName(ns) == "probe_ns"
    @test CC.IsEmpty(ns)
    # getIfNamespace is clang's RTTI-free downcast: a namespace answers with itself
    inner = CC.getIfNamespace(ns)
    @test inner !== nothing
    @test inner.ptr == ns.ptr

    h = CC.EmptyPragmaHandler("noisy")
    @test CC.getName(h) == "noisy"
    # ... and a plain handler answers that it is not one
    @test CC.getIfNamespace(h) === nothing

    CC.AddPragma(ns, h)
    @test CC.IsEmpty(ns) == false
    found = CC.FindHandler(ns, "noisy")
    @test found !== nothing
    @test found.ptr == h.ptr
    @test CC.getName(found) == "noisy"
    @test CC.FindHandler(ns, "absent") === nothing
    # with no null handler registered, the fallback finds nothing either
    @test CC.FindHandler(ns, "absent"; ignore_null=false) === nothing

    # the null handler is the one registered under the empty name, and it is what the
    # fallback -- and only the fallback -- returns for an unmatched name
    nullh = CC.EmptyPragmaHandler()
    @test CC.getName(nullh) == ""
    CC.AddPragma(ns, nullh)
    @test CC.FindHandler(ns, "absent") === nothing
    fallback = CC.FindHandler(ns, "absent"; ignore_null=false)
    @test fallback !== nothing
    @test fallback.ptr == nullh.ptr

    # registering twice under one name is refused before clang's assert is reached, and so
    # is unregistering a handler that merely shares a name with the registered one --
    # clang's own remove looks the entry up by name and would release the wrong object
    dup = CC.EmptyPragmaHandler("noisy")
    @test_throws AssertionError CC.AddPragma(ns, dup)
    @test_throws AssertionError CC.RemovePragmaHandler(ns, dup)
    dispose(dup)                      # never registered, so still ours

    # removal releases ownership back to us, which is what makes disposing legal again
    CC.RemovePragmaHandler(ns, h)
    @test CC.FindHandler(ns, "noisy") === nothing
    dispose(h)
    CC.RemovePragmaHandler(ns, nullh)
    dispose(nullh)
    @test CC.IsEmpty(ns)

    dispose(ns)
end

@testset "Preprocessor | registering and reclaiming a pragma handler" begin
    ci = pragma_bare_instance()
    pp = CC.getPreprocessor(ci)

    # top level, then inside a namespace the registration creates
    h = CC.EmptyPragmaHandler("probe_pragma")
    @test CC.AddPragmaHandler(pp, h) === nothing
    @test CC.RemovePragmaHandler(pp, h) === nothing
    # the handler came back intact rather than being deleted under us, which is the whole
    # difference between clang's remove and a drop
    @test CC.getName(h) == "probe_pragma"
    dispose(h)

    inner = CC.EmptyPragmaHandler("inner")
    @test CC.AddPragmaHandler(pp, inner, "probe_space") === nothing
    @test CC.RemovePragmaHandler(pp, inner, "probe_space") === nothing
    @test CC.getName(inner) == "inner"
    dispose(inner)

    # a namespace of our own can be installed whole and reclaimed whole; while it is out
    # on loan its own table still answers
    ns = CC.PragmaNamespace("probe_space2")
    leaf = CC.EmptyPragmaHandler("leaf")
    CC.AddPragma(ns, leaf)
    CC.AddPragmaHandler(pp, ns)
    @test CC.FindHandler(ns, "leaf") !== nothing
    CC.RemovePragmaHandler(pp, ns)
    @test CC.IsEmpty(ns) == false
    dispose(ns)                      # takes `leaf` with it

    dispose(ci)
end
