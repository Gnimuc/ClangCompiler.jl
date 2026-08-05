# Report `@test` lines that never executed.
#
# A green suite says every assertion that ran passed. It says nothing about assertions that
# did not run, and those are worse than no assertion at all: they read as coverage and prove
# nothing. A `for` loop over a collection that is empty on this host, an `if` branch never
# taken, or a guard that was always false will all sail through CI in silence. One such line
# hid an off-by-one in `DeclIterator` -- the iterator dropped the first declaration of every
# context, and the test that would have caught it asserted only over the elements it did
# yield.
#
# Line coverage answers the question exactly, with no parsing of `@testset` nesting:
#
#     julia --project -e 'using Pkg; Pkg.test(coverage=true)'
#     julia .claude/skills/suite-audit/deadtests.jl
#
# Coverage counts accumulate across runs, so delete stale `.cov` files first
# (`find . -name '*.cov' -delete`) or a line that ran in an earlier run looks live.
#
# Exit status is 1 when anything is dead, so this can gate a CI job.

"""
    repo_root() -> String

The ClangCompiler repository root, found by walking up from this file.

Resolved rather than spelled as a fixed number of `".."` steps so the script keeps working
wherever it lives; `gen/` also has a Project.toml, so the marker is Project.toml *and*
src/clang together.
"""
function repo_root()
    d = @__DIR__
    while !(isfile(joinpath(d, "Project.toml")) && isdir(joinpath(d, "src", "clang")))
        p = dirname(d)
        p == d && error("could not locate the ClangCompiler repository root from $(@__DIR__)")
        d = p
    end
    return d
end

const TEST_DIR = joinpath(repo_root(), "test")

"""
    cov_files(dir) -> Vector{String}

Return every `.cov` file under `dir`. Julia writes `<source>.<pid>.cov` next to the source.
"""
function cov_files(dir)
    out = String[]
    for (root, _, files) in walkdir(dir), f in files
        endswith(f, ".cov") && push!(out, joinpath(root, f))
    end
    return out
end

"""
    dead_assertions(dir) -> Dict{String,Vector{Tuple{Int,String}}}

Map each source file to the `@test` lines coverage recorded as executed zero times.

A `.cov` line is a count (or `-` for a line carrying no code) followed by the source text.
`0` means the line was compiled and never reached, which is exactly the case of interest; `-`
means there was nothing to run there.

WHAT THIS SEES, AND WHAT IT DOES NOT. Measured on Julia 1.12 with a three-case probe:

    @testset "probe" begin
        @test 1 + 1 == 2          # -> count 2
        for x in Int[]            # -> count 1
            @test x == 999        # -> count 0   CAUGHT
        end
        if false                  # -> count 1
            @test 2 + 2 == 5      # -> count 1   MISSED
        end
    end

The empty-loop case — the one CLAUDE.md's first rule about tests is written for, and the one
that hid the `DeclIterator` off-by-one — is caught. A `@test` inside a branch that is never
taken is NOT: Julia attributes the line as executed anyway, so it comes back with a positive
count and looks live. A clean run here therefore means "no assertion sits in an empty loop",
not "every assertion ran".

The branch case needs a different instrument. Until there is one, read a guarded assertion in
a test file as unproven: `if cond; @test ...; end` asserts nothing whenever `cond` is false,
and nothing here will tell you it was.
"""
function dead_assertions(dir=TEST_DIR)
    dead = Dict{String,Vector{Tuple{Int,String}}}()
    for cov in cov_files(dir)
        src = replace(cov, r"\.\d+\.cov$" => "")
        hits = Tuple{Int,String}[]
        for (n, line) in enumerate(eachline(cov))
            m = match(r"^\s*(\d+|-)\s(.*)$", line)
            m === nothing && continue
            count, code = m.captures[1], m.captures[2]
            if count == "0" && occursin(r"@test(_throws|_broken|_skip)?\b", code)
                push!(hits, (n, strip(code)))
            end
        end
        isempty(hits) || (dead[src] = hits)
    end
    return dead
end

function main()
    covs = cov_files(TEST_DIR)
    if isempty(covs)
        println("no .cov files under $TEST_DIR — run the suite with coverage=true first")
        return 2
    end
    dead = dead_assertions()
    total = sum(length(v) for v in values(dead); init=0)
    if total == 0
        println("every @test line executed at least once ($(length(covs)) coverage files)")
        return 0
    end
    root = repo_root()
    println("@test lines that NEVER executed: $total across $(length(dead)) files\n")
    for f in sort!(collect(keys(dead)); by=k -> -length(dead[k]))
        rel = replace(relpath(f, root), '\\' => '/')   # stable across platforms
        println("--- $rel  ($(length(dead[f])))")
        for (n, code) in dead[f]
            println("    $rel:$n  $code")
        end
    end
    println("\nEach of these proves nothing. Either construct the state that makes it run, or")
    println("assert the empty case explicitly so the silence is visible in the source.")
    return 1
end

abspath(PROGRAM_FILE) == (@__FILE__) && exit(main())
