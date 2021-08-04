"""
    abstract type AbstractFinder <: Any
Supertype for various "lookup" functors.
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
    sema = get_sema(ci)
    loc = get_loc_for_start_of_main_file(get_source_manager(ci))  # used as a fake loc
    result = LookupResult(sema, DeclarationName(), loc, kind)
    return DeclFinder(result, kind)
end

function reset(x::DeclFinder)
    clear(x.result, x.kind)
    clear(x.spec)
end

function get_decl(x::DeclFinder)
    is_empty(x.result) && error("no lookup result.")
    return get_representative_decl(x.result)
end
