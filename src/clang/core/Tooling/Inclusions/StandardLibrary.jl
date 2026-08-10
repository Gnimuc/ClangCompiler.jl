"""
    abstract type AbstractStdlibHeader <: Any
Supertype for `StdlibHeader`s.
"""
abstract type AbstractStdlibHeader end

"""
    struct StdlibHeader <: AbstractStdlibHeader
Hold a pointer to a `clang::tooling::stdlib::Header` object.

`clang::tooling::stdlib::Header` is an index into a static table — literally an id and a
language — so the object behind this handle is a heap-boxed copy. Copies returned by
`named`, `header` and `Recognizer` are caller-owned and released with `dispose`; the ones
handed out by `StdlibHeaderList` are borrowed from the list and must not be.
"""
struct StdlibHeader <: AbstractStdlibHeader
    ptr::CXStdlibHeader
end

"""
    abstract type AbstractStdlibHeaderList <: Any
Supertype for `StdlibHeaderList`s.
"""
abstract type AbstractStdlibHeaderList end

"""
    struct StdlibHeaderList <: AbstractStdlibHeaderList
Hold a pointer to a shim-owned `std::vector<clang::tooling::stdlib::Header>`.

Clang returns `all()` and `headers()` by value, so there is no clang-owned array to borrow;
the list is caller-owned and released with `dispose`.
"""
struct StdlibHeaderList <: AbstractStdlibHeaderList
    ptr::CXStdlibHeaderList
end

"""
    abstract type AbstractStdlibSymbol <: Any
Supertype for `StdlibSymbol`s.
"""
abstract type AbstractStdlibSymbol end

"""
    struct StdlibSymbol <: AbstractStdlibSymbol
Hold a pointer to a `clang::tooling::stdlib::Symbol` object.

Same shape as `StdlibHeader`: an index into a static table, heap-boxed. Copies from `named`
and `Recognizer` are caller-owned; the ones from a `StdlibSymbolList` are borrowed.
"""
struct StdlibSymbol <: AbstractStdlibSymbol
    ptr::CXStdlibSymbol
end

"""
    abstract type AbstractStdlibSymbolList <: Any
Supertype for `StdlibSymbolList`s.
"""
abstract type AbstractStdlibSymbolList end

"""
    struct StdlibSymbolList <: AbstractStdlibSymbolList
Hold a pointer to a shim-owned `std::vector<clang::tooling::stdlib::Symbol>`.
"""
struct StdlibSymbolList <: AbstractStdlibSymbolList
    ptr::CXStdlibSymbolList
end

"""
    abstract type AbstractStdlibRecognizer <: Any
Supertype for `StdlibRecognizer`s.
"""
abstract type AbstractStdlibRecognizer end

"""
    struct StdlibRecognizer <: AbstractStdlibRecognizer
Hold a pointer to a `clang::tooling::stdlib::Recognizer` object.

The recognizer memoises per `DeclContext`, so it is keyed on raw context pointers: use one
per `ASTContext` and do not let it outlive that context.
"""
struct StdlibRecognizer <: AbstractStdlibRecognizer
    ptr::CXStdlibRecognizer
end
