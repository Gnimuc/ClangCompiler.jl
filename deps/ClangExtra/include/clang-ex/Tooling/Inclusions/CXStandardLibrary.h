#ifndef LLVM_CLANG_C_EXTRA_CXSTANDARDLIBRARY_H
#define LLVM_CLANG_C_EXTRA_CXSTANDARDLIBRARY_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Everything below lives in clang::tooling::stdlib, and the namespace is part of the C
// name: the bare class names `Symbol` and `Header` say nothing on their own.
//
// Mirror of `clang::tooling::stdlib::Lang` (clang/Tooling/Inclusions/StandardLibrary.h).
// C and C++ are separate tables: <cstdio> and <stdio.h>, std::printf and ::printf, are
// different entries. The trailing LastValue is an alias of CXX and is not mirrored.
typedef enum CXStdlibLang {
  CXStdlibLang_C = 0,
  CXStdlibLang_CXX
} CXStdlibLang;

// stdlib::Header

/// Header::all -- every header in the table for L. Caller-owned: dispose the list with
/// clang_stdlib_HeaderList_dispose.
CXStdlibHeaderList clang_stdlib_Header_all(CXStdlibLang L);

/// Header::named -- Name carries its angle brackets, e.g. "<vector>". Returns NULL when the
/// table has no such header. Caller-owned copy: pair with clang_stdlib_Header_dispose.
CXStdlibHeader clang_stdlib_Header_named(const char *Name, CXStdlibLang Language);

CXString clang_stdlib_Header_name(CXStdlibHeader H);

void clang_stdlib_Header_dispose(CXStdlibHeader H);

/// A shim-owned std::vector<stdlib::Header>: clang hands `all()` and `headers()` back by
/// value, so there is no clang-owned array to borrow a view of.
unsigned clang_stdlib_HeaderList_getNumHeaders(CXStdlibHeaderList HL);

/// BORROWED from the list -- valid until the list is disposed, and not to be disposed
/// itself. Returns NULL when I is out of range.
CXStdlibHeader clang_stdlib_HeaderList_getHeader(CXStdlibHeaderList HL, unsigned I);

void clang_stdlib_HeaderList_dispose(CXStdlibHeaderList HL);

// stdlib::Symbol

/// Symbol::all -- every top-level symbol in the table for L. Caller-owned list.
CXStdlibSymbolList clang_stdlib_Symbol_all(CXStdlibLang L);

/// Symbol::named -- Scope carries its trailing "::", e.g. named("std::chrono::",
/// "system_clock"); the global scope is the empty string. Returns NULL when the table has
/// no such symbol. Caller-owned copy: pair with clang_stdlib_Symbol_dispose.
CXStdlibSymbol clang_stdlib_Symbol_named(const char *Scope, const char *Name,
                                         CXStdlibLang Language);

CXString clang_stdlib_Symbol_scope(CXStdlibSymbol S);

CXString clang_stdlib_Symbol_name(CXStdlibSymbol S);

CXString clang_stdlib_Symbol_qualifiedName(CXStdlibSymbol S);

/// Symbol::header -- the one header to suggest inserting for this symbol, or NULL when the
/// table records none. Caller-owned copy.
CXStdlibHeader clang_stdlib_Symbol_header(CXStdlibSymbol S);

/// Symbol::headers -- every header that provides this symbol. Caller-owned list.
CXStdlibHeaderList clang_stdlib_Symbol_headers(CXStdlibSymbol S);

void clang_stdlib_Symbol_dispose(CXStdlibSymbol S);

unsigned clang_stdlib_SymbolList_getNumSymbols(CXStdlibSymbolList SL);

/// BORROWED from the list, exactly as for headers. Returns NULL when I is out of range.
CXStdlibSymbol clang_stdlib_SymbolList_getSymbol(CXStdlibSymbolList SL, unsigned I);

void clang_stdlib_SymbolList_dispose(CXStdlibSymbolList SL);

// stdlib::Recognizer

/// Caller-owned: pair with clang_stdlib_Recognizer_dispose. The recognizer memoises what it
/// learns per DeclContext, so one per ASTContext, and it must not outlive that context --
/// its cache is keyed on raw DeclContext pointers.
CXStdlibRecognizer clang_stdlib_Recognizer_create(void);

/// Recognizer::operator()(const Decl *) under a name C can spell: the top-level standard
/// library symbol D belongs to (std::vector<int>::iterator answers std::vector), or NULL
/// when D is not one. Caller-owned copy of the symbol.
CXStdlibSymbol clang_stdlib_Recognizer_recognize(CXStdlibRecognizer R, CXDecl D);

void clang_stdlib_Recognizer_dispose(CXStdlibRecognizer R);

LLVM_CLANG_C_EXTERN_C_END

#endif
