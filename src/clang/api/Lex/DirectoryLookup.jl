# DirectoryLookup
"""
    DirectoryLookup(dir::AbstractDirectoryEntryRef, dt::CXCharacteristicKind,
                    is_framework::Bool=false) -> DirectoryLookup
Build a search-path entry naming the directory `dir`, whose headers are treated as `dt` — user
code, system code, or extern-C system code.

This function allocates and one should call `dispose` to release the resources after using
this object. [`AddSearchPath`](@ref) and [`AddSystemSearchPath`](@ref) copy the value into the
search, so it may be disposed as soon as either has been called.
"""
function DirectoryLookup(dir::AbstractDirectoryEntryRef, dt::CXCharacteristicKind, is_framework::Bool=false)
    @check_ptrs dir
    return DirectoryLookup(clang_DirectoryLookup_create(dir, dt, is_framework))
end

dispose(x::DirectoryLookup) = clang_DirectoryLookup_dispose(x)

"""
    getName(x::AbstractDirectoryLookup) -> String
Return the name of the directory `x` searches — for a normal directory, the path
[`getOptionalDirectoryRef`](@ref) was given.
"""
function getName(x::AbstractDirectoryLookup)
    @check_ptrs x
    return get_string(clang_DirectoryLookup_getName(x))
end
