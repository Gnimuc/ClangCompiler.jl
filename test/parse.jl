using ClangCompiler
using ClangCompiler: create_interpreter, dispose
using ClangCompiler: parse_cxx_scope_spec, CXXScopeSpec, getScopeRep, getName, isValid, isEmpty, clear
using Test

@testset "Parse Decl" begin
    I = create_interpreter(["-include", "vector"])
    ss = CXXScopeSpec()

    id = parse_cxx_scope_spec(I, ss, "std::vector<int>::size_type")
    @test !isEmpty(ss)
    @test isValid(ss)
    @test getName(getScopeRep(ss)) == "std::vector<int>::"
    @test id == "size_type"
    clear(ss)

    id = parse_cxx_scope_spec(I, ss, "std::vector<int>::")
    @test !isEmpty(ss)
    @test isValid(ss)
    @test getName(getScopeRep(ss)) == "std::vector<int>::"
    @test id == ""
    clear(ss)

    id = parse_cxx_scope_spec(I, ss, "std::vector<int>")
    @test !isEmpty(ss)
    @test isValid(ss)
    @test getName(getScopeRep(ss)) == "std::"
    @test id == ""
    clear(ss)

    id = parse_cxx_scope_spec(I, ss, "std::vector")
    @test !isEmpty(ss)
    @test isValid(ss)
    @test getName(getScopeRep(ss)) == "std::"
    @test id == "vector"
    clear(ss)

    id = parse_cxx_scope_spec(I, ss, "std::")
    @test !isEmpty(ss)
    @test isValid(ss)
    @test getName(getScopeRep(ss)) == "std::"
    @test id == ""
    clear(ss)

    id = parse_cxx_scope_spec(I, ss, "std")
    @test isEmpty(ss)
    @test !isValid(ss)
    @test id == "std"
    clear(ss)

    id = parse_cxx_scope_spec(I, ss, "::std")
    @test !isEmpty(ss)
    @test isValid(ss)
    @test getName(getScopeRep(ss)) == "::"
    @test id == "std"
    clear(ss)

    dispose(ss)
    dispose(I)
end
