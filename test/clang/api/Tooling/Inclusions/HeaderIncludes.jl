using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: dispose
using Test

@testset "IncludeStyle | seeded from clang-format's LLVM style" begin
    style = CC.IncludeStyle()
    # clang's own struct has no in-class initialisers, so what matters here is that the shim
    # never hands out an indeterminate one: these are the LLVM style's values.
    @test CC.getIncludeBlocks(style) == CC.CXIncludeBlocksStyle_IBS_Preserve
    n = Int(CC.getNumIncludeCategories(style))
    @test n > 0
    @test !isempty(CC.getIncludeCategoryRegex(style, 0))
    @test !isempty(CC.getIncludeIsMainRegex(style))

    # round trips through clang's own fields
    CC.setIncludeBlocks(style, CC.CXIncludeBlocksStyle_IBS_Regroup)
    @test CC.getIncludeBlocks(style) == CC.CXIncludeBlocksStyle_IBS_Regroup
    CC.setIncludeIsMainRegex(style, "(_probe)?\$")
    @test CC.getIncludeIsMainRegex(style) == "(_probe)?\$"
    CC.setIncludeIsMainSourceRegex(style, "(Impl\\.hpp)\$")
    @test CC.getIncludeIsMainSourceRegex(style) == "(Impl\\.hpp)\$"

    CC.addIncludeCategory(style, "^<ccprobe/", 7, 3, true)
    @test CC.getNumIncludeCategories(style) == n + 1
    @test CC.getIncludeCategoryRegex(style, n) == "^<ccprobe/"
    @test CC.getIncludeCategoryPriority(style, n) == 7
    @test CC.getIncludeCategorySortPriority(style, n) == 3
    @test CC.getIncludeCategoryRegexIsCaseSensitive(style, n)

    CC.clearIncludeCategories(style)
    @test CC.getNumIncludeCategories(style) == 0

    dispose(style)
end

@testset "IncludeCategoryManager | which category an include falls in" begin
    style = CC.IncludeStyle()
    mgr = CC.IncludeCategoryManager(style, "a.cc")

    # The LLVM style sorts project headers first, then llvm/clang headers, then angled ones.
    # The relationship is what the categories mean; the numbers themselves are clang-format's.
    p_other = CC.getIncludePriority(mgr, "\"zzz.h\"", false)
    p_llvm = CC.getIncludePriority(mgr, "\"llvm/ADT/StringRef.h\"", false)
    p_angled = CC.getIncludePriority(mgr, "<vector>", false)
    @test p_other < p_llvm < p_angled

    # the main header of a.cc, and only when the caller asks for main-header detection
    @test CC.getIncludePriority(mgr, "\"a.h\"", true) == 0
    @test CC.getIncludePriority(mgr, "\"a.h\"", false) != 0
    # an unrelated header is never the main one
    @test CC.getIncludePriority(mgr, "\"b.h\"", true) != 0

    @test CC.getSortIncludePriority(mgr, "\"a.h\"", true) == 0

    dispose(mgr)
    dispose(style)
end

@testset "HeaderIncludes | inserting and removing directives" begin
    style = CC.IncludeStyle()
    code = "#include \"a.h\"\n#include <vector>\n\nint x;\n"
    hi = CC.HeaderIncludes("a.cc", code, style)

    r = CC.insert(hi, "map", true, CC.CXIncludeDirective_Include)
    @test r !== nothing
    @test CC.getFilePath(r) == "a.cc"
    @test occursin("#include <map>", CC.getReplacementText(r))
    # the edit lands inside the existing include block, not at the end of the buffer
    @test CC.getOffset(r) < length(code)

    imported = CC.insert(hi, "map", true, CC.CXIncludeDirective_Import)
    @test imported !== nothing
    @test occursin("#import <map>", CC.getReplacementText(imported))

    # a header already included with exactly this spelling gives std::nullopt
    @test CC.insert(hi, "vector", true) === nothing
    # ... but the same name with the other quoting is a different spelling
    quoted = CC.insert(hi, "vector", false)
    @test quoted !== nothing
    @test occursin("#include \"vector\"", CC.getReplacementText(quoted))

    # removal is spelling-exact too
    rem = CC.remove(hi, "vector", true)
    @test CC.size(rem) == 1
    only_edit = CC.getReplacement(rem, 0)
    @test CC.getReplacementText(only_edit) == ""
    @test CC.getLength(only_edit) > 0

    nothing_to_remove = CC.remove(hi, "map", true)
    @test CC.empty(nothing_to_remove)

    # the replacements HeaderIncludes computes are the same value type Replacements holds,
    # so they compose with the conflict-checked set
    rs = CC.Replacements()
    ok, msg = CC.add(rs, r)
    @test ok
    @test isempty(msg)
    okc, newcode = CC.applyAllReplacements(code, rs)
    @test okc
    @test occursin("#include <map>", newcode)
    @test occursin("#include <vector>", newcode)

    dispose(rs)
    dispose(nothing_to_remove)
    dispose(rem)
    dispose(quoted)
    dispose(imported)
    dispose(r)
    dispose(hi)
    dispose(style)
end
