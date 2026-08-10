#include "clang-ex/Frontend/CXPrecompiledPreamble.h"
#include "utils.h"
#include "clang/Basic/Diagnostic.h"
#include "clang/Basic/LangOptions.h"
#include "clang/Frontend/CompilerInvocation.h"
#include "clang/Frontend/PrecompiledPreamble.h"
#include "clang/Serialization/PCHContainerOperations.h"
#include "llvm/Support/MemoryBuffer.h"
#include "llvm/Support/VirtualFileSystem.h"
#include "llvm/Support/raw_ostream.h"

#include <memory>

namespace {

// Everything a PrecompiledPreamble expects its caller to keep alive, boxed together with
// the (move-only) preamble itself so one handle owns the lot. See the header for why the
// VFS is always the real filesystem and why the main-file buffer has to live here.
struct PreambleBox {
  clang::PrecompiledPreamble Preamble;
  llvm::IntrusiveRefCntPtr<llvm::vfs::FileSystem> VFS;
  std::unique_ptr<llvm::MemoryBuffer> MainBuffer;

  PreambleBox(clang::PrecompiledPreamble P,
              llvm::IntrusiveRefCntPtr<llvm::vfs::FileSystem> FS)
      : Preamble(std::move(P)), VFS(std::move(FS)) {}
};

clang::PreambleBounds unwrapBounds(CXPreambleBounds_ B) {
  return clang::PreambleBounds(B.Size, B.PreambleEndsAtStartOfLine);
}

CXPreambleBounds_ wrapBounds(clang::PreambleBounds B) {
  return CXPreambleBounds_{B.Size, B.PreambleEndsAtStartOfLine};
}

// A null-terminated copy: clang lexes the preamble out of this buffer and
// MemoryBuffer::getMemBuffer over a caller's pointer would promise a terminator the caller
// never agreed to provide.
std::unique_ptr<llvm::MemoryBuffer> copyBuffer(const char *Contents, size_t Length,
                                               const char *Name) {
  return llvm::MemoryBuffer::getMemBufferCopy(llvm::StringRef(Contents, Length),
                                              Name ? Name : "");
}

} // namespace

CXPreambleBounds_ clang_ComputePreambleBounds(CXLangOptions LangOpts, const char *Buffer,
                                              size_t Length, unsigned MaxLines) {
  auto Buf = copyBuffer(Buffer, Length, "<preamble-input>");
  return wrapBounds(clang::ComputePreambleBounds(
      *reinterpret_cast<clang::LangOptions *>(LangOpts), Buf->getMemBufferRef(), MaxLines));
}

CXPrecompiledPreamble clang_PrecompiledPreamble_Build(CXCompilerInvocation Invocation,
                                                      const char *MainFileContents,
                                                      size_t Length,
                                                      const char *MainFileName,
                                                      CXPreambleBounds_ Bounds,
                                                      CXDiagnosticsEngine Diagnostics,
                                                      const char *StoragePath) {
  auto Buf = copyBuffer(MainFileContents, Length, MainFileName);
  llvm::IntrusiveRefCntPtr<llvm::vfs::FileSystem> VFS = llvm::vfs::getRealFileSystem();
  clang::PreambleCallbacks Callbacks;
  auto Built = clang::PrecompiledPreamble::Build(
      *reinterpret_cast<clang::CompilerInvocation *>(Invocation), Buf.get(),
      unwrapBounds(Bounds), *reinterpret_cast<clang::DiagnosticsEngine *>(Diagnostics), VFS,
      std::make_shared<clang::PCHContainerOperations>(), /*StoreInMemory=*/false,
      llvm::StringRef(StoragePath ? StoragePath : ""), Callbacks);
  if (!Built) {
    llvm::errs() << "clang_PrecompiledPreamble_Build: " << Built.getError().message()
                 << "\n";
    return nullptr;
  }
  auto Box = std::make_unique<PreambleBox>(std::move(*Built), std::move(VFS));
  return reinterpret_cast<CXPrecompiledPreamble>(Box.release());
}

void clang_PrecompiledPreamble_dispose(CXPrecompiledPreamble P) {
  delete reinterpret_cast<PreambleBox *>(P);
}

CXPreambleBounds_ clang_PrecompiledPreamble_getBounds(CXPrecompiledPreamble P) {
  return wrapBounds(reinterpret_cast<PreambleBox *>(P)->Preamble.getBounds());
}

size_t clang_PrecompiledPreamble_getSize(CXPrecompiledPreamble P) {
  return reinterpret_cast<PreambleBox *>(P)->Preamble.getSize();
}

CXString clang_PrecompiledPreamble_getContents(CXPrecompiledPreamble P) {
  return extra::makeCXString(
      reinterpret_cast<PreambleBox *>(P)->Preamble.getContents().str());
}

bool clang_PrecompiledPreamble_CanReuse(CXPrecompiledPreamble P,
                                        CXCompilerInvocation Invocation,
                                        const char *MainFileContents, size_t Length,
                                        const char *MainFileName,
                                        CXPreambleBounds_ Bounds) {
  auto *Box = reinterpret_cast<PreambleBox *>(P);
  auto Buf = copyBuffer(MainFileContents, Length, MainFileName);
  return Box->Preamble.CanReuse(*reinterpret_cast<clang::CompilerInvocation *>(Invocation),
                                Buf->getMemBufferRef(), unwrapBounds(Bounds), *Box->VFS);
}

void clang_PrecompiledPreamble_AddImplicitPreamble(CXPrecompiledPreamble P,
                                                   CXCompilerInvocation CI,
                                                   const char *MainFileContents,
                                                   size_t Length,
                                                   const char *MainFileName) {
  auto *Box = reinterpret_cast<PreambleBox *>(P);
  Box->MainBuffer = copyBuffer(MainFileContents, Length, MainFileName);
  Box->Preamble.AddImplicitPreamble(*reinterpret_cast<clang::CompilerInvocation *>(CI),
                                    Box->VFS, Box->MainBuffer.get());
}

void clang_PrecompiledPreamble_OverridePreamble(CXPrecompiledPreamble P,
                                                CXCompilerInvocation CI,
                                                const char *MainFileContents, size_t Length,
                                                const char *MainFileName) {
  auto *Box = reinterpret_cast<PreambleBox *>(P);
  Box->MainBuffer = copyBuffer(MainFileContents, Length, MainFileName);
  Box->Preamble.OverridePreamble(*reinterpret_cast<clang::CompilerInvocation *>(CI),
                                 Box->VFS, Box->MainBuffer.get());
}
