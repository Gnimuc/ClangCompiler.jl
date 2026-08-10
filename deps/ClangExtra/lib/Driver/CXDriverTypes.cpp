#include "clang-ex/Driver/CXDriverTypes.h"

#include "clang/Driver/Phases.h"
#include "clang/Driver/Types.h"

namespace types = clang::driver::types;
namespace phases = clang::driver::phases;

unsigned clang_types_getLastTypeID(void) { return static_cast<unsigned>(types::TY_LAST); }

unsigned clang_phases_getMaxNumberOfPhases(void) {
  return static_cast<unsigned>(phases::MaxNumberOfPhases);
}

const char *clang_types_getTypeName(unsigned Id) {
  return types::getTypeName(static_cast<types::ID>(Id));
}

unsigned clang_types_getPreprocessedType(unsigned Id) {
  return static_cast<unsigned>(types::getPreprocessedType(static_cast<types::ID>(Id)));
}

const char *clang_types_getTypeTempSuffix(unsigned Id, bool CLStyle) {
  return types::getTypeTempSuffix(static_cast<types::ID>(Id), CLStyle);
}

bool clang_types_isCXX(unsigned Id) { return types::isCXX(static_cast<types::ID>(Id)); }

bool clang_types_isSrcFile(unsigned Id) {
  return types::isSrcFile(static_cast<types::ID>(Id));
}

bool clang_types_isLLVMIR(unsigned Id) {
  return types::isLLVMIR(static_cast<types::ID>(Id));
}

bool clang_types_isAcceptedByClang(unsigned Id) {
  return types::isAcceptedByClang(static_cast<types::ID>(Id));
}

unsigned clang_types_lookupTypeForExtension(const char *Ext) {
  return static_cast<unsigned>(types::lookupTypeForExtension(llvm::StringRef(Ext)));
}

unsigned clang_types_lookupTypeForTypeSpecifier(const char *Name) {
  return static_cast<unsigned>(types::lookupTypeForTypeSpecifier(Name));
}

unsigned clang_types_getCompilationPhases(unsigned Id, CXPhaseID LastPhase, CXPhaseID *Buf,
                                          unsigned N) {
  llvm::SmallVector<phases::ID, phases::MaxNumberOfPhases> P =
      types::getCompilationPhases(static_cast<types::ID>(Id),
                                  static_cast<phases::ID>(LastPhase));
  for (unsigned I = 0; I < N && I < P.size(); ++I)
    Buf[I] = static_cast<CXPhaseID>(P[I]);
  return static_cast<unsigned>(P.size());
}

const char *clang_phases_getPhaseName(CXPhaseID Id) {
  return phases::getPhaseName(static_cast<phases::ID>(Id));
}
