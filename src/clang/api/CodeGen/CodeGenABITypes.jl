# CodeGenTypes
function convertTypeForMemory(x::CodeGenModule, t::QualType)
    @check_ptrs x
    return clang_CodeGen_convertTypeForMemory(x, t)
end
