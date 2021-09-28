function parse_ast(sema::Sema, PrintStats::Bool=false, SkipFunctionBodies::Bool=false)
    @check_ptrs sema
    clang_ParseAST(sema, PrintStats, SkipFunctionBodies)
    return nothing
end
