# Options — the table of every flag clang's driver understands.
#
# clang indexes the table with no bounds check, so every id-taking wrapper restates the
# range clang asserts on: `0 < id <= getNumOptions(t)`. Zero is `OPT_INVALID`.

"""
    getDriverOptTable() -> OptTable
Return the table of every option clang's driver understands.

The table is a function-local singleton with static storage duration, so the result is
borrowed and is never disposed.
"""
getDriverOptTable() = OptTable(clang_driver_getDriverOptTable())

"""
    getNumOptions(x::AbstractOptTable) -> Int
Return how many options the table holds. Valid option IDs run from 1 to this value
inclusive.
"""
function getNumOptions(x::AbstractOptTable)
    @check_ptrs x
    return Int(clang_OptTable_getNumOptions(x))
end

"""
    getOptionName(x::AbstractOptTable, id::Integer) -> String
Return the option's name without any prefix, e.g. `"std="` for `-std=`.
"""
function getOptionName(x::AbstractOptTable, id::Integer)
    @check_ptrs x
    @assert 0 < id ≤ getNumOptions(x) "option id out of range"
    return get_string(clang_OptTable_getOptionName(x, id))
end

"""
    getOptionHelpText(x::AbstractOptTable, id::Integer) -> String
Return the option's help text, empty for an option that has none — which most aliases do
not.
"""
function getOptionHelpText(x::AbstractOptTable, id::Integer)
    @check_ptrs x
    @assert 0 < id ≤ getNumOptions(x) "option id out of range"
    return get_string(clang_OptTable_getOptionHelpText(x, id))
end

"""
    getOption(x::AbstractOptTable, id::Integer) -> Option
Return the `Option` value for an ID.

This function allocates and one should call `dispose` to release the resources after using
this object: `llvm::opt::Option` is a two-pointer value class, so the handle is a heap-boxed
copy.
"""
function getOption(x::AbstractOptTable, id::Integer)
    @check_ptrs x
    @assert 0 < id ≤ getNumOptions(x) "option id out of range"
    return Option(clang_OptTable_getOption(x, id))
end

dispose(x::Option) = clang_Option_dispose(x)

"""
    isValid(x::AbstractOption) -> Bool
Return whether the boxed option refers to a table entry at all. This is the precondition of
every other `Option` accessor — clang asserts on an invalid one.
"""
function isValid(x::AbstractOption)
    @check_ptrs x
    return clang_Option_isValid(x)
end

"""
    getID(x::AbstractOption) -> Int
Return the option's ID, i.e. the index it was looked up by.
"""
function getID(x::AbstractOption)
    @check_ptrs x
    @assert clang_Option_isValid(x) "an invalid Option has no ID"
    return Int(clang_Option_getID(x))
end

"""
    getKind(x::AbstractOption) -> CXOptionClass
Return the shape of the option — how its value is written on a command line.
"""
function getKind(x::AbstractOption)
    @check_ptrs x
    @assert clang_Option_isValid(x) "an invalid Option has no kind"
    return clang_Option_getKind(x)
end

"""
    getName(x::AbstractOption) -> String
Return the option's name without a prefix, e.g. `"std="`.
"""
function getName(x::AbstractOption)
    @check_ptrs x
    @assert clang_Option_isValid(x) "an invalid Option has no name"
    return get_string(clang_Option_getName(x))
end

"""
    getPrefixedName(x::AbstractOption) -> String
Return the option's name with its default prefix, e.g. `"-std="`.
"""
function getPrefixedName(x::AbstractOption)
    @check_ptrs x
    @assert clang_Option_isValid(x) "an invalid Option has no name"
    return get_string(clang_Option_getPrefixedName(x))
end

"""
    findNearest(x::AbstractOptTable, option::AbstractString;
                visibility::Integer=typemax(UInt32), minimum_length::Integer=4,
                maximum_distance::Integer=typemax(UInt32)) -> Tuple{String,Int}
Return `(nearest_spelling, edit_distance)` for a possibly misspelled flag — the engine
behind clang's own "did you mean" suggestions. A distance of 0 is an exact match, and the
spelling is empty when nothing was near enough.

`visibility` is an OR of `CXClangVisibility` values; the default asks the whole table.
`minimum_length` keeps very short options from being suggested for unrelated input.
"""
function findNearest(x::AbstractOptTable, option::AbstractString; visibility::Integer=typemax(UInt32), minimum_length::Integer=4, maximum_distance::Integer=typemax(UInt32))
    @check_ptrs x
    distance = Ref{Cuint}(0)
    nearest = get_string(clang_OptTable_findNearest(x, option, visibility, minimum_length, maximum_distance, distance))
    return (nearest, Int(distance[]))
end

"""
    printHelp(x::AbstractOptTable, usage::AbstractString, title::AbstractString;
              show_hidden::Bool=false, show_all_aliases::Bool=false,
              visibility::Integer=typemax(UInt32)) -> String
Return the help screen clang would print, rendered into a string.
"""
function printHelp(x::AbstractOptTable, usage::AbstractString, title::AbstractString; show_hidden::Bool=false, show_all_aliases::Bool=false, visibility::Integer=typemax(UInt32))
    @check_ptrs x
    return get_string(clang_OptTable_printHelp(x, usage, title, show_hidden, show_all_aliases, visibility))
end
