using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose
using Clang_jll
using Test

# Check the wrappers against an oracle that is not the wrappers.
#
# Every other guard in this suite is self-referential. A pinned value records what the shim
# returns today and so cannot tell a correct shim from one that has been wrong since it was
# written. An invariant checks a relationship among the shim's own answers, which a
# consistently-wrong shim can still satisfy -- if getBeginLoc and getEndLoc were swapped
# together, containment would still hold.
#
# clang's own `-ast-dump` is an independent path to the same facts: a different traversal,
# a different printer, in a different process. Where it disagrees with a wrapper, one of them
# is wrong, and it is not the one upstream maintains.
#
# The source deliberately has no #include: the interpreter runs with -nostdinc and
# JLL-provided include paths, so anything needing headers would compare two different ASTs
# rather than two readings of one.

const DIFF_SRC = """
int diff_zero() { return 0; }

int diff_add(int a, int b) {
    return a + b;
}

double diff_scale(double v,
                  int n) {
    return v * n;
}

struct DiffRec {
    int f;
    double g;
    int sum() const { return f + g; }
};

namespace diff_ns {
    int diff_nested(int x) { return x; }
}

int diff_global = 3;
double diff_scalev = 1.5;
"""

"""
    parse_decl_line(line) -> (name, type, beginline, endline) or nothing

Pull the facts out of one `-ast-dump` line.

The range is `<first, second>`, where `first` ends in `:LINE:COL` and `second` is either
`line:LINE:COL` or a bare `col:COL` when only the column moved. The leading part of `first`
is a file path, which on Windows begins `D:\\...` -- so the line is split on the range
delimiters and each component anchored at its *end*, never scanned up to the first colon.
"""
function parse_decl_line(line)
    occursin(r"(?:FunctionDecl|CXXMethodDecl) 0x", line) || return nothing
    rng = match(r"<([^>]*)>", line)
    tail = match(r"> [^ ]+ (?:used )?(?:constexpr )?(\w+) '([^']+)'", line)
    (rng === nothing || tail === nothing) && return nothing
    parts = split(rng.captures[1], ", ")
    mb = match(r"(\d+):\d+$", parts[1])
    mb === nothing && return nothing
    b = parse(Int, mb.captures[1])
    e = b
    if length(parts) > 1
        me = match(r"line:(\d+):\d+$", parts[2])
        me === nothing || (e = parse(Int, me.captures[1]))
    end
    return (name=tail.captures[1], type=tail.captures[2], beginline=b, endline=e)
end

"What clang says, keyed by function name: (type spelling, begin line, end line, params)."
function oracle_facts(path)
    out = Dict{String,NamedTuple}()
    dump = read(pipeline(ignorestatus(`$(clang()) -Xclang -ast-dump -fsyntax-only
                                       -std=c++17 $path`); stderr=devnull), String)
    fname = ""
    for line in split(dump, '\n')
        m = parse_decl_line(line)
        if m !== nothing
            fname = m.name
            out[fname] = (type=m.type, beginline=m.beginline, endline=m.endline, params=0)
        elseif !isempty(fname) && occursin("ParmVarDecl", line)
            f = out[fname]
            out[fname] = (type=f.type, beginline=f.beginline, endline=f.endline, params=f.params + 1)
        elseif !isempty(line) && !startswith(line, " ") && !startswith(line, "|") && !startswith(line, "`")
            fname = ""
        end
    end
    return out
end

"""
    oracle_members(path) -> (fields, vars)

The record fields and file-scope variables clang reports, keyed by name. The name is taken
as the word adjacent to the quoted type rather than by counting words after the source
range, because clang prefixes a decl with `used`, `referenced`, `implicit` or `constexpr`
whenever they apply and a positional match drops those lines.
"""
function oracle_members(path)
    fields, vars = Dict{String,String}(), Dict{String,String}()
    dump = read(pipeline(ignorestatus(`$(clang()) -Xclang -ast-dump -fsyntax-only
                                       -std=c++17 $path`); stderr=devnull), String)
    for line in split(dump, '\n')
        # The name is the word immediately before the quoted type. Anchoring just after
        # the range instead would miss any decl clang prefixes with a qualifier -- `used`,
        # `referenced`, `implicit`, `constexpr` -- and silently drop it from the oracle.
        k = match(r"\b(FieldDecl|VarDecl) 0x", line)
        k === nothing && continue
        nt = match(r"(\w+) '([^']+)'", line)
        nt === nothing && continue
        (k.captures[1] == "FieldDecl" ? fields : vars)[nt.captures[1]] = nt.captures[2]
    end
    return fields, vars
end

"What the wrappers say for fields and file-scope variables."
function wrapper_members(I)
    ctx = CC.getASTContext(CC.get_sema(I))
    fields, vars = Dict{String,String}(), Dict{String,String}()
    for d in CC.decls(CC.castToDeclContext(CC.getTranslationUnitDecl(ctx)))
        CC.isImplicit(d) && continue
        if d isa CC.FieldDecl
            fields[CC.getName(d)] = CC.printAsString(CC.getType(d), ctx)
        elseif d isa CC.VarDecl
            vars[CC.getName(d)] = CC.printAsString(CC.getType(d), ctx)
        end
    end
    return fields, vars
end

"What the wrappers say, keyed the same way."
function wrapper_facts(I)
    ctx = CC.getASTContext(CC.get_sema(I))
    sm = CC.getSourceManager(CC.get_sema(I))
    out = Dict{String,NamedTuple}()
    for d in CC.decls(CC.castToDeclContext(CC.getTranslationUnitDecl(ctx)))
        d isa CC.AbstractFunctionDecl || continue
        CC.isImplicit(d) && continue
        name = CC.getName(d)
        isempty(name) && continue
        b, e = CC.getBeginLoc(d), CC.getEndLoc(d)
        (CC.isValid(b) && CC.isValid(e)) || continue
        # printAsString uses the context's own PrintingPolicy, which is what the dump
        # prints under; getAsString uses clang's default policy and spells an empty
        # parameter list "(void)" where a C++ context spells it "()".
        out[name] = (type=CC.printAsString(CC.getType(d), ctx), beginline=Int(CC.getSpellingLineNumber(sm, b)),
                     endline=Int(CC.getSpellingLineNumber(sm, e)), params=Int(CC.getNumParams(d)))
    end
    return out
end

@testset "the dump parser survives a Windows path" begin
    # A drive letter puts a colon in front of everything, which is why the parser anchors
    # each range component at its end rather than scanning up to the first colon.
    posix = raw"`-FunctionDecl 0x60 </tmp/d.cpp:1:1, line:3:1> line:1:5 f 'int (int)'"
    win = raw"`-FunctionDecl 0x60 <D:\a\r\d.cpp:1:1, line:3:1> line:1:5 f 'int (int)'"
    for l in (posix, win)
        m = parse_decl_line(l)
        @test m !== nothing
        @test m.name == "f"
        @test m.type == "int (int)"
        @test m.beginline == 1
        @test m.endline == 3
    end
    # a one-line definition elides the line from the second component
    oneline = raw"`-FunctionDecl 0x60 <D:\a\r\d.cpp:7:1, col:29> col:5 g 'int ()'"
    m = parse_decl_line(oneline)
    @test m !== nothing
    @test m.beginline == 7
    @test m.endline == 7
    @test parse_decl_line("|-ParmVarDecl 0x1 <col:1> col:1 a 'int'") === nothing
end

@testset "member extraction survives clang's decl qualifiers" begin
    # clang prefixes a decl with used/referenced/implicit/constexpr whenever they apply.
    # Counting words after the source range silently drops those lines, which is how the
    # field comparison came back empty the first time.
    withq = raw"| |-FieldDecl 0x1 <line:2:5, col:9> col:9 referenced f 'int'"
    plain = raw"| |-FieldDecl 0x2 <line:3:5, col:12> col:12 g 'double'"
    var = raw"| `-VarDecl 0x3 <line:6:1, col:19> col:5 diff_global 'int' cinit"
    for (line, want_name, want_type) in ((withq, "f", "int"), (plain, "g", "double"), (var, "diff_global", "int"))
        @test match(r"\b(FieldDecl|VarDecl) 0x", line) !== nothing
        nt = match(r"(\w+) '([^']+)'", line)
        @test nt !== nothing
        @test nt.captures[1] == want_name
        @test nt.captures[2] == want_type
    end
end

@testset "differential: wrappers against clang's own AST dump" begin
    path = joinpath(mktempdir(), "diff_src.cpp")
    write(path, DIFF_SRC)

    oracle = oracle_facts(path)
    @test length(oracle) >= 5          # the dump parsed; a silent regex miss fails here

    I = create_interpreter(["-std=c++17"])
    CC.parse(I, DIFF_SRC)
    ours = wrapper_facts(I)
    @test length(ours) >= 5

    shared = sort!(collect(intersect(keys(oracle), keys(ours))))
    @test length(shared) >= 5          # the two readings agree on which functions exist

    for name in shared
        o, w = oracle[name], ours[name]
        # A function's signature, its parameter count, and where it starts and ends are
        # facts about the source. Two independent readings must agree on all four.
        @test w.type == o.type
        @test w.params == o.params
        @test w.beginline == o.beginline
        @test w.endline == o.endline
    end

    # Fields and file-scope variables, compared the same way. A record's fields are the
    # case where an index or a member accessor could silently return a sibling, and the
    # type spelling is what separates them.
    of, ov = oracle_members(path)
    wf, wv = wrapper_members(I)
    shared_f = sort!(collect(intersect(keys(of), keys(wf))))
    shared_v = sort!(collect(intersect(keys(ov), keys(wv))))
    @test length(shared_f) >= 2
    @test length(shared_v) >= 2
    for k in shared_f
        @test wf[k] == of[k]
    end
    for k in shared_v
        @test wv[k] == ov[k]
    end
    # DiffRec's fields are deliberately of different types, so a member accessor
    # returning the wrong one would change the spelling rather than go unnoticed
    @test length(unique(values(wf))) > 1

    # Multi-line definitions are the ones that make begin and end distinguishable at all: if
    # every function were one line, an accessor returning the wrong end would still match.
    @test any(name -> ours[name].endline > ours[name].beginline, shared)

    dispose(I)
end
