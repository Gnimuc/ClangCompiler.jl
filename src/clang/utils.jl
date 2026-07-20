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

function get_string(cxstr::CXString)
    ptr = clang_getCString(cxstr)
    ptr == C_NULL && return ""
    s = unsafe_string(ptr)
    clang_disposeString(cxstr)
    return s
end

function get_string(cxstrset::CXStringSet)
    strs = Vector{String}(undef, cxstrset.Count)
    for i = 1:(cxstrset.Count)
        ptr = clang_getCString(cxstrset.Strings[i])
        s = ptr == C_NULL ? "" : unsafe_string(ptr)
        strs[i] = s
    end
    clang_disposeStringSet(cxstrset)
    return strs
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
