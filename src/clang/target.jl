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
    @assert x.ptr != C_NULL "file manager has a NULL pointer."
    clang_TargetOptions_setTriple(x.ptr, triple, length(triple))
    return nothing
end

"""
    mutable struct TargetInfo <: Any
Holds a pointer to a `clang::TargetInfo` object.
"""
mutable struct TargetInfo
    ptr::CXTargetInfo
end

function TargetInfo(opts::TargetOptions, diag::DiagnosticsEngine=DiagnosticsEngine())
    @assert opts.ptr != C_NULL "target options has a NULL pointer."
    @assert diag.ptr != C_NULL "diagnostics engine has a NULL pointer."
    info = clang_TargetInfo_CreateTargetInfo(diag.ptr, opts.ptr)
    return TargetInfo(info)
end
