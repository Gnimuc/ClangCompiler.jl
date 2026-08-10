#include "clang-ex/Index/CXCommentToXML.h"

#include "utils.h"

#include "clang/AST/ASTContext.h"
#include "clang/AST/Comment.h"
#include "clang/Index/CommentToXML.h"
#include "llvm/ADT/SmallString.h"
#include "llvm/ADT/SmallVector.h"

#include <memory>
#include <string>

static clang::index::CommentToXMLConverter *conv(CXCommentToXMLConverter C) {
  return reinterpret_cast<clang::index::CommentToXMLConverter *>(C);
}

static CXString fromBuf(const llvm::SmallVectorImpl<char> &Buf) {
  return extra::makeCXString(std::string(Buf.begin(), Buf.end()));
}

CXCommentToXMLConverter clang_CommentToXMLConverter_create(void) {
  auto C = std::make_unique<clang::index::CommentToXMLConverter>();
  return reinterpret_cast<CXCommentToXMLConverter>(C.release());
}

void clang_CommentToXMLConverter_dispose(CXCommentToXMLConverter C) {
  delete reinterpret_cast<clang::index::CommentToXMLConverter *>(C);
}

CXString clang_CommentToXMLConverter_convertCommentToHTML(CXCommentToXMLConverter C,
                                                          CXFullComment FC,
                                                          CXASTContext Context) {
  llvm::SmallString<256> Buf;
  conv(C)->convertCommentToHTML(reinterpret_cast<clang::comments::FullComment *>(FC), Buf,
                                *reinterpret_cast<clang::ASTContext *>(Context));
  return fromBuf(Buf);
}

CXString clang_CommentToXMLConverter_convertHTMLTagNodeToText(CXCommentToXMLConverter C,
                                                              CXHTMLTagComment HTC,
                                                              CXASTContext Context) {
  llvm::SmallString<256> Buf;
  conv(C)->convertHTMLTagNodeToText(
      reinterpret_cast<clang::comments::HTMLTagComment *>(HTC), Buf,
      *reinterpret_cast<clang::ASTContext *>(Context));
  return fromBuf(Buf);
}

CXString clang_CommentToXMLConverter_convertCommentToXML(CXCommentToXMLConverter C,
                                                         CXFullComment FC,
                                                         CXASTContext Context) {
  llvm::SmallString<256> Buf;
  conv(C)->convertCommentToXML(reinterpret_cast<clang::comments::FullComment *>(FC), Buf,
                               *reinterpret_cast<clang::ASTContext *>(Context));
  return fromBuf(Buf);
}
