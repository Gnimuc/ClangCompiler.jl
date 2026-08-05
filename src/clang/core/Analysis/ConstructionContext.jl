# Local abstract type: clang::ConstructionContext heads a standalone hierarchy in
# clang/Analysis/ConstructionContext.h with no Clang base outside it, so it is not part
# of core/abstract.jl.
abstract type AbstractConstructionContext end

"""
    struct ConstructionContext <: AbstractConstructionContext
Hold a pointer to a `clang::ConstructionContext` object.

The pointee is allocated from the arena of the `CFG` whose element produced it: the
handle is borrowed, there is no `dispose`, and `dispose(::CFG)` invalidates it.

`clang::ConstructionContext` is an abstract base with twelve concrete subclasses, but
this is deliberately the only carrier for the whole hierarchy. Every wrapper in
`api/Analysis/ConstructionContext.jl` is backed by a C function that `dyn_cast`s to the
subclass declaring the accessor and answers NULL on any other kind, so those wrappers
are total at the base and Invariant 2 holds without a carrier per subclass. Branch on
`getKind` (or on a NULL-pointer result) to learn which payload a context carries.
"""
struct ConstructionContext <: AbstractConstructionContext
    ptr::CXConstructionContext
end
