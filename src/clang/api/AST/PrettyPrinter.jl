# PrintingPolicy
"""
    PrintingPolicy(opts::AbstractLangOptions) -> PrintingPolicy
Build a printing policy with the defaults `opts` implies — `SuppressTagKeyword` follows
`opts`'s `CPlusPlus`, for instance.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function PrintingPolicy(opts::AbstractLangOptions)
    @check_ptrs opts
    return PrintingPolicy(clang_PrintingPolicy_create(opts))
end

"""
    PrintingPolicy(x::AbstractPrintingPolicy) -> PrintingPolicy
Return an owned copy of `x`. This is how a context's borrowed policy is turned into one that
can be mutated and disposed without touching the context.

Spelled as a constructor rather than `copy` on purpose: a bare `copy` defined here would
shadow `Base.copy` throughout the module, and this layer calls that on plain arrays.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function PrintingPolicy(x::AbstractPrintingPolicy)
    @check_ptrs x
    return PrintingPolicy(clang_PrintingPolicy_copy(x))
end

"""
    dispose(x::PrintingPolicy)
Release a policy built by either [`PrintingPolicy`](@ref) constructor.

Never call this on the policy [`getPrintingPolicy`](@ref) returns: that one is an interior
pointer into its `ASTContext`, and freeing it deletes into the context.
"""
dispose(x::PrintingPolicy) = clang_PrintingPolicy_dispose(x)

"""
    getSuppressTagKeyword(x::AbstractPrintingPolicy) -> Bool
Return whether `struct`/`class`/`union`/`enum` is omitted before a tag type's name.
"""
function getSuppressTagKeyword(x::AbstractPrintingPolicy)
    @check_ptrs x
    return clang_PrintingPolicy_getSuppressTagKeyword(x)
end

"""
    setSuppressTagKeyword(x::AbstractPrintingPolicy, value::Bool)
Choose whether `struct`/`class`/`union`/`enum` is omitted before a tag type's name.
"""
function setSuppressTagKeyword(x::AbstractPrintingPolicy, value::Bool)
    @check_ptrs x
    return clang_PrintingPolicy_setSuppressTagKeyword(x, value)
end

"""
    getSuppressScope(x::AbstractPrintingPolicy) -> Bool
Return whether the qualified part of a name is omitted, printing `S` rather than `NS::S`.
"""
function getSuppressScope(x::AbstractPrintingPolicy)
    @check_ptrs x
    return clang_PrintingPolicy_getSuppressScope(x)
end

"""
    setSuppressScope(x::AbstractPrintingPolicy, value::Bool)
Choose whether the qualified part of a name is omitted.
"""
function setSuppressScope(x::AbstractPrintingPolicy, value::Bool)
    @check_ptrs x
    return clang_PrintingPolicy_setSuppressScope(x, value)
end

"""
    getBool(x::AbstractPrintingPolicy) -> Bool
Return whether the boolean type prints as `bool` rather than `_Bool`.
"""
function getBool(x::AbstractPrintingPolicy)
    @check_ptrs x
    return clang_PrintingPolicy_getBool(x)
end

"""
    setBool(x::AbstractPrintingPolicy, value::Bool)
Choose whether the boolean type prints as `bool` rather than `_Bool`.
"""
function setBool(x::AbstractPrintingPolicy, value::Bool)
    @check_ptrs x
    return clang_PrintingPolicy_setBool(x, value)
end

"""
    getFullyQualifiedName(x::AbstractPrintingPolicy) -> Bool
Return whether names print fully qualified from the global namespace.
"""
function getFullyQualifiedName(x::AbstractPrintingPolicy)
    @check_ptrs x
    return clang_PrintingPolicy_getFullyQualifiedName(x)
end

"""
    setFullyQualifiedName(x::AbstractPrintingPolicy, value::Bool)
Choose whether names print fully qualified from the global namespace. This qualifies the
name as the AST spells it; it does not resolve using-declarations or requalify template
arguments, which is what [`getFullyQualifiedName`](@ref) on a `QualType` does instead.
"""
function setFullyQualifiedName(x::AbstractPrintingPolicy, value::Bool)
    @check_ptrs x
    return clang_PrintingPolicy_setFullyQualifiedName(x, value)
end

"""
    getSuppressDefaultTemplateArgs(x::AbstractPrintingPolicy) -> Bool
Return whether template arguments matching their parameter's default are omitted.
"""
function getSuppressDefaultTemplateArgs(x::AbstractPrintingPolicy)
    @check_ptrs x
    return clang_PrintingPolicy_getSuppressDefaultTemplateArgs(x)
end

"""
    setSuppressDefaultTemplateArgs(x::AbstractPrintingPolicy, value::Bool)
Choose whether template arguments matching their parameter's default are omitted, printing
`std::vector<int>` rather than `std::vector<int, std::allocator<int>>`.
"""
function setSuppressDefaultTemplateArgs(x::AbstractPrintingPolicy, value::Bool)
    @check_ptrs x
    return clang_PrintingPolicy_setSuppressDefaultTemplateArgs(x, value)
end

"""
    getPrintCanonicalTypes(x::AbstractPrintingPolicy) -> Bool
Return whether types print canonically, with sugar stripped.
"""
function getPrintCanonicalTypes(x::AbstractPrintingPolicy)
    @check_ptrs x
    return clang_PrintingPolicy_getPrintCanonicalTypes(x)
end

"""
    setPrintCanonicalTypes(x::AbstractPrintingPolicy, value::Bool)
Choose whether types print canonically, with sugar (typedefs, using-aliases) stripped.
"""
function setPrintCanonicalTypes(x::AbstractPrintingPolicy, value::Bool)
    @check_ptrs x
    return clang_PrintingPolicy_setPrintCanonicalTypes(x, value)
end
