#ifndef LLVM_CLANG_C_EXTRA_CXPRAGMAKINDS_H
#define LLVM_CLANG_C_EXTRA_CXPRAGMAKINDS_H

LLVM_CLANG_C_EXTERN_C_BEGIN

typedef enum CXPragmaMSCommentKind {
  CXPragmaMSCommentKind_PCK_Unknown,
  CXPragmaMSCommentKind_PCK_Linker,
  CXPragmaMSCommentKind_PCK_Lib,
  CXPragmaMSCommentKind_PCK_Compiler,
  CXPragmaMSCommentKind_PCK_ExeStr,
  CXPragmaMSCommentKind_PCK_User
} CXPragmaMSCommentKind;

typedef enum CXPragmaMSStructKind {
  CXPragmaMSStructKind_PMSST_OFF,
  CXPragmaMSStructKind_PMSST_ON
} CXPragmaMSStructKind;

typedef enum CXPragmaFloatControlKind {
  CXPragmaFloatControlKind_PFC_Unknown,
  CXPragmaFloatControlKind_PFC_Precise,
  CXPragmaFloatControlKind_PFC_NoPrecise,
  CXPragmaFloatControlKind_PFC_Except,
  CXPragmaFloatControlKind_PFC_NoExcept,
  CXPragmaFloatControlKind_PFC_Push,
  CXPragmaFloatControlKind_PFC_Pop
} CXPragmaFloatControlKind;

LLVM_CLANG_C_EXTERN_C_END

#endif