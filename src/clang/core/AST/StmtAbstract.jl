# The abstract-type skeleton of the Stmt hierarchy that abstract.jl doesn't
# already define (the OpenMP/ObjC tail) is generated from the vendored
# StmtNodes.inc into src/clang/core/AST/StmtAbstractGen.jl by gen/stmt_nodes.jl. Runs
# right after abstract.jl so the hand-written struct files can subtype per-class
# abstract types.
#
# Naming (mirrored in gen/stmt_nodes.jl): clang class `X` gets `AbstractX` and a
# carrier `X`. A class clang itself names `Abstract*` is not mirrored at all -- no
# carrier, no abstract, children hung off its parent -- because `Abstract` + `X` and
# the mirror of `AbstractX` are the same string, and only one of the two classes can
# have it. `AbstractConditionalOperator` is the sole case in StmtNodes.inc, and it is
# the one dropped: it cannot be instantiated, `resolve` never yields it, and what it
# declares is exposed on `ConditionalOperator` and `BinaryConditionalOperator`.
# Carrier `Expr` is spelled `Expr_` on a different tiebreak (Base.Expr clash).
include("StmtAbstractGen.jl")
