# DeclarationName
DeclarationName() = DeclarationName(clang_DeclarationName_create())

function DeclarationName(x::IdentifierInfo)
    @check_ptrs x
    return DeclarationName(clang_DeclarationName_createFromIdentifierInfo(x))
end

dump(x::DeclarationName) = clang_DeclarationName_dump(x)

isEmpty(x::DeclarationName) = clang_DeclarationName_isEmpty(x)

getAsString(x::DeclarationName) = get_string(clang_DeclarationName_getAsString(x))

# DeclarationNameInfo
function DeclarationNameInfo(name::DeclarationName, loc::SourceLocation)
    return DeclarationNameInfo(clang_DeclarationNameInfo_create(name, loc))
end

dispose(x::DeclarationNameInfo) = clang_DeclarationNameInfo_dispose(x)

function getName(x::DeclarationNameInfo)
    @check_ptrs x
    return DeclarationName(clang_DeclarationNameInfo_getName(x))
end

function getLoc(x::DeclarationNameInfo)
    @check_ptrs x
    return SourceLocation(clang_DeclarationNameInfo_getLoc(x))
end

function getBeginLoc(x::DeclarationNameInfo)
    @check_ptrs x
    return SourceLocation(clang_DeclarationNameInfo_getBeginLoc(x))
end

function getEndLoc(x::DeclarationNameInfo)
    @check_ptrs x
    return SourceLocation(clang_DeclarationNameInfo_getEndLoc(x))
end

function getAsString(x::DeclarationNameInfo)
    @check_ptrs x
    return get_string(clang_DeclarationNameInfo_getAsString(x))
end
