# Attr
function getKind(x::Attr)
    @check_ptrs x
    return clang_Attr_getKind(x)
end

# The attribute's source spelling (e.g. "aligned"); borrowed clang-owned storage.
function getSpelling(x::Attr)
    @check_ptrs x
    return unsafe_string(clang_Attr_getSpelling(x))
end

function getRange(x::Attr)
    @check_ptrs x
    return SourceRange(clang_Attr_getRange(x))
end

function getLocation(x::Attr)
    @check_ptrs x
    return SourceLocation(clang_Attr_getLocation(x))
end

function isImplicit(x::Attr)
    @check_ptrs x
    return clang_Attr_isImplicit(x)
end

function isInherited(x::Attr)
    @check_ptrs x
    return clang_Attr_isInherited(x)
end

function isPackExpansion(x::Attr)
    @check_ptrs x
    return clang_Attr_isPackExpansion(x)
end
