# Diagnostics and Parser (clang::ast_matchers::dynamic)
#
# The string front end to the matcher DSL. Clang's ~700 matcher factories are variadic
# function templates with no addresses, so none of them can be wrapped one by one; the
# registry the parser consults holds a descriptor for every one of them, which is what makes
# a matcher spelled as TEXT the way to reach all of them from Julia.

"""
    MatcherDiagnostics()
Create the error sink [`parseMatcherExpression`](@ref) writes into.

A sink may be reused across parses, in which case the errors accumulate — build a fresh one
per parse if [`getNumErrors`](@ref) is to mean "did *this* parse fail".

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function MatcherDiagnostics()
    ptr = clang_MatcherDiagnostics_create()
    @assert ptr != C_NULL "Failed to create MatcherDiagnostics"
    return MatcherDiagnostics(ptr)
end

dispose(x::MatcherDiagnostics) = clang_MatcherDiagnostics_dispose(x)

"""
    getNumErrors(x::AbstractMatcherDiagnostics) -> Integer
Return how many errors have been recorded. Zero after a successful parse.
"""
function getNumErrors(x::AbstractMatcherDiagnostics)
    @check_ptrs x
    return clang_MatcherDiagnostics_getNumErrors(x)
end

"""
    toString(x::AbstractMatcherDiagnostics) -> String
Return one line per recorded error, message only — empty exactly when
[`getNumErrors`](@ref) is zero.
"""
function toString(x::AbstractMatcherDiagnostics)
    @check_ptrs x
    return get_string(clang_MatcherDiagnostics_toString(x))
end

"""
    toStringFull(x::AbstractMatcherDiagnostics) -> String
Return one line per recorded error carrying its full context chain ("Error parsing argument 1
for matcher hasName" and so on) — what `clang-query` prints.
"""
function toStringFull(x::AbstractMatcherDiagnostics)
    @check_ptrs x
    return get_string(clang_MatcherDiagnostics_toStringFull(x))
end

"""
    parseMatcherExpression(code::AbstractString, err::AbstractMatcherDiagnostics) -> DynTypedMatcher
    parseMatcherExpression(code::AbstractString, named_values::AbstractNamedValueMap,
                           err::AbstractMatcherDiagnostics) -> DynTypedMatcher
Parse a `clang-query` matcher expression — `"cxxRecordDecl(hasName(\\"Foo\\")).bind(\\"r\\")"` —
into a matcher that [`addDynamicMatcher`](@ref) can run.

The result is a null handle on failure, and `err` then holds the reason
([`toStringFull`](@ref)). `named_values`, when given, is the dictionary the expression's bare
identifiers resolve against — `clang-query`'s `let name = matcher`.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function parseMatcherExpression(code::AbstractString, err::AbstractMatcherDiagnostics)
    @check_ptrs err
    return DynTypedMatcher(clang_Parser_parseMatcherExpression(code, CXNamedValueMap(C_NULL), err))
end

function parseMatcherExpression(code::AbstractString, named_values::AbstractNamedValueMap, err::AbstractMatcherDiagnostics)
    @check_ptrs named_values err
    return DynTypedMatcher(clang_Parser_parseMatcherExpression(code, named_values, err))
end

"""
    completeExpression(code::AbstractString, offset::Integer) -> MatcherCompletionList
    completeExpression(code::AbstractString, offset::Integer,
                       named_values::AbstractNamedValueMap) -> MatcherCompletionList
Return the matcher-name completions valid at byte `offset` into `code`.

`offset` 0 with an empty `code` enumerates every root matcher the pinned LLVM knows, which is
also the only way to list them without hand-maintaining the list. Errors are not reported: an
unparsable prefix simply yields an empty list.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function completeExpression(code::AbstractString, offset::Integer)
    @assert offset >= 0 "completion offset must be non-negative"
    return MatcherCompletionList(clang_Parser_completeExpression(code, offset, CXNamedValueMap(C_NULL)))
end

function completeExpression(code::AbstractString, offset::Integer, named_values::AbstractNamedValueMap)
    @check_ptrs named_values
    @assert offset >= 0 "completion offset must be non-negative"
    return MatcherCompletionList(clang_Parser_completeExpression(code, offset, named_values))
end

# MatcherCompletion (clang/ASTMatchers/Dynamic/Registry.h) — returned by value in a
# std::vector, so the vector is boxed whole and its elements read out by index.

dispose(x::MatcherCompletionList) = clang_MatcherCompletionList_dispose(x)

"""
    getNumCompletions(x::AbstractMatcherCompletionList) -> Integer
Return how many completions the list holds.
"""
function getNumCompletions(x::AbstractMatcherCompletionList)
    @check_ptrs x
    return clang_MatcherCompletionList_getNumCompletions(x)
end

"""
    getTypedText(x::AbstractMatcherCompletionList, i::Integer) -> String
Return the text to type to select the `i`-th completion, counting from 0.
"""
function getTypedText(x::AbstractMatcherCompletionList, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumCompletions(x) "completion index $i out of range"
    return get_string(clang_MatcherCompletionList_getTypedText(x, i))
end

"""
    getMatcherDecl(x::AbstractMatcherCompletionList, i::Integer) -> String
Return the `i`-th completion's "declaration" — the matcher's name with its type information,
for display.
"""
function getMatcherDecl(x::AbstractMatcherCompletionList, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumCompletions(x) "completion index $i out of range"
    return get_string(clang_MatcherCompletionList_getMatcherDecl(x, i))
end

"""
    getSpecificity(x::AbstractMatcherCompletionList, i::Integer) -> Integer
Return how specific the conversion behind the `i`-th completion is. Zero would mean a matcher
that always or never matches; Clang excludes those from completion results, so a completion
that reaches Julia has a non-zero specificity.
"""
function getSpecificity(x::AbstractMatcherCompletionList, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumCompletions(x) "completion index $i out of range"
    return clang_MatcherCompletionList_getSpecificity(x, i)
end
