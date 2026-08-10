using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: LLVM
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl
using Test

const LX = CC.LibClangEx

# What clang decided about a signature, read back through CGFunctionInfo/ABIArgInfo. The
# assertions below are the ones that hold on every ABI this package is built for: the kind
# partition (a scalar goes direct, a 64-byte aggregate goes through memory), the gates that
# refuse a field the kind does not have, and the agreement between the two routes to a
# lowering (from a FunctionProtoType, and from a return type plus argument types).

@testset "CGFunctionInfo: the lowered shape of a free function" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             int cgfi_f(int a, double b) { return a; }
             int cgfi_v(int a, ...) { return a; }
             struct cgfi_big { long a[8]; };
             cgfi_big cgfi_ret();
             """)
    # after the parse, and not before: the interpreter starts a fresh CodeGenModule per
    # increment, so a handle taken earlier belongs to a module that this parse has already
    # replaced. It is still non-NULL, and using it segfaults inside the interned
    # CGFunctionInfo set -- see the warning on get_codegen_module.
    cgm = CC.get_codegen_module(I)

    f = DeclFinder(I)
    @test f(I, "cgfi_f")
    fd = CC.FunctionDecl(get_decl(f))
    fi = CC.arrangeFreeFunctionType(cgm, CC.getType(fd))

    # the arguments are the ones clang parsed, in order, canonicalized
    @test CC.arg_size(fi) == 2
    for i in 0:1
        @test CC.getArgType(fi, i) ==
              CC.getCanonicalType(CC.getType(CC.getParamDecl(fd, i)))
    end
    @test CC.getReturnType(fi) == CC.getCanonicalType(CC.getReturnType(fd))

    # indices are bounds-checked rather than reading past the trailing argument buffer
    @test_throws AssertionError CC.getArgType(fi, 2)
    @test_throws AssertionError CC.getArgInfo(fi, 2)
    @test_throws AssertionError CC.getArgInfo(fi, -1)

    @test !CC.isVariadic(fi)
    @test CC.getNumRequiredArgs(fi) == CC.arg_size(fi)
    @test !CC.isInstanceMethod(fi)
    @test !CC.isNoReturn(fi)
    @test CC.getASTCallingConvention(fi) == LX.CXCallingConv_CC_C
    @test CC.getCallingConvention(fi) == 0            # llvm::CallingConv::C
    @test CC.getEffectiveCallingConvention(fi) == 0
    # the two are one object in clang: the struct exists exactly when inalloca is in use
    @test CC.usesInAlloca(fi) == (CC.getArgStruct(fi) != C_NULL)

    # `int` is not a promotable integer type, so no ABI extends it: Direct everywhere
    ri = CC.getReturnInfo(fi)
    @test CC.getKind(ri) == LX.CXABIArgInfo_Direct
    @test CC.getDirectOffset(ri) == 0
    @test CC.getPaddingType(ri) == C_NULL             # nothing to pad a register return
    # ... and the accessors belonging to the other kinds refuse it instead of reading the
    # union member that happens to sit there
    @test_throws AssertionError CC.isSignExt(ri)
    @test_throws AssertionError CC.getIndirectAlign(ri)
    @test_throws AssertionError CC.getIndirectByVal(ri)
    @test_throws AssertionError CC.isSRetAfterThis(ri)
    @test_throws AssertionError CC.getInAllocaFieldIndex(ri)

    dispose(f)
    dispose(I)
end

@testset "CGFunctionInfo: variadic, and an aggregate that cannot go in registers" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             int cgfi2_v(int a, ...) { return a; }
             struct cgfi2_big { long a[8]; };
             cgfi2_big cgfi2_ret();
             """)
    # after the parse: the CodeGenModule is per-increment (see its docstring)
    cgm = CC.get_codegen_module(I)
    f = DeclFinder(I)

    @test f(I, "cgfi2_v")
    vfi = CC.arrangeFreeFunctionType(cgm, CC.getType(CC.FunctionDecl(get_decl(f))))
    @test CC.isVariadic(vfi)
    @test CC.getNumRequiredArgs(vfi) == 1              # only `a` is declared

    # 64 bytes is past every ABI's register-return budget (16 on SysV/AAPCS, 8 on Win64),
    # so this is the sret case whatever the host is
    @test f(I, "cgfi2_ret")
    rfi = CC.arrangeFreeFunctionType(cgm, CC.getType(CC.FunctionDecl(get_decl(f))))
    rri = CC.getReturnInfo(rfi)
    @test CC.getKind(rri) == LX.CXABIArgInfo_Indirect
    @test CC.getIndirectAlign(rri) > 0
    @test !CC.isSRetAfterThis(rri)                     # a free function has no `this`
    @test_throws AssertionError CC.getDirectOffset(rri)
    @test_throws AssertionError CC.getCoerceToType(rri)
    @test_throws AssertionError CC.getCanBeFlattened(rri)

    dispose(f)
    dispose(I)
end

@testset "arrangeCXXMethodType prepends the implicit this" begin
    I = create_interpreter(String[])
    CC.parse(I, "struct cgfi_c { int m(int x); };")
    # after the parse: the CodeGenModule is per-increment (see its docstring)
    cgm = CC.get_codegen_module(I)

    f = DeclFinder(I)
    @test f(I, "cgfi_c")
    rd = CC.CXXRecordDecl(get_decl(f))
    md = only(m for m in CC.getMethods(rd) if CC.getNameAsString(m) == "m")
    ftp = CC.resolve(CC.getTypePtr(CC.getCanonicalType(CC.getType(md))))
    @test ftp isa CC.FunctionProtoType

    mfi = CC.arrangeCXXMethodType(cgm, rd, ftp, md)
    @test CC.isInstanceMethod(mfi)
    @test CC.arg_size(mfi) == 2                        # this, x
    @test CC.isPointerType(CC.getTypePtr(CC.getArgType(mfi, 0)))
    @test CC.getArgType(mfi, 1) == CC.getCanonicalType(CC.getType(CC.getParamDecl(md, 0)))

    dispose(f)
    dispose(I)
end

@testset "arrangeFreeFunctionCall agrees with the same signature spelled as a type" begin
    I = create_interpreter(String[])
    ctx = CC.get_ast_context(I)
    CC.parse(I, "int cgfi3_f(int a, double b) { return a; }")
    # after the parse: the CodeGenModule is per-increment (see its docstring)
    cgm = CC.get_codegen_module(I)

    f = DeclFinder(I)
    @test f(I, "cgfi3_f")
    fd = CC.FunctionDecl(get_decl(f))
    fromtype = CC.arrangeFreeFunctionType(cgm, CC.getType(fd))

    ret = CC.get_qual_type(CC.IntTy(ctx))
    args = [CC.get_qual_type(CC.IntTy(ctx)), CC.get_qual_type(CC.DoubleTy(ctx))]
    fromargs = CC.arrangeFreeFunctionCall(cgm, ctx, ret, args)

    @test CC.arg_size(fromargs) == CC.arg_size(fromtype)
    @test !CC.isVariadic(fromargs)
    @test CC.getReturnType(fromargs) == CC.getReturnType(fromtype)
    @test CC.getKind(CC.getReturnInfo(fromargs)) == CC.getKind(CC.getReturnInfo(fromtype))
    for i in 0:(CC.arg_size(fromtype) - 1)
        @test CC.getArgType(fromargs, i) == CC.getArgType(fromtype, i)
        @test CC.getKind(CC.getArgInfo(fromargs, i)) == CC.getKind(CC.getArgInfo(fromtype, i))
    end

    # the variadic flag and the required count are ours to set here, unlike above where the
    # prototype carried them
    varargs = CC.arrangeFreeFunctionCall(cgm, ctx, ret, args, LX.CXCallingConv_CC_C, false,
                                         true, 1)
    @test CC.isVariadic(varargs)
    @test CC.getNumRequiredArgs(varargs) == 1
    # and a required count no argument list can satisfy is refused before the ccall
    @test_throws AssertionError CC.arrangeFreeFunctionCall(cgm, ctx, ret, args,
                                                           LX.CXCallingConv_CC_C, false,
                                                           true, 3)

    dispose(f)
    dispose(I)
end
