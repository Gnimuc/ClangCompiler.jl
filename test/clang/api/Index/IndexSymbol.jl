using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_tag, get_instance
using Test

const ISYM = CC.LibClangEx

@testset "Index | IndexSymbol" begin
    # The bitset printers need no AST at all, and the empty set is the one case with a
    # pinned answer: applyForEachSymbolRole visits nothing, so nothing is written.
    @test CC.printSymbolRoles(0) == ""
    @test CC.printSymbolProperties(0) == ""

    decl_role = CC.printSymbolRoles(UInt32(ISYM.CXSymbolRole_Declaration))
    def_role = CC.printSymbolRoles(UInt32(ISYM.CXSymbolRole_Definition))
    @test !isempty(decl_role)
    @test decl_role != def_role
    both = CC.printSymbolRoles(UInt32(ISYM.CXSymbolRole_Declaration) |
                               UInt32(ISYM.CXSymbolRole_Definition))
    @test occursin(decl_role, both)
    @test occursin(def_role, both)
    @test occursin(",", both)

    generic = CC.printSymbolProperties(UInt32(ISYM.CXSymbolProperty_Generic))
    @test !isempty(generic)
    @test occursin(generic,
                   CC.printSymbolProperties(UInt32(ISYM.CXSymbolProperty_Generic) |
                                            UInt32(ISYM.CXSymbolProperty_Local)))

    # Every kind, sub-kind and language has its own spelling: clang switches over the
    # enumerator, so two enumerators sharing a string would mean the mirror is misaligned.
    kinds = [CC.getSymbolKindString(k) for k in instances(ISYM.CXSymbolKind)]
    @test all(!isempty, kinds)
    @test length(unique(kinds)) == length(kinds)

    subkinds = [CC.getSymbolSubKindString(k) for k in instances(ISYM.CXSymbolSubKind)]
    @test all(!isempty, subkinds)
    @test length(unique(subkinds)) == length(subkinds)

    langs = [CC.getSymbolLanguageString(k) for k in instances(ISYM.CXSymbolLanguage)]
    @test all(!isempty, langs)
    @test length(unique(langs)) == length(langs)

    # Classification against a live AST.
    I = create_interpreter(String[])
    CC.parse(I, """
             namespace isym_ns { int isym_var = 1; }
             struct isym_struct { int isym_field; void isym_method(); };
             class isym_class { public: isym_class(); };
             enum isym_enum { isym_enumerator = 3 };
             int isym_fn(int a);
             template <typename T> T isym_tmpl(T a) { return a; }
             """)

    ci = get_instance(I)
    lo = CC.getLangOpts(ci)
    f = DeclFinder(I)

    # `get_decl` asserts the lookup is unique, and a function template is not: clang
    # resolves one to FoundOverloaded -- an overload set that happens to hold a single
    # FunctionTemplateDecl -- so the uniqueness gate rejects it even though there is exactly
    # one result. `get_decls` is the accessor that covers both, and asserting the count here
    # keeps the single-result expectation the callers rely on.
    function info_of(name)
        @test f(I, name)
        ds = CC.get_decls(f)
        @test length(ds) == 1
        return CC.getSymbolInfo(only(ds))
    end

    @test info_of("isym_fn").kind == ISYM.CXSymbolKind_Function
    @test info_of("isym_ns").kind == ISYM.CXSymbolKind_Namespace
    @test info_of("isym_enumerator").kind == ISYM.CXSymbolKind_EnumConstant

    # A `struct` and a `class` are different kinds even though both are CXXRecordDecls --
    # this is the tag keyword clang recorded, not the Decl class.
    @test f(I, "isym_struct")
    struct_info = CC.getSymbolInfo(get_tag(f))
    @test struct_info.kind == ISYM.CXSymbolKind_Struct
    @test f(I, "isym_class")
    class_info = CC.getSymbolInfo(get_tag(f))
    @test class_info.kind == ISYM.CXSymbolKind_Class
    @test class_info.lang == ISYM.CXSymbolLanguage_CXX
    @test f(I, "isym_enum")
    @test CC.getSymbolInfo(get_tag(f)).kind == ISYM.CXSymbolKind_Enum

    # A function template is still a Function, but carries the Generic property.
    tmpl = info_of("isym_tmpl")
    @test tmpl.kind == ISYM.CXSymbolKind_Function
    @test tmpl.properties & UInt32(ISYM.CXSymbolProperty_Generic) != 0
    @test occursin(CC.printSymbolProperties(UInt32(ISYM.CXSymbolProperty_Generic)),
                   CC.printSymbolProperties(tmpl.properties))

    # A plain function is not generic, so the two differ in exactly that bit.
    plain = info_of("isym_fn")
    @test plain.properties & UInt32(ISYM.CXSymbolProperty_Generic) == 0
    @test plain.subkind == ISYM.CXSymbolSubKind_None

    # The kind string of a classified decl agrees with the string of its own enumerator.
    @test CC.getSymbolKindString(plain.kind) == CC.getSymbolKindString(ISYM.CXSymbolKind_Function)

    # printSymbolName spells the decl; a namespace-scope function is spelled by its name.
    @test f(I, "isym_fn")
    fd = get_decl(f)
    @test occursin("isym_fn", CC.printSymbolName(fd, lo))

    # Neither a namespace-scope function nor a namespace lives inside a function body.
    @test CC.isFunctionLocalSymbol(fd) == false
    @test f(I, "isym_ns")
    @test CC.isFunctionLocalSymbol(get_decl(f)) == false
    # ...but its first parameter does, and clang records that as the Local property.
    param = CC.getParamDecl(CC.FunctionDecl(fd), 0)
    @test CC.isFunctionLocalSymbol(param) == true
    param_info = CC.getSymbolInfo(param)
    @test param_info.kind == ISYM.CXSymbolKind_Parameter
    @test param_info.properties & UInt32(ISYM.CXSymbolProperty_Local) != 0

    dispose(f)
    dispose(I)
end
