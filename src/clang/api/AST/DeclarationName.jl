# DeclarationName
DeclarationName() = DeclarationName(clang_DeclarationName_create())

function DeclarationName(x::IdentifierInfo)
    @check_ptrs x
    return DeclarationName(clang_DeclarationName_createFromIdentifierInfo(x))
end

dump(x::DeclarationName) = clang_DeclarationName_dump(x)

isEmpty(x::DeclarationName) = clang_DeclarationName_isEmpty(x)

getAsString(x::DeclarationName) = get_string(clang_DeclarationName_getAsString(x))
