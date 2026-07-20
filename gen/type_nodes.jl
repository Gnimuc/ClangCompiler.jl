# Parse the vendored TypeNodes.inc and emit the EXPLICIT CXTypeClass -> carrier
# resolve map — no runtime loop, no `TYPE_NODES` mirror table. Type carriers are
# hand-written (a curated subset), so the map only covers classes whose
# `<name>Type` carrier exists; the wrapped set is read from the hand-written
# core/AST files, the same way the old runtime `isdefined` guard did. Regenerate
# on an LLVM bump.
#
# Emits src/TypeClassMap.jl defining `TYPE_CLASS_TO_TYPE`. `name` is the
# bare TypeNodes spelling (CXTypeClass_<name>, carrier <name>Type).

const TYPE_NODES_INC = normpath(joinpath(@__DIR__, "..", "deps", "ClangExtra", "include",
                                         "clang-ex", "AST", "TypeNodes.inc"))
const TYPE_SRC = normpath(joinpath(@__DIR__, "..", "src"))
const TYPE_SRC_AST = normpath(joinpath(@__DIR__, "..", "src", "clang", "core", "AST"))

# Concrete Type class names (bare spelling). ABSTRACT_TYPE excluded; the concrete
# TYPE / NON_CANONICAL_TYPE / DEPENDENT_TYPE / NON_CANONICAL_UNLESS_DEPENDENT_TYPE
# variants are kept; LAST_TYPE / LEAF_TYPE are one-arg and never match.
function parse_type_names(inc_path)
    names = Symbol[]
    concrete_re = r"^([A-Z][A-Z0-9_]*)\((\w+),\s*(\w+)\)$"
    for line in eachline(inc_path)
        line = strip(line)
        startswith(line, "ABSTRACT_TYPE") && continue
        m = match(concrete_re, line)
        m === nothing && continue
        push!(names, Symbol(m.captures[2]))
    end
    return names
end

# carrier struct names defined across the hand-written core/AST/*.jl files
function wrapped_carriers()
    s = Set{String}()
    for f in readdir(TYPE_SRC_AST; join=true)
        endswith(f, ".jl") || continue
        for line in eachline(f)
            m = match(r"^struct (\w+)", line)
            m === nothing || push!(s, m.captures[1])
        end
    end
    return s
end

function emit_type_classmap()
    names = parse_type_names(TYPE_NODES_INC)
    wrapped = wrapped_carriers()
    n = 0
    open(joinpath(TYPE_SRC, "TypeClassMap.jl"), "w") do io
        println(io,
                "# Generated from deps/ClangExtra/include/clang-ex/AST/TypeNodes.inc by gen/type_nodes.jl — do not edit.")
        println(io, "# CXTypeClass -> concrete carrier; classes without a wrapped `<name>Type`")
        println(io, "# carrier are absent, so resolve falls back to UnexposedType.")
        println(io, "const TYPE_CLASS_TO_TYPE = Dict{CXTypeClass,Any}(")
        for name in names
            carrier = string(name, "Type")
            carrier in wrapped || continue
            println(io, "    LibClangEx.CXTypeClass_$name => $carrier,")
            n += 1
        end
        println(io, ")")
    end
    @info "wrote TypeClassMap into src/" entries = n
end

emit_type_classmap()
