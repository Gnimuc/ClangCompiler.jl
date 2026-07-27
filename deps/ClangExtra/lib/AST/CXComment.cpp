#include "clang-ex/AST/CXComment.h"

#include "utils.h"

#include "clang/AST/ASTContext.h"
#include "clang/AST/Comment.h"
#include "clang/AST/CommentCommandTraits.h"
#include "clang/AST/RawCommentList.h"
#include "clang/Basic/SourceManager.h"

// RawComment
CXRawCommentKind clang_RawComment_getKind(CXRawComment RC) {
  return static_cast<CXRawCommentKind>(
      static_cast<clang::RawComment *>(RC)->getKind());
}

bool clang_RawComment_isAttached(CXRawComment RC) {
  return static_cast<clang::RawComment *>(RC)->isAttached();
}

bool clang_RawComment_isTrailingComment(CXRawComment RC) {
  return static_cast<clang::RawComment *>(RC)->isTrailingComment();
}

bool clang_RawComment_isDocumentation(CXRawComment RC) {
  return static_cast<clang::RawComment *>(RC)->isDocumentation();
}

CXString clang_RawComment_getRawText(CXRawComment RC, CXSourceManager SM) {
  auto *C = static_cast<clang::RawComment *>(RC);
  return extra::makeCXString(
      C->getRawText(*static_cast<clang::SourceManager *>(SM)).str());
}

CXSourceRange_ clang_RawComment_getSourceRange(CXRawComment RC) {
  auto rng = static_cast<clang::RawComment *>(RC)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

const char *clang_RawComment_getBriefText(CXRawComment RC, CXASTContext Ctx) {
  return static_cast<clang::RawComment *>(RC)->getBriefText(
      *static_cast<clang::ASTContext *>(Ctx));
}

// Comment
const char *clang_Comment_getCommentKindName(CXComment C) {
  return static_cast<clang::comments::Comment *>(C)->getCommentKindName();
}

CXSourceRange_ clang_Comment_getSourceRange(CXComment C) {
  auto rng = static_cast<clang::comments::Comment *>(C)->getSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXSourceLocation_ clang_Comment_getBeginLoc(CXComment C) {
  return static_cast<clang::comments::Comment *>(C)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_Comment_getEndLoc(CXComment C) {
  return static_cast<clang::comments::Comment *>(C)->getEndLoc().getPtrEncoding();
}

CXSourceLocation_ clang_Comment_getLocation(CXComment C) {
  return static_cast<clang::comments::Comment *>(C)->getLocation().getPtrEncoding();
}

unsigned clang_Comment_child_count(CXComment C) {
  return static_cast<clang::comments::Comment *>(C)->child_count();
}

CXComment clang_Comment_getChild(CXComment C, unsigned i) {
  return *(static_cast<clang::comments::Comment *>(C)->child_begin() + i);
}

// Comment Cast
CXTextComment clang_Comment_castToTextComment(CXComment C) {
  return llvm::dyn_cast_or_null<clang::comments::TextComment>(
      static_cast<clang::comments::Comment *>(C));
}

CXBlockCommandComment clang_Comment_castToBlockCommandComment(CXComment C) {
  return llvm::dyn_cast_or_null<clang::comments::BlockCommandComment>(
      static_cast<clang::comments::Comment *>(C));
}

CXParamCommandComment clang_Comment_castToParamCommandComment(CXComment C) {
  return llvm::dyn_cast_or_null<clang::comments::ParamCommandComment>(
      static_cast<clang::comments::Comment *>(C));
}

CXInlineCommandComment clang_Comment_castToInlineCommandComment(CXComment C) {
  return llvm::dyn_cast_or_null<clang::comments::InlineCommandComment>(
      static_cast<clang::comments::Comment *>(C));
}

CXHTMLStartTagComment clang_Comment_castToHTMLStartTagComment(CXComment C) {
  return llvm::dyn_cast_or_null<clang::comments::HTMLStartTagComment>(
      static_cast<clang::comments::Comment *>(C));
}

CXHTMLEndTagComment clang_Comment_castToHTMLEndTagComment(CXComment C) {
  return llvm::dyn_cast_or_null<clang::comments::HTMLEndTagComment>(
      static_cast<clang::comments::Comment *>(C));
}

CXTParamCommandComment clang_Comment_castToTParamCommandComment(CXComment C) {
  return llvm::dyn_cast_or_null<clang::comments::TParamCommandComment>(
      static_cast<clang::comments::Comment *>(C));
}

// InlineContentComment
bool clang_InlineContentComment_hasTrailingNewline(CXInlineContentComment ICC) {
  return static_cast<clang::comments::InlineContentComment *>(ICC)->hasTrailingNewline();
}

// TextComment
CXString clang_TextComment_getText(CXTextComment TC) {
  return extra::makeCXString(
      static_cast<clang::comments::TextComment *>(TC)->getText().str());
}

bool clang_TextComment_isWhitespace(CXTextComment TC) {
  return static_cast<clang::comments::TextComment *>(TC)->isWhitespace();
}

// InlineCommandComment
unsigned clang_InlineCommandComment_getCommandID(CXInlineCommandComment ICC) {
  return static_cast<clang::comments::InlineCommandComment *>(ICC)->getCommandID();
}

CXString clang_InlineCommandComment_getCommandName(CXInlineCommandComment ICC,
                                                   CXASTContext Ctx) {
  auto *I = static_cast<clang::comments::InlineCommandComment *>(ICC);
  auto *C = static_cast<clang::ASTContext *>(Ctx);
  return extra::makeCXString(I->getCommandName(C->getCommentCommandTraits()).str());
}

CXSourceRange_ clang_InlineCommandComment_getCommandNameRange(CXInlineCommandComment ICC) {
  auto *I = static_cast<clang::comments::InlineCommandComment *>(ICC);
  auto rng = I->getCommandNameRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXInlineCommandRenderKind
clang_InlineCommandComment_getRenderKind(CXInlineCommandComment ICC) {
  return static_cast<CXInlineCommandRenderKind>(
      static_cast<clang::comments::InlineCommandComment *>(ICC)->getRenderKind());
}

unsigned clang_InlineCommandComment_getNumArgs(CXInlineCommandComment ICC) {
  return static_cast<clang::comments::InlineCommandComment *>(ICC)->getNumArgs();
}

CXString clang_InlineCommandComment_getArgText(CXInlineCommandComment ICC, unsigned Idx) {
  auto *I = static_cast<clang::comments::InlineCommandComment *>(ICC);
  return extra::makeCXString(I->getArgText(Idx).str());
}

CXSourceRange_ clang_InlineCommandComment_getArgRange(CXInlineCommandComment ICC,
                                                      unsigned Idx) {
  auto *I = static_cast<clang::comments::InlineCommandComment *>(ICC);
  auto rng = I->getArgRange(Idx);
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

// HTMLTagComment
CXString clang_HTMLTagComment_getTagName(CXHTMLTagComment HTC) {
  auto *H = static_cast<clang::comments::HTMLTagComment *>(HTC);
  return extra::makeCXString(H->getTagName().str());
}

CXSourceRange_ clang_HTMLTagComment_getTagNameSourceRange(CXHTMLTagComment HTC) {
  auto *H = static_cast<clang::comments::HTMLTagComment *>(HTC);
  auto rng = H->getTagNameSourceRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

bool clang_HTMLTagComment_isMalformed(CXHTMLTagComment HTC) {
  return static_cast<clang::comments::HTMLTagComment *>(HTC)->isMalformed();
}

// HTMLStartTagComment
unsigned clang_HTMLStartTagComment_getNumAttrs(CXHTMLStartTagComment HSTC) {
  return static_cast<clang::comments::HTMLStartTagComment *>(HSTC)->getNumAttrs();
}

CXString clang_HTMLStartTagComment_getAttrName(CXHTMLStartTagComment HSTC, unsigned Idx) {
  auto *H = static_cast<clang::comments::HTMLStartTagComment *>(HSTC);
  return extra::makeCXString(H->getAttr(Idx).Name.str());
}

CXString clang_HTMLStartTagComment_getAttrValue(CXHTMLStartTagComment HSTC, unsigned Idx) {
  auto *H = static_cast<clang::comments::HTMLStartTagComment *>(HSTC);
  return extra::makeCXString(H->getAttr(Idx).Value.str());
}

bool clang_HTMLStartTagComment_isSelfClosing(CXHTMLStartTagComment HSTC) {
  return static_cast<clang::comments::HTMLStartTagComment *>(HSTC)->isSelfClosing();
}

// ParagraphComment
bool clang_ParagraphComment_isWhitespace(CXParagraphComment PC) {
  return static_cast<clang::comments::ParagraphComment *>(PC)->isWhitespace();
}

// BlockCommandComment
unsigned clang_BlockCommandComment_getCommandID(CXBlockCommandComment BCC) {
  return static_cast<clang::comments::BlockCommandComment *>(BCC)->getCommandID();
}
CXString clang_BlockCommandComment_getCommandName(CXBlockCommandComment BCC,
                                                  CXASTContext Ctx) {
  auto *B = static_cast<clang::comments::BlockCommandComment *>(BCC);
  auto *C = static_cast<clang::ASTContext *>(Ctx);
  return extra::makeCXString(B->getCommandName(C->getCommentCommandTraits()).str());
}

CXSourceLocation_
clang_BlockCommandComment_getCommandNameBeginLoc(CXBlockCommandComment BCC) {
  return static_cast<clang::comments::BlockCommandComment *>(BCC)
      ->getCommandNameBeginLoc()
      .getPtrEncoding();
}

unsigned clang_BlockCommandComment_getNumArgs(CXBlockCommandComment BCC) {
  return static_cast<clang::comments::BlockCommandComment *>(BCC)->getNumArgs();
}

CXString clang_BlockCommandComment_getArgText(CXBlockCommandComment BCC, unsigned Idx) {
  return extra::makeCXString(
      static_cast<clang::comments::BlockCommandComment *>(BCC)->getArgText(Idx).str());
}

CXSourceRange_ clang_BlockCommandComment_getArgRange(CXBlockCommandComment BCC,
                                                     unsigned Idx) {
  auto rng = static_cast<clang::comments::BlockCommandComment *>(BCC)->getArgRange(Idx);
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXParagraphComment clang_BlockCommandComment_getParagraph(CXBlockCommandComment BCC) {
  return static_cast<clang::comments::BlockCommandComment *>(BCC)->getParagraph();
}

bool clang_BlockCommandComment_hasNonWhitespaceParagraph(CXBlockCommandComment BCC) {
  return static_cast<clang::comments::BlockCommandComment *>(BCC)
      ->hasNonWhitespaceParagraph();
}

CXCommandMarkerKind clang_BlockCommandComment_getCommandMarker(CXBlockCommandComment BCC) {
  return static_cast<CXCommandMarkerKind>(
      static_cast<clang::comments::BlockCommandComment *>(BCC)->getCommandMarker());
}

// ParamCommandComment
CXParamCommandPassDirection
clang_ParamCommandComment_getDirection(CXParamCommandComment PCC) {
  return static_cast<CXParamCommandPassDirection>(
      static_cast<clang::comments::ParamCommandComment *>(PCC)->getDirection());
}

bool clang_ParamCommandComment_isDirectionExplicit(CXParamCommandComment PCC) {
  return static_cast<clang::comments::ParamCommandComment *>(PCC)->isDirectionExplicit();
}
bool clang_ParamCommandComment_hasParamName(CXParamCommandComment PCC) {
  return static_cast<clang::comments::ParamCommandComment *>(PCC)->hasParamName();
}

CXString clang_ParamCommandComment_getParamNameAsWritten(CXParamCommandComment PCC) {
  auto *P = static_cast<clang::comments::ParamCommandComment *>(PCC);
  return extra::makeCXString(P->getParamNameAsWritten().str());
}

CXSourceRange_ clang_ParamCommandComment_getParamNameRange(CXParamCommandComment PCC) {
  auto rng = static_cast<clang::comments::ParamCommandComment *>(PCC)->getParamNameRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

bool clang_ParamCommandComment_isParamIndexValid(CXParamCommandComment PCC) {
  return static_cast<clang::comments::ParamCommandComment *>(PCC)->isParamIndexValid();
}

bool clang_ParamCommandComment_isVarArgParam(CXParamCommandComment PCC) {
  return static_cast<clang::comments::ParamCommandComment *>(PCC)->isVarArgParam();
}

unsigned clang_ParamCommandComment_getParamIndex(CXParamCommandComment PCC) {
  return static_cast<clang::comments::ParamCommandComment *>(PCC)->getParamIndex();
}

// TParamCommandComment
bool clang_TParamCommandComment_hasParamName(CXTParamCommandComment TPCC) {
  return static_cast<clang::comments::TParamCommandComment *>(TPCC)->hasParamName();
}

CXString clang_TParamCommandComment_getParamNameAsWritten(CXTParamCommandComment TPCC) {
  auto *T = static_cast<clang::comments::TParamCommandComment *>(TPCC);
  return extra::makeCXString(T->getParamNameAsWritten().str());
}

CXSourceRange_ clang_TParamCommandComment_getParamNameRange(CXTParamCommandComment TPCC) {
  auto *T = static_cast<clang::comments::TParamCommandComment *>(TPCC);
  auto rng = T->getParamNameRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

bool clang_TParamCommandComment_isPositionValid(CXTParamCommandComment TPCC) {
  return static_cast<clang::comments::TParamCommandComment *>(TPCC)->isPositionValid();
}

unsigned clang_TParamCommandComment_getDepth(CXTParamCommandComment TPCC) {
  return static_cast<clang::comments::TParamCommandComment *>(TPCC)->getDepth();
}

unsigned clang_TParamCommandComment_getIndex(CXTParamCommandComment TPCC, unsigned Depth) {
  return static_cast<clang::comments::TParamCommandComment *>(TPCC)->getIndex(Depth);
}

// FullComment
CXDecl clang_FullComment_getDecl(CXFullComment FC) {
  auto *F = static_cast<clang::comments::FullComment *>(FC);
  return const_cast<clang::Decl *>(F->getDecl());
}
