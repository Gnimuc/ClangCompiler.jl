for sym in [:AccessSpecDecl,
            :CXXRecordDecl,
            :CXXDeductionGuideDecl,
            :RequiresExprBodyDecl,
            :CXXMethodDecl,
            :CXXConstructorDecl,
            :CXXDestructorDecl,
            :CXXConversionDecl,
            :LinkageSpecDecl,
            :UsingDirectiveDecl,
            :NamespaceAliasDecl,
            :LifetimeExtendedTemporaryDecl,
            :UsingShadowDecl,
            :ConstructorUsingShadowDecl,
            :UsingDecl,
            :UsingPackDecl,
            :UnresolvedUsingValueDecl,
            :UnresolvedUsingTypenameDecl,
            :StaticAssertDecl,
            :BindingDecl,
            :DecompositionDecl,
            :MSPropertyDecl,
            :MSGuidDecl]
    asym = Symbol("Abstract", sym)
    cxsym = Symbol("CX", sym)

    @eval begin
        struct $sym <: $asym
            ptr::$cxsym
        end

        Base.unsafe_convert(::Type{$cxsym}, x::$sym) = x.ptr
        Base.cconvert(::Type{$cxsym}, x::$sym) = x
    end
end

# Standalone value classes (no AST-node hierarchy): a base-class edge in a
# CXXRecordDecl, and the explicit(...) specifier on a constructor/conversion.
for sym in [:CXXBaseSpecifier, :ExplicitSpecifier]
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
