# Stamp carrier structs for every Stmt-hierarchy class the hand-written files
# (Stmt.jl, StmtCXX.jl, Expr.jl, ExprCXX.jl) don't define — OpenMP and ObjC
# included — so all 234 concrete classes are wrappable. Clang-abstract classes
# get carriers too (the Decl/Type_/Expr_ precedent), except classes clang
# names `Abstract*` (their name belongs to the abstract type). Runs after the
# hand-written files; existing structs are kept.
for node in STMT_NODES
    startswith(String(node.name), "Abstract") && continue
    sym = stmt_carrier_name(node.name)
    isdefined(@__MODULE__, sym) && continue
    asym = stmt_abstract_name(node.name)
    @eval begin
        """
            struct $($(QuoteNode(sym))) <: $($(QuoteNode(asym)))
        Hold a pointer to a `clang::$($(QuoteNode(node.name)))` object.
        """
        struct $sym <: $asym
            ptr::CXStmt
        end
        Base.unsafe_convert(::Type{CXStmt}, x::$sym) = x.ptr
        Base.cconvert(::Type{CXStmt}, x::$sym) = x
    end
end
