#include "clang-ex/AST/CXComment.h"

#include "utils.h"

#include "clang/AST/ASTContext.h"
#include "clang/AST/Comment.h"
#include "clang/AST/CommentCommandTraits.h"
#include "clang/AST/RawCommentList.h"
#include "clang/Basic/SourceManager.h"

#include <cstring>
#include <new>

// RawComment
CXRawCommentKind clang_RawComment_getKind(CXRawComment RC) {
  return static_cast<CXRawCommentKind>(
      reinterpret_cast<clang::RawComment *>(RC)->getKind());
}

bool clang_RawComment_isAttached(CXRawComment RC) {
  return reinterpret_cast<clang::RawComment *>(RC)->isAttached();
}

bool clang_RawComment_isTrailingComment(CXRawComment RC) {
  return reinterpret_cast<clang::RawComment *>(RC)->isTrailingComment();
}

bool clang_RawComment_isDocumentation(CXRawComment RC) {
  return reinterpret_cast<clang::RawComment *>(RC)->isDocumentation();
}

CXString clang_RawComment_getRawText(CXRawComment RC, CXSourceManager SM) {
  auto *C = reinterpret_cast<clang::RawComment *>(RC);
  return extra::makeCXString(
      C->getRawText(*reinterpret_cast<clang::SourceManager *>(SM)).str());
}

CXSourceRange_ clang_RawComment_getSourceRange(CXRawComment RC) {
  auto rng = reinterpret_cast<clang::RawComment *>(RC)->getSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

const char *clang_RawComment_getBriefText(CXRawComment RC, CXASTContext Ctx) {
  return reinterpret_cast<clang::RawComment *>(RC)->getBriefText(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

// Comment
const char *clang_Comment_getCommentKindName(CXComment C) {
  return reinterpret_cast<clang::comments::Comment *>(C)->getCommentKindName();
}

CXCommentKind_ clang_Comment_getCommentKind(CXComment C) {
  return static_cast<CXCommentKind_>(
      reinterpret_cast<clang::comments::Comment *>(C)->getCommentKind());
}

void clang_Comment_dump(CXComment C) { reinterpret_cast<clang::comments::Comment *>(C)->dump(); }

void clang_Comment_dumpColor(CXComment C) {
  reinterpret_cast<clang::comments::Comment *>(C)->dumpColor();
}

CXSourceRange_ clang_Comment_getSourceRange(CXComment C) {
  auto rng = reinterpret_cast<clang::comments::Comment *>(C)->getSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

CXSourceLocation_ clang_Comment_getBeginLoc(CXComment C) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::comments::Comment *>(C)->getBeginLoc().getPtrEncoding());
}

CXSourceLocation_ clang_Comment_getEndLoc(CXComment C) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::comments::Comment *>(C)->getEndLoc().getPtrEncoding());
}

CXSourceLocation_ clang_Comment_getLocation(CXComment C) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::comments::Comment *>(C)->getLocation().getPtrEncoding());
}

unsigned clang_Comment_child_count(CXComment C) {
  return reinterpret_cast<clang::comments::Comment *>(C)->child_count();
}

CXComment clang_Comment_getChild(CXComment C, unsigned i) {
  return reinterpret_cast<CXComment>(*(reinterpret_cast<clang::comments::Comment *>(C)->child_begin() + i));
}

// Comment Cast
CXTextComment clang_Comment_castToTextComment(CXComment C) {
  return reinterpret_cast<CXTextComment>(llvm::dyn_cast_or_null<clang::comments::TextComment>(
      reinterpret_cast<clang::comments::Comment *>(C)));
}

CXBlockCommandComment clang_Comment_castToBlockCommandComment(CXComment C) {
  return reinterpret_cast<CXBlockCommandComment>(llvm::dyn_cast_or_null<clang::comments::BlockCommandComment>(
      reinterpret_cast<clang::comments::Comment *>(C)));
}

CXParamCommandComment clang_Comment_castToParamCommandComment(CXComment C) {
  return reinterpret_cast<CXParamCommandComment>(llvm::dyn_cast_or_null<clang::comments::ParamCommandComment>(
      reinterpret_cast<clang::comments::Comment *>(C)));
}

CXInlineCommandComment clang_Comment_castToInlineCommandComment(CXComment C) {
  return reinterpret_cast<CXInlineCommandComment>(llvm::dyn_cast_or_null<clang::comments::InlineCommandComment>(
      reinterpret_cast<clang::comments::Comment *>(C)));
}

CXHTMLStartTagComment clang_Comment_castToHTMLStartTagComment(CXComment C) {
  return reinterpret_cast<CXHTMLStartTagComment>(llvm::dyn_cast_or_null<clang::comments::HTMLStartTagComment>(
      reinterpret_cast<clang::comments::Comment *>(C)));
}

CXHTMLEndTagComment clang_Comment_castToHTMLEndTagComment(CXComment C) {
  return reinterpret_cast<CXHTMLEndTagComment>(llvm::dyn_cast_or_null<clang::comments::HTMLEndTagComment>(
      reinterpret_cast<clang::comments::Comment *>(C)));
}

CXTParamCommandComment clang_Comment_castToTParamCommandComment(CXComment C) {
  return reinterpret_cast<CXTParamCommandComment>(llvm::dyn_cast_or_null<clang::comments::TParamCommandComment>(
      reinterpret_cast<clang::comments::Comment *>(C)));
}

CXVerbatimBlockLineComment clang_Comment_castToVerbatimBlockLineComment(CXComment C) {
  return reinterpret_cast<CXVerbatimBlockLineComment>(llvm::dyn_cast_or_null<clang::comments::VerbatimBlockLineComment>(
      reinterpret_cast<clang::comments::Comment *>(C)));
}

CXVerbatimBlockComment clang_Comment_castToVerbatimBlockComment(CXComment C) {
  return reinterpret_cast<CXVerbatimBlockComment>(llvm::dyn_cast_or_null<clang::comments::VerbatimBlockComment>(
      reinterpret_cast<clang::comments::Comment *>(C)));
}

CXVerbatimLineComment clang_Comment_castToVerbatimLineComment(CXComment C) {
  return reinterpret_cast<CXVerbatimLineComment>(llvm::dyn_cast_or_null<clang::comments::VerbatimLineComment>(
      reinterpret_cast<clang::comments::Comment *>(C)));
}

CXParagraphComment clang_Comment_castToParagraphComment(CXComment C) {
  return reinterpret_cast<CXParagraphComment>(llvm::dyn_cast_or_null<clang::comments::ParagraphComment>(
      reinterpret_cast<clang::comments::Comment *>(C)));
}

CXFullComment clang_Comment_castToFullComment(CXComment C) {
  return reinterpret_cast<CXFullComment>(llvm::dyn_cast_or_null<clang::comments::FullComment>(
      reinterpret_cast<clang::comments::Comment *>(C)));
}

// Comment Predicates
bool clang_Comment_isInlineContentComment(CXComment C) {
  return llvm::isa_and_nonnull<clang::comments::InlineContentComment>(
      reinterpret_cast<clang::comments::Comment *>(C));
}

bool clang_Comment_isBlockContentComment(CXComment C) {
  return llvm::isa_and_nonnull<clang::comments::BlockContentComment>(
      reinterpret_cast<clang::comments::Comment *>(C));
}

bool clang_Comment_isHTMLTagComment(CXComment C) {
  return llvm::isa_and_nonnull<clang::comments::HTMLTagComment>(
      reinterpret_cast<clang::comments::Comment *>(C));
}

// InlineContentComment
bool clang_InlineContentComment_hasTrailingNewline(CXInlineContentComment ICC) {
  return reinterpret_cast<clang::comments::InlineContentComment *>(ICC)->hasTrailingNewline();
}

void clang_InlineContentComment_addTrailingNewline(CXInlineContentComment ICC) {
  reinterpret_cast<clang::comments::InlineContentComment *>(ICC)->addTrailingNewline();
}

// TextComment
CXString clang_TextComment_getText(CXTextComment TC) {
  return extra::makeCXString(
      reinterpret_cast<clang::comments::TextComment *>(TC)->getText().str());
}

bool clang_TextComment_isWhitespace(CXTextComment TC) {
  return reinterpret_cast<clang::comments::TextComment *>(TC)->isWhitespace();
}

// InlineCommandComment
unsigned clang_InlineCommandComment_getCommandID(CXInlineCommandComment ICC) {
  return reinterpret_cast<clang::comments::InlineCommandComment *>(ICC)->getCommandID();
}

CXString clang_InlineCommandComment_getCommandName(CXInlineCommandComment ICC,
                                                   CXASTContext Ctx) {
  auto *I = reinterpret_cast<clang::comments::InlineCommandComment *>(ICC);
  auto *C = reinterpret_cast<clang::ASTContext *>(Ctx);
  return extra::makeCXString(I->getCommandName(C->getCommentCommandTraits()).str());
}

CXSourceRange_ clang_InlineCommandComment_getCommandNameRange(CXInlineCommandComment ICC) {
  auto *I = reinterpret_cast<clang::comments::InlineCommandComment *>(ICC);
  auto rng = I->getCommandNameRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

CXInlineCommandRenderKind
clang_InlineCommandComment_getRenderKind(CXInlineCommandComment ICC) {
  return static_cast<CXInlineCommandRenderKind>(
      reinterpret_cast<clang::comments::InlineCommandComment *>(ICC)->getRenderKind());
}

unsigned clang_InlineCommandComment_getNumArgs(CXInlineCommandComment ICC) {
  return reinterpret_cast<clang::comments::InlineCommandComment *>(ICC)->getNumArgs();
}

CXString clang_InlineCommandComment_getArgText(CXInlineCommandComment ICC, unsigned Idx) {
  auto *I = reinterpret_cast<clang::comments::InlineCommandComment *>(ICC);
  return extra::makeCXString(I->getArgText(Idx).str());
}

CXSourceRange_ clang_InlineCommandComment_getArgRange(CXInlineCommandComment ICC,
                                                      unsigned Idx) {
  auto *I = reinterpret_cast<clang::comments::InlineCommandComment *>(ICC);
  auto rng = I->getArgRange(Idx);
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

// HTMLTagComment
CXString clang_HTMLTagComment_getTagName(CXHTMLTagComment HTC) {
  auto *H = reinterpret_cast<clang::comments::HTMLTagComment *>(HTC);
  return extra::makeCXString(H->getTagName().str());
}

CXSourceRange_ clang_HTMLTagComment_getTagNameSourceRange(CXHTMLTagComment HTC) {
  auto *H = reinterpret_cast<clang::comments::HTMLTagComment *>(HTC);
  auto rng = H->getTagNameSourceRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

bool clang_HTMLTagComment_isMalformed(CXHTMLTagComment HTC) {
  return reinterpret_cast<clang::comments::HTMLTagComment *>(HTC)->isMalformed();
}

void clang_HTMLTagComment_setIsMalformed(CXHTMLTagComment HTC) {
  reinterpret_cast<clang::comments::HTMLTagComment *>(HTC)->setIsMalformed();
}

// HTMLStartTagComment
unsigned clang_HTMLStartTagComment_getNumAttrs(CXHTMLStartTagComment HSTC) {
  return reinterpret_cast<clang::comments::HTMLStartTagComment *>(HSTC)->getNumAttrs();
}

CXString clang_HTMLStartTagComment_getAttrName(CXHTMLStartTagComment HSTC, unsigned Idx) {
  auto *H = reinterpret_cast<clang::comments::HTMLStartTagComment *>(HSTC);
  return extra::makeCXString(H->getAttr(Idx).Name.str());
}

CXString clang_HTMLStartTagComment_getAttrValue(CXHTMLStartTagComment HSTC, unsigned Idx) {
  auto *H = reinterpret_cast<clang::comments::HTMLStartTagComment *>(HSTC);
  return extra::makeCXString(H->getAttr(Idx).Value.str());
}

CXSourceRange_ clang_HTMLStartTagComment_getAttrNameRange(CXHTMLStartTagComment HSTC,
                                                          unsigned Idx) {
  auto *H = reinterpret_cast<clang::comments::HTMLStartTagComment *>(HSTC);
  auto rng = H->getAttr(Idx).getNameRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

CXSourceLocation_ clang_HTMLStartTagComment_getAttrNameLocEnd(CXHTMLStartTagComment HSTC,
                                                              unsigned Idx) {
  auto *H = reinterpret_cast<clang::comments::HTMLStartTagComment *>(HSTC);
  return reinterpret_cast<CXSourceLocation_>(H->getAttr(Idx).getNameLocEnd().getPtrEncoding());
}

CXSourceLocation_ clang_HTMLStartTagComment_getAttrEqualsLoc(CXHTMLStartTagComment HSTC,
                                                             unsigned Idx) {
  auto *H = reinterpret_cast<clang::comments::HTMLStartTagComment *>(HSTC);
  return reinterpret_cast<CXSourceLocation_>(H->getAttr(Idx).EqualsLoc.getPtrEncoding());
}

CXSourceRange_ clang_HTMLStartTagComment_getAttrValueRange(CXHTMLStartTagComment HSTC,
                                                           unsigned Idx) {
  auto *H = reinterpret_cast<clang::comments::HTMLStartTagComment *>(HSTC);
  auto rng = H->getAttr(Idx).ValueRange;
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

void clang_HTMLStartTagComment_setAttrs(CXHTMLStartTagComment HSTC, CXASTContext Ctx,
                                        const CXSourceLocation_ *NameLocBegins,
                                        const char **Names,
                                        const CXSourceLocation_ *EqualsLocs,
                                        const CXSourceRange_ *ValueRanges,
                                        const char **Values, unsigned N) {
  using Attribute = clang::comments::HTMLStartTagComment::Attribute;
  auto *C = reinterpret_cast<clang::ASTContext *>(Ctx);
  auto *Buf = C->Allocate<Attribute>(N);
  for (unsigned I = 0; I != N; ++I) {
    llvm::StringRef Name(Names[I]);
    char *NameBuf = C->Allocate<char>(Name.size());
    std::memcpy(NameBuf, Name.data(), Name.size());
    llvm::StringRef Value(Values[I]);
    char *ValueBuf = C->Allocate<char>(Value.size());
    std::memcpy(ValueBuf, Value.data(), Value.size());
    clang::SourceRange VR(clang::SourceLocation::getFromPtrEncoding(ValueRanges[I].B),
                          clang::SourceLocation::getFromPtrEncoding(ValueRanges[I].E));
    new (&Buf[I]) Attribute(clang::SourceLocation::getFromPtrEncoding(NameLocBegins[I]),
                            llvm::StringRef(NameBuf, Name.size()),
                            clang::SourceLocation::getFromPtrEncoding(EqualsLocs[I]), VR,
                            llvm::StringRef(ValueBuf, Value.size()));
  }
  reinterpret_cast<clang::comments::HTMLStartTagComment *>(HSTC)->setAttrs(
      llvm::ArrayRef<Attribute>(Buf, N));
}

void clang_HTMLStartTagComment_setGreaterLoc(CXHTMLStartTagComment HSTC,
                                             CXSourceLocation_ GreaterLoc) {
  reinterpret_cast<clang::comments::HTMLStartTagComment *>(HSTC)->setGreaterLoc(
      clang::SourceLocation::getFromPtrEncoding(GreaterLoc));
}

bool clang_HTMLStartTagComment_isSelfClosing(CXHTMLStartTagComment HSTC) {
  return reinterpret_cast<clang::comments::HTMLStartTagComment *>(HSTC)->isSelfClosing();
}

void clang_HTMLStartTagComment_setSelfClosing(CXHTMLStartTagComment HSTC) {
  reinterpret_cast<clang::comments::HTMLStartTagComment *>(HSTC)->setSelfClosing();
}

// ParagraphComment
bool clang_ParagraphComment_isWhitespace(CXParagraphComment PC) {
  return reinterpret_cast<clang::comments::ParagraphComment *>(PC)->isWhitespace();
}

// BlockCommandComment
unsigned clang_BlockCommandComment_getCommandID(CXBlockCommandComment BCC) {
  return reinterpret_cast<clang::comments::BlockCommandComment *>(BCC)->getCommandID();
}
CXString clang_BlockCommandComment_getCommandName(CXBlockCommandComment BCC,
                                                  CXASTContext Ctx) {
  auto *B = reinterpret_cast<clang::comments::BlockCommandComment *>(BCC);
  auto *C = reinterpret_cast<clang::ASTContext *>(Ctx);
  return extra::makeCXString(B->getCommandName(C->getCommentCommandTraits()).str());
}

CXSourceLocation_
clang_BlockCommandComment_getCommandNameBeginLoc(CXBlockCommandComment BCC) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::comments::BlockCommandComment *>(BCC)
      ->getCommandNameBeginLoc()
      .getPtrEncoding());
}

CXSourceRange_ clang_BlockCommandComment_getCommandNameRange(CXBlockCommandComment BCC,
                                                             CXASTContext Ctx) {
  auto *B = reinterpret_cast<clang::comments::BlockCommandComment *>(BCC);
  auto *C = reinterpret_cast<clang::ASTContext *>(Ctx);
  auto rng = B->getCommandNameRange(C->getCommentCommandTraits());
  CXSourceLocation_ Begin = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ End = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{Begin, End};
}

unsigned clang_BlockCommandComment_getNumArgs(CXBlockCommandComment BCC) {
  return reinterpret_cast<clang::comments::BlockCommandComment *>(BCC)->getNumArgs();
}

CXString clang_BlockCommandComment_getArgText(CXBlockCommandComment BCC, unsigned Idx) {
  return extra::makeCXString(
      reinterpret_cast<clang::comments::BlockCommandComment *>(BCC)->getArgText(Idx).str());
}

CXSourceRange_ clang_BlockCommandComment_getArgRange(CXBlockCommandComment BCC,
                                                     unsigned Idx) {
  auto rng = reinterpret_cast<clang::comments::BlockCommandComment *>(BCC)->getArgRange(Idx);
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

void clang_BlockCommandComment_setArgs(CXBlockCommandComment BCC, CXASTContext Ctx,
                                       const char **Texts, const CXSourceRange_ *Ranges,
                                       unsigned N) {
  using Argument = clang::comments::Comment::Argument;
  auto *C = reinterpret_cast<clang::ASTContext *>(Ctx);
  auto *Buf = C->Allocate<Argument>(N);
  for (unsigned I = 0; I != N; ++I) {
    llvm::StringRef Text(Texts[I]);
    char *TextBuf = C->Allocate<char>(Text.size());
    std::memcpy(TextBuf, Text.data(), Text.size());
    clang::SourceRange R(clang::SourceLocation::getFromPtrEncoding(Ranges[I].B),
                         clang::SourceLocation::getFromPtrEncoding(Ranges[I].E));
    new (&Buf[I]) Argument{R, llvm::StringRef(TextBuf, Text.size())};
  }
  reinterpret_cast<clang::comments::BlockCommandComment *>(BCC)->setArgs(
      llvm::ArrayRef<Argument>(Buf, N));
}

CXParagraphComment clang_BlockCommandComment_getParagraph(CXBlockCommandComment BCC) {
  return reinterpret_cast<CXParagraphComment>(reinterpret_cast<clang::comments::BlockCommandComment *>(BCC)->getParagraph());
}

bool clang_BlockCommandComment_hasNonWhitespaceParagraph(CXBlockCommandComment BCC) {
  return reinterpret_cast<clang::comments::BlockCommandComment *>(BCC)
      ->hasNonWhitespaceParagraph();
}

void clang_BlockCommandComment_setParagraph(CXBlockCommandComment BCC,
                                            CXParagraphComment PC) {
  reinterpret_cast<clang::comments::BlockCommandComment *>(BCC)->setParagraph(
      reinterpret_cast<clang::comments::ParagraphComment *>(PC));
}

CXCommandMarkerKind clang_BlockCommandComment_getCommandMarker(CXBlockCommandComment BCC) {
  return static_cast<CXCommandMarkerKind>(
      reinterpret_cast<clang::comments::BlockCommandComment *>(BCC)->getCommandMarker());
}

// ParamCommandComment
CXParamCommandPassDirection
clang_ParamCommandComment_getDirection(CXParamCommandComment PCC) {
  return static_cast<CXParamCommandPassDirection>(
      reinterpret_cast<clang::comments::ParamCommandComment *>(PCC)->getDirection());
}

bool clang_ParamCommandComment_isDirectionExplicit(CXParamCommandComment PCC) {
  return reinterpret_cast<clang::comments::ParamCommandComment *>(PCC)->isDirectionExplicit();
}

void clang_ParamCommandComment_setDirection(CXParamCommandComment PCC,
                                            CXParamCommandPassDirection Direction,
                                            bool Explicit) {
  reinterpret_cast<clang::comments::ParamCommandComment *>(PCC)->setDirection(
      static_cast<clang::comments::ParamCommandPassDirection>(Direction), Explicit);
}

const char *clang_ParamCommandComment_getDirectionAsString(CXParamCommandPassDirection D) {
  return clang::comments::ParamCommandComment::getDirectionAsString(
      static_cast<clang::comments::ParamCommandPassDirection>(D));
}
bool clang_ParamCommandComment_hasParamName(CXParamCommandComment PCC) {
  return reinterpret_cast<clang::comments::ParamCommandComment *>(PCC)->hasParamName();
}

CXString clang_ParamCommandComment_getParamName(CXParamCommandComment PCC,
                                                CXFullComment FC) {
  auto *P = reinterpret_cast<clang::comments::ParamCommandComment *>(PCC);
  auto *F = reinterpret_cast<clang::comments::FullComment *>(FC);
  return extra::makeCXString(P->getParamName(F).str());
}

CXString clang_ParamCommandComment_getParamNameAsWritten(CXParamCommandComment PCC) {
  auto *P = reinterpret_cast<clang::comments::ParamCommandComment *>(PCC);
  return extra::makeCXString(P->getParamNameAsWritten().str());
}

CXSourceRange_ clang_ParamCommandComment_getParamNameRange(CXParamCommandComment PCC) {
  auto rng = reinterpret_cast<clang::comments::ParamCommandComment *>(PCC)->getParamNameRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

bool clang_ParamCommandComment_isParamIndexValid(CXParamCommandComment PCC) {
  return reinterpret_cast<clang::comments::ParamCommandComment *>(PCC)->isParamIndexValid();
}

bool clang_ParamCommandComment_isVarArgParam(CXParamCommandComment PCC) {
  return reinterpret_cast<clang::comments::ParamCommandComment *>(PCC)->isVarArgParam();
}

void clang_ParamCommandComment_setIsVarArgParam(CXParamCommandComment PCC) {
  reinterpret_cast<clang::comments::ParamCommandComment *>(PCC)->setIsVarArgParam();
}

unsigned clang_ParamCommandComment_getParamIndex(CXParamCommandComment PCC) {
  return reinterpret_cast<clang::comments::ParamCommandComment *>(PCC)->getParamIndex();
}

void clang_ParamCommandComment_setParamIndex(CXParamCommandComment PCC, unsigned Index) {
  reinterpret_cast<clang::comments::ParamCommandComment *>(PCC)->setParamIndex(Index);
}

// TParamCommandComment
bool clang_TParamCommandComment_hasParamName(CXTParamCommandComment TPCC) {
  return reinterpret_cast<clang::comments::TParamCommandComment *>(TPCC)->hasParamName();
}

CXString clang_TParamCommandComment_getParamName(CXTParamCommandComment TPCC,
                                                 CXFullComment FC) {
  auto *T = reinterpret_cast<clang::comments::TParamCommandComment *>(TPCC);
  auto *F = reinterpret_cast<clang::comments::FullComment *>(FC);
  return extra::makeCXString(T->getParamName(F).str());
}

CXString clang_TParamCommandComment_getParamNameAsWritten(CXTParamCommandComment TPCC) {
  auto *T = reinterpret_cast<clang::comments::TParamCommandComment *>(TPCC);
  return extra::makeCXString(T->getParamNameAsWritten().str());
}

CXSourceRange_ clang_TParamCommandComment_getParamNameRange(CXTParamCommandComment TPCC) {
  auto *T = reinterpret_cast<clang::comments::TParamCommandComment *>(TPCC);
  auto rng = T->getParamNameRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

bool clang_TParamCommandComment_isPositionValid(CXTParamCommandComment TPCC) {
  return reinterpret_cast<clang::comments::TParamCommandComment *>(TPCC)->isPositionValid();
}

unsigned clang_TParamCommandComment_getDepth(CXTParamCommandComment TPCC) {
  return reinterpret_cast<clang::comments::TParamCommandComment *>(TPCC)->getDepth();
}

unsigned clang_TParamCommandComment_getIndex(CXTParamCommandComment TPCC, unsigned Depth) {
  return reinterpret_cast<clang::comments::TParamCommandComment *>(TPCC)->getIndex(Depth);
}

void clang_TParamCommandComment_setPosition(CXTParamCommandComment TPCC, CXASTContext Ctx,
                                            const unsigned *Position, unsigned N) {
  auto *C = reinterpret_cast<clang::ASTContext *>(Ctx);
  unsigned *Buf = C->Allocate<unsigned>(N);
  for (unsigned I = 0; I != N; ++I)
    Buf[I] = Position[I];
  reinterpret_cast<clang::comments::TParamCommandComment *>(TPCC)->setPosition(
      llvm::ArrayRef<unsigned>(Buf, N));
}

// VerbatimBlockLineComment
CXString clang_VerbatimBlockLineComment_getText(CXVerbatimBlockLineComment VBLC) {
  auto *V = reinterpret_cast<clang::comments::VerbatimBlockLineComment *>(VBLC);
  return extra::makeCXString(V->getText().str());
}

// VerbatimBlockComment
void clang_VerbatimBlockComment_setCloseName(CXVerbatimBlockComment VBC, CXASTContext Ctx,
                                             const char *Name, CXSourceLocation_ LocBegin) {
  auto *C = reinterpret_cast<clang::ASTContext *>(Ctx);
  llvm::StringRef S(Name);
  char *Buf = C->Allocate<char>(S.size());
  std::memcpy(Buf, S.data(), S.size());
  reinterpret_cast<clang::comments::VerbatimBlockComment *>(VBC)->setCloseName(
      llvm::StringRef(Buf, S.size()), clang::SourceLocation::getFromPtrEncoding(LocBegin));
}

void clang_VerbatimBlockComment_setLines(CXVerbatimBlockComment VBC, CXASTContext Ctx,
                                         const CXVerbatimBlockLineComment *Lines,
                                         unsigned N) {
  auto *C = reinterpret_cast<clang::ASTContext *>(Ctx);
  auto **Buf = C->Allocate<clang::comments::VerbatimBlockLineComment *>(N);
  for (unsigned I = 0; I != N; ++I)
    Buf[I] = reinterpret_cast<clang::comments::VerbatimBlockLineComment *>(Lines[I]);
  reinterpret_cast<clang::comments::VerbatimBlockComment *>(VBC)->setLines(
      llvm::ArrayRef<clang::comments::VerbatimBlockLineComment *>(Buf, N));
}
CXString clang_VerbatimBlockComment_getCloseName(CXVerbatimBlockComment VBC) {
  auto *V = reinterpret_cast<clang::comments::VerbatimBlockComment *>(VBC);
  return extra::makeCXString(V->getCloseName().str());
}

unsigned clang_VerbatimBlockComment_getNumLines(CXVerbatimBlockComment VBC) {
  return reinterpret_cast<clang::comments::VerbatimBlockComment *>(VBC)->getNumLines();
}

CXString clang_VerbatimBlockComment_getText(CXVerbatimBlockComment VBC, unsigned LineIdx) {
  auto *V = reinterpret_cast<clang::comments::VerbatimBlockComment *>(VBC);
  return extra::makeCXString(V->getText(LineIdx).str());
}

// VerbatimLineComment
CXString clang_VerbatimLineComment_getText(CXVerbatimLineComment VLC) {
  auto *V = reinterpret_cast<clang::comments::VerbatimLineComment *>(VLC);
  return extra::makeCXString(V->getText().str());
}

CXSourceRange_ clang_VerbatimLineComment_getTextRange(CXVerbatimLineComment VLC) {
  auto *V = reinterpret_cast<clang::comments::VerbatimLineComment *>(VLC);
  auto rng = V->getTextRange();
  CXSourceLocation_ B = reinterpret_cast<CXSourceLocation_>(rng.getBegin().getPtrEncoding());
  CXSourceLocation_ E = reinterpret_cast<CXSourceLocation_>(rng.getEnd().getPtrEncoding());
  return CXSourceRange_{B, E};
}

// DeclInfo
CXDeclInfo_DeclKind clang_DeclInfo_getKind(CXDeclInfo DI) {
  return static_cast<CXDeclInfo_DeclKind>(
      reinterpret_cast<clang::comments::DeclInfo *>(DI)->getKind());
}

CXDeclInfo_TemplateDeclKind clang_DeclInfo_getTemplateKind(CXDeclInfo DI) {
  return static_cast<CXDeclInfo_TemplateDeclKind>(
      reinterpret_cast<clang::comments::DeclInfo *>(DI)->getTemplateKind());
}

bool clang_DeclInfo_involvesFunctionType(CXDeclInfo DI) {
  return reinterpret_cast<clang::comments::DeclInfo *>(DI)->involvesFunctionType();
}

// FullComment
CXDecl clang_FullComment_getDecl(CXFullComment FC) {
  auto *F = reinterpret_cast<clang::comments::FullComment *>(FC);
  return reinterpret_cast<CXDecl>(const_cast<clang::Decl *>(F->getDecl()));
}

CXDeclInfo clang_FullComment_getDeclInfo(CXFullComment FC) {
  auto *F = reinterpret_cast<clang::comments::FullComment *>(FC);
  return reinterpret_cast<CXDeclInfo>(const_cast<clang::comments::DeclInfo *>(F->getDeclInfo()));
}

unsigned clang_FullComment_getNumBlocks(CXFullComment FC) {
  auto *F = reinterpret_cast<clang::comments::FullComment *>(FC);
  return static_cast<unsigned>(F->getBlocks().size());
}

CXComment clang_FullComment_getBlock(CXFullComment FC, unsigned Idx) {
  return reinterpret_cast<CXComment>(reinterpret_cast<clang::comments::FullComment *>(FC)->getBlocks()[Idx]);
}

CXString clang_RawComment_getFormattedText(CXRawComment RC, CXSourceManager SM,
                                           CXDiagnosticsEngine Diags) {
  return extra::makeCXString(reinterpret_cast<clang::RawComment *>(RC)->getFormattedText(
      *reinterpret_cast<clang::SourceManager *>(SM),
      *reinterpret_cast<clang::DiagnosticsEngine *>(Diags)));
}

bool clang_RawComment_isAlmostTrailingComment(CXRawComment RC) {
  return reinterpret_cast<clang::RawComment *>(RC)->isAlmostTrailingComment();
}

bool clang_RawCommentList_empty(CXRawCommentList RCL) {
  return reinterpret_cast<clang::RawCommentList *>(RCL)->empty();
}

unsigned clang_RawCommentList_getNumCommentsInFile(CXRawCommentList RCL, CXFileID File) {
  const auto *M = reinterpret_cast<clang::RawCommentList *>(RCL)->getCommentsInFile(
      *reinterpret_cast<clang::FileID *>(File));
  return M ? static_cast<unsigned>(M->size()) : 0;
}

void clang_RawCommentList_getCommentsInFile(CXRawCommentList RCL, CXFileID File,
                                            CXRawComment *Comments) {
  const auto *M = reinterpret_cast<clang::RawCommentList *>(RCL)->getCommentsInFile(
      *reinterpret_cast<clang::FileID *>(File));
  if (!M)
    return;
  unsigned I = 0;
  for (const auto &E : *M)
    Comments[I++] = reinterpret_cast<CXRawComment>(E.second);
}
