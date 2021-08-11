function specialize(llvm_ctx::LLVM.Context, ctx::ASTContext, template_decl::ClassTemplateDecl, args...)
    arg_vec = Vector{TemplateArgument}(undef, length(args))
    for (i, arg) in enumerate(args)
        if arg isa Bool
            jlty = typeof(arg)
            clty = jlty_to_clty(jlty, ctx)
            bitwidth_clty = get_type_size(ctx, clty)
            # this assumes Bool is lowered to int1
            @assert bitwidth_clty == 1
            v = LLVM.GenericValue(jlty_to_llvmty(jlty, llvm_ctx), Int(arg))
            @assert LLVM.intwidth(v) == bitwidth_clty
            arg_vec[i] = TemplateArgument(ctx, v, clty)
        elseif arg isa Integer
            int_jlty = typeof(arg)
            int_clty = jlty_to_clty(int_jlty, ctx)
            bitwidth_clty = get_type_size(ctx, int_clty)
            v = LLVM.GenericValue(jlty_to_llvmty(int_jlty, llvm_ctx), arg)
            @assert LLVM.intwidth(v) == bitwidth_clty
            arg_vec[i] = TemplateArgument(ctx, v, clty)
        elseif arg isa QualType
            arg_vec[i] = TemplateArgument(arg)
        else
            error("failed to specialize $arg")
        end
    end
    arg_list = TemplateArgumentList(ctx, arg_vec)
    new_decl = find_specialization(template_decl, arg_list)
    dispose.(arg_vec)
    return new_decl
end
