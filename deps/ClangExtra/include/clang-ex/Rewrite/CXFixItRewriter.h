#ifndef LLVM_CLANG_C_EXTRA_CXFIXITREWRITER_H
#define LLVM_CLANG_C_EXTRA_CXFIXITREWRITER_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// FixItRewriter
//
// A DiagnosticConsumer that applies the fix-it hints clang attaches to its own
// diagnostics ("did you mean ...", a missing semicolon, a wrong member name) to the source
// they came from, and hands the repaired text back.
//
// `clang::FixItOptions::RewriteFilename` is a PURE VIRTUAL, so a FixItRewriter cannot be
// built without a subclass. libclangex compiles exactly ONE: its behaviour switches are
// the plain public bools FixItOptions already declares, set once at create time, and
// its RewriteFilename appends ".fixit" to the name it is given (leaving the file
// descriptor out-parameter at -1). No Julia-side virtual overriding is involved, and
// nothing about the subclass crosses this boundary -- the handle below designates a
// shim-side box holding the rewriter and its options in one allocation, because
// FixItRewriter stores the options as a raw pointer it does not own.

/// Create a fix-it rewriter over DE/SM/LO. Caller-owned: pair with
/// clang_FixItRewriter_dispose.
///
/// OWNERSHIP DANCE -- clang::FixItRewriter's constructor and destructor perform it
/// themselves, and this is what the caller has to respect:
///   * creating one calls `DE.takeClient()` (adopting whatever consumer DE owned) and then
///     `DE.setClient(rewriter, /*ShouldOwnClient=*/false)`, so from this call on DE routes
///     every diagnostic through the rewriter, while the rewriter forwards to the previous
///     client;
///   * disposing it calls `DE.setClient(previous, ...)`, restoring both the client and its
///     ownership flag.
/// So: do not call clang_DiagnosticsEngine_setClient/takeClient between the two, and
/// always dispose the rewriter BEFORE the DiagnosticsEngine, the SourceManager and the
/// LangOptions it was built from -- it holds raw references to all four.
///
/// InPlace         -- rewrite the original files rather than the ".fixit" siblings.
/// FixWhatYouCan   -- keep the fixes already applied even when some diagnostic in the file
///                    could not be fixed.
/// FixOnlyWarnings -- apply the hints attached to warnings and skip those on errors.
/// Silent          -- forward a diagnostic to the previous client only when it is an error
///                    or carried a fix-it that was applied.
CXFixItRewriter clang_FixItRewriter_create(CXDiagnosticsEngine DE, CXSourceManager SM,
                                           CXLangOptions LO, bool InPlace,
                                           bool FixWhatYouCan, bool FixOnlyWarnings,
                                           bool Silent);

void clang_FixItRewriter_dispose(CXFixItRewriter R);

/// SEQUENCING, which the four accessors below all depend on: as diagnostics arrive, the
/// fix-its are batched into a private clang::edit::EditedSource, NOT into the rewriter's
/// buffers. It is WriteFixedFiles that replays that batch into them. Until it has run,
/// IsModified is false for every file, getNumBuffers is 0 and WriteFixedFile yields the
/// empty string.
///
/// Write every fixed file to DISK -- over the original when InPlace, otherwise to the
/// `<path>.fixit` sibling the shim's FixItOptions names -- and return true if any of them
/// could not be written (or if fixes failed and FixWhatYouCan is off, in which case
/// nothing is written at all).
///
/// PRECONDITION: every changed FileID must be backed by a real file. The output path is
/// derived from the FileID's FileEntry, and a FileID created from a memory buffer -- which
/// is what the incremental Interpreter parses from -- has none.
///
/// Upstream's optional out-parameter listing the (original, rewritten) name pairs is not
/// exposed; enumerate the buffers instead.
bool clang_FixItRewriter_WriteFixedFiles(CXFixItRewriter R);

/// Whether any fix-it landed in the file ID names. See the sequencing note above.
bool clang_FixItRewriter_IsModified(CXFixItRewriter R, CXFileID ID);

/// helper -- std::distance(buffer_begin(), buffer_end()). The number of files fixed.
unsigned clang_FixItRewriter_getNumBuffers(CXFixItRewriter R);

/// helper -- the FileID of the Idx'th fixed file, walking buffer_begin()..buffer_end().
/// PRECONDITION: Idx < clang_FixItRewriter_getNumBuffers(R).
/// This allocates a FileID box; release it with clang_FileID_dispose.
CXFileID clang_FixItRewriter_getBufferFileID(CXFixItRewriter R, unsigned Idx);

/// The fixed text of ID, in memory -- WriteFixedFile(ID, raw_ostream) into a string.
/// Upstream signals its one failure mode, "ID has no rewrite buffer", with a `true`
/// return; here that is the EMPTY string, which clang_FixItRewriter_IsModified tells apart
/// from a file that really did rewrite to nothing.
CXString clang_FixItRewriter_WriteFixedFile(CXFixItRewriter R, CXFileID ID);

bool clang_FixItRewriter_IncludeInDiagnosticCounts(CXFixItRewriter R);

/// Emit a diagnostic through the client this rewriter displaced.
void clang_FixItRewriter_Diag(CXFixItRewriter R, CXSourceLocation_ Loc, unsigned DiagID);

// HandleDiagnostic -- the DiagnosticConsumer override; the DiagnosticsEngine calls it, a
// caller of this API does not.

LLVM_CLANG_C_EXTERN_C_END

#endif
