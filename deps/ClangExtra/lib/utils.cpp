#include "utils.h"
#include "llvm/ADT/STLExtras.h"

namespace extra {

CXString makeCXString(const std::string &S) {
  CXString Str;
  if (S.empty()) {
    Str.data = "";
    Str.private_flags = 0; // CXS_Unmanaged
  } else {
    Str.data = strdup(S.c_str());
    Str.private_flags = 1; // CXS_Malloc
  }
  return Str;
}

CXStringSet *makeCXStringSet(const std::vector<std::string> &Strs) {
  auto *Set = new CXStringSet; // NOLINT(*-owning-memory)
  Set->Count = Strs.size();
  Set->Strings = new CXString[Set->Count]; // NOLINT(*-owning-memory)
  for (auto En : llvm::enumerate(Strs)) {
    Set->Strings[En.index()] = makeCXString(En.value());
  }
  return Set;
}

} // namespace extra