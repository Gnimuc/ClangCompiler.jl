# The abstract-type skeleton of the Stmt hierarchy that abstract.jl doesn't
# already define (the OpenMP/ObjC tail) is generated from the vendored
# StmtNodes.inc into lib/<major>/StmtAbstractGen.jl by gen/stmt_nodes.jl. Runs
# right after abstract.jl so the hand-written struct files can subtype per-class
# abstract types.
#
# Naming (mirrored in gen/stmt_nodes.jl): clang class `X` gets `AbstractX` and a
# carrier `X`, with no exception for classes clang itself names `Abstract*`. A name
# cannot be both, so where `AbstractX` is also a clang class the carrier keeps the
# plain name and the abstract takes a trailing underscore: `AbstractConditionalOperator`
# is the carrier for clang's class of that name, `AbstractAbstractConditionalOperator`
# is its abstract, and `ConditionalOperator` hangs off `AbstractConditionalOperator_`.
# Carrier `Expr` is spelled `Expr_` on the same tiebreak (Base.Expr clash).
include("StmtAbstractGen.jl")
