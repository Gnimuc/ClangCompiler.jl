#include "clang-ex/Tooling/CXArgumentsAdjusters.h"

#include "utils.h"

#include "clang/Tooling/ArgumentsAdjusters.h"
#include "llvm/ADT/StringRef.h"

#include <memory>
#include <string>
#include <utility>
#include <vector>

namespace {

clang::tooling::ArgumentsAdjuster *unwrapAdjuster(CXArgumentsAdjuster A) {
  return reinterpret_cast<clang::tooling::ArgumentsAdjuster *>(A);
}

CXArgumentsAdjuster boxAdjuster(clang::tooling::ArgumentsAdjuster A) {
  return reinterpret_cast<CXArgumentsAdjuster>(
      std::make_unique<clang::tooling::ArgumentsAdjuster>(std::move(A)).release());
}

std::vector<std::string> toStrings(const char **Strs, unsigned N) {
  std::vector<std::string> Out;
  Out.reserve(N);
  for (unsigned I = 0; I < N; ++I)
    Out.emplace_back(Strs && Strs[I] ? Strs[I] : "");
  return Out;
}

} // namespace

CXArgumentsAdjuster clang_tooling_getClangSyntaxOnlyAdjuster(void) {
  return boxAdjuster(clang::tooling::getClangSyntaxOnlyAdjuster());
}

CXArgumentsAdjuster clang_tooling_getClangStripOutputAdjuster(void) {
  return boxAdjuster(clang::tooling::getClangStripOutputAdjuster());
}

CXArgumentsAdjuster clang_tooling_getClangStripDependencyFileAdjuster(void) {
  return boxAdjuster(clang::tooling::getClangStripDependencyFileAdjuster());
}

CXArgumentsAdjuster clang_tooling_getStripPluginsAdjuster(void) {
  return boxAdjuster(clang::tooling::getStripPluginsAdjuster());
}

CXArgumentsAdjuster clang_tooling_getInsertArgumentAdjuster(const char *Extra,
                                                            CXArgumentInsertPosition Pos) {
  return boxAdjuster(clang::tooling::getInsertArgumentAdjuster(
      Extra ? Extra : "",
      static_cast<clang::tooling::ArgumentInsertPosition>(Pos)));
}

CXArgumentsAdjuster
clang_tooling_getInsertArgumentAdjusterForArgs(const char **Extra, unsigned N,
                                               CXArgumentInsertPosition Pos) {
  std::vector<std::string> Args = toStrings(Extra, N);
  return boxAdjuster(clang::tooling::getInsertArgumentAdjuster(
      Args, static_cast<clang::tooling::ArgumentInsertPosition>(Pos)));
}

CXArgumentsAdjuster clang_tooling_combineAdjusters(CXArgumentsAdjuster First,
                                                   CXArgumentsAdjuster Second) {
  clang::tooling::ArgumentsAdjuster F = First ? *unwrapAdjuster(First)
                                              : clang::tooling::ArgumentsAdjuster();
  clang::tooling::ArgumentsAdjuster S = Second ? *unwrapAdjuster(Second)
                                               : clang::tooling::ArgumentsAdjuster();
  return boxAdjuster(clang::tooling::combineAdjusters(std::move(F), std::move(S)));
}

void clang_ArgumentsAdjuster_dispose(CXArgumentsAdjuster A) { delete unwrapAdjuster(A); }

CXStringSet *clang_ArgumentsAdjuster_adjust(CXArgumentsAdjuster A, const char **Args,
                                            unsigned N, const char *Filename) {
  std::vector<std::string> In = toStrings(Args, N);
  clang::tooling::ArgumentsAdjuster *Adj = unwrapAdjuster(A);
  if (!Adj || !*Adj)
    return extra::makeCXStringSet(In);
  return extra::makeCXStringSet((*Adj)(In, Filename ? Filename : ""));
}
