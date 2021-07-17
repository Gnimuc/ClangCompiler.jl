"""
    mutable struct TargetOptions <: Any
Holds a pointer to a `clang::TargetOptions` object.
"""
mutable struct TargetOptions
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
    @assert x.ptr != C_NULL "TargetOptions has a NULL pointer."
    clang_TargetOptions_setTriple(x.ptr, triple, length(triple))
    return nothing
end

function status(x::TargetOptions)
    @assert x.ptr != C_NULL "TargetOptions has a NULL pointer."
    return clang_TargetOptions_PrintStats(x.ptr)
end

"""
    mutable struct TargetInfo <: Any
Holds a pointer to a `clang::TargetInfo` object.
"""
mutable struct TargetInfo
    ptr::CXTargetInfo_
end

function TargetInfo(opts::TargetOptions, diag::DiagnosticsEngine=DiagnosticsEngine())
    @assert opts.ptr != C_NULL "TargetOptions has a NULL pointer."
    @assert diag.ptr != C_NULL "DiagnosticsEngine has a NULL pointer."
    info = clang_TargetInfo_CreateTargetInfo(diag.ptr, opts.ptr)
    return TargetInfo(info)
end
