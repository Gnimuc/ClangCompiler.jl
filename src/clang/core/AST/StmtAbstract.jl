# The abstract-type skeleton of the Stmt hierarchy that abstract.jl doesn't
# already define (the OpenMP/ObjC tail) is generated from the vendored
# StmtNodes.inc into lib/<major>/StmtAbstractGen.jl by gen/stmt_nodes.jl. Runs
# right after abstract.jl so the hand-written struct files can subtype per-class
# abstract types.
#
# Naming (mirrored in gen/stmt_nodes.jl): clang class `X` gets `AbstractX`,
# except classes clang itself names `Abstract*` (e.g. `AbstractConditionalOperator`),
# whose Julia abstract doubles as the per-class abstract of their children;
# carrier `Expr` is spelled `Expr_` (Base.Expr clash).
include("StmtAbstractGen.jl")
