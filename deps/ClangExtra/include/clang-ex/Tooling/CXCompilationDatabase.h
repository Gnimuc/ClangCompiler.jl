#ifndef LLVM_CLANG_C_EXTRA_CXCOMPILATIONDATABASE_H
#define LLVM_CLANG_C_EXTRA_CXCOMPILATIONDATABASE_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-c/CXString.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// CompileCommand
//
// clang::tooling::CompileCommand is a plain value struct of five fields, so it crosses as a
// pointer to one. Where the pointer came from decides who frees it:
//
//   * clang_CompileCommandList_getCommand hands back a BORROWED command that points into the
//     list and dies with it. Never dispose one of those.
//   * clang_CompileCommand_create and clang_tooling_transferCompileCommand heap-box a fresh
//     command that the caller owns and releases with clang_CompileCommand_dispose.
//
// The four string accessors return the field's own storage, borrowed: valid until the command
// (or the list holding it) goes away, and never null -- an unset field reads as "".

// Heuristic is not a constructor parameter in clang and starts empty; only the interpolating
// database ever sets it. Caller-owned: pair with clang_CompileCommand_dispose.
CXCompileCommand clang_CompileCommand_create(const char *Directory, const char *Filename,
                                             const char **CommandLine, unsigned N,
                                             const char *Output);

void clang_CompileCommand_dispose(CXCompileCommand CC);

const char *clang_CompileCommand_getDirectory(CXCompileCommand CC);

const char *clang_CompileCommand_getFilename(CXCompileCommand CC);

const char *clang_CompileCommand_getOutput(CXCompileCommand CC);

// The short human-readable explanation an inferred command carries ("inferred from foo/bar.h"),
// empty for a command that came from an authoritative source.
const char *clang_CompileCommand_getHeuristic(CXCompileCommand CC);

unsigned clang_CompileCommand_getNumCommandLineArgs(CXCompileCommand CC);

// PRECONDITION: Index < clang_CompileCommand_getNumCommandLineArgs(CC).
const char *clang_CompileCommand_getCommandLineArg(CXCompileCommand CC, unsigned Index);

// CompileCommand::operator==, which compares all five fields.
bool clang_CompileCommand_equals(CXCompileCommand LHS, CXCompileCommand RHS);

// operator!=

// CompileCommandList
//
// The shim-owned std::vector clang's two query methods return by value. Caller-owned: release
// with clang_CompileCommandList_dispose, which also invalidates every command borrowed from it.

unsigned clang_CompileCommandList_getNumCommands(CXCompileCommandList L);

// Borrowed: the command lives in L.
// PRECONDITION: Index < clang_CompileCommandList_getNumCommands(L).
CXCompileCommand clang_CompileCommandList_getCommand(CXCompileCommandList L, unsigned Index);

void clang_CompileCommandList_dispose(CXCompileCommandList L);

// CompilationDatabase
//
// The three loaders are static and each returns null when no database could be built; the
// reason goes to *ErrorMessage, a caller-owned CXString, when that pointer is non-null.
// A database that did load is caller-owned: release it with clang_CompilationDatabase_dispose,
// which runs the virtual destructor and so is also the right release for the Fixed and JSON
// subclasses.

CXCompilationDatabase clang_CompilationDatabase_loadFromDirectory(const char *BuildDirectory,
                                                                  CXString *ErrorMessage);

// Walks every parent path of SourceFile looking for a database.
CXCompilationDatabase clang_CompilationDatabase_autoDetectFromSource(const char *SourceFile,
                                                                     CXString *ErrorMessage);

// Walks SourceDir and every parent path of it looking for a database.
CXCompilationDatabase clang_CompilationDatabase_autoDetectFromDirectory(const char *SourceDir,
                                                                        CXString *ErrorMessage);

void clang_CompilationDatabase_dispose(CXCompilationDatabase DB);

// Every command in which FilePath was compiled, possibly none. Caller-owned list.
CXCompileCommandList
clang_CompilationDatabase_getCompileCommands(CXCompilationDatabase DB, const char *FilePath);

// Every command in the database. Not all implementations can enumerate: the base class
// builds this out of getAllFiles(), which defaults to {}, so a FixedCompilationDatabase
// reports an empty list here however many commands it can answer for.
CXCompileCommandList clang_CompilationDatabase_getAllCompileCommands(CXCompilationDatabase DB);

// The files the database can enumerate, caller-owned (clang_disposeStringSet). Empty for a
// non-enumerable database -- the base class's getAllFiles returns {}.
CXStringSet *clang_CompilationDatabase_getAllFiles(CXCompilationDatabase DB);

// FixedCompilationDatabase
//
// A database that answers every query with one command line. Not enumerable: getAllFiles is
// the base class's {}. Release it with clang_CompilationDatabase_dispose.

// The public constructor: Directory is the command's working directory and CommandLine the
// flags after argv[0], which the database supplies as "clang-tool" itself.
CXFixedCompilationDatabase clang_FixedCompilationDatabase_create(const char *Directory,
                                                                 const char **CommandLine,
                                                                 unsigned N);

// Parses Argv for "--" and takes the flags after it. Returns null when there is no "--", and
// writes the number of arguments *before* it back through Argc.
// PRECONDITION: Argv points at *Argc entries.
CXFixedCompilationDatabase
clang_FixedCompilationDatabase_loadFromCommandLine(int *Argc, const char **Argv,
                                                   CXString *ErrorMsg, const char *Directory);

// Reads flags from a compile_flags.txt-style file, one per line.
CXFixedCompilationDatabase clang_FixedCompilationDatabase_loadFromFile(const char *Path,
                                                                       CXString *ErrorMsg);

// Reads flags from Data, one per line. Directory is the working directory the commands run
// in, typically the parent of the compile_flags.txt the buffer came from.
CXFixedCompilationDatabase clang_FixedCompilationDatabase_loadFromBuffer(const char *Directory,
                                                                        const char *Data,
                                                                        CXString *ErrorMsg);

// Free functions of namespace clang::tooling
//
// ADOPTION: the three wrapping functions below CONSUME the database handed to them -- the
// unique_ptr moves into the wrapper -- so the argument handle must never be disposed again.
// Dispose the returned wrapper instead; its destructor takes the inner database with it.
// All three return null when the argument was null.

// Defers to Base but infers a command for files it does not know, which is what gets a header
// that never appears in compile_commands.json a usable command line. getAllFiles and
// getAllCompileCommands still report Base's own contents.
CXCompilationDatabase clang_tooling_inferMissingCompileCommands(CXCompilationDatabase Base);

// Defers to Base and adds -target/--driver-mode flags deduced from argv[0] of the command
// line Base returned.
CXCompilationDatabase clang_tooling_inferTargetAndDriverMode(CXCompilationDatabase Base);

// Defers to Base and expands @response-files in the command lines it returns, reading them
// through the real file system.
CXCompilationDatabase clang_tooling_expandResponseFiles(CXCompilationDatabase Base);

// Re-points a command at a different file: most arguments survive, -x/-std and friends are
// tweaked, and the result always ends in {"--", Filename}. Caller-owned: pair with
// clang_CompileCommand_dispose. CC is only read.
CXCompileCommand clang_tooling_transferCompileCommand(CXCompileCommand CC,
                                                      const char *Filename);

LLVM_CLANG_C_EXTERN_C_END

#endif
