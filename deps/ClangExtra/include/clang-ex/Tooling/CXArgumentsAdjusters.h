#ifndef LLVM_CLANG_C_EXTRA_CXARGUMENTSADJUSTERS_H
#define LLVM_CLANG_C_EXTRA_CXARGUMENTSADJUSTERS_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include "clang-c/CXString.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/Tooling/ArgumentsAdjusters.h: enum class clang::tooling::ArgumentInsertPosition
typedef enum CXArgumentInsertPosition {
  CXArgumentInsertPosition_BEGIN,
  CXArgumentInsertPosition_END,
} CXArgumentInsertPosition;

// ArgumentsAdjuster
//
// clang::tooling::ArgumentsAdjuster is a std::function typedef, not a class, so the handle
// boxes the closure: every factory below heap-allocates one and hands back a caller-owned
// handle to release with clang_ArgumentsAdjuster_dispose. Writing an adjuster from Julia is
// out of scope -- only the prebuilt ones clang ships and their combination cross here.
//
// A boxed adjuster is a value, not a resource clang holds: appending one to a ClangTool or
// passing it to clang_tooling_buildASTFromCodeWithArgs COPIES the std::function, so the
// handle stays the caller's to dispose in both cases.

// Rewrites the command line to a "syntax check only" one (-fsyntax-only, output flags gone).
CXArgumentsAdjuster clang_tooling_getClangSyntaxOnlyAdjuster(void);

// Removes the output-related flags (-o and friends).
CXArgumentsAdjuster clang_tooling_getClangStripOutputAdjuster(void);

// Removes the dependency-file flags (-M, -MF, -MD ...).
CXArgumentsAdjuster clang_tooling_getClangStripDependencyFileAdjuster(void);

// Removes the plugin-related flags (-load, -plugin, -add-plugin ...).
CXArgumentsAdjuster clang_tooling_getStripPluginsAdjuster(void);

// Inserts one extra argument at Pos. Extra is copied.
CXArgumentsAdjuster clang_tooling_getInsertArgumentAdjuster(const char *Extra,
                                                            CXArgumentInsertPosition Pos);

// getInsertArgumentAdjuster(const CommandLineArguments &, ArgumentInsertPosition) -- the
// overload taking a whole list, which inserts the N entries of Extra in order at Pos.
CXArgumentsAdjuster
clang_tooling_getInsertArgumentAdjusterForArgs(const char **Extra, unsigned N,
                                               CXArgumentInsertPosition Pos);

// Runs First and then Second. Both are only read: the returned adjuster owns its own copies,
// so the two argument handles stay the caller's.
CXArgumentsAdjuster clang_tooling_combineAdjusters(CXArgumentsAdjuster First,
                                                   CXArgumentsAdjuster Second);

void clang_ArgumentsAdjuster_dispose(CXArgumentsAdjuster A);

// helper -- applies the adjuster to a command line, which is the only way to observe what one
// does without running a tool. Returns the adjusted arguments, caller-owned
// (clang_disposeStringSet). An empty (default-constructed) std::function cannot be produced by
// the factories above; should one reach here anyway, the input is returned unchanged rather
// than throwing std::bad_function_call across the boundary.
CXStringSet *clang_ArgumentsAdjuster_adjust(CXArgumentsAdjuster A, const char **Args,
                                            unsigned N, const char *Filename);

LLVM_CLANG_C_EXTERN_C_END

#endif
