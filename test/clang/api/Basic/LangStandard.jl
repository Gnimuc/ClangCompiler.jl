using ClangCompiler
import ClangCompiler as CC
using Test

# LangStandard is a static table: nothing here needs an interpreter, a target or a
# CompilerInstance, and every answer is decided by clang/Basic/LangStandards.def.

@testset "LangStandard | the -std= name table" begin
    # The name a standard is selected by, and the aliases that resolve to the same entry.
    @test CC.getLangKind("c++17") == CC.CXLangStandardKind_lang_cxx17
    @test CC.getLangKind("gnu++17") == CC.CXLangStandardKind_lang_gnucxx17
    @test CC.getLangKind("c99") == CC.CXLangStandardKind_lang_c99
    # LANGSTANDARD_ALIAS(c89, "c90") and (c99, "iso9899:1999"): an alias adds no entry, it
    # resolves to the one it names.
    @test CC.getLangKind("c90") == CC.CXLangStandardKind_lang_c89
    @test CC.getLangKind("iso9899:1999") == CC.CXLangStandardKind_lang_c99
    # and a name clang knows nothing about is the one answer that is not a standard
    @test CC.getLangKind("c++42") == CC.CXLangStandardKind_lang_unspecified

    # The by-name lookup goes through getLangKind, so the two agree, and the miss that
    # answers lang_unspecified there answers `nothing` here.
    std = CC.getLangStandardForName("c++17")
    @test std !== nothing
    @test CC.getName(std) == "c++17"
    @test CC.getLangStandardForName("c++42") === nothing

    # The kind and the name are two spellings of one entry, so the round trip closes.
    @test CC.getName(CC.getLangStandardForKind(CC.getLangKind("gnu++17"))) == "gnu++17"

    # lang_unspecified names no entry at all: clang answers it with report_fatal_error,
    # which would take the process down, so the wrapper refuses first.
    @test_throws AssertionError CC.getLangStandardForKind(CC.CXLangStandardKind_lang_unspecified)
end

@testset "LangStandard | the feature bits of an entry" begin
    cxx17 = CC.getLangStandardForKind(CC.CXLangStandardKind_lang_cxx17)
    gnucxx17 = CC.getLangStandardForKind(CC.CXLangStandardKind_lang_gnucxx17)
    c89 = CC.getLangStandardForKind(CC.CXLangStandardKind_lang_c89)
    c99 = CC.getLangStandardForKind(CC.CXLangStandardKind_lang_c99)
    cl12 = CC.getLangStandardForKind(CC.CXLangStandardKind_lang_opencl12)

    @test CC.getLanguage(cxx17) == CC.CXLanguage_CXX
    @test CC.getLanguage(c99) == CC.CXLanguage_C
    @test CC.getLanguage(cl12) == CC.CXLanguage_OpenCL
    @test CC.getDescription(cxx17) == "ISO C++ 2017 with amendments"

    # The C++ feature bits are cumulative up to the standard's own level and stop there.
    @test CC.isCPlusPlus(cxx17)
    @test CC.isCPlusPlus11(cxx17)
    @test CC.isCPlusPlus14(cxx17)
    @test CC.isCPlusPlus17(cxx17)
    @test !CC.isCPlusPlus20(cxx17)
    @test !CC.isCPlusPlus23(cxx17)
    @test !CC.isCPlusPlus26(cxx17)

    # gnu++17 is c++17 plus exactly one bit, which is the whole difference between them.
    for f in (CC.isCPlusPlus, CC.isCPlusPlus11, CC.isCPlusPlus14, CC.isCPlusPlus17,
              CC.isCPlusPlus20, CC.hasLineComments, CC.hasDigraphs, CC.hasHexFloats)
        @test f(cxx17) == f(gnucxx17)
    end
    @test !CC.isGNUMode(cxx17)
    @test CC.isGNUMode(gnucxx17)

    # LANGSTANDARD(c89, ..., 0): the one entry with no feature bits at all.
    @test !CC.hasLineComments(c89)
    @test !CC.isC99(c89)
    @test !CC.hasDigraphs(c89)
    @test !CC.isCPlusPlus(c89)
    @test !CC.isGNUMode(c89)

    # c99 turns three of them on and leaves the later C levels off.
    @test CC.hasLineComments(c99)
    @test CC.isC99(c99)
    @test CC.hasDigraphs(c99)
    @test CC.hasHexFloats(c99)
    @test !CC.isC11(c99)
    @test !CC.isC17(c99)
    @test !CC.isC23(c99)
    @test !CC.isCPlusPlus(c99)

    # OpenCL is the only family with the OpenCL bit, and it is a C99 superset.
    @test CC.isOpenCL(cl12)
    @test CC.isC99(cl12)
    @test !CC.isOpenCL(c99)
end

@testset "LangStandard | language names and per-language defaults" begin
    langs = [CC.CXLanguage_Unknown, CC.CXLanguage_Asm, CC.CXLanguage_LLVM_IR,
             CC.CXLanguage_C, CC.CXLanguage_CXX, CC.CXLanguage_ObjC, CC.CXLanguage_ObjCXX,
             CC.CXLanguage_OpenCL, CC.CXLanguage_OpenCLCXX, CC.CXLanguage_CUDA,
             CC.CXLanguage_RenderScript, CC.CXLanguage_HIP, CC.CXLanguage_HLSL]
    names = map(CC.languageToString, langs)
    # Every language has a name and no two share one: a shim returning a constant, or one
    # off by an enumerator, fails here.
    @test all(!isempty, names)
    @test length(unique(names)) == length(names)

    triple = "x86_64-unknown-linux-gnu"
    # The default for these four is a standard of that same language. It is not a universal
    # rule -- ObjC defaults to a C standard, and C++ for OpenCL's own table entry is filed
    # under OpenCL -- so the languages where it does hold are the ones named here.
    for lang in (CC.CXLanguage_C, CC.CXLanguage_CXX, CC.CXLanguage_OpenCL,
                 CC.CXLanguage_HLSL)
        kind = CC.getDefaultLanguageStandard(lang, triple)
        @test kind != CC.CXLangStandardKind_lang_unspecified
        @test CC.getLanguage(CC.getLangStandardForKind(kind)) == lang
    end
    # and C++ defaults to a C++ standard while C does not
    @test CC.isCPlusPlus(CC.getLangStandardForKind(
        CC.getDefaultLanguageStandard(CC.CXLanguage_CXX, triple)))
    @test !CC.isCPlusPlus(CC.getLangStandardForKind(
        CC.getDefaultLanguageStandard(CC.CXLanguage_C, triple)))

    # Neither of these has a default standard; clang answers both with llvm_unreachable.
    @test_throws AssertionError CC.getDefaultLanguageStandard(CC.CXLanguage_Unknown, triple)
    @test_throws AssertionError CC.getDefaultLanguageStandard(CC.CXLanguage_LLVM_IR, triple)
end
