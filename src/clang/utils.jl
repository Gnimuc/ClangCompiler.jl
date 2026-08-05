"""
    is_null_handle(x) -> Bool

Return whether `x`'s handle designates nothing. This is what `@check_ptrs` tests.

Carriers hold a plain pointer, so the default is a comparison against `C_NULL`. Value types
that pack their pointer with other bits need their own method: a `QualType` is a
`PointerIntPair` of a type pointer and the fast qualifiers, so a qualifier on a null type
makes the opaque value non-zero while the type is still absent.
"""
is_null_handle(x) = x.ptr == C_NULL

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
