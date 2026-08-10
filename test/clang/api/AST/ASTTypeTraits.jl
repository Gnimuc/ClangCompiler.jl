using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, find_decl
using Test

@testset "DynTypedNode" begin
    I = create_interpreter(["-std=c++17"])
    ctx = CC.get_ast_context(I)
    CC.parse(I, "int dtn_f(int p) { return p + 1; }")

    fd = find_decl(I, "dtn_f")
    @test fd !== nothing
    body = CC.getBody(fd)

    dn = CC.DynTypedNode(fd)
    # clang names the DYNAMIC class, not the static type of the carrier it was built from
    @test CC.getNodeKindName(dn) == "FunctionDecl"
    @test !CC.isNodeKindNone(dn)
    @test CC.nodeKindHasPointerIdentity(dn)
    # the discrimination: the declaration arm answers, the others do not
    @test CC.getAsDecl(dn) == fd
    @test CC.is_null_handle(CC.getAsStmt(dn))
    @test CC.is_null_handle(CC.getAsType(dn))
    @test CC.is_null_handle(CC.getAsAttr(dn))
    @test CC.is_null_handle(CC.getAsQualType(dn))
    @test CC.is_null_handle(CC.getAsTypeLoc(dn))
    # the memoization address IS the node address clang compares declarations by
    @test UInt(CC.getMemoizationData(dn)) == CC.decl_id(fd)
    rng = CC.getSourceRange(dn)
    @test rng.begin_loc == CC.getBeginLoc(fd)

    sn = CC.DynTypedNode(body)
    @test CC.getNodeKindName(sn) == "CompoundStmt"
    @test CC.getAsStmt(sn) == body
    @test CC.is_null_handle(CC.getAsDecl(sn))
    @test !CC.isNodeKindSame(dn, sn)
    @test !CC.isNodeKindBaseOf(dn, sn)

    again = CC.DynTypedNode(body)
    # a second box of one node: a different box, the same kind and the same identity
    @test again.ptr != sn.ptr
    @test CC.isNodeKindSame(sn, again)
    @test CC.isNodeKindBaseOf(sn, again)
    @test CC.getMemoizationData(again) == CC.getMemoizationData(sn)
    dispose(again)

    # a by-value kind: no pointer identity, and the value survives being copied out of the
    # node -- which is the whole reason this handle is owned
    int_qt = CC.get_qual_type(CC.IntTy(ctx))
    qn = CC.DynTypedNode(int_qt)
    @test CC.getNodeKindName(qn) == "QualType"
    @test !CC.nodeKindHasPointerIdentity(qn)
    @test CC.getMemoizationData(qn) == C_NULL
    @test CC.getAsQualType(qn) == int_qt
    @test CC.is_null_handle(CC.getAsType(qn))

    # the bare Type is a pointer kind and reports its concrete class
    int_ty = CC.getTypePtr(int_qt)
    tn = CC.DynTypedNode(int_ty)
    @test CC.getNodeKindName(tn) == "BuiltinType"
    @test CC.getAsType(tn) == int_ty
    @test CC.is_null_handle(CC.getAsQualType(tn))
    @test UInt(CC.getMemoizationData(tn)) == CC.type_id(int_ty)

    # a TypeLoc: the kind the old parent API had to answer NULL for. Copied out of the node
    # into its own box, so it outlives the node.
    tsi = CC.getTypeSourceInfo(fd)
    @test !CC.is_null_handle(tsi)
    tl = CC.getTypeLoc(tsi)
    ln = CC.DynTypedNode(tl)
    @test endswith(CC.getNodeKindName(ln), "TypeLoc")
    @test !CC.nodeKindHasPointerIdentity(ln)
    copied = CC.getAsTypeLoc(ln)
    @test !CC.is_null_handle(copied)
    @test copied.ptr != tl.ptr
    @test CC.getType(copied) == CC.getType(tl)
    dispose(ln)                      # the copy must still be readable afterwards
    @test CC.getType(copied) == CC.getType(tl)
    dispose(copied)
    dispose(tl)

    # printing goes through the context's own policy
    pp = CC.getPrintingPolicy(ctx)
    @test occursin("return", CC.print(sn, pp))
    @test occursin("CompoundStmt", CC.dump(sn, ctx))

    dispose(sn)
    dispose(qn)
    dispose(tn)
    dispose(dn)
    dispose(I)
end

@testset "getParentAsNode" begin
    I = create_interpreter(["-std=c++17"])
    ctx = CC.get_ast_context(I)
    CC.parse(I, """
    int dtn_h();
    decltype(dtn_h()) dtn_v = 0;
    int dtn_g(int p) { return p + 1; }
    """)

    fd = find_decl(I, "dtn_g")
    @test fd !== nothing
    body = CC.getBody(fd)
    ret = only(filter(s -> s isa CC.ReturnStmt, CC.subtree(body)))

    # for a statement parent the node form and the arm-split form agree
    @test CC.getNumParents(ctx, ret) == 1
    pn = CC.getParentAsNode(ctx, ret, 0)
    @test CC.getAsStmt(pn) == body
    @test CC.getAsStmt(pn) == CC.getParentAsStmt(ctx, ret, 0)
    @test CC.is_null_handle(CC.getAsDecl(pn))
    dispose(pn)

    # and for the declaration parent of the body
    @test CC.getNumParents(ctx, body) == 1
    bn = CC.getParentAsNode(ctx, body, 0)
    @test CC.getAsDecl(bn) == fd
    dispose(bn)

    @test_throws AssertionError CC.getParentAsNode(ctx, ret, 1)

    # the hole this entry point exists to close: the call inside `decltype(...)` is nested
    # in a TypeLoc, so both arm-split accessors answer NULL and only the node can say what
    # the parent is
    vd = find_decl(I, "dtn_v")
    @test vd !== nothing
    dt = CC.DecltypeType(CC.getTypePtr(CC.getType(vd)))
    call = CC.getUnderlyingExpr(dt)
    @test CC.getStmtClassName(call) == "CallExpr"
    @test CC.getNumParents(ctx, call) == 1
    @test CC.is_null_handle(CC.getParentAsStmt(ctx, call, 0))
    @test CC.is_null_handle(CC.getParentAsDecl(ctx, call, 0))
    tn = CC.getParentAsNode(ctx, call, 0)
    @test !CC.isNodeKindNone(tn)
    @test endswith(CC.getNodeKindName(tn), "TypeLoc")
    parent_tl = CC.getAsTypeLoc(tn)
    @test !CC.is_null_handle(parent_tl)
    dispose(parent_tl)
    dispose(tn)

    dispose(I)
end
