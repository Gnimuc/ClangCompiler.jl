#include "clang-ex/Lex/CXDependencyDirectivesScanner.h"
#include "utils.h"

#include "clang/Basic/Diagnostic.h"
#include "clang/Basic/SourceLocation.h"
#include "clang/Lex/DependencyDirectivesScanner.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/raw_ostream.h"

#include <memory>
#include <string>

namespace {

namespace dds = clang::dependency_directives_scan;

// The three pieces of one scan, boxed together because each Directive's `Tokens` is an
// ArrayRef into `Tokens` and the printer needs the original source: handing any of them
// out on its own leaves a view over freed memory.
struct DependencyDirectivesScanBox {
  std::string Source;
  llvm::SmallVector<dds::Token, 32> Tokens;
  llvm::SmallVector<dds::Directive, 16> Directives;
};

DependencyDirectivesScanBox *box(CXDependencyDirectivesScan S) {
  return reinterpret_cast<DependencyDirectivesScanBox *>(S);
}

} // namespace

CXDependencyDirectivesScan
clang_DependencyDirectivesScan_create(const char *Input, size_t Len,
                                      CXDiagnosticsEngine Diags,
                                      CXSourceLocation_ InputSourceLoc, bool *HadError) {
  auto S = std::make_unique<DependencyDirectivesScanBox>();
  S->Source.assign(Input, Len);
  bool Error = clang::scanSourceForDependencyDirectives(
      S->Source, S->Tokens, S->Directives,
      reinterpret_cast<clang::DiagnosticsEngine *>(Diags),
      clang::SourceLocation::getFromPtrEncoding(InputSourceLoc));
  if (HadError)
    *HadError = Error;
  return reinterpret_cast<CXDependencyDirectivesScan>(S.release());
}

void clang_DependencyDirectivesScan_dispose(CXDependencyDirectivesScan S) {
  delete box(S);
}

unsigned clang_DependencyDirectivesScan_getNumTokens(CXDependencyDirectivesScan S) {
  return box(S)->Tokens.size();
}

void clang_DependencyDirectivesScan_getToken(CXDependencyDirectivesScan S, unsigned I,
                                             unsigned *Offset, unsigned *Length,
                                             unsigned *Kind, unsigned *Flags) {
  const dds::Token &Tok = box(S)->Tokens[I];
  *Offset = Tok.Offset;
  *Length = Tok.Length;
  *Kind = static_cast<unsigned>(Tok.Kind);
  *Flags = Tok.Flags;
}

unsigned clang_DependencyDirectivesScan_getNumDirectives(CXDependencyDirectivesScan S) {
  return box(S)->Directives.size();
}

CXDependencyDirectiveKind
clang_DependencyDirectivesScan_getDirectiveKind(CXDependencyDirectivesScan S, unsigned I) {
  return static_cast<CXDependencyDirectiveKind>(box(S)->Directives[I].Kind);
}

unsigned clang_DependencyDirectivesScan_getNumDirectiveTokens(CXDependencyDirectivesScan S,
                                                              unsigned I) {
  return box(S)->Directives[I].Tokens.size();
}

unsigned
clang_DependencyDirectivesScan_getDirectiveFirstTokenIndex(CXDependencyDirectivesScan S,
                                                           unsigned I) {
  auto *B = box(S);
  const dds::Directive &D = B->Directives[I];
  if (D.Tokens.empty())
    return 0;
  return static_cast<unsigned>(D.Tokens.data() - B->Tokens.data());
}

CXString clang_DependencyDirectivesScan_printAsSource(CXDependencyDirectivesScan S) {
  auto *B = box(S);
  std::string Out;
  llvm::raw_string_ostream OS(Out);
  clang::printDependencyDirectivesAsSource(B->Source, B->Directives, OS);
  OS.flush();
  return extra::makeCXString(Out);
}
