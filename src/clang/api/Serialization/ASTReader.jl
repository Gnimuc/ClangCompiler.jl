# ASTReader — the two static utilities that inspect a PCH/AST file without loading it.
#
# Both take a `PCHContainerReader` upstream; the shim supplies the only one this package
# produces (the stateless `RawPCHContainerReader`) and keeps it out of the signature, so
# neither wrapper has a parameter for it.

"""
    getOriginalSourceFile(ast_file_name, file_mgr::AbstractFileManager, diags::AbstractDiagnosticsEngine) -> String
Return the source file the AST file at `ast_file_name` was built from, read straight out of
its control block without loading it.

Return `""` when the file cannot be read or is not an AST file; the reason is reported
through `diags`, so a caller that wants it should attach a
[`TextDiagnosticBuffer`](@ref) first.
"""
function getOriginalSourceFile(ast_file_name::AbstractString, file_mgr::AbstractFileManager,
                               diags::AbstractDiagnosticsEngine)
    @check_ptrs file_mgr diags
    return get_string(clang_ASTReader_getOriginalSourceFile(ast_file_name, file_mgr, diags))
end

"""
    isAcceptableASTFile(filename, file_mgr, lang_opts, target_opts, pp_opts; existing_module_cache_path="", require_strict_option_matches=false) -> Bool
Return whether the AST file at `filename` can be loaded into a translation unit compiled
with the given `LangOptions`, `TargetOptions` and `PreprocessorOptions`.

This is the pre-flight check clang's driver runs before attaching an implicit PCH: it turns
a diagnostic-spewing load failure into a clean rebuild decision. No diagnostics are
emitted — the answer is the returned `Bool`, and a missing or corrupt file is simply not
acceptable.

`existing_module_cache_path` is the module cache a loaded module file must have come from;
`require_strict_option_matches` turns benign option differences into rejections. Both
defaults match clang's.
"""
function isAcceptableASTFile(filename::AbstractString, file_mgr::AbstractFileManager,
                             lang_opts::AbstractLangOptions,
                             target_opts::AbstractTargetOptions,
                             pp_opts::AbstractPreprocessorOptions;
                             existing_module_cache_path::AbstractString="",
                             require_strict_option_matches::Bool=false)
    @check_ptrs file_mgr lang_opts target_opts pp_opts
    return clang_ASTReader_isAcceptableASTFile(filename, file_mgr, lang_opts, target_opts,
                                               pp_opts, existing_module_cache_path,
                                               require_strict_option_matches)
end
