# ArgumentsAdjuster
#
# Every factory here allocates a boxed `std::function`, so each pairs with `dispose`. Handing
# one to a `ClangTool` or to `buildASTFromCodeWithArgs` copies the closure rather than
# adopting the box, so the handle stays the caller's in both cases.

"""
    getClangSyntaxOnlyAdjuster() -> ArgumentsAdjuster
Return the adjuster that rewrites a command line into its "syntax check only" form:
`-fsyntax-only`, with the flags that would have produced output dropped.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getClangSyntaxOnlyAdjuster()
    ptr = clang_tooling_getClangSyntaxOnlyAdjuster()
    @assert ptr != C_NULL "Failed to create ArgumentsAdjuster"
    return ArgumentsAdjuster(ptr)
end

"""
    getClangStripOutputAdjuster() -> ArgumentsAdjuster
Return the adjuster that removes the output-related flags (`-o` and its family).

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getClangStripOutputAdjuster()
    ptr = clang_tooling_getClangStripOutputAdjuster()
    @assert ptr != C_NULL "Failed to create ArgumentsAdjuster"
    return ArgumentsAdjuster(ptr)
end

"""
    getClangStripDependencyFileAdjuster() -> ArgumentsAdjuster
Return the adjuster that removes the dependency-file flags (`-M`, `-MF`, `-MD` and friends).

This is the adjuster [`buildASTFromCodeWithArgs`](@ref) applies when none is supplied.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getClangStripDependencyFileAdjuster()
    ptr = clang_tooling_getClangStripDependencyFileAdjuster()
    @assert ptr != C_NULL "Failed to create ArgumentsAdjuster"
    return ArgumentsAdjuster(ptr)
end

"""
    getStripPluginsAdjuster() -> ArgumentsAdjuster
Return the adjuster that removes the plugin-related flags (`-load`, `-plugin`, `-add-plugin`
and their `-Xclang` spellings).

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getStripPluginsAdjuster()
    ptr = clang_tooling_getStripPluginsAdjuster()
    @assert ptr != C_NULL "Failed to create ArgumentsAdjuster"
    return ArgumentsAdjuster(ptr)
end

"""
    getInsertArgumentAdjuster(extra::AbstractString,
                              pos::CXArgumentInsertPosition=CXArgumentInsertPosition_END)
    -> ArgumentsAdjuster
Return the adjuster that inserts `extra` at `pos`. `CXArgumentInsertPosition_BEGIN` puts it
right after `argv[0]`, which is where a `-x` or `-std=` belongs; `_END` appends it.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getInsertArgumentAdjuster(extra::AbstractString,
                                   pos::CXArgumentInsertPosition=CXArgumentInsertPosition_END)
    ptr = clang_tooling_getInsertArgumentAdjuster(extra, pos)
    @assert ptr != C_NULL "Failed to create ArgumentsAdjuster"
    return ArgumentsAdjuster(ptr)
end

"""
    getInsertArgumentAdjuster(extra::AbstractVector{<:String},
                              pos::CXArgumentInsertPosition=CXArgumentInsertPosition_END)
    -> ArgumentsAdjuster
The list overload: inserts all of `extra`, in order, at `pos`.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getInsertArgumentAdjuster(extra::AbstractVector{<:String},
                                   pos::CXArgumentInsertPosition=CXArgumentInsertPosition_END)
    ptr = clang_tooling_getInsertArgumentAdjusterForArgs(extra, length(extra), pos)
    @assert ptr != C_NULL "Failed to create ArgumentsAdjuster"
    return ArgumentsAdjuster(ptr)
end

"""
    combineAdjusters(first_adjuster::AbstractArgumentsAdjuster,
                     second_adjuster::AbstractArgumentsAdjuster) -> ArgumentsAdjuster
Return the adjuster that runs `first_adjuster` and then `second_adjuster` on its result.

Both arguments are only read — the combination owns its own copies of the two closures — so
each still has to be disposed by whoever created it.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function combineAdjusters(first_adjuster::AbstractArgumentsAdjuster,
                          second_adjuster::AbstractArgumentsAdjuster)
    @check_ptrs first_adjuster second_adjuster
    ptr = clang_tooling_combineAdjusters(first_adjuster, second_adjuster)
    @assert ptr != C_NULL "Failed to create ArgumentsAdjuster"
    return ArgumentsAdjuster(ptr)
end

dispose(x::ArgumentsAdjuster) = clang_ArgumentsAdjuster_dispose(x)

"""
    adjust(x::AbstractArgumentsAdjuster, args::AbstractVector{<:String},
           filename::AbstractString) -> Vector{String}
Apply `x` to `args` as if `filename` were the file being compiled, and return the adjusted
command line.

Clang's own callers only ever run an adjuster inside a tool; this exposes it directly, which
is the way to see what a chain of adjusters does to a command line without parsing anything.

`args` must not be empty. An adjuster built with `CXArgumentInsertPosition_BEGIN` steps over
`argv[0]` before inserting, which walks off the end of an empty vector, and the handle does
not carry the position it was built with — so the refusal covers every adjuster rather than
the ones it can be shown to matter for.
"""
function adjust(x::AbstractArgumentsAdjuster, args::AbstractVector{<:String},
                filename::AbstractString)
    @check_ptrs x
    @assert !isempty(args) "an adjuster runs on a command line, whose first entry is argv[0]"
    return get_string(clang_ArgumentsAdjuster_adjust(x, args, length(args), filename))
end
