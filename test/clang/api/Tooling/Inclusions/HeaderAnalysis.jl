using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, get_instance
using Test

@testset "parseIWYUPragma | an IWYU directive out of a comment" begin
    @test CC.parseIWYUPragma("// IWYU pragma: keep") == "keep"
    # a block comment loses its terminator and the whitespace around it
    @test CC.parseIWYUPragma("/* IWYU pragma: export */") == "export"
    # only the first line of a multi-line comment is considered
    @test CC.parseIWYUPragma("// IWYU pragma: private\nnot part of it") == "private"

    # the three ways of not being an IWYU pragma, each answering nothing rather than ""
    @test CC.parseIWYUPragma("// just a comment") === nothing
    @test CC.parseIWYUPragma("IWYU pragma: keep") === nothing
    @test CC.parseIWYUPragma("") === nothing
end

@testset "codeContainsImports | #import versus #include" begin
    @test CC.codeContainsImports("#import <Foundation/Foundation.h>\n")
    @test !CC.codeContainsImports("#include <stdio.h>\nint x;\n")
    @test !CC.codeContainsImports("")
end

@testset "isSelfContainedHeader | which headers the parser can be handed alone" begin
    dir = mktempdir()
    guarded = joinpath(dir, "ccselfcontained.h")
    write(guarded, "#pragma once\nint ccselfcontained_marker;\n")
    unguarded = joinpath(dir, "ccunguarded.h")
    write(unguarded, "int ccunguarded_marker;\n")

    I = create_interpreter(["-I" * dir])
    # the guard state lives in HeaderSearch's per-file info, so both headers have to have
    # been read before the question means anything
    CC.parse(I, "#include \"ccselfcontained.h\"\n#include \"ccunguarded.h\"\n")

    ci = get_instance(I)
    sm = CC.getSourceManager(ci)
    hs = CC.getHeaderSearchInfo(CC.getPreprocessor(ci))
    fm = CC.getFileManager(ci)

    g = CC.getFileRef(fm, guarded)
    u = CC.getFileRef(fm, unguarded)

    # `#pragma once` is a guard; nothing at all is not
    @test CC.isSelfContainedHeader(g, sm, hs)
    @test !CC.isSelfContainedHeader(u, sm, hs)

    dispose(u)
    dispose(g)
    dispose(I)
end
