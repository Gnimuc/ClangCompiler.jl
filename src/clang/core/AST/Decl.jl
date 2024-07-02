for sym in [:TranslationUnitDecl,
            :PragmaCommentDecl,
            :PragmaDetectMismatchDecl,
            :ExternCContextDecl,
            :NamedDecl,
            :LabelDecl,
            :NamespaceDecl,
            :ValueDecl,
            :DeclaratorDecl,
            :VarDecl,
            :ImplicitParamDecl,
            :ParmVarDecl,
            :FunctionDecl,
            :FieldDecl,
            :EnumConstantDecl,
            :IndirectFieldDecl,
            :TypeDecl,
            :TypedefNameDecl,
            :TypedefDecl,
            :TypeAliasDecl,
            :TagDecl,
            :EnumDecl,
            :RecordDecl,
            :FileScopeAsmDecl,
            :BlockDecl,
            :CapturedDecl,
            :ImportDecl,
            :ExportDecl,
            :EmptyDecl]
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
