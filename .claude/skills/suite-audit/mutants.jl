# Measure what the test suite actually catches, by breaking wrappers on purpose.
#
# Assertion counts say nothing about fault detection. A suite can be large, fully executed,
# and free of tautologies while still failing to notice that an accessor returns the wrong
# member. The only way to know is to inject the fault and see whether anything goes red.
#
#     julia --project .claude/skills/suite-audit/mutants.jl            # run the whole catalogue
#     julia --project .claude/skills/suite-audit/mutants.jl swap       # only mutants whose label matches
#
# Each mutant redefines one wrapper in the ClangCompiler module, then runs the test files
# that exercise it. A mutant that SURVIVES is a precise, addressable gap: some wrapper can
# return the wrong thing and no assertion notices.
#
# Two results are reported separately on purpose. "assertion" means a `@test` failed, which
# is the suite doing its job. "crash" means clang aborted downstream -- the fault was fatal
# rather than detected, so the suite noticed by luck and would not have caught a subtler
# version of the same bug. Only the first counts as coverage.
#
# Exit status is 1 when any mutant survives.

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

const ROOT = repo_root()

struct Mutant
    label::String
    mutation::String        # evaluated inside the ClangCompiler module
    files::Vector{String}   # test files to run
    note::String            # the real bug class this stands in for
end

const AST_CORE = ["test/clang/invariants.jl", "test/clang/differential.jl",
                  "test/clang/api/AST/Expr.jl",
                  "test/clang/api/AST/Decl.jl", "test/clang/api/AST/DeclBase.jl",
                  "test/clang/decl.jl", "test/clang/stmt.jl"]

const CATALOGUE = [
    Mutant("swap_begin_end",
           "getBeginLoc(x::AbstractStmt) = getEndLoc(x)", AST_CORE,
           "an accessor returns a sibling member of the same type"),
    Mutant("swap_lhs_rhs",
           "getLHS(x::AbstractBinaryOperator) = getRHS(x)", AST_CORE,
           "a two-operand accessor pair wired the wrong way round"),
    Mutant("null_qualtype",
           "getType(x::AbstractExpr) = QualType(C_NULL)", AST_CORE,
           "a shim swallows its result and hands back nothing"),
    Mutant("null_declcontext",
           "getParent(x::DeclContext) = DeclContext(C_NULL)", AST_CORE,
           "the same, on a carrier rather than a value type"),
    Mutant("negate_isimplicit",
           "isImplicit(x::AbstractDecl) = !clang_Decl_isImplicit(x)", AST_CORE,
           "a predicate inverted, as a wrong static_cast or a flipped bit would"),
    Mutant("off_by_one_arg",
           "getArg(x::AbstractCallExpr, i::Integer) = Expr_(clang_CallExpr_getArg(x, i + 1))",
           AST_CORE,
           "an index accessor shifted, the classic count+index marshalling slip"),
    Mutant("swap_both_ends",
           """begin
               getBeginLoc(x::AbstractDecl) = clang_Decl_getEndLoc(x) |> SourceLocation
               getEndLoc(x::AbstractDecl) = clang_Decl_getBeginLoc(x) |> SourceLocation
           end""", AST_CORE,
           "both ends swapped together -- symmetric, so containment cannot see it; only an outside oracle can"),
    Mutant("no_decl_resolve",
           "resolve(x::AbstractDecl) = x", AST_CORE,
           "declaration carriers left at their base class -- every `isa` against a concrete decl silently stops matching"),
    Mutant("first_arg_always",
           "getArg(x::AbstractCallExpr, i::Integer) = Expr_(clang_CallExpr_getArg(x, 0))",
           AST_CORE,
           "an index ignored -- what argument misrouting in a void* shim looks like"),
]

"Run one mutant. Returns (:assertion, :crash, :survived)."
function run_mutant(m::Mutant)
    includes = join(["    try; include(\"$f\"); catch; end" for f in m.files], "\n")
    prog = """
    using TestEnv; TestEnv.activate()
    cp("LocalPreferences.toml",
       joinpath(dirname(Base.active_project()), "LocalPreferences.toml"); force=true)
    using ClangCompiler
    @eval ClangCompiler $(m.mutation)
    $includes
    """
    out = IOBuffer()
    base = setenv(`$(Base.julia_cmd()) --project=$ROOT -e $prog`; dir=ROOT)
    run(pipeline(ignorestatus(base); stdout=out, stderr=out))
    log = String(take!(out))
    occursin("Test Failed", log) && return :assertion
    occursin(r"signal|Segmentation|Assertion failed|SIGABRT", log) && return :crash
    return :survived
end

function main(pattern="")
    sel = filter(m -> isempty(pattern) || occursin(pattern, m.label), CATALOGUE)
    isempty(sel) && (println("no mutants match \"$pattern\""); return 2)
    println("running $(length(sel)) mutants\n")
    survivors, lucky = String[], String[]
    for m in sel
        r = run_mutant(m)
        mark = r === :assertion ? "caught  " : r === :crash ? "crash   " : "SURVIVED"
        println("  $mark  $(m.label)")
        r === :survived && push!(survivors, "$(m.label): $(m.note)")
        r === :crash && push!(lucky, "$(m.label): $(m.note)")
    end
    score = round(100 * (length(sel) - length(survivors) - length(lucky)) / length(sel); digits=1)
    println("\nmutation score (caught by an assertion): $score%")
    if !isempty(lucky)
        println("\nNoticed only because clang aborted, not because anything asserted --")
        println("a subtler version of the same fault would pass:")
        for l in lucky; println("  - $l"); end
    end
    if !isempty(survivors)
        println("\nSURVIVED. Some wrapper can return the wrong thing and nothing notices:")
        for s in survivors; println("  - $s"); end
        return 1
    end
    return 0
end

abspath(PROGRAM_FILE) == (@__FILE__) && exit(main(get(ARGS, 1, "")))
