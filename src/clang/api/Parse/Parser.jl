# Parser
function Parser(pp::Preprocessor, sema::Sema, skip_func_body::Bool=false)
    @check_ptrs pp sema
    p = clang_Parser_create(pp, sema, skip_func_body)
    @assert p != C_NULL "Failed to create Parser"
    return Parser(p)
end

dispose(x::Parser) = clang_Parser_dispose(x)

function Initialize(x::Parser)
    @check_ptrs x
    return clang_Parser_Initialize(x)
end

function getLangOpts(x::Parser)
    @check_ptrs x
    return clang_Parser_getLangOpts(x)
end

function getTargetInfo(x::Parser)
    @check_ptrs x
    return TargetInfo(clang_Parser_getTargetInfo(x))
end

function getPreprocessor(x::Parser)
    @check_ptrs x
    return Preprocessor(clang_Parser_getPreprocessor(x))
end

function getActions(x::Parser)
    @check_ptrs x
    return Sema(clang_Parser_getActions(x))
end

# function parseOneTopLevelDecl(x::Parser, is_first_decl::Bool=false)
#     @check_ptrs x
#     return DeclGroupRef(clang_Parser_parseOneTopLevelDecl(x, is_first_decl))
# end

function getCurToken(x::Parser)
    @check_ptrs x
    return Token(clang_Parser_getCurToken(x))
end

function NextToken(x::Parser)
    @check_ptrs x
    return Token(clang_Parser_NextToken(x))
end

function ConsumeToken(x::Parser)
    @check_ptrs x
    return SourceLocation(clang_Parser_ConsumeToken(x))
end

function ConsumeAnyToken(x::Parser)
    @check_ptrs x
    return SourceLocation(clang_Parser_ConsumeAnyToken(x))
end

function getCurScope(x::Parser)
    @check_ptrs x
    return Scope(clang_Parser_getCurScope(x))
end


# should be sync to Clang's implementation
function getDeclSpecContextFromDeclaratorContext(ctx::CXDeclaratorContext)
    if ctx == CXDeclaratorContext_Member
        return CXDeclSpecContext_DSC_class
    elseif ctx == CXDeclaratorContext_File
        return CXDeclSpecContext_DSC_top_level
    elseif ctx == CXDeclaratorContext_TemplateParam
        return CXDeclSpecContext_DSC_template_param
    elseif ctx == CXDeclaratorContext_TemplateArg
        return CXDeclSpecContext_DSC_template_arg
    elseif ctx == CXDeclaratorContext_TemplateTypeArg
        return CXDeclSpecContext_DSC_template_type_arg
    elseif ctx == CXDeclaratorContext_TrailingReturn ||
           ctx == CXDeclaratorContext_TrailingReturnVar
        return CXDeclSpecContext_DSC_trailing
    elseif ctx == CXDeclaratorContext_AliasDecl || ctx == CXDeclaratorContext_AliasTemplate
        return CXDeclSpecContext_DSC_alias_declaration
    elseif ctx == CXDeclaratorContext_Association
        return CXDeclSpecContext_DSC_association
    elseif ctx == CXDeclaratorContext_TypeName
        return CXDeclSpecContext_DSC_type_specifier
    elseif ctx == CXDeclaratorContext_Condition
        return CXDeclSpecContext_DSC_condition
    elseif ctx == CXDeclaratorContext_ConversionId
        return CXDeclSpecContext_DSC_conv_operator
    elseif ctx == CXDeclaratorContext_CXXNew
        return CXDeclSpecContext_DSC_new
    else
        return CXDeclSpecContext_DSC_normal
    end
end

function shouldEnterContext(ctx::CXDeclSpecContext)
    return ctx == CXDeclSpecContext_DSC_top_level || ctx == CXDeclSpecContext_DSC_class
end

"""
    TryAnnotateCXXScopeToken(x::Parser, entering_context)
Return true if there was an error.
"""
function TryAnnotateCXXScopeToken(x::Parser, entering_context::Bool)
    @check_ptrs x
    return clang_Parser_TryAnnotateCXXScopeToken(x, entering_context)
end

function TryAnnotateCXXScopeToken(x::Parser, ctx::CXDeclSpecContext)
    return TryAnnotateCXXScopeToken(x, shouldEnterContext(ctx))
end

function TryAnnotateCXXScopeToken(x::Parser, dlctx::CXDeclaratorContext)
    ctx = getDeclSpecContextFromDeclaratorContext(dlctx)
    return TryAnnotateCXXScopeToken(x, ctx)
end

function TryAnnotateOptionalCXXScopeToken(x::Parser, entering_context::Bool)
    @check_ptrs x
    return clang_Parser_TryAnnotateOptionalCXXScopeToken(x, entering_context)
end

function TryAnnotateOptionalCXXScopeToken(x::Parser, ctx::CXDeclSpecContext)
    return TryAnnotateOptionalCXXScopeToken(x, shouldEnterContext(ctx))
end

function TryAnnotateOptionalCXXScopeToken(x::Parser, dlctx::CXDeclaratorContext)
    ctx = getDeclSpecContextFromDeclaratorContext(dlctx)
    return TryAnnotateOptionalCXXScopeToken(x, ctx)
end

"""
    TryAnnotateTypeOrScopeToken(x::Parser, allow_implicit_typename::Bool=false)
Return true if there was an error.
"""
function TryAnnotateTypeOrScopeToken(x::Parser, allow_implicit_typename::Bool=false)
    @check_ptrs x
    return clang_Parser_TryAnnotateTypeOrScopeToken(x, allow_implicit_typename)
end

"""
    TryAnnotateTypeOrScopeTokenAfterScopeSpec(x::Parser, ss::CXXScopeSpec, is_new_scope::Bool=false, allow_implicit_typename::Bool=false)
Return true if there was an error.
"""
function TryAnnotateTypeOrScopeTokenAfterScopeSpec(x::Parser, ss::CXXScopeSpec,
                                                   is_new_scope::Bool=false,
                                                   allow_implicit_typename::Bool=false)
    @check_ptrs x ss
    return clang_Parser_TryAnnotateTypeOrScopeTokenAfterScopeSpec(x, ss, is_new_scope, allow_implicit_typename)
end

function getTypeAnnotation(x::Token)
    @check_ptrs x
    return QualType(clang_Parser_getTypeAnnotation(x))
end
