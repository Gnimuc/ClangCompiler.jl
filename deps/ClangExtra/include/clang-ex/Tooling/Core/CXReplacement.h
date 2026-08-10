#ifndef LLVM_CLANG_C_EXTRA_CXREPLACEMENT_H
#define LLVM_CLANG_C_EXTRA_CXREPLACEMENT_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Range
// A (offset, length) pair with no SourceManager behind it. It has no handle: every place it
// crosses here it does so as the two unsigneds it is made of.

// Replacement

/// Replacement(StringRef FilePath, unsigned Offset, unsigned Length, StringRef Text).
/// Caller-owned: pair with clang_Replacement_dispose.
CXReplacement clang_Replacement_create(const char *FilePath, unsigned Offset,
                                       unsigned Length, const char *ReplacementText);

/// Replacement() -- the invalid replacement, the one isApplicable() rejects.
/// Caller-owned.
CXReplacement clang_Replacement_createInvalid(void);

/// Replacement(const SourceManager &, SourceLocation Start, unsigned Length, StringRef).
/// PRECONDITION: Start must be a valid source location -- the constructor runs it through
/// SourceManager::getDecomposedLoc, which asserts otherwise. Caller-owned.
CXReplacement clang_Replacement_createFromSourceLocation(CXSourceManager SM,
                                                         CXSourceLocation_ Start,
                                                         unsigned Length,
                                                         const char *ReplacementText);

/// Replacement(const SourceManager &, const CharSourceRange &, StringRef,
///             const LangOptions &). A CharSourceRange crosses as its CXSourceRange_ plus a
/// separate token-range flag. LO may be NULL, which selects clang's own default argument
/// (a default-constructed LangOptions). PRECONDITION: both endpoints of Range must be valid.
/// Caller-owned.
CXReplacement clang_Replacement_createFromCharSourceRange(CXSourceManager SM,
                                                          CXSourceRange_ Range,
                                                          bool IsTokenRange,
                                                          const char *ReplacementText,
                                                          CXLangOptions LO);

void clang_Replacement_dispose(CXReplacement R);

bool clang_Replacement_isApplicable(CXReplacement R);

CXString clang_Replacement_getFilePath(CXReplacement R);

unsigned clang_Replacement_getOffset(CXReplacement R);

unsigned clang_Replacement_getLength(CXReplacement R);

CXString clang_Replacement_getReplacementText(CXReplacement R);

/// Applies the replacement to a Rewriter. Returns true on success -- the opposite of the
/// Rewriter's own Insert*/Replace* convention.
bool clang_Replacement_apply(CXReplacement R, CXRewriter Rewrite);

CXString clang_Replacement_toString(CXReplacement R);

// replacement_error
// ReplacementError
// The error class is not mirrored: llvm::Error never crosses this boundary, so the only
// thing a caller can see of it is the message clang_Replacements_add hands back.

// operator<
// operator==

// Replacements

/// Replacements() -- an empty, conflict-free set. Caller-owned: pair with
/// clang_Replacements_dispose.
CXReplacements clang_Replacements_create(void);

/// explicit Replacements(const Replacement &R). R is copied into the set. Caller-owned.
CXReplacements clang_Replacements_createFromReplacement(CXReplacement R);

void clang_Replacements_dispose(CXReplacements Rs);

/// Replacements::add. clang returns llvm::Error; the shim flattens it -- true when R was
/// inserted, false when it conflicts with an existing replacement or names a different
/// file. When OutError is non-NULL it receives the message (the empty string on success);
/// it is caller-owned either way (clang_disposeString).
bool clang_Replacements_add(CXReplacements Rs, CXReplacement R, CXString *OutError);

/// Replacements::merge -- Other refers to the code *after* Rs has been applied. Returns a
/// NEW set; caller-owned. Neither argument is modified.
CXReplacements clang_Replacements_merge(CXReplacements Rs, CXReplacements Other);

/// getAffectedRanges(), as a count plus a fill. Writes the first min(N, count) ranges into
/// the caller's two buffers -- Offsets[i]/Lengths[i] are the i-th range -- and returns the
/// total number of ranges. Call it once with N == 0 to size the buffers. Either buffer may
/// be NULL when N is 0.
unsigned clang_Replacements_getAffectedRanges(CXReplacements Rs, unsigned *Offsets,
                                              unsigned *Lengths, unsigned N);

unsigned clang_Replacements_getShiftedCodePosition(CXReplacements Rs, unsigned Position);

unsigned clang_Replacements_size(CXReplacements Rs);

void clang_Replacements_clear(CXReplacements Rs);

bool clang_Replacements_empty(CXReplacements Rs);

/// helper: the set exposes iterators rather than an index operator, so this walks begin()
/// forward I times. The returned Replacement is BORROWED from the set -- do not dispose it,
/// and do not keep it across an add()/clear()/merge().
/// PRECONDITION: I < clang_Replacements_size(Rs).
CXReplacement clang_Replacements_getReplacement(CXReplacements Rs, unsigned I);

// begin
// end
// rbegin
// rend
// operator==

/// applyAllReplacements(const Replacements &, Rewriter &). Applications are independent of
/// one another; returns true only when every one of them applied.
bool clang_tooling_applyAllReplacements(CXReplacements Rs, CXRewriter Rewrite);

/// applyAllReplacements(StringRef Code, const Replacements &) -- the SourceManager-free
/// form, which ignores the file path stored in each replacement. clang returns
/// llvm::Expected<std::string>; the shim flattens it: on success the CXString is the
/// rewritten code and *OutSuccess is true, on failure it is clang's error message and
/// *OutSuccess is false. Caller-owned either way. OutSuccess may be NULL.
CXString clang_tooling_applyAllReplacementsToCode(const char *Code, CXReplacements Rs,
                                                  bool *OutSuccess);

// TranslationUnitReplacements
// calculateRangesAfterReplacements
// groupReplacementsByFile

/// helper for formatAndApplyAllReplacements (clang/Tooling/Refactoring.h), which takes a
/// std::map<std::string, Replacements> the C boundary has no way to spell: this is the
/// single-file case, with the shim building the one-entry map from FilePath and Rs. Beyond
/// applying the replacements it runs clang-format over the changed ranges. Style is a
/// clang-format style name ("LLVM", "Google", "file", ...); NULL selects "file", clang's
/// own default argument. Returns true when everything applied and formatted.
/// PRECONDITION: Rs must be conflict-free, which is what building it through
/// clang_Replacements_add guarantees.
bool clang_tooling_formatAndApplyAllReplacements(const char *FilePath, CXReplacements Rs,
                                                 CXRewriter Rewrite, const char *Style);

LLVM_CLANG_C_EXTERN_C_END

#endif
