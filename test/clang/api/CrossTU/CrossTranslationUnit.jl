using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

@testset "CrossTU | index files" begin
    idx = CC.CrossTUIndex()
    @test CC.getNumEntries(idx) == 0
    @test CC.lookup(idx, "c:@F@absent#") == ""

    idx["c:@F@ctu_one#"] = "/tmp/one.ast"
    idx["c:@F@ctu_two#"] = "/tmp/two.ast"
    @test CC.getNumEntries(idx) == 2
    @test CC.lookup(idx, "c:@F@ctu_one#") == "/tmp/one.ast"
    @test CC.lookup(idx, "c:@F@ctu_two#") == "/tmp/two.ast"
    @test CC.lookup(idx, "c:@F@absent#") == ""

    # A second write to the same key replaces rather than appends.
    idx["c:@F@ctu_one#"] = "/tmp/other.ast"
    @test CC.getNumEntries(idx) == 2
    @test CC.lookup(idx, "c:@F@ctu_one#") == "/tmp/other.ast"

    # The index enumeration agrees with the lookups, whatever bucket order it uses.
    by_index = Dict(CC.getUSR(idx, i) => CC.getFilePath(idx, i) for i = 0:1)
    @test by_index == Dict("c:@F@ctu_one#" => "/tmp/other.ast", "c:@F@ctu_two#" => "/tmp/two.ast")
    @test_throws AssertionError CC.getUSR(idx, 2)
    @test_throws AssertionError CC.getFilePath(idx, 2)

    # Render and re-read: the file format is the round trip's only witness, so parsing back
    # what was written has to reproduce the map exactly.
    text = CC.createCrossTUIndexString(idx)
    @test occursin("c:@F@ctu_one#", text)
    @test occursin("/tmp/other.ast", text)

    mktempdir() do dir
        path = joinpath(dir, "externalDefMap.txt")
        write(path, text)
        back = CC.parseCrossTUIndex(path)
        @test back !== nothing
        @test CC.getNumEntries(back) == CC.getNumEntries(idx)
        @test CC.lookup(back, "c:@F@ctu_one#") == "/tmp/other.ast"
        @test CC.lookup(back, "c:@F@ctu_two#") == "/tmp/two.ast"
        CC.dispose(back)

        # A missing file is a null, not an exception and not an empty index.
        @test CC.parseCrossTUIndex(joinpath(dir, "no-such-index.txt")) === nothing
    end

    CC.dispose(idx)
end

@testset "CrossTU | context over a live AST" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             int ctu_declared_only(int a);
             int ctu_defined_here(int a) { return a + 1; }
             extern const int ctu_extern_var;
             const int ctu_local_var = 5;
             struct ctu_nontrivial { ctu_nontrivial() : x(1) {} int x; };
             ctu_nontrivial ctu_nontrivial_var;
             """)

    ci = get_instance(I)
    ctx = CC.get_ast_context(I)
    f = DeclFinder(I)

    # getLookupName is clang's own index key, and clang computes it with the very USR
    # generator this package already wraps -- so the two must agree, decl for decl. That
    # agreement is the invariant, and it holds even where there is no key at all.
    #
    # Which is the case worth separating: a USR names an entity ACROSS translation units, so
    # an internal-linkage one has none and the generator returns "". `ctu_local_var` is
    # `static`, so it is exactly that case -- and getLookupName returns "" for it too, which
    # is the agreement still holding rather than the check being skipped. Asserting
    # non-emptiness for all three read as a stronger test but only described the two
    # externally-visible ones.
    for name in ("ctu_declared_only", "ctu_defined_here")
        @test f(I, name)
        d = get_decl(f)
        usr = CC.generateUSRForDecl(d)
        @test !isempty(usr)
        @test CC.getLookupName(d) == usr
    end
    @test f(I, "ctu_local_var")
    let d = get_decl(f)
        @test isempty(CC.generateUSRForDecl(d))     # internal linkage: no cross-TU identity
        @test CC.getLookupName(d) == CC.generateUSRForDecl(d)
    end

    # shouldImport refuses a variable whose type has a non-trivial constructor, because
    # running that constructor in the importing TU would have side effects. A const int has
    # no such problem, so the two answers must differ.
    @test f(I, "ctu_nontrivial_var")
    nontrivial = CC.VarDecl(get_decl(f))
    @test CC.shouldImport(nontrivial, ctx) == false
    @test f(I, "ctu_local_var")
    trivial = CC.VarDecl(get_decl(f))
    @test CC.shouldImport(trivial, ctx) != CC.shouldImport(nontrivial, ctx)

    ctu = CC.CrossTranslationUnitContext(ci)
    @test ctu.ptr != C_NULL

    # Nothing has been imported through this context, so no decl of the current AST is
    # either newly created or marked with an import error.
    @test f(I, "ctu_defined_here")
    defined = CC.FunctionDecl(get_decl(f))
    @test CC.isImportedAsNew(ctu, defined) == false
    @test CC.hasError(ctu, defined) == false

    # The lookup exists precisely for a decl with no body here; one that has a body trips
    # clang's own assertion, so the wrapper refuses it first.
    @test_throws AssertionError CC.getCrossTUDefinition(ctu, defined, ".", "index.txt")
    # ...and the import is the mirror image: only a decl that HAS a body can be imported.
    @test f(I, "ctu_declared_only")
    declared = CC.FunctionDecl(get_decl(f))
    @test CC.hasBody(declared) == false

    mktempdir() do dir
        # No index file in `dir`, so every lookup fails cleanly rather than throwing.
        @test CC.getCrossTUDefinition(ctu, declared, dir, "externalDefMap.txt") === nothing
        @test CC.loadExternalAST(ctu, CC.getLookupName(declared), dir, "externalDefMap.txt") === nothing

        @test f(I, "ctu_extern_var")
        extern_var = CC.VarDecl(get_decl(f))
        @test CC.hasInit(extern_var) == false
        @test CC.getCrossTUDefinition(ctu, extern_var, dir, "externalDefMap.txt") === nothing
        # ...while the one that is already initialised here is refused before clang sees it.
        @test_throws AssertionError CC.getCrossTUDefinition(ctu, trivial, dir, "externalDefMap.txt")
    end

    CC.dispose(ctu)
    dispose(f)
    dispose(I)
end
