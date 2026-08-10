#ifndef LLVM_CLANG_C_EXTRA_CXDECLFRIEND_H
#define LLVM_CLANG_C_EXTRA_CXDECLFRIEND_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// A friend declaration names either a type ("friend class S;") or a declaration
// ("friend void f();"), never both: the two getters below are the discriminator, and
// exactly one of them is non-NULL on any FriendDecl. clang_CXXRecordDecl_getFriends
// enumerates these.

// Non-NULL iff the friend names a type.
CXTypeSourceInfo clang_FriendDecl_getFriendType(CXFriendDecl FD);

unsigned clang_FriendDecl_getFriendTypeNumTemplateParameterLists(CXFriendDecl FD);

// Precondition: N < clang_FriendDecl_getFriendTypeNumTemplateParameterLists(FD). The
// clang method asserts it.
CXTemplateParameterList
clang_FriendDecl_getFriendTypeTemplateParameterList(CXFriendDecl FD, unsigned N);

// Non-NULL iff the friend names a declaration rather than a type.
CXNamedDecl clang_FriendDecl_getFriendDecl(CXFriendDecl FD);

CXSourceLocation_ clang_FriendDecl_getFriendLoc(CXFriendDecl FD);

CXSourceRange_ clang_FriendDecl_getSourceRange(CXFriendDecl FD);

LLVM_CLANG_C_EXTERN_C_END

#endif
