#include "clang-ex/Driver/CXOptions.h"
#include "utils.h"

#include "clang/Driver/Options.h"
#include "llvm/Option/OptTable.h"
#include "llvm/Option/Option.h"
#include "llvm/Support/raw_ostream.h"
#include <memory>
#include <string>

static const llvm::opt::OptTable *unwrapOT(CXOptTable T) {
  return reinterpret_cast<const llvm::opt::OptTable *>(T);
}

static llvm::opt::Option *unwrapOpt(CXOption O) {
  return reinterpret_cast<llvm::opt::Option *>(O);
}

CXOptTable clang_driver_getDriverOptTable(void) {
  return reinterpret_cast<CXOptTable>(
      const_cast<llvm::opt::OptTable *>(&clang::driver::getDriverOptTable()));
}

unsigned clang_OptTable_getNumOptions(CXOptTable T) {
  return unwrapOT(T)->getNumOptions();
}

CXString clang_OptTable_getOptionName(CXOptTable T, unsigned Id) {
  return extra::makeCXString(unwrapOT(T)->getOptionName(Id).str());
}

CXString clang_OptTable_getOptionHelpText(CXOptTable T, unsigned Id) {
  const char *S = unwrapOT(T)->getOptionHelpText(Id);
  return extra::makeCXString(S ? std::string(S) : std::string());
}

CXOption clang_OptTable_getOption(CXOptTable T, unsigned Id) {
  return reinterpret_cast<CXOption>(
      std::make_unique<llvm::opt::Option>(unwrapOT(T)->getOption(Id)).release());
}

void clang_Option_dispose(CXOption O) { delete reinterpret_cast<llvm::opt::Option *>(O); }

bool clang_Option_isValid(CXOption O) { return unwrapOpt(O)->isValid(); }

unsigned clang_Option_getID(CXOption O) { return unwrapOpt(O)->getID(); }

CXOptionClass clang_Option_getKind(CXOption O) {
  return static_cast<CXOptionClass>(unwrapOpt(O)->getKind());
}

CXString clang_Option_getName(CXOption O) {
  return extra::makeCXString(unwrapOpt(O)->getName().str());
}

CXString clang_Option_getPrefixedName(CXOption O) {
  return extra::makeCXString(unwrapOpt(O)->getPrefixedName().str());
}

CXString clang_OptTable_findNearest(CXOptTable T, const char *Option,
                                    unsigned VisibilityMask, unsigned MinimumLength,
                                    unsigned MaximumDistance, unsigned *Distance) {
  std::string Nearest;
  unsigned D = unwrapOT(T)->findNearest(llvm::StringRef(Option), Nearest,
                                        llvm::opt::Visibility(VisibilityMask),
                                        MinimumLength, MaximumDistance);
  if (Distance)
    *Distance = D;
  return extra::makeCXString(Nearest);
}

CXString clang_OptTable_printHelp(CXOptTable T, const char *Usage, const char *Title,
                                  bool ShowHidden, bool ShowAllAliases,
                                  unsigned VisibilityMask) {
  std::string Out;
  llvm::raw_string_ostream OS(Out);
  unwrapOT(T)->printHelp(OS, Usage, Title, ShowHidden, ShowAllAliases,
                         llvm::opt::Visibility(VisibilityMask));
  OS.flush();
  return extra::makeCXString(Out);
}
