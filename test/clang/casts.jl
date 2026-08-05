using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, find_decl, top_level_decls
using Test

# The cast surface as a whole: what `src/clang/casts.jl` promises, held against clang.
#
# Each hierarchy's per-class tests live beside its wrappers (`api/AST/Stmt.jl` sweeps the
# stamped Stmt casts, `api/AST/Attr.jl` the Attr ones). What is here is the part that is a
# property of the *design* rather than of any one class: that widening needs no spelling,
# that narrowing is checked and says what it found, and that Julia's own subtype relation
# already answers the question the casts are usually reached for.

@testset "crossing the hierarchy" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             namespace cst {
             struct Widget {
                 int w;
                 double area() const;
                 Widget();
             };
             int twice(int v) { return 2 * v; }
             typedef Widget Alias;
             Widget g_w;
             Alias  g_alias;
             }
             """)
    ctx = CC.get_ast_context(I)

    fd = find_decl(I, "cst::twice")
    rd = find_decl(I, "cst::Widget")
    # clang adds implicit copy/move members beside the two written ones, so pick by name
    members = [CC.resolve(d) for d in CC.decls_in(CC.castToDeclContext(rd))]
    method = only(m for m in members if m isa CC.CXXMethodDecl &&
                                        CC.getNameAsString(m) == "area")
    ctor = only(m for m in members if m isa CC.CXXConstructorDecl && CC.getNumParams(m) == 0)

    @testset "widening is not spelled" begin
        # `getLocation`/`getNameAsString` are declared at `AbstractDecl`/`AbstractNamedDecl`.
        # A CXXRecordDecl reaches both with nothing written, because marshalling is keyed on
        # the abstract types — the same implicit derived-to-base conversion C++ performs.
        @test CC.getNameAsString(rd) == "Widget"
        @test CC.getLocation(rd) == CC.getLocation(CC.NamedDecl(rd))
        @test CC.getBeginLoc(fd) == CC.getBeginLoc(CC.Decl(fd))

        # The root carriers are a widening, so what they must preserve is the node's identity
        # *and* what clang then says about it. `== rd` alone would be an identity by
        # construction — `Decl(x)` is `Decl(unsafe_convert(CXDecl, x))` and `==` on
        # AbstractDecl is that same conversion — so ask clang instead.
        @test CC.getDeclKindName(CC.Decl(rd)) == "CXXRecord"
        @test CC.getNameAsString(CC.NamedDecl(rd)) == CC.getNameAsString(rd)
        @test CC.getStmtClassName(CC.Stmt(CC.getBody(fd))) == "CompoundStmt"
    end

    @testset "narrowing is checked, and names what it found" begin
        # the base-typed carrier a wrapper would hand out
        d = CC.Decl(fd)
        @test CC.FunctionDecl(d) == fd
        @test CC.isFunctionDecl(d)
        @test !CC.isVarDecl(d)

        err = try
            CC.VarDecl(d)
            nothing
        catch e
            e
        end
        @test err isa CC.CastError
        msg = sprint(showerror, err)
        @test occursin("clang::FunctionDecl", msg)   # the class clang says it is
        @test occursin("clang::VarDecl", msg)        # the class that was asked for

        # the predicate and the cast are the same question, so they never disagree
        for T in (CC.FunctionDecl, CC.VarDecl, CC.NamedDecl, CC.CXXMethodDecl, CC.TagDecl)
            pred = getproperty(CC, Symbol("is", nameof(T)))
            if pred(d)
                @test T(d) == fd
            else
                @test_throws CC.CastError T(d)
            end
        end
    end

    @testset "the cast admits every derived class, as dyn_cast does" begin
        # A method IS a function: `cast<FunctionDecl>` accepts it, and so does this. The
        # carrier that comes back is typed at the class asked for and still designates the
        # method — which is why a base-typed carrier is not a lie.
        @test CC.isFunctionDecl(method)
        @test CC.FunctionDecl(method) == method
        @test CC.FunctionDecl(ctor) == ctor
        @test CC.getNumParams(CC.FunctionDecl(method)) == 0

        # and the Julia hierarchy agrees with clang about which classes those are
        @test method isa CC.AbstractFunctionDecl
        @test ctor isa CC.AbstractFunctionDecl
        @test !(rd isa CC.AbstractFunctionDecl)
    end

    @testset "dispatch answers it without a cast at all" begin
        # `resolve` reads the class clang recorded; from there the subtype relation is the
        # cast, against the *abstract* type. A carrier is a leaf, so the concrete spelling
        # rejects the very subclasses `dyn_cast` accepts — that difference is the trap this
        # says out loud.
        # `method` came out of a comprehension filtered on `isa CXXMethodDecl`, so asserting
        # that again would restate the filter. What is not free is that clang and the mirror
        # agree: the shim's own predicate, and the abstract the generator placed it under.
        @test CC.resolve(CC.Decl(fd)) isa CC.AbstractFunctionDecl
        @test CC.isFunctionDecl(method) == (method isa CC.AbstractFunctionDecl)
        @test CC.isCXXMethodDecl(method) && !CC.isVarDecl(method)
        @test !(method isa CC.FunctionDecl)   # a carrier is a leaf; the abstract is the hierarchy

        # the typeassert form, which raises for the same reason and with no ccall
        let x::CC.AbstractFunctionDecl = method
            @test x === method
        end
        @test_throws TypeError (rd::CC.AbstractFunctionDecl)

        # and dispatch, which is the form that needs neither
        kind(::CC.AbstractFunctionDecl) = :function
        kind(::CC.AbstractRecordDecl) = :record
        @test kind(fd) == :function
        @test kind(method) == :function
        @test kind(rd) == :record
    end

    @testset "type casts are exact where clang's predicates desugar" begin
        # `Type::isRecordType()` looks through sugar; `dyn_cast<RecordType>` does not. Both
        # are wrapped, under the names that say which is which — and a variable declared
        # `Widget` is written with an ElaboratedType over the record either way.
        sugar = CC.getTypePtr(CC.getType(CC.VarDecl(find_decl(I, "cst::g_alias"))))
        canon = CC.getTypePtr(CC.getCanonicalType(ctx,
                                                  CC.getType(CC.VarDecl(find_decl(I,
                                                                                  "cst::g_alias")))))
        @test CC.isRecordType(sugar)                  # clang's predicate: true through sugar
        @test !(CC.resolve(sugar) isa CC.RecordType)  # the node itself is not a RecordType
        @test_throws CC.CastError CC.RecordType(sugar)
        @test CC.RecordType(canon) == canon           # canonicalise and it is
        @test CC.resolve(canon) isa CC.RecordType

        # the two spellings of `Widget` are different nodes that denote one type
        w = CC.getTypePtr(CC.getType(CC.VarDecl(find_decl(I, "cst::g_w"))))
        @test w != sugar
        @test CC.getCanonicalType(ctx, CC.get_qual_type(w)) ==
              CC.getCanonicalType(ctx, CC.get_qual_type(sugar))
    end

    @testset "a null carrier is refused before clang sees it" begin
        # `@check_ptrs` runs first, so the absent node never reaches a cast's ccall
        @test_throws AssertionError CC.FunctionDecl(CC.Decl(C_NULL))
        @test_throws AssertionError CC.isFunctionDecl(CC.Decl(C_NULL))
    end

    @testset "the unchecked cast will not leave a hierarchy" begin
        # `unchecked_cast` asks clang nothing, so what keeps it sound is that its callers
        # established the class — and that the reinterpretation stays inside one singly
        # inherited hierarchy, where the base subobject shares its object's address. Between
        # two hierarchies nothing of the sort holds, so the pair is refused by dispatch.
        #
        # This is the one testset licensed to name `unchecked_cast` outside `src/`
        # (test/lint.jl exempts this file), because a guard whose refusals nothing pins is a
        # guard that rots.
        body = CC.getBody(fd)
        qt = CC.getType(CC.VarDecl(find_decl(I, "cst::g_w")))
        loc = CC.getLocation(fd)

        # what it must keep doing — every real call site, in both directions
        @test CC.unchecked_cast(CC.FunctionDecl, CC.Decl(fd)) == fd
        @test CC.unchecked_cast(CC.Decl, fd) == fd
        @test CC.unchecked_cast(CC.CompoundStmt, body) == body
        # the `BuiltinType` family, whose field is a CXType_ rather than its own class handle
        @test CC.unchecked_cast(CC.BuiltinType, CC.IntTy(ctx)) == CC.IntTy(ctx)
        # and the bare-handle arm, which `decls` drives with a bulk-filled Vector{CXDecl}
        @test CC.unchecked_cast(CC.FunctionDecl, Base.unsafe_convert(CC.CXDecl, fd)) == fd

        # what it must refuse. Each of these succeeded silently before the per-hierarchy
        # methods, and the third is the one that does not even crash — it lands 48 bytes
        # short of the DeclContext base and answers `isNamespace` about another class.
        @test_throws MethodError CC.unchecked_cast(CC.IfStmt, fd)          # Decl -> Stmt
        @test_throws MethodError CC.unchecked_cast(CC.VarDecl, body)       # Stmt -> Decl
        @test_throws MethodError CC.unchecked_cast(CC.IfStmt, ctx)         # not a node at all
        @test_throws MethodError CC.unchecked_cast(CC.DeclContext, rd)     # the offset pivot
        @test_throws MethodError CC.unchecked_cast(CC.Type_, qt)           # a PointerIntPair
        @test_throws MethodError CC.unchecked_cast(CC.IfStmt, loc)         # a file offset
        @test_throws MethodError CC.unchecked_cast(CC.IfStmt, 12345)       # not a handle

        # the refusal is dispatch, so it is visible without calling anything
        @test !applicable(CC.unchecked_cast, CC.IfStmt, fd)
        @test applicable(CC.unchecked_cast, CC.CXXRecordDecl, fd)

        # the `Ptr` arm is deliberately still open: three wrapper bodies pass a handle more
        # derived than the carrier they build, and `decls` passes base handles by the
        # thousand. Narrowing it needs the phantoms to carry their hierarchy in the type.
        @test applicable(CC.unchecked_cast, CC.IfStmt, Base.unsafe_convert(CC.CXDecl, fd))
    end

    dispose(I)
end
