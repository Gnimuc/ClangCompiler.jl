# Local abstract types: `clang::ExprMutationAnalyzer` and its per-parameter wrapper are
# standalone classes in clang/Analysis/Analyses/ExprMutationAnalyzer.h with no base, so
# they are not part of core/abstract.jl.
abstract type AbstractExprMutationAnalyzer end
abstract type AbstractFunctionParmMutationAnalyzer end

"""
    struct ExprMutationAnalyzer <: AbstractExprMutationAnalyzer
Hold a pointer to a `clang::ExprMutationAnalyzer` object.

Answers "is this expression written through, anywhere inside the statement I was built
over?". The pointee is caller-owned (`ExprMutationAnalyzer(stmt, ctx)` heap-allocates it)
— call `dispose` after use. It stores the statement and the `ASTContext` as C++
references, so both must outlive it, and every `Expr` or `Decl` handed to a query must
belong to them.
"""
struct ExprMutationAnalyzer <: AbstractExprMutationAnalyzer
    ptr::CXExprMutationAnalyzer
end

"""
    struct FunctionParmMutationAnalyzer <: AbstractFunctionParmMutationAnalyzer
Hold a pointer to a `clang::FunctionParmMutationAnalyzer` object.

An `ExprMutationAnalyzer` specialised to a function body, answering the mutation question
per parameter. The pointee is caller-owned — call `dispose` after use — and holds the
function's body and the `ASTContext` by reference, so both must outlive it.
"""
struct FunctionParmMutationAnalyzer <: AbstractFunctionParmMutationAnalyzer
    ptr::CXFunctionParmMutationAnalyzer
end
