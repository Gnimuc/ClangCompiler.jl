# DeclarationName
DeclarationName() = DeclarationName(clang_DeclarationName_create())

function DeclarationName(x::IdentifierInfo)
    @check_ptrs x
    return DeclarationName(clang_DeclarationName_createFromIdentifierInfo(x))
end

dump(x::DeclarationName) = clang_DeclarationName_dump(x)

isEmpty(x::DeclarationName) = clang_DeclarationName_isEmpty(x)

function getAsString(x::DeclarationName)
    str = clang_DeclarationName_getAsString(x)
    s = unsafe_string(str)
    clang_DeclarationName_disposeString(str)
    return s
end
