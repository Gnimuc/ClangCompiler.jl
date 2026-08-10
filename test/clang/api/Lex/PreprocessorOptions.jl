using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

const LXB_PPO = CC.LibClangEx

# PreprocessorOptions is a plain option bag: the defaults asserted here are the ones
# clang/Lex/PreprocessorOptions.h gives its members, and the rest are round trips. A
# throwaway CompilerInstance owns the bag, so nothing here touches a live interpreter.

@testset "PreprocessorOptions | defaults clang's own header fixes" begin
    ci = CC.CompilerInstance()
    ppo = CC.getPreprocessorOpts(ci)

    @test CC.getUsePredefines(ppo) == true
    @test CC.getDetailedRecord(ppo) == false
    @test CC.getPCHWithHdrStop(ppo) == false
    @test CC.getPCHWithHdrStopCreate(ppo) == false
    @test CC.getPCHThroughHeader(ppo) == ""
    @test CC.getImplicitPCHInclude(ppo) == ""
    @test CC.getDisablePCHOrModuleValidation(ppo) ==
          LXB_PPO.CXDisableValidationForModuleKind_None
    @test CC.getAllowPCHWithCompilerErrors(ppo) == false
    @test CC.getAllowPCHWithDifferentModulesCachePath(ppo) == false
    @test CC.getPrecompiledPreambleBytes(ppo) == (0, false)
    @test CC.getGeneratePreamble(ppo) == false
    @test CC.getSingleFileParseMode(ppo) == false
    @test CC.getRetainRemappedFileBuffers(ppo) == false
    @test isempty(CC.getRemappedFiles(ppo))
    @test isempty(CC.getRemappedFileBuffers(ppo))

    dispose(ci)
end

@testset "PreprocessorOptions | the PCH knobs round-trip" begin
    ci = CC.CompilerInstance()
    ppo = CC.getPreprocessorOpts(ci)

    # the three a PCH-consuming instance is configured through
    CC.setImplicitPCHInclude(ppo, "/tmp/probe.pch")
    @test CC.getImplicitPCHInclude(ppo) == "/tmp/probe.pch"
    CC.setDisablePCHOrModuleValidation(ppo, LXB_PPO.CXDisableValidationForModuleKind_PCH)
    @test CC.getDisablePCHOrModuleValidation(ppo) ==
          LXB_PPO.CXDisableValidationForModuleKind_PCH
    CC.setAllowPCHWithCompilerErrors(ppo, true)
    @test CC.getAllowPCHWithCompilerErrors(ppo) == true

    # the enum is a bitmask upstream, so All must be distinct from either half
    CC.setDisablePCHOrModuleValidation(ppo, LXB_PPO.CXDisableValidationForModuleKind_All)
    @test CC.getDisablePCHOrModuleValidation(ppo) ==
          LXB_PPO.CXDisableValidationForModuleKind_All
    @test LXB_PPO.CXDisableValidationForModuleKind_All !=
          LXB_PPO.CXDisableValidationForModuleKind_PCH

    CC.setPCHThroughHeader(ppo, "prefix.h")
    @test CC.getPCHThroughHeader(ppo) == "prefix.h"
    CC.setPCHWithHdrStop(ppo, true)
    @test CC.getPCHWithHdrStop(ppo) == true
    CC.setPCHWithHdrStopCreate(ppo, true)
    @test CC.getPCHWithHdrStopCreate(ppo) == true
    CC.setAllowPCHWithDifferentModulesCachePath(ppo, true)
    @test CC.getAllowPCHWithDifferentModulesCachePath(ppo) == true

    # the std::pair<unsigned,bool> crosses as two scalars, so both halves are set and read
    CC.setPrecompiledPreambleBytes(ppo, 1234, true)
    @test CC.getPrecompiledPreambleBytes(ppo) == (1234, true)
    CC.setPrecompiledPreambleBytes(ppo, 1234, false)
    @test CC.getPrecompiledPreambleBytes(ppo) == (1234, false)
    CC.setPrecompiledPreambleBytes(ppo, 0, false)
    @test CC.getPrecompiledPreambleBytes(ppo) == (0, false)

    CC.setGeneratePreamble(ppo, true)
    @test CC.getGeneratePreamble(ppo) == true
    CC.setUsePredefines(ppo, false)
    @test CC.getUsePredefines(ppo) == false
    CC.setDetailedRecord(ppo, true)
    @test CC.getDetailedRecord(ppo) == true
    CC.setSingleFileParseMode(ppo, true)
    @test CC.getSingleFileParseMode(ppo) == true

    # an empty string clears rather than being rejected
    CC.setImplicitPCHInclude(ppo, "")
    @test CC.getImplicitPCHInclude(ppo) == ""

    dispose(ci)
end

@testset "PreprocessorOptions | file remappings" begin
    ci = CC.CompilerInstance()
    ppo = CC.getPreprocessorOpts(ci)

    CC.addRemappedFile(ppo, "orig.h", "replacement.h")
    CC.addRemappedFile(ppo, "other.h", "other-replacement.h")
    @test CC.getRemappedFiles(ppo) ==
          ["orig.h" => "replacement.h", "other.h" => "other-replacement.h"]
    # the buffer form fills a different vector, so the path-to-path one is unchanged
    @test isempty(CC.getRemappedFileBuffers(ppo))

    buf = CC.LLVM.MemoryBuffer(Vector{UInt8}(codeunits("int remapped = 1;\n")),
                               "remap-probe", true)
    CC.addRemappedFile(ppo, "buffered.h", buf)
    @test CC.getRemappedFileBuffers(ppo) == ["buffered.h"]
    @test length(CC.getRemappedFiles(ppo)) == 2

    CC.setRetainRemappedFileBuffers(ppo, true)
    @test CC.getRetainRemappedFileBuffers(ppo) == true

    # clearing drops both vectors at once
    CC.clearRemappedFiles(ppo)
    @test isempty(CC.getRemappedFiles(ppo))
    @test isempty(CC.getRemappedFileBuffers(ppo))

    # the option bag only borrowed the buffer, so it is ours to release
    CC.LLVM.dispose(buf)
    dispose(ci)
end
