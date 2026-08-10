#include "clang-ex/CodeGen/CXObjectFilePCHContainerOperations.h"
#include "utils.h"
#include "clang/CodeGen/ObjectFilePCHContainerOperations.h"
#include "clang/Serialization/PCHContainerOperations.h"
#include <memory>

namespace {

clang::PCHContainerOperations *unwrapOps(CXPCHContainerOperations Ops) {
  return reinterpret_cast<clang::PCHContainerOperations *>(Ops);
}

CXPCHContainerReader wrapReader(const clang::PCHContainerReader *R) {
  return reinterpret_cast<CXPCHContainerReader>(
      const_cast<clang::PCHContainerReader *>(R));
}

} // namespace

CXPCHContainerOperations clang_PCHContainerOperations_create(void) {
  return reinterpret_cast<CXPCHContainerOperations>(
      std::make_unique<clang::PCHContainerOperations>().release());
}

void clang_PCHContainerOperations_dispose(CXPCHContainerOperations Ops) {
  delete reinterpret_cast<clang::PCHContainerOperations *>(Ops);
}

void clang_PCHContainerOperations_registerObjectFilePCHContainerWriter(
    CXPCHContainerOperations Ops) {
  unwrapOps(Ops)->registerWriter(
      std::make_unique<clang::ObjectFilePCHContainerWriter>());
}

void clang_PCHContainerOperations_registerObjectFilePCHContainerReader(
    CXPCHContainerOperations Ops) {
  unwrapOps(Ops)->registerReader(
      std::make_unique<clang::ObjectFilePCHContainerReader>());
}

CXPCHContainerWriter clang_PCHContainerOperations_getWriterOrNull(CXPCHContainerOperations Ops,
                                                                  const char *Format) {
  return reinterpret_cast<CXPCHContainerWriter>(const_cast<clang::PCHContainerWriter *>(
      unwrapOps(Ops)->getWriterOrNull(llvm::StringRef(Format))));
}

CXPCHContainerReader clang_PCHContainerOperations_getReaderOrNull(CXPCHContainerOperations Ops,
                                                                  const char *Format) {
  return wrapReader(unwrapOps(Ops)->getReaderOrNull(llvm::StringRef(Format)));
}

CXPCHContainerReader clang_PCHContainerOperations_getRawReader(CXPCHContainerOperations Ops) {
  return wrapReader(&unwrapOps(Ops)->getRawReader());
}

CXString clang_PCHContainerWriter_getFormat(CXPCHContainerWriter W) {
  return extra::makeCXString(
      reinterpret_cast<const clang::PCHContainerWriter *>(W)->getFormat().str());
}

unsigned clang_PCHContainerReader_getNumFormats(CXPCHContainerReader R) {
  return static_cast<unsigned>(
      reinterpret_cast<const clang::PCHContainerReader *>(R)->getFormats().size());
}

CXString clang_PCHContainerReader_getFormat(CXPCHContainerReader R, unsigned I) {
  return extra::makeCXString(
      reinterpret_cast<const clang::PCHContainerReader *>(R)->getFormats()[I].str());
}
