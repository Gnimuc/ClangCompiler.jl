using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

const LX = CC.LibClangEx

@testset "Attr hierarchy table" begin
    # Re-parse the vendored AttrList.inc as an independent oracle and check the
    # generated carriers (src/clang/core/AST/AttrCarriers.jl) against it: every clang
    # attribute has a `<Name>Attr` carrier subtyping the abstract of its C++
    # base category. This is the same source gen/attr_nodes.jl reads, parsed
    # separately here so a generator mistake can't validate itself.
    macro_to_category = Dict("ATTR" => :Attr, "TYPE_ATTR" => :TypeAttr,
                             "STMT_ATTR" => :StmtAttr, "DECL_OR_STMT_ATTR" => :DeclOrStmtAttr,
                             "INHERITABLE_ATTR" => :InheritableAttr, "DECL_OR_TYPE_ATTR" => :InheritableAttr,
                             "INHERITABLE_PARAM_ATTR" => :InheritableParamAttr,
                             "PARAMETER_ABI_ATTR" => :ParameterABIAttr,
                             "HLSL_ANNOTATION_ATTR" => :HLSLAnnotationAttr)
    inc = joinpath(pkgdir(ClangCompiler), "deps", "ClangExtra", "include", "clang-ex", "AST", "AttrList.inc")
    entry_re = r"^([A-Z][A-Z0-9_]*)\((\w+)\)$"
    count = 0
    for line in eachline(inc)
        m = match(entry_re, strip(line))
        m === nothing && continue
        m.captures[1] == "PRAGMA_SPELLING_ATTR" && continue
        category = get(macro_to_category, m.captures[1], nothing)
        category === nothing && error("unknown AttrList.inc macro: $(m.captures[1])")
        T = getfield(CC, Symbol(m.captures[2], "Attr"))
        A = getfield(CC, category === :Attr ? :AbstractAttr : Symbol("Abstract", category))
        @test T <: A
        @test A <: CC.AbstractAttr
        count += 1
    end
    # every attribute kind has a carrier in the resolve map
    @test length(CC.ATTR_KIND_TO_TYPE) == count
    @test CC.Attr <: CC.AbstractAttr
end
