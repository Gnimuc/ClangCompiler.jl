get_name(x::ASTContext, s::String) = get_name(getIdents(x), s)

function get_builtin_type(ctx::ASTContext, ::Type{T}) where {T<:AbstractBuiltinType}
    @check_ptrs ctx
    return T(ctx)
end

get_ast_context(x::AbstractDecl) = getASTContext(x)
get_ast_context(x::DeclContext) = getParentASTContext(x)


dump(x::AbstractDecl) = dumpColor(x)


get_location(x::AbstractDecl) = getLocation(x)

get_begin_loc(x::AbstractDecl) = getBeginLoc(x)
get_end_loc(x::AbstractDecl) = getEndLoc(x)


function get_as_string(x::DeclarationName)
    str = clang_DeclarationName_getAsString(x.ptr)
    s = unsafe_string(str)
    clang_DeclarationName_disposeString(str)
    return s
end

name(x::DeclarationName) = get_as_string(x)

Base.string(x::DeclarationName) = get_as_string(x)

is_empty(x::DeclarationName) = isEmpty(x)


get_name(x::IdentifierTable, s::String) = get(x, s)
