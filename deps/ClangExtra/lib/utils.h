#ifndef LLVM_CLANG_CPP_EXTRA_UTILS_H
#define LLVM_CLANG_CPP_EXTRA_UTILS_H

#include "clang-c/CXString.h"
#include <string>
#include <vector>

namespace extra {

CXString makeCXString(const std::string &S);

CXStringSet *makeCXStringSet(const std::vector<std::string> &Strs);

} // namespace extra

#endif