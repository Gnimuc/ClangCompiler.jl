# Parse the vendored StmtNodes.inc into a Julia class table.
#
# Emits lib/<major>/StmtNodes.jl containing `STMT_NODES`, the (name, parent,
# isabstract) tuple list in .inc order — the same order that defines
# clang::Stmt::StmtClass / CXStmtClass values, so the position of the Nth
# concrete entry is its enum value. The Julia core layer stamps the Stmt
# hierarchy (abstract types + carrier structs) from this table, and
# test/stmt.jl checks the stamped hierarchy against it.
#
# Run standalone or via gen/generator.jl (which includes this file last).

const STMT_NODES_INC = normpath(joinpath(@__DIR__, "..", "deps", "ClangExtra", "include",
                                         "clang-ex", "AST", "StmtNodes.inc"))
const LIB_DIR = normpath(joinpath(@__DIR__, "..", "lib"))

function parse_stmt_nodes(inc_path)
    nodes = Vector{NamedTuple{(:name, :parent, :isabstract),Tuple{Symbol,Symbol,Bool}}}()
    abstract_re = r"^ABSTRACT_STMT\([A-Z][A-Z0-9_]*\((\w+),\s*(\w+)\)\)$"
    concrete_re = r"^([A-Z][A-Z0-9_]*)\((\w+),\s*(\w+)\)$"
    for line in eachline(inc_path)
        line = strip(line)
        m = match(abstract_re, line)
        if m !== nothing
            push!(nodes, (name=Symbol(m.captures[1]), parent=Symbol(m.captures[2]),
                          isabstract=true))
            continue
        end
        m = match(concrete_re, line)
        m === nothing && continue
        macroname = m.captures[1]
        macroname in ("STMT_RANGE", "LAST_STMT_RANGE", "ABSTRACT_STMT") && continue
        push!(nodes, (name=Symbol(m.captures[2]), parent=Symbol(m.captures[3]),
                      isabstract=false))
    end
    return nodes
end

function emit_stmt_nodes()
    nodes = parse_stmt_nodes(STMT_NODES_INC)
    nconcrete = count(!, getindex.(nodes, :isabstract))
    @info "StmtNodes table" total = length(nodes) concrete = nconcrete
    for dir in readdir(LIB_DIR)
        isdir(joinpath(LIB_DIR, dir)) || continue
        tryparse(Int, dir) === nothing && continue
        path = joinpath(LIB_DIR, dir, "StmtNodes.jl")
        open(path, "w") do io
            println(io,
                    "# Generated from deps/ClangExtra/include/clang-ex/AST/StmtNodes.inc by gen/stmt_nodes.jl — do not edit.")
            println(io,
                    "# Entries are in StmtNodes.inc order; the Nth concrete entry has CXStmtClass value N.")
            println(io, "const STMT_NODES = [")
            for n in nodes
                println(io,
                        "    (name = :$(n.name), parent = :$(n.parent), isabstract = $(n.isabstract)),")
            end
            println(io, "]")
        end
        @info "wrote" path
    end
end

emit_stmt_nodes()
