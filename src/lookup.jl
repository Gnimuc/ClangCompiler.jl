"""
    abstract type AbstractFinder <: Any
Supertype for "lookup" functors.
"""
abstract type AbstractFinder end

"""
    struct DeclFinder <: AbstractFinder
Functor for decl lookup.
"""
struct DeclFinder <: AbstractFinder
    spec::CXXScopeSpec
    result::LookupResult
    kind::CXLookupNameKind
end
DeclFinder(r::LookupResult, k::CXLookupNameKind) = DeclFinder(CXXScopeSpec(), r, k)

function dispose(x::DeclFinder)
    dispose(x.spec)
    dispose(x.result)
end

function DeclFinder(i::Union{CxxInterpreter,IncrementalParser},
                    kind::CXLookupNameKind=CXLookupNameKind_LookupOrdinaryName)
    ci, sema = get_instance(i), get_sema(i)
    loc = get_main_file_begin_loc(getSourceManager(ci))  # used as a fake loc
    result = LookupResult(sema, DeclarationName(), loc, kind)
    return DeclFinder(result, kind)
end

"""
    reset(x::DeclFinder)
Clear the last lookup's result and scope specifier so `x` can be used again.

This extends `Base.reset` rather than defining a function of the same name. Doing so is not
piracy — the method dispatches on `DeclFinder`, which this package owns — and it is what stops
`using ClangCompiler: reset` from shadowing `Base.reset` for the rest of the scope. The
semantics match the one `Base.reset` method that is not about streams, `reset(::Base.Event)`:
return a stateful object to its initial state.

The functor calls this itself before every lookup, so a caller reusing one finder needs it only
to release the previous result early.
"""
function Base.reset(x::DeclFinder)
    clear(x.result, x.kind)
    clear(x.spec)
end

"""
    get_decl(x::DeclFinder) -> resolved decl
The single declaration the last lookup found, resolved to its concrete class.

Resolved rather than the base `NamedDecl` clang hands back, because a base carrier makes
`d isa FunctionDecl` silently false — the trap [`find_decl`](@ref) exists to close, which this
would otherwise reopen for anyone driving the finder directly.

Throws `ArgumentError` when the lookup found no declaration or more than one; ask
[`get_decls`](@ref) for an overload set. One result is one result even when clang classifies it
as an overload set, which it does for a lone function template — so `get_decl` accepts that
where `isSingleResult` alone would refuse it.
"""
function get_decl(x::DeclFinder)
    n = getNum(x.result)
    n == 1 || throw(ArgumentError("the lookup found $n declarations; get_decl needs exactly \
                                   one, use get_decls for an overload set"))
    return resolve(getResult(x.result))
end

function get_decls(x::DeclFinder)
    is_empty(x.result) && error("failed to find any lookup result.")
    return getResults(x.result)
end

function get_tag(x::DeclFinder)
    @assert is_tag(x.result) "the lookup result is not a single tag decl."
    return getResult(x.result)
end

"""
The tag keywords clang's nested-name-specifier printer emits and the source did not write.

All four, not just `class`: the shim prints the specifier with a default-constructed
`LangOptions`, whose `SuppressTagKeyword` is false, so `app::Widget::m` comes back as
`app::struct Widget::` and the length arithmetic below runs off the end of the name. Handling
`class` alone is why a `class`-qualified lookup worked and every other tag raised.
"""
const NNS_TAG_KEYWORDS = ("class ", "struct ", "union ", "enum ")

function strip_nns(nns::AbstractString, code::AbstractString)
    # FIXME: the shim should print the specifier with the translation unit's own LangOptions,
    # which would emit none of these; stripping here is the workaround, not the fix.
    for kw in NNS_TAG_KEYWORDS
        occursin(kw, nns) && (nns = replace(nns, kw => ""))
    end
    nns = replace(nns, ", " => ",")
    nns = replace(nns, "> " => ">")
    return code[(length(nns) + 1):end]
end

function diagnose_declname(code::AbstractString, type_name::AbstractString, nns::AbstractString="")
    s = strip_nns(nns, code)
    if isempty(type_name) # template-ids are not handled in `parse_cxx_scope_spec`
        # assume this is a template-id (e.g. `vector<int>`)
        # do the lookup for `vector`
        idx = findfirst('<', s)
        s = isnothing(idx) ? s : s[1:(idx - 1)]
    elseif s != type_name
        # this happends when the template-id is not annotated in `parse_cxx_scope_spec` due to missing headers
        @assert occursin(type_name, s)
        idx = findfirst('>', s)
        id = isnothing(idx) ? s : s[1:idx]
        error("failed to annotate the template-id `$id`; did you forget to include any headers?")
    elseif isempty(s)
        error("failed to get the decl name; did you forget to add the decl name after the scope specifier `$nns`?")
    end
    return s
end

function (x::DeclFinder)(i::Union{CxxInterpreter,IncrementalParser}, code::String)
    reset(x)
    sema, parser = get_sema(i), get_parser(i)
    type_name = parse_cxx_scope_spec(i, x.spec, code)
    if isValid(x.spec)
        nns = getName(getScopeRep(x.spec))
        declname = diagnose_declname(code, type_name, nns)
        setLookupName(x.result, DeclarationName(get_name(get_ast_context(i), declname)))
        LookupParsedName(sema, x.result, getCurScope(parser), x.spec, true, true)
    else
        setLookupName(x.result, DeclarationName(get_name(get_ast_context(i), code)))
        LookupName(sema, x.result, getCurScope(parser), true)
    end
    resolveKind(x.result)
    return !is_empty(x.result)
end
