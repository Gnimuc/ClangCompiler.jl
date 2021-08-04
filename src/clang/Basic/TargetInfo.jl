"""
    struct TargetInfo <: Any
Holds a pointer to a `clang::TargetInfo` object.
"""
struct TargetInfo
    ptr::CXTargetInfo_
end

function TargetInfo(opts::TargetOptions, diag::DiagnosticsEngine=DiagnosticsEngine())
    @assert opts.ptr != C_NULL "TargetOptions has a NULL pointer."
    @assert diag.ptr != C_NULL "DiagnosticsEngine has a NULL pointer."
    info = clang_TargetInfo_CreateTargetInfo(diag.ptr, opts.ptr)
    return TargetInfo(info)
end
