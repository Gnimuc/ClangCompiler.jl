using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

@testset "FormatStyle | predefined styles" begin
    llvm = CC.getLLVMStyle()
    google = CC.getGoogleStyle()
    none = CC.getNoStyle()

    # the default language of every predefined style is C++
    @test CC.getLanguage(llvm) == CC.CXLanguageKind_LK_Cpp
    @test CC.getLanguage(google) == CC.CXLanguageKind_LK_Cpp

    # they are genuinely different configurations, not the same struct handed back twice
    @test CC.configurationAsText(llvm) != CC.configurationAsText(google)

    # the language a style was asked for is the language it reports, and setLanguage moves it
    json = CC.getLLVMStyle(CC.CXLanguageKind_LK_Json)
    @test CC.getLanguage(json) == CC.CXLanguageKind_LK_Json
    CC.setLanguage(json, CC.CXLanguageKind_LK_Cpp)
    @test CC.getLanguage(json) == CC.CXLanguageKind_LK_Cpp

    # "none" formats nothing, so it is the one style whose reformat is the identity
    messy = "int   a   =   1;"
    @test CC.reformat(none, messy)[1] == messy
    @test CC.reformat(llvm, messy)[1] != messy

    dispose(json)
    dispose(none)
    dispose(google)
    dispose(llvm)
end

@testset "FormatStyle | getPredefinedStyle" begin
    g = CC.getPredefinedStyle("google")
    @test g !== nothing
    # the name is matched case-insensitively and reaches the same style as getGoogleStyle
    gu = CC.getPredefinedStyle("GOOGLE")
    ref = CC.getGoogleStyle()
    @test CC.configurationAsText(g) == CC.configurationAsText(ref)
    @test CC.configurationAsText(gu) == CC.configurationAsText(ref)

    # a name clang does not know is a nothing, not an empty style
    @test CC.getPredefinedStyle("definitely-not-a-clang-format-style") === nothing

    dispose(ref)
    dispose(gu)
    dispose(g)
end

@testset "FormatStyle | configuration round trip" begin
    s = CC.getLLVMStyle()
    # a document that mentions one option leaves the rest of the style alone
    @test CC.parseConfiguration(s, "ColumnLimit: 20") == CC.CXParseError_Success
    @test occursin(r"ColumnLimit:\s*20", CC.configurationAsText(s))

    long = "void ccfmt(int aaaa, int bbbb, int cccc, int dddd);"
    default = CC.getLLVMStyle()
    narrow, _, _ = CC.reformat(s, long)
    wide, _, _ = CC.reformat(default, long)
    # the parsed column limit is what clang formatted against: the narrow style wraps
    @test count(==('\n'), narrow) > count(==('\n'), wide)
    dispose(default)

    # a document for another language cannot configure a C++ style
    cpp = CC.getLLVMStyle(CC.CXLanguageKind_LK_Cpp)
    @test CC.parseConfiguration(cpp, "---\nLanguage: JavaScript\nColumnLimit: 20\n...\n") == CC.CXParseError_Unsuitable

    dispose(cpp)
    dispose(s)
end

@testset "FormatStyle | getStyle" begin
    # the inline "{key: value}" form of clang-format's --style=
    s = CC.getStyle("{ColumnLimit: 33}", "ccfmt.cpp", "LLVM")
    @test s !== nothing
    @test occursin(r"ColumnLimit:\s*33", CC.configurationAsText(s))
    dispose(s)

    # a predefined name is also accepted, and reaches that style
    g = CC.getStyle("Google", "ccfmt.cpp", "LLVM")
    @test g !== nothing
    @test CC.getLanguage(g) == CC.CXLanguageKind_LK_Cpp
    dispose(g)

    # an unusable style name is a failure, not a fallback
    @test CC.getStyle("definitely-not-a-clang-format-style", "ccfmt.cpp", "LLVM") === nothing
end

@testset "format | guessLanguage and getLanguageName" begin
    @test CC.guessLanguage("ccfmt.cpp", "") == CC.CXLanguageKind_LK_Cpp
    @test CC.guessLanguage("ccfmt.js", "") == CC.CXLanguageKind_LK_JavaScript
    @test CC.guessLanguage("ccfmt.m", "") == CC.CXLanguageKind_LK_ObjC
    @test CC.guessLanguage("ccfmt.java", "") == CC.CXLanguageKind_LK_Java

    @test CC.getLanguageName(CC.CXLanguageKind_LK_Cpp) == "C++"
    @test CC.getLanguageName(CC.CXLanguageKind_LK_JavaScript) == "JavaScript"
    # LK_None has no name of its own
    @test CC.getLanguageName(CC.CXLanguageKind_LK_None) == "Unknown"
end

@testset "format | reformat" begin
    s = CC.getLLVMStyle()
    out, complete, line = CC.reformat(s, "int  ccfmtmain( ) {int   x=1;return x;}", "ccfmt.cpp")
    # clang reports a completed attempt, so it has no line to point at
    @test complete
    @test line == 0
    @test occursin("int ccfmtmain()", out)
    @test occursin("int x = 1;", out)

    # formatting is idempotent: the formatter's own output is already a fixed point
    again, _, _ = CC.reformat(s, out, "ccfmt.cpp")
    @test again == out
    dispose(s)
end

@testset "format | sortIncludes" begin
    s = CC.getLLVMStyle()
    code = "#include \"ccb.h\"\n#include \"cca.h\"\n\nint ccfmtx;\n"
    out = CC.sortIncludes(s, code, "ccfmt.cpp")
    @test first(findfirst("cca.h", out)) < first(findfirst("ccb.h", out))
    # already sorted input comes back unchanged
    @test CC.sortIncludes(s, out, "ccfmt.cpp") == out
    dispose(s)
end

@testset "format | fixNamespaceEndComments" begin
    s = CC.getLLVMStyle()
    code = "namespace ccfmtns {\nint a;\nint b;\nint c;\n}\n"
    out = CC.fixNamespaceEndComments(s, code, "ccfmt.cpp")
    @test occursin("} // namespace ccfmtns", out)
    # the fixer is idempotent once the comment is there
    @test CC.fixNamespaceEndComments(s, out, "ccfmt.cpp") == out
    dispose(s)
end

@testset "format | sortUsingDeclarations" begin
    s = CC.getLLVMStyle()
    code = "using ccfmtns::b;\nusing ccfmtns::a;\n"
    out = CC.sortUsingDeclarations(s, code, "ccfmt.cpp")
    @test first(findfirst("::a", out)) < first(findfirst("::b", out))
    dispose(s)
end

@testset "format | cleanup" begin
    s = CC.getLLVMStyle()
    # nothing to clean up: the text is handed straight back
    clean = "int ccfmty;\n"
    @test CC.cleanup(s, clean, "ccfmt.cpp") == clean

    # an empty namespace is exactly what cleanup exists to remove
    empty_ns = "namespace ccfmtA {\nnamespace ccfmtB {\n} // namespace ccfmtB\n} // namespace ccfmtA\n"
    out = CC.cleanup(s, empty_ns, "ccfmt.cpp")
    @test !occursin("ccfmtB", out)
    dispose(s)
end

@testset "format | replacement-driven entry points" begin
    s = CC.getLLVMStyle()

    # formatReplacements applies the script and then formats only what it touched
    code = "int  cca;\nint  ccb;\n"
    out = CC.formatReplacements(s, code, UInt32[0], UInt32[3], String["long"], "ccfmt.cpp")
    @test occursin("long cca;", out)

    # cleanupAroundReplacements is the #include insertion/removal entry point: an offset of
    # typemax(UInt32) with length 0 inserts a directive, and with length 1 removes a header
    inc = "#include \"ccaaa.h\"\nint ccx;\n"
    inserted = CC.cleanupAroundReplacements(s, inc, UInt32[typemax(UInt32)], UInt32[0], String["#include \"ccbbb.h\""],
                                            "ccfmt.cpp")
    @test occursin("ccbbb.h", inserted)
    @test occursin("ccaaa.h", inserted)

    removed = CC.cleanupAroundReplacements(s, inc, UInt32[typemax(UInt32)], UInt32[1], String["\"ccaaa.h\""],
                                           "ccfmt.cpp")
    @test !occursin("ccaaa.h", removed)

    # an empty script changes nothing
    @test CC.cleanupAroundReplacements(s, inc, UInt32[], UInt32[], String[], "ccfmt.cpp") == inc
    dispose(s)
end
