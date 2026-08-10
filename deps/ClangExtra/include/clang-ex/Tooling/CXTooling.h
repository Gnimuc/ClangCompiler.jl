#ifndef LLVM_CLANG_C_EXTRA_CXTOOLING_H
#define LLVM_CLANG_C_EXTRA_CXTOOLING_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Every entry point in this file defaults the PCHContainerOperations the clang signature
// leaves defaultable: the shim constructs a fresh std::make_shared<PCHContainerOperations>()
// per call, which is what clang's own default argument does. Nothing about it is observable
// from Julia, so it is not a parameter here.

// getCC1Arguments
// ToolAction
// FrontendActionFactory
// newFrontendActionFactory
// SourceFileCallbacks
// runToolOnCode

// Runs ToolAction over Code with -fsyntax-only plus Args, mapping the snippet in as FileName.
// ToolName is the binary name the standard library search paths are resolved relative to.
// The N pairs (VirtualFileNames[i], VirtualFileContents[i]) are mapped in as extra in-memory
// files, so a snippet can #include one. Returns true if the action ran successfully.
//
// ADOPTION: clang takes the action by unique_ptr and destroys it before returning, so the
// CXFrontendAction handle is dangling on the way out -- do not run it again and do not call
// its own dispose (clang_CodeGenAction_dispose for the Emit* family). Pass a freshly created
// action every time.
//
// The overload taking an explicit llvm::vfs::FileSystem is not wrapped: no VFS handle crosses
// this boundary yet.
bool clang_tooling_runToolOnCodeWithArgs(CXFrontendAction ToolAction, const char *Code,
                                         const char **Args, unsigned NumArgs,
                                         const char *FileName, const char *ToolName,
                                         const char **VirtualFileNames,
                                         const char **VirtualFileContents,
                                         unsigned NumVirtualFiles);

// One-call parse of a code string. Returns null when the AST could not be built; otherwise a
// caller-owned unit, released with clang_ASTUnit_dispose.
CXASTUnit clang_tooling_buildASTFromCode(const char *Code, const char *FileName);

// buildASTFromCode with the flags, tool name, arguments adjuster, virtual files and
// diagnostic consumer clang's longer overload takes.
//
// Adjuster may be null, in which case clang's own default applies -- the strip-dependency-file
// adjuster, NOT "no adjustment". The adjuster is copied, so the handle stays the caller's.
// DiagConsumer may be null; it is borrowed either way and outlives nothing.
//
// Returns null when the AST could not be built; otherwise a caller-owned unit, released with
// clang_ASTUnit_dispose.
CXASTUnit clang_tooling_buildASTFromCodeWithArgs(
    const char *Code, const char **Args, unsigned NumArgs, const char *FileName,
    const char *ToolName, CXArgumentsAdjuster Adjuster, const char **VirtualFileNames,
    const char **VirtualFileContents, unsigned NumVirtualFiles,
    CXDiagnosticConsumer DiagConsumer);

// ToolInvocation
//
// Runs one FrontendAction over one synthetic command line. CommandLine[0] is the binary name
// clang locates its builtin headers relative to, not a flag.
//
// ADOPTION: the constructor takes the action by unique_ptr and the invocation deletes it in
// its own destructor, so the CXFrontendAction handle must never be disposed by the caller
// afterwards and must not be handed to a second invocation.
//
// Files is borrowed: the invocation stores the raw pointer and never frees it, so the
// FileManager has to outlive the invocation.
CXToolInvocation clang_ToolInvocation_create(const char **CommandLine, unsigned N,
                                             CXFrontendAction Action, CXFileManager Files);

void clang_ToolInvocation_dispose(CXToolInvocation TI);

// Borrowed, and used for both driver command-line parsing and the action itself. The consumer
// must outlive the invocation.
void clang_ToolInvocation_setDiagnosticConsumer(CXToolInvocation TI,
                                                CXDiagnosticConsumer DiagConsumer);

// Borrowed, and used for driver command-line parsing. Must outlive the invocation. No pin is
// needed: clang_DiagnosticOptions_create hands the options back already holding the caller's
// reference, so the printer and engine run() builds on the stack borrow them 1 -> 2 -> 1 and
// the caller's own dispose still frees.
void clang_ToolInvocation_setDiagnosticOptions(CXToolInvocation TI,
                                               CXDiagnosticOptions DiagOpts);

// True when the invocation ran without errors.
bool clang_ToolInvocation_run(CXToolInvocation TI);

// ClangTool
//
// Compilations is BORROWED and stored as a reference: the database must outlive the tool.
// SourcePaths are copied. Caller-owned: release with clang_ClangTool_dispose.
CXClangTool clang_ClangTool_create(CXCompilationDatabase Compilations,
                                   const char **SourcePaths, unsigned N);

void clang_ClangTool_dispose(CXClangTool CT);

// Both strings are copied into the tool's in-memory file system.
void clang_ClangTool_mapVirtualFile(CXClangTool CT, const char *FilePath, const char *Content);

// The adjuster is copied into the tool's chain, so the handle stays the caller's.
void clang_ClangTool_appendArgumentsAdjuster(CXClangTool CT, CXArgumentsAdjuster Adjuster);

// Drops the whole chain, including the syntax-only and strip-output adjusters the constructor
// installed -- after this the raw command lines of the database are used as they are.
void clang_ClangTool_clearArgumentsAdjusters(CXClangTool CT);

// Borrowed: the consumer must outlive the tool.
void clang_ClangTool_setDiagnosticConsumer(CXClangTool CT, CXDiagnosticConsumer DiagConsumer);

void clang_ClangTool_setPrintErrorMessage(CXClangTool CT, bool PrintErrorMessage);

// The file manager shared by every translation unit the tool builds, borrowed.
CXFileManager clang_ClangTool_getFiles(CXClangTool CT);

unsigned clang_ClangTool_getNumSourcePaths(CXClangTool CT);

// Borrowed. PRECONDITION: Index < clang_ClangTool_getNumSourcePaths(CT).
const char *clang_ClangTool_getSourcePath(CXClangTool CT, unsigned Index);

// Parses every translation unit the tool covers and writes the resulting units into ASTs,
// which must have room for MaxASTs of them. *NumASTs, when non-null, receives how many units
// were actually built -- one per compile command that ran, which is not necessarily one per
// source path. A unit written into ASTs is CALLER-OWNED (clang_ASTUnit_dispose); should the
// build produce more than MaxASTs, the surplus is destroyed rather than leaked and *NumASTs
// reports the larger figure, so a caller that sees NumASTs > MaxASTs has lost work and must
// re-run with a bigger buffer.
//
// Returns clang's own status: 0 on success, 1 if any error occurred, 2 if no error occurred
// but some files were skipped for want of a compile command.
//
// run(ToolAction *) is deliberately absent: ToolAction is an abstract interface whose only
// method a caller has to implement, which needs a trampoline back into Julia.
int clang_ClangTool_buildASTs(CXClangTool CT, CXASTUnit *ASTs, unsigned MaxASTs,
                              unsigned *NumASTs);

// getAbsolutePath
// addTargetAndModeForProgramName
// addExpandedResponseFiles
// newInvocation

LLVM_CLANG_C_EXTERN_C_END

#endif
