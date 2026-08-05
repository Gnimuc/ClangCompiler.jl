# Parse the vendored AttrList.inc and emit EXPLICIT Julia source for the Attr
# subsystem — no runtime `@eval`, no `ATTR_NODES` mirror table. Regenerate on an
# LLVM bump (run standalone or via gen/generator.jl); the emitted files are
# committed into src/ (listed in .JuliaFormatter.toml ignore) and never hand-edited.
#
# Emits three files into src/:
#   src/clang/core/AST/AttrCarriers.jl — `struct <Name>Attr <: Abstract<Category>;
#                     ptr::CX<Name>Attr end`, one per attribute.
#   src/clang/api/AST/AttrWrappers.jl  — per attribute: the `is<Name>Attr` predicate
#                     and the `<Name>Attr` constructor-shaped downcast.
#   src/clang/AttrKindMap.jl           — `const ATTR_KIND_TO_TYPE = Dict{CXAttrKind,Any}(...)`,
#                     the CXAttrKind -> carrier map that drives `resolve`.
#
# `category` is the attribute's C++ base class in clang/AST/Attr.h, derived from
# which X-macro spells the entry (DECL_OR_TYPE_ATTR entries carry :InheritableAttr
# — clang defines no DeclOrTypeAttr class). Every attribute class is concrete.

const ATTR_LIST_INC = normpath(joinpath(@__DIR__, "..", "deps", "ClangExtra", "include",
                                        "clang-ex", "AST", "AttrList.inc"))
const ATTR_SRC = normpath(joinpath(@__DIR__, "..", "src"))

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

# carrier struct name and its category abstract supertype (mirrors clang's class
# names): `<Name>Attr`, and `AbstractAttr` for the root or `Abstract<Category>`.
attr_carrier(name) = string(name, "Attr")
attr_category_abstract(cat) = cat === :Attr ? "AbstractAttr" : "Abstract" * String(cat)

const GEN_NOTE = "# Generated from deps/ClangExtra/include/clang-ex/AST/AttrList.inc by gen/attr_nodes.jl — do not edit."

# Per-attribute abstract types (front-loaded via abstract.jl): Abstract<Name>Attr
# subtypes the attribute's C++ category, so every concrete carrier has its own
# AbstractFoo for uniform loose-typing.
function emit_abstracts(io, nodes)
    println(io, GEN_NOTE)
    println(io, "# Abstract<Name>Attr <: <category>, one per concrete clang attribute.")
    for n in nodes
        println(io, "abstract type Abstract$(attr_carrier(n.name)) <: $(attr_category_abstract(n.category)) end")
    end
end

function emit_carriers(io, nodes)
    println(io, GEN_NOTE)
    println(io, "# One carrier per concrete clang attribute, subtyping its own Abstract<Name>Attr")
    println(io, "# (defined in AttrAbstracts.jl) which subtypes the attribute's category.")
    println(io, "# Marshalling is the carrier's own entry in converts.jl, plus the `CXAttr`")
    println(io, "# entry keyed on `AbstractAttr` that carries it to every base-class binding.")
    for n in nodes
        sym = attr_carrier(n.name)
        println(io, """
        \"\"\"
            struct $sym <: Abstract$sym
        Hold a pointer to a `clang::$sym` object.
        \"\"\"
        struct $sym <: Abstract$sym
            ptr::CX$sym
        end
        """)
    end
end

function emit_wrappers(io, nodes)
    println(io, GEN_NOTE)
    println(io, "# Per-attribute checked cast: the `<Name>Attr` constructor is C++'s `cast<T>` and")
    println(io, "# the `is<Name>Attr` predicate beside it is `isa<T>`. Clang's own `classof` decides,")
    println(io, "# so an attribute can never become a carrier that names another class.")
    for n in nodes
        sym = attr_carrier(n.name)
        println(io, """
        function is$sym(x::AbstractAttr)
            @check_ptrs x
            return clang_Attr_is$sym(x)
        end

        function $sym(x::AbstractAttr)
            @check_ptrs x
            p = clang_Attr_castTo$sym(x)
            p == C_NULL && _cast_failed($sym, x)
            return $sym(p)
        end
        """)
    end
end

function emit_kindmap(io, nodes)
    println(io, GEN_NOTE)
    println(io, "# CXAttrKind -> concrete carrier, so `resolve(::AbstractAttr)` is one getKind")
    println(io, "# call plus one lookup. Kinds and carriers both derive from AttrList.inc.")
    println(io, "const ATTR_KIND_TO_TYPE = Dict{CXAttrKind,Any}(")
    for n in nodes
        println(io, "    LibClangEx.CXAttrKind_$(n.name) => $(attr_carrier(n.name)),")
    end
    println(io, ")")
end

function emit_attr_sources()
    nodes = parse_attr_nodes(ATTR_LIST_INC)
    @info "Attr sources" total = length(nodes)
    open(io -> emit_abstracts(io, nodes), joinpath(ATTR_SRC, "clang", "core", "AST", "AttrAbstracts.jl"), "w")
    open(io -> emit_carriers(io, nodes), joinpath(ATTR_SRC, "clang", "core", "AST", "AttrCarriers.jl"), "w")
    open(io -> emit_wrappers(io, nodes), joinpath(ATTR_SRC, "clang", "api", "AST", "AttrWrappers.jl"), "w")
    open(io -> emit_kindmap(io, nodes), joinpath(ATTR_SRC, "clang", "AttrKindMap.jl"), "w")
    @info "wrote Attr sources into src/"
end

emit_attr_sources()
