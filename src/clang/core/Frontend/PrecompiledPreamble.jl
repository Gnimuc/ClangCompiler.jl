"""
    struct PreambleBounds <: Any
Where a buffer's preamble — its leading run of `#include`s and other directives — ends.

`clang::PreambleBounds` is a pure aggregate of exactly these two fields, so — like
[`SourceRange`](@ref) — it is reproduced structurally in Julia instead of crossing the C
boundary as a handle.
"""
struct PreambleBounds
    "Size of the preamble in bytes."
    size::UInt32
    "Whether the preamble ends at the start of a new line."
    ends_at_start_of_line::Bool
end

"""
    struct PrecompiledPreamble <: AbstractPrecompiledPreamble
Hold a pointer to a `clang::PrecompiledPreamble` object.

The handle also owns the two things `clang::PrecompiledPreamble` expects its caller to keep
alive — the virtual file system it was built against and the main-file buffer the last
[`AddImplicitPreamble`](@ref) or [`OverridePreamble`](@ref) remapped — so the object must
outlive both the compiler run that consumes it and the AST that run builds.
"""
struct PrecompiledPreamble <: AbstractPrecompiledPreamble
    ptr::CXPrecompiledPreamble
end
