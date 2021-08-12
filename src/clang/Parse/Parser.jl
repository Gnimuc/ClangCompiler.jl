"""
    struct Parser <: Any
Hold a pointer to a `clang::Parser` object.
"""
struct Parser
    ptr::CXParser
end

function Parser(pp::Preprocessor, sema::Sema, skip_func_body::Bool=false)
    @assert pp.ptr != C_NULL "Preprocessor has a NULL pointer."
    @assert sema.ptr != C_NULL "Sema has a NULL pointer."
    status = Ref{CXInit_Error}(CXInit_NoError)
    p = clang_Parser_create(pp.ptr, sema.ptr, skip_func_body, status)
    @assert status[] == CXInit_NoError
    return Parser(p)
end

dispose(x::Parser) = clang_Parser_dispose(x.ptr)

function initialize(x::Parser)
    @assert x.ptr != C_NULL "Parser has a NULL pointer."
    return clang_Parser_Initialize(x.ptr)
end

function get_lang_options(x::Parser)
    @assert x.ptr != C_NULL "Parser has a NULL pointer."
    return clang_Parser_getLangOpts(x.ptr)
end

function get_target_info(x::Parser)
    @assert x.ptr != C_NULL "Parser has a NULL pointer."
    return TargetInfo(clang_Parser_getTargetInfo(x.ptr))
end

get_target(x::Parser) = get_target_info(x)

function get_preprocessor(x::Parser)
    @assert x.ptr != C_NULL "Parser has a NULL pointer."
    return Preprocessor(clang_Parser_getPreprocessor(x.ptr))
end

function get_actions(x::Parser)
    @assert x.ptr != C_NULL "Parser has a NULL pointer."
    return Sema(clang_Parser_getActions(x.ptr))
end

get_sema(x::Parser) = get_actions(x)

function parse_decl(x::Parser, is_first_decl::Bool=false)
    @assert x.ptr != C_NULL "Parser has a NULL pointer."
    return DeclGroupRef(clang_Parser_parseOneTopLevelDecl(x.ptr, is_first_decl))
end

function get_current_token(x::Parser)
    @assert x.ptr != C_NULL "Parser has a NULL pointer."
    return Token(clang_Parser_getCurToken(x.ptr))
end

function get_next_token(x::Parser)
    @assert x.ptr != C_NULL "Parser has a NULL pointer."
    return Token(clang_Parser_NextToken(x.ptr))
end

function consume_token(x::Parser)
    @assert x.ptr != C_NULL "Parser has a NULL pointer."
    return SourceLocation(clang_Parser_ConsumeToken(x.ptr))
end

function consume_any_token(x::Parser)
    @assert x.ptr != C_NULL "Parser has a NULL pointer."
    return SourceLocation(clang_Parser_ConsumeAnyToken(x.ptr))
end

function get_current_scope(x::Parser)
    @assert x.ptr != C_NULL "Parser has a NULL pointer."
    return Scope(clang_Parser_getCurScope(x.ptr))
end

# should be sync to Clang's implementation
function get_decl_spec_context_from_declarator_context(ctx::CXDeclaratorContext)
    if ctx == CXDeclaratorContext_Member
        return CXDeclSpecContext_DSC_class
    elseif ctx == CXDeclaratorContext_File
        return CXDeclSpecContext_DSC_top_level
    elseif ctx == CXDeclaratorContext_TemplateParam
        return CXDeclSpecContext_DSC_template_param
    elseif ctx == CXDeclaratorContext_TemplateArg ||
           ctx == CXDeclaratorContext_TemplateTypeArg
        return CXDeclSpecContext_DSC_template_type_arg
    elseif ctx == CXDeclaratorContext_TrailingReturn ||
           ctx == CXDeclaratorContext_TrailingReturnVar
        return CXDeclSpecContext_DSC_trailing
    elseif ctx == CXDeclaratorContext_AliasDecl || ctx == CXDeclaratorContext_AliasTemplate
        return CXDeclSpecContext_DSC_alias_declaration
    else
        return CXDeclSpecContext_DSC_normal
    end
end

function should_enter_context(ctx::CXDeclSpecContext)
    return ctx == CXDeclSpecContext_DSC_top_level || ctx == CXDeclSpecContext_DSC_class
end

"""
    try_annotate_cxx_scope_token(x::Parser, entering_context)
Return true if there was an error.
"""
function try_annotate_cxx_scope_token(x::Parser, entering_context::Bool)
    @assert x.ptr != C_NULL "Parser has a NULL pointer."
    return clang_Parser_TryAnnotateCXXScopeToken(x.ptr, entering_context)
end

function try_annotate_cxx_scope_token(x::Parser, ctx::CXDeclSpecContext)
    return try_annotate_cxx_scope_token(x, should_enter_context(ctx))
end

function try_annotate_cxx_scope_token(x::Parser, dlctx::CXDeclaratorContext)
    ctx = get_decl_spec_context_from_declarator_context(dlctx)
    return try_annotate_cxx_scope_token(x, ctx)
end

function try_annotate_cxx_scope_token(x::Parser)
    return try_annotate_cxx_scope_token(x, CXDeclSpecContext_DSC_top_level)
end

"""
    try_annotate_type_or_scope_token_after_scope_spec(x::Parser, ss::CXXScopeSpec, is_new_scope::Bool=false)
Return true if there was an error.
"""
function try_annotate_type_or_scope_token_after_scope_spec(x::Parser, ss::CXXScopeSpec,
                                                           is_new_scope::Bool=false)
    @assert x.ptr != C_NULL "Parser has a NULL pointer."
    @assert ss.ptr != C_NULL "CXXScopeSpec has a NULL pointer."
    return clang_Parser_TryAnnotateTypeOrScopeTokenAfterScopeSpec(x.ptr, ss.ptr,
                                                                  is_new_scope)
end
