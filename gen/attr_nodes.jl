# Parse the vendored AttrList.inc into a Julia attribute table.
#
# Emits lib/<major>/AttrNodes.jl containing `ATTR_NODES`, the (name, category)
# tuple list in .inc order — position (0-based) is the CXAttrKind /
# clang::attr::Kind value. `category` is the attribute's C++ base class in
# clang/AST/Attr.h, derived from which X-macro spells the entry
# (DECL_OR_TYPE_ATTR entries carry :InheritableAttr — clang defines no
# DeclOrTypeAttr class). Every attribute class is concrete (the hierarchy has
# leaf attributes only), so there is no isabstract column. The Julia core layer
# stamps the Attr carriers from this table, and test/attributes.jl checks the
# stamped hierarchy against it.
#
# Run standalone or via gen/generator.jl (which includes this file last).

const ATTR_LIST_INC = normpath(joinpath(@__DIR__, "..", "deps", "ClangExtra", "include",
                                        "clang-ex", "AST", "AttrList.inc"))
const ATTR_LIB_DIR = normpath(joinpath(@__DIR__, "..", "lib"))

# X-macro -> the C++ base class the attribute derives from (clang/AST/Attr.h).
const ATTR_MACRO_TO_CATEGORY = Dict("ATTR" => :Attr,
                                    "TYPE_ATTR" => :TypeAttr,
                                    "STMT_ATTR" => :StmtAttr,
                                    "DECL_OR_STMT_ATTR" => :DeclOrStmtAttr,
                                    "INHERITABLE_ATTR" => :InheritableAttr,
                                    "DECL_OR_TYPE_ATTR" => :InheritableAttr,
                                    "INHERITABLE_PARAM_ATTR" => :InheritableParamAttr,
                                    "PARAMETER_ABI_ATTR" => :ParameterABIAttr,
                                    "HLSL_ANNOTATION_ATTR" => :HLSLAnnotationAttr)

function parse_attr_nodes(inc_path)
    nodes = Vector{NamedTuple{(:name, :category),Tuple{Symbol,Symbol}}}()
    # single-argument entry lines only: ATTR_RANGE has three arguments and
    # never matches; #define/#undef lines never match the anchored macro name
    entry_re = r"^([A-Z][A-Z0-9_]*)\((\w+)\)$"
    for line in eachline(inc_path)
        line = strip(line)
        m = match(entry_re, line)
        m === nothing && continue
        macroname = m.captures[1]
        # the PRAGMA_SPELLING_ATTR block re-lists a spelling subset of the
        # attributes above it — not new entries
        macroname == "PRAGMA_SPELLING_ATTR" && continue
        category = get(ATTR_MACRO_TO_CATEGORY, macroname, nothing)
        category === nothing && error("unknown AttrList.inc macro: $macroname")
        push!(nodes, (name=Symbol(m.captures[2]), category=category))
    end
    return nodes
end

function emit_attr_nodes()
    nodes = parse_attr_nodes(ATTR_LIST_INC)
    @info "AttrNodes table" total = length(nodes)
    for dir in readdir(ATTR_LIB_DIR)
        isdir(joinpath(ATTR_LIB_DIR, dir)) || continue
        tryparse(Int, dir) === nothing && continue
        path = joinpath(ATTR_LIB_DIR, dir, "AttrNodes.jl")
        open(path, "w") do io
            println(io,
                    "# Generated from deps/ClangExtra/include/clang-ex/AST/AttrList.inc by gen/attr_nodes.jl — do not edit.")
            println(io,
                    "# Entries are in AttrList.inc order; position (0-based) is the CXAttrKind value. Carrier = <name>Attr; category = the C++ base class.")
            println(io, "const ATTR_NODES = [")
            for n in nodes
                println(io, "    (name = :$(n.name), category = :$(n.category)),")
            end
            println(io, "]")
        end
        @info "wrote" path
    end
end

emit_attr_nodes()
