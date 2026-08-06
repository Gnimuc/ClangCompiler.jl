# Carrier structs for every Stmt-hierarchy class the hand-written files (Stmt.jl,
# StmtCXX.jl, Expr.jl, ExprCXX.jl) don't define — OpenMP/ObjC included, all with
# ptr::CXStmt — are generated from the vendored StmtNodes.inc into
# src/clang/core/AST/StmtCarriers.jl by gen/stmt_nodes.jl. Clang-abstract classes get
# carriers too (the Decl/Type_/Expr_ precedent), except classes clang names
# `Abstract*` (their name belongs to the abstract type). Runs after the
# hand-written files.
include("StmtCarriers.jl")
