# ReplCodeCompleter
"""
    codeComplete(interp_ci::AbstractCompilerInstance, content::AbstractString, line::Integer, col::Integer, parent_ci::AbstractCompilerInstance) -> (Vector{String}, String)
Return the C++ completion candidates at (`line`, `col`) in `content`, together with the
prefix they complete.

`interp_ci` is a compiler instance built for this request — clang-repl passes a fresh
`CreateCpp` — while `parent_ci` is the running interpreter's instance, which supplies the
`ASTContext` names are looked up in. Neither is consumed. Both coordinates are 1-based, as
clang counts source positions.

`clang::ReplCodeCompleter` keeps no state worth a handle beyond the prefix, so it is built
and dropped inside the call.
"""
function codeComplete(interp_ci::AbstractCompilerInstance, content::AbstractString, line::Integer, col::Integer, parent_ci::AbstractCompilerInstance)
    @check_ptrs interp_ci parent_ci
    prefix = Ref{CXString}()
    results = get_string(clang_ReplCodeCompleter_codeComplete(interp_ci, content, line, col, parent_ci, prefix))
    return results, get_string(prefix[])
end
