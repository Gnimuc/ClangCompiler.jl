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
    # Non-empty marks a mutant known to survive, naming the capability the suite would need
    # to kill it. It still counts against the score -- an exemption that improved the number
    # would be a way of hiding the gap rather than recording it -- but it keeps the exit
    # status meaningful, so a red run means something NEW survived. The script fails just as
    # loudly when a blocked mutant starts being caught, because the note is then stale and
    # this field is the kind of exemption that rots if nothing checks it.
    blocked_on::String
end
Mutant(l, m, f, n) = Mutant(l, m, f, n, "")

const AST_CORE = ["test/clang/invariants.jl", "test/clang/differential.jl",
                  "test/clang/api/AST/Expr.jl",
                  "test/clang/api/AST/Decl.jl", "test/clang/api/AST/DeclBase.jl",
                  "test/clang/decl.jl", "test/clang/stmt.jl"]

# The two files holding the most `# shape-only` markers, and -- until these mutants -- the
# largest stretch of the wrapper surface no fault had ever been injected into. A score
# measured only over AST_CORE says nothing about either.
const FRONTEND = ["test/clang/api/Frontend/CompilerInstance.jl"]
const DRIVER = ["test/clang/api/Driver/Driver.jl"]
const SOURCEMGR = ["test/clang/api/Basic/SourceManager.jl"]
const ASTUNIT = ["test/clang/api/Frontend/ASTUnit.jl"]
const COMMENT = ["test/clang/api/AST/Comment.jl"]
const IDTABLE = ["test/clang/api/Basic/IdentifierTable.jl"]
const CFGF = ["test/clang/api/Analysis/CFG.jl"]
const LEX = ["test/clang/api/Lex/Preprocessor.jl"]
const SEMA = ["test/clang/api/Sema/Sema.jl", "test/clang/api/Sema/Lookup.jl",
              "test/clang/api/Sema/TemplateDeduction.jl"]
const SRCLOC = ["test/clang/api/Basic/SourceLocation.jl"]

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
    Mutant("lookup_name_always_found",
           "LookupName(x::Sema, r::LookupResult, sp::Scope, allow_builtin_creation::Bool=false, force_no_cxx::Bool=false) = true",
           FRONTEND,
           "a Sema query answering yes whatever the lookup found"),
    Mutant("lookup_count_zero",
           "getNum(x::LookupResult) = 0", FRONTEND,
           "a count swallowed -- the shape of a shim reading the wrong field"),
    Mutant("scopespec_validity_collapse",
           "isInvalid(x::CXXScopeSpec) = isValid(x)", FRONTEND,
           "two complementary predicates wired to the same underlying query"),
    Mutant("scopespec_emptiness_collapse",
           "isNotEmpty(x::CXXScopeSpec) = isEmpty(x)", FRONTEND,
           "the same, on the emptiness pair"),
    Mutant("driver_sysroot_swap",
           "getSysRoot(x::AbstractDriver) = getResourceDir(x)", DRIVER,
           "a string accessor returning a sibling member -- `isa String` cannot see it"),
    Mutant("toolchain_arch_os_swap",
           "getArchName(x::AbstractToolChain) = getOS(x)", DRIVER,
           "the same, on the two components a toolchain reads out of its triple"),
    Mutant("driver_lto_always",
           "isUsingLTO(x::AbstractDriver, is_offload::Bool=false) = true", DRIVER,
           "a predicate stuck at one answer"),
    Mutant("astunit_filename_swap",
           "getMainFileName(x::AbstractASTUnit) = getOriginalSourceFileName(x)", ASTUNIT,
           "two string accessors on one object wired to the same member",
           """a unit whose main file and original source differ. Both are empty on a unit
              that never parsed and both are the .cpp after a command-line parse, so the
              two accessors agree in every state the suite can currently build. They
              diverge only after ASTUnit::LoadFromASTFile, where the main file is the .ast
              and the original source is the .cpp it came from -- and that entry point has
              no wrapper. The load testset already writes an .ast and checks its magic, so
              wrapping LoadFromASTFile is what closes this."""),
    Mutant("astunit_fileid_swap",
           "isInMainFileID(x::AbstractASTUnit, loc::SourceLocation) = isInPreambleFileID(x, loc)",
           ASTUNIT,
           "the main-file and preamble queries collapsed onto one another"),
    Mutant("sm_next_offset_zero",
           "getNextLocalOffset(src_mgr::SourceManager) = 0", SOURCEMGR,
           "a monotonically growing counter swallowed"),
    Mutant("sm_sloc_size_zero",
           "local_sloc_entry_size(src_mgr::SourceManager) = 0", SOURCEMGR,
           "the same, on the entry table's own size"),
    Mutant("sm_created_fids_zero",
           "getNumCreatedFIDsForFileID(src_mgr::SourceManager, id::FileID) = 0", SOURCEMGR,
           "a per-key count answering zero whatever the key"),
    Mutant("comment_command_id_zero",
           "getCommandID(x::AbstractBlockCommandComment) = 0", COMMENT,
           "a command-table index swallowed -- \\brief and \\param stop being distinguishable"),
    Mutant("comment_param_index_zero",
           "getParamIndex(x::AbstractParamCommandComment) = 0", COMMENT,
           "an index ignored, so every \\param names the first parameter"),
    Mutant("idtable_total_memory_zero",
           "getTotalMemory(x::AbstractSelectorTable) = 0", IDTABLE,
           "an allocator query swallowed"),
    Mutant("cfg_synthetic_decls_zero",
           "getNumSyntheticDeclStmts(x::AbstractCFG) = 0", CFGF,
           "a whole-graph count swallowed"),
    Mutant("cfg_cc_index_zero",
           "getIndex(x::AbstractConstructionContext) = 0", CFGF,
           "an argument position ignored, so every construction looks like the first"),
    Mutant("pp_directives_zero",
           "getNumDirectives(x::AbstractPreprocessor) = 0", LEX,
           "a count of what the source actually contains, swallowed"),
    Mutant("pp_total_memory_zero",
           "getTotalMemory(x::AbstractPreprocessor) = 0", LEX,
           "an allocator query swallowed"),
    Mutant("sema_section_specifier_always",
           "isValidSectionSpecifier(x::AbstractSema, s::AbstractString) = true", SEMA,
           "a validator that accepts everything -- the shape of a swallowed diagnostic"),
    Mutant("scope_prototype_depth_zero",
           "getFunctionPrototypeDepth(x::AbstractScope) = 0", SEMA,
           "a nesting depth pinned at the outermost value"),
    Mutant("deduction_callarg_zero",
           "getCallArgIndex(x::AbstractTemplateDeductionInfo) = 0", SEMA,
           "the argument a deduction failed on, reported as always the first",
           """a deduction that fails on an argument other than the first. CallArgIndex is
              written only by the deduce-from-call-arguments path, and the three wrapped
              DeduceTemplateArguments overloads are the two partial-specialisation ones and
              the explicit-template-argument one -- none of which take call arguments, so
              the field stays 0 in every state the suite can reach. Wrapping the
              overload-resolution entry point (FunctionTemplateDecl + ArrayRef<Expr*>) is
              what closes this."""),
    Mutant("presumedloc_line_col_swap",
           "getLine(x::PresumedLoc) = getColumn(x)", SRCLOC,
           "line reported as column -- two integers off one struct, which `isa Integer` cannot separate"),
]

"""
    run_files(files, mutation) -> String

Include `files` in a fresh process, with `mutation` evaluated into ClangCompiler first when
it is non-empty. Returns the combined output.
"""
function run_files(files, mutation)
    includes = join(["    try; include(\"$f\"); catch; end" for f in files], "\n")
    mutate = isempty(mutation) ? "" : "@eval ClangCompiler $mutation"
    prog = """
    using TestEnv; TestEnv.activate()
    cp("LocalPreferences.toml",
       joinpath(dirname(Base.active_project()), "LocalPreferences.toml"); force=true)
    using ClangCompiler
    $mutate
    $includes
    """
    out = IOBuffer()
    base = setenv(`$(Base.julia_cmd()) --project=$ROOT -e $prog`; dir=ROOT)
    run(pipeline(ignorestatus(base); stdout=out, stderr=out))
    return String(take!(out))
end

"""
    check_baseline(sel) -> Vector{String}

The file sets that are already failing before any mutation, as human-readable lines.

Detection here is "a `Test Failed` appeared", which cannot tell a mutant being caught from a
suite that was red to begin with: a single broken assertion anywhere in a mutant's file set
marks every mutant over that set as caught, and the score climbs while the suite gets worse.
That is not hypothetical -- one wrong expected value in Lookup.jl once reported two genuine
survivors as caught. So each distinct file set is run unmutated first, and a red one stops
the run rather than inflating it.
"""
function check_baseline(sel)
    bad = String[]
    for files in unique(m.files for m in sel)
        log = run_files(files, "")
        if occursin("Test Failed", log) ||
           occursin(r"signal|Segmentation|Assertion failed|SIGABRT", log)
            push!(bad, join(files, ", "))
        end
    end
    return bad
end

"Run one mutant. Returns (:assertion, :crash, :survived)."
function run_mutant(m::Mutant)
    log = run_files(m.files, m.mutation)
    occursin("Test Failed", log) && return :assertion
    occursin(r"signal|Segmentation|Assertion failed|SIGABRT", log) && return :crash
    return :survived
end

function main(pattern="")
    sel = filter(m -> isempty(pattern) || occursin(pattern, m.label), CATALOGUE)
    isempty(sel) && (println("no mutants match \"$pattern\""); return 2)

    println("checking the baseline is green before injecting anything")
    red = check_baseline(sel)
    if !isempty(red)
        println("\nThese file sets FAIL before any mutation, so every mutant over them would")
        println("be scored as caught for a reason that has nothing to do with the mutant:")
        for r in red; println("  - $r"); end
        println("\nFix the suite first; a score measured against a red tree only goes up.")
        return 3
    end

    println("running $(length(sel)) mutants\n")
    survivors, lucky, blocked, stale = String[], String[], String[], String[]
    for m in sel
        r = run_mutant(m)
        known = !isempty(m.blocked_on)
        mark = r === :assertion ? "caught  " : r === :crash ? "crash   " :
               known ? "blocked " : "SURVIVED"
        println("  $mark  $(m.label)")
        if r === :survived
            # one entry per mutant either way -- the score below counts these
            if known
                needs = replace(strip(m.blocked_on), r"\s*\n\s*" => " ")
                push!(blocked, "$(m.label): $(m.note)\n      needs: $needs")
            else
                push!(survivors, "$(m.label): $(m.note)")
            end
        elseif r === :crash
            push!(lucky, "$(m.label): $(m.note)")
        elseif known
            push!(stale, "$(m.label): now caught, so `blocked_on` is out of date -- drop it")
        end
    end
    # blocked mutants count against the score exactly like any other survivor: the gap is
    # real whether or not it is expected, and an exemption that moved the number would be a
    # way of not seeing it
    caught = length(sel) - length(survivors) - length(blocked) - length(lucky)
    score = round(100 * caught / length(sel); digits=1)
    println("\nmutation score (caught by an assertion): $score%")
    if !isempty(lucky)
        println("\nNoticed only because clang aborted, not because anything asserted --")
        println("a subtler version of the same fault would pass:")
        for l in lucky; println("  - $l"); end
    end
    if !isempty(blocked)
        println("\nKnown survivors. Each names the capability that would close it:")
        for b in blocked; println("  - $b"); end
    end
    if !isempty(stale)
        println("\nA known survivor is no longer surviving -- the exemption is stale:")
        for s in stale; println("  - $s"); end
    end
    if !isempty(survivors)
        println("\nSURVIVED. Some wrapper can return the wrong thing and nothing notices:")
        for s in survivors; println("  - $s"); end
    end
    return (isempty(survivors) && isempty(stale)) ? 0 : 1
end

abspath(PROGRAM_FILE) == (@__FILE__) && exit(main(get(ARGS, 1, "")))
