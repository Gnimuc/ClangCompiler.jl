#ifndef LLVM_CLANG_C_EXTRA_CXPRECOMPILEDPREAMBLE_H
#define LLVM_CLANG_C_EXTRA_CXPRECOMPILEDPREAMBLE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-c/CXString.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/Lex/Lexer.h: struct clang::PreambleBounds, a pure aggregate of two fields, so it
// crosses by value the way CXSourceRange_ does rather than as a handle.
typedef struct CXPreambleBounds_ {
  // Size of the preamble in bytes.
  unsigned Size;
  // Whether the preamble ends at the start of a new line.
  bool PreambleEndsAtStartOfLine;
} CXPreambleBounds_;

// Lexes `Buffer` far enough to find where its leading #include block ends. `MaxLines` caps
// how far the lexer will look; 0 means no cap. Pure computation over the bytes given — no
// file is opened and nothing is cached.
CXPreambleBounds_ clang_ComputePreambleBounds(CXLangOptions LangOpts, const char *Buffer,
                                              size_t Length, unsigned MaxLines);

// clang::PrecompiledPreamble builds a PCH for the leading #include block of a buffer and
// keeps enough information to say whether that PCH is still valid for new contents of the
// same file. It is move-only, so the handle boxes the moved-from-ErrorOr value on the heap.
//
// The box also owns two things the class expects the caller to keep alive:
//
//   * the virtual file system. Every entry point here uses llvm::vfs::getRealFileSystem().
//     That is deliberate: with an on-disk PCH (this shim always passes StoreInMemory=false)
//     clang::PrecompiledPreamble::setupPreambleStorage leaves a real-filesystem VFS
//     untouched, so no overlay escapes and the caller's ordinary FileManager keeps working.
//     A shim that stored the PCH in memory would have to hand the rewritten overlay back,
//     and there is no VFS handle in this library to hand it back through.
//
//   * the main-file buffer. AddImplicitPreamble and OverridePreamble remap the main file to
//     the buffer they are given and clang reads it during the later parse, so the bytes
//     must outlive the compiler run. Each call copies the contents it was passed into the
//     box, replacing whatever the previous call left there. The box must therefore outlive
//     both the compiler run and the AST built from it.
//
// The preamble is caller-owned; release it with clang_PrecompiledPreamble_dispose.

// Builds the preamble PCH for `Bounds` of the given main-file contents, writing it to a
// temporary file under `StoragePath` (the system temporary directory when that is NULL or
// empty). `MainFileName` is the buffer's identifier and must be the file the invocation
// names as its input, since that is the name the remapping is keyed on.
//
// Returns NULL on failure, having logged the reason to stderr: the llvm::ErrorOr the C++
// API returns does not cross this boundary.
CXPrecompiledPreamble clang_PrecompiledPreamble_Build(CXCompilerInvocation Invocation,
                                                      const char *MainFileContents,
                                                      size_t Length,
                                                      const char *MainFileName,
                                                      CXPreambleBounds_ Bounds,
                                                      CXDiagnosticsEngine Diagnostics,
                                                      const char *StoragePath);

void clang_PrecompiledPreamble_dispose(CXPrecompiledPreamble P);

// The bounds the preamble was built for.
CXPreambleBounds_ clang_PrecompiledPreamble_getBounds(CXPrecompiledPreamble P);

// Bytes the PCH takes on disk. Documented by clang as logging/debugging only: it reports 0
// when the filesystem query fails rather than distinguishing that from an empty preamble.
size_t clang_PrecompiledPreamble_getSize(CXPrecompiledPreamble P);

// The prefix of the main file the preamble was built from — the first getBounds().Size
// bytes of it. Caller frees the string with clang_disposeString.
CXString clang_PrecompiledPreamble_getContents(CXPrecompiledPreamble P);

// Whether this preamble can be reused for new contents of the main file: the preamble bytes
// must still match and no file it read may have changed. This is the query the whole class
// exists for — a true answer is what lets a reparse skip the headers.
bool clang_PrecompiledPreamble_CanReuse(CXPrecompiledPreamble P,
                                        CXCompilerInvocation Invocation,
                                        const char *MainFileContents, size_t Length,
                                        const char *MainFileName,
                                        CXPreambleBounds_ Bounds);

// Rewires `CI` to consume this preamble as an implicit PCH and remaps its main file to a
// copy of the contents given, which the box keeps alive (see the note above).
// PRECONDITION: clang_PrecompiledPreamble_CanReuse must hold for the same invocation,
// contents and bounds. clang does not check it and parses against a stale PCH if it does
// not.
void clang_PrecompiledPreamble_AddImplicitPreamble(CXPrecompiledPreamble P,
                                                   CXCompilerInvocation CI,
                                                   const char *MainFileContents,
                                                   size_t Length,
                                                   const char *MainFileName);

// The same rewiring without the reuse precondition: use it when the preamble is known not
// to match and a possibly-different parse is acceptable.
void clang_PrecompiledPreamble_OverridePreamble(CXPrecompiledPreamble P,
                                                CXCompilerInvocation CI,
                                                const char *MainFileContents, size_t Length,
                                                const char *MainFileName);

LLVM_CLANG_C_EXTERN_C_END

#endif
