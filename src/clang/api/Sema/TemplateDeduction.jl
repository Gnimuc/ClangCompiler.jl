# TemplateDeductionInfo
"""
    TemplateDeductionInfo(loc::SourceLocation, deduced_depth::Integer=0) -> TemplateDeductionInfo
Return a freshly created template-deduction report — the out-parameter every `Sema` deduction
entry point fills in. This function allocates and one should call `dispose` to release the
resources after using this object.

`deduced_depth` is the template-parameter depth deduction runs at; it is 0 for a deduction
started outside an enclosing template.
"""
function TemplateDeductionInfo(loc::SourceLocation, deduced_depth::Integer=0)
    return TemplateDeductionInfo(clang_TemplateDeductionInfo_create(loc, deduced_depth))
end

dispose(x::TemplateDeductionInfo) = clang_TemplateDeductionInfo_dispose(x)

function getLocation(x::AbstractTemplateDeductionInfo)
    @check_ptrs x
    return SourceLocation(clang_TemplateDeductionInfo_getLocation(x))
end

function getDeducedDepth(x::AbstractTemplateDeductionInfo)
    @check_ptrs x
    return clang_TemplateDeductionInfo_getDeducedDepth(x)
end

function getNumExplicitArgs(x::AbstractTemplateDeductionInfo)
    @check_ptrs x
    return clang_TemplateDeductionInfo_getNumExplicitArgs(x)
end

"""
    hasSFINAEDiagnostic(x::AbstractTemplateDeductionInfo) -> Bool
Return whether deduction suppressed an error under SFINAE and stored it in the report.
"""
function hasSFINAEDiagnostic(x::AbstractTemplateDeductionInfo)
    @check_ptrs x
    return clang_TemplateDeductionInfo_hasSFINAEDiagnostic(x)
end

"""
    takeSugared(x::AbstractTemplateDeductionInfo) -> TemplateArgumentList
Return the deduced argument list with the sugar deduction saw, transferring it out of `x`:
a second call yields a NULL carrier. The list is `ASTContext` memory and is never disposed,
and the carrier holds NULL until a deduction has filled it in.
"""
function takeSugared(x::AbstractTemplateDeductionInfo)
    @check_ptrs x
    return TemplateArgumentList(clang_TemplateDeductionInfo_takeSugared(x))
end

"""
    takeCanonical(x::AbstractTemplateDeductionInfo) -> TemplateArgumentList
The canonical form of [`takeSugared`](@ref), transferred out of `x` the same way.
"""
function takeCanonical(x::AbstractTemplateDeductionInfo)
    @check_ptrs x
    return TemplateArgumentList(clang_TemplateDeductionInfo_takeCanonical(x))
end

"""
    getCallArgIndex(x::AbstractTemplateDeductionInfo) -> Integer
Return the index of the call argument the mismatch was about. Reads 0 unless the deduction
returned `CXTemplateDeductionResult_TDK_DeducedMismatch`.
"""
function getCallArgIndex(x::AbstractTemplateDeductionInfo)
    @check_ptrs x
    return clang_TemplateDeductionInfo_getCallArgIndex(x)
end
