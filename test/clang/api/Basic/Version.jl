using ClangCompiler
import ClangCompiler as CC
using Test

@testset "Version | what the loaded libclang-cpp says about itself" begin
    full = CC.getClangFullVersion()
    @test !isempty(full)
    @test occursin("clang version", full)
    # The bindings under lib/<major>/ are generated against one clang release and the library
    # loaded at run time is whichever the artifact provides. This is the check that the two
    # are the same release, which is the whole reason these wrappers exist.
    @test occursin(string(Base.libllvm_version.major) * ".", full)

    # getClangFullVersion is getClangToolFullVersion("clang"), so substituting the tool name
    # changes exactly that word and leaves the version tail alone.
    tool = CC.getClangToolFullVersion("clangcompiler")
    @test occursin("clangcompiler version", tool)
    @test !occursin("clang version", tool)
    @test endswith(tool, last(split(full, "clang version "; limit=2)))

    # The vendor tag is the prefix of the banner, empty for an unbranded build.
    vendor = CC.getClangVendor()
    @test startswith(full, vendor)

    # The repository version, when the build recorded one, is part of the banner too.
    rev = CC.getClangRevision()
    @test isempty(rev) || occursin(rev, full)
    path = CC.getClangRepositoryPath()
    @test isempty(path) || occursin(path, full)
    # LLVM and clang normally live in one repository, and then the two revisions agree.
    llvm_rev = CC.getLLVMRevision()
    @test isempty(llvm_rev) || isempty(rev) || llvm_rev == rev

    # __VERSION__ carries the same release number as the banner.
    cpp = CC.getClangFullCPPVersion()
    @test !isempty(cpp)
    @test occursin(string(Base.libllvm_version.major) * ".", cpp)
end
