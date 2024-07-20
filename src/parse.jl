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

# function parse(instance::CompilerInstance, parser::Parser, codegen::CodeGenerator)
#     diag_csr = getDiagnosticClient(instance)

#     preprocessor = getPreprocessor(instance)
#     EnterMainSourceFile(preprocessor)
#     InitializeBuiltins(preprocessor)

#     begin_source_file(diag_csr, getLangOpts(instance), preprocessor)

#     initialize(parser)

#     sema = getSema(instance)
#     ast_ctx = getASTContext(instance)

#     if tryParseAndSkipInvalidOrParsedDecl(parser, codegen)
#         processWeakTopLevelDecls(sema, codegen)
#         HandleTranslationUnit(codegen, ast_ctx)
#         end_source_file(diag_csr)
#         return true
#     else
#         end_source_file(diag_csr)
#         return false
#     end
# end

"""
    parse_cxx_scope_spec(x::AbstractInterpreter, ss::CXXScopeSpec, code::AbstractString) -> String
Parse the C++ decl specifier w.r.t current translation unit and extract the scope specifier to `ss`.
Return the tailing type name if it can be extracted. Otherwise, return "".

For `std::vector<int>::size_type`, it will extract `std::vector<int>::` and return "size_type".
For `std::vector<int>::`, it will extract `std::vector<int>::` and return "".
For `std::vector<int>`, it will extract `std::` and return "". (`vector<int>` is used as a template-id)
For `std::vector`, it will extract `std::` and return "vector". (`vector` is used as an identifier)
For `std::`, it will extract `std::` and return "".
For `std`, it will extract nothing and return "std". (`std` is used as an identifier)
"""
function parse_cxx_scope_spec(x::AbstractInterpreter, ss::CXXScopeSpec, code::AbstractString)
    ci, p = getCompilerInstance(x), getParser(x)
    src_mgr, pp, sema = getSourceManager(ci), getPreprocessor(p), getSema(p)
    begin_diag(ci)
    fid = FileID(src_mgr, get_buffer(code))
    setShowColors(ci, true)
    try
        EnterSourceFile(pp, fid)
        # the preprocessor should be in incremental mode
        @assert is_incremental(pp)
        # parse the scope spec and the type
        tok = getCurToken(p)
        is_annot_repl_input_end(tok) && ConsumeAnyToken(p)
        # try to annotate the current token in the following cases:
        # nested-name-specifier 'template'[opt] simple-template-id '::'
        # template-id '::'
        # type-name '::'
        # namespace-name '::'
        # nested-name-specifier identifier '::'
        # type-name '<'
        TryAnnotateOptionalCXXScopeToken(p, CXDeclSpecContext_DSC_top_level)
        type_name = ""
        while !is_annot_repl_input_end(tok)
            if is_coloncolon(tok)
                ConsumeAnyToken(p) # ignore all `::`s
            elseif is_annot_cxxscope(tok)
                restore_nns_annotation(sema, tok, ss) # extract the scope specifier
                ConsumeAnyToken(p)
            elseif is_identifier(tok)
                type_name = getName(getIdentifierInfo(tok)) # extract (possible-) type name
                ConsumeToken(p)
            elseif is_annot_template_id(tok)
                ConsumeAnyToken(p) # ignore template-ids
            elseif is_annot_typename(tok)
                ConsumeAnyToken(p) # actually impossible to reach here
            else
                # ignore anything until EOF(annot_repl_input_end)
                ConsumeAnyToken(p)
            end
        end
        return type_name
    finally
        tok = getCurToken(p)
        while !is_annot_repl_input_end(tok)
            ConsumeAnyToken(p)
        end
        EndSourceFile(pp)
        dispose(fid)
        end_diag(ci)
    end
end
