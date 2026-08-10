#ifndef LLVM_CLANG_C_EXTRA_CXCOMMENTTOXML_H
#define LLVM_CLANG_C_EXTRA_CXCOMMENTTOXML_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang::index::CommentToXMLConverter (clang/Index/CommentToXML.h) -- renders a parsed
// doc comment as XML or HTML, which is what libclang's clang_FullComment_getAsXML gives
// and what a generator emitting Julia docstrings wants instead of walking the comment AST
// node by node. clang_ASTContext_getCommentForDecl already yields the CXFullComment these
// take.
//
// Each upstream method writes into a `SmallVectorImpl<char>` out-parameter; every wrapper
// here returns that buffer as a CXString.

// Caller-owned; free with clang_CommentToXMLConverter_dispose. The object's only state is
// a formatting-context cache, so one per session is the intended use, but it is not
// thread-safe: two concurrent conversions must not share a converter.
CXCommentToXMLConverter clang_CommentToXMLConverter_create(void);
void clang_CommentToXMLConverter_dispose(CXCommentToXMLConverter C);

// PRECONDITION for all three: the comment must be non-NULL (each converter visits it
// unconditionally), and Context must be the ASTContext the comment was parsed in -- the
// converters read the comment's source locations and the declaration it is attached to out
// of that context's tables.
CXString clang_CommentToXMLConverter_convertCommentToHTML(CXCommentToXMLConverter C,
                                                          CXFullComment FC,
                                                          CXASTContext Context);

CXString clang_CommentToXMLConverter_convertHTMLTagNodeToText(CXCommentToXMLConverter C,
                                                              CXHTMLTagComment HTC,
                                                              CXASTContext Context);

CXString clang_CommentToXMLConverter_convertCommentToXML(CXCommentToXMLConverter C,
                                                         CXFullComment FC,
                                                         CXASTContext Context);

LLVM_CLANG_C_EXTERN_C_END

#endif
