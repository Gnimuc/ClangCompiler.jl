# Generated from deps/ClangExtra/include/clang-ex/AST/DeclNodes.inc by gen/decl_nodes.jl — do not edit.

"""
    const AbstractDeclContextDecl
The decls clang marks `DECL_CONTEXT` — those that are also `DeclContext`s, and so may be
passed wherever a [`DeclContext`](@ref) is wanted. Dispatch admits exactly these, which is
what stops a decl that is not a context from ever reaching `castToDeclContext`'s assert.
"""
const AbstractDeclContextDecl = Union{AbstractBlockDecl,
                                      AbstractCapturedDecl,
                                      AbstractExportDecl,
                                      AbstractExternCContextDecl,
                                      AbstractFunctionDecl,
                                      AbstractCXXDeductionGuideDecl,
                                      AbstractCXXMethodDecl,
                                      AbstractCXXConstructorDecl,
                                      AbstractCXXConversionDecl,
                                      AbstractCXXDestructorDecl,
                                      AbstractHLSLBufferDecl,
                                      AbstractLinkageSpecDecl,
                                      AbstractNamespaceDecl,
                                      AbstractObjCCategoryDecl,
                                      AbstractObjCCategoryImplDecl,
                                      AbstractObjCImplementationDecl,
                                      AbstractObjCInterfaceDecl,
                                      AbstractObjCProtocolDecl,
                                      AbstractObjCMethodDecl,
                                      AbstractRequiresExprBodyDecl,
                                      AbstractEnumDecl,
                                      AbstractRecordDecl,
                                      AbstractCXXRecordDecl,
                                      AbstractClassTemplateSpecializationDecl,
                                      AbstractClassTemplatePartialSpecializationDecl,
                                      AbstractTopLevelStmtDecl,
                                      AbstractTranslationUnitDecl}

# `DeclContext` is the one base in this package that is not at offset zero, so unlike
# every entry in converts.jl this one cannot reinterpret: it calls the pivot, and
# the per-class adjustment (+48 from a NamespaceDecl, +64 from a TagDecl) happens as the
# argument is marshalled. A decl reaching a `CXDeclContext` parameter therefore arrives
# as a `DeclContext *` however it got there, and no call site can forget the cast.
#
# No check here: the Union is exactly the classes clang marks `DECL_CONTEXT`, so dispatch
# has already established what `castToDeclContext`'s assert would test, and the wrapper's
# own `@check_ptrs` runs before the ccall marshals its arguments.
Base.unsafe_convert(::Type{CXDeclContext}, x::AbstractDeclContextDecl) = clang_Decl_castToDeclContext(x)
Base.cconvert(::Type{CXDeclContext}, x::AbstractDeclContextDecl) = x

"""
    const AnyDeclContext
What a `DeclContext` parameter accepts: a context, or a declaration that is also one.
This is the signature C++ writes as `DeclContext *`, where a `NamespaceDecl *` converts
implicitly — here the same call marshals through the pivot above, so `RecordDecl(ctx, ns,
...)` reaches clang with the adjusted pointer and needs no `castToDeclContext` spelled at
the call site.

Two kinds of signature keep the narrower `DeclContext`. A method clang declares on both
`Decl` and `DeclContext` is ambiguous over this union — `getDeclKindName` is the one such
pair, and the same call needs qualifying in C++ too. So is a wrapper that reads `dc.ptr`
rather than passing the carrier, since that spelling takes the raw pointer and bypasses
the pivot.
"""
const AnyDeclContext = Union{AbstractDeclContext,AbstractDeclContextDecl}
