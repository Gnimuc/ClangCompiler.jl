#include "clang-ex/AST/CXDeclFriend.h"

#include "clang/AST/DeclFriend.h"

CXTypeSourceInfo clang_FriendDecl_getFriendType(CXFriendDecl FD) {
  return reinterpret_cast<CXTypeSourceInfo>(
      reinterpret_cast<clang::FriendDecl *>(FD)->getFriendType());
}

unsigned clang_FriendDecl_getFriendTypeNumTemplateParameterLists(CXFriendDecl FD) {
  return reinterpret_cast<clang::FriendDecl *>(FD)->getFriendTypeNumTemplateParameterLists();
}

CXTemplateParameterList
clang_FriendDecl_getFriendTypeTemplateParameterList(CXFriendDecl FD, unsigned N) {
  return reinterpret_cast<CXTemplateParameterList>(
      reinterpret_cast<clang::FriendDecl *>(FD)->getFriendTypeTemplateParameterList(N));
}

CXNamedDecl clang_FriendDecl_getFriendDecl(CXFriendDecl FD) {
  return reinterpret_cast<CXNamedDecl>(
      reinterpret_cast<clang::FriendDecl *>(FD)->getFriendDecl());
}

CXSourceLocation_ clang_FriendDecl_getFriendLoc(CXFriendDecl FD) {
  return reinterpret_cast<CXSourceLocation_>(
      reinterpret_cast<clang::FriendDecl *>(FD)->getFriendLoc().getPtrEncoding());
}

CXSourceRange_ clang_FriendDecl_getSourceRange(CXFriendDecl FD) {
  auto Rng = reinterpret_cast<clang::FriendDecl *>(FD)->getSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(Rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(Rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}
