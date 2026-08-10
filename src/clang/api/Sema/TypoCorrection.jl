# CorrectionCandidateCallback
"""
    CorrectionCandidateCallback(kind::CXCorrectionCandidateCallbackKind, sema::AbstractSema; num_args::Integer=0, has_explicit_template_args::Bool=false) -> CorrectionCandidateCallback
Build one of clang's three concrete correction filters — what decides whether a near-miss
name is an acceptable suggestion.

Only these three are reachable: the filter is a virtual interface, and a Julia-authored one
would need a callback trampoline this package does not have. `num_args` and
`has_explicit_template_args` are read only by the `FunctionCall` kind.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function CorrectionCandidateCallback(kind::CXCorrectionCandidateCallbackKind, sema::AbstractSema;
                                     num_args::Integer=0, has_explicit_template_args::Bool=false)
    @check_ptrs sema
    return CorrectionCandidateCallback(clang_CorrectionCandidateCallback_create(kind, sema, num_args,
                                                                                has_explicit_template_args))
end

dispose(x::CorrectionCandidateCallback) = clang_CorrectionCandidateCallback_dispose(x)

# TypoCorrection
"""
    CorrectTypo(sema::AbstractSema, typo::AbstractDeclarationNameInfo, lookup_kind::CXLookupNameKind, scope::AbstractScope, ss::AbstractCXXScopeSpec, ccc::AbstractCorrectionCandidateCallback; mode::CXCorrectTypoKind=LibClangEx.CXCorrectTypoKind_CTK_ErrorRecovery, member_context=nothing, entering_context::Bool=false, record_failure::Bool=true) -> TypoCorrection
Look for a declaration whose name is near `typo`'s and that `ccc` accepts — the "did you
mean" suggestion clang makes for a failed lookup.

The result is always a `TypoCorrection`, never `nothing`: [`isEmpty`](@ref) is what says
nothing was found. `mode` decides whether clang records the failure so later attempts on the
same name are suppressed.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function CorrectTypo(sema::AbstractSema, typo::AbstractDeclarationNameInfo,
                     lookup_kind::CXLookupNameKind, scope::AbstractScope,
                     ss::AbstractCXXScopeSpec, ccc::AbstractCorrectionCandidateCallback;
                     mode::CXCorrectTypoKind=LibClangEx.CXCorrectTypoKind_CTK_ErrorRecovery,
                     member_context::AnyDeclContext=DeclContext(C_NULL),
                     entering_context::Bool=false, record_failure::Bool=true)
    @check_ptrs sema typo scope ss ccc
    return TypoCorrection(clang_Sema_CorrectTypo(sema, typo, lookup_kind, scope, ss, ccc, mode,
                                                 member_context, entering_context, record_failure))
end

dispose(x::TypoCorrection) = clang_TypoCorrection_dispose(x)

"""
    isEmpty(x::AbstractTypoCorrection) -> Bool
Return whether the correction names nothing — what a lookup that found no near miss gives.
"""
function isEmpty(x::AbstractTypoCorrection)
    @check_ptrs x
    return clang_TypoCorrection_isEmpty(x)
end

"""
    isResolved(x::AbstractTypoCorrection) -> Bool
Return whether the correction reached a keyword or at least one declaration. A non-empty
correction that is unresolved is a name clang suggests without having found what it names.
"""
function isResolved(x::AbstractTypoCorrection)
    @check_ptrs x
    return clang_TypoCorrection_isResolved(x)
end

function isOverloaded(x::AbstractTypoCorrection)
    @check_ptrs x
    return clang_TypoCorrection_isOverloaded(x)
end

function getCorrection(x::AbstractTypoCorrection)
    @check_ptrs x
    return DeclarationName(clang_TypoCorrection_getCorrection(x))
end

"""
    getAsString(x::AbstractTypoCorrection, opts::AbstractLangOptions) -> String
Return the suggested spelling. The language options are needed because the rendering depends
on them.
"""
function getAsString(x::AbstractTypoCorrection, opts::AbstractLangOptions)
    @check_ptrs x opts
    return get_string(clang_TypoCorrection_getAsString(x, opts))
end

"""
    getEditDistance(x::AbstractTypoCorrection, normalized::Bool=true) -> UInt32
Return the edit distance from the typo to the suggestion, in single-character edits.

Passing `false` gives clang's internal weighted sum instead — character, qualifier and
callback distances each scaled by their own weight — which is the form it ranks candidates
by, and is a hundred times larger per character edit. Either way an unreachable correction
comes back as clang's `InvalidDistance` rather than a real count.
"""
function getEditDistance(x::AbstractTypoCorrection, normalized::Bool=true)
    @check_ptrs x
    return clang_TypoCorrection_getEditDistance(x, normalized)
end

"""
    getCorrectionDecl(x::AbstractTypoCorrection) -> NamedDecl
Return the declaration the correction names, or a carrier holding `NULL` when it corrects to
a keyword or names nothing.
"""
function getCorrectionDecl(x::AbstractTypoCorrection)
    @check_ptrs x
    return NamedDecl(clang_TypoCorrection_getCorrectionDecl(x))
end

function isKeyword(x::AbstractTypoCorrection)
    @check_ptrs x
    return clang_TypoCorrection_isKeyword(x)
end
