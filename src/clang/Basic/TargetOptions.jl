"""
    struct TargetOptions <: Any
Hold a pointer to a `clang::TargetOptions` object.
"""
struct TargetOptions
    ptr::CXTargetOptions
end
TargetOptions() = TargetOptions(create_target_options())

"""
    create_target_options() -> CXTargetOptions
Return a pointer to a `clang::TargetOptions` object.
"""
function create_target_options()
    status = Ref{CXInit_Error}(CXInit_NoError)
    opts = clang_TargetOptions_create(status)
    @assert status[] == CXInit_NoError
    return opts
end

function set_triple(x::TargetOptions, triple::String)
    @check_ptrs x
    clang_TargetOptions_setTriple(x.ptr, triple, length(triple))
    return nothing
end

function PrintStats(x::TargetOptions)
    @check_ptrs x
    return clang_TargetOptions_PrintStats(x.ptr)
end
