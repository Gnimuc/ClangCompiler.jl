"""
    const SOURCE_LANGUAGES

The `language` values [`create_parser`](@ref) and [`create_irgenerator`](@ref) accept, and the
`-x` spelling each selects.
"""
const SOURCE_LANGUAGES = (c="c", cxx="c++", objc="objective-c", objcxx="objective-c++")

"""
    is_cxx_language(language::Symbol) -> Bool
Whether `language` selects the C++ build environment — which shard's system includes are on
the search path — rather than the C one.
"""
is_cxx_language(language::Symbol) = language in (:cxx, :objcxx)

"""
    check_language(language::Symbol) -> Symbol
Return `language` if it is one of [`SOURCE_LANGUAGES`](@ref), and throw `ArgumentError`
otherwise.
"""
function check_language(language::Symbol)
    haskey(SOURCE_LANGUAGES, language) || throw(ArgumentError("language must be one of $(keys(SOURCE_LANGUAGES)), got :$language"))
    return language
end
