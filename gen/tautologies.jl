# Report `@test x isa T` assertions that cannot fail.
#
# `gen/deadtests.jl` finds assertions that never run. This finds the ones that run and prove
# nothing: an `isa` whose truth is fixed by the wrapper's own return expression rather than
# by anything Clang decided.
#
#     @test CC.getNumBases(rd) isa Integer      # wrapper returns Int(...) -- always true
#     @test CC.isAbstract(rd) isa Bool          # ccall is declared ::Bool -- always true
#     @test CC.getParent(dc) isa DeclContext    # wrapper is `return DeclContext(...)` -- always
#
# None of these can distinguish a correct shim from one handing back a wrong pointer, a
# stale value, or another argument's payload. They restate the source, not the behaviour.
#
# The check is deliberately one-sided: a name is reported only when EVERY method of it
# provably returns a subtype of the asserted type, so dispatch that could widen the result
# is left alone. That keeps false positives near zero at the cost of missing some.
#
#     julia gen/tautologies.jl
#
# Exit status is 1 when anything is reported.

const ROOT = normpath(joinpath(@__DIR__, ".."))

"Marks an assertion whose value is genuinely not assertable; see the note in CLAUDE.md."
const MARKER = "# shape-only"
const API = joinpath(ROOT, "src", "clang")
const TESTS = joinpath(ROOT, "test")

"A ccall's declared return type, e.g. `clang_Foo_bar` => `:Cuint`."
function ccall_returns(binding_file)
    out = Dict{String,Symbol}()
    for line in eachline(binding_file)
        m = match(r"@ccall libclangex\.(\w+)\(.*\)::(\w+)$", strip(line))
        m === nothing || (out[m.captures[1]] = Symbol(m.captures[2]))
    end
    return out
end

# The concrete Julia types these C return types always produce.
const SCALAR = Dict(:Cuint => :Integer, :Cint => :Integer, :Csize_t => :Integer,
                    :Clong => :Integer, :Culong => :Integer, :Cshort => :Integer,
                    :Cushort => :Integer, :UInt32 => :Integer, :Int32 => :Integer,
                    :Int64 => :Integer, :UInt64 => :Integer, :Bool => :Bool,
                    :Cdouble => :AbstractFloat, :Cfloat => :AbstractFloat)

"""
    wrapper_returns(dir) -> Dict{String,Set{Symbol}}

Map each wrapper name to the set of result shapes its methods provably produce. A name maps
to `:unknown` the moment one of its methods returns something this cannot pin down, which is
what makes the caller's all-methods-agree test sound.
"""
function wrapper_returns(dir, ccalls)
    out = Dict{String,Set{Symbol}}()
    for (root, _, files) in walkdir(dir), f in files
        endswith(f, ".jl") || continue
        occursin(".cov", f) && continue
        name = ""
        for line in eachline(joinpath(root, f))
            m = match(r"^function (\w+)\(", line)
            if m !== nothing
                name = m.captures[1]
                # a declared return type wins outright: `function f(...)::Int`
                rt = match(r"^function \w+\(.*\)::(\w+)$", strip(line))
                rt === nothing || push!(get!(out, name, Set{Symbol}()), Symbol(rt.captures[1]))
                continue
            end
            isempty(name) && continue
            s = strip(line)
            startswith(s, "return ") || continue
            body = strip(s[8:end])
            shape = if (c = match(r"^(?:Int|UInt)\d*\((\w+)\(", body)) !== nothing
                :Integer
            elseif (c = match(r"^(get_string|unsafe_string)\(", body)) !== nothing
                :String
            elseif (c = match(r"^([A-Z]\w*)\(", body)) !== nothing
                Symbol(c.captures[1])            # `return Carrier(...)`
            elseif (c = match(r"^(clang_\w+)\(", body)) !== nothing
                get(SCALAR, get(ccalls, c.captures[1], :_), :unknown)
            else
                :unknown
            end
            push!(get!(out, name, Set{Symbol}()), shape)
            name = ""
        end
    end
    return out
end

"Whether a result of shape `shape` is always an instance of `asserted`."
function always_isa(shape, asserted)
    shape === :unknown && return false
    shape === asserted && return true
    if asserted === :Integer
        return shape === :Integer
    elseif asserted === :Bool
        return shape === :Bool
    elseif asserted in (:Real, :Number)
        return shape in (:Integer, :Bool, :AbstractFloat)
    elseif asserted === :AbstractString
        return shape === :String
    end
    return false
end

function main()
    ccalls = ccall_returns(joinpath(ROOT, "lib", "18", "LibClangEx.jl"))
    rets = wrapper_returns(API, ccalls)
    isempty(ccalls) && (println("no ccalls parsed — is lib/18/LibClangEx.jl present?"); return 2)

    hits = Tuple{String,Int,String,String}[]
    for (root, _, files) in walkdir(TESTS), f in files
        endswith(f, ".jl") || continue
        occursin(".cov", f) && continue
        path = joinpath(root, f)
        for (n, line) in enumerate(eachline(path))
            m = match(r"@test\s+(?:CC\.|ClangCompiler\.)?(\w+)\(.*\)\s+isa\s+(?:CC\.|ClangCompiler\.)?([\w{}]+)\s*$",
                      strip(line))
            m === nothing && continue
            fname, asserted = m.captures[1], Symbol(m.captures[2])
            shapes = get(rets, fname, nothing)
            shapes === nothing && continue
            # sound only when every method of the name agrees
            all(s -> always_isa(s, asserted), shapes) || continue
            # An accepted exception carries the marker at the site, with its reason beside
            # it. Recording these in a separate baseline file instead put the count three
            # directories from the code, drifted whenever a file was cleaned up, and made
            # two branches conflict over a generated artifact.
            occursin(MARKER, line) && continue
            # forward slashes always: this output is compared against a checked-in
            # baseline, and Windows would otherwise report every path as a new file
            push!(hits, (replace(relpath(path, ROOT), '\\' => '/'), n, fname, strip(line)))
        end
    end

    if isempty(hits)
        println("every statically-true `isa` assertion carries the `$MARKER` marker")
        return 0
    end
    byfile = Dict{String,Vector{Tuple{Int,String,String}}}()
    for (p, n, fn, code) in hits
        push!(get!(byfile, p, Tuple{Int,String,String}[]), (n, fn, code))
    end
    println("`@test ... isa ...` assertions that cannot fail: $(length(hits)) across $(length(byfile)) files\n")
    for p in sort!(collect(keys(byfile)); by=k -> -length(byfile[k]))
        println("--- $p  ($(length(byfile[p])))")
        for (n, fn, code) in byfile[p]
            println("    $p:$n  $code")
        end
    end
    println("\nEach restates the wrapper's own return expression. Assert what Clang decided")
    println("instead: a value, a round trip, or a relationship the shim could get wrong.")
    println("If the value genuinely is not assertable -- the host decides it, it varies across")
    println("the objects the test walks, or it is an integer the target chooses -- mark the")
    println("line `$MARKER` and say which of those it is.")
    return 1
end

abspath(PROGRAM_FILE) == (@__FILE__) && exit(main())
