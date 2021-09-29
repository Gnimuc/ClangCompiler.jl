function ParseAST(sema::Sema, PrintStats::Bool=false, SkipFunctionBodies::Bool=false)
    @check_ptrs sema
    clang_ParseAST(sema, PrintStats, SkipFunctionBodies)
    return nothing
end

function tryParseAndSkipInvalidOrParsedDecl(p::Parser, cg::CodeGenerator)
    @check_ptrs p cg
    return clang_Parser_tryParseAndSkipInvalidOrParsedDecl(p, cg)
end
