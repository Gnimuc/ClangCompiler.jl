# Stamp the abstract-type skeleton of the Stmt hierarchy from the STMT_NODES
# table (generated from the vendored StmtNodes.inc — see gen/stmt_nodes.jl).
# Runs right after abstract.jl so the hand-written struct files can subtype
# per-class abstract types; types abstract.jl already defines are skipped.
#
# Naming: clang class `X` gets `AbstractX`, except classes clang itself names
# `Abstract*` (e.g. `AbstractConditionalOperator`), which keep their own name
# — their Julia abstract doubles as the per-class abstract of their children.
stmt_abstract_name(name::Symbol) = startswith(String(name), "Abstract") ? name :
                                   Symbol("Abstract", name)

# Carrier struct names: `Expr` is carried by `Expr_` (Base.Expr clash);
# clang-`Abstract*`-named classes get no carrier (their name is taken by the
# abstract type itself).
stmt_carrier_name(name::Symbol) = name === :Expr ? :Expr_ : name

for node in STMT_NODES
    asym = stmt_abstract_name(node.name)
    psym = node.parent === :Stmt ? :AbstractStmt : stmt_abstract_name(node.parent)
    if !isdefined(@__MODULE__, asym)
        @eval begin
            """
                abstract type $($(QuoteNode(asym))) <: $($(QuoteNode(psym)))
            Supertype for `$($(QuoteNode(node.name)))`s.
            """
            abstract type $asym <: $psym end
        end
    end
end
