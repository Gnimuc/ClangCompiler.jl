# DependencyCollector
"""
    DependencyCollector() -> DependencyCollector
Build a collector that records every file a translation unit reads.

Attach it to a preprocessor before the parse and read the list back afterwards — the answer
to "which headers would invalidate this cached translation unit", which nothing else in this
package can produce. The base class already keeps every user header and drops `<built-in>`
and system files.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function DependencyCollector()
    dc = clang_DependencyCollector_create()
    @assert dc != C_NULL "Failed to create DependencyCollector"
    return DependencyCollector(dc)
end

"""
    DependencyFileGenerator(opts::AbstractDependencyOutputOptions) -> DependencyFileGenerator
Build a collector that also writes a make-style `.d` file when the main file finishes.

Everything it needs is copied out of `opts` here — the output path, the targets and the four
inclusion flags — so `opts` may be released or reused afterwards.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function DependencyFileGenerator(opts::AbstractDependencyOutputOptions)
    @check_ptrs opts
    dc = clang_DependencyFileGenerator_create(opts)
    @assert dc != C_NULL "Failed to create DependencyFileGenerator"
    return DependencyFileGenerator(dc)
end

"""
    dispose(x::AbstractDependencyCollector)
Release a collector of either class.

Nothing it was attached to may still be running: `attachToPreprocessor` installs
`PPCallbacks` that hold this pointer and are owned by the preprocessor, so the collector has
to outlive every preprocessor it was attached to.
"""
dispose(x::AbstractDependencyCollector) = clang_DependencyCollector_dispose(x)

"""
    attachToPreprocessor(x::AbstractDependencyCollector, pp::Preprocessor)
Install the collector's callbacks on `pp`, so every file the preprocessor opens from now on
is offered to it.

Not an adoption — the preprocessor owns the callback object it builds, not the collector —
but it does create the lifetime constraint [`dispose`](@ref) documents.
"""
function attachToPreprocessor(x::AbstractDependencyCollector, pp::Preprocessor)
    @check_ptrs x pp
    return clang_DependencyCollector_attachToPreprocessor(x, pp)
end

"""
    getDependenciesNum(x::AbstractDependencyCollector) -> UInt32
How many distinct files the collector has recorded.
"""
function getDependenciesNum(x::AbstractDependencyCollector)
    @check_ptrs x
    return clang_DependencyCollector_getDependenciesNum(x)
end

"""
    getDependency(x::AbstractDependencyCollector, i::Integer) -> String
The `i`-th recorded file (0-origin), in the order the collector first saw it.
"""
function getDependency(x::AbstractDependencyCollector, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getDependenciesNum(x) "dependency index $i out of range"
    return get_string(clang_DependencyCollector_getDependency(x, i))
end

"""
    getDependencies(x::AbstractDependencyCollector) -> Vector{String}
Every recorded file, in the order the collector first saw each one.
"""
function getDependencies(x::AbstractDependencyCollector)
    @check_ptrs x
    # Int() first: the count is a C `unsigned`, and `0:(UInt32(0) - 1)` is four billion
    # iterations rather than the empty range an empty list wants.
    return [getDependency(x, i) for i in 0:(Int(getDependenciesNum(x)) - 1)]
end

"""
    needSystemDependencies(x::AbstractDependencyCollector) -> Bool
Whether the collector wants system headers offered to it as well. `false` for a plain
collector; a [`DependencyFileGenerator`](@ref) answers with its options'
`IncludeSystemHeaders`.
"""
function needSystemDependencies(x::AbstractDependencyCollector)
    @check_ptrs x
    return clang_DependencyCollector_needSystemDependencies(x)
end

"""
    maybeAddDependency(x::AbstractDependencyCollector, filename::AbstractString; from_module=false, is_system=false, is_module_file=false, is_missing=false)
Offer one filename to the collector exactly as the preprocessor callbacks would, honouring
its filter and its already-seen set. Lets a caller seed or extend the list without a parse.
"""
function maybeAddDependency(x::AbstractDependencyCollector, filename::AbstractString;
                            from_module::Bool=false, is_system::Bool=false,
                            is_module_file::Bool=false, is_missing::Bool=false)
    @check_ptrs x
    return clang_DependencyCollector_maybeAddDependency(x, filename, from_module, is_system,
                                                        is_module_file, is_missing)
end

"""
    finishedMainFile(x::AbstractDependencyFileGenerator, diags::AbstractDiagnosticsEngine)
Write the dependency file.

Problems opening the output path are reported through `diags`; with an empty output path
nothing is written. Typed at the generator, not at the collector: the base class's
`finishedMainFile` does nothing, so accepting a plain collector here would be a call that
silently does nothing rather than one that fails.
"""
function finishedMainFile(x::AbstractDependencyFileGenerator,
                          diags::AbstractDiagnosticsEngine)
    @check_ptrs x diags
    return clang_DependencyFileGenerator_finishedMainFile(x, diags)
end

# createInvocation
"""
    createInvocation(src, args=String[]; diag=DiagnosticsEngine(), recover_on_error=false, probe_precompiled=false, capture_cc1_args=false)

Run the driver over `args` plus the source file `src` and return the `CompilerInvocation` a
`-cc1` subprocess would have been given.

This is the option-carrying entry point; [`createFromCommandLine`](@ref) keeps the older,
flag-only signature. As there, the caller passes flags and the source path only: the driver
name `clang` is supplied here, because `clang::createInvocation` reads `Args[0]` as the
executable and a caller who put a flag there would lose that flag silently rather than see a
diagnostic.

`recover_on_error` asks for a possibly-incorrect invocation instead of a failure when the
command line does not fully parse. `probe_precompiled` lets the driver look for `X.h.pch`
beside an `-include X.h` and rewrite it to `-include-pch`, which is the command-line route to
consuming a precompiled header; clang's own default for it is `false`.

Returns `nothing` when no invocation could be determined. With `capture_cc1_args` it returns
the pair `(invocation, cc1_args)` instead, and the driver fills that argument list in even in
some cases where it produces no invocation, so it is worth asking for on a failure.

The invocation is caller-owned; release it with `dispose`.
"""
function createInvocation(src::AbstractString, args::Vector{String}=String[];
                          diag::DiagnosticsEngine=DiagnosticsEngine(),
                          recover_on_error::Bool=false, probe_precompiled::Bool=false,
                          capture_cc1_args::Bool=false)
    @check_ptrs diag
    argv = ["clang"; args; String(src)]
    if capture_cc1_args
        cc1 = Ref{Ptr{CXStringSet}}(C_NULL)
        ptr = clang_createInvocation(argv, length(argv), diag, recover_on_error,
                                     probe_precompiled, cc1)
        invocation = ptr == C_NULL ? nothing : CompilerInvocation(ptr)
        return invocation, get_string(cc1[])
    end
    ptr = clang_createInvocation(argv, length(argv), diag, recover_on_error,
                                 probe_precompiled, C_NULL)
    return ptr == C_NULL ? nothing : CompilerInvocation(ptr)
end
