# Parse the vendored TypeNodes.inc and emit the EXPLICIT CXTypeClass -> carrier
# resolve map — no runtime loop, no `TYPE_NODES` mirror table. Type carriers are
# hand-written (a curated subset), so the map only covers classes whose
# `<name>Type` carrier exists; the wrapped set is read from the hand-written
# core/AST files, the same way the old runtime `isdefined` guard did. Regenerate
# on an LLVM bump.
#
# Emits src/TypeClassMap.jl defining `TYPE_CLASS_TO_TYPE`, and
# src/clang/api/AST/TypeWrappers.jl carrying the checked cast per class. `name`
# is the bare TypeNodes spelling (CXTypeClass_<name>, carrier <name>Type).

const TYPE_NODES_INC = normpath(joinpath(@__DIR__, "..", "deps", "ClangExtra", "include", "clang-ex", "AST",
                                         "TypeNodes.inc"))
const TYPE_SRC = normpath(joinpath(@__DIR__, "..", "src"))
const TYPE_SRC_AST = normpath(joinpath(@__DIR__, "..", "src", "clang", "core", "AST"))

# Every Type class name the shim stamps a cast for. CXType.cpp leaves ABSTRACT_TYPE at its
# TypeNodes.inc default, which expands to TYPE, so the abstract bases are stamped too.
function parse_all_type_names(inc_path)
    names = Symbol[]
    concrete_re = r"^(?:ABSTRACT_TYPE|[A-Z][A-Z0-9_]*)\((\w+),\s*(\w+)\)$"
    for line in eachline(inc_path)
        m = match(concrete_re, strip(line))
        m === nothing || push!(names, Symbol(m.captures[1]))
    end
    return unique(names)
end

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

# Each wrapped carrier's `ptr` field type. Almost always `CX<Carrier>`, but a class whose
# family shares one handle stores that instead -- `BuiltinType` holds a `CXType_`, because the
# per-kind singletons beside it (`IntTy`, `BoolTy`, ...) are kinds of one class and have no
# handle of their own. The cast has to fill the field the carrier actually declares.
function carrier_handles(dir)
    h = Dict{String,String}()
    for f in readdir(dir; join=true)
        endswith(f, ".jl") || continue
        name = ""
        for line in eachline(f)
            m = match(r"^struct (\w+)", line)
            if m !== nothing
                name = m.captures[1]
                continue
            end
            isempty(name) && continue
            m = match(r"^\s+ptr::(\w+)", line)
            m === nothing || (h[name]=m.captures[1]; name="")
        end
    end
    return h
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

# ---------------------------------------------------------------------------
# The checked Type casts.
#
# CXType.cpp stamps `clang_Type_castTo<Name>Type` (dyn_cast_or_null) for every class in
# TypeNodes.inc. There is deliberately no `is<Name>Type` emitted beside them: clang already
# declares methods by those names and they ask a *different* question — `Type::isRecordType()`
# looks through sugar, so it is true of a typedef for a struct that `dyn_cast<RecordType>`
# rejects. Those semantic predicates are wrapped under their own names in api/AST/Type.jl;
# the test that matches a cast is `resolve(t) isa Abstract<Name>Type`.

function emit_type_wrappers()
    names = parse_all_type_names(TYPE_NODES_INC)
    wrapped = wrapped_carriers()
    n = 0
    open(joinpath(TYPE_SRC, "clang", "api", "AST", "TypeWrappers.jl"), "w") do io
        println(io,
                "# Generated from deps/ClangExtra/include/clang-ex/AST/TypeNodes.inc by gen/type_nodes.jl — do not edit.")
        println(io, "# Per-class checked cast: the `<Name>Type` constructor is C++'s `cast<T>`, resting on")
        println(io, "# clang's own `classof`, so a type node can never become a carrier naming another class.")
        println(io, "#")
        println(io, "# These are exact-class casts. A `TypedefType` that sugars a struct is not a")
        println(io, "# `RecordType` and `RecordType(t)` raises on one, even though `isRecordType(t)` —")
        println(io, "# clang's own predicate, which desugars — is true. Canonicalise first, or use one of")
        println(io, "# the `getAs*` accessors, when the question is what a type denotes rather than which")
        println(io, "# node it is. To test without raising: `resolve(t) isa Abstract<Name>Type`.")
        handles = carrier_handles(TYPE_SRC_AST)
        for name in names
            carrier = string(name, "Type")
            carrier in wrapped || continue
            # `CX<Carrier>(p)` is a no-op the compiler elides when the carrier declares its own
            # handle; it is the widening to the shared family handle where it does not.
            h = get(handles, carrier, "CX" * carrier)
            wrap = h == "CX" * carrier ? "p" : "$h(p)"
            println(io, """

            function $carrier(x::AbstractType)
                @check_ptrs x
                p = clang_Type_castTo$carrier(x)
                p == C_NULL && _cast_failed($carrier, x)
                return $carrier($wrap)
            end""")
            n += 1
        end
    end
    @info "wrote TypeWrappers into src/" casts = n skipped = length(names) - n
end

emit_type_wrappers()
