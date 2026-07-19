for sym in [:MangleContext, :ASTNameGenerator]
    cxsym = Symbol("CX", sym)
    @eval begin
        """
            struct $($(QuoteNode(sym)))
        Hold a pointer to a `clang::$($(QuoteNode(sym)))` object.
        """
        struct $sym
            ptr::$cxsym
        end

        Base.unsafe_convert(::Type{$cxsym}, x::$sym) = x.ptr
        Base.cconvert(::Type{$cxsym}, x::$sym) = x
    end
end
