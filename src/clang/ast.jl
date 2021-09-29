# AST
"""
    get_identifier_table(x::ASTContext)
Return the [`IdentifierTable`](@ref) in the [`ASTContext`](@ref).
"""
get_identifier_table(x::ASTContext) = getIdents(x)

get_name(x::ASTContext, s::String) = get(getIdents(x), s)

function get_builtin_type(ctx::ASTContext, ::Type{T}) where {T<:AbstractBuiltinType}
    @check_ptrs ctx
    return T(ctx)
end

function begin_source_file(consumer::T, lang::LangOptions,
    pp::Preprocessor) where {T<:AbstractDiagnosticConsumer}
@check_ptrs pp
return begin_source_file(consumer, lang, pp)
end

# Decl
get_ast_context(x::AbstractDecl) = getASTContext(x)
get_ast_context(x::DeclContext) = getParentASTContext(x)

get_name(x::AbstractNamedDecl) = getName(x)
get_name(x::DeclarationName) = getAsString(x)

get_begin_loc(x::AbstractDecl) = getBeginLoc(x)
get_end_loc(x::AbstractDecl) = getEndLoc(x)
get_loc(x::AbstractDecl) = getLocation(x)

dump(x::AbstractDecl) = dumpColor(x)

Base.isempty(x::DeclarationName) = isEmpty(x)
Base.string(x::DeclarationName) = get_as_string(x)

dump(x::CXXScopeSpec) = dump(getScopeRep(x))
