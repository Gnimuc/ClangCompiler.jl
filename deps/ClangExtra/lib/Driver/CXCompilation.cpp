#include "clang-ex/Driver/CXCompilation.h"
#include "utils.h"
#include "clang/Driver/Compilation.h"
#include "clang/Driver/Driver.h"
#include "clang/Driver/Job.h"
#include "clang/Driver/ToolChain.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Option/ArgList.h"
#include <optional>
#include <string>
#include <utility>
#include <vector>

void clang_Compilation_dispose(CXCompilation C) {
  delete reinterpret_cast<clang::driver::Compilation *>(C);
}

CXDriver clang_Compilation_getDriver(CXCompilation C) {
  return reinterpret_cast<CXDriver>(const_cast<clang::driver::Driver *>(
      &reinterpret_cast<clang::driver::Compilation *>(C)->getDriver()));
}

CXToolChain clang_Compilation_getDefaultToolChain(CXCompilation C) {
  return reinterpret_cast<CXToolChain>(const_cast<clang::driver::ToolChain *>(
      &reinterpret_cast<clang::driver::Compilation *>(C)->getDefaultToolChain()));
}

unsigned clang_Compilation_getActiveOffloadKinds(CXCompilation C) {
  return reinterpret_cast<clang::driver::Compilation *>(C)->getActiveOffloadKinds();
}

CXString clang_Compilation_getSysRoot(CXCompilation C) {
  return extra::makeCXString(
      reinterpret_cast<clang::driver::Compilation *>(C)->getSysRoot().str());
}

unsigned clang_Compilation_getNumTempFiles(CXCompilation C) {
  return static_cast<unsigned>(
      reinterpret_cast<clang::driver::Compilation *>(C)->getTempFiles().size());
}

const char *clang_Compilation_getTempFile(CXCompilation C, unsigned i) {
  return reinterpret_cast<clang::driver::Compilation *>(C)->getTempFiles()[i];
}

bool clang_Compilation_isForDiagnostics(CXCompilation C) {
  return reinterpret_cast<clang::driver::Compilation *>(C)->isForDiagnostics();
}

bool clang_Compilation_containsError(CXCompilation C) {
  return reinterpret_cast<clang::driver::Compilation *>(C)->containsError();
}

void clang_Compilation_setContainsError(CXCompilation C) {
  reinterpret_cast<clang::driver::Compilation *>(C)->setContainsError();
}

CXJobList clang_Compilation_getJobs(CXCompilation C) {
  return reinterpret_cast<CXJobList>(
      &reinterpret_cast<clang::driver::Compilation *>(C)->getJobs());
}

// The two execution entry points share this: clang answers with a SmallVector of
// (result code, Command) pairs, and the caller supplied a fixed-size pair of buffers.
static void reportFailures(
    const llvm::SmallVectorImpl<std::pair<int, const clang::driver::Command *>> &Failing,
    unsigned *NumFailing, int *FailingResults, CXCommand *FailingCommands, unsigned N) {
  if (NumFailing)
    *NumFailing = static_cast<unsigned>(Failing.size());
  for (unsigned I = 0; I < N && I < Failing.size(); ++I) {
    if (FailingResults)
      FailingResults[I] = Failing[I].first;
    if (FailingCommands)
      FailingCommands[I] = reinterpret_cast<CXCommand>(
          const_cast<clang::driver::Command *>(Failing[I].second));
  }
}

void clang_Compilation_ExecuteJobs(CXCompilation C, CXJobList Jobs, bool LogOnly,
                                   unsigned *NumFailing, int *FailingResults,
                                   CXCommand *FailingCommands, unsigned N) {
  llvm::SmallVector<std::pair<int, const clang::driver::Command *>, 4> Failing;
  reinterpret_cast<clang::driver::Compilation *>(C)->ExecuteJobs(
      *reinterpret_cast<clang::driver::JobList *>(Jobs), Failing, LogOnly);
  reportFailures(Failing, NumFailing, FailingResults, FailingCommands, N);
}

void clang_Compilation_Redirect(CXCompilation C, const char *In, const char *Out,
                                const char *Err) {
  auto *Comp = reinterpret_cast<clang::driver::Compilation *>(C);
  const char *Paths[3] = {In, Out, Err};
  std::vector<std::optional<llvm::StringRef>> Redirects;
  Redirects.reserve(3);
  for (const char *P : Paths) {
    if (P)
      // Owned by the compilation's argument allocator, which is what clang's non-owning
      // StringRefs need.
      Redirects.emplace_back(llvm::StringRef(Comp->getArgs().MakeArgString(P)));
    else
      Redirects.emplace_back(std::nullopt);
  }
  Comp->Redirect(Redirects);
}
