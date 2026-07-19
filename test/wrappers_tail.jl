using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, DeclIterator
using Test

# Depth-first search for the first resolved child node whose carrier is `T`.
function _find_node(::Type{T}, x) where {T}
    x isa T && return x
    for c in CC.children(x)
        r = _find_node(T, CC.resolve(c))
        r === nothing || return r
    end
    return nothing
end

@testset "Tail | NestedNameSpecifier navigation" begin
    I = create_interpreter(String[])
    CC.parse(I, "namespace N { struct S {}; } N::S obj;")
    f = DeclFinder(I)
    @test f(I, "obj")
    vd = CC.VarDecl(get_decl(f).ptr)
    ety = CC.resolve(CC.getTypePtr(CC.getType(vd)))
    @test ety isa CC.ElaboratedType
    nns = CC.getQualifier(ety)
    @test nns.ptr != C_NULL
    @test CC.getKind(nns) == CC.LibClangEx.CXNestedNameSpecifierKind_Namespace
    @test CC.getName(CC.getAsNamespace(nns)) == "N"
    @test CC.isDependent(nns) == false
    dispose(f)
    dispose(I)
end

@testset "Tail | DeclarationNameInfo" begin
    I = create_interpreter(String[])
    CC.parse(I, "int declnameinfo_probe(int a) { return a; }")
    f = DeclFinder(I)
    @test f(I, "declnameinfo_probe")
    fd = CC.FunctionDecl(get_decl(f).ptr)
    ni = CC.getNameInfo(fd)                       # owned box
    @test ni isa CC.DeclarationNameInfo
    @test CC.getAsString(ni) == "declnameinfo_probe"
    @test CC.getName(ni) isa CC.DeclarationName
    @test CC.getLoc(ni) isa CC.SourceLocation
    @test CC.getBeginLoc(ni) isa CC.SourceLocation
    @test CC.getEndLoc(ni) isa CC.SourceLocation
    dispose(ni)                                   # release the box
    dispose(f)
    dispose(I)
end

@testset "Tail | TemplateSpecializationType arguments" begin
    I = create_interpreter(String[])
    CC.parse(I, "template<typename T, int N> struct STempl { T x; }; STempl<int,3> stempl_obj;")
    f = DeclFinder(I)
    @test f(I, "stempl_obj")
    vd = CC.VarDecl(get_decl(f).ptr)
    ety = CC.resolve(CC.getTypePtr(CC.getType(vd)))
    tst = CC.resolve(CC.getTypePtr(CC.getNamedType(ety)))
    @test tst isa CC.TemplateSpecializationType
    @test CC.getNumArgs(tst) == 2
    @test CC.getArg(tst, 0) isa CC.TemplateArgument
    dispose(f)
    dispose(I)
end

@testset "Tail | DeclCXX ctor initializers" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    CC.parse(I, "struct Base { int b; }; struct Wid : Base { int m; Wid(int x) : Base(), m(x) {} };")
    @test f(I, "Wid")
    wid = CC.CXXRecordDecl(get_decl(f).ptr)
    ctor = first(c for c in CC.getCtors(wid) if CC.getNumCtorInitializers(c) == 2)
    inits = CC.getCtorInitializers(ctor)
    @test length(inits) == 2
    @test all(x -> x isa CC.CXXCtorInitializer, inits)
    @test CC.isBaseInitializer(inits[1])
    @test !CC.isMemberInitializer(inits[1])
    @test CC.getBaseClass(inits[1]) isa CC.Type_
    @test CC.isMemberInitializer(inits[2])
    @test CC.getName(CC.getMember(inits[2])) == "m"
    @test CC.getInit(inits[2]) isa CC.Expr_
    dispose(f)
    dispose(I)
end

@testset "Tail | LambdaExpr captures" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)
    CC.parse(I, "auto get_lambda(int cap) { return [cap]() { return cap; }; }")
    @test f(I, "get_lambda")
    fn = CC.FunctionDecl(get_decl(f).ptr)
    le = _find_node(CC.LambdaExpr, CC.resolve(CC.getBody(fn)))
    @test le isa CC.LambdaExpr
    @test CC.isGenericLambda(le) == false
    @test CC.getNumCaptures(le) == 1
    cap = CC.getCapture(le, 0)
    @test cap isa CC.LambdaCapture
    @test CC.capturesVariable(cap)
    @test !CC.capturesThis(cap)
    @test CC.getCaptureKind(cap) == CC.LibClangEx.CXLambdaCaptureKind_LCK_ByCopy
    dispose(f)
    dispose(I)
end

@testset "Tail | FunctionProtoType accessors" begin
    I = create_interpreter(String[])
    CC.parse(I, "int fpt_probe(double a, char b) noexcept;")
    f = DeclFinder(I)
    @test f(I, "fpt_probe")
    fd = CC.FunctionDecl(get_decl(f).ptr)
    ty = CC.resolve(CC.resolve(CC.getTypePtr(CC.getType(fd))))   # Type_ -> FunctionType -> FunctionProtoType
    @test ty isa CC.FunctionProtoType
    @test CC.getNumParams(ty) == 2
    @test CC.isVariadic(ty) == false
    @test CC.getNumExceptions(ty) == 0
    @test CC.isIntegerType(CC.getTypePtr(CC.getReturnType(ty)))
    @test CC.isRealFloatingType(CC.getTypePtr(CC.getParamType(ty, 0)))
    @test Integer(CC.getCallConv(ty)) == Integer(CC.LibClangEx.CXCallingConv_CC_C)
    @test CC.getExceptionSpecType(ty) == CC.LibClangEx.CXExceptionSpecificationType_EST_BasicNoexcept
    dispose(f)
    dispose(I)
end

@testset "Tail | IndirectFieldDecl chain" begin
    I = create_interpreter(String[])
    CC.parse(I, "struct AnonHost { union { int a; long b; }; };")
    f = DeclFinder(I)
    @test f(I, "AnonHost")
    host = get_decl(f)
    ifds = CC.IndirectFieldDecl[]
    for d in DeclIterator(host)
        CC.getDeclKindName(d) == "IndirectField" && push!(ifds, CC.IndirectFieldDecl(d.ptr))
    end
    @test length(ifds) == 2
    for ifd in ifds
        n = CC.getChainingSize(ifd)
        @test n == 2
        @test CC.getChainElement(ifd, n - 1).ptr == CC.getAnonField(ifd).ptr
    end
    dispose(f)
    dispose(I)
end

@testset "Tail | skiplist-sweep accessors" begin
    I = create_interpreter(String[])
    CC.parse(I, "struct S { int a : 3; int b; }; int fn(){ return (int)3.5; }")
    f = DeclFinder(I)
    ctx = CC.get_ast_context(I)

    @test f(I, "S")
    rd = CC.CXXRecordDecl(get_decl(f).ptr)
    fields = collect(CC.getFields(rd))
    @test CC.getBitWidthValue(fields[1], ctx) == 3          # `int a : 3`
    @test !CC.isZeroSize(fields[1], ctx)
    @test !CC.isMsStruct(rd, ctx)

    @test f(I, "fn")
    fd = CC.FunctionDecl(get_decl(f).ptr)
    @test CC.isFunctionOrFunctionTemplate(get_decl(f))
    csce = nothing
    for n in CC.subtree(CC.resolve(CC.getBody(fd)))
        n isa CC.CStyleCastExpr && (csce = n; break)
    end
    @test csce !== nothing
    @test CC.getLParenLoc(csce) isa CC.SourceLocation
    @test CC.getRParenLoc(csce) isa CC.SourceLocation

    dispose(f)
    dispose(I)
end

@testset "Tail | whole-TU decls traversal" begin
    I = create_interpreter(String[])
    CC.parse(I, "namespace N { struct S { int x; void m(); }; int g; }")
    f = DeclFinder(I)
    @test f(I, "N")
    nsdc = CC.castToDeclContext(get_decl(f))    # NamespaceDecl -> DeclContext pivot
    ds = CC.decls(nsdc)
    @test all(d -> d isa CC.AbstractDecl, ds)
    @test !any(d -> isabstracttype(typeof(d)), ds)          # every node resolved
    names = [CC.getDeclKindName(d) for d in ds]
    # recurses into the nested record: S, then S's members (x, m), plus g.
    @test "CXXRecord" in names
    @test "Field" in names
    @test "CXXMethod" in names
    @test "Var" in names
    @test any(d -> d isa CC.CXXRecordDecl, ds)
    @test any(d -> d isa CC.FieldDecl && CC.getName(d) == "x", ds)
    dispose(f)
    dispose(I)
end

@testset "Tail | bulk subtree traversal" begin
    I = create_interpreter(String[])
    CC.parse(I, "int fn(int a){ int s=0; for(int i=0;i<a;i++){ s+=i*2; if(s>10) break; } return s; }")
    f = DeclFinder(I)
    @test f(I, "fn")
    fd = CC.FunctionDecl(get_decl(f).ptr)
    body = CC.resolve(CC.getBody(fd))

    # bulk subtree must match a manual recursive children walk, node-for-node.
    function walk(x, acc)
        push!(acc, x)
        for c in CC.children(x)
            walk(c, acc)
        end
        acc
    end
    rec = walk(body, CC.AbstractStmt[])
    bulk = CC.subtree(body)
    @test length(bulk) == length(rec)
    @test bulk[1] isa CC.CompoundStmt                       # pre-order: root first
    @test all(x -> x isa CC.AbstractStmt, bulk)
    @test !any(x -> isabstracttype(typeof(x)), bulk)        # every node fully resolved
    @test [s.ptr for s in bulk] == [s.ptr for s in rec]     # same nodes, same order

    dispose(f)
    dispose(I)
end

@testset "Tail | TypeLoc" begin
    I = create_interpreter(String[])
    CC.parse(I, "int *tlp;")
    f = DeclFinder(I)
    @test f(I, "tlp")
    vd = CC.VarDecl(get_decl(f).ptr)
    tl = CC.getTypeLoc(CC.getTypeSourceInfo(vd))   # owned box
    @test tl isa CC.TypeLoc
    @test !CC.isNull(tl)
    @test CC.resolve(CC.getTypePtr(CC.getType(tl))) isa CC.PointerType
    @test CC.getSourceRange(tl) isa CC.SourceRange
    @test CC.getBeginLoc(tl) isa CC.SourceLocation

    nxt = CC.getNextTypeLoc(tl)                     # the pointee (int) loc; owned box
    @test CC.resolve(CC.getTypePtr(CC.getType(nxt))) isa CC.BuiltinType
    CC.dispose(nxt)
    CC.dispose(tl)
    dispose(f)
    dispose(I)
end

@testset "Tail | Attributes (Decl::getAttrs)" begin
    I = create_interpreter(String[])
    CC.parse(I, "int __attribute__((aligned(16), deprecated)) gattr;")
    f = DeclFinder(I)
    @test f(I, "gattr")
    d = get_decl(f)
    @test CC.hasAttrs(d)
    @test CC.getNumAttrs(d) == 2
    attrs = CC.getAttrs(d)
    @test length(attrs) == 2
    @test all(a -> a isa CC.Attr, attrs)
    spellings = [CC.getSpelling(a) for a in attrs]
    @test "aligned" in spellings
    @test "deprecated" in spellings
    @test CC.getKind(attrs[1]) == CC.LibClangEx.CXAttrKind_Aligned
    @test !CC.isImplicit(attrs[1])
    @test CC.getLocation(attrs[1]) isa CC.SourceLocation

    @test f(I, "gattr")   # a decl with no attrs
    CC.parse(I, "int noattr;")
    @test f(I, "noattr")
    @test !CC.hasAttrs(get_decl(f))
    @test isempty(CC.getAttrs(get_decl(f)))

    dispose(f)
    dispose(I)
end

@testset "Tail | Type classification (getTypeClass / resolve)" begin
    I = create_interpreter(String[])
    CC.parse(I, "int *tc_p; int tc_arr[4]; int &tc_r = *tc_p;")
    f = DeclFinder(I)
    cases = [("tc_p", CC.PointerType, CC.LibClangEx.CXTypeClass_Pointer),
             # getTypeClass resolves straight to the leaf: array -> ConstantArray
             # (not the abstract Array), reference -> LValueReference.
             ("tc_arr", CC.ConstantArrayType, CC.LibClangEx.CXTypeClass_ConstantArray),
             ("tc_r", CC.LValueReferenceType, CC.LibClangEx.CXTypeClass_LValueReference)]
    for (name, carrier, cls) in cases
        @test f(I, name)
        typtr = CC.getTypePtr(CC.getType(CC.VarDecl(get_decl(f).ptr)))
        @test CC.getTypeClass(typtr) == cls
        @test CC.resolve(typtr) isa carrier
    end
    dispose(f)
    dispose(I)
end

@testset "Tail | Decl classification (getKind / resolve)" begin
    I = create_interpreter(String[])
    CC.parse(I, "int gv = 3; int fn(int a){return a;} struct S { int m; }; namespace N {}")
    f = DeclFinder(I)
    cases = [("gv", CC.VarDecl, CC.LibClangEx.CXDeclKind_Var, "Var"),
             ("fn", CC.FunctionDecl, CC.LibClangEx.CXDeclKind_Function, "Function"),
             ("S", CC.CXXRecordDecl, CC.LibClangEx.CXDeclKind_CXXRecord, "CXXRecord"),
             ("N", CC.NamespaceDecl, CC.LibClangEx.CXDeclKind_Namespace, "Namespace")]
    for (name, carrier, kind, kindname) in cases
        @test f(I, name)
        d = get_decl(f)                       # base Decl carrier
        @test CC.getKind(d) == kind
        @test CC.getDeclKindName(d) == kindname
        r = CC.resolve(d)                     # O(1) downcast via getKind
        @test r isa carrier
        @test r.ptr == d.ptr                  # Decl is the primary base: identity
    end
    dispose(f)
    dispose(I)
end

@testset "Tail | Expr payload (StringLiteral / UETT)" begin
    I = create_interpreter(String[])
    f = DeclFinder(I)

    CC.parse(I, "const char *g_str = \"abc\";")
    @test f(I, "g_str")
    vd = CC.VarDecl(get_decl(f).ptr)
    sl = _find_node(CC.StringLiteral, CC.resolve(CC.getInit(vd)))
    @test sl !== nothing
    @test CC.getString(sl) == "abc"
    @test CC.getLength(sl) == 3
    @test CC.isOrdinary(sl)
    @test CC.getKind(sl) == CC.LibClangEx.CXStringLiteralKind_Ordinary

    CC.parse(I, "unsigned long g_sz = sizeof(int);")
    @test f(I, "g_sz")
    vd2 = CC.VarDecl(get_decl(f).ptr)
    uett = _find_node(CC.UnaryExprOrTypeTraitExpr, CC.resolve(CC.getInit(vd2)))
    @test uett !== nothing
    @test CC.getKind(uett) == CC.LibClangEx.CXUnaryExprOrTypeTrait_UETT_SizeOf

    dispose(f)
    dispose(I)
end
