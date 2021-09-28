# CodeGenerator
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

function StartModule(x::CodeGenerator, ctx::Context, mod_name::String)
    @check_ptrs x
    @assert ctx.ref != C_NULL "LLVMContextRef has a NULL pointer."
    return LLVM.Module(clang_CodeGenerator_StartModule(x, ctx, mod_name))
end
