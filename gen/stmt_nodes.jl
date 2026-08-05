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
#   src/clang/core/AST/StmtCarriers.jl    — fill-in carriers (`ptr::CX<Class>`) the hand files omit.
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

# A class clang itself names `Abstract*` is not mirrored: no carrier, no abstract type, and
# its children hang off ITS parent instead. `AbstractConditionalOperator` is the only one in
# StmtNodes.inc, and mirroring it costs more than it carries.
#
# The name is what forces the choice. `Abstract` + `ConditionalOperator` and the mirror of
# `AbstractConditionalOperator` are the same string, so one of the two classes has to give up
# its natural spelling; there is no arrangement in which both keep it. Dropping the abstract
# one is the cheaper give: it cannot be instantiated, `resolve` never yields it (it has no
# StmtClass of its own), and everything it declares is reachable on the two concrete spellings
# below it, which is where those wrappers now live.
is_unmirrored(name) = startswith(String(name), "Abstract")

stmt_abstract_name(name, carriers) = "Abstract" * String(name)

"The abstract type a class's carrier subtypes, and that its children hang off."
function stmt_abstract_of(name, carriers, parents=Dict{Symbol,Symbol}())
    name === :Stmt && return "AbstractStmt"
    # skip past an unmirrored ancestor to the nearest class that has an abstract type
    while is_unmirrored(name) && haskey(parents, name)
        name = parents[name]
    end
    return name === :Stmt ? "AbstractStmt" : stmt_abstract_name(name, carriers)
end

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

function emit_abstract(io, nodes, predefined, carriers, parents)
    println(io, GEN_NOTE)
    println(io, "# Abstract-type skeleton for the Stmt hierarchy not already defined in abstract.jl.")
    println(io, "# Classes clang names `Abstract*` are not mirrored; their children hang off the")
    println(io, "# nearest ancestor that is.")
    for n in nodes
        is_unmirrored(n.name) && continue
        asym = stmt_abstract_name(n.name, carriers)
        asym in predefined && continue
        psym = stmt_abstract_of(n.parent, carriers, parents)
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
    println(io, "# Fill-in carriers for Stmt classes the hand-written files omit. Each holds the")
    println(io, "# handle of its own class, so the stamped cast that produces it type-checks.")
    println(io, "# What a carrier ACCEPTS is decided by clang/handles.jl, not here: a handle of")
    println(io, "# another class does not convert, so no carrier needs a constructor of its own.")
    println(io, "# Marshalling is the carrier's own entry in converts.jl, plus the `CXStmt`")
    println(io, "# entry keyed on `AbstractStmt` that carries it to every base-class binding.")
    for n in nodes
        is_unmirrored(n.name) && continue
        sym = stmt_carrier_name(n.name)
        sym in hand && continue
        asym = stmt_abstract_name(n.name, carriers)
        println(io, """
        \"\"\"
            struct $sym <: $asym
        Hold a pointer to a `clang::$(n.name)` object.
        \"\"\"
        struct $sym <: $asym
            ptr::CX$(n.name)
        end
        """)
    end
end

function emit_wrappers(io, nodes)
    println(io, GEN_NOTE)
    println(io, "# Per-node downcast: `is<Name>` predicate and `<carrier>` constructor-shaped")
    println(io, "# cast for every class, abstract bases included — the C shim stamps both from")
    println(io, "# the same table, and clang's own `classof` makes the dyn_cast sound.")
    println(io, "#")
    println(io, "# The shim stamps each cast to return that class's own handle, so the carrier it")
    println(io, "# feeds is checked by the compiler -- pairing a cast with the wrong carrier is a")
    println(io, "# type error here rather than a pointer of the wrong class reaching clang.")
    for n in nodes
        println(io, """
        function is$(n.name)(x::AbstractStmt)
            @check_ptrs x
            return clang_Stmt_is$(n.name)(x)
        end
        """)
        # an unmirrored class keeps its predicate -- "is this any kind of conditional?" is a
        # real question -- but has no carrier for a cast to produce
        is_unmirrored(n.name) && continue
        sym = stmt_carrier_name(n.name)
        # the OpenMP directive names run past the margin on one line
        body = "return $sym(clang_Stmt_castTo$(n.name)(x))"
        length(body) + 4 <= 120 ||
            (body = "return $sym(\n        clang_Stmt_castTo$(n.name)(x))")
        println(io, """
        function $sym(x::AbstractStmt)
            @check_ptrs x
            $body
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
    carriers = Set(stmt_carrier_name(n.name) for n in nodes if !is_unmirrored(n.name))
    parents = Dict(n.name => n.parent for n in nodes)
    @info "Stmt sources" total = length(nodes) concrete = count(!, getindex.(nodes, :isabstract)) predefined = length(predefined) hand = length(hand) unmirrored = [n.name for n in nodes if is_unmirrored(n.name)]
    open(io -> emit_abstract(io, nodes, predefined, carriers, parents),
         joinpath(STMT_SRC, "clang", "core", "AST", "StmtAbstractGen.jl"), "w")
    open(io -> emit_carriers(io, nodes, hand, carriers),
         joinpath(STMT_SRC, "clang", "core", "AST", "StmtCarriers.jl"), "w")
    open(io -> emit_wrappers(io, nodes), joinpath(STMT_SRC, "clang", "api", "AST", "StmtWrappers.jl"), "w")
    open(io -> emit_classmap(io, nodes), joinpath(STMT_SRC, "clang", "StmtClassMap.jl"), "w")
    @info "wrote Stmt sources into src/"
end

emit_stmt_sources()
