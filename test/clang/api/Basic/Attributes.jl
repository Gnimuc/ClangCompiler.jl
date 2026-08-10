using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, get_instance
using Test

@testset "hasAttribute | which attributes this clang implements" begin
    I = create_interpreter(String[])
    ci = get_instance(I)
    pp = CC.getPreprocessor(ci)
    target = CC.getTarget(ci)
    lang_opts = CC.getLangOpts(ci)

    ii(name) = CC.getIdentifierInfo(pp, name)

    # `pure` is a GNU attribute, so the three arguments that decide the answer each change
    # it: __attribute__((pure)) is implemented, the unscoped C++11 spelling [[pure]] is not
    # an attribute at all, and [[gnu::pure]] is the same GNU attribute again.
    @test CC.hasAttribute(CC.CXAttributeCommonInfoSyntax_AS_GNU, nothing, ii("pure"),
                          target, lang_opts) > 0
    @test CC.hasAttribute(CC.CXAttributeCommonInfoSyntax_AS_CXX11, nothing, ii("pure"),
                          target, lang_opts) == 0
    @test CC.hasAttribute(CC.CXAttributeCommonInfoSyntax_AS_CXX11, ii("gnu"), ii("pure"),
                          target, lang_opts) > 0

    # A standard C++11 attribute answers in the unscoped spelling, and its version number is
    # the paper's year-and-month rather than a bare 1.
    nodiscard = CC.hasAttribute(CC.CXAttributeCommonInfoSyntax_AS_CXX11, nothing,
                                ii("nodiscard"), target, lang_opts)
    @test nodiscard > 0

    # A name clang knows nothing about is 0 in every syntax, which is the answer
    # __has_attribute gives.
    for syntax in (CC.CXAttributeCommonInfoSyntax_AS_GNU,
                   CC.CXAttributeCommonInfoSyntax_AS_CXX11,
                   CC.CXAttributeCommonInfoSyntax_AS_C23,
                   CC.CXAttributeCommonInfoSyntax_AS_Declspec)
        @test CC.hasAttribute(syntax, nothing, ii("clangcompiler_not_an_attribute"), target,
                              lang_opts) == 0
    end

    # A scope clang knows nothing about is 0 too, even when the attribute name alone is one
    # it implements.
    @test CC.hasAttribute(CC.CXAttributeCommonInfoSyntax_AS_CXX11,
                          ii("clangcompiler_not_a_scope"), ii("pure"), target,
                          lang_opts) == 0

    dispose(I)
end
