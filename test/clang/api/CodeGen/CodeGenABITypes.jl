using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: LLVM
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

const LX = CC.LibClangEx

@testset "convertFreeFunctionType lowers a declaration to its IR signature" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             int cgabi_f(int a, double b) { return a; }
             struct cgabi_big { long a[8]; };
             cgabi_big cgabi_ret();
             """)
    # after the parse: the CodeGenModule is per-increment (see its docstring)
    cgm = CC.get_codegen_module(I)
    f = DeclFinder(I)

    @test f(I, "cgabi_f")
    ft = LLVM.LLVMType(CC.convertFreeFunctionType(cgm, CC.FunctionDecl(get_decl(f))))
    @test ft isa LLVM.FunctionType
    @test length(LLVM.parameters(ft)) == 2
    @test LLVM.width(LLVM.return_type(ft)) == 32

    # the same sret decision CGFunctionInfo reports, seen in the IR type: the aggregate
    # return became a hidden pointer parameter and the function returns void
    @test f(I, "cgabi_ret")
    rt = LLVM.LLVMType(CC.convertFreeFunctionType(cgm, CC.FunctionDecl(get_decl(f))))
    @test LLVM.return_type(rt) isa LLVM.VoidType
    @test length(LLVM.parameters(rt)) == 1

    dispose(f)
    dispose(I)
end

@testset "getLLVMFieldNumber is the GEP index, not the field's position in the AST" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             struct cgabi_plain { char c; int i; };
             struct cgabi_pad { char c; alignas(16) int i; };
             struct cgabi_bits { int a : 3; int b : 5; };
             """)
    # after the parse: the CodeGenModule is per-increment (see its docstring)
    cgm = CC.get_codegen_module(I)
    f = DeclFinder(I)

    @test f(I, "cgabi_plain")
    plain = CC.CXXRecordDecl(get_decl(f))
    pfields = CC.getFields(plain)
    @test length(pfields) == 2
    @test CC.getLLVMFieldNumber(cgm, plain, pfields[1]) == 0
    @test CC.getLLVMFieldNumber(cgm, plain, pfields[2]) == 1

    # the bytes clang inserts to reach the alignas(16) offset are an LLVM struct member of
    # their own, so the second field stops being element 1 -- which is the whole reason this
    # entry point exists
    @test f(I, "cgabi_pad")
    padded = CC.CXXRecordDecl(get_decl(f))
    dfields = CC.getFields(padded)
    @test length(dfields) == 2
    @test CC.getLLVMFieldNumber(cgm, padded, dfields[1]) == 0
    @test CC.getLLVMFieldNumber(cgm, padded, dfields[2]) > 1

    # the two shapes the layout's lookup table does not contain: a field of another record,
    # and a bitfield (which shares a storage unit rather than owning an element)
    @test_throws AssertionError CC.getLLVMFieldNumber(cgm, plain, dfields[1])
    @test f(I, "cgabi_bits")
    bits = CC.CXXRecordDecl(get_decl(f))
    bfields = CC.getFields(bits)
    @test length(bfields) == 2
    @test_throws AssertionError CC.getLLVMFieldNumber(cgm, bits, bfields[1])

    dispose(f)
    dispose(I)
end

@testset "getImplicitCXXConstructorArgs adds nothing without virtual bases" begin
    I = create_interpreter(String[])
    CC.parse(I, "struct cgabi_ctor { cgabi_ctor(); cgabi_ctor(int); int v; };")
    # after the parse: the CodeGenModule is per-increment (see its docstring)
    cgm = CC.get_codegen_module(I)
    f = DeclFinder(I)
    @test f(I, "cgabi_ctor")
    rd = CC.CXXRecordDecl(get_decl(f))

    ctors = CC.getCtors(rd)
    @test length(ctors) >= 2          # the loop below is only worth anything if it runs
    for c in ctors
        prefix, suffix = CC.getImplicitCXXConstructorArgs(cgm, c)
        # the prefix is the VTT on Itanium and the most-derived flag on the Microsoft ABI;
        # a class with no virtual bases needs neither, on either
        @test isempty(prefix)
        @test isempty(suffix)
    end

    dispose(f)
    dispose(I)
end

@testset "AttrBuilder carries clang's default function-definition attributes" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             extern "C" int cgabi_attr_fn(int x) { return x; }
             extern "C" int cgabi_attr_gv = 7;
             """)
    # after the parse: the CodeGenModule is per-increment (see its docstring)
    cgm = CC.get_codegen_module(I)
    cg = CC.getCodeGen(I.interp)
    # the builder has to live in the context the attributes will be attached in
    lctx = LLVM.context(CC.GetModule(cg))

    ab = CC.AttrBuilder(lctx)
    @test CC.getNumAttributes(ab) == 0
    @test !contains(ab, "target-cpu")

    CC.addDefaultFunctionDefinitionAttributes(cgm, ab)
    n = CC.getNumAttributes(ab)
    @test n > 0                                     # the empty/filled partition
    strs = [CC.getAttributeAsString(ab, i) for i = 0:(n - 1)]
    @test all(!isempty, strs)
    @test_throws AssertionError CC.getAttributeAsString(ab, n)
    @test !contains(ab, "no-such-attribute-at-all")

    f = DeclFinder(I)
    @test f(I, "cgabi_attr_fn")
    fn = CC.GetAddrOfGlobal(cg, CC.FunctionDecl(get_decl(f)), true)
    @test fn isa LLVM.Function
    @test CC.applyToFunction(ab, fn)
    # clang already put these on the function it emitted, so applying them again cannot
    # remove any: the function ends up with at least what the builder holds
    @test length(LLVM.function_attributes(fn)) >= n

    # a global variable takes no function attributes, and the shim refuses rather than
    # casting a non-function to llvm::Function
    @test f(I, "cgabi_attr_gv")
    gv = CC.GetAddrOfGlobal(cg, CC.VarDecl(get_decl(f)), true)
    @test gv !== nothing
    @test !(gv isa LLVM.Function)
    @test !CC.applyToFunction(ab, gv)

    dispose(ab)
    dispose(f)
    dispose(I)
end
