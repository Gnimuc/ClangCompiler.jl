# ABI / layout façade for a downstream that asked. These compose existing wrappers
# and promise a named-tuple shape, not clang's TableGen ordinals: size, alignment
# and bit offsets are what the target's ASTRecordLayout decided; enumerator values
# are what Sema assigned; Itanium vtable slots are what VTableBuilder computed.
# A later LLVM major may grow the sets (more record kinds, more vtable component
# kinds) but will not rename these keys.

"""
    record_layout(ctx::ASTContext, decl::AbstractRecordDecl) -> NamedTuple

Clang's layout for the completing definition of `decl`: size and alignment in
**bytes**, field offsets in **bits**, and (for a C++ record) bases, virtual
bases and whether the object carries a vptr.

`decl` must have a definition. A forward declaration is an error rather than an
empty layout — that is the same refusal [`getASTRecordLayout`](@ref) makes.
"""
function record_layout(ctx::ASTContext, decl::AbstractRecordDecl)
    @check_ptrs ctx decl
    d = definition(decl)
    d === nothing && error("record has no definition; layout needs a complete type")
    layout = get_record_layout(ctx, d)
    fields = _field_entries(ctx, d, layout)
    bases, vbases, has_vptr = _base_entries(ctx, d, layout)
    return (; size=Int(getSize(layout)), align=Int(getAlignment(layout)), fields, bases, vbases, has_vptr)
end

function _type_string(ctx::ASTContext, qt::QualType)
    policy = PrintingPolicy(getLangOpts(ctx))
    try
        return getAsString(qt, policy)
    finally
        dispose(policy)
    end
end

function _field_entries(ctx::ASTContext, d::AbstractRecordDecl, layout)
    entries = NamedTuple[]
    for f in getFields(d)
        isImplicit(f) && continue
        qt = getType(f)
        name = getNameAsString(f)
        bit_offset = Int(getFieldOffset(layout, getFieldIndex(f)))
        bit_width = isBitField(f) ? Int(getBitWidthValue(f, ctx)) : 0
        push!(entries, (; name, type=_type_string(ctx, qt), bit_offset, bit_width))
    end
    return entries
end

function _base_entries(ctx::ASTContext, d, layout)
    d isa AbstractCXXRecordDecl || return (NamedTuple[], NamedTuple[], false)
    hasDefinition(d) || return (NamedTuple[], NamedTuple[], false)
    has_vptr = hasOwnVFPtr(layout) || isDynamicClass(d)
    bases = NamedTuple[]
    vbases = NamedTuple[]
    itanium = _itanium_vtable(ctx)
    for spec in getBases(d)
        entry = _one_base(ctx, d, layout, spec, itanium)
        entry === nothing && continue
        push!(bases, entry)
        entry.is_virtual && push!(vbases, entry)
    end
    return bases, vbases, has_vptr
end

function _one_base(ctx, d, layout, spec, itanium)
    base = getAsCXXRecordDecl(getTypePtr(getType(spec)))
    is_null_handle(base) && return nothing
    is_virt = isVirtual(spec)
    byte_offset = is_virt ? Int(getVBaseClassOffset(layout, base)) : Int(getBaseClassOffset(layout, base))
    vbase_vtable_offset = 0
    if is_virt && itanium !== nothing
        vbase_vtable_offset = Int(getVirtualBaseOffsetOffset(itanium, d, base))
    end
    return (; name=getNameAsString(base), byte_offset, is_virtual=is_virt, vbase_vtable_offset)
end

function _itanium_vtable(ctx::ASTContext)
    vtc = getVTableContext(ctx)
    is_null_handle(vtc) && return nothing
    it = castToItaniumVTableContext(vtc)
    return is_null_handle(it) ? nothing : it
end

"""
    enum_info(decl::AbstractEnumDecl) -> NamedTuple

The enumerators clang parsed, with the values Sema assigned, and the
underlying integer type as the translation unit spells it.
"""
function enum_info(decl::AbstractEnumDecl)
    @check_ptrs decl
    d = definition(decl)
    d === nothing && error("enum has no definition")
    ctx = getASTContext(d)
    enumerators = [(; name=getNameAsString(e), value=Int(getEnumConstantDeclValue(e))) for e in getEnumerators(d)]
    return (; name=getNameAsString(d), enumerators, underlying=_type_string(ctx, getIntegerType(EnumDecl(d))))
end

"""
    vtable_info(ctx::ASTContext, decl::AbstractCXXRecordDecl) -> NamedTuple

Itanium vtable facts for a dynamic class: the mangled vtable symbol, the
function-pointer slots, and virtual-base offsets relative to the vtable
address point.

Microsoft C++ ABI is refused — this package does not wrap that builder.
A non-dynamic class has no vtable and is an error.
"""
function vtable_info(ctx::ASTContext, decl::AbstractCXXRecordDecl)
    @check_ptrs ctx decl
    d = definition(decl)
    d === nothing && error("record has no definition; vtable needs a complete type")
    isDynamicClass(d) || error("a non-dynamic class has no vtable")
    itanium = _itanium_vtable(ctx)
    itanium === nothing && error("vtable_info is Itanium-only; Microsoft vtable context is not wrapped")
    layout = getVTableLayout(itanium, d)
    slots = NamedTuple[]
    for i = 0:(getNumVTableComponents(layout) - 1)
        c = getVTableComponent(layout, i)
        if isFunctionPointerKind(c)
            fn = resolve(getFunctionDecl(c))
            slot = _method_slot(itanium, fn)
            push!(slots, (; name=getNameAsString(fn), slot, kind=getKind(c)))
        elseif isRTTIKind(c)
            push!(slots, (; name="RTTI", slot=i, kind=getKind(c)))
        end
    end
    vbase_offsets = NamedTuple[]
    for spec in getVBases(d)
        base = getAsCXXRecordDecl(getTypePtr(getType(spec)))
        is_null_handle(base) && continue
        push!(vbase_offsets, (; name=getNameAsString(base), offset=Int(getVirtualBaseOffsetOffset(itanium, d, base))))
    end
    symbol = _vtable_symbol(ctx, d)
    return (; symbol, slots, vbase_offsets)
end

function _method_slot(itanium, fn)
    fn isa AbstractCXXDestructorDecl && return Int(getMethodVTableIndexForDtor(itanium, fn, CXCXXDtorType_Dtor_Complete))
    fn isa AbstractCXXConstructorDecl && return -1
    return Int(getMethodVTableIndex(itanium, fn))
end

function _vtable_symbol(ctx::ASTContext, d::AbstractCXXRecordDecl)
    mc = createMangleContext(ctx, getTargetInfo(ctx))
    try
        it = ItaniumMangleContext(mc)
        is_null_handle(it) && return ""
        return mangleCXXVTable(it, d)
    finally
        dispose(mc)
    end
end

"""
    api_decls(session) -> Vector

File-scope declarations written in user files, each resolved to its concrete
class. System-header and implicit declarations are skipped. A namespace is
descended rather than returned, so `app::foo` is in the list and `app` is not.
"""
function api_decls(session::Union{CxxInterpreter,IncrementalParser})
    sm = getSourceManager(get_instance(session))
    out = []
    _collect_api!(out, top_level_decls(session), sm)
    return out
end

function _collect_api!(out, decls, sm)
    for d in decls
        d = resolve(d)
        isImplicit(d) && continue
        isInSystemHeader(sm, getBeginLoc(d)) && continue
        if d isa AbstractNamespaceDecl
            _collect_api!(out, members(d), sm)
        else
            push!(out, d)
        end
    end
    return out
end

"""
    is_exported(decl::AbstractNamedDecl) -> Bool

Whether `decl` has external formal linkage — the names that can appear in a
shared library's symbol table.
"""
is_exported(d::AbstractNamedDecl) = (@check_ptrs d; hasExternalFormalLinkage(d))

"""
    is_nothrow(decl::AbstractFunctionDecl) -> Bool

Whether clang's exception spec says this function cannot throw (`CT_Cannot`).
A function without a prototype answers `false`.
"""
function is_nothrow(d::AbstractFunctionDecl)
    @check_ptrs d
    # C has no exceptions. clang still types those functions as EST_None, whose
    # `canThrow` is `CT_Can` — the C++ default, not a C fact.
    getCPlusPlus(getLangOpts(getASTContext(d))) || return true
    ft = resolve(getTypePtr(getType(d)))
    ft isa AbstractFunctionProtoType || return false
    return canThrow(ft) == CXCanThrowResult_CT_Cannot
end

"""
    comments(session, decl::AbstractDecl) -> String

The raw documentation comment attached to `decl` itself, or `""` when none is.
Walks no redeclaration chain — the comment written above a different
redeclaration is not this one.
"""
function comments(session::Union{CxxInterpreter,IncrementalParser}, decl::AbstractDecl)
    @check_ptrs decl
    ctx = get_ast_context(session)
    raw = getRawCommentForDeclNoCache(ctx, decl)
    is_null_handle(raw) && return ""
    return getRawText(raw, getSourceManager(get_instance(session)))
end

"""
    expanded_macro(session, loc::SourceLocation) -> String or `nothing`

The fully expanded text recorded at `loc`, when the session was created with
`record_macros=true`. `nothing` when that location is not a macro expansion,
or when the session is not recording macros.
"""
function expanded_macro(session, loc::SourceLocation)
    mec = _macros_of(session)
    mec === nothing && return nothing
    return getExpandedText(mec, loc)
end

"""
    macro_text(session, name::AbstractString) -> String or `nothing`

The replacement-list spelling of the active definition of `name`, joined with
spaces. `nothing` when `name` is not a currently defined macro.
"""
function macro_text(session, name::AbstractString)
    pp = getPreprocessor(get_instance(session))
    isMacroDefined(pp, String(name)) || return nothing
    ii = getIdentifierInfo(pp, String(name))
    mi = getMacroInfo(pp, ii)
    is_null_handle(mi) && return nothing
    n = Int(getNumTokens(mi))
    n == 0 && return ""
    return join((getSpelling(pp, getReplacementToken(mi, i)) for i = 0:(n - 1)), " ")
end

_macros_of(x::CxxInterpreter) = x.macros
_macros_of(x::IncrementalParser) = x.macros
_macros_of(::Any) = nothing
