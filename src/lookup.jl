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

function DeclFinder(ci::CompilerInstance, kind::CXLookupNameKind=CXLookupNameKind_LookupOrdinaryName)
    sema = getSema(ci)
    loc = get_main_file_begin_loc(getSourceManager(ci))  # used as a fake loc
    result = LookupResult(sema, DeclarationName(), loc, kind)
    return DeclFinder(result, kind)
end

function reset(x::DeclFinder)
    clear(x.result, x.kind)
    clear(x.spec)
end

function get_decl(x::DeclFinder)
    isempty(x.result) && error("no lookup result.")
    return getRepresentativeDecl(x.result)
end

function (x::DeclFinder)(ci::CompilerInstance, parser::Parser, decl::String, scope::String="")
    reset(x)
    parse_cxx_scope_spec(ci, parser, scope, x.spec)
    setLookupName(x.result, DeclarationName(get_name(getASTContext(ci), decl)))
    if isValid(x.spec)
        is_found = LookupParsedName(getSema(ci), x.result, getCurScope(parser), x.spec)
        !is_found && error("failed to find decl(`$decl`) in the CXXScopeSpec.")
    else
        is_found = LookupName(getSema(ci), x.result, getCurScope(parser))
        !is_found && error("failed to find decl(`$decl`) in the current scope.")
    end
    return !isempty(x.result)
end
