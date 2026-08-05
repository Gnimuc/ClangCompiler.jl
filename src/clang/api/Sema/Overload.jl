# StandardConversionSequence
#
# A `StandardConversionSequence` carrier is a borrowed interior pointer into the
# `ImplicitConversionSequence` that owns it. It dangles once that sequence is disposed or
# switched to another kind, so it must not outlive the call that produced it.

"""
    getFromType(x::AbstractStandardConversionSequence) -> QualType
Return the type this standard conversion sequence converts from.
"""
function getFromType(x::AbstractStandardConversionSequence)
    @check_ptrs x
    return QualType(clang_StandardConversionSequence_getFromType(x))
end

"""
    getToType(x::AbstractStandardConversionSequence, i::Integer) -> QualType
Return the type step `i` of this standard conversion sequence converts to.

`i` is 0-based and must be less than 3; the underlying C++ accessor asserts on it.
"""
function getToType(x::AbstractStandardConversionSequence, i::Integer)
    @check_ptrs x
    @assert 0 <= i < 3 "to-type index $i out of range"
    return QualType(clang_StandardConversionSequence_getToType(x, i))
end

function isIdentityConversion(x::AbstractStandardConversionSequence)
    @check_ptrs x
    return clang_StandardConversionSequence_isIdentityConversion(x)
end

# BadConversionSequence
#
# Also a borrowed interior pointer into the owning `ImplicitConversionSequence`.

function getFromType(x::AbstractBadConversionSequence)
    @check_ptrs x
    return QualType(clang_BadConversionSequence_getFromType(x))
end

function getToType(x::AbstractBadConversionSequence)
    @check_ptrs x
    return QualType(clang_BadConversionSequence_getToType(x))
end

# ImplicitConversionSequence

"""
    ImplicitConversionSequence() -> ImplicitConversionSequence
Create an *uninitialized* `clang::ImplicitConversionSequence`.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
ImplicitConversionSequence() = ImplicitConversionSequence(create_implicit_conversion_sequence())

"""
    create_implicit_conversion_sequence() -> CXImplicitConversionSequence
Return a pointer to a heap-allocated `clang::ImplicitConversionSequence` object.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function create_implicit_conversion_sequence()
    ics = clang_ImplicitConversionSequence_create()
    @assert ics != C_NULL "Failed to create ImplicitConversionSequence"
    return ics
end

dispose(x::ImplicitConversionSequence) = clang_ImplicitConversionSequence_dispose(x)

"""
    isInitialized(x::AbstractImplicitConversionSequence) -> Bool
Return whether a kind has been assigned to this conversion sequence.

A freshly created sequence carries a private `Uninitialized` sentinel that is outside
`CXImplicitConversionSequence_Kind`; every kind query below asserts against it.
"""
function isInitialized(x::AbstractImplicitConversionSequence)
    @check_ptrs x
    return clang_ImplicitConversionSequence_isInitialized(x)
end

"""
    getKind(x::AbstractImplicitConversionSequence) -> CXImplicitConversionSequence_Kind
Return which arm of the conversion-sequence union is live.
"""
function getKind(x::AbstractImplicitConversionSequence)
    @check_ptrs x
    @assert isInitialized(x) "conversion sequence has no kind yet"
    return clang_ImplicitConversionSequence_getKind(x)
end

"""
    getKindRank(x::AbstractImplicitConversionSequence) -> UInt32
Return the rank of this sequence's kind; smaller ranks are better conversion sequences.
"""
function getKindRank(x::AbstractImplicitConversionSequence)
    @check_ptrs x
    @assert isInitialized(x) "conversion sequence has no kind yet"
    return clang_ImplicitConversionSequence_getKindRank(x)
end

# clang spells the kind predicates as `isStandard`/`isBad`/... ; each is a pure reading of
# `getKind`, so they are Julia-side spellings over the single bound accessor rather than
# extra C entry points.
function isStandard(x::AbstractImplicitConversionSequence)
    return getKind(x) == CXImplicitConversionSequence_StandardConversion
end

function isStaticObjectArgument(x::AbstractImplicitConversionSequence)
    return getKind(x) == CXImplicitConversionSequence_StaticObjectArgumentConversion
end

function isUserDefined(x::AbstractImplicitConversionSequence)
    return getKind(x) == CXImplicitConversionSequence_UserDefinedConversion
end

function isAmbiguous(x::AbstractImplicitConversionSequence)
    return getKind(x) == CXImplicitConversionSequence_AmbiguousConversion
end

function isEllipsis(x::AbstractImplicitConversionSequence)
    return getKind(x) == CXImplicitConversionSequence_EllipsisConversion
end

function isBad(x::AbstractImplicitConversionSequence)
    return getKind(x) == CXImplicitConversionSequence_BadConversion
end

isFailure(x::AbstractImplicitConversionSequence) = isBad(x) || isAmbiguous(x)

"""
    getStandard(x::AbstractImplicitConversionSequence) -> StandardConversionSequence
Return the standard-conversion arm of the union.

The result is a borrowed interior pointer into `x`; it dangles once `x` is disposed or
switched to another kind.
"""
function getStandard(x::AbstractImplicitConversionSequence)
    @check_ptrs x
    @assert isStandard(x) "conversion sequence is not a standard conversion"
    return StandardConversionSequence(clang_ImplicitConversionSequence_getStandard(x))
end

"""
    getBad(x::AbstractImplicitConversionSequence) -> BadConversionSequence
Return the bad-conversion arm of the union.

The result is a borrowed interior pointer into `x`; it dangles once `x` is disposed or
switched to another kind.
"""
function getBad(x::AbstractImplicitConversionSequence)
    @check_ptrs x
    @assert isBad(x) "conversion sequence is not a bad conversion"
    return BadConversionSequence(clang_ImplicitConversionSequence_getBad(x))
end

"""
    setBad(x::AbstractImplicitConversionSequence, failure, from::QualType, to::QualType)
Make `x` a bad conversion from `from` to `to` for the given failure kind.

This is clang's implicit-argument overload, which records no source expression.
"""
function setBad(x::AbstractImplicitConversionSequence, failure::CXBadConversionSequence_FailureKind, from::QualType, to::QualType)
    @check_ptrs x
    return clang_ImplicitConversionSequence_setBad(x, failure, from, to)
end

function setEllipsis(x::AbstractImplicitConversionSequence)
    @check_ptrs x
    return clang_ImplicitConversionSequence_setEllipsis(x)
end

"""
    setAsIdentityConversion(x::AbstractImplicitConversionSequence, ty::QualType)
Make `x` a standard conversion whose sequence is the identity conversion from `ty` to `ty`.
"""
function setAsIdentityConversion(x::AbstractImplicitConversionSequence, ty::QualType)
    @check_ptrs x
    return clang_ImplicitConversionSequence_setAsIdentityConversion(x, ty)
end

function hasInitializerListContainerType(x::AbstractImplicitConversionSequence)
    @check_ptrs x
    return clang_ImplicitConversionSequence_hasInitializerListContainerType(x)
end

function setInitializerListContainerType(x::AbstractImplicitConversionSequence, ty::QualType, incomplete_array::Bool)
    @check_ptrs x
    return clang_ImplicitConversionSequence_setInitializerListContainerType(x, ty, incomplete_array)
end

function isInitializerListOfIncompleteArray(x::AbstractImplicitConversionSequence)
    @check_ptrs x
    return clang_ImplicitConversionSequence_isInitializerListOfIncompleteArray(x)
end

"""
    getInitializerListContainerType(x::AbstractImplicitConversionSequence) -> QualType
Return the array or `std::initializer_list` type being initialized from an initializer list.
"""
function getInitializerListContainerType(x::AbstractImplicitConversionSequence)
    @check_ptrs x
    @assert hasInitializerListContainerType(x) "no initializer-list container type"
    return QualType(clang_ImplicitConversionSequence_getInitializerListContainerType(x))
end

# OverloadCandidateSet

"""
    OverloadCandidateSet(loc::SourceLocation, kind) -> OverloadCandidateSet
Create an empty overload candidate set for a lookup of `kind` at `loc`.

The set owns its candidates and the conversion sequences slab-allocated for them, so every
candidate dies with it. This function allocates and one should call `dispose` to release
the resources after using this object.
"""
function OverloadCandidateSet(loc::SourceLocation, kind::CXOverloadCandidateSet_CandidateSetKind)
    cs = clang_OverloadCandidateSet_create(loc, kind)
    @assert cs != C_NULL "Failed to create OverloadCandidateSet"
    return OverloadCandidateSet(cs)
end

dispose(x::OverloadCandidateSet) = clang_OverloadCandidateSet_dispose(x)

function getLocation(x::AbstractOverloadCandidateSet)
    @check_ptrs x
    return SourceLocation(clang_OverloadCandidateSet_getLocation(x))
end

function getKind(x::AbstractOverloadCandidateSet)
    @check_ptrs x
    return clang_OverloadCandidateSet_getKind(x)
end

"""
    clear(x::AbstractOverloadCandidateSet, kind)
Destroy every candidate in the set and reset it for a lookup of `kind`.
"""
function clear(x::AbstractOverloadCandidateSet, kind::CXOverloadCandidateSet_CandidateSetKind)
    @check_ptrs x
    return clang_OverloadCandidateSet_clear(x, kind)
end

# Number of candidates currently in the set.
function Base.size(x::AbstractOverloadCandidateSet)
    @check_ptrs x
    return clang_OverloadCandidateSet_size(x)
end

function empty(x::AbstractOverloadCandidateSet)
    @check_ptrs x
    return clang_OverloadCandidateSet_empty(x)
end

# StandardConversionSequence (cont.)

"""
    setFromType(x::AbstractStandardConversionSequence, ty::QualType)
Set the type this standard conversion sequence converts from.
"""
function setFromType(x::AbstractStandardConversionSequence, ty::QualType)
    @check_ptrs x
    return clang_StandardConversionSequence_setFromType(x, ty)
end

"""
    setToType(x::AbstractStandardConversionSequence, i::Integer, ty::QualType)
Set the type step `i` of this standard conversion sequence converts to.

`i` is 0-based and must be less than 3; the underlying C++ method asserts on it.
"""
function setToType(x::AbstractStandardConversionSequence, i::Integer, ty::QualType)
    @check_ptrs x
    @assert 0 <= i < 3 "to-type index $i out of range"
    return clang_StandardConversionSequence_setToType(x, i, ty)
end

"""
    setAllToTypes(x::AbstractStandardConversionSequence, ty::QualType)
Set all three to-type steps of this standard conversion sequence to `ty`.
"""
function setAllToTypes(x::AbstractStandardConversionSequence, ty::QualType)
    @check_ptrs x
    return clang_StandardConversionSequence_setAllToTypes(x, ty)
end

"""
    setAsIdentityConversion(x::AbstractStandardConversionSequence)
Reset the three conversion kinds to the identity conversion and clear the binding flags.

The from- and to-types are left untouched; `setFromType` and `setAllToTypes` set those.
"""
function setAsIdentityConversion(x::AbstractStandardConversionSequence)
    @check_ptrs x
    return clang_StandardConversionSequence_setAsIdentityConversion(x)
end

"""
    getRank(x::AbstractStandardConversionSequence) -> CXImplicitConversionRank
Return the rank of this sequence, the worst of its three conversion kinds' ranks.

Smaller ranks are better conversion sequences.
"""
function getRank(x::AbstractStandardConversionSequence)
    @check_ptrs x
    return clang_StandardConversionSequence_getRank(x)
end

"""
    isPointerConversionToBool(x::AbstractStandardConversionSequence) -> Bool
Return whether this sequence converts a pointer-like value to `bool`.

The sequence's from- and to-types have no default initializer and this predicate reads both.
Set them first, with `setFromType`/`setAllToTypes` or wholesale through
`setAsIdentityConversion(::AbstractImplicitConversionSequence, ty)`; nothing records whether
they have been set, so this precondition is documented rather than asserted.
"""
function isPointerConversionToBool(x::AbstractStandardConversionSequence)
    @check_ptrs x
    return clang_StandardConversionSequence_isPointerConversionToBool(x)
end

"""
    isPointerConversionToVoidPointer(x::AbstractStandardConversionSequence, ctx::ASTContext) -> Bool
Return whether this sequence converts a pointer to a pointer-to-`void`.

Carries the same unset-types precondition as `isPointerConversionToBool`.
"""
function isPointerConversionToVoidPointer(x::AbstractStandardConversionSequence, ctx::ASTContext)
    @check_ptrs x ctx
    return clang_StandardConversionSequence_isPointerConversionToVoidPointer(x, ctx)
end

# BadConversionSequence (cont.)

"""
    getFailureKind(x::AbstractBadConversionSequence) -> CXBadConversionSequence_FailureKind
Return why the conversion failed.
"""
function getFailureKind(x::AbstractBadConversionSequence)
    @check_ptrs x
    return clang_BadConversionSequence_getFailureKind(x)
end

"""
    getFromExpr(x::AbstractBadConversionSequence) -> Expr_
Return the source expression the conversion failed on.

The carrier's `ptr` is NULL when the failure records no expression, which is the case for an
implicit object argument and for any sequence built from types alone.
"""
function getFromExpr(x::AbstractBadConversionSequence)
    @check_ptrs x
    return Expr_(clang_BadConversionSequence_getFromExpr(x))
end

"""
    setFromExpr(x::AbstractBadConversionSequence, e::AbstractExpr)
Record `e` as the source expression of the failure, and its type as the from-type.
"""
function setFromExpr(x::AbstractBadConversionSequence, e::AbstractExpr)
    @check_ptrs x e
    return clang_BadConversionSequence_setFromExpr(x, e)
end

function setFromType(x::AbstractBadConversionSequence, ty::QualType)
    @check_ptrs x
    return clang_BadConversionSequence_setFromType(x, ty)
end

function setToType(x::AbstractBadConversionSequence, ty::QualType)
    @check_ptrs x
    return clang_BadConversionSequence_setToType(x, ty)
end

# ImplicitConversionSequence (cont.)

"""
    setStandard(x::AbstractImplicitConversionSequence)
Make `x` a standard conversion without touching the standard arm's payload.

The arm keeps whatever it last held; `setAsIdentityConversion` is the initializing form.
"""
function setStandard(x::AbstractImplicitConversionSequence)
    @check_ptrs x
    return clang_ImplicitConversionSequence_setStandard(x)
end

"""
    setStaticObjectArgument(x::AbstractImplicitConversionSequence)
Make `x` the conversion for the synthesized first argument of a static member function call.
"""
function setStaticObjectArgument(x::AbstractImplicitConversionSequence)
    @check_ptrs x
    return clang_ImplicitConversionSequence_setStaticObjectArgument(x)
end

"""
    setAmbiguous(x::AbstractImplicitConversionSequence)
Make `x` an ambiguous conversion and construct its (empty) conversion set in place.

The set is destroyed when `x` is disposed or switched to another kind.
"""
function setAmbiguous(x::AbstractImplicitConversionSequence)
    @check_ptrs x
    return clang_ImplicitConversionSequence_setAmbiguous(x)
end

"""
    getNullptrToBool(source::QualType, dest::QualType, needs_lval_to_rval::Bool) -> ImplicitConversionSequence
Build the implicit conversion sequence from `nullptr_t` to `bool` that direct-initializing a
`bool` object uses.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function getNullptrToBool(source::QualType, dest::QualType, needs_lval_to_rval::Bool)
    ics = clang_ImplicitConversionSequence_getNullptrToBool(source, dest, needs_lval_to_rval)
    @assert ics != C_NULL "Failed to create ImplicitConversionSequence"
    return ImplicitConversionSequence(ics)
end

# OverloadCandidateSet (cont.)

"""
    isNewCandidate(x::AbstractOverloadCandidateSet, d::AbstractDecl, reversed::Bool=false) -> Bool
Record `d` as seen by this candidate set and return whether it was new to the set.

`d` is keyed by its canonical declaration together with the parameter order, so the reversed
order is a separate key from the normal one.
"""
function isNewCandidate(x::AbstractOverloadCandidateSet, d::AbstractDecl, reversed::Bool=false)
    @check_ptrs x d
    return clang_OverloadCandidateSet_isNewCandidate(x, d, reversed)
end

"""
    exclude(x::AbstractOverloadCandidateSet, d::AbstractDecl)
Mark `d` as seen in both parameter orders, so no later candidate for it counts as new.
"""
function exclude(x::AbstractOverloadCandidateSet, d::AbstractDecl)
    @check_ptrs x d
    return clang_OverloadCandidateSet_exclude(x, d)
end

"""
    getDestAS(x::AbstractOverloadCandidateSet) -> CXLangAS
Return the address space of the object being constructed.
"""
function getDestAS(x::AbstractOverloadCandidateSet)
    @check_ptrs x
    return clang_OverloadCandidateSet_getDestAS(x)
end

"""
    setDestAS(x::AbstractOverloadCandidateSet, as::CXLangAS)
Set the address space of the object being constructed.

Only defined while the set's kind is `CSK_InitByConstructor` or
`CSK_InitByUserDefinedConversion`; the C++ method asserts on it.
"""
function setDestAS(x::AbstractOverloadCandidateSet, as::CXLangAS)
    @check_ptrs x
    kind = getKind(x)
    ok = kind == CXOverloadCandidateSet_CSK_InitByConstructor || kind == CXOverloadCandidateSet_CSK_InitByUserDefinedConversion
    @assert ok "candidate set is not constructing an object"
    return clang_OverloadCandidateSet_setDestAS(x, as)
end

# AmbiguousConversionSequence
#
# Another borrowed interior pointer into the owning `ImplicitConversionSequence`: it dangles
# once that sequence is disposed or switched to another kind, and the kind change destroys
# the conversion set as well.

"""
    getAmbiguous(x::AbstractImplicitConversionSequence) -> AmbiguousConversionSequence
Return the ambiguous-conversion arm of the union.

The result is a borrowed interior pointer into `x`; it dangles once `x` is disposed or
switched to another kind.
"""
function getAmbiguous(x::AbstractImplicitConversionSequence)
    @check_ptrs x
    @assert isAmbiguous(x) "conversion sequence is not an ambiguous conversion"
    return AmbiguousConversionSequence(clang_ImplicitConversionSequence_getAmbiguous(x))
end

"""
    setUserDefined(x::AbstractImplicitConversionSequence)
Make `x` a user-defined conversion without touching the user-defined arm's payload.

The arm keeps whatever it last held, and this layer exposes no accessor for it.
"""
function setUserDefined(x::AbstractImplicitConversionSequence)
    @check_ptrs x
    return clang_ImplicitConversionSequence_setUserDefined(x)
end

"""
    getFromType(x::AbstractAmbiguousConversionSequence) -> QualType
Return the type this ambiguous conversion sequence converts from.

`setAmbiguous` constructs the conversion set but leaves the from- and to-types
indeterminate, and nothing records whether they have been set, so this precondition is
documented rather than asserted: call `setFromType` before reading this.
"""
function getFromType(x::AbstractAmbiguousConversionSequence)
    @check_ptrs x
    return QualType(clang_AmbiguousConversionSequence_getFromType(x))
end

"""
    getToType(x::AbstractAmbiguousConversionSequence) -> QualType
Return the type this ambiguous conversion sequence converts to.

Carries the same unset-types precondition as `getFromType`.
"""
function getToType(x::AbstractAmbiguousConversionSequence)
    @check_ptrs x
    return QualType(clang_AmbiguousConversionSequence_getToType(x))
end

"""
    setFromType(x::AbstractAmbiguousConversionSequence, ty::QualType)
Set the type this ambiguous conversion sequence converts from.
"""
function setFromType(x::AbstractAmbiguousConversionSequence, ty::QualType)
    @check_ptrs x
    return clang_AmbiguousConversionSequence_setFromType(x, ty)
end

"""
    setToType(x::AbstractAmbiguousConversionSequence, ty::QualType)
Set the type this ambiguous conversion sequence converts to.
"""
function setToType(x::AbstractAmbiguousConversionSequence, ty::QualType)
    @check_ptrs x
    return clang_AmbiguousConversionSequence_setToType(x, ty)
end

"""
    addConversion(x::AbstractAmbiguousConversionSequence, found::AbstractNamedDecl, d::AbstractFunctionDecl)
Append the `(found declaration, function)` pair to this sequence's conversion set.

The set may reallocate its storage, so indices taken before the call stay valid but nothing
borrowing that storage does.
"""
function addConversion(x::AbstractAmbiguousConversionSequence, found::AbstractNamedDecl, d::AbstractFunctionDecl)
    @check_ptrs x found d
    return clang_AmbiguousConversionSequence_addConversion(x, found, d)
end

# Number of conversions in this sequence's conversion set.
function getNumConversions(x::AbstractAmbiguousConversionSequence)
    @check_ptrs x
    return clang_AmbiguousConversionSequence_getNumConversions(x)
end

"""
    getConversionFound(x::AbstractAmbiguousConversionSequence, i::Integer) -> NamedDecl
Return the declaration lookup found for conversion `i`, which may be a using-shadow
declaration rather than the conversion function itself.

`i` is 0-based and must be less than `getNumConversions(x)`.
"""
function getConversionFound(x::AbstractAmbiguousConversionSequence, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumConversions(x) "conversion index $i out of range"
    return NamedDecl(clang_AmbiguousConversionSequence_getConversionFound(x, i))
end

"""
    getConversionFunction(x::AbstractAmbiguousConversionSequence, i::Integer) -> FunctionDecl
Return the conversion function of conversion `i`.

`i` is 0-based and must be less than `getNumConversions(x)`.
"""
function getConversionFunction(x::AbstractAmbiguousConversionSequence, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumConversions(x) "conversion index $i out of range"
    return FunctionDecl(clang_AmbiguousConversionSequence_getConversionFunction(x, i))
end

# BadConversionSequence (cont.)

"""
    init(x::AbstractBadConversionSequence, failure, e::AbstractExpr, to::QualType)
Record `failure` on `x`, with `e` as the source expression and `to` as the destination type.

This is clang's expression overload, which takes the from-type from `e`; the type-only form
is reached through `setBad(::AbstractImplicitConversionSequence, ...)`.
"""
function init(x::AbstractBadConversionSequence, failure::CXBadConversionSequence_FailureKind, e::AbstractExpr, to::QualType)
    @check_ptrs x e
    return clang_BadConversionSequence_init(x, failure, e, to)
end

# OverloadCandidateSet (cont.)

"""
    OverloadCandidateSet(loc::SourceLocation, kind, op::CXOverloadedOperatorKind, op_loc::SourceLocation, allow_rewritten::Bool) -> OverloadCandidateSet
Create an empty overload candidate set that also records how operator rewrites are to be
considered while candidates are added to it.

The two-argument form uses clang's default (empty) rewrite info instead. This function
allocates and one should call `dispose` to release the resources after using this object.
"""
function OverloadCandidateSet(loc::SourceLocation, kind::CXOverloadCandidateSet_CandidateSetKind, op::CXOverloadedOperatorKind, op_loc::SourceLocation, allow_rewritten::Bool)
    cs = clang_OverloadCandidateSet_createWithRewriteInfo(loc, kind, op, op_loc, allow_rewritten)
    @assert cs != C_NULL "Failed to create OverloadCandidateSet"
    return OverloadCandidateSet(cs)
end

"""
    getRewriteInfoOriginalOperator(x::AbstractOverloadCandidateSet) -> CXOverloadedOperatorKind
Return the operator, as written in the source, that this candidate set was built for.
"""
function getRewriteInfoOriginalOperator(x::AbstractOverloadCandidateSet)
    @check_ptrs x
    return clang_OverloadCandidateSet_getRewriteInfoOriginalOperator(x)
end

"""
    getRewriteInfoOpLoc(x::AbstractOverloadCandidateSet) -> SourceLocation
Return the source location of the operator this candidate set was built for.
"""
function getRewriteInfoOpLoc(x::AbstractOverloadCandidateSet)
    @check_ptrs x
    return SourceLocation(clang_OverloadCandidateSet_getRewriteInfoOpLoc(x))
end

"""
    getRewriteInfoAllowRewrittenCandidates(x::AbstractOverloadCandidateSet) -> Bool
Return whether rewritten candidates belong in this overload set.
"""
function getRewriteInfoAllowRewrittenCandidates(x::AbstractOverloadCandidateSet)
    @check_ptrs x
    return clang_OverloadCandidateSet_getRewriteInfoAllowRewrittenCandidates(x)
end

"""
    getCandidate(x::AbstractOverloadCandidateSet, i::Integer) -> OverloadCandidate
Return candidate `i` of this set.

`i` is 0-based and must be less than `size(x)`. The result is a borrowed interior pointer
into `x`.
"""
function getCandidate(x::AbstractOverloadCandidateSet, i::Integer)
    @check_ptrs x
    @assert 0 <= i < size(x) "candidate index $i out of range"
    return OverloadCandidate(clang_OverloadCandidateSet_getCandidate(x, i))
end

"""
    addCandidate(x::AbstractOverloadCandidateSet, num_conversions::Integer=0) -> OverloadCandidate
Append a candidate with `num_conversions` conversion-sequence slots and return it.

The slots are slab-allocated inside `x` and start out uninitialized. The candidate is a
borrowed interior pointer into `x`: the candidate vector may reallocate, so every handle
taken from the set before an `addCandidate` dangles afterwards, and `clear`/`dispose`
destroy them all.

clang leaves a fresh candidate's function, viability and failure kind indeterminate for
`Sema` to fill in; the C shim completes the object with the defaults of a viable
non-surrogate candidate with no function, so the accessors below and the set's destructor
are defined without a `Sema` pass over it.
"""
function addCandidate(x::AbstractOverloadCandidateSet, num_conversions::Integer=0)
    @check_ptrs x
    return OverloadCandidate(clang_OverloadCandidateSet_addCandidate(x, num_conversions))
end

# OverloadCandidate
#
# A carrier is a borrowed interior pointer into the `OverloadCandidateSet` that owns it.

"""
    getRewriteKind(x::AbstractOverloadCandidate) -> CXOverloadCandidateRewriteKind
Return what kind of rewrite produced this candidate.

The value is a bitmask as well as a rank: a candidate rewritten both with a different
operator and with reversed parameters carries `CRK_DifferentOperator | CRK_Reversed`, which
is not itself an enumerator and prints as an invalid instance.
"""
function getRewriteKind(x::AbstractOverloadCandidate)
    @check_ptrs x
    return clang_OverloadCandidate_getRewriteKind(x)
end

"""
    isReversed(x::AbstractOverloadCandidate) -> Bool
Return whether this candidate reverses the order of its parameters.
"""
function isReversed(x::AbstractOverloadCandidate)
    @check_ptrs x
    return clang_OverloadCandidate_isReversed(x)
end

"""
    hasAmbiguousConversion(x::AbstractOverloadCandidate) -> Bool
Return whether any of this candidate's argument conversions is an ambiguous one.

The scan stops at the first uninitialized slot, so a candidate whose conversions have not
been resolved reports `false`.
"""
function hasAmbiguousConversion(x::AbstractOverloadCandidate)
    @check_ptrs x
    return clang_OverloadCandidate_hasAmbiguousConversion(x)
end

"""
    getNumParams(x::AbstractOverloadCandidate) -> UInt32
Return the number of parameters this candidate takes.

A surrogate candidate reports the parameter count of the function type its conversion
function yields — reached through an unchecked `castAs`, which only `Sema` guarantees — a
candidate with a function that function's parameter count, and any other candidate the
number of arguments recorded for it. A candidate from `addCandidate` is the last case and
reports the conversion-slot count that call asked for.
"""
function getNumParams(x::AbstractOverloadCandidate)
    @check_ptrs x
    return clang_OverloadCandidate_getNumParams(x)
end

"""
    NotValidBecauseConstraintExprHasError(x::AbstractOverloadCandidate) -> Bool
Return whether this candidate is non-viable only because its associated constraint
expression is itself ill-formed.
"""
function NotValidBecauseConstraintExprHasError(x::AbstractOverloadCandidate)
    @check_ptrs x
    return clang_OverloadCandidate_NotValidBecauseConstraintExprHasError(x)
end

# Number of argument conversion sequences this candidate carries.
function getNumConversions(x::AbstractOverloadCandidate)
    @check_ptrs x
    return clang_OverloadCandidate_getNumConversions(x)
end

"""
    getConversion(x::AbstractOverloadCandidate, i::Integer) -> ImplicitConversionSequence
Return the conversion sequence for argument `i`.

`i` is 0-based and must be less than `getNumConversions(x)`. The result is a borrowed
interior pointer into the owning set's slab storage: it must never be passed to `dispose`,
which would free memory the set owns.
"""
function getConversion(x::AbstractOverloadCandidate, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumConversions(x) "conversion index $i out of range"
    return ImplicitConversionSequence(clang_OverloadCandidate_getConversion(x, i))
end

"""
    getNarrowingKind(x::AbstractStandardConversionSequence, ctx::ASTContext,
                     converted::AbstractExpr, value::APValue,
                     ignore_float_to_integral::Bool=false)
        -> Tuple{CXNarrowingKind,QualType}
Classify the narrowing `x` performs on `converted`, per C++11 [dcl.init.list]p7, and return
that classification together with the narrowed destination type.

`value` is an in/out box: clang overwrites it with the source constant when the answer is
`CXNarrowingKind_NK_Constant_Narrowing`. The returned `QualType` is null on every outcome
that records no type.

`ctx` must be a C++ context — the C++ method opens with an assertion on it — and `x`'s
to-types must already be set, because the method reads `getToType(0)` and dereferences
`getToType(1)`. `setAsIdentityConversion` on the owning `ImplicitConversionSequence` is what
normally establishes them; on a sequence whose types no setter has touched they are
indeterminate and reading them is undefined.
"""
function getNarrowingKind(x::AbstractStandardConversionSequence, ctx::ASTContext, converted::AbstractExpr, value::APValue, ignore_float_to_integral::Bool=false)
    @check_ptrs x ctx converted value
    @assert getCPlusPlus(getLangOpts(ctx)) "narrowing is a C++ notion; ctx is not a C++ context"
    ty = Ref{CXQualType}(C_NULL)
    kind = clang_StandardConversionSequence_getNarrowingKind(x, ctx, converted, value, ty, ignore_float_to_integral)
    return kind, QualType(ty[])
end

"""
    dump(x::AbstractStandardConversionSequence)
Write a one-line description of the three conversion kinds to `stderr`.

Only those kinds and the binding flags are read, and `setAsIdentityConversion` is what sets
them; on the `Before`/`After` arms of a user-defined sequence they stay indeterminate until
it has run.
"""
function dump(x::AbstractStandardConversionSequence)
    @check_ptrs x
    return clang_StandardConversionSequence_dump(x)
end

# UserDefinedConversionSequence
#
# Every member of the arm is raw storage with no default initializer, and `setUserDefined`
# only changes the owning sequence's kind — it does not touch the arm. Sema fills it during
# overload resolution; a sequence built by hand must be given a `Before`, an `After` and a
# conversion function before any accessor here reads it, and nothing records whether that
# has happened.
"""
    getBefore(x::AbstractUserDefinedConversionSequence) -> StandardConversionSequence
Return the standard conversion applied before the user-defined one.

The result is a borrowed interior pointer into `x`; it dangles once the owning sequence is
disposed or switched to another kind. It is raw storage until
`setAsIdentityConversion` has run on it.
"""
function getBefore(x::AbstractUserDefinedConversionSequence)
    @check_ptrs x
    return StandardConversionSequence(clang_UserDefinedConversionSequence_getBefore(x))
end

"""
    getAfter(x::AbstractUserDefinedConversionSequence) -> StandardConversionSequence
Return the standard conversion applied after the user-defined one.

Borrowed and uninitialized on the same terms as `getBefore`.
"""
function getAfter(x::AbstractUserDefinedConversionSequence)
    @check_ptrs x
    return StandardConversionSequence(clang_UserDefinedConversionSequence_getAfter(x))
end

"""
    getEllipsisConversion(x::AbstractUserDefinedConversionSequence) -> Bool
Return whether the sequence starts with an ellipsis conversion, in which case the `Before`
arm carries no meaning. Reads raw storage until `setEllipsisConversion` has run.
"""
function getEllipsisConversion(x::AbstractUserDefinedConversionSequence)
    @check_ptrs x
    return clang_UserDefinedConversionSequence_getEllipsisConversion(x)
end

"""
    setEllipsisConversion(x::AbstractUserDefinedConversionSequence, v::Bool)
Record whether the sequence starts with an ellipsis conversion.
"""
function setEllipsisConversion(x::AbstractUserDefinedConversionSequence, v::Bool)
    @check_ptrs x
    return clang_UserDefinedConversionSequence_setEllipsisConversion(x, v)
end

"""
    getHadMultipleCandidates(x::AbstractUserDefinedConversionSequence) -> Bool
Return whether the conversion function was resolved from an overload set with more than one
member. Reads raw storage until `setHadMultipleCandidates` has run.
"""
function getHadMultipleCandidates(x::AbstractUserDefinedConversionSequence)
    @check_ptrs x
    return clang_UserDefinedConversionSequence_getHadMultipleCandidates(x)
end

"""
    setHadMultipleCandidates(x::AbstractUserDefinedConversionSequence, v::Bool)
Record whether the conversion function came out of an overload set with more than one
member.
"""
function setHadMultipleCandidates(x::AbstractUserDefinedConversionSequence, v::Bool)
    @check_ptrs x
    return clang_UserDefinedConversionSequence_setHadMultipleCandidates(x, v)
end

"""
    getConversionFunction(x::AbstractUserDefinedConversionSequence) -> FunctionDecl
Return the function performing the user-defined conversion.

The carrier holds a NULL pointer when the conversion is an aggregate initialization from an
initializer list. Reads raw storage until `setConversionFunction` has run.
"""
function getConversionFunction(x::AbstractUserDefinedConversionSequence)
    @check_ptrs x
    return FunctionDecl(clang_UserDefinedConversionSequence_getConversionFunction(x))
end

"""
    setConversionFunction(x::AbstractUserDefinedConversionSequence, fd::AbstractFunctionDecl)
Record `fd` as the function performing the user-defined conversion.
"""
function setConversionFunction(x::AbstractUserDefinedConversionSequence, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    return clang_UserDefinedConversionSequence_setConversionFunction(x, fd)
end

"""
    dump(x::AbstractUserDefinedConversionSequence)
Write the sequence to `stderr`.

The `Before` and `After` conversion kinds and the conversion function are all read, so the
arm must have been filled first.
"""
function dump(x::AbstractUserDefinedConversionSequence)
    @check_ptrs x
    return clang_UserDefinedConversionSequence_dump(x)
end

"""
    construct(x::AbstractAmbiguousConversionSequence)
Construct this arm's conversion set in its raw buffer.

`setAmbiguous` on the owning sequence already does this, so running it on a live set leaks
that set's heap storage; it exists to pair with `destruct`.
"""
function construct(x::AbstractAmbiguousConversionSequence)
    @check_ptrs x
    return clang_AmbiguousConversionSequence_construct(x)
end

"""
    destruct(x::AbstractAmbiguousConversionSequence)
Destroy this arm's conversion set.

The set must be live, and nothing may read it afterwards — neither an accessor, nor the
owning sequence's next kind change, nor its `dispose`, each of which would destroy it a
second time. Follow this with `construct` or `copyFrom`.
"""
function destruct(x::AbstractAmbiguousConversionSequence)
    @check_ptrs x
    return clang_AmbiguousConversionSequence_destruct(x)
end

"""
    copyFrom(x::AbstractAmbiguousConversionSequence,
             other::AbstractAmbiguousConversionSequence)
Replace `x`'s from-type, to-type and conversion set with copies of `other`'s.

clang constructs the set in place rather than assigning to it — this is what
`ImplicitConversionSequence`'s copy constructor calls on freshly allocated storage — so
`x`'s set must not be live: run `destruct` first. `other`'s set must be live and both of its
types must have been set.
"""
function copyFrom(x::AbstractAmbiguousConversionSequence, other::AbstractAmbiguousConversionSequence)
    @check_ptrs x other
    return clang_AmbiguousConversionSequence_copyFrom(x, other)
end

"""
    getUserDefined(x::AbstractImplicitConversionSequence) -> UserDefinedConversionSequence
Return the user-defined-conversion arm of the union.

The result is a borrowed interior pointer into `x`; it dangles once `x` is disposed or
switched to another kind. Unlike the ambiguous arm, switching to `UserDefinedConversion`
does not initialise the arm — see `getBefore`.
"""
function getUserDefined(x::AbstractImplicitConversionSequence)
    @check_ptrs x
    @assert isUserDefined(x) "conversion sequence is not a user-defined conversion"
    return UserDefinedConversionSequence(clang_ImplicitConversionSequence_getUserDefined(x))
end

"""
    dump(x::AbstractImplicitConversionSequence)
Write the sequence to `stderr`.

Every kind but `UserDefinedConversion` prints from state the shim guarantees. For
`UserDefinedConversion` this dumps the user-defined arm, whose members stay indeterminate
until a caller fills them; nothing records whether that has happened, so it is a documented
precondition here rather than an assertion.
"""
function dump(x::AbstractImplicitConversionSequence)
    @check_ptrs x
    @assert isInitialized(x) "conversion sequence has no kind yet"
    return clang_ImplicitConversionSequence_dump(x)
end

"""
    TryToFixBadConversion(x::AbstractOverloadCandidate, i::Integer, sema::AbstractSema)
        -> Bool
Ask clang whether the bad conversion at 0-based index `i` can be repaired by a fix-it,
recording the hints on `x` when it can.

The C++ method reads that conversion's `Bad` union arm with no kind check of its own, so the
conversion at `i` must already be a bad conversion.
"""
function TryToFixBadConversion(x::AbstractOverloadCandidate, i::Integer, sema::AbstractSema)
    @check_ptrs x sema
    @assert isBad(getConversion(x, i)) "conversion $i is not a bad conversion"
    return clang_OverloadCandidate_TryToFixBadConversion(x, i, sema)
end

"""
    shouldDeferDiags(x::AbstractOverloadCandidateSet, sema::AbstractSema,
                     args::AbstractVector{<:AbstractExpr}, op_loc::SourceLocation) -> Bool
Return whether diagnostics for this candidate set should be deferred.

Only the CUDA/HIP deferred-diagnostic path answers anything but `false`, and that path walks
both the candidates and `args`, which is the argument list the set was built for.
"""
function shouldDeferDiags(x::AbstractOverloadCandidateSet, sema::AbstractSema, args::AbstractVector{<:AbstractExpr}, op_loc::SourceLocation)
    @check_ptrs x sema
    buf = CXExpr[Base.unsafe_convert(CXExpr, a) for a in args]
    return clang_OverloadCandidateSet_shouldDeferDiags(x, sema, buf, length(buf), op_loc)
end

"""
    allocateConversionSequences(x::AbstractOverloadCandidateSet, n::Integer)
        -> Vector{ImplicitConversionSequence}
Slab-allocate `n` freshly created (uninitialized) conversion sequences out of `x` and return
a borrowed handle to each.

The storage dies with `x`, so no element may reach `dispose`. Elements never handed to a
candidate are not destructed either, so do not give one the ambiguous kind — its conversion
set would leak.
"""
function allocateConversionSequences(x::AbstractOverloadCandidateSet, n::Integer)
    @check_ptrs x
    @assert n >= 0 "conversion count must be non-negative"
    buf = Vector{CXImplicitConversionSequence}(undef, n)
    clang_OverloadCandidateSet_allocateConversionSequences(x, n, buf)
    return [ImplicitConversionSequence(p) for p in buf]
end

# OverloadCandidateSet::OperatorRewriteInfo
#
# clang keeps the rewrite info as a private member and hands it out by value, so its
# predicates are exposed on the owning set rather than on a carrier of their own.

"""
    rewriteInfoIsRewrittenOperator(x::AbstractOverloadCandidateSet, fd::AbstractFunctionDecl) -> Bool
Return whether a candidate for `fd` would rewrite the operator `x` was built for into a
different one.

Always `false` on a set whose rewrite info carries no original operator, which is what the
two-argument `OverloadCandidateSet` constructor leaves behind.
"""
function rewriteInfoIsRewrittenOperator(x::AbstractOverloadCandidateSet, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    return clang_OverloadCandidateSet_rewriteInfoIsRewrittenOperator(x, fd)
end

"""
    rewriteInfoIsAcceptableCandidate(x::AbstractOverloadCandidateSet, fd::AbstractFunctionDecl) -> Bool
Return whether `fd` is one of the candidates `x` is supposed to consider.

Always `true` on a set with no original operator; otherwise `fd` must name that operator, or —
when the set allows rewritten candidates — the operator that rewrites to it.
"""
function rewriteInfoIsAcceptableCandidate(x::AbstractOverloadCandidateSet, fd::AbstractFunctionDecl)
    @check_ptrs x fd
    return clang_OverloadCandidateSet_rewriteInfoIsAcceptableCandidate(x, fd)
end

"""
    rewriteInfoGetRewriteKind(x::AbstractOverloadCandidateSet, fd::AbstractFunctionDecl,
                              reversed::Bool=false) -> CXOverloadCandidateRewriteKind
Return the rewrite kind a candidate for `fd` would carry in the given parameter order.

The value is a bitmask as well as a rank: a candidate that is both a different operator and
reversed carries `CRK_DifferentOperator | CRK_Reversed`, which is not itself an enumerator and
prints as an invalid instance.
"""
function rewriteInfoGetRewriteKind(x::AbstractOverloadCandidateSet, fd::AbstractFunctionDecl, reversed::Bool=false)
    @check_ptrs x fd
    return clang_OverloadCandidateSet_rewriteInfoGetRewriteKind(x, fd, reversed)
end

"""
    rewriteInfoIsReversible(x::AbstractOverloadCandidateSet) -> Bool
Return whether the operator `x` was built for could be implemented by a function with reversed
parameter order.

Always `false` on a set that does not allow rewritten candidates.
"""
function rewriteInfoIsReversible(x::AbstractOverloadCandidateSet)
    @check_ptrs x
    return clang_OverloadCandidateSet_rewriteInfoIsReversible(x)
end

"""
    rewriteInfoAllowsReversed(x::AbstractOverloadCandidateSet, op::CXOverloadedOperatorKind) -> Bool
Return whether reversing parameter order is allowed for `op`, judged against `x`'s rewrite
info.
"""
function rewriteInfoAllowsReversed(x::AbstractOverloadCandidateSet, op::CXOverloadedOperatorKind)
    @check_ptrs x
    return clang_OverloadCandidateSet_rewriteInfoAllowsReversed(x, op)
end

"""
    BestViableFunction(x::AbstractOverloadCandidateSet, sema::AbstractSema, loc::SourceLocation)
        -> Tuple{CXOverloadingResult, Union{OverloadCandidate,Nothing}}
Run overload resolution over `x` and return the outcome together with the winning candidate.

The candidate is `nothing` on the outcomes that select none, where clang parks its iterator one
past the end of the candidate vector; that pointer never crosses the C boundary.

Resolution compares any two viable candidates through their argument conversion sequences, and
the slots `addCandidate` hands out start uninitialized — so a set holding more than one
candidate is only resolvable once every slot has been given a kind, which is asserted here.
Resolution also flips each candidate's internal best-so-far flag: handles into `x` stay valid,
but their state changes.
"""
function BestViableFunction(x::AbstractOverloadCandidateSet, sema::AbstractSema, loc::SourceLocation)
    @check_ptrs x sema
    n = Int(size(x))
    if n > 1
        for i = 0:(n - 1)
            c = getCandidate(x, i)
            for j = 0:(Int(getNumConversions(c)) - 1)
                @assert isInitialized(getConversion(c, j)) "candidate $i has no conversion $j yet"
            end
        end
    end
    best = Ref{CXOverloadCandidate}(C_NULL)
    res = clang_OverloadCandidateSet_BestViableFunction(x, sema, loc, best)
    return res, best[] == C_NULL ? nothing : OverloadCandidate(best[])
end

# OverloadCandidate public members
#
# Every candidate a caller can hold points into a set's candidate vector, so it came out of
# `addCandidate`, which writes each member below on top of the `IsSurrogate` that clang's own
# constructor sets. None of these therefore reads indeterminate storage.

"""
    getFunction(x::AbstractOverloadCandidate) -> FunctionDecl
Return the function this candidate stands for.

The carrier is null for a built-in candidate, for a surrogate for a conversion to a function
pointer or reference, and for every candidate `addCandidate` builds.
"""
function getFunction(x::AbstractOverloadCandidate)
    @check_ptrs x
    return FunctionDecl(clang_OverloadCandidate_getFunction(x))
end

"""
    getSurrogate(x::AbstractOverloadCandidate) -> CXXConversionDecl
Return the conversion function this candidate is a surrogate for.

Only meaningful when `isSurrogate(x)`; the carrier is null on every candidate `addCandidate`
builds.
"""
function getSurrogate(x::AbstractOverloadCandidate)
    @check_ptrs x
    return CXXConversionDecl(clang_OverloadCandidate_getSurrogate(x))
end

"""
    getViable(x::AbstractOverloadCandidate) -> Bool
Return whether this candidate is viable. `addCandidate` builds viable candidates.
"""
function getViable(x::AbstractOverloadCandidate)
    @check_ptrs x
    return clang_OverloadCandidate_getViable(x)
end

"""
    getBest(x::AbstractOverloadCandidate) -> Bool
Return whether this candidate is the best viable function, or tied for it.

Overload resolution writes the flag, so every candidate of a set `BestViableFunction` has not
yet run over reports `false`.
"""
function getBest(x::AbstractOverloadCandidate)
    @check_ptrs x
    return clang_OverloadCandidate_getBest(x)
end

"""
    isSurrogate(x::AbstractOverloadCandidate) -> Bool
Return whether this candidate is a surrogate for a conversion to a function pointer or
reference.
"""
function isSurrogate(x::AbstractOverloadCandidate)
    @check_ptrs x
    return clang_OverloadCandidate_isSurrogate(x)
end

"""
    getIgnoreObjectArgument(x::AbstractOverloadCandidate) -> Bool
Return whether the first argument's conversion — the implicit object argument — is ignored.
"""
function getIgnoreObjectArgument(x::AbstractOverloadCandidate)
    @check_ptrs x
    return clang_OverloadCandidate_getIgnoreObjectArgument(x)
end

"""
    getExplicitCallArguments(x::AbstractOverloadCandidate) -> UInt32
Return how many call arguments were explicitly provided at the call site.

On a candidate from `addCandidate` this is the conversion-slot count that call asked for.
"""
function getExplicitCallArguments(x::AbstractOverloadCandidate)
    @check_ptrs x
    return clang_OverloadCandidate_getExplicitCallArguments(x)
end

"""
    CompleteCandidates(x::AbstractOverloadCandidateSet, sema::AbstractSema,
                       kind::CXOverloadCandidateDisplayKind,
                       args::AbstractVector{<:AbstractExpr},
                       loc::SourceLocation) -> Vector{OverloadCandidate}
Return the candidates a diagnostic over `x` would list, ordered the way clang would print
them.

Nothing is emitted: this is the selection-and-ordering half of clang's candidate-note
machinery on its own. `args` must be the argument list `x` was built for — on
`CXOverloadCandidateDisplayKind_OCD_AllCandidates` clang recomputes each non-viable
candidate's argument conversions against it.

The selection is then display-sorted, and the comparator reads the argument conversion
sequences of any two candidates it has to order. The slots `addCandidate` hands out start
uninitialized, so — exactly as for `BestViableFunction` — a set holding more than one
candidate is only usable here once every slot has been given a kind, which is asserted.

The returned carriers borrow `x`'s candidate vector: `addCandidate` invalidates them, and
`clear` and `dispose` destroy them.
"""
function CompleteCandidates(x::AbstractOverloadCandidateSet, sema::AbstractSema, kind::CXOverloadCandidateDisplayKind, args::AbstractVector{<:AbstractExpr}, loc::SourceLocation)
    @check_ptrs x sema
    n = Int(size(x))
    if n > 1
        for i = 0:(n - 1)
            c = getCandidate(x, i)
            for j = 0:(Int(getNumConversions(c)) - 1)
                @assert isInitialized(getConversion(c, j)) "candidate $i has no conversion $j yet"
            end
        end
    end
    argv = CXExpr[Base.unsafe_convert(CXExpr, a) for a in args]
    # The selection is a subset of the set, so one capacity-bounded call both sizes and fills
    # it; a count-then-fill pair would run the non-viable completion walk twice.
    out = Vector{CXOverloadCandidate}(undef, n)
    total = clang_OverloadCandidateSet_CompleteCandidates(x, sema, kind, argv, length(argv), loc, out, n)
    return [OverloadCandidate(out[i]) for i = 1:Int(total)]
end
