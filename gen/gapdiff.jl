# Diff the clang-cpp method surface (gen/gapmap.jl output) against the bindings we actually
# have, and rank what is left.
#
#     julia gen/gapmap.jl gap.json && julia gen/gapdiff.jl gap.json [--class Sema]
#
# The comparison this performs used to be done by hand at each call site, and twice reported
# a class as unwrapped when it was fully covered. Both misses had the same two causes, so
# both are handled here rather than left to the caller:
#
#   * Case. The shim lower-cases the class segment for a few value-ish types
#     (`clang_value_getBool`, `clang_sema_getTypeName`), so a case-sensitive compare against
#     `clang_Value_*` reports all 44 of `clang::Value`'s methods as missing when every one of
#     them is bound.
#   * Stamping. Whole families are emitted by X-macro (`CXVALUE_ABI_TYPES`) or from a
#     TableGen `.inc`, so the declaration never appears as text in any header we could grep.
#   * Julia-side classes. A pure aggregate (`CharSourceRange`, `FullSourceLoc`) is reproduced
#     structurally in `core/` and has no `clang_*` symbol at all, by design.
#   * Base-class coverage. `clang::Stmt::getBeginLoc` is non-virtual and 120 subclasses shadow
#     it; one wrapper on `AbstractStmt` serves every one of them. Counting per subclass
#     inflated the tail by 682 methods -- 53% of it.
#   * A different mechanism. `classof` is answered by the `resolve` table, not by 288 shims.
#
# One cause is NOT handled here and has to be checked by hand, because no mechanical rule
# separates it from a real gap: FLATTENING. Clang's small nested value types are routinely
# wrapped by hoisting their accessors onto the owner rather than giving the type a handle, so
# the nested class reports as having no bindings at all while every question it answers is
# already reachable. `clang::APValue::LValueBase` has no `clang_LValueBase_*` symbol and 15
# `clang_APValue_getLValueBase*` ones; `FunctionType::ExtInfo` has none and its bits are on
# `clang_FunctionType_getCallConv`, `_getProducesResult`, `_getNoCfCheck`; all four
# `CFGTerminator` queries are `clang_CFGBlock_getTerminator*`. Before treating any nested or
# value type in the "no bindings" list as a gap, grep the OWNER's prefix for its accessors.
#
# The first four are avoided by comparing against the *generated bindings* plus the Julia
# wrapper surface and its type hierarchy -- never against header text. The last is a
# classification (`covered_otherwise`), because those methods are real but must not be wrapped.

const ROOT = normpath(joinpath(@__DIR__, ".."))

"Signatures whose marshalling is out of scope for a thin wrapper: C++ types with no C ABI."
const BLOCKED = r"ArrayRef|MultiExpr|SmallVector|function_ref|std::function|LookupResult|
                 InitializedEntity|InitializationKind|TemplateArgumentListInfo|CachedTokens|
                 SmallBitVector|PartialDiagnostic|iterator|sema::|std::tuple|llvm::|
                 raw_ostream|Declarator|CXXScopeSpec|ParsedAttr|AttributeList|DeclSpec"x

"Surface this package deliberately does not carry."
const OUT_OF_SCOPE = r"OMP|OpenMP|ObjC"

"""
Capabilities this package provides by a different mechanism, so a per-class wrapper would
duplicate rather than extend it.

`classof`/`classofKind` are Clang's per-class RTTI predicates -- 288 of them across the AST
node classes. Downcasting here goes through `resolve`, an O(1) lookup on `getStmtClass` plus
the `castTo*` family, so wrapping them one class at a time would add 288 shims for something
already answered in constant time.

`CreateDeserialized` builds a node with storage for a deserializing `ASTReader` to fill. This
package never constructs one -- there is no PCH and no module file in an incremental
interpreter -- so every such wrapper would hand back an uninitialized node.
"""
const COVERED_OTHERWISE = r"^(classof|classofKind|CreateDeserialized)$"

"Every `clang_*` symbol bound in lib/<major>/LibClangEx.jl, lower-cased for comparison."
function bound_symbols(path)
    syms = Set{String}()
    for line in eachline(path)
        m = match(r"@ccall libclangex\.(\w+)\(", line)
        m === nothing || push!(syms, lowercase(m.captures[1]))
    end
    return syms
end

"""
    julia_methods(dir) -> Dict{String,Set{String}}

Map each carrier type name to the wrapper names defined *in Julia* for it.

Not every wrapped class crosses the C boundary. A pure aggregate — `SourceRange`,
`CharSourceRange`, `FullSourceLoc` — is reproduced structurally in `core/` and its accessors
are plain field reads, so it has no `clang_*` symbol and never will. Counting only C symbols
reports all 12 of `CharSourceRange`'s methods as missing when all 12 are implemented.
"""
function julia_methods(dir)
    out = Dict{String,Set{String}}()
    for (root, _, files) in walkdir(dir), f in files
        (endswith(f, ".jl") && !occursin(".cov", f)) || continue
        for line in eachline(joinpath(root, f))
            m = match(r"^(?:function\s+)?([a-zA-Z_]\w*)\((.*)", line)
            m === nothing && continue
            name, rest = m.captures[1], m.captures[2]
            for t in eachmatch(r"::([A-Z]\w*)", rest)
                push!(get!(out, t.captures[1], Set{String}()), name)
            end
        end
    end
    return out
end

"""
    type_hierarchy(dir) -> (parent, carrier)

Read the Julia mirror of Clang's inheritance: `parent` maps each abstract type to its
supertype, `carrier` maps each concrete carrier to the abstract type it is declared under.
"""
function type_hierarchy(dir)
    parent, carrier = Dict{String,String}(), Dict{String,String}()
    for (root, _, files) in walkdir(dir), f in files
        (endswith(f, ".jl") && !occursin(".cov", f)) || continue
        for line in eachline(joinpath(root, f))
            s = strip(line)
            m = match(r"^abstract type (\w+)\s*<:\s*(\w+)", s)
            m === nothing || (parent[m.captures[1]] = m.captures[2])
            m = match(r"^struct (\w+)\s*<:\s*(\w+)", s)
            m === nothing || (carrier[m.captures[1]] = m.captures[2])
        end
    end
    return parent, carrier
end

"Every abstract type `class`'s carrier is a subtype of, itself included."
function supertypes_of(class, parent, carrier)
    out = String[]
    t = get(carrier, class, "Abstract" * class)
    while true
        push!(out, t)
        haskey(parent, t) || break
        t = parent[t]
    end
    return out
end

"""
    is_wrapped(syms, jl, hier, class, method) -> Bool

Whether `method` of `class` is reachable from Julia: bound in C under any spelling,
implemented in Julia on the carrier, or — the case that dominates the AST node classes —
wrapped on a BASE class the carrier inherits from.

`clang::Stmt::getBeginLoc` is non-virtual and every subclass shadows it, so the gap map lists
`IfStmt::getBeginLoc` separately from 119 siblings. One `getBeginLoc(x::AbstractStmt)` wrapper
over `clang_Stmt_getBeginLoc` serves all of them, and a per-subclass wrapper would be a
duplicate, not coverage. The same holds for `children` and for `classof`, whose job this
package does with the O(1) `resolve`/`getStmtClass` table instead.
"""
function is_wrapped(syms, jl, hier, class, method)
    lowercase("clang_$(class)_$(method)") in syms && return true
    method in get(jl, class, Set{String}()) && return true
    parent, carrier = hier
    for t in supertypes_of(class, parent, carrier)
        method in get(jl, t, Set{String}()) && return true
        # the C binding is spelled with the clang class name, i.e. the carrier's, so strip
        # the Abstract prefix the Julia mirror adds
        base = startswith(t, "Abstract") ? t[9:end] : t
        isempty(base) || lowercase("clang_$(base)_$(method)") in syms && return true
    end
    return false
end

"Whether the class is wrapped at all — distinguishes a tail from an untouched subsystem."
function has_any(syms, jl, class)
    pre = lowercase("clang_$(class)_")
    haskey(jl, class) && return true
    return any(s -> startswith(s, pre), syms)
end

function classify(name, ret, args)
    sig = join(args, " ") * " " * ret
    startswith(name, "ActOn") && return :parser_action
    occursin(COVERED_OTHERWISE, name) && return :covered_otherwise
    occursin(OUT_OF_SCOPE, sig * name) && return :out_of_scope
    occursin("CodeComplete", name) && return :out_of_scope
    occursin(BLOCKED, sig) && return :blocked
    return :viable
end

"""
    each_method(f, gapfile)

Call `f(class, method, ret, args)` for every method in a `gen/gapmap.jl` dump.

Walks the pretty-printed JSON as lines with a depth counter rather than matching nested
braces with a regex, which exhausts PCRE's JIT stack on a file this size.
"""
function each_method(f, gapfile)
    depth, class, method, ret, args, inargs = 0, "", "", "", String[], false
    for line in eachline(gapfile)
        s = strip(line)
        if inargs
            if startswith(s, "]")
                inargs = false
            else
                a = match(r"\"(.*)\"", s)
                a === nothing || push!(args, a.captures[1])
            end
            continue
        end
        key = (k = match(r"^\"([^\"]+)\"\s*:", s)) === nothing ? nothing : k.captures[1]
        if key !== nothing && endswith(s, "{")
            depth == 2 && (class = split(key, "::")[end])
            depth == 3 && (method=key; ret=""; empty!(args))
        elseif key == "ret"
            r = match(r":\s*\"(.*)\",?$", s)
            r === nothing || (ret = r.captures[1])
        elseif key == "args"
            inargs = !endswith(s, "]")   # `"args": []` closes on the same line
        end
        depth += count(==('{'), s) - count(==('}'), s)
        # a method object just closed: depth is back to the class level
        if depth == 3 && !isempty(method) && (startswith(s, "}") || startswith(s, "},"))
            f(class, method, ret, args)
            method = ""
        end
    end
end

function main(gapfile; only=nothing)
    isfile(gapfile) || (println("no such gap file: $gapfile"); return 2)
    syms = bound_symbols(joinpath(ROOT, "lib", "18", "LibClangEx.jl"))
    isempty(syms) && (println("no bindings parsed — is lib/18/LibClangEx.jl present?"); return 2)
    jl = julia_methods(joinpath(ROOT, "src", "clang"))
    hier = type_hierarchy(joinpath(ROOT, "src", "clang"))

    counts = Dict{Symbol,Int}()
    viable = Dict{String,Vector{String}}()
    untouched = Set{String}()
    wrapped = 0

    each_method(gapfile) do class, name, ret, args
        only === nothing || class == only || return
        if is_wrapped(syms, jl, hier, class, name)
            wrapped += 1
            return
        end
        k = classify(name, ret, args)
        counts[k] = get(counts, k, 0) + 1
        k === :viable || return
        push!(get!(viable, class, String[]), name)
        has_any(syms, jl, class) || push!(untouched, class)
    end

    total_viable = sum(length, values(viable); init=0)
    println("bound symbols: $(length(syms))    already wrapped: $wrapped")
    for k in (:viable, :blocked, :parser_action, :out_of_scope, :covered_otherwise)
        println("  $(rpad(k, 14)) $(get(counts, k, 0))")
    end
    println("\nviable: $total_viable across $(length(viable)) classes " *
            "($(length(untouched)) of them with no binding at all)")
    for c in sort!(collect(keys(viable)); by=k -> -length(viable[k]))[1:min(25, length(viable))]
        tag = c in untouched ? "  [no bindings — a subsystem, not a tail]" : ""
        println("  $(lpad(length(viable[c]), 4))  $c$tag")
        only === nothing || println("        " * join(sort(viable[c]), ", "))
    end
    return 0
end

if abspath(PROGRAM_FILE) == (@__FILE__)
    i = findfirst(==("--class"), ARGS)
    exit(main(ARGS[1]; only=i === nothing ? nothing : ARGS[i + 1]))
end
