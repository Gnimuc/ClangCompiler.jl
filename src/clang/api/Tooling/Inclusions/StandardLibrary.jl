# stdlib::Header
#
# `all` and `named` are static members of two different classes, so both dispatch on the
# carrier type. `all_` carries the trailing underscore this package uses for a name Base
# already owns.

"""
    all_(::Type{StdlibHeader}, lang::CXStdlibLang=CXStdlibLang_CXX) -> StdlibHeaderList
Return every standard library header Clang's table knows about for `lang`.

C and C++ are separate tables: `<stdio.h>` is a `CXStdlibLang_C` entry and `<cstdio>` a
`CXStdlibLang_CXX` one.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function all_(::Type{StdlibHeader}, lang::CXStdlibLang=CXStdlibLang_CXX)
    ptr = clang_stdlib_Header_all(lang)
    @assert ptr != C_NULL "Failed to enumerate stdlib headers"
    return StdlibHeaderList(ptr)
end

"""
    named(::Type{StdlibHeader}, name::AbstractString, lang::CXStdlibLang=CXStdlibLang_CXX) -> Union{StdlibHeader,Nothing}
Return the table entry for the header spelled `name`, or `nothing` when there is none.

`name` carries its angle brackets, as it would be written in an `#include`: `"<vector>"`,
not `"vector"`.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function named(::Type{StdlibHeader}, name::AbstractString, lang::CXStdlibLang=CXStdlibLang_CXX)
    ptr = clang_stdlib_Header_named(name, lang)
    return ptr == C_NULL ? nothing : StdlibHeader(ptr)
end

"""
    name(x::AbstractStdlibHeader) -> String
Return the header's spelling, angle brackets included.
"""
function name(x::AbstractStdlibHeader)
    @check_ptrs x
    return get_string(clang_stdlib_Header_name(x))
end

dispose(x::StdlibHeader) = clang_stdlib_Header_dispose(x)

"""
    Base.length(x::AbstractStdlibHeaderList) -> UInt32
Return how many headers the list holds.
"""
function Base.length(x::AbstractStdlibHeaderList)
    @check_ptrs x
    return clang_stdlib_HeaderList_getNumHeaders(x)
end

"""
    getHeader(x::AbstractStdlibHeaderList, i::Integer) -> StdlibHeader
Return the `i`-th header of the list, counting from 0.

The result is *borrowed* from the list: it stays valid until the list is disposed, and must
not be disposed itself.
"""
function getHeader(x::AbstractStdlibHeaderList, i::Integer)
    @check_ptrs x
    @assert 0 <= i < clang_stdlib_HeaderList_getNumHeaders(x) "header index $i out of range"
    return StdlibHeader(clang_stdlib_HeaderList_getHeader(x, i))
end

dispose(x::StdlibHeaderList) = clang_stdlib_HeaderList_dispose(x)

# stdlib::Symbol

"""
    all_(::Type{StdlibSymbol}, lang::CXStdlibLang=CXStdlibLang_CXX) -> StdlibSymbolList
Return every top-level standard library symbol Clang's table knows about for `lang`.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function all_(::Type{StdlibSymbol}, lang::CXStdlibLang=CXStdlibLang_CXX)
    ptr = clang_stdlib_Symbol_all(lang)
    @assert ptr != C_NULL "Failed to enumerate stdlib symbols"
    return StdlibSymbolList(ptr)
end

"""
    named(::Type{StdlibSymbol}, scope::AbstractString, name::AbstractString,
          lang::CXStdlibLang=CXStdlibLang_CXX) -> Union{StdlibSymbol,Nothing}
Return the table entry for `scope * name`, or `nothing` when there is none.

`scope` carries its trailing `"::"` — `named(StdlibSymbol, "std::chrono::",
"system_clock")` — and the global scope is the empty string.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function named(::Type{StdlibSymbol}, scope::AbstractString, name::AbstractString, lang::CXStdlibLang=CXStdlibLang_CXX)
    ptr = clang_stdlib_Symbol_named(scope, name, lang)
    return ptr == C_NULL ? nothing : StdlibSymbol(ptr)
end

"""
    scope(x::AbstractStdlibSymbol) -> String
Return the symbol's enclosing scope, trailing `"::"` included.
"""
function scope(x::AbstractStdlibSymbol)
    @check_ptrs x
    return get_string(clang_stdlib_Symbol_scope(x))
end

"""
    name(x::AbstractStdlibSymbol) -> String
Return the symbol's unqualified name.
"""
function name(x::AbstractStdlibSymbol)
    @check_ptrs x
    return get_string(clang_stdlib_Symbol_name(x))
end

"""
    qualifiedName(x::AbstractStdlibSymbol) -> String
Return the symbol's fully qualified name, e.g. `"std::vector"`.
"""
function qualifiedName(x::AbstractStdlibSymbol)
    @check_ptrs x
    return get_string(clang_stdlib_Symbol_qualifiedName(x))
end

"""
    header(x::AbstractStdlibSymbol) -> Union{StdlibHeader,Nothing}
Return the header to suggest inserting for this symbol, or `nothing` when the table records
none.

Several headers may provide a symbol; this is the preferred one, and [`headers`](@ref) is
the whole set.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function header(x::AbstractStdlibSymbol)
    @check_ptrs x
    ptr = clang_stdlib_Symbol_header(x)
    return ptr == C_NULL ? nothing : StdlibHeader(ptr)
end

"""
    headers(x::AbstractStdlibSymbol) -> StdlibHeaderList
Return every header that provides this symbol.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function headers(x::AbstractStdlibSymbol)
    @check_ptrs x
    ptr = clang_stdlib_Symbol_headers(x)
    @assert ptr != C_NULL "Failed to enumerate the headers of a stdlib symbol"
    return StdlibHeaderList(ptr)
end

dispose(x::StdlibSymbol) = clang_stdlib_Symbol_dispose(x)

"""
    Base.length(x::AbstractStdlibSymbolList) -> UInt32
Return how many symbols the list holds.
"""
function Base.length(x::AbstractStdlibSymbolList)
    @check_ptrs x
    return clang_stdlib_SymbolList_getNumSymbols(x)
end

"""
    getSymbol(x::AbstractStdlibSymbolList, i::Integer) -> StdlibSymbol
Return the `i`-th symbol of the list, counting from 0.

The result is *borrowed* from the list, exactly as for headers.
"""
function getSymbol(x::AbstractStdlibSymbolList, i::Integer)
    @check_ptrs x
    @assert 0 <= i < clang_stdlib_SymbolList_getNumSymbols(x) "symbol index $i out of range"
    return StdlibSymbol(clang_stdlib_SymbolList_getSymbol(x, i))
end

dispose(x::StdlibSymbolList) = clang_stdlib_SymbolList_dispose(x)

# stdlib::Recognizer

"""
    StdlibRecognizer() -> StdlibRecognizer
Create the functor that maps a declaration to the standard library symbol it belongs to.

It memoises what it learns per `DeclContext`, keyed on raw pointers, so use one per
`ASTContext` and do not let it outlive that context.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function StdlibRecognizer()
    ptr = clang_stdlib_Recognizer_create()
    @assert ptr != C_NULL "Failed to create StdlibRecognizer"
    return StdlibRecognizer(ptr)
end

"""
    recognize(x::AbstractStdlibRecognizer, d::AbstractDecl) -> Union{StdlibSymbol,Nothing}
Return the top-level standard library symbol `d` belongs to, or `nothing` when it is not one
of them.

"Top-level" is the point: the iterator type inside `std::vector<int>` answers `std::vector`,
not itself. This is Clang's `Recognizer::operator()`, which C cannot spell.

This function allocates and one should call `dispose` to release the resources after using this object.
"""
function recognize(x::AbstractStdlibRecognizer, d::AbstractDecl)
    @check_ptrs x d
    ptr = clang_stdlib_Recognizer_recognize(x, d)
    return ptr == C_NULL ? nothing : StdlibSymbol(ptr)
end

dispose(x::StdlibRecognizer) = clang_stdlib_Recognizer_dispose(x)
