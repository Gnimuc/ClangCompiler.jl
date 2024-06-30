for sym in [
	:AccessSpecDecl,
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
    :MSGuidDecl,
]
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
