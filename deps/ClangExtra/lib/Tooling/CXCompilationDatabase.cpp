#include "clang-ex/Tooling/CXCompilationDatabase.h"

#include "utils.h"

#include "clang/Tooling/CompilationDatabase.h"
#include "llvm/ADT/ArrayRef.h"
#include "llvm/ADT/StringRef.h"
#include "llvm/ADT/Twine.h"
#include "llvm/Support/VirtualFileSystem.h"

#include <memory>
#include <string>
#include <vector>

namespace {

using CompileCommandVec = std::vector<clang::tooling::CompileCommand>;

CompileCommandVec *unwrapList(CXCompileCommandList L) {
  return reinterpret_cast<CompileCommandVec *>(L);
}

clang::tooling::CompileCommand *unwrapCommand(CXCompileCommand CC) {
  return reinterpret_cast<clang::tooling::CompileCommand *>(CC);
}

clang::tooling::CompilationDatabase *unwrapDB(CXCompilationDatabase DB) {
  return reinterpret_cast<clang::tooling::CompilationDatabase *>(DB);
}

std::vector<std::string> toStrings(const char **Strs, unsigned N) {
  std::vector<std::string> Out;
  Out.reserve(N);
  for (unsigned I = 0; I < N; ++I)
    Out.emplace_back(Strs && Strs[I] ? Strs[I] : "");
  return Out;
}

// Every loader publishes its message unconditionally when the caller asked for one, so a
// success leaves an empty CXString rather than whatever the cell held before the call.
void publishError(CXString *Out, const std::string &Msg) {
  if (Out)
    *Out = extra::makeCXString(Msg);
}

CXCompileCommandList boxCommands(CompileCommandVec Commands) {
  return reinterpret_cast<CXCompileCommandList>(
      std::make_unique<CompileCommandVec>(std::move(Commands)).release());
}

} // namespace

// CompileCommand

CXCompileCommand clang_CompileCommand_create(const char *Directory, const char *Filename,
                                             const char **CommandLine, unsigned N,
                                             const char *Output) {
  auto CC = std::make_unique<clang::tooling::CompileCommand>();
  CC->Directory = Directory ? Directory : "";
  CC->Filename = Filename ? Filename : "";
  CC->CommandLine = toStrings(CommandLine, N);
  CC->Output = Output ? Output : "";
  return reinterpret_cast<CXCompileCommand>(CC.release());
}

void clang_CompileCommand_dispose(CXCompileCommand CC) { delete unwrapCommand(CC); }

const char *clang_CompileCommand_getDirectory(CXCompileCommand CC) {
  return unwrapCommand(CC)->Directory.c_str();
}

const char *clang_CompileCommand_getFilename(CXCompileCommand CC) {
  return unwrapCommand(CC)->Filename.c_str();
}

const char *clang_CompileCommand_getOutput(CXCompileCommand CC) {
  return unwrapCommand(CC)->Output.c_str();
}

const char *clang_CompileCommand_getHeuristic(CXCompileCommand CC) {
  return unwrapCommand(CC)->Heuristic.c_str();
}

unsigned clang_CompileCommand_getNumCommandLineArgs(CXCompileCommand CC) {
  return static_cast<unsigned>(unwrapCommand(CC)->CommandLine.size());
}

const char *clang_CompileCommand_getCommandLineArg(CXCompileCommand CC, unsigned Index) {
  return unwrapCommand(CC)->CommandLine[Index].c_str();
}

bool clang_CompileCommand_equals(CXCompileCommand LHS, CXCompileCommand RHS) {
  return *unwrapCommand(LHS) == *unwrapCommand(RHS);
}

// CompileCommandList

unsigned clang_CompileCommandList_getNumCommands(CXCompileCommandList L) {
  return static_cast<unsigned>(unwrapList(L)->size());
}

CXCompileCommand clang_CompileCommandList_getCommand(CXCompileCommandList L, unsigned Index) {
  return reinterpret_cast<CXCompileCommand>(&(*unwrapList(L))[Index]);
}

void clang_CompileCommandList_dispose(CXCompileCommandList L) { delete unwrapList(L); }

// CompilationDatabase

CXCompilationDatabase clang_CompilationDatabase_loadFromDirectory(const char *BuildDirectory,
                                                                  CXString *ErrorMessage) {
  std::string Err;
  auto DB = clang::tooling::CompilationDatabase::loadFromDirectory(
      BuildDirectory ? BuildDirectory : "", Err);
  publishError(ErrorMessage, Err);
  return reinterpret_cast<CXCompilationDatabase>(DB.release());
}

CXCompilationDatabase clang_CompilationDatabase_autoDetectFromSource(const char *SourceFile,
                                                                     CXString *ErrorMessage) {
  std::string Err;
  auto DB = clang::tooling::CompilationDatabase::autoDetectFromSource(
      SourceFile ? SourceFile : "", Err);
  publishError(ErrorMessage, Err);
  return reinterpret_cast<CXCompilationDatabase>(DB.release());
}

CXCompilationDatabase clang_CompilationDatabase_autoDetectFromDirectory(const char *SourceDir,
                                                                        CXString *ErrorMessage) {
  std::string Err;
  auto DB = clang::tooling::CompilationDatabase::autoDetectFromDirectory(
      SourceDir ? SourceDir : "", Err);
  publishError(ErrorMessage, Err);
  return reinterpret_cast<CXCompilationDatabase>(DB.release());
}

void clang_CompilationDatabase_dispose(CXCompilationDatabase DB) { delete unwrapDB(DB); }

CXCompileCommandList
clang_CompilationDatabase_getCompileCommands(CXCompilationDatabase DB, const char *FilePath) {
  return boxCommands(unwrapDB(DB)->getCompileCommands(FilePath ? FilePath : ""));
}

CXCompileCommandList clang_CompilationDatabase_getAllCompileCommands(CXCompilationDatabase DB) {
  return boxCommands(unwrapDB(DB)->getAllCompileCommands());
}

CXStringSet *clang_CompilationDatabase_getAllFiles(CXCompilationDatabase DB) {
  return extra::makeCXStringSet(unwrapDB(DB)->getAllFiles());
}

// FixedCompilationDatabase

CXFixedCompilationDatabase clang_FixedCompilationDatabase_create(const char *Directory,
                                                                 const char **CommandLine,
                                                                 unsigned N) {
  std::vector<std::string> Args = toStrings(CommandLine, N);
  return reinterpret_cast<CXFixedCompilationDatabase>(
      std::make_unique<clang::tooling::FixedCompilationDatabase>(
          llvm::Twine(Directory ? Directory : "."), llvm::ArrayRef<std::string>(Args))
          .release());
}

CXFixedCompilationDatabase
clang_FixedCompilationDatabase_loadFromCommandLine(int *Argc, const char **Argv,
                                                   CXString *ErrorMsg, const char *Directory) {
  std::string Err;
  int LocalArgc = Argc ? *Argc : 0;
  auto DB = clang::tooling::FixedCompilationDatabase::loadFromCommandLine(
      LocalArgc, Argv, Err, llvm::Twine(Directory ? Directory : "."));
  if (Argc)
    *Argc = LocalArgc;
  publishError(ErrorMsg, Err);
  return reinterpret_cast<CXFixedCompilationDatabase>(DB.release());
}

CXFixedCompilationDatabase clang_FixedCompilationDatabase_loadFromFile(const char *Path,
                                                                       CXString *ErrorMsg) {
  std::string Err;
  auto DB = clang::tooling::FixedCompilationDatabase::loadFromFile(Path ? Path : "", Err);
  publishError(ErrorMsg, Err);
  return reinterpret_cast<CXFixedCompilationDatabase>(DB.release());
}

CXFixedCompilationDatabase clang_FixedCompilationDatabase_loadFromBuffer(const char *Directory,
                                                                        const char *Data,
                                                                        CXString *ErrorMsg) {
  std::string Err;
  auto DB = clang::tooling::FixedCompilationDatabase::loadFromBuffer(
      Directory ? Directory : ".", Data ? Data : "", Err);
  publishError(ErrorMsg, Err);
  return reinterpret_cast<CXFixedCompilationDatabase>(DB.release());
}

// Free functions of namespace clang::tooling

CXCompilationDatabase clang_tooling_inferMissingCompileCommands(CXCompilationDatabase Base) {
  if (!Base)
    return nullptr;
  std::unique_ptr<clang::tooling::CompilationDatabase> Inner(unwrapDB(Base));
  return reinterpret_cast<CXCompilationDatabase>(
      clang::tooling::inferMissingCompileCommands(std::move(Inner)).release());
}

CXCompilationDatabase clang_tooling_inferTargetAndDriverMode(CXCompilationDatabase Base) {
  if (!Base)
    return nullptr;
  std::unique_ptr<clang::tooling::CompilationDatabase> Inner(unwrapDB(Base));
  return reinterpret_cast<CXCompilationDatabase>(
      clang::tooling::inferTargetAndDriverMode(std::move(Inner)).release());
}

CXCompilationDatabase clang_tooling_expandResponseFiles(CXCompilationDatabase Base) {
  if (!Base)
    return nullptr;
  std::unique_ptr<clang::tooling::CompilationDatabase> Inner(unwrapDB(Base));
  return reinterpret_cast<CXCompilationDatabase>(
      clang::tooling::expandResponseFiles(std::move(Inner), llvm::vfs::getRealFileSystem())
          .release());
}

CXCompileCommand clang_tooling_transferCompileCommand(CXCompileCommand CC,
                                                      const char *Filename) {
  return reinterpret_cast<CXCompileCommand>(
      std::make_unique<clang::tooling::CompileCommand>(clang::tooling::transferCompileCommand(
                                                           *unwrapCommand(CC),
                                                           Filename ? Filename : ""))
          .release());
}
