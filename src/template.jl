function specialize(llvm_ctx::LLVM.Context, ctx::ASTContext, template_decl::ClassTemplateDecl, args...)
    arg_vec = Vector{TemplateArgument}(undef, length(args))
    for (i, arg) in enumerate(args)
        if arg isa Bool
            jlty = typeof(arg)
            clty = jlty_to_clty(jlty, ctx)
            bitwidth_clty = getTypeSize(ctx, clty)
            # this assumes Bool is lowered to int8
            @assert bitwidth_clty == 8
            v = LLVM.GenericValue(jlty_to_llvmty(jlty, llvm_ctx), Int(arg))
            @assert LLVM.intwidth(v) == bitwidth_clty
            arg_vec[i] = TemplateArgument(ctx, v, clty)
            dispose(v)
        elseif arg isa Integer
            int_jlty = typeof(arg)
            int_clty = jlty_to_clty(int_jlty, ctx)
            bitwidth_clty = getTypeSize(ctx, int_clty)
            v = LLVM.GenericValue(jlty_to_llvmty(int_jlty, llvm_ctx), arg)
            @assert LLVM.intwidth(v) == bitwidth_clty
            arg_vec[i] = TemplateArgument(ctx, v, int_clty)
            dispose(v)
        elseif arg isa AbstractType
            arg_vec[i] = TemplateArgument(arg)
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
