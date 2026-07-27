#ifndef LLVM_CLANG_C_EXTRA_CXDRIVER_H
#define LLVM_CLANG_C_EXTRA_CXDRIVER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/Driver/Driver.h: enum clang::driver::LTOKind, mirrored in declaration order.
typedef enum CXLTOKind {
  CXLTOKind_LTOK_None,
  CXLTOKind_LTOK_Full,
  CXLTOKind_LTOK_Thin,
  CXLTOKind_LTOK_Unknown
} CXLTOKind;

// The Driver stores `DiagnosticsEngine &Diags`: dispose the Driver BEFORE the
// DiagnosticsEngine it was created with.
CXDriver clang_Driver_create(const char *ClangExecutable, const char *TargetTriple,
                             CXDiagnosticsEngine Diags);

void clang_Driver_dispose(CXDriver D);

bool clang_Driver_CCCIsCXX(CXDriver D);

bool clang_Driver_CCCIsCPP(CXDriver D);

bool clang_Driver_CCCIsCC(CXDriver D);

bool clang_Driver_IsCLMode(CXDriver D);

bool clang_Driver_IsFlangMode(CXDriver D);

bool clang_Driver_IsDXCMode(CXDriver D);

CXString clang_Driver_getCCCGenericGCCName(CXDriver D);

CXDiagnosticsEngine clang_Driver_getDiags(CXDriver D);

bool clang_Driver_getCheckInputsExist(CXDriver D);

void clang_Driver_setCheckInputsExist(CXDriver D, bool Value);

CXString clang_Driver_getTitle(CXDriver D);

void clang_Driver_setTitle(CXDriver D, const char *Value);

CXString clang_Driver_getTargetTriple(CXDriver D);

const char *clang_Driver_getClangProgramPath(CXDriver D);

const char *clang_Driver_getInstalledDir(CXDriver D);

// helper: the public `Driver::Dir` field (path the driver executable was in).
const char *clang_Driver_getDir(CXDriver D);

// helper: the public `Driver::ResourceDir` field.
const char *clang_Driver_getResourceDir(CXDriver D);

// helper: the public `Driver::SysRoot` field.
const char *clang_Driver_getSysRoot(CXDriver D);

// helper: the public `Driver::DyldPrefix` field.
const char *clang_Driver_getDyldPrefix(CXDriver D);

// Borrowed string literal ("a.out" or "a.exe"), never freed.
const char *clang_Driver_getDefaultImageName(CXDriver D);

// IsOffload selects the offload LTO mode instead of the host one; the C++ default
// is false.
//
// PRECONDITION: the Driver must already have processed arguments. Driver::LTOMode
// and Driver::OffloadLTOMode are plain members with NO default initializer, written
// only by the private setLTOMode() during BuildCompilation — reading them before
// that is undefined behaviour and has been observed returning a value outside the
// enum. The Julia wrapper restates this.
CXLTOKind clang_Driver_getLTOMode(CXDriver D, bool IsOffload);

// BuildCompilation / BuildActions / the Compilation and ActionList accessors are
// deliberately not wrapped.

size_t clang_Driver_GetResourcesPathLength(const char *BinaryPath);

void clang_Driver_GetResourcesPath(const char *BinaryPath, char *ResourcesPath, size_t N);

LLVM_CLANG_C_EXTERN_C_END

#endif