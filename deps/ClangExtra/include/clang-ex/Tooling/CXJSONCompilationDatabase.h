#ifndef LLVM_CLANG_C_EXTRA_CXJSONCOMPILATIONDATABASE_H
#define LLVM_CLANG_C_EXTRA_CXJSONCOMPILATIONDATABASE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-c/CXString.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/Tooling/JSONCompilationDatabase.h: enum class clang::tooling::JSONCommandLineSyntax
//
// How the 'command' string of an entry is split into arguments. AutoDetect picks Windows or
// Gnu from the shape of the first entry's filename, which is what a compile_commands.json
// written by CMake expects.
typedef enum CXJSONCommandLineSyntax {
  CXJSONCommandLineSyntax_Windows,
  CXJSONCommandLineSyntax_Gnu,
  CXJSONCommandLineSyntax_AutoDetect,
} CXJSONCommandLineSyntax;

// JSONCompilationDatabase
//
// Both loaders are static and return null when the database could not be parsed, with the
// reason in *ErrorMessage (a caller-owned CXString) when that pointer is non-null. A database
// that did load is caller-owned and released with clang_CompilationDatabase_dispose -- the
// base class destructor is virtual, and this class adds no release of its own.
//
// Unlike the base class, this one enumerates: getAllFiles and getAllCompileCommands are
// overridden here, so reaching them through the CXCompilationDatabase handle answers with the
// JSON file's real contents.

CXJSONCompilationDatabase
clang_JSONCompilationDatabase_loadFromFile(const char *FilePath, CXString *ErrorMessage,
                                           CXJSONCommandLineSyntax Syntax);

// Parses DatabaseString itself, so a database can be built without touching disk.
CXJSONCompilationDatabase
clang_JSONCompilationDatabase_loadFromBuffer(const char *DatabaseString,
                                             CXString *ErrorMessage,
                                             CXJSONCommandLineSyntax Syntax);

// getCompileCommands
// getAllFiles
// getAllCompileCommands

LLVM_CLANG_C_EXTERN_C_END

#endif
