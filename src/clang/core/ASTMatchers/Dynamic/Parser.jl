"""
    abstract type AbstractMatcherDiagnostics <: Any
Supertype for `MatcherDiagnostics`.
"""
abstract type AbstractMatcherDiagnostics end

"""
    struct MatcherDiagnostics <: AbstractMatcherDiagnostics
Hold a pointer to a `clang::ast_matchers::dynamic::Diagnostics` object.

The error sink a matcher-expression parse writes into. Named for the C handle rather than for
the C++ class: `Diagnostics` alone would read as the `DiagnosticsEngine` family in
`Basic/Diagnostic.jl`, which this is unrelated to.
"""
struct MatcherDiagnostics <: AbstractMatcherDiagnostics
    ptr::CXMatcherDiagnostics
end

"""
    abstract type AbstractMatcherCompletionList <: Any
Supertype for `MatcherCompletionList`s.
"""
abstract type AbstractMatcherCompletionList end

"""
    struct MatcherCompletionList <: AbstractMatcherCompletionList
Hold a pointer to a heap-boxed `std::vector<clang::ast_matchers::dynamic::MatcherCompletion>`.

`Parser::completeExpression` returns its completions by value, so the whole vector is boxed
once rather than one handle per element; the three fields of each completion are read out by
index.
"""
struct MatcherCompletionList <: AbstractMatcherCompletionList
    ptr::CXMatcherCompletionList
end
