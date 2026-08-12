using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, get_instance
using Test

"The kind names of every token in `list`, in order."
kind_names(list) = [CC.getTokenName(CC.getKind(CC.getToken(list, i))) for i = 0:(Int(length(list)) - 1)]

@testset "syntax::tokenize | the tokens as written" begin
    dir = mktempdir()
    path = joinpath(dir, "cctokens.cpp")
    write(path, "int a = 1;\n")

    I = create_interpreter(String[])
    ci = get_instance(I)
    sm = CC.getSourceManager(ci)
    lo = CC.getLangOpts(ci)
    fm = CC.getFileManager(ci)

    fer = CC.getFileRef(fm, path)
    fid = CC.FileID(sm, fer)

    toks = CC.tokenize(fid, sm, lo)
    @test length(toks) == 5
    # raw lexing still resolves keywords, so `int` is kw_int and not a raw identifier
    @test kind_names(toks) == ["int", "identifier", "equal", "numeric_constant", "semi"]

    t0 = CC.getToken(toks, 0)
    @test CC.getLength(t0) == 3
    @test CC.text(t0, sm) == "int"
    @test CC.isValid(CC.getLocation(t0))
    @test CC.text(CC.getToken(toks, 1), sm) == "a"
    # endLocation is location advanced by the token's length, so the two differ for a
    # non-empty token
    @test CC.getLocation(t0) != CC.getEndLocation(t0)
    @test !isempty(CC.str(t0))

    # the FileRange overload lexes only the slice it is given
    head = CC.tokenize(fid, 0, 3, sm, lo)
    @test length(head) == 1
    @test CC.text(CC.getToken(head, 0), sm) == "int"

    dispose(head)
    dispose(toks)
    dispose(fid)
    dispose(fer)
    dispose(I)
end

@testset "syntax::tokenize | raw mode does not preprocess" begin
    dir = mktempdir()
    path = joinpath(dir, "cctokens_macro.cpp")
    write(path, "#define FOO 1\nint x = FOO;\n")

    I = create_interpreter(String[])
    ci = get_instance(I)
    sm = CC.getSourceManager(ci)
    lo = CC.getLangOpts(ci)
    fm = CC.getFileManager(ci)

    fer = CC.getFileRef(fm, path)
    fid = CC.FileID(sm, fer)
    toks = CC.tokenize(fid, sm, lo)

    # the directive is lexed as ordinary tokens rather than consumed: `#`, `define`, `FOO`,
    # `1`, then the five of the declaration
    @test length(toks) == 9
    names = kind_names(toks)
    @test names[1] == "hash"
    @test names[end] == "semi"
    # and the use of FOO is still spelled FOO -- nothing was expanded
    @test CC.text(CC.getToken(toks, 7), sm) == "FOO"
    @test count(==("identifier"), names) == 4

    dispose(toks)
    dispose(fid)
    dispose(fer)
    dispose(I)
end
