# What the prose claims, computed — and which of its references do not resolve.
#
#   julia --project .claude/skills/doc-audit/facts.jl
#
# This script does the part that needs no judgement: it counts the quantities the docs assert
# most often, and it resolves every path, symbol and link they cite. It does NOT decide whether
# a claim is true — a sentence can cite only live symbols and still be wrong about what they
# mean, which is how "all CX handles are Ptr{Cvoid} aliases" survived a suite that already
# checks cited symbols. Deciding is the reader's job; SKILL.md says how.
#
# Exits 1 when a cited reference does not resolve.

const ROOT = normpath(joinpath(@__DIR__, "..", "..", ".."))

# Tracked files only. `.agents/` and other scratch are gitignored workspace artifacts that no
# reader is expected to trust, and auditing them buries the real findings — the first run of
# this script reported nine of them and two genuine defects.
const DOCS = let tracked = cd(() -> readlines(`git ls-files '*.md'`), ROOT)
    # the skills are gitignored under `.claude/` but force-added, so ask git rather than assume
    filter(f -> !startswith(f, "lib/"), tracked)
end

read_(p) = read(joinpath(ROOT, p), String)
count_matches(re, s) = length(collect(eachmatch(re, s)))

"Every `clang_*` symbol the shim headers declare."
function shim_symbols()
    s = Set{String}()
    for (r, _, fs) in walkdir(joinpath(ROOT, "deps", "ClangExtra", "include")), f in fs
        endswith(f, ".h") || continue
        for m in eachmatch(r"\bclang_[A-Za-z0-9_]+", read(joinpath(r, f), String))
            push!(s, m.match)
        end
    end
    return s
end

function facts()
    bindings = read_(joinpath("lib", string(Base.libllvm_version.major), "LibClangEx.jl"))
    types_h = read_(joinpath("deps", "ClangExtra", "include", "clang-ex", "CXTypes.h"))
    api = [joinpath(r, f) for (r, _, fs) in walkdir(joinpath(ROOT, "src", "clang", "api"))
           for f in fs if endswith(f, ".jl")]
    marsh = read_(joinpath("deps", "ClangExtra", "MARSHALLING.md"))

    println("== quantities the docs assert (each with the way it was counted) ==\n")
    out(label, n, how) = println("  ", rpad(label, 46), lpad(string(n), 6), "   ", how)

    out("handles as Ptr{Cvoid} in bindings",
        count_matches(r"^const CX\w+ = Ptr\{Cvoid\}"m, bindings), "const CX* = Ptr{Cvoid}")
    out("handles as their own phantom",
        count_matches(r"^const CX\w+ = Ptr\{CX\w*Impl\}"m, bindings), "const CX* = Ptr{CX*Impl}")
    out("shim `typedef void *`",
        count_matches(r"typedef void \*", types_h), "in CXTypes.h")
    out("shim `typedef struct CX*Impl *`",
        count_matches(r"typedef struct CX\w*Impl \*", types_h), "in CXTypes.h")
    out("clang_* symbols the headers declare", length(shim_symbols()), "over deps/ClangExtra/include")
    out("@ccall bindings", count_matches(r"@ccall libclangex\.", bindings), "in LibClangEx.jl")
    out("wrapper functions in src/clang/api",
        sum(f -> count_matches(r"^function "m, read(f, String)), api; init=0), "^function in api/**")
    out("test files", length(filter(f -> endswith(f, ".jl"),
                                    reduce(vcat, [joinpath.(r, fs) for (r, _, fs) in
                                                  walkdir(joinpath(ROOT, "test"))]; init=String[]))),
        "*.jl under test/")
    out("examples", length(filter(f -> endswith(f, ".jl"), readdir(joinpath(ROOT, "examples")))),
        "*.jl in examples/")
    out("`public` names", count_matches(r"^public "m, read_(joinpath("src", "ClangCompiler.jl"))),
        "^public in ClangCompiler.jl")
    out("MARSHALLING.md sections", count_matches(r"^## \d+\."m, marsh), "^## <n>. in MARSHALLING.md")

    println("\n  MARSHALLING.md section numbers present: ",
            join([m.captures[1] for m in eachmatch(r"^## (\d+)\."m, marsh)], " "))
    println("  formatter settings: ",
            join(filter(l -> !isempty(l) && !startswith(l, "#") && !startswith(l, " "),
                        strip.(split(read_(".JuliaFormatter.toml"), "\n"))), "  "))
    println("  CI jobs: ", join([m.captures[1] for m in
                                 eachmatch(r"^  ([a-z][\w-]*):$"m,
                                           read_(joinpath(".github", "workflows", "CI.yml")))], " "))

    # Names this branch retired. A hit is a CANDIDATE, never a defect: `casts.jl` names both
    # deliberately, to say what they were replaced by, and the C side's `castTo` family is a
    # different thing wearing a similar word. Only a reader can tell those from a doc still
    # instructing someone to call one.
    println("\n  retired names — candidates to read, not defects:")
    for name in ("downcast", "upcast", "gapmap", "gapdiff")
        hits = String[]
        for d in ("src", "deps"), (r, _, fs) in walkdir(joinpath(ROOT, d)), f in fs
            endswith(f, ".jl") || endswith(f, ".h") || endswith(f, ".cpp") || continue
            occursin(name, read(joinpath(r, f), String)) && push!(hits, relpath(joinpath(r, f), ROOT))
        end
        println("    ", rpad(name, 12), isempty(hits) ? "gone" : join(first(hits, 3), ", "))
    end
end

"A name a doc uses as an illustration rather than a citation."
const PLACEHOLDER = r"_(Foo|Bar|Baz|X|Derived|Base|ClassName|Class)(_|$)|^clang_<"

"""
Cited paths, `clang_*` symbols and relative links that do not resolve.

Three kinds of citation are deliberately NOT errors, and each cost a false positive on the
first run: a `clang_*` name from **libclang** rather than this shim (`clang_toggleCrashRecovery`
is bound in `lib/LibClang.jl`), a placeholder standing in for a real name
(`clang_Foo_create` in a skill's worked example), and a path into **clang's own tree** rather
than this repo (`clang/AST/DeclBase.h`, which names the upstream header a shim file mirrors).
"""
function broken_refs()
    syms = union(shim_symbols(),
                 Set(m.match for m in eachmatch(r"\bclang_[A-Za-z0-9_]+",
                                                read_(joinpath("lib", "LibClang.jl")))))
    bad = Tuple{String,Int,String,String}[]
    for doc in DOCS
        here = dirname(joinpath(ROOT, doc))
        for (n, line) in enumerate(eachline(joinpath(ROOT, doc)))
            for m in eachmatch(r"`([^`]+)`", line)
                t = m.captures[1]
                if occursin(r"^clang_[A-Za-z0-9_]+$", t)
                    (t in syms || occursin(PLACEHOLDER, t)) || push!(bad, (doc, n, "symbol", t))
                elseif occursin(r"^[\w./-]+\.(jl|md|h|cpp|toml|yml|inc)$", t) && occursin("/", t)
                    # `clang/...` is upstream clang's tree; `clang-ex/...` and `clang-c/...`
                    # are include-path-relative as an #include writes them, not paths from
                    # anywhere on disk. None of the three is this repo's to resolve.
                    startswith(t, "clang/") && continue
                    (startswith(t, "clang-ex/") || startswith(t, "clang-c/") ||
                     startswith(t, "llvm-c/") || startswith(t, "llvm/")) && continue
                    # a citation may be written from the repo root or from the doc's own
                    # directory; both are legitimate, so it resolves if either does
                    (ispath(joinpath(ROOT, t)) || ispath(joinpath(here, t))) ||
                        push!(bad, (doc, n, "path", t))
                end
            end
            for m in eachmatch(r"\]\(([^)]+)\)", line)
                t = m.captures[1]
                # NOTE the parentheses: `a || b && continue` binds as `a || (b && continue)`,
                # so without them every http link fell through to the filesystem check.
                (startswith(t, "http") || startswith(t, "#") || startswith(t, "mailto:")) && continue
                p = normpath(joinpath(here, split(t, "#")[1]))
                ispath(p) || push!(bad, (doc, n, "link", t))
            end
        end
    end
    println("\n== references that do not resolve ==\n")
    isempty(bad) && println("  none")
    for (d, n, kind, t) in bad
        println("  ", rpad("$d:$n", 44), rpad(kind, 8), t)
    end
    return length(bad)
end

"Bare numbers in prose. Correct today is not the question — nothing updates them."
function bare_constants()
    println("\n== bare constants in prose (candidates for compute-don't-quote) ==\n")
    n = 0
    for doc in DOCS, (ln, line) in enumerate(eachline(joinpath(ROOT, doc)))
        occursin(r"^\s*[|`]", line) && continue                       # tables and code
        for m in eachmatch(r"(?<![\w.$-])(\d{2,})(?![\w.%-])", line)
            v = parse(Int, m.captures[1])
            (1900 <= v <= 2100 || v in (8, 16, 32, 64, 92, 120)) && continue  # years, widths
            n += 1
            println("  ", rpad("$doc:$ln", 44), rpad(m.captures[1], 8),
                    strip(line)[1:min(end, 76)])
        end
    end
    n == 0 && println("  none")
    return n
end

facts()
bad = broken_refs()
bare_constants()
println("\n", bad == 0 ? "references resolve" : "$bad reference(s) do not resolve")
exit(bad == 0 ? 0 : 1)
