#ifndef LLVM_CLANG_C_EXTRA_CXASTREADER_H
#define LLVM_CLANG_C_EXTRA_CXASTREADER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::ASTReader (clang/Serialization/ASTReader.h) -- the two STATIC utilities, which
// inspect a PCH/AST file without loading it into a translation unit. Static members keep
// the class segment and take no receiver.
//
// Both take a `const PCHContainerReader &` that the shim supplies itself: the only reader
// this package produces is clang::RawPCHContainerReader, it is stateless, and one static
// instance serves every call (the same pattern as lib/Frontend/CXASTUnit.cpp). Keeping it
// out of the C surface is also what makes these signatures survive clang's later
// InMemoryModuleCache -> ModuleCache change, since isAcceptableASTFile's module cache is
// likewise constructed inside and consulted only for the duration of the call.

// The source file the AST file was built from, read straight out of the file's control
// block. Returns the EMPTY string when the file cannot be read or is not an AST file; the
// reason is reported through Diags.
CXString clang_ASTReader_getOriginalSourceFile(const char *ASTFileName,
                                               CXFileManager FileMgr,
                                               CXDiagnosticsEngine Diags);

// Whether the AST file at Filename can be loaded into a translation unit compiled with the
// given options -- the pre-flight check clang's driver runs before attaching an implicit
// PCH, turning a diagnostic-spewing load failure into a clean rebuild decision. No
// diagnostics are emitted: the answer is the bool.
//
// ExistingModuleCachePath is the module cache a loaded module file must have come from;
// pass "" when there is none (upstream's own default). RequireStrictOptionMatches turns
// benign option differences into rejections; upstream defaults it to false.
bool clang_ASTReader_isAcceptableASTFile(const char *Filename, CXFileManager FileMgr,
                                         CXLangOptions LangOpts,
                                         CXTargetOptions TargetOpts,
                                         CXPreprocessorOptions PPOpts,
                                         const char *ExistingModuleCachePath,
                                         bool RequireStrictOptionMatches);

// readASTFileControlBlock -- takes an `ASTReaderListener &`, an abstract class with a
// dozen virtuals; reaching it needs the callback trampoline this library does not have.

LLVM_CLANG_C_EXTERN_C_END

#endif
