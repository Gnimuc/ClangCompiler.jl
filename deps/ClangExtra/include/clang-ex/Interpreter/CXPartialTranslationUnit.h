#ifndef LLVM_CLANG_C_EXTRA_CXPARTIALTRANSLATIONUNIT_H
#define LLVM_CLANG_C_EXTRA_CXPARTIALTRANSLATIONUNIT_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "llvm-c/Types.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::PartialTranslationUnit is a two-field struct, not a class: these are its members
// rather than accessors clang declares. A PTU handle comes from clang_Interpreter_Parse and
// points into the interpreter's PTU list, so it is borrowed and invalidated by
// clang_Interpreter_Undo.

// The TranslationUnitDecl holding just this increment's declarations.
CXTranslationUnitDecl clang_PartialTranslationUnit_getTUPart(CXPartialTranslationUnit PTU);

// The IR module generated for this increment, borrowed. NULL once
// clang_Interpreter_Execute has run: Execute moves the unique_ptr out into the JIT.
LLVMModuleRef clang_PartialTranslationUnit_getModule(CXPartialTranslationUnit PTU);

LLVM_CLANG_C_EXTERN_C_END

#endif
