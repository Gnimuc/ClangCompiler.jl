# Parse the vendored StmtNodes.inc and emit EXPLICIT Julia source for the Stmt
# subsystem — no runtime `@eval`, no `STMT_NODES` mirror table. Regenerate on an
# LLVM bump (run standalone or via gen/generator.jl); the emitted files are
# committed into src/ (listed in .JuliaFormatter.toml ignore) and never hand-edited.
#
# The hand-written AST files (abstract.jl, Stmt.jl, StmtCXX.jl, Expr.jl,
# ExprCXX.jl) carry the commonly-used part of the hierarchy with per-class CX
# handle types; this generator emits only the COMPLEMENT — the abstract types
# abstract.jl doesn't define and the carriers the hand files don't define (the
# OpenMP/ObjC tail), plus the per-node wrappers and the class->carrier map for
# the WHOLE hierarchy. It reads those hand files to compute the complement, the
# same way the old runtime `isdefined` guards did.
#
# Emits four files into src/:
#   src/clang/core/AST/StmtAbstractGen.jl — abstract-type skeleton not in abstract.jl.
#   src/clang/core/AST/StmtCarriers.jl    — fill-in carriers (`ptr::CXStmt`) the hand files omit.
#   src/clang/api/AST/StmtWrappers.jl     — per-node `is<Name>` predicate + `<carrier>` downcast.
#   src/clang/StmtClassMap.jl             — `const STMT_CLASS_TO_TYPE = Dict{CXStmtClass,Any}(...)`.

const STMT_NODES_INC = normpath(joinpath(@__DIR__, "..", "deps", "ClangExtra", "include",
                                         "clang-ex", "AST", "StmtNodes.inc"))
const STMT_SRC = normpath(joinpath(@__DIR__, "..", "src"))
const SRC_AST = normpath(joinpath(@__DIR__, "..", "src", "clang", "core"))

function parse_stmt_nodes(inc_path)
    nodes = Vector{NamedTuple{(:name, :parent, :isabstract),Tuple{Symbol,Symbol,Bool}}}()
    abstract_re = r"^ABSTRACT_STMT\([A-Z][A-Z0-9_]*\((\w+),\s*(\w+)\)\)$"
    concrete_re = r"^([A-Z][A-Z0-9_]*)\((\w+),\s*(\w+)\)$"
    for line in eachline(inc_path)
        line = strip(line)
        m = match(abstract_re, line)
        if m !== nothing
            push!(nodes, (name=Symbol(m.captures[1]), parent=Symbol(m.captures[2]), isabstract=true))
            continue
        end
        m = match(concrete_re, line)
        m === nothing && continue
        m.captures[1] in ("STMT_RANGE", "LAST_STMT_RANGE", "ABSTRACT_STMT") && continue
        push!(nodes, (name=Symbol(m.captures[2]), parent=Symbol(m.captures[3]), isabstract=false))
    end
    return nodes
end

# `Expr` is carried by `Expr_` (Base.Expr clash); every other class keeps its name.
stmt_carrier_name(name) = name === :Expr ? "Expr_" : String(name)

# clang class `X` -> `AbstractX` + carrier `X`, with no exception for classes clang itself
# names `Abstract*`: `AbstractConditionalOperator` is a real class with its own state and its
# own `classof`, so it carries like any other.
#
# One name cannot be both, and `AbstractX` collides whenever clang also has a class named
# `AbstractX` — `ConditionalOperator` vs `AbstractConditionalOperator` is the only such pair
# here. The carrier keeps the plain name because it mirrors clang's, so the abstract takes a
# trailing underscore: the same tiebreak `Expr_` uses against `Base.Expr`.
function stmt_abstract_name(name, carriers)
    a = "Abstract" * String(name)
    return a in carriers ? a * "_" : a
end

"The abstract type a class's carrier subtypes, and that its children hang off."
stmt_abstract_of(name, carriers) = name === :Stmt ? "AbstractStmt" :
                                   stmt_abstract_name(name, carriers)

# names matching `regex`'s first capture across the given files (col-0 anchored)
function collect_names(files, regex)
    s = Set{String}()
    for f in files, line in eachline(f)
        m = match(regex, line)
        m === nothing || push!(s, m.captures[1])
    end
    return s
end

const GEN_NOTE = "# Generated from deps/ClangExtra/include/clang-ex/AST/StmtNodes.inc by gen/stmt_nodes.jl — do not edit."

function emit_abstract(io, nodes, predefined, carriers)
    println(io, GEN_NOTE)
    println(io, "# Abstract-type skeleton for the Stmt hierarchy not already defined in abstract.jl.")
    for n in nodes
        asym = stmt_abstract_name(n.name, carriers)
        asym in predefined && continue
        psym = stmt_abstract_of(n.parent, carriers)
        println(io, """
        \"\"\"
            abstract type $asym <: $psym
        Supertype for `$(n.name)`s.
        \"\"\"
        abstract type $asym <: $psym end
        """)
    end
end

function emit_carriers(io, nodes, hand, carriers)
    println(io, GEN_NOTE)
    println(io, "# Fill-in carriers (ptr::CXStmt) for Stmt classes the hand-written files omit.")
    for n in nodes
        sym = stmt_carrier_name(n.name)
        sym in hand && continue
        asym = stmt_abstract_name(n.name, carriers)
        println(io, """
        \"\"\"
            struct $sym <: $asym
        Hold a pointer to a `clang::$(n.name)` object.
        \"\"\"
        struct $sym <: $asym
            ptr::CXStmt
        end

        Base.unsafe_convert(::Type{CXStmt}, x::$sym) = x.ptr
        Base.cconvert(::Type{CXStmt}, x::$sym) = x
        """)
    end
end

function emit_wrappers(io, nodes)
    println(io, GEN_NOTE)
    println(io, "# Per-node downcast: `is<Name>` predicate and `<carrier>` constructor-shaped")
    println(io, "# cast for every class, abstract bases included — the C shim stamps both from")
    println(io, "# the same table, and clang's own `classof` makes the dyn_cast sound.")
    for n in nodes
        println(io, """
        function is$(n.name)(x::AbstractStmt)
            @check_ptrs x
            return clang_Stmt_is$(n.name)(x)
        end
        """)
        sym = stmt_carrier_name(n.name)
        println(io, """
        function $sym(x::AbstractStmt)
            @check_ptrs x
            return $sym(clang_Stmt_castTo$(n.name)(x))
        end
        """)
    end
end

function emit_classmap(io, nodes)
    println(io, GEN_NOTE)
    println(io, "# CXStmtClass -> concrete carrier, so `resolve(::AbstractStmt)` is one")
    println(io, "# getStmtClass call plus one lookup. Both derive from StmtNodes.inc.")
    println(io, "const STMT_CLASS_TO_TYPE = Dict{CXStmtClass,Any}(")
    for n in nodes
        n.isabstract && continue
        println(io, "    LibClangEx.CXStmtClass_$(n.name)Class => $(stmt_carrier_name(n.name)),")
    end
    println(io, ")")
end

function emit_stmt_sources()
    nodes = parse_stmt_nodes(STMT_NODES_INC)
    predefined = collect_names([joinpath(SRC_AST, "abstract.jl")], r"^abstract type (\w+)")
    hand = collect_names([joinpath(SRC_AST, "AST", f) for f in
                                                          ("Stmt.jl", "StmtCXX.jl", "Expr.jl", "ExprCXX.jl")],
                         r"^struct (\w+)")
    carriers = Set(stmt_carrier_name(n.name) for n in nodes)
    @info "Stmt sources" total = length(nodes) concrete = count(!, getindex.(nodes, :isabstract)) predefined = length(predefined) hand = length(hand)
    open(io -> emit_abstract(io, nodes, predefined, carriers),
         joinpath(STMT_SRC, "clang", "core", "AST", "StmtAbstractGen.jl"), "w")
    open(io -> emit_carriers(io, nodes, hand, carriers),
         joinpath(STMT_SRC, "clang", "core", "AST", "StmtCarriers.jl"), "w")
    open(io -> emit_wrappers(io, nodes), joinpath(STMT_SRC, "clang", "api", "AST", "StmtWrappers.jl"), "w")
    open(io -> emit_classmap(io, nodes), joinpath(STMT_SRC, "clang", "StmtClassMap.jl"), "w")
    @info "wrote Stmt sources into src/"
end

emit_stmt_sources()
