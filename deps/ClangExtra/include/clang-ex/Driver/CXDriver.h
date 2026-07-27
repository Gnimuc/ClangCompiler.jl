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

// Paths to the configuration files the driver loaded, as a count + index pair. The
// list is empty until a command line has been processed; the returned pointers are
// borrowed from the Driver's std::vector<std::string> and are never freed.
unsigned clang_Driver_getNumConfigFiles(CXDriver D);

const char *clang_Driver_getConfigFile(CXDriver D, unsigned i);

bool clang_Driver_getProbePrecompiled(CXDriver D);

void clang_Driver_setProbePrecompiled(CXDriver D, bool Value);

// The argument prepended before reinvoking clang, or NULL when none is set. The
// Driver stores the pointer WITHOUT copying it, so Value must outlive the Driver.
const char *clang_Driver_getPrependArg(CXDriver D);

void clang_Driver_setPrependArg(CXDriver D, const char *Value);

void clang_Driver_setInstalledDir(CXDriver D, const char *Value);

// The predicates below read Driver::SaveTemps / BitcodeEmbed / Offload /
// CXX20HeaderType -- plain members with no in-class initializer that command-line
// processing refines. Each of them is a comparison, so the answer is always a valid
// bool (unlike getLTOMode, which hands the raw enum out), but it is only meaningful
// once the driver has processed arguments.
bool clang_Driver_isSaveTempsEnabled(CXDriver D);

bool clang_Driver_isSaveTempsObj(CXDriver D);

bool clang_Driver_embedBitcodeEnabled(CXDriver D);

bool clang_Driver_embedBitcodeInObject(CXDriver D);

bool clang_Driver_embedBitcodeMarkerOnly(CXDriver D);

bool clang_Driver_offloadHostOnly(CXDriver D);

bool clang_Driver_offloadDeviceOnly(CXDriver D);

// True when -fmodule-header selected a C++20 header-unit mode.
bool clang_Driver_hasHeaderMode(CXDriver D);

// getModuleHeaderMode -- deliberately not wrapped: unlike hasHeaderMode it hands the
// raw Driver::CXX20HeaderType out, and that member has no in-class initializer, so
// reading it is the getLTOMode problem with no observable gate to assert on.

// Reads the same uninitialized Driver::LTOMode / OffloadLTOMode members as
// clang_Driver_getLTOMode, but compares them instead of returning the raw enum, so the
// result is always a valid bool; it is only meaningful once the driver has processed
// arguments. IsOffload selects the offload mode instead of the host one (the C++
// default is false).
bool clang_Driver_isUsingLTO(CXDriver D, bool IsOffload);

// BuildCompilation / BuildActions / the Compilation and ActionList accessors are
// deliberately not wrapped.

// BuildCompilation runs argument parsing, toolchain selection, action building and job
// building. It is what assigns the Driver members that have no in-class initializer, so
// clang_Driver_getLTOMode, clang_Driver_isUsingLTO, clang_Driver_isSaveTempsEnabled,
// clang_Driver_hasHeaderMode and the config-file list are only well-defined on a Driver
// a compilation has been built with.
//
// Args is a full argv: Args[0] is dereferenced to pick the driver mode, so NumArgs must
// be at least 1. The returned Compilation is owned by the caller
// (clang_Compilation_dispose) and its destructor reads the Driver, so dispose it before
// the Driver. NULL means no compilation was built, which is not by itself an error --
// the DiagnosticsEngine reports whether one occurred.
CXCompilation clang_Driver_BuildCompilation(CXDriver D, const char **Args,
                                            unsigned NumArgs);

// PrintActions
// PrintHelp

// The driver's version banner, rendered into a string instead of the raw_ostream the
// C++ signature writes to.
CXString clang_Driver_PrintVersion(CXDriver D, CXCompilation C);

// Look Name up in TC's file search paths.
CXString clang_Driver_GetFilePath(CXDriver D, const char *Name, CXToolChain TC);

// Look Name up in TC's program search paths.
CXString clang_Driver_GetProgramPath(CXDriver D, const char *Name, CXToolChain TC);

// HandleAutocompletions
// HandleImmediateArgs

size_t clang_Driver_GetResourcesPathLength(const char *BinaryPath);

void clang_Driver_GetResourcesPath(const char *BinaryPath, char *ResourcesPath, size_t N);

// GetTemporaryPath and GetTemporaryDirectory CREATE the file (respectively the
// directory) on disk before returning its path; the caller owns it and nothing in the
// driver ever removes it. Both report failure through the Driver's DiagnosticsEngine
// and return an empty string.
CXString clang_Driver_GetTemporaryPath(CXDriver D, const char *Prefix, const char *Suffix);

CXString clang_Driver_GetTemporaryDirectory(CXDriver D, const char *Prefix);

// Parse "major[.minor[.micro]][extra]". Returns true when the whole string was
// consumed, or when every group parsed and only trailing characters remain (*HadExtra
// then reports them). Groups the string does not provide come back as 0, and all four
// out-params are written on every call.
bool clang_Driver_GetReleaseVersion(const char *Str, unsigned *Major, unsigned *Minor,
                                    unsigned *Micro, bool *HadExtra);

// GetReleaseVersion(StringRef, MutableArrayRef<unsigned>) overload: parses up to N
// dot-separated groups into Digits, which is zeroed first, so every slot is written.
// Stricter than the four-out-param form -- it returns true only when the entire string
// was consumed with nothing left over.
bool clang_Driver_GetReleaseVersionDigits(const char *Str, unsigned *Digits, unsigned N);

// The default -fmodule-cache-path, or an empty string when the system provides no
// cache directory (the C++ false return; on success the path is never empty).
CXString clang_Driver_getDefaultModuleCachePath(void);

// --- Driver identity and search-prefix state (public data members) -------------------
//
// These read members the Driver constructor sets, so they are total: no BuildCompilation
// is needed and there is no uninitialized-read window.

// The name the driver was invoked as (argv[0]'s stem).
CXString clang_Driver_getName(CXDriver D);

// The system-wide configuration directory the driver searches.
CXString clang_Driver_getSystemConfigDir(CXDriver D);

// The per-user configuration directory the driver searches.
CXString clang_Driver_getUserConfigDir(CXDriver D);

// The prefix directories searched ahead of the toolchain's own, as a count + index pair
// (MARSHALLING.md section 6). These come from every -B on the command line AND from the
// COMPILER_PATH environment variable, so the count is host-dependent -- never assert a
// particular one. Idx must be < the count; the Julia wrapper restates that.
unsigned clang_Driver_getNumPrefixDirs(CXDriver D);
CXString clang_Driver_getPrefixDir(CXDriver D, unsigned Idx);

LLVM_CLANG_C_EXTERN_C_END

#endif