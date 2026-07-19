# TypeLoc — every TypeLoc handle is an owned heap box; `dispose` it after use.
function getTypeLoc(x::TypeSourceInfo)
    @check_ptrs x
    return TypeLoc(clang_TypeSourceInfo_getTypeLoc(x))
end

function getType(x::TypeLoc)
    @check_ptrs x
    return QualType(clang_TypeLoc_getType(x))
end

function getBeginLoc(x::TypeLoc)
    @check_ptrs x
    return SourceLocation(clang_TypeLoc_getBeginLoc(x))
end

function getEndLoc(x::TypeLoc)
    @check_ptrs x
    return SourceLocation(clang_TypeLoc_getEndLoc(x))
end

function getSourceRange(x::TypeLoc)
    @check_ptrs x
    r = clang_TypeLoc_getSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

function getLocalSourceRange(x::TypeLoc)
    @check_ptrs x
    r = clang_TypeLoc_getLocalSourceRange(x)
    return SourceRange(SourceLocation(r.B), SourceLocation(r.E))
end

# The next TypeLoc in the chain; an owned box (dispose it), null at the chain end.
function getNextTypeLoc(x::TypeLoc)
    @check_ptrs x
    return TypeLoc(clang_TypeLoc_getNextTypeLoc(x))
end

isNull(x::TypeLoc) = (@check_ptrs x; clang_TypeLoc_isNull(x))

dispose(x::TypeLoc) = clang_TypeLoc_dispose(x)
