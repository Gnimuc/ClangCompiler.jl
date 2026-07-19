# Parse the vendored DeclNodes.inc into a Julia class table.
#
# Emits lib/<major>/DeclNodes.jl containing `DECL_NODES`, the (name, parent,
# isabstract) tuple list in .inc order. `name` is the bare DeclNodes spelling
# (matching CXDeclKind_<name> and clang::Decl::<name>); the Julia carrier is
# `<name>Decl`. clang::Decl::Kind is a dense enum, so the Nth CONCRETE entry
# here has kind value N — the Julia layer maps getKind -> concrete carrier from
# that. DECL_RANGE / LAST_DECL_RANGE markers are dropped (they only alias).
#
# Run standalone or via gen/generator.jl (which includes this file last).

const DECL_NODES_INC = normpath(joinpath(@__DIR__, "..", "deps", "ClangExtra", "include",
                                         "clang-ex", "AST", "DeclNodes.inc"))
const DECL_LIB_DIR = normpath(joinpath(@__DIR__, "..", "lib"))

function parse_decl_nodes(inc_path)
    nodes = Vector{NamedTuple{(:name, :parent, :isabstract),Tuple{Symbol,Symbol,Bool}}}()
    abstract_re = r"^ABSTRACT_DECL\([A-Z][A-Z0-9_]*\((\w+),\s*(\w+)\)\)$"
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
        macroname in ("DECL_RANGE", "LAST_DECL_RANGE", "ABSTRACT_DECL") && continue
        push!(nodes, (name=Symbol(m.captures[2]), parent=Symbol(m.captures[3]),
                      isabstract=false))
    end
    return nodes
end

function emit_decl_nodes()
    nodes = parse_decl_nodes(DECL_NODES_INC)
    nconcrete = count(!, getindex.(nodes, :isabstract))
    @info "DeclNodes table" total = length(nodes) concrete = nconcrete
    for dir in readdir(DECL_LIB_DIR)
        isdir(joinpath(DECL_LIB_DIR, dir)) || continue
        tryparse(Int, dir) === nothing && continue
        path = joinpath(DECL_LIB_DIR, dir, "DeclNodes.jl")
        open(path, "w") do io
            println(io,
                    "# Generated from deps/ClangExtra/include/clang-ex/AST/DeclNodes.inc by gen/decl_nodes.jl — do not edit.")
            println(io,
                    "# Entries are in DeclNodes.inc order; the Nth concrete entry has CXDeclKind value N. Carrier = <name>Decl.")
            println(io, "const DECL_NODES = [")
            for n in nodes
                println(io,
                        "    (name = :$(n.name), parent = :$(n.parent), isabstract = $(n.isabstract)),")
            end
            println(io, "]")
        end
        @info "wrote" path
    end
end

emit_decl_nodes()
