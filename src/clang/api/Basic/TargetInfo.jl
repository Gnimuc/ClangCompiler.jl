# TargetInfo
function TargetInfo(opts::TargetOptions, diag::DiagnosticsEngine=DiagnosticsEngine())
    @check_ptrs opts diag
    info = clang_TargetInfo_CreateTargetInfo(diag.ptr, opts.ptr)
    return TargetInfo(info)
end
