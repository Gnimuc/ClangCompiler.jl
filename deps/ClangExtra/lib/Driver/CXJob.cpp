#include "clang-ex/Driver/CXJob.h"
#include "utils.h"

#include "clang/Driver/InputInfo.h"
#include "clang/Driver/Job.h"
#include "clang/Driver/Tool.h"
#include "clang/Driver/ToolChain.h"
#include "llvm/Support/raw_ostream.h"
#include <string>

static clang::driver::JobList *unwrapJL(CXJobList JL) {
  return reinterpret_cast<clang::driver::JobList *>(JL);
}

static clang::driver::Command *unwrapCmd(CXCommand C) {
  return reinterpret_cast<clang::driver::Command *>(C);
}

static const clang::driver::InputInfo &inputInfo(CXCommand C, unsigned i) {
  return unwrapCmd(C)->getInputInfos()[i];
}

unsigned clang_JobList_size(CXJobList JL) {
  return static_cast<unsigned>(unwrapJL(JL)->size());
}

bool clang_JobList_empty(CXJobList JL) { return unwrapJL(JL)->empty(); }

CXCommand clang_JobList_getJob(CXJobList JL, unsigned i) {
  return reinterpret_cast<CXCommand>(unwrapJL(JL)->getJobs()[i].get());
}

void clang_JobList_clear(CXJobList JL) { unwrapJL(JL)->clear(); }

CXString clang_JobList_Print(CXJobList JL, const char *Terminator, bool Quote) {
  std::string Out;
  llvm::raw_string_ostream OS(Out);
  unwrapJL(JL)->Print(OS, Terminator, Quote);
  OS.flush();
  return extra::makeCXString(Out);
}

const char *clang_Command_getExecutable(CXCommand C) {
  return unwrapCmd(C)->getExecutable();
}

unsigned clang_Command_getNumArguments(CXCommand C) {
  return static_cast<unsigned>(unwrapCmd(C)->getArguments().size());
}

const char *clang_Command_getArgument(CXCommand C, unsigned i) {
  return unwrapCmd(C)->getArguments()[i];
}

unsigned clang_Command_getNumOutputFilenames(CXCommand C) {
  return static_cast<unsigned>(unwrapCmd(C)->getOutputFilenames().size());
}

CXString clang_Command_getOutputFilename(CXCommand C, unsigned i) {
  return extra::makeCXString(unwrapCmd(C)->getOutputFilenames()[i]);
}

unsigned clang_Command_getNumInputInfos(CXCommand C) {
  return static_cast<unsigned>(unwrapCmd(C)->getInputInfos().size());
}

bool clang_Command_isInputInfoNothing(CXCommand C, unsigned i) {
  return inputInfo(C, i).isNothing();
}

bool clang_Command_isInputInfoFilename(CXCommand C, unsigned i) {
  return inputInfo(C, i).isFilename();
}

bool clang_Command_isInputInfoInputArg(CXCommand C, unsigned i) {
  return inputInfo(C, i).isInputArg();
}

const char *clang_Command_getInputInfoFilename(CXCommand C, unsigned i) {
  return inputInfo(C, i).getFilename();
}

unsigned clang_Command_getInputInfoType(CXCommand C, unsigned i) {
  return static_cast<unsigned>(inputInfo(C, i).getType());
}

CXString clang_Command_getInputInfoBaseInput(CXCommand C, unsigned i) {
  const char *S = inputInfo(C, i).getBaseInput();
  return extra::makeCXString(S ? std::string(S) : std::string());
}

CXString clang_Command_getInputInfoAsString(CXCommand C, unsigned i) {
  return extra::makeCXString(inputInfo(C, i).getAsString());
}

CXString clang_Command_Print(CXCommand C, const char *Terminator, bool Quote) {
  std::string Out;
  llvm::raw_string_ostream OS(Out);
  unwrapCmd(C)->Print(OS, Terminator, Quote);
  OS.flush();
  return extra::makeCXString(Out);
}

CXTool clang_Command_getCreator(CXCommand C) {
  return reinterpret_cast<CXTool>(
      const_cast<clang::driver::Tool *>(&unwrapCmd(C)->getCreator()));
}

const char *clang_Tool_getName(CXTool T) {
  return reinterpret_cast<clang::driver::Tool *>(T)->getName();
}

const char *clang_Tool_getShortName(CXTool T) {
  return reinterpret_cast<clang::driver::Tool *>(T)->getShortName();
}

CXToolChain clang_Tool_getToolChain(CXTool T) {
  return reinterpret_cast<CXToolChain>(const_cast<clang::driver::ToolChain *>(
      &reinterpret_cast<clang::driver::Tool *>(T)->getToolChain()));
}

bool clang_Tool_isLinkJob(CXTool T) {
  return reinterpret_cast<clang::driver::Tool *>(T)->isLinkJob();
}
