# PartialTranslationUnit
"""
    getTUPart(x::AbstractPartialTranslationUnit) -> TranslationUnitDecl
Return the translation unit holding just this increment's declarations.

`clang::PartialTranslationUnit` is a two-field struct rather than a class, so this and
[`getModule`](@ref) read members rather than call accessors. The handle points into the
interpreter's increment list and is invalidated by [`undo`](@ref).
"""
function getTUPart(x::AbstractPartialTranslationUnit)
    @check_ptrs x
    return TranslationUnitDecl(clang_PartialTranslationUnit_getTUPart(x))
end

"""
    getModule(x::AbstractPartialTranslationUnit) -> Union{Nothing,LLVM.Module}
Return the IR module generated for this increment, borrowed, or `nothing` once there is
none.

Executing the increment hands its module to the JIT, so this answers `nothing` afterwards —
inspect the IR before [`Execute`](@ref), not after. The absence is returned rather than
wrapped because `LLVM.Module` rejects a null reference outright, which would turn a
documented state of the increment into an error.
"""
function getModule(x::AbstractPartialTranslationUnit)
    @check_ptrs x
    m = clang_PartialTranslationUnit_getModule(x)
    return m == C_NULL ? nothing : LLVM.Module(m)
end
