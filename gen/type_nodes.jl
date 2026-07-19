# Parse the vendored TypeNodes.inc into a Julia class table.
#
# Emits lib/<major>/TypeNodes.jl containing `TYPE_NODES`, the (name, parent,
# isabstract) tuple list in .inc order. `name` is the bare TypeNodes spelling
# (matching CXTypeClass_<name> and clang::Type::<name>); the Julia carrier is
# `<name>Type`. clang::Type::TypeClass is dense, so the Nth CONCRETE entry here
# has class value N — the Julia layer maps getTypeClass -> concrete carrier from
# that. LAST_TYPE / LEAF_TYPE markers are one-arg and dropped; the concrete
# NON_CANONICAL_TYPE / DEPENDENT_TYPE variants default to TYPE and are kept.
#
# Run standalone or via gen/generator.jl (which includes this file last).

const TYPE_NODES_INC = normpath(joinpath(@__DIR__, "..", "deps", "ClangExtra", "include",
                                         "clang-ex", "AST", "TypeNodes.inc"))
const TYPE_LIB_DIR = normpath(joinpath(@__DIR__, "..", "lib"))

function parse_type_nodes(inc_path)
    nodes = Vector{NamedTuple{(:name, :parent, :isabstract),Tuple{Symbol,Symbol,Bool}}}()
    abstract_re = r"^ABSTRACT_TYPE\((\w+),\s*(\w+)\)$"
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
        # ABSTRACT_TYPE handled above; LAST_TYPE/LEAF_TYPE are one-arg (no match);
        # TYPE / NON_CANONICAL_TYPE / DEPENDENT_TYPE / NON_CANONICAL_UNLESS_DEPENDENT_TYPE
        # are all concrete.
        m.captures[1] == "ABSTRACT_TYPE" && continue
        push!(nodes, (name=Symbol(m.captures[2]), parent=Symbol(m.captures[3]),
                      isabstract=false))
    end
    return nodes
end

function emit_type_nodes()
    nodes = parse_type_nodes(TYPE_NODES_INC)
    nconcrete = count(!, getindex.(nodes, :isabstract))
    @info "TypeNodes table" total = length(nodes) concrete = nconcrete
    for dir in readdir(TYPE_LIB_DIR)
        isdir(joinpath(TYPE_LIB_DIR, dir)) || continue
        tryparse(Int, dir) === nothing && continue
        path = joinpath(TYPE_LIB_DIR, dir, "TypeNodes.jl")
        open(path, "w") do io
            println(io,
                    "# Generated from deps/ClangExtra/include/clang-ex/AST/TypeNodes.inc by gen/type_nodes.jl — do not edit.")
            println(io,
                    "# Entries are in TypeNodes.inc order; the Nth concrete entry has CXTypeClass value N. Carrier = <name>Type.")
            println(io, "const TYPE_NODES = [")
            for n in nodes
                println(io,
                        "    (name = :$(n.name), parent = :$(n.parent), isabstract = $(n.isabstract)),")
            end
            println(io, "]")
        end
        @info "wrote" path
    end
end

emit_type_nodes()
