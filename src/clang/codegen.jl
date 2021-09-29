# CodeGen
function start_llvm_module(x::CodeGenerator, ctx::Context, mod_name::String)
    return StartModule(x, ctx, mod_name)
end

get_llvm_module(x::CodeGenerator) = GetModule(x)

release_llvm_module(x::CodeGenerator) = ReleaseModule(x)

get_decl(x::CodeGenerator, s::String) = GetDeclForMangledName(x, s)
