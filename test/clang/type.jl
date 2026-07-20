using ClangCompiler
using ClangCompiler: create_interpreter, dispose
using ClangCompiler: DeclFinder, get_decl, DeclIterator, getDeclKindName
using Test

import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, DeclIterator
# Depth-first search for the first resolved child node whose carrier is `T`.
function _find_node(::Type{T}, x) where {T}
    x isa T && return x
    for c in CC.children(x)
        r = _find_node(T, CC.resolve(c))
        r === nothing || return r
    end
    return nothing
end

@testset "sugar type resolve" begin
    I = create_interpreter(String[])
    ClangCompiler.parse(I, "_Atomic int av;")
    f = DeclFinder(I)
    @test f(I, "av")
    vd = ClangCompiler.VarDecl(get_decl(f).ptr)
    ty = ClangCompiler.resolve(ClangCompiler.getTypePtr(ClangCompiler.getType(vd)))
    @test ty isa ClangCompiler.AtomicType
    @test ClangCompiler.getValueType(ty) isa ClangCompiler.QualType
    dispose(f)
    dispose(I)
end

@testset "Type classification (getTypeClass / resolve)" begin
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
