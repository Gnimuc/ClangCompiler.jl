# TargetOptions
TargetOptions() = TargetOptions(create_target_options())

"""
    create_target_options() -> CXTargetOptions
Return a pointer to a `clang::TargetOptions` object.
"""
function create_target_options()
    opts = clang_TargetOptions_create()
    @assert opts != C_NULL "Failed to create TargetOptions"
    return opts
end

function setTriple(x::TargetOptions, triple::String)
    @check_ptrs x
    clang_TargetOptions_setTriple(x, triple, length(triple))
    return nothing
end

function PrintStats(x::TargetOptions)
    @check_ptrs x
    return clang_TargetOptions_PrintStats(x)
end
