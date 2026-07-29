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
#
# Both are avoided by comparing against the *generated bindings* — the only artifact that
# lists every symbol however it was produced — never against header text.

const ROOT = normpath(joinpath(@__DIR__, ".."))

"Signatures whose marshalling is out of scope for a thin wrapper: C++ types with no C ABI."
const BLOCKED = r"ArrayRef|MultiExpr|SmallVector|function_ref|std::function|LookupResult|
                 InitializedEntity|InitializationKind|TemplateArgumentListInfo|CachedTokens|
                 SmallBitVector|PartialDiagnostic|iterator|sema::|std::tuple|llvm::|
                 raw_ostream|Declarator|CXXScopeSpec|ParsedAttr|AttributeList|DeclSpec"x

"Surface this package deliberately does not carry."
const OUT_OF_SCOPE = r"OMP|OpenMP|ObjC"

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

"Whether `method` of `class` is bound in C under any spelling, or implemented in Julia."
function is_wrapped(syms, jl, class, method)
    lowercase("clang_$(class)_$(method)") in syms && return true
    return method in get(jl, class, Set{String}())
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

    counts = Dict{Symbol,Int}()
    viable = Dict{String,Vector{String}}()
    untouched = Set{String}()
    wrapped = 0

    each_method(gapfile) do class, name, ret, args
        only === nothing || class == only || return
        if is_wrapped(syms, jl, class, name)
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
    for k in (:viable, :blocked, :parser_action, :out_of_scope)
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
