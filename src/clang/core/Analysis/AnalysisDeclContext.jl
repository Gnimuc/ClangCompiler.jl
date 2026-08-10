# AnalysisDeclContext — the per-Decl hub every analysis in clang/Analysis/Analyses is
# entered through, plus the two satellites it hands out borrowed. Local abstract types: none
# of these four classes has a Clang base class.
abstract type AbstractAnalysisDeclContext end

"""
    struct AnalysisDeclContext <: AbstractAnalysisDeclContext
Hold a pointer to a `clang::AnalysisDeclContext` object.

It caches, per `Decl` and built lazily on first request, the `CFG`, the `Stmt` -> `CFGBlock`
map over it, the `ParentMap` of the body and the reverse block-reachability analysis. A
context built by [`AnalysisDeclContext`](@ref) is caller-owned — call `dispose` after use.
One obtained from [`getContext`](@ref) is owned by its `AnalysisDeclContextManager`
instead and must NOT be disposed; disposing the manager releases it.
"""
struct AnalysisDeclContext <: AbstractAnalysisDeclContext
    ptr::CXAnalysisDeclContext
end

abstract type AbstractAnalysisDeclContextManager end

"""
    struct AnalysisDeclContextManager <: AbstractAnalysisDeclContextManager
Hold a pointer to a `clang::AnalysisDeclContextManager` object.

The pointee is caller-owned — call `dispose` after use, which also deletes every
`AnalysisDeclContext` the manager handed out.
"""
struct AnalysisDeclContextManager <: AbstractAnalysisDeclContextManager
    ptr::CXAnalysisDeclContextManager
end

abstract type AbstractCFGStmtMap end

"""
    struct CFGStmtMap <: AbstractCFGStmtMap
Hold a pointer to a `clang::CFGStmtMap` object.

The pointee is owned by the [`AnalysisDeclContext`](@ref) that built it — there is no
`dispose`, and it dies with that context.
"""
struct CFGStmtMap <: AbstractCFGStmtMap
    ptr::CXCFGStmtMap
end

abstract type AbstractParentMap end

"""
    struct ParentMap <: AbstractParentMap
Hold a pointer to a `clang::ParentMap` object.

The pointee is owned by the [`AnalysisDeclContext`](@ref) that built it — there is no
`dispose`, and it dies with that context. `clang/AST/ParentMap.h` is deliberately not
wrapped as a class of its own: this borrowed view is the only way to reach one.
"""
struct ParentMap <: AbstractParentMap
    ptr::CXParentMap
end

"""
    const AnalyzableDecl

The declaration kinds `clang::AnalysisDeclContext` can analyse. Its `getBody` switches on
the kind and ends in `llvm_unreachable`, so every accessor that reaches the body is
undefined for any other declaration; this union is that precondition, restated as a type so
dispatch enforces it at the one place a context is built.
"""
const AnalyzableDecl = Union{AbstractFunctionDecl,AbstractObjCMethodDecl,AbstractBlockDecl,
                             AbstractFunctionTemplateDecl}
