# NestedNameSpecifier
function getPrefix(x::NestedNameSpecifier)
    @check_ptrs x
    return NestedNameSpecifier(clang_NestedNameSpecifier_getPrefix(x.ptr))
end

function containsErrors(x::NestedNameSpecifier)
    @check_ptrs x
    return clang_NestedNameSpecifier_containsErrors(x.ptr)
end

function dump(x::NestedNameSpecifier)
    @check_ptrs x
    return clang_NestedNameSpecifier_dump(x.ptr)
end
