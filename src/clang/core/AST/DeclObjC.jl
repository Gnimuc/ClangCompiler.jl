"""
    struct ObjCMethodDecl <: AbstractObjCMethodDecl
Hold a pointer to a `clang::ObjCMethodDecl` object.
"""
struct ObjCMethodDecl <: AbstractObjCMethodDecl
    ptr::CXObjCMethodDecl
end

"""
    struct ObjCContainerDecl <: AbstractObjCContainerDecl
Hold a pointer to a `clang::ObjCContainerDecl` object.
"""
struct ObjCContainerDecl <: AbstractObjCContainerDecl
    ptr::CXObjCContainerDecl
end

"""
    struct ObjCProtocolDecl <: AbstractObjCProtocolDecl
Hold a pointer to a `clang::ObjCProtocolDecl` object.
"""
struct ObjCProtocolDecl <: AbstractObjCProtocolDecl
    ptr::CXObjCProtocolDecl
end

"""
    struct ObjCInterfaceDecl <: AbstractObjCInterfaceDecl
Hold a pointer to a `clang::ObjCInterfaceDecl` object.
"""
struct ObjCInterfaceDecl <: AbstractObjCInterfaceDecl
    ptr::CXObjCInterfaceDecl
end

"""
    struct ObjCImplDecl <: AbstractObjCImplDecl
Hold a pointer to a `clang::ObjCImplDecl` object.
"""
struct ObjCImplDecl <: AbstractObjCImplDecl
    ptr::CXObjCImplDecl
end

"""
    struct ObjCImplementationDecl <: AbstractObjCImplementationDecl
Hold a pointer to a `clang::ObjCImplementationDecl` object.
"""
struct ObjCImplementationDecl <: AbstractObjCImplementationDecl
    ptr::CXObjCImplementationDecl
end

"""
    struct ObjCCategoryImplDecl <: AbstractObjCCategoryImplDecl
Hold a pointer to a `clang::ObjCCategoryImplDecl` object.
"""
struct ObjCCategoryImplDecl <: AbstractObjCCategoryImplDecl
    ptr::CXObjCCategoryImplDecl
end

"""
    struct ObjCCategoryDecl <: AbstractObjCCategoryDecl
Hold a pointer to a `clang::ObjCCategoryDecl` object.
"""
struct ObjCCategoryDecl <: AbstractObjCCategoryDecl
    ptr::CXObjCCategoryDecl
end

"""
    struct ObjCPropertyDecl <: AbstractObjCPropertyDecl
Hold a pointer to a `clang::ObjCPropertyDecl` object.
"""
struct ObjCPropertyDecl <: AbstractObjCPropertyDecl
    ptr::CXObjCPropertyDecl
end

"""
    struct ObjCCompatibleAliasDecl <: AbstractObjCCompatibleAliasDecl
Hold a pointer to a `clang::ObjCCompatibleAliasDecl` object.
"""
struct ObjCCompatibleAliasDecl <: AbstractObjCCompatibleAliasDecl
    ptr::CXObjCCompatibleAliasDecl
end

"""
    struct ObjCPropertyImplDecl <: AbstractObjCPropertyImplDecl
Hold a pointer to a `clang::ObjCPropertyImplDecl` object.
"""
struct ObjCPropertyImplDecl <: AbstractObjCPropertyImplDecl
    ptr::CXObjCPropertyImplDecl
end

"""
    struct ObjCIvarDecl <: AbstractObjCIvarDecl
Hold a pointer to a `clang::ObjCIvarDecl` object.
"""
struct ObjCIvarDecl <: AbstractObjCIvarDecl
    ptr::CXObjCIvarDecl
end

"""
    struct ObjCAtDefsFieldDecl <: AbstractObjCAtDefsFieldDecl
Hold a pointer to a `clang::ObjCAtDefsFieldDecl` object.
"""
struct ObjCAtDefsFieldDecl <: AbstractObjCAtDefsFieldDecl
    ptr::CXObjCAtDefsFieldDecl
end

"""
    struct ObjCTypeParamDecl <: AbstractObjCTypeParamDecl
Hold a pointer to a `clang::ObjCTypeParamDecl` object.
"""
struct ObjCTypeParamDecl <: AbstractObjCTypeParamDecl
    ptr::CXObjCTypeParamDecl
end
