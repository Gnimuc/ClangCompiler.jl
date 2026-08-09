#include "clang-ex/Frontend/CXTextDiagnosticBuffer.h"
#include "utils.h"
#include "clang/Basic/Diagnostic.h"
#include "clang/Frontend/TextDiagnosticBuffer.h"
#include <memory>

CXDiagnosticConsumer clang_TextDiagnosticBuffer_create(void) {
  auto DB = std::make_unique<clang::TextDiagnosticBuffer>();
  return reinterpret_cast<CXDiagnosticConsumer>(DB.release());
}

// The four buffered lists are reachable only through their begin/end iterator pairs, which
// are random-access, so a level selects a [begin, end) range and an index offsets into it.
static std::pair<clang::TextDiagnosticBuffer::const_iterator,
                 clang::TextDiagnosticBuffer::const_iterator>
levelRange(CXDiagnosticConsumer DC, CXTextDiagnosticBuffer_Level Level) {
  auto *DB = reinterpret_cast<clang::TextDiagnosticBuffer *>(DC);
  switch (Level) {
  case CXTextDiagnosticBuffer_Note:
    return {DB->note_begin(), DB->note_end()};
  case CXTextDiagnosticBuffer_Remark:
    return {DB->remark_begin(), DB->remark_end()};
  case CXTextDiagnosticBuffer_Warning:
    return {DB->warn_begin(), DB->warn_end()};
  case CXTextDiagnosticBuffer_Error:
    break;
  }
  return {DB->err_begin(), DB->err_end()};
}

unsigned clang_TextDiagnosticBuffer_size(CXDiagnosticConsumer DC,
                                         CXTextDiagnosticBuffer_Level Level) {
  auto R = levelRange(DC, Level);
  return static_cast<unsigned>(std::distance(R.first, R.second));
}

CXString clang_TextDiagnosticBuffer_getMessage(CXDiagnosticConsumer DC,
                                               CXTextDiagnosticBuffer_Level Level,
                                               unsigned Idx) {
  return extra::makeCXString(levelRange(DC, Level).first[Idx].second);
}

CXSourceLocation_ clang_TextDiagnosticBuffer_getLocation(CXDiagnosticConsumer DC,
                                                         CXTextDiagnosticBuffer_Level Level,
                                                         unsigned Idx) {
  return reinterpret_cast<CXSourceLocation_>(
      levelRange(DC, Level).first[Idx].first.getPtrEncoding());
}

void clang_TextDiagnosticBuffer_FlushDiagnostics(CXDiagnosticConsumer DC,
                                                 CXDiagnosticsEngine DE) {
  reinterpret_cast<clang::TextDiagnosticBuffer *>(DC)->FlushDiagnostics(
      *reinterpret_cast<clang::DiagnosticsEngine *>(DE));
}
