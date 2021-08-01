function parse_ast(sema::Sema, PrintStats::Bool=false, SkipFunctionBodies::Bool=false)
    @assert sema.ptr != C_NULL "Sema has a NULL pointer."
    clang_ParseAST(sema.ptr, PrintStats, SkipFunctionBodies)
    return nothing
end
