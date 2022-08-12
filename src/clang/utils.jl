macro check_ptrs(args...)
    ex = Expr(:block)
    for x in args
        @assert x isa Symbol "$x should be a symbol."
        cond = :($(esc(x)).ptr != C_NULL)
        info = :(string(typeof($(esc(x)))) * " has a NULL pointer")
        push!(ex.args, Expr(:macrocall, Symbol("@assert"), nothing, cond, info))
    end
    return ex
end

function _get_string(cxstr::CXString)
    ptr = clang_getCString(cxstr)
    ptr == C_NULL && return ""
    s = unsafe_string(ptr)
    clang_disposeString(cxstr)
    return s
end
