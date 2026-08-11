# Report `@test x isa T` assertions that cannot fail.
#
# The `suite-audit` skill's `deadtests.jl` finds assertions that never run. This finds the ones that run and prove
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
#     julia test/tautologies.jl
#
# Exit status is 1 when anything is reported.
#
# This lives in test/ next to its consumer: test/lint.jl executes it and asserts on its output,
# so it runs in CI on every platform and is part of the suite. It is not a testset and
# runtests.jl does not include it -- the same shape as test/util.jl. The audit scripts that
# nothing executes are in .claude/skills/suite-audit/ instead.

const ROOT = normpath(joinpath(@__DIR__, ".."))

"Marks an assertion whose value is genuinely not assertable; see the note in CLAUDE.md."
const MARKER = "# shape-only"
const API = joinpath(ROOT, "src", "clang")
const TESTS = joinpath(ROOT, "test")

# The marker is an exemption, so it carries the reason it was granted under. CLAUDE.md admits
# four and no others; these match them by keyword, leaving the prose free.
#
# The fourth is not a weaker version of the first. "The host decides it" says a real machine
# chose a real value; "nothing decides it" says the read was of memory nobody wrote, which is
# a precondition to state rather than an answer to record. Sites in the second class were all
# labelled with the first before this existed, which read as though someone had checked.
#
# What this can and cannot do: it checks that a reason was *stated* and names one of the
# categories above. It cannot check that the claim is TRUE -- `getLine` marked "the target chooses
# this value" satisfies every pattern below and is still false, because a line number is
# decided by the source. Only reading the site catches that. Without the check, though, a
# marker with no reason at all reads exactly like one that was thought about.
const REASONS = ["the host decides it" => r"\bhost\b|\bsysroot\b|\brunner\b|\bworking directory\b|\bexecutable path\b"i, "the target decides it" => r"\btarget\b|\bABI\b|\btriple\b|\bmangl|\blayout\b|\balign|\bendian|\bplatform\b"i, "it varies across the objects the test walks" => r"\bvar(?:y|ies|ying)\b|\bwalk|\bdiffers\b|\bnode to node\b"i, "nothing decides it -- the read is uninitialised" => r"\buninitiali[sz]ed\b|\bnever set\b|\bnever initiali[sz]ed\b|\bno in-class initiali[sz]er\b"i]

"""
    split_comment(line) -> (code, comment)

Split `line` at its trailing comment, with `comment` keeping its `#`.

The assertion pattern is anchored at end-of-code, so the comment has to come off before the
match rather than being tolerated inside it. Anchoring at end-of-*line* instead is what made
this check vacuous: every marked site ends in `# shape-only`, so none of them matched the
pattern, the marker test below was unreachable, and any trailing comment whatsoever -- not
just the marker -- exempted an assertion from the ratchet.

The scan tracks string and character literals so a `#` inside one is not mistaken for the
start of a comment.
"""
function split_comment(line)
    instr = inchar = escaped = false
    for (i, c) in pairs(line)
        if escaped
            escaped = false
        elseif c == '\\'
            escaped = true
        elseif instr
            c == '"' && (instr = false)
        elseif inchar
            c == '\'' && (inchar = false)
        elseif c == '"'
            instr = true
        elseif c == '\''
            inchar = true
        elseif c == '#'
            return (line[1:prevind(line, i)], line[i:end])
        end
    end
    return (line, "")
end

"""
    reason_of(comment) -> String

The prose following the marker, or `""` when the marker carries none.

Split on the marker rather than matched as a whole so that a site writing `# shape-only`
with no colon is reported as missing a reason instead of silently not matching.
"""
function reason_of(comment)
    i = findfirst(MARKER, comment)
    i === nothing && return ""
    return strip(lstrip(comment[(last(i) + 1):end], [':', ' ', '\t', '-', '—']))
end

"""
    continues(code, nxt) -> Bool

Whether `code` runs on into `nxt` with its parentheses already balanced.

Julia accepts a binary operator at either end of the break, so both `x isa\\n Bool` and
`x\\n isa Bool` are one expression, and each hides the assertion from a per-line scan. Only
the operators that can appear in an `ASSERTION` are listed; a wider set would risk joining
one assertion onto the next.
"""
function continues(code, nxt)
    c, n = rstrip(code), lstrip(nxt)
    (isempty(c) || isempty(n)) && return false
    # `isa` and `in` are words, so they need the space: without it `Visa` ends with `isa`.
    any(endswith(c, op) for op in (" isa", " in", "==", "!=", "<=", ">=", "&&", "||")) && return true
    return any(startswith(n, op) for op in ("isa ", "in ", "==", "!=", "<=", ">=", "&&", "||"))
end

"""
    logical_lines(path) -> Vector{Tuple{Int,String,String}}

The file as ASSERTIONS see it: `(first line number, code, comments)`, with a `@test` that does
not finish on its own line joined to the lines that finish it.

Without this the detector is formatting-dependent, which is a way of being vacuous that its
own `self_check` was not built to catch. `ASSERTION` is anchored to end-of-line, so

    @test CC.SpecialMemberIsTrivial(sema, ctor,
                                    CC.CXCXXSpecialMember_CXXDefaultConstructor) isa Bool

never matched, and four such assertions sat unreported until an unrelated formatter run
happened to join them. Whether an assertion is checked must not depend on where the author
pressed return.

Two things continue a line, and counting parentheses alone catches only the first. An operator
may also sit at the end of one line or the start of the next with the parentheses already
balanced —

    @test CC.getElementDestructorDecl(b, j, ctx) isa
          CC.CXXDestructorDecl

— which is how a fifth vacuous assertion survived the pass that added the parenthesis joining,
and stayed hidden until the formatter joined it too. [`continues`](@ref) reads both spellings.

Comments are stripped per physical line and concatenated, so a `# shape-only` marker counts
wherever in the assertion it was written.
"""
function logical_lines(path)
    out = Tuple{Int,String,String}[]
    lines = readlines(path)
    i = 1
    while i <= length(lines)
        code, comment = split_comment(lines[i])
        first_line = i
        # Only a `@test` is joined, and only while it is unfinished: this is a report about
        # assertions, and joining everything would risk swallowing a following statement when
        # a file has unbalanced parens inside a string this crude counter cannot see.
        if occursin("@test", code)
            depth = count(==('('), code) - count(==(')'), code)
            while i < length(lines) && (depth > 0 || continues(code, split_comment(lines[i + 1])[1]))
                i += 1
                c2, cm2 = split_comment(lines[i])
                code = rstrip(code) * " " * strip(c2)
                comment *= cm2
                depth += count(==('('), c2) - count(==(')'), c2)
            end
        end
        push!(out, (first_line, code, comment))
        i += 1
    end
    return out
end

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
const SCALAR = Dict(:Cuint => :Integer, :Cint => :Integer, :Csize_t => :Integer, :Clong => :Integer, :Culong => :Integer, :Cshort => :Integer, :Cushort => :Integer, :UInt32 => :Integer, :Int32 => :Integer, :Int64 => :Integer, :UInt64 => :Integer, :Bool => :Bool, :Cdouble => :AbstractFloat, :Cfloat => :AbstractFloat)

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

"The assertion this script hunts for, matched against a line with its comment already removed."
const ASSERTION = r"@test\s+(?:CC\.|ClangCompiler\.)?(\w+)\(.*\)\s+isa\s+(?:CC\.|ClangCompiler\.)?([\w{}]+)\s*$"

"""
    self_check()

Fail loudly if the line mechanics stop recognising the shapes they are supposed to.

This exists because the detector went vacuous once without anyone noticing: `ASSERTION` was
matched against the whole line, so a site ending in `# shape-only` -- which is every marked
site, and any commented assertion besides -- did not match at all. The marker test below it
was unreachable, every marker was decorative, and the script reported a clean tree. A clean
tree and a broken detector print the same sentence, which is what makes this worth asserting.
"""
function self_check()
    probe = "    @test CC.getNumBases(rd) isa Integer"
    for (suffix, want) in ("" => "", "  # prose" => "# prose", "  # shape-only" => "# shape-only", "  # shape-only: the host decides this" => "# shape-only: the host decides this")
        code, comment = split_comment(probe * suffix)
        comment == want || error("split_comment lost the comment on `$probe$suffix`: got `$comment`")
        match(ASSERTION, strip(code)) === nothing && error("the assertion pattern no longer matches `$probe$suffix`")
    end
    # a `#` inside a string literal does not start a comment
    _, c = split_comment("""    @test CC.getName(d) == "a#b" """)
    isempty(c) || error("split_comment read a `#` inside a string as a comment: `$c`")
    # A split assertion reaches ASSERTION as one line, carrying its marker and its first line
    # number. Probing only single-line shapes is how this check missed the joining hole for as
    # long as it did: the mechanic it guarded was sound and the input never reached it.
    mktemp() do probe_path, io
        write(io, """
              x = 1
              @test CC.getNumBases(rd,
                                   extra) isa Integer  # shape-only: the host decides this
              y = 2
              """)
        close(io)
        got = logical_lines(probe_path)
        # four physical lines, three logical: the joining is the whole point
        length(got) == 3 || error("logical_lines produced $(length(got)) entries for a 4-line file with one \
                                   split assertion; expected 3")
        n, code, comment = got[2]
        n == 2 || error("logical_lines lost the first line number of a joined assertion: got $n")
        match(ASSERTION, strip(code)) === nothing && error("a joined assertion no longer matches the assertion pattern: `$code`")
        occursin(MARKER, comment) || error("logical_lines dropped the marker from a joined assertion: `$comment`")
    end
    # The same, with the parentheses BALANCED at the break and an operator carrying the line --
    # both spellings, since Julia accepts the operator at either end. Paren-depth alone reports
    # neither, which is how one of these stayed hidden after the joining pass went in.
    for body in ("""
                 @test CC.getElementDestructorDecl(b, j, ctx) isa
                       CC.CXXDestructorDecl  # shape-only: the host decides this
                 """, """
                 @test CC.getElementDestructorDecl(b, j, ctx)
                       isa CC.CXXDestructorDecl  # shape-only: the host decides this
                 """)
        mktemp() do probe_path, io
            write(io, body)
            close(io)
            got = logical_lines(probe_path)
            length(got) == 1 || error("logical_lines produced $(length(got)) entries for an assertion broken \
                                       at a balanced-paren operator; expected 1")
            n, code, comment = got[1]
            n == 1 || error("logical_lines lost the first line number of an operator-joined assertion: got $n")
            match(ASSERTION, strip(code)) === nothing && error("an operator-joined assertion no longer matches the assertion pattern: `$code`")
            occursin(MARKER, comment) || error("logical_lines dropped the marker from an operator-joined assertion: `$comment`")
        end
    end
    # ... and joining must stop at the end of an assertion, or two would be reported as one
    mktemp() do probe_path, io
        write(io, """
              @test CC.getNumBases(rd) isa Integer
              @test CC.getNumVBases(rd) isa Integer
              """)
        close(io)
        length(logical_lines(probe_path)) == 2 || error("logical_lines joined two complete assertions into one")
    end
    # every admitted reason is recognised by its own pattern, and prose naming none is not
    for (name, _) in REASONS
        any(p -> occursin(last(p), name), REASONS) || error("the admitted reason `$name` matches none of the patterns")
    end
    any(p -> occursin(last(p), "because it seemed fine"), REASONS) && error("the reason patterns accept prose that names no category")
    return nothing
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
    self_check()
    ccalls = ccall_returns(joinpath(ROOT, "lib", "18", "LibClangEx.jl"))
    rets = wrapper_returns(API, ccalls)
    isempty(ccalls) && (println("no ccalls parsed — is lib/18/LibClangEx.jl present?"); return 2)

    hits = Tuple{String,Int,String,String}[]
    bare = Tuple{String,Int,String,String}[]
    for (root, _, files) in walkdir(TESTS), f in files
        endswith(f, ".jl") || continue
        occursin(".cov", f) && continue
        # This file is the detector, not a test: it contains no `@testset`, and the example
        # assertions in its own comments and docstrings are illustrations. Scanning itself was
        # harmless only while those examples were invisible for being split across lines --
        # joining them turned the script's own documentation into a finding.
        f == "tautologies.jl" && continue
        path = joinpath(root, f)
        for (n, code, comment) in logical_lines(path)
            m = match(ASSERTION, strip(code))
            m === nothing && continue
            fname, asserted = m.captures[1], Symbol(m.captures[2])
            shapes = get(rets, fname, nothing)
            shapes === nothing && continue
            # sound only when every method of the name agrees
            all(s -> always_isa(s, asserted), shapes) || continue
            # forward slashes always: this output is compared against a checked-in
            # baseline, and Windows would otherwise report every path as a new file
            rel = replace(relpath(path, ROOT), '\\' => '/')
            # An accepted exception carries the marker at the site, with its reason beside
            # it. Recording these in a separate baseline file instead put the count three
            # directories from the code, drifted whenever a file was cleaned up, and made
            # two branches conflict over a generated artifact.
            if occursin(MARKER, comment)
                # The marker alone used to end the check here, which made the reason a
                # comment nobody read: a third of the exemptions carried none at all.
                r = reason_of(comment)
                any(p -> occursin(last(p), r), REASONS) && continue
                push!(bare, (rel, n, fname, strip(code * comment)))
                continue
            end
            push!(hits, (rel, n, fname, strip(code * comment)))
        end
    end

    if isempty(hits) && isempty(bare)
        println("every statically-true `isa` assertion carries the `$MARKER` marker, with a reason")
        return 0
    end

    # Group by file and print, densest file first. The four-space indent is load-bearing:
    # test/lint.jl scrapes `path:line` out of it to decide whether CI fails.
    function report(rows)
        byfile = Dict{String,Vector{Tuple{Int,String,String}}}()
        for (p, n, fn, code) in rows
            push!(get!(byfile, p, Tuple{Int,String,String}[]), (n, fn, code))
        end
        for p in sort!(collect(keys(byfile)); by=k -> -length(byfile[k]))
            println("--- $p  ($(length(byfile[p])))")
            for (n, fn, code) in byfile[p]
                println("    $p:$n  $code")
            end
        end
        return length(byfile)
    end

    if !isempty(hits)
        nf = report(hits)
        println("`@test ... isa ...` assertions that cannot fail: $(length(hits)) across $nf files\n")
        println("Each restates the wrapper's own return expression. Assert what Clang decided")
        println("instead: a value, a round trip, or a relationship the shim could get wrong.")
        println("If the value genuinely is not assertable -- the host decides it, it varies across")
        println("the objects the test walks, or it is an integer the target chooses -- mark the")
        println("line `$MARKER` and say which of those it is.\n")
    end
    if !isempty(bare)
        nf = report(bare)
        println("`$MARKER` markers whose reason is missing or names none of the $(length(REASONS)) admitted")
        println("categories: $(length(bare)) across $nf files\n")
        println("The marker is an exemption from the rule above, so it states the ground it was")
        println("granted on. One of these must be recognisable in the text after it:")
        for (name, _) in REASONS
            println("  - $name")
        end
        println("\nIf none of them is true of the site, the value is assertable and the marker")
        println("is the wrong fix -- assert what Clang decided instead.")
    end
    return 1
end

abspath(PROGRAM_FILE) == (@__FILE__) && exit(main())
