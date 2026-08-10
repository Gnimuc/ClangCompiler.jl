# Parse the vendored DeclNodes.inc and emit the EXPLICIT CXDeclKind -> carrier
# resolve map — no runtime loop, no `DECL_NODES` mirror table. Decl carriers are
# hand-written (a curated subset), so the map only covers kinds whose `<name>Decl`
# carrier exists; the wrapped set is read from the hand-written core/AST files,
# the same way the old runtime `isdefined` guard did. Regenerate on an LLVM bump.
#
# Emits src/clang/DeclKindMap.jl defining `DECL_KIND_TO_TYPE`, and
# src/clang/api/AST/DeclWrappers.jl carrying the checked `cast`/`isa` pair per class.

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

# Every Decl class name the shim stamps a cast for — abstract bases included, since
# CXDeclBase.cpp expands ABSTRACT_DECL to its inner macro. `ABSTRACT_DECL(NAMED(Named, Decl))`
# is one line with the payload nested, so it needs its own pattern.
function parse_all_decl_names(inc_path)
    names = Symbol[]
    concrete_re = r"^([A-Z][A-Z0-9_]*)\((\w+),\s*(\w+)\)$"
    abstract_re = r"^ABSTRACT_DECL\([A-Z][A-Z0-9_]*\((\w+),\s*(\w+)\)\)$"
    for line in eachline(inc_path)
        line = strip(line)
        m = match(abstract_re, line)
        if m !== nothing
            push!(names, Symbol(m.captures[1]))
            continue
        end
        m = match(concrete_re, line)
        m === nothing && continue
        m.captures[1] in ("DECL_RANGE", "LAST_DECL_RANGE", "DECL_CONTEXT",
                          "DECL_CONTEXT_BASE") && continue
        push!(names, Symbol(m.captures[2]))
    end
    return unique(names)
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
            m === nothing || (h[name] = m.captures[1]; name = "")
        end
    end
    return h
end

function emit_decl_kindmap()
    names = parse_decl_names(DECL_NODES_INC)
    wrapped = wrapped_carriers()
    n = 0
    open(joinpath(DECL_SRC, "clang", "DeclKindMap.jl"), "w") do io
        println(io,
                "# Generated from deps/ClangExtra/include/clang-ex/AST/DeclNodes.inc by gen/decl_nodes.jl — do not edit.")
        println(io, "# CXDeclKind -> concrete carrier; kinds without a wrapped `<name>Decl` carrier")
        println(io, "# (the six OpenMP declaration kinds) are absent, so")
        println(io, "# resolve falls back to the base Decl.")
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

# ---------------------------------------------------------------------------
# The checked Decl casts.
#
# CXDeclBase.cpp stamps `clang_Decl_castTo<Name>Decl` (dyn_cast_or_null) and
# `clang_Decl_is<Name>Decl` (isa_and_nonnull) for every class in DeclNodes.inc, abstract bases
# included. This turns each pair into the Julia spelling: a constructor that is C++'s
# `cast<T>` and a predicate that is `isa<T>`, for the classes this package carries.

function emit_decl_wrappers()
    names = parse_all_decl_names(DECL_NODES_INC)
    wrapped = wrapped_carriers()
    n = 0
    open(joinpath(DECL_SRC, "clang", "api", "AST", "DeclWrappers.jl"), "w") do io
        println(io,
                "# Generated from deps/ClangExtra/include/clang-ex/AST/DeclNodes.inc by gen/decl_nodes.jl — do not edit.")
        println(io, "# Per-class checked cast: the `<Name>Decl` constructor is C++'s `cast<T>` and the")
        println(io, "# `is<Name>Decl` predicate beside it is `isa<T>`. Both come from clang's own")
        println(io, "# `classof`, so a declaration can never become a carrier that names another class.")
        println(io, "#")
        println(io, "# The shim types each cast at that class's own handle, so pairing a cast with the")
        println(io, "# wrong carrier is a Julia type error here rather than a bad pointer reaching clang.")
        handles = carrier_handles(DECL_SRC_AST)
        for name in names
            carrier = string(name, "Decl")
            carrier in wrapped || continue
            # `CX<Carrier>(p)` is a no-op the compiler elides when the carrier declares its own
            # handle; it is the widening to the shared family handle where it does not.
            h = get(handles, carrier, "CX" * carrier)
            wrap = h == "CX" * carrier ? "p" : "$h(p)"
            println(io, """

            function is$carrier(x::AbstractDecl)
                @check_ptrs x
                return clang_Decl_is$carrier(x)
            end

            function $carrier(x::AbstractDecl)
                @check_ptrs x
                p = clang_Decl_castTo$carrier(x)
                p == C_NULL && _cast_failed($carrier, x)
                return $carrier($wrap)
            end""")
            n += 1
        end
    end
    @info "wrote DeclWrappers into src/" casts = n skipped = length(names) - n
end

emit_decl_wrappers()

# ---------------------------------------------------------------------------
# The DeclContext union.
#
# A clang decl that is also a DeclContext holds the two base subobjects at
# different addresses — a NamespaceDecl's DeclContext* sits 48 bytes past its
# Decl*, a TagDecl's 64, a TranslationUnitDecl's 40 — so the two hierarchies are
# disjoint here and crossing them means calling the pivot. Julia's abstract types
# are single-inheritance, so no carrier can subtype both and the relation cannot
# be expressed directly.
#
# What CAN be expressed is the SET: DeclNodes.inc marks each such class
# DECL_CONTEXT, and a Union over those admits exactly them. Typing a parameter at
# that union lets a decl be passed where a context is wanted; the marshalling
# entry emitted beside it calls clang_Decl_castToDeclContext — a switch over the
# decl kind, which is what recovers the per-class offset — as the argument is
# converted. A decl that is not a context fails at dispatch instead of reaching
# the pivot's assert.
#
# Emits src/clang/core/AST/DeclContextUnion.jl.

const DECL_API = normpath(joinpath(@__DIR__, "..", "src", "clang", "api"))
const DECL_CORE = normpath(joinpath(@__DIR__, "..", "src", "clang", "core"))
const DECL_CLANG = normpath(joinpath(@__DIR__, "..", "src", "clang"))

"Bare names marked `DECL_CONTEXT` — the decls that are also DeclContexts."
function parse_decl_contexts(inc_path)
    names = String[]
    for line in eachline(inc_path)
        m = match(r"^DECL_CONTEXT\((\w+)\)$", strip(line))
        m === nothing || push!(names, m.captures[1])
    end
    return unique(names)
end

"Names matching `regex`'s first capture across every .jl file under `dir`."
function scan_names(dir, regex)
    s = Set{String}()
    for (root, _, files) in walkdir(dir), f in files
        endswith(f, ".jl") || continue
        for line in eachline(joinpath(root, f))
            m = match(regex, line)
            m === nothing || push!(s, m.captures[1])
        end
    end
    return s
end

function emit_declcontext_union()
    contexts = parse_decl_contexts(DECL_NODES_INC)
    absts = scan_names(DECL_CORE, r"^abstract type (\w+)")
    have = [n for n in contexts if "Abstract$(n)Decl" in absts]
    indent = " " ^ length("const AbstractDeclContextDecl = Union{")

    open(joinpath(DECL_CORE, "AST", "DeclContextUnion.jl"), "w") do io
        println(io,
                "# Generated from deps/ClangExtra/include/clang-ex/AST/DeclNodes.inc by gen/decl_nodes.jl — do not edit.")
        println(io, """

        \"\"\"
            const AbstractDeclContextDecl
        The decls clang marks `DECL_CONTEXT` — those that are also `DeclContext`s, and so may be
        passed wherever a [`DeclContext`](@ref) is wanted. Dispatch admits exactly these, which is
        what stops a decl that is not a context from ever reaching `castToDeclContext`'s assert.
        \"\"\"""")
        println(io, "const AbstractDeclContextDecl = Union{",
                join(("Abstract$(n)Decl" for n in have), ",\n" * indent), "}\n")
        println(io, """
        # `DeclContext` is the one base in this package that is not at offset zero, so unlike
        # every entry in converts.jl this one cannot reinterpret: it calls the pivot, and
        # the per-class adjustment (+48 from a NamespaceDecl, +64 from a TagDecl) happens as the
        # argument is marshalled. A decl reaching a `CXDeclContext` parameter therefore arrives
        # as a `DeclContext *` however it got there, and no call site can forget the cast.
        #
        # No check here: the Union is exactly the classes clang marks `DECL_CONTEXT`, so dispatch
        # has already established what `castToDeclContext`'s assert would test, and the wrapper's
        # own `@check_ptrs` runs before the ccall marshals its arguments.
        Base.unsafe_convert(::Type{CXDeclContext}, x::AbstractDeclContextDecl) = clang_Decl_castToDeclContext(x)
        Base.cconvert(::Type{CXDeclContext}, x::AbstractDeclContextDecl) = x

        \"\"\"
            const AnyDeclContext
        What a `DeclContext` parameter accepts: a context, or a declaration that is also one.
        This is the signature C++ writes as `DeclContext *`, where a `NamespaceDecl *` converts
        implicitly — here the same call marshals through the pivot above, so `RecordDecl(ctx, ns,
        ...)` reaches clang with the adjusted pointer and needs no `castToDeclContext` spelled at
        the call site.

        Two kinds of signature keep the narrower `DeclContext`. A method clang declares on both
        `Decl` and `DeclContext` is ambiguous over this union — `getDeclKindName` is the one such
        pair, and the same call needs qualifying in C++ too. So is a wrapper that reads `dc.ptr`
        rather than passing the carrier, since that spelling takes the raw pointer and bypasses
        the pivot.
        \"\"\"
        const AnyDeclContext = Union{AbstractDeclContext,AbstractDeclContextDecl}""")
    end

    @info "wrote DeclContextUnion into src/" union_members = length(have) not_wrapped = setdiff(contexts, have)
end

emit_declcontext_union()
