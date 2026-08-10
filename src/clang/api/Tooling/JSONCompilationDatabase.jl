# JSONCompilationDatabase

"""
    loadFromFile(::Type{JSONCompilationDatabase}, file_path::AbstractString,
                 syntax::CXJSONCommandLineSyntax=CXJSONCommandLineSyntax_AutoDetect)
    -> (Union{JSONCompilationDatabase,Nothing}, String)
Load a `compile_commands.json` from `file_path`, returning `nothing` and clang's parse error
when it cannot be read or understood.

`syntax` decides how the `command` string of an entry is split into arguments;
`CXJSONCommandLineSyntax_AutoDetect` picks Windows or GNU quoting from the shape of the first
entry, which is what a CMake-generated database expects. Entries that use the `arguments`
array instead are unaffected — those are never unescaped.

Unlike a database reached through the base class, this one enumerates: `getAllFiles` and
`getAllCompileCommands` report the JSON file's real contents.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function loadFromFile(::Type{JSONCompilationDatabase}, file_path::AbstractString,
                      syntax::CXJSONCommandLineSyntax=CXJSONCommandLineSyntax_AutoDetect)
    err = Ref{CXString}()
    ptr = clang_JSONCompilationDatabase_loadFromFile(file_path, err, syntax)
    return (ptr == C_NULL ? nothing : JSONCompilationDatabase(ptr)), get_string(err[])
end

"""
    loadFromBuffer(::Type{JSONCompilationDatabase}, database_string::AbstractString,
                   syntax::CXJSONCommandLineSyntax=CXJSONCommandLineSyntax_AutoDetect)
    -> (Union{JSONCompilationDatabase,Nothing}, String)
Parse `database_string` as a compilation database, so one can be built without touching disk.
Returns `nothing` and clang's parse error when the text is not a well-formed database.

Same `syntax` meaning as [`loadFromFile`](@ref).

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function loadFromBuffer(::Type{JSONCompilationDatabase}, database_string::AbstractString,
                        syntax::CXJSONCommandLineSyntax=CXJSONCommandLineSyntax_AutoDetect)
    err = Ref{CXString}()
    ptr = clang_JSONCompilationDatabase_loadFromBuffer(database_string, err, syntax)
    return (ptr == C_NULL ? nothing : JSONCompilationDatabase(ptr)), get_string(err[])
end
