function parse(instance::CompilerInstance)
    begin_diag(instance)
    try
        InitializeBuiltins(getPreprocessor(instance))
        ParseAST(getSema(instance))
    finally
        end_diag(instance)
    end
    return true
end

function parse(instance::CompilerInstance, parser::Parser, codegen::CodeGenerator)
    diag_csr = getDiagnosticClient(instance)

    preprocessor = getPreprocessor(instance)
    EnterMainSourceFile(preprocessor)
    InitializeBuiltins(preprocessor)

    begin_source_file(diag_csr, getLangOpts(instance), preprocessor)

    initialize(parser)

    sema = getSema(instance)
    ast_ctx = getASTContext(instance)

    if tryParseAndSkipInvalidOrParsedDecl(parser, codegen)
        processWeakTopLevelDecls(sema, codegen)
        HandleTranslationUnit(codegen, ast_ctx)
        end_source_file(diag_csr)
        return true
    else
        end_source_file(diag_csr)
        return false
    end
end



function parse_cxx_scope_spec(p::Parser, spec::CXXScopeSpec)
    sema = getSema(p)
    pp = getPreprocessor(p)
    tok = getCurToken(p)
    is_incremental(pp) && is_eof(tok) && ConsumeToken(p)
    while !is_eof(tok)
        if is_coloncolon(tok)  # `::foo::bar::baz`
            TryAnnotateCXXScopeToken(p) && error("failed to annotate token.")
        elseif is_identifier(tok)  # `foo::bar::baz`
            TryAnnotateCXXScopeToken(p) && error("failed to annotate token.")
            if !is_identifier(tok)
                continue
            else
                ConsumeToken(p)
            end
        elseif is_annot_cxxscope(tok) || is_annot_typename(tok)
            restore_nns_annotation(sema, tok, spec)
            break
        elseif is_annot_template_id(tok)
            TryAnnotateTypeOrScopeTokenAfterScopeSpec(p, spec)
            break
        else  # skip other cases which we may add support in the future
            ConsumeAnyToken(p)
        end
    end
    # parse to the end of file, ignore everything
    while !is_eof(tok)
        ConsumeAnyToken(p)
    end
    return nothing
end

function parse_cxx_scope_spec(p::Parser, fid::FileID, spec::CXXScopeSpec)
    pp = getPreprocessor(p)
    EnterSourceFile(pp, fid)
    try
        parse_cxx_scope_spec(p, spec)
    finally
        EndSourceFile(pp)
    end
    return nothing
end

function parse_cxx_scope_spec(ci::CompilerInstance, p::Parser, str::String, spec::CXXScopeSpec)
    src_mgr = getSourceManager(ci)
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
