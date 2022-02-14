# CodeGenTypes
function convertTypeForMemory(x::CodeGenModule, t::AbstractQualType)
    @check_ptrs x
    return clang_CodeGen_convertTypeForMemory(x, t)
end
