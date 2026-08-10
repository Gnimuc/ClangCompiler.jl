#ifndef LLVM_CLANG_C_EXTRA_CXCROSSTRANSLATIONUNIT_H
#define LLVM_CLANG_C_EXTRA_CXCROSSTRANSLATIONUNIT_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::cross_tu (clang/CrossTU/CrossTranslationUnit.h) -- pulling a definition out of
// another translation unit's on-disk AST file and merging it into the current ASTContext
// through the ASTImporter. It pairs with the already-wrapped clang_ASTUnit_Save (which
// produces those AST files) and clang_index_generateUSRForDecl (which produces the index
// keys below).
//
// ERROR HANDLING. Every lookup here returns an `llvm::Expected<T>` upstream. Nothing of
// that shape crosses the boundary: the shim consumes the error, logs it to llvm::errs()
// and returns NULL. A NULL return therefore means "no definition found, or the import
// failed", not "invalid argument".
//
// THE INDEX. The "USR<space>filepath" mapping the lookups consult is an
// `llvm::StringMap<std::string>`. CXCrossTUIndex is the shim's owned box for one; it is
// what parseCrossTUIndex produces and createCrossTUIndexString consumes, and it is also
// buildable from scratch so a caller can write an index file for AST dumps it just
// produced.

CXCrossTUIndex clang_CrossTUIndex_create(void);
void clang_CrossTUIndex_dispose(CXCrossTUIndex Idx);

// Insert or overwrite the file path recorded for USR.
void clang_CrossTUIndex_set(CXCrossTUIndex Idx, const char *USR, const char *FilePath);

// The path recorded for USR, or the EMPTY string when the index has no such key.
CXString clang_CrossTUIndex_lookup(CXCrossTUIndex Idx, const char *USR);

unsigned clang_CrossTUIndex_getNumEntries(CXCrossTUIndex Idx);

// PRECONDITION for both: I < clang_CrossTUIndex_getNumEntries. The order is the
// StringMap's bucket order -- unspecified, but stable between two calls that do not mutate
// the index, so USR I and file path I are always the same entry.
CXString clang_CrossTUIndex_getUSR(CXCrossTUIndex Idx, unsigned I);
CXString clang_CrossTUIndex_getFilePath(CXCrossTUIndex Idx, unsigned I);

// Read an index file: one "USR filepath" line per entry. Returns NULL and logs when the
// file is missing or malformed. The result is caller-owned -- free it with
// clang_CrossTUIndex_dispose.
CXCrossTUIndex clang_cross_tu_parseCrossTUIndex(const char *IndexPath);

// Render an index back to the file format above.
CXString clang_cross_tu_createCrossTUIndexString(CXCrossTUIndex Idx);

// Whether importing this variable's definition is worth it -- clang skips variables whose
// type has a non-trivial constructor, because running it would have side effects.
// PRECONDITION: VD and ACtx must be non-NULL.
bool clang_cross_tu_shouldImport(CXVarDecl VD, CXASTContext ACtx);

// The context itself. Owned by the caller; it holds the ASTUnits it loaded and the
// ASTImporters it built, so every borrowed pointer it hands out below dies with it.
// PRECONDITION: CI must have an ASTContext (the constructor stores `CI.getASTContext()`
// by reference).
CXCrossTranslationUnitContext clang_CrossTranslationUnitContext_create(CXCompilerInstance CI);
void clang_CrossTranslationUnitContext_dispose(CXCrossTranslationUnitContext CTU);

// getCrossTUDefinition, split in two because C has no overloading: upstream has one
// FunctionDecl form and one VarDecl form. Both look the decl's USR up in the index file
// `IndexName` inside directory `CrossTUDir`, load the AST file it names, and merge the
// definition into the current AST; the returned decl is the merged one, owned by the
// current ASTContext. NULL when there is no such definition or the import failed.
//
// PRECONDITION for both: the decl must be non-NULL and must have NO body (function) or NO
// initializer (variable) in the current translation unit -- the lookup opens with
// `assert(!hasBodyOrInit(D))`, since not having one is the whole reason to go looking.
CXFunctionDecl clang_CrossTranslationUnitContext_getCrossTUDefinitionForFunction(
    CXCrossTranslationUnitContext CTU, CXFunctionDecl FD, const char *CrossTUDir,
    const char *IndexName, bool DisplayCTUProgress);

CXVarDecl clang_CrossTranslationUnitContext_getCrossTUDefinitionForVar(
    CXCrossTranslationUnitContext CTU, CXVarDecl VD, const char *CrossTUDir,
    const char *IndexName, bool DisplayCTUProgress);

// Load (or return from cache) the AST file that defines LookupName. The unit is BORROWED:
// the context owns it, so it must not be disposed. NULL on failure, including when the
// context's own load threshold has been reached.
CXASTUnit clang_CrossTranslationUnitContext_loadExternalAST(
    CXCrossTranslationUnitContext CTU, const char *LookupName, const char *CrossTUDir,
    const char *IndexName, bool DisplayCTUProgress);

// importDefinition, split in two for the same reason. Merges a definition out of an
// ASTUnit the caller already has -- the second half of the lookups above, usable on its
// own when the AST file was located some other way.
//
// PRECONDITION for both, the mirror image of the lookups': the decl passed in is the
// FOREIGN one, so it must HAVE a body (function) or an initializer (variable) --
// `assert(hasBodyOrInit(D))`.
CXFunctionDecl clang_CrossTranslationUnitContext_importDefinitionForFunction(
    CXCrossTranslationUnitContext CTU, CXFunctionDecl FD, CXASTUnit Unit);

CXVarDecl clang_CrossTranslationUnitContext_importDefinitionForVar(
    CXCrossTranslationUnitContext CTU, CXVarDecl VD, CXASTUnit Unit);

// Static: the index key for a decl. The EMPTY string when the decl has no stable
// cross-TU name (upstream returns std::nullopt).
// PRECONDITION: ND must be non-NULL.
CXString clang_CrossTranslationUnitContext_getLookupName(CXNamedDecl ND);

// Whether the decl was newly created by an import, and whether an import left it marked
// with an unrecoverable error. Both are total over any non-NULL Decl.
bool clang_CrossTranslationUnitContext_isImportedAsNew(CXCrossTranslationUnitContext CTU,
                                                       CXDecl ToDecl);
bool clang_CrossTranslationUnitContext_hasError(CXCrossTranslationUnitContext CTU,
                                                CXDecl ToDecl);

// emitCrossTUDiagnostics -- takes a cross_tu::IndexError, the very object the wrappers
// above consume and log; there is no handle to hand one back in.
// getMacroExpansionContextForSourceLocation -- returns an optional
// MacroExpansionContext that clang 18 documents as unconditionally empty.
// parseInvocationList -- YAML in, `StringMap<SmallVector<std::string, 32>>` out; only
// on-demand source parsing consumes it, and that path needs the invocation list file
// anyway.

LLVM_CLANG_C_EXTERN_C_END

#endif
