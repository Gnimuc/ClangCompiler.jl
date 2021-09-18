"""
    struct TargetInfo <: Any
Hold a pointer to a `clang::TargetInfo` object.
"""
struct TargetInfo
    ptr::CXTargetInfo_
end

function TargetInfo(opts::TargetOptions, diag::DiagnosticsEngine=DiagnosticsEngine())
    @check_ptrs opts diag
    info = clang_TargetInfo_CreateTargetInfo(diag.ptr, opts.ptr)
    return TargetInfo(info)
end
