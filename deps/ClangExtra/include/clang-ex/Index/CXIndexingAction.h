#ifndef LLVM_CLANG_C_EXTRA_CXINDEXINGACTION_H
#define LLVM_CLANG_C_EXTRA_CXINDEXINGACTION_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/Index/IndexingAction.h -- the drivers that walk a translation unit and report
// every symbol occurrence, plus the one consumer this library gives them.
//
// clang::index::IndexDataConsumer is an abstract class with five virtuals, and this
// library has no way to route a virtual call back into Julia. So the shim compiles in ONE
// concrete subclass, CXIndexDataCollector, which does the only thing that needs no
// callback: it appends every occurrence to a buffer, and the buffer is read afterwards by
// index. That is a batch interface rather than a streaming one, which is also what a
// caller building a symbol table wants.
//
// An occurrence is either a DECL occurrence or a MACRO occurrence; the two are
// distinguished by clang_IndexDataCollector_isMacroOccurrence, and each carries the fields
// the other leaves empty (a NULL decl, or an empty macro name). Module occurrences are not
// collected -- they carry a clang::Module the walk does not otherwise expose.
//
// Roles are the SymbolRoleSet bitset of clang-ex/Index/CXIndexSymbol.h, i.e. an or of
// CXSymbolRole_ values, and clang_index_printSymbolRoles renders one.

// clang/Index/IndexingOptions.h: enum class
// clang::index::IndexingOptions::SystemSymbolFilterKind
typedef enum CXSystemSymbolFilterKind {
  CXSystemSymbolFilterKind_None,
  CXSystemSymbolFilterKind_DeclarationsOnly,
  CXSystemSymbolFilterKind_All,
} CXSystemSymbolFilterKind;

// Caller-owned; free with clang_IndexDataCollector_dispose. Not adopted by either driver
// below -- both take the consumer by reference and neither keeps it.
CXIndexDataCollector clang_IndexDataCollector_create(void);
void clang_IndexDataCollector_dispose(CXIndexDataCollector C);

// Drop every occurrence collected so far, so one collector can be reused across runs. A
// collector is otherwise cumulative: two driver calls append to the same buffer.
void clang_IndexDataCollector_clear(CXIndexDataCollector C);

unsigned clang_IndexDataCollector_getNumOccurrences(CXIndexDataCollector C);

// PRECONDITION for all five: I < clang_IndexDataCollector_getNumOccurrences.
bool clang_IndexDataCollector_isMacroOccurrence(CXIndexDataCollector C, unsigned I);

// The declaration the occurrence refers to, borrowed from the AST that was walked and
// valid as long as that AST is. NULL for a macro occurrence.
CXDecl clang_IndexDataCollector_getOccurrenceDecl(CXIndexDataCollector C, unsigned I);

// The macro's spelling. The EMPTY string for a decl occurrence, and also for a macro
// occurrence clang reported with no identifier.
CXString clang_IndexDataCollector_getOccurrenceMacroName(CXIndexDataCollector C,
                                                         unsigned I);

unsigned clang_IndexDataCollector_getOccurrenceRoles(CXIndexDataCollector C, unsigned I);

// Where the occurrence was written. May be an INVALID location (the encoding is then
// NULL) for an implicit occurrence, which is why this one has no precondition of its own
// beyond the index bound.
CXSourceLocation_ clang_IndexDataCollector_getOccurrenceLocation(CXIndexDataCollector C,
                                                                 unsigned I);

// The two drivers. `clang::index::IndexingOptions` is a plain struct of scalars plus a
// `std::function` filter this boundary cannot carry, so the scalars are spelled out as
// parameters and the shim assembles the struct; the filter is left unset, i.e. nothing is
// skipped. The defaults upstream gives the struct are DeclarationsOnly / false / false /
// true / false / false / false, in the order below.

// Walk every decl of an already-parsed ASTUnit.
void clang_index_indexASTUnit(CXASTUnit Unit, CXIndexDataCollector C,
                              CXSystemSymbolFilterKind SystemSymbolFilter,
                              bool IndexFunctionLocals, bool IndexImplicitInstantiation,
                              bool IndexMacros, bool IndexMacrosInPreprocessor,
                              bool IndexParametersInDeclarations,
                              bool IndexTemplateParameters);

// Walk the given decls (and, recursively, everything under them) in an ASTContext the
// caller already has -- the interpreter-shaped flow, where there is no ASTUnit. `Decls` is
// an array of NumDecls decl handles; passing NumDecls == 0 walks nothing.
void clang_index_indexTopLevelDecls(CXASTContext Ctx, CXPreprocessor PP, CXDecl *Decls,
                                    unsigned NumDecls, CXIndexDataCollector C,
                                    CXSystemSymbolFilterKind SystemSymbolFilter,
                                    bool IndexFunctionLocals,
                                    bool IndexImplicitInstantiation, bool IndexMacros,
                                    bool IndexMacrosInPreprocessor,
                                    bool IndexParametersInDeclarations,
                                    bool IndexTemplateParameters);

// createIndexingASTConsumer / createIndexingAction -- both take the consumer as a
// `std::shared_ptr<IndexDataConsumer>`, i.e. they take ownership of a collector whose
// buffer the caller still has to read afterwards; the two drivers above cover the same
// ground without that split lifetime.
// indexMacrosCallback -- returns a PPCallbacks the caller must hand to a Preprocessor,
// which has no handle here.
// indexModuleFile -- takes a serialization::ModuleFile, which has no handle here.

LLVM_CLANG_C_EXTERN_C_END

#endif
