#ifndef LLVM_CLANG_C_EXTRA_CXJOB_H
#define LLVM_CLANG_C_EXTRA_CXJOB_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// The jobs a Compilation was built out of: one Command per subprocess the driver would
// run. This is the `-###` view, and the -cc1 argument vector it exposes is exactly what
// clang_CompilerInvocation_CreateFromArgs consumes.
//
// A JobList is a member of its Compilation and every Command in it is owned by that list,
// so both handles are borrowed and neither has a dispose. Both die with the Compilation.

// JobList
unsigned clang_JobList_size(CXJobList JL);

bool clang_JobList_empty(CXJobList JL);

// Precondition: i < clang_JobList_size(JL). The list is indexed without a bounds check.
CXCommand clang_JobList_getJob(CXJobList JL, unsigned i);

// Drops every command. The Compilation keeps its temporary files; only the plan goes.
void clang_JobList_clear(CXJobList JL);

// The whole plan rendered the way `clang -###` prints it. `Terminator` is written after
// each command (usually "\n") and `Quote` asks for shell-quotable escaping.
CXString clang_JobList_Print(CXJobList JL, const char *Terminator, bool Quote);

// Command
//
// Borrowed: the executable and every argument string are owned by the driver's own
// argument allocator and live as long as the Compilation.
const char *clang_Command_getExecutable(CXCommand C);

unsigned clang_Command_getNumArguments(CXCommand C);

// Precondition: i < clang_Command_getNumArguments(C).
const char *clang_Command_getArgument(CXCommand C, unsigned i);

// The files this command writes. std::string members, so these cross as copies.
unsigned clang_Command_getNumOutputFilenames(CXCommand C);

// Precondition: i < clang_Command_getNumOutputFilenames(C).
CXString clang_Command_getOutputFilename(CXCommand C, unsigned i);

// The inputs, flattened: InputInfo is a tagged union of a filename, a parsed argument and
// nothing at all, so the tag comes across as three predicates and each payload accessor
// carries the tag it needs. Every accessor here has the same index precondition,
// i < clang_Command_getNumInputInfos(C).
unsigned clang_Command_getNumInputInfos(CXCommand C);

bool clang_Command_isInputInfoNothing(CXCommand C, unsigned i);
bool clang_Command_isInputInfoFilename(CXCommand C, unsigned i);
bool clang_Command_isInputInfoInputArg(CXCommand C, unsigned i);

// Precondition: clang_Command_isInputInfoFilename(C, i) — clang asserts on the other two
// tags. Borrowed, like every other driver argument string.
const char *clang_Command_getInputInfoFilename(CXCommand C, unsigned i);

// The driver type ID of the input, as a raw clang::driver::types::ID — the currency
// clang-ex/Driver/CXDriverTypes.h reads. Total over every tag.
unsigned clang_Command_getInputInfoType(CXCommand C, unsigned i);

// The original file this input derives from, whatever the tag. May be NULL for an input
// the driver synthesised, so it crosses as a possibly-empty copy.
CXString clang_Command_getInputInfoBaseInput(CXCommand C, unsigned i);

// clang's own debugging rendering of the input: the quoted filename, "(input arg)" or
// "(nothing)". Total over every tag, which is what makes it worth having next to the
// payload accessors.
CXString clang_Command_getInputInfoAsString(CXCommand C, unsigned i);

// This one command rendered as `clang -###` would print it.
CXString clang_Command_Print(CXCommand C, const char *Terminator, bool Quote);

// Borrowed: the Tool that built this command, owned by its toolchain.
CXTool clang_Command_getCreator(CXCommand C);

// Tool
const char *clang_Tool_getName(CXTool T);

const char *clang_Tool_getShortName(CXTool T);

// Borrowed: the toolchain this tool belongs to.
CXToolChain clang_Tool_getToolChain(CXTool T);

// Whether this tool links. The one predicate that picks the link job out of a plan, which
// is where a JIT looks for the libraries and -L paths the driver decided on.
bool clang_Tool_isLinkJob(CXTool T);

LLVM_CLANG_C_EXTERN_C_END

#endif
