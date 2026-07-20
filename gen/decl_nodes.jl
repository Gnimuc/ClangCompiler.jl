# Parse the vendored DeclNodes.inc and emit the EXPLICIT CXDeclKind -> carrier
# resolve map — no runtime loop, no `DECL_NODES` mirror table. Decl carriers are
# hand-written (a curated subset), so the map only covers kinds whose `<name>Decl`
# carrier exists; the wrapped set is read from the hand-written core/AST files,
# the same way the old runtime `isdefined` guard did. Regenerate on an LLVM bump.
#
# Emits src/clang/DeclKindMap.jl defining `DECL_KIND_TO_TYPE`.

const DECL_NODES_INC = normpath(joinpath(@__DIR__, "..", "deps", "ClangExtra", "include",
                                         "clang-ex", "AST", "DeclNodes.inc"))
const DECL_SRC = normpath(joinpath(@__DIR__, "..", "src"))
const DECL_SRC_AST = normpath(joinpath(@__DIR__, "..", "src", "clang", "core", "AST"))

# Concrete Decl class names (bare spelling; CXDeclKind_<name>, carrier <name>Decl).
function parse_decl_names(inc_path)
    names = Symbol[]
    concrete_re = r"^([A-Z][A-Z0-9_]*)\((\w+),\s*(\w+)\)$"
    for line in eachline(inc_path)
        line = strip(line)
        startswith(line, "ABSTRACT_DECL") && continue
        m = match(concrete_re, line)
        m === nothing && continue
        m.captures[1] in ("DECL_RANGE", "LAST_DECL_RANGE") && continue
        push!(names, Symbol(m.captures[2]))
    end
    return names
end

# carrier struct names defined across the hand-written core/AST/*.jl files
function wrapped_carriers()
    s = Set{String}()
    for f in readdir(DECL_SRC_AST; join=true)
        endswith(f, ".jl") || continue
        for line in eachline(f)
            m = match(r"^struct (\w+)", line)
            m === nothing || push!(s, m.captures[1])
        end
    end
    return s
end

function emit_decl_kindmap()
    names = parse_decl_names(DECL_NODES_INC)
    wrapped = wrapped_carriers()
    n = 0
    open(joinpath(DECL_SRC, "clang", "DeclKindMap.jl"), "w") do io
        println(io,
                "# Generated from deps/ClangExtra/include/clang-ex/AST/DeclNodes.inc by gen/decl_nodes.jl — do not edit.")
        println(io, "# CXDeclKind -> concrete carrier; kinds without a wrapped `<name>Decl` carrier")
        println(io, "# (many ObjC/OpenMP decls) are absent, so resolve falls back to the base Decl.")
        println(io, "const DECL_KIND_TO_TYPE = Dict{CXDeclKind,Any}(")
        for name in names
            carrier = string(name, "Decl")
            carrier in wrapped || continue
            println(io, "    LibClangEx.CXDeclKind_$name => $carrier,")
            n += 1
        end
        println(io, ")")
    end
    @info "wrote DeclKindMap into src/" entries = n
end

emit_decl_kindmap()
