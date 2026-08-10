using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

@testset "stdlib::Header | the table of standard headers" begin
    v = CC.named(CC.StdlibHeader, "<vector>")
    @test v !== nothing
    @test CC.name(v) == "<vector>"

    # the C and C++ tables are separate: <vector> is not a C header, <stdio.h> is
    @test CC.named(CC.StdlibHeader, "<vector>", CC.CXStdlibLang_C) === nothing
    c = CC.named(CC.StdlibHeader, "<stdio.h>", CC.CXStdlibLang_C)
    @test c !== nothing
    @test CC.name(c) == "<stdio.h>"

    @test CC.named(CC.StdlibHeader, "<no_such_standard_header>") === nothing
    # a name without its angle brackets is not how the table spells headers
    @test CC.named(CC.StdlibHeader, "vector") === nothing

    hs = CC.all_(CC.StdlibHeader)
    n = Int(length(hs))
    @test n > 0
    names = Set(CC.name(CC.getHeader(hs, i)) for i in 0:(n - 1))
    @test "<vector>" in names
    @test "<string>" in names

    dispose(hs)
    dispose(c)
    dispose(v)
end

@testset "stdlib::Symbol | the table of standard symbols" begin
    s = CC.named(CC.StdlibSymbol, "std::", "vector")
    @test s !== nothing
    @test CC.scope(s) == "std::"
    @test CC.name(s) == "vector"
    @test CC.qualifiedName(s) == "std::vector"

    h = CC.header(s)
    @test h !== nothing
    @test CC.name(h) == "<vector>"

    hs = CC.headers(s)
    @test length(hs) >= 1
    @test "<vector>" in Set(CC.name(CC.getHeader(hs, i)) for i in 0:(Int(length(hs)) - 1))

    @test CC.named(CC.StdlibSymbol, "std::", "no_such_std_symbol") === nothing
    # the scope has to carry its trailing "::"
    @test CC.named(CC.StdlibSymbol, "std", "vector") === nothing

    syms = CC.all_(CC.StdlibSymbol)
    @test length(syms) > 0

    dispose(syms)
    dispose(hs)
    dispose(h)
    dispose(s)
end

@testset "stdlib::Recognizer | a decl mapped back to its standard symbol" begin
    I = create_interpreter(["-include", "vector"])
    f = DeclFinder(I)
    rec = CC.StdlibRecognizer()

    @test f(I, "std::vector")
    d = get_decl(f)
    sym = CC.recognize(rec, d)
    @test sym !== nothing
    @test CC.qualifiedName(sym) == "std::vector"
    h = CC.header(sym)
    @test h !== nothing
    @test CC.name(h) == "<vector>"

    # the negative half: a declaration of the program's own is not a standard symbol
    CC.parse(I, "struct CCStdlibProbeTag { int a; };")
    @test f(I, "CCStdlibProbeTag")
    @test CC.recognize(rec, get_decl(f)) === nothing

    dispose(h)
    dispose(sym)
    dispose(rec)
    dispose(f)
    dispose(I)
end
