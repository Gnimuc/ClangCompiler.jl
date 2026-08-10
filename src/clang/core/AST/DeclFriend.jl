"""
    struct FriendDecl <: AbstractFriendDecl
Hold a pointer to a `clang::FriendDecl` object.
"""
struct FriendDecl <: AbstractFriendDecl
    ptr::CXFriendDecl
end
