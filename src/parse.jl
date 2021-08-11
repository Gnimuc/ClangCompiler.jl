function parse(instance::CompilerInstance)
    begin_diag(instance)
    try
        initialize_builtins(get_preprocessor(instance))
        parse_ast(get_sema(instance))
    finally
        end_diag(instance)
    end
    return true
end

function parse(instance::CompilerInstance, parser::Parser, codegen::CodeGenerator)
    diag_csr = get_diagnostic_client(instance)

    preprocessor = get_preprocessor(instance)
    enter_main_file(preprocessor)
    initialize_builtins(preprocessor)

    begin_source_file(diag_csr, get_lang_options(instance), preprocessor)

    initialize(parser)

    sema = get_sema(instance)
    ast_ctx = get_ast_context(instance)

    if try_parse_and_skip_invalid_or_parsed_decl(parser, codegen)
        process_weak_toplevel_decls(sema, codegen)
        handle_translation_unit(codegen, ast_ctx)
        end_source_file(diag_csr)
        return true
    else
        end_source_file(diag_csr)
        return false
    end
end

function try_parse_and_skip_invalid_or_parsed_decl(p::Parser, cg::CodeGenerator)
    @assert p.ptr != C_NULL "Parser has a NULL pointer."
    @assert cg.ptr != C_NULL "CodeGenerator has a NULL pointer."
    return clang_Parser_tryParseAndSkipInvalidOrParsedDecl(p.ptr, cg.ptr)
end

function process_weak_toplevel_decls(sema::Sema, cg::CodeGenerator)
    @assert sema.ptr != C_NULL "Sema has a NULL pointer."
    @assert cg.ptr != C_NULL "CodeGenerator has a NULL pointer."
    clang_Sema_processWeakTopLevelDecls(sema.ptr, cg.ptr)
    return nothing
end

function parse_cxx_scope_spec(p::Parser, spec::CXXScopeSpec)
    sema = get_sema(p)
    pp = get_preprocessor(p)
    tok = get_current_token(p)
    is_incremental(pp) && is_eof(tok) && consume_token(p)
    while !is_eof(tok)
        if is_coloncolon(tok)  # `::foo::bar::baz`
            try_annotate_cxx_scope_token(p) && error("failed to annotate token.")
        elseif is_identifier(tok)  # `foo::bar::baz`
            try_annotate_cxx_scope_token(p) && error("failed to annotate token.")
            if !is_identifier(tok)
                continue
            else
                consume_token(p)
            end
        elseif is_annot_cxxscope(tok) || is_annot_typename(tok)
            restore_nns_annotation(sema, tok, spec)
            break
        elseif is_annot_template_id(tok)
            try_annotate_type_or_scope_token_after_scope_spec(p, spec)
            break
        else  # skip other cases which we may add support in the future
            consume_any_token(p)
        end
    end
    # parse to the end of file, ignore everything
    while !is_eof(tok)
        consume_any_token(p)
    end
    return nothing
end

function parse_cxx_scope_spec(p::Parser, fid::FileID, spec::CXXScopeSpec)
    pp = get_preprocessor(p)
    enter_file(pp, fid)
    try
        parse_cxx_scope_spec(p, spec)
    finally
        end_file(pp)
    end
    return nothing
end

function parse_cxx_scope_spec(ci::CompilerInstance, p::Parser, str::String, spec::CXXScopeSpec)
    src_mgr = get_source_manager(ci)
    begin_diag(ci)
    fid = FileID(src_mgr, get_buffer(str))
    try
        parse_cxx_scope_spec(p, fid, spec)
    finally
        dispose(fid)
        end_diag(ci)
    end
    return nothing
end
