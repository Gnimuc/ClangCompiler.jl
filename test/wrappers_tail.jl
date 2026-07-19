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
