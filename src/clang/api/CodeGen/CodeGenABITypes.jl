# CodeGenTypes
function convertTypeForMemory(x::CodeGenModule, t::QualType)
    @check_ptrs x
    return clang_CodeGen_convertTypeForMemory(x, t)
end

"""
    arrangeFreeFunctionType(x::AbstractCodeGenModule, t::QualType) -> CGFunctionInfo
The lowered signature of the prototyped function type `t`: what LLVM type each parameter is
passed as, and by which mechanism. `t` is canonicalized first, so a typedef of a function
type is accepted.

The result is interned in `x` and borrowed — it must not outlive the `CodeGenModule`, and
there is nothing to dispose.

PRECONDITION: the canonical form of `t` is a `FunctionProtoType`. Passing anything else
would have clang read the wrong class out of the type node.
"""
function arrangeFreeFunctionType(x::AbstractCodeGenModule, t::QualType)
    @check_ptrs x t
    @assert isFunctionProtoType(getTypePtr(getCanonicalType(t))) "arrangeFreeFunctionType needs a prototyped function type"
    return CGFunctionInfo(clang_CodeGen_arrangeFreeFunctionType(x, t))
end

"""
    arrangeFreeFunctionTypeNoProto(x::AbstractCodeGenModule, t::QualType) -> CGFunctionInfo
[`arrangeFreeFunctionType`](@ref) for the other overload: an unprototyped (K&R) function
type, which has no declared parameters at all.

PRECONDITION: the canonical form of `t` is a `FunctionNoProtoType`.
"""
function arrangeFreeFunctionTypeNoProto(x::AbstractCodeGenModule, t::QualType)
    @check_ptrs x t
    @assert isFunctionNoProtoType(getTypePtr(getCanonicalType(t))) "arrangeFreeFunctionTypeNoProto needs an unprototyped function type"
    return CGFunctionInfo(clang_CodeGen_arrangeFreeFunctionTypeNoProto(x, t))
end

"""
    arrangeCXXMethodType(x::AbstractCodeGenModule, rd::AbstractCXXRecordDecl,
                         ftp::AbstractFunctionProtoType, md::AbstractCXXMethodDecl) -> CGFunctionInfo
The lowered signature of a member function of `rd`, including the implicit `this`. `md` may
be a null-pointered carrier, in which case `ftp` alone describes the arguments.

Borrowed like [`arrangeFreeFunctionType`](@ref).
"""
function arrangeCXXMethodType(x::AbstractCodeGenModule, rd::AbstractCXXRecordDecl,
                              ftp::AbstractFunctionProtoType, md::AbstractCXXMethodDecl)
    @check_ptrs x rd ftp
    return CGFunctionInfo(clang_CodeGen_arrangeCXXMethodType(x, rd, ftp, md))
end

"""
    arrangeFreeFunctionCall(x::AbstractCodeGenModule, ctx::AbstractASTContext,
                            ret::QualType, args::Vector{QualType},
                            cc::CXCallingConv_=CXCallingConv_CC_C, noreturn::Bool=false,
                            variadic::Bool=false, num_required::Integer=length(args)) -> CGFunctionInfo
The lowered signature of a call whose argument types are given directly rather than read off
a `FunctionType` — the shape a synthesized call site needs.

`ctx` is what canonicalizes the types: clang requires every argument type to be canonical
*as a parameter* (arrays decayed, top-level qualifiers dropped), so the shim runs each one
through `ASTContext::getCanonicalParamType` instead of trusting the caller.

`num_required` is read only when `variadic` is true; a non-variadic call requires all of its
arguments.

Borrowed like [`arrangeFreeFunctionType`](@ref).
"""
function arrangeFreeFunctionCall(x::AbstractCodeGenModule, ctx::AbstractASTContext,
                                 ret::QualType, args::Vector{CXQualType},
                                 cc::CXCallingConv_=CXCallingConv_CC_C, noreturn::Bool=false,
                                 variadic::Bool=false, num_required::Integer=length(args))
    @check_ptrs x ctx ret
    @assert all(a -> a != CXQualType(C_NULL), args) "an argument type has a NULL pointer"
    @assert 0 <= num_required <= length(args) "num_required $num_required is not an argument count"
    return CGFunctionInfo(clang_CodeGen_arrangeFreeFunctionCall(x, ctx, ret, args,
                                                                length(args), cc, noreturn,
                                                                variadic, num_required))
end

function arrangeFreeFunctionCall(x::AbstractCodeGenModule, ctx::AbstractASTContext,
                                 ret::QualType, args::Vector{QualType},
                                 cc::CXCallingConv_=CXCallingConv_CC_C, noreturn::Bool=false,
                                 variadic::Bool=false, num_required::Integer=length(args))
    handles = CXQualType[Base.unsafe_convert(CXQualType, a) for a in args]
    return arrangeFreeFunctionCall(x, ctx, ret, handles, cc, noreturn, variadic, num_required)
end

"""
    getImplicitCXXConstructorArgs(x::AbstractCodeGenModule, d::AbstractCXXConstructorDecl) -> Tuple{Vector{LLVM.Value},Vector{LLVM.Value}}
The implicit arguments a complete, non-delegating call to `d` must pass beyond `this`: those
that go before the explicit arguments, and those that go after.

These are the VTT under the Itanium ABI and the most-derived flag under the Microsoft one,
so on macOS and Linux both halves are usually empty.
"""
function getImplicitCXXConstructorArgs(x::AbstractCodeGenModule, d::AbstractCXXConstructorDecl)
    @check_ptrs x d
    # `ImplicitCXXConstructorArgs` holds two `SmallVector<llvm::Value *, 1>`, so a buffer of
    # four is already past every shape clang builds today; the resize path exists so a future
    # ABI that adds one cannot silently truncate.
    cap = Cuint(4)
    prefix = Vector{LLVM.API.LLVMValueRef}(undef, cap)
    suffix = Vector{LLVM.API.LLVMValueRef}(undef, cap)
    nprefix, nsuffix = Ref{Cuint}(0), Ref{Cuint}(0)
    clang_CodeGen_getImplicitCXXConstructorArgs(x, d, cap, prefix, nprefix, cap, suffix,
                                                nsuffix)
    if nprefix[] > cap || nsuffix[] > cap
        resize!(prefix, nprefix[])
        resize!(suffix, nsuffix[])
        clang_CodeGen_getImplicitCXXConstructorArgs(x, d, nprefix[], prefix, nprefix,
                                                    nsuffix[], suffix, nsuffix)
    end
    return ([LLVM.Value(prefix[i]) for i in 1:nprefix[]],
            [LLVM.Value(suffix[i]) for i in 1:nsuffix[]])
end

"""
    convertFreeFunctionType(x::AbstractCodeGenModule, d::AbstractFunctionDecl) -> LLVM.API.LLVMTypeRef
The LLVM function type `d` lowers to, or a null reference when `d`'s type is incomplete and
cannot be lowered.

The raw reference is returned rather than an `LLVM.FunctionType`, matching
[`convertTypeForMemory`](@ref); wrap it with `LLVM.LLVMType` once it is known non-null.
"""
function convertFreeFunctionType(x::AbstractCodeGenModule, d::AbstractFunctionDecl)
    @check_ptrs x d
    return clang_CodeGen_convertFreeFunctionType(x, d)
end

"""
    getLLVMFieldNumber(x::AbstractCodeGenModule, rd::AbstractRecordDecl, fd::AbstractFieldDecl) -> Cuint
The index of `fd` inside the LLVM struct [`convertTypeForMemory`](@ref) produces for `rd`.

Padding and bitfield storage units are inserted by codegen, so this is not `fd`'s position
among `rd`'s fields, and it is the index a GEP has to use.

PRECONDITION (stated by the clang header): `fd` must be a direct, non-bitfield field of
`rd`. An inherited or bitfield field is looked up in a table that does not contain it.
"""
function getLLVMFieldNumber(x::AbstractCodeGenModule, rd::AbstractRecordDecl,
                            fd::AbstractFieldDecl)
    @check_ptrs x rd fd
    @assert !isBitField(fd) "getLLVMFieldNumber is not defined for a bitfield"
    # `getParent` answers a `RecordDecl` carrier while `rd` may be a `CXXRecordDecl` one, so
    # the two handles have different pointer types even when they name the same decl; the
    # comparison is of the addresses, which is what "declared directly in rd" means.
    @assert Ptr{Cvoid}(getParent(fd).ptr) == Ptr{Cvoid}(rd.ptr) "getLLVMFieldNumber needs a field declared directly in rd"
    return clang_CodeGen_getLLVMFieldNumber(x, rd, fd)
end

"""
    AttrBuilder(ctx::LLVM.Context) -> AttrBuilder
An empty `llvm::AttrBuilder`, the accumulator
[`addDefaultFunctionDefinitionAttributes`](@ref) writes into.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function AttrBuilder(ctx::LLVM.Context)
    @assert ctx.ref != C_NULL "LLVMContextRef has a NULL pointer."
    ab = clang_AttrBuilder_create(ctx)
    @assert ab != C_NULL "Failed to create AttrBuilder"
    return AttrBuilder(ab)
end

dispose(x::AbstractAttrBuilder) = clang_AttrBuilder_dispose(x)

"""
    addDefaultFunctionDefinitionAttributes(x::AbstractCodeGenModule, ab::AbstractAttrBuilder)
Fill `ab` with the IR attributes clang would put on a function it defined itself under `x`'s
configuration — target CPU, target features, the frame-pointer policy and so on.

Entries already in `ab` are neither consulted nor preserved, so build on top of the result
rather than before it.
"""
function addDefaultFunctionDefinitionAttributes(x::AbstractCodeGenModule,
                                                ab::AbstractAttrBuilder)
    @check_ptrs x ab
    return clang_CodeGen_addDefaultFunctionDefinitionAttributes(x, ab)
end

"""
    getNumAttributes(x::AbstractAttrBuilder) -> Cuint
How many attributes the builder currently holds.
"""
function getNumAttributes(x::AbstractAttrBuilder)
    @check_ptrs x
    return clang_AttrBuilder_getNumAttributes(x)
end

"""
    getAttributeAsString(x::AbstractAttrBuilder, i::Integer) -> String
The `i`-th (0-based, `i < getNumAttributes(x)`) attribute, spelled the way it is printed in
IR.
"""
function getAttributeAsString(x::AbstractAttrBuilder, i::Integer)
    @check_ptrs x
    @assert 0 <= i < getNumAttributes(x) "attribute index $i out of range"
    return get_string(clang_AttrBuilder_getAttributeAsString(x, i))
end

"""
    Base.contains(x::AbstractAttrBuilder, kind::AbstractString) -> Bool
Whether the builder carries a string attribute spelled `kind`, e.g. `"target-cpu"`.
"""
function Base.contains(x::AbstractAttrBuilder, kind::AbstractString)
    @check_ptrs x
    return clang_AttrBuilder_contains(x, kind)
end

"""
    applyToFunction(x::AbstractAttrBuilder, f::LLVM.Value) -> Bool
Add everything in `x` to `f` as function attributes. False when `f` is not an
`llvm::Function` — the parameter is widened to `LLVM.Value` because that refusal is the
answer for, say, a global variable, and clang's `GetAddrOfGlobal` hands back both.

`f` must live in the same `LLVM.Context` the builder was created with; attributes do not
cross contexts.
"""
function applyToFunction(x::AbstractAttrBuilder, f::LLVM.Value)
    @check_ptrs x
    return clang_AttrBuilder_applyToFunction(x, f)
end
