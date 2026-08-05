"""
    specialize(llvm_ctx::LLVM.Context, ctx::ASTContext, template_decl::ClassTemplateDecl, args...)
Return the [`ClassTemplateSpecializationDecl`](@ref) of `template_decl` specialized on
`args`, creating and registering it first if the specialization does not exist yet.

Each argument is either a Julia `Bool`/`Integer` (a non-type template argument) or an
`AbstractType` (a type template argument).
"""
function specialize(llvm_ctx::LLVM.Context, ctx::ASTContext, template_decl::ClassTemplateDecl, args...)
    arg_vec = Vector{TemplateArgument}(undef, length(args))
    params = getTemplateParameters(template_decl)
    # The parameter's own type, when the template has one at this position and it is a non-type
    # parameter. Guessing the C type from the Julia one instead cannot work: `jlty_to_clty` maps
    # `Int64` to `long long`, so a `template <long N>` argument built that way carries a
    # different QualType from the one Sema uses -- and `TemplateArgument::Profile` folds the
    # integral type, so the two never unify in the folding set.
    function param_type(i)
        i <= size(params) || return nothing
        p = resolve(getParam(params, i - 1))
        return p isa NonTypeTemplateParmDecl ? getType(p) : nothing
    end
    for (i, arg) in enumerate(args)
        if arg isa Union{Bool,Integer}
            declared = param_type(i)
            jlty = typeof(arg)
            clty = declared === nothing ? get_qual_type(jlty_to_clty(jlty, ctx)) : declared
            # The GenericValue only carries the bits; the shim takes the width and the
            # signedness of the argument from `clty`, exactly as clang does.
            v = LLVM.GenericValue(jlty_to_llvmty(jlty, llvm_ctx), Int(arg))
            arg_vec[i] = TemplateArgument(ctx, v, clty)
            LLVM.dispose(v)
        elseif arg isa AbstractType
            arg_vec[i] = TemplateArgument(get_qual_type(arg))
        else
            error("failed to specialize $arg")
        end
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
