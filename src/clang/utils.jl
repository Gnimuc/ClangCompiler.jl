"""
    is_null_handle(x) -> Bool

Return whether `x`'s handle designates nothing. This is what `@check_ptrs` tests.

Carriers hold a plain pointer, so the default is a comparison against `C_NULL`. Value types
that pack their pointer with other bits need their own method: a `QualType` is a
`PointerIntPair` of a type pointer and the fast qualifiers, so a qualifier on a null type
makes the opaque value non-zero while the type is still absent.
"""
is_null_handle(x) = x.ptr == C_NULL

"""
    downcast(::Type{T}, x) -> T

Wrap `x` — a carrier or a bare handle — as `T`, when it designates a `T` but is typed as one
of `T`'s bases.

This is the one place the package narrows a handle, and the only construction where the
handle type and the carrier's field type are allowed to differ. Both hierarchies it serves
already establish the class before calling: clang's `dyn_cast_or_null` behind every
`castTo<Derived>` returns null rather than a mismatched pointer, and `resolve` picks `T` from
a table keyed on the class clang itself reported. Re-checking here would be a second ccall
per node in every traversal, buying nothing either path has not already paid for.

Everywhere else, a carrier is built from a handle of its own type — `clang/handles.jl` makes
anything else raise. What it cannot make raise is the explicitly-named reinterpretation
`CXIfStmt(p)`, which is Julia's own `Ptr{T}(::Ptr)` constructor and bitcasts by definition.
That spelling is exactly what this function performs, on purpose and in one place, which is
what makes the deliberate narrowings greppable rather than scattered.
"""
downcast(::Type{T}, x) where {T} = T(fieldtype(T, :ptr)(_handle(x)))

# A carrier or the handle itself: `downcast`/`upcast` are the two functions that legitimately
# read the field, so callers hand over the carrier and never spell `.ptr` at the call site.
_handle(x::Ptr) = x
_handle(x) = getfield(x, :ptr)

"""
    upcast(::Type{T}, x) -> T

Wrap `x` — a carrier or a bare handle — as `T`, when `T` stores one of its *base* handles.

The mirror of [`downcast`](@ref), and the easier direction: the carrier's class is already
what the C function returned, only its field is typed at a base — `Type_` stands for the
`clang::Type` base itself, so a function returning a `CXFunctionType` fills it by widening.
That is sound for the same reason the entries in `converts.jl` are: Clang's AST hierarchies
are singly inherited, so a base subobject shares its address with the object.
"""
upcast(::Type{T}, x) where {T} = T(fieldtype(T, :ptr)(_handle(x)))

macro check_ptrs(args...)
    ex = Expr(:block)
    for x in args
        @assert x isa Symbol "$x should be a symbol."
        cond = :(!is_null_handle($(esc(x))))
        info = :(string(typeof($(esc(x)))) * " has a NULL pointer")
        push!(ex.args, Expr(:macrocall, Symbol("@assert"), nothing, cond, info))
    end
    return ex
end

function get_string(cxstr::CXString)
    ptr = clang_getCString(cxstr)
    ptr == C_NULL && return ""
    s = unsafe_string(ptr)
    clang_disposeString(cxstr)
    return s
end

function get_string(ptr::Ptr{CXStringSet})
    ptr == C_NULL && return String[]
    cxstrset = unsafe_load(ptr)
    strs = Vector{String}(undef, cxstrset.Count)
    for i = 1:(cxstrset.Count)
        cstr = clang_getCString(unsafe_load(cxstrset.Strings, i))
        strs[i] = cstr == C_NULL ? "" : unsafe_string(cstr)
    end
    clang_disposeStringSet(ptr)
    return strs
end
