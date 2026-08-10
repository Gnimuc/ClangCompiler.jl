using ClangCompiler
import ClangCompiler as CC
using Test

# driver::types and driver::phases are pure functions over clang/Driver/Types.def, so
# nothing here needs a driver, a toolchain or an interpreter.

@testset "driver types | classifying an input the way the driver does" begin
    last_id = CC.getLastTypeID()
    @test last_id > 1

    cxx = CC.lookupTypeForExtension("cpp")
    c = CC.lookupTypeForExtension("c")
    ir = CC.lookupTypeForExtension("ll")

    # TYPE("c++", CXX, PP_CXX, "cpp", ...) in clang/Driver/Types.def
    @test CC.getTypeName(cxx) == "c++"
    @test CC.getTypeName(c) == "c"
    @test CC.getTypeName(ir) == "ir"
    @test CC.getTypeTempSuffix(cxx) == "cpp"
    @test CC.getTypeTempSuffix(ir) == "ll"

    # The three predicates partition these three, each way round.
    @test CC.isCXX(cxx)
    @test !CC.isCXX(c)
    @test !CC.isCXX(ir)
    @test CC.isLLVMIR(ir)
    @test !CC.isLLVMIR(cxx)
    @test CC.isAcceptedByClang(cxx)
    @test CC.isAcceptedByClang(c)

    # A source file is one that still has to be preprocessed, so the preprocessed form of a
    # source is not itself one.
    pp_cxx = CC.getPreprocessedType(cxx)
    @test pp_cxx != 0
    @test CC.getTypeName(pp_cxx) == "c++-cpp-output"
    @test CC.isSrcFile(cxx)
    @test !CC.isSrcFile(pp_cxx)
    @test CC.getPreprocessedType(pp_cxx) == 0
    @test CC.isCXX(pp_cxx)

    # An extension and a -x specifier that name nothing answer TY_INVALID rather than
    # throwing, and TY_INVALID is exactly what the accessors refuse.
    @test CC.lookupTypeForExtension("clangcompiler-no-such-ext") == 0
    @test CC.lookupTypeForTypeSpecifier("clangcompiler-no-such-type") == 0
    @test CC.lookupTypeForTypeSpecifier("c++") == cxx

    # clang indexes the table with a bare assert, so the wrapper is what keeps 0 and TY_LAST
    # out of it.
    @test_throws AssertionError CC.getTypeName(0)
    @test_throws AssertionError CC.getTypeName(last_id)
    @test_throws AssertionError CC.isCXX(0)
    @test_throws AssertionError CC.getCompilationPhases(last_id)
end

@testset "driver phases | what the driver would run for a type" begin
    cxx = CC.lookupTypeForExtension("cpp")
    pp_cxx = CC.getPreprocessedType(cxx)

    # TYPE("c++", CXX, PP_CXX, "cpp", Preprocess, Compile, Backend, Assemble, Link)
    @test CC.getCompilationPhases(cxx) == [CC.CXPhaseID_Preprocess, CC.CXPhaseID_Compile,
                                           CC.CXPhaseID_Backend, CC.CXPhaseID_Assemble,
                                           CC.CXPhaseID_Link]
    # the preprocessed form drops exactly the phase that produced it
    @test CC.getCompilationPhases(pp_cxx) == [CC.CXPhaseID_Compile, CC.CXPhaseID_Backend,
                                              CC.CXPhaseID_Assemble, CC.CXPhaseID_Link]

    # LastPhase truncates the list, and truncating is all it does.
    all_phases = CC.getCompilationPhases(cxx)
    upto = CC.getCompilationPhases(cxx, CC.CXPhaseID_Compile)
    @test upto == filter(p -> Int(p) <= Int(CC.CXPhaseID_Compile), all_phases)
    @test length(upto) < length(all_phases)
    @test length(all_phases) <= CC.getMaxNumberOfPhases()

    # Every phase has a name and no two share one.
    phases = [CC.CXPhaseID_Preprocess, CC.CXPhaseID_Precompile, CC.CXPhaseID_Compile,
              CC.CXPhaseID_Backend, CC.CXPhaseID_Assemble, CC.CXPhaseID_Link,
              CC.CXPhaseID_IfsMerge]
    @test length(phases) == CC.getMaxNumberOfPhases()
    names = map(CC.getPhaseName, phases)
    @test all(!isempty, names)
    @test length(unique(names)) == length(names)
end
