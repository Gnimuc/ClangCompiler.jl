# CodeGenerator
"""
    CodeGenerator(ci::CompilerInstance, mod_name::AbstractString, ctx::LLVM.Context) -> CodeGenerator
A standalone code generator: an `ASTConsumer` that lowers to LLVM IR with no
`FrontendAction` and no `Interpreter` driving it, which is what a hand-built
Parser + CodeGenerator pipeline needs.

Everything but `mod_name` and `ctx` is read off `ci` — its diagnostics engine, its
header-search / preprocessor / codegen options, and the virtual file system its file manager
holds.

PRECONDITION: `ci` must have a file manager; the LLVM 20 signature takes a virtual file
system and there is nowhere else to get one.

This function allocates and one should call `dispose` to release the resources after using
this object. It must outlive every `Sema` and `Parser` built against it.
"""
function CodeGenerator(ci::CompilerInstance, mod_name::AbstractString, ctx::LLVM.Context)
    @check_ptrs ci
    @assert ctx.ref != C_NULL "LLVMContextRef has a NULL pointer."
    @assert hasFileManager(ci) "CompilerInstance has no file manager."
    cg = clang_CreateLLVMCodeGen(ci, mod_name, ctx)
    @assert cg != C_NULL "Failed to create CodeGenerator"
    return CodeGenerator(cg)
end

"""
    dispose(x::AbstractCodeGenerator)
Release a code generator obtained from
[`CodeGenerator(::CompilerInstance, ::AbstractString, ::LLVM.Context)`](@ref).

Only that one. A generator handed to `setASTConsumer` belongs to the `CompilerInstance` from
then on, and the one `getCodeGen` returns belongs to the `Interpreter`; disposing either is a
double free.
"""
dispose(x::AbstractCodeGenerator) = clang_CodeGenerator_dispose(x)

function CGM(x::CodeGenerator)
    @check_ptrs x
    return CodeGenModule(clang_CodeGenerator_CGM(x))
end

function GetModule(x::CodeGenerator)
    @check_ptrs x
    return LLVM.Module(clang_CodeGenerator_GetModule(x))
end

function ReleaseModule(x::CodeGenerator)
    @check_ptrs x
    return LLVM.Module(clang_CodeGenerator_ReleaseModule(x))
end

function GetDeclForMangledName(x::CodeGenerator, s::String)
    @check_ptrs x
    return Decl(clang_CodeGenerator_GetDeclForMangledName(x, s))
end

"""
    GetMangledName(x::AbstractCodeGenerator, d::AbstractNamedDecl) -> String
The name codegen mangled `d` to. This is the name in the module, so unlike a name recomputed
from a `MangleContext` it cannot disagree with what was emitted.

Constructors and destructors have several emitted bodies and are rejected by clang's
`GlobalDecl` — use the `CXCXXCtorType`/`CXCXXDtorType` methods below for those.
"""
function GetMangledName(x::AbstractCodeGenerator, d::AbstractNamedDecl)
    @check_ptrs x d
    @assert !isCXXConstructorDecl(d) && !isCXXDestructorDecl(d) "a constructor or destructor has several mangled bodies; pass its CXCXXCtorType/CXCXXDtorType"
    return get_string(clang_CodeGenerator_GetMangledName(x, d))
end

"""
    GetMangledName(x::AbstractCodeGenerator, d::AbstractCXXConstructorDecl, kind::CXCXXCtorType) -> String
The mangled name of the constructor body `kind` selects.
"""
function GetMangledName(x::AbstractCodeGenerator, d::AbstractCXXConstructorDecl, kind::CXCXXCtorType)
    @check_ptrs x d
    return get_string(clang_CodeGenerator_GetMangledNameFromCtorDecl(x, d, kind))
end

"""
    GetMangledName(x::AbstractCodeGenerator, d::AbstractCXXDestructorDecl, kind::CXCXXDtorType) -> String
The mangled name of the destructor body `kind` selects.
"""
function GetMangledName(x::AbstractCodeGenerator, d::AbstractCXXDestructorDecl, kind::CXCXXDtorType)
    @check_ptrs x d
    return get_string(clang_CodeGenerator_GetMangledNameFromDtorDecl(x, d, kind))
end

"""
    GetAddrOfGlobal(x::AbstractCodeGenerator, d::AbstractNamedDecl, is_for_definition::Bool=false) -> Union{Nothing,LLVM.Value}
The constant naming `d`'s storage in the module this generator is currently building, and
the request that `d` be emitted into it — decl-driven codegen, as against handing the
generator more source.

With `is_for_definition` the result is an `llvm::GlobalValue`; without it, any constant
expression that names the entity. `nothing` when codegen produced no constant at all.

Constructors and destructors are rejected for the same reason as in
[`GetMangledName`](@ref).
"""
function GetAddrOfGlobal(x::AbstractCodeGenerator, d::AbstractNamedDecl, is_for_definition::Bool=false)
    @check_ptrs x d
    @assert !isCXXConstructorDecl(d) && !isCXXDestructorDecl(d) "a constructor or destructor has several emitted bodies; pass its CXCXXCtorType/CXCXXDtorType"
    v = clang_CodeGenerator_GetAddrOfGlobal(x, d, is_for_definition)
    return v == C_NULL ? nothing : LLVM.Value(v)
end

"""
    GetAddrOfGlobal(x::AbstractCodeGenerator, d::AbstractCXXConstructorDecl, kind::CXCXXCtorType, is_for_definition::Bool=false) -> Union{Nothing,LLVM.Value}
[`GetAddrOfGlobal`](@ref) for the constructor body `kind` selects.
"""
function GetAddrOfGlobal(x::AbstractCodeGenerator, d::AbstractCXXConstructorDecl, kind::CXCXXCtorType, is_for_definition::Bool=false)
    @check_ptrs x d
    v = clang_CodeGenerator_GetAddrOfGlobalFromCtorDecl(x, d, kind, is_for_definition)
    return v == C_NULL ? nothing : LLVM.Value(v)
end

"""
    GetAddrOfGlobal(x::AbstractCodeGenerator, d::AbstractCXXDestructorDecl, kind::CXCXXDtorType, is_for_definition::Bool=false) -> Union{Nothing,LLVM.Value}
[`GetAddrOfGlobal`](@ref) for the destructor body `kind` selects.
"""
function GetAddrOfGlobal(x::AbstractCodeGenerator, d::AbstractCXXDestructorDecl, kind::CXCXXDtorType, is_for_definition::Bool=false)
    @check_ptrs x d
    v = clang_CodeGenerator_GetAddrOfGlobalFromDtorDecl(x, d, kind, is_for_definition)
    return v == C_NULL ? nothing : LLVM.Value(v)
end

function StartModule(x::CodeGenerator, ctx::LLVM.Context, mod_name::String)
    @check_ptrs x
    @assert ctx.ref != C_NULL "LLVMContextRef has a NULL pointer."
    return LLVM.Module(clang_CodeGenerator_StartModule(x, ctx, mod_name))
end
