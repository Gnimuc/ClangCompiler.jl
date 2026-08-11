"""
    specialize(ctx::ASTContext, template_decl::ClassTemplateDecl, args...)
Return the [`ClassTemplateSpecializationDecl`](@ref) of `template_decl` specialized on
`args`, creating and registering it first if the specialization does not exist yet.

Each argument is either a Julia `Bool`/`Integer` (a non-type template argument) or an
`AbstractType` (a type template argument).
"""
function specialize(ctx::ASTContext, template_decl::ClassTemplateDecl, args...)
    params = getTemplateParameters(template_decl)

    # One TemplateArgument from one Julia value, at the type the parameter declares.
    function build(arg, declared)
        if arg isa Union{Bool,Integer}
            jlty = typeof(arg)
            clty = declared === nothing ? get_qual_type(jlty_to_clty(jlty, ctx)) : declared
            # The width and the signedness come from `clty`, exactly as clang does, so the
            # value itself is all this has to carry.
            return TemplateArgument(ctx, Int(arg), clty)
        elseif arg isa AbstractType
            return TemplateArgument(get_qual_type(arg))
        else
            error("failed to specialize $arg")
        end
    end

    # Walk the PARAMETERS, not the arguments, because the two are not one-to-one: a parameter
    # pack takes all the arguments left. Sema folds a pack into a single `Pack` argument, and
    # `ClassTemplateSpecializationDecl::Profile` folds the argument count before anything else,
    # so `Pk<1,2,3>` built as three arguments can never unify with Sema's one.
    arg_vec = TemplateArgument[]
    next = 1
    pi = 1
    while next <= length(args)
        p = pi <= size(params) ? resolve(getParam(params, pi - 1)) : nothing
        declared = p isa NonTypeTemplateParmDecl ? getCanonicalType(ctx, getType(p)) : nothing
        if p !== nothing && isParameterPack(p)
            push!(arg_vec, CreatePackCopy(ctx, TemplateArgument[build(args[j], declared) for j = next:length(args)]))
            next = length(args) + 1
        else
            push!(arg_vec, build(args[next], declared))
            next += 1
        end
        pi += 1
    end

    arg_list = TemplateArgumentList(ctx, arg_vec)
    specialization_decl = findSpecialization(template_decl, arg_list)

    if specialization_decl.ptr == C_NULL
        specialization_decl = ClassTemplateSpecializationDecl(ctx, template_decl, arg_list)
        AddSpecialization(template_decl, specialization_decl)
        if isOutOfLine(template_decl)
            lexical_decl_ctx = getLexicalDeclContext(template_decl)
            setLexicalDeclContext(specialization_decl, lexical_decl_ctx)
        end
    end

    # dispose.(arg_vec)  # FIXME: free NULL pointer

    return specialization_decl
end
