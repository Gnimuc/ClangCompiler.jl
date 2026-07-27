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

CXCommentKind_ clang_Comment_getCommentKind(CXComment C) {
  return static_cast<CXCommentKind_>(
      static_cast<clang::comments::Comment *>(C)->getCommentKind());
}

void clang_Comment_dump(CXComment C) { static_cast<clang::comments::Comment *>(C)->dump(); }

void clang_Comment_dumpColor(CXComment C) {
  static_cast<clang::comments::Comment *>(C)->dumpColor();
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

CXVerbatimBlockLineComment clang_Comment_castToVerbatimBlockLineComment(CXComment C) {
  return llvm::dyn_cast_or_null<clang::comments::VerbatimBlockLineComment>(
      static_cast<clang::comments::Comment *>(C));
}

CXVerbatimBlockComment clang_Comment_castToVerbatimBlockComment(CXComment C) {
  return llvm::dyn_cast_or_null<clang::comments::VerbatimBlockComment>(
      static_cast<clang::comments::Comment *>(C));
}

CXVerbatimLineComment clang_Comment_castToVerbatimLineComment(CXComment C) {
  return llvm::dyn_cast_or_null<clang::comments::VerbatimLineComment>(
      static_cast<clang::comments::Comment *>(C));
}

CXParagraphComment clang_Comment_castToParagraphComment(CXComment C) {
  return llvm::dyn_cast_or_null<clang::comments::ParagraphComment>(
      static_cast<clang::comments::Comment *>(C));
}

CXFullComment clang_Comment_castToFullComment(CXComment C) {
  return llvm::dyn_cast_or_null<clang::comments::FullComment>(
      static_cast<clang::comments::Comment *>(C));
}

// Comment Predicates
bool clang_Comment_isInlineContentComment(CXComment C) {
  return llvm::isa_and_nonnull<clang::comments::InlineContentComment>(
      static_cast<clang::comments::Comment *>(C));
}

bool clang_Comment_isBlockContentComment(CXComment C) {
  return llvm::isa_and_nonnull<clang::comments::BlockContentComment>(
      static_cast<clang::comments::Comment *>(C));
}

bool clang_Comment_isHTMLTagComment(CXComment C) {
  return llvm::isa_and_nonnull<clang::comments::HTMLTagComment>(
      static_cast<clang::comments::Comment *>(C));
}

// InlineContentComment
bool clang_InlineContentComment_hasTrailingNewline(CXInlineContentComment ICC) {
  return static_cast<clang::comments::InlineContentComment *>(ICC)->hasTrailingNewline();
}

void clang_InlineContentComment_addTrailingNewline(CXInlineContentComment ICC) {
  static_cast<clang::comments::InlineContentComment *>(ICC)->addTrailingNewline();
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

void clang_HTMLTagComment_setIsMalformed(CXHTMLTagComment HTC) {
  static_cast<clang::comments::HTMLTagComment *>(HTC)->setIsMalformed();
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

CXSourceRange_ clang_HTMLStartTagComment_getAttrNameRange(CXHTMLStartTagComment HSTC,
                                                          unsigned Idx) {
  auto *H = static_cast<clang::comments::HTMLStartTagComment *>(HSTC);
  auto rng = H->getAttr(Idx).getNameRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

CXSourceLocation_ clang_HTMLStartTagComment_getAttrNameLocEnd(CXHTMLStartTagComment HSTC,
                                                              unsigned Idx) {
  auto *H = static_cast<clang::comments::HTMLStartTagComment *>(HSTC);
  return H->getAttr(Idx).getNameLocEnd().getPtrEncoding();
}

CXSourceLocation_ clang_HTMLStartTagComment_getAttrEqualsLoc(CXHTMLStartTagComment HSTC,
                                                             unsigned Idx) {
  auto *H = static_cast<clang::comments::HTMLStartTagComment *>(HSTC);
  return H->getAttr(Idx).EqualsLoc.getPtrEncoding();
}

CXSourceRange_ clang_HTMLStartTagComment_getAttrValueRange(CXHTMLStartTagComment HSTC,
                                                           unsigned Idx) {
  auto *H = static_cast<clang::comments::HTMLStartTagComment *>(HSTC);
  auto rng = H->getAttr(Idx).ValueRange;
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

void clang_HTMLStartTagComment_setAttrs(CXHTMLStartTagComment HSTC, CXASTContext Ctx,
                                        const CXSourceLocation_ *NameLocBegins,
                                        const char **Names,
                                        const CXSourceLocation_ *EqualsLocs,
                                        const CXSourceRange_ *ValueRanges,
                                        const char **Values, unsigned N) {
  using Attribute = clang::comments::HTMLStartTagComment::Attribute;
  auto *C = static_cast<clang::ASTContext *>(Ctx);
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
  static_cast<clang::comments::HTMLStartTagComment *>(HSTC)->setAttrs(
      llvm::ArrayRef<Attribute>(Buf, N));
}

void clang_HTMLStartTagComment_setGreaterLoc(CXHTMLStartTagComment HSTC,
                                             CXSourceLocation_ GreaterLoc) {
  static_cast<clang::comments::HTMLStartTagComment *>(HSTC)->setGreaterLoc(
      clang::SourceLocation::getFromPtrEncoding(GreaterLoc));
}

bool clang_HTMLStartTagComment_isSelfClosing(CXHTMLStartTagComment HSTC) {
  return static_cast<clang::comments::HTMLStartTagComment *>(HSTC)->isSelfClosing();
}

void clang_HTMLStartTagComment_setSelfClosing(CXHTMLStartTagComment HSTC) {
  static_cast<clang::comments::HTMLStartTagComment *>(HSTC)->setSelfClosing();
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

CXSourceRange_ clang_BlockCommandComment_getCommandNameRange(CXBlockCommandComment BCC,
                                                             CXASTContext Ctx) {
  auto *B = static_cast<clang::comments::BlockCommandComment *>(BCC);
  auto *C = static_cast<clang::ASTContext *>(Ctx);
  auto rng = B->getCommandNameRange(C->getCommentCommandTraits());
  CXSourceLocation_ Begin = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ End = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{Begin, End};
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

void clang_BlockCommandComment_setArgs(CXBlockCommandComment BCC, CXASTContext Ctx,
                                       const char **Texts, const CXSourceRange_ *Ranges,
                                       unsigned N) {
  using Argument = clang::comments::Comment::Argument;
  auto *C = static_cast<clang::ASTContext *>(Ctx);
  auto *Buf = C->Allocate<Argument>(N);
  for (unsigned I = 0; I != N; ++I) {
    llvm::StringRef Text(Texts[I]);
    char *TextBuf = C->Allocate<char>(Text.size());
    std::memcpy(TextBuf, Text.data(), Text.size());
    clang::SourceRange R(clang::SourceLocation::getFromPtrEncoding(Ranges[I].B),
                         clang::SourceLocation::getFromPtrEncoding(Ranges[I].E));
    new (&Buf[I]) Argument{R, llvm::StringRef(TextBuf, Text.size())};
  }
  static_cast<clang::comments::BlockCommandComment *>(BCC)->setArgs(
      llvm::ArrayRef<Argument>(Buf, N));
}

CXParagraphComment clang_BlockCommandComment_getParagraph(CXBlockCommandComment BCC) {
  return static_cast<clang::comments::BlockCommandComment *>(BCC)->getParagraph();
}

bool clang_BlockCommandComment_hasNonWhitespaceParagraph(CXBlockCommandComment BCC) {
  return static_cast<clang::comments::BlockCommandComment *>(BCC)
      ->hasNonWhitespaceParagraph();
}

void clang_BlockCommandComment_setParagraph(CXBlockCommandComment BCC,
                                            CXParagraphComment PC) {
  static_cast<clang::comments::BlockCommandComment *>(BCC)->setParagraph(
      static_cast<clang::comments::ParagraphComment *>(PC));
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

void clang_ParamCommandComment_setDirection(CXParamCommandComment PCC,
                                            CXParamCommandPassDirection Direction,
                                            bool Explicit) {
  static_cast<clang::comments::ParamCommandComment *>(PCC)->setDirection(
      static_cast<clang::comments::ParamCommandPassDirection>(Direction), Explicit);
}

const char *clang_ParamCommandComment_getDirectionAsString(CXParamCommandPassDirection D) {
  return clang::comments::ParamCommandComment::getDirectionAsString(
      static_cast<clang::comments::ParamCommandPassDirection>(D));
}
bool clang_ParamCommandComment_hasParamName(CXParamCommandComment PCC) {
  return static_cast<clang::comments::ParamCommandComment *>(PCC)->hasParamName();
}

CXString clang_ParamCommandComment_getParamName(CXParamCommandComment PCC,
                                                CXFullComment FC) {
  auto *P = static_cast<clang::comments::ParamCommandComment *>(PCC);
  auto *F = static_cast<clang::comments::FullComment *>(FC);
  return extra::makeCXString(P->getParamName(F).str());
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

void clang_ParamCommandComment_setIsVarArgParam(CXParamCommandComment PCC) {
  static_cast<clang::comments::ParamCommandComment *>(PCC)->setIsVarArgParam();
}

unsigned clang_ParamCommandComment_getParamIndex(CXParamCommandComment PCC) {
  return static_cast<clang::comments::ParamCommandComment *>(PCC)->getParamIndex();
}

void clang_ParamCommandComment_setParamIndex(CXParamCommandComment PCC, unsigned Index) {
  static_cast<clang::comments::ParamCommandComment *>(PCC)->setParamIndex(Index);
}

// TParamCommandComment
bool clang_TParamCommandComment_hasParamName(CXTParamCommandComment TPCC) {
  return static_cast<clang::comments::TParamCommandComment *>(TPCC)->hasParamName();
}

CXString clang_TParamCommandComment_getParamName(CXTParamCommandComment TPCC,
                                                 CXFullComment FC) {
  auto *T = static_cast<clang::comments::TParamCommandComment *>(TPCC);
  auto *F = static_cast<clang::comments::FullComment *>(FC);
  return extra::makeCXString(T->getParamName(F).str());
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

void clang_TParamCommandComment_setPosition(CXTParamCommandComment TPCC, CXASTContext Ctx,
                                            const unsigned *Position, unsigned N) {
  auto *C = static_cast<clang::ASTContext *>(Ctx);
  unsigned *Buf = C->Allocate<unsigned>(N);
  for (unsigned I = 0; I != N; ++I)
    Buf[I] = Position[I];
  static_cast<clang::comments::TParamCommandComment *>(TPCC)->setPosition(
      llvm::ArrayRef<unsigned>(Buf, N));
}

// VerbatimBlockLineComment
CXString clang_VerbatimBlockLineComment_getText(CXVerbatimBlockLineComment VBLC) {
  auto *V = static_cast<clang::comments::VerbatimBlockLineComment *>(VBLC);
  return extra::makeCXString(V->getText().str());
}

// VerbatimBlockComment
void clang_VerbatimBlockComment_setCloseName(CXVerbatimBlockComment VBC, CXASTContext Ctx,
                                             const char *Name, CXSourceLocation_ LocBegin) {
  auto *C = static_cast<clang::ASTContext *>(Ctx);
  llvm::StringRef S(Name);
  char *Buf = C->Allocate<char>(S.size());
  std::memcpy(Buf, S.data(), S.size());
  static_cast<clang::comments::VerbatimBlockComment *>(VBC)->setCloseName(
      llvm::StringRef(Buf, S.size()), clang::SourceLocation::getFromPtrEncoding(LocBegin));
}

void clang_VerbatimBlockComment_setLines(CXVerbatimBlockComment VBC, CXASTContext Ctx,
                                         const CXVerbatimBlockLineComment *Lines,
                                         unsigned N) {
  auto *C = static_cast<clang::ASTContext *>(Ctx);
  auto **Buf = C->Allocate<clang::comments::VerbatimBlockLineComment *>(N);
  for (unsigned I = 0; I != N; ++I)
    Buf[I] = static_cast<clang::comments::VerbatimBlockLineComment *>(Lines[I]);
  static_cast<clang::comments::VerbatimBlockComment *>(VBC)->setLines(
      llvm::ArrayRef<clang::comments::VerbatimBlockLineComment *>(Buf, N));
}
CXString clang_VerbatimBlockComment_getCloseName(CXVerbatimBlockComment VBC) {
  auto *V = static_cast<clang::comments::VerbatimBlockComment *>(VBC);
  return extra::makeCXString(V->getCloseName().str());
}

unsigned clang_VerbatimBlockComment_getNumLines(CXVerbatimBlockComment VBC) {
  return static_cast<clang::comments::VerbatimBlockComment *>(VBC)->getNumLines();
}

CXString clang_VerbatimBlockComment_getText(CXVerbatimBlockComment VBC, unsigned LineIdx) {
  auto *V = static_cast<clang::comments::VerbatimBlockComment *>(VBC);
  return extra::makeCXString(V->getText(LineIdx).str());
}

// VerbatimLineComment
CXString clang_VerbatimLineComment_getText(CXVerbatimLineComment VLC) {
  auto *V = static_cast<clang::comments::VerbatimLineComment *>(VLC);
  return extra::makeCXString(V->getText().str());
}

CXSourceRange_ clang_VerbatimLineComment_getTextRange(CXVerbatimLineComment VLC) {
  auto *V = static_cast<clang::comments::VerbatimLineComment *>(VLC);
  auto rng = V->getTextRange();
  CXSourceLocation_ B = rng.getBegin().getPtrEncoding();
  CXSourceLocation_ E = rng.getEnd().getPtrEncoding();
  return CXSourceRange_{B, E};
}

// DeclInfo
CXDeclInfo_DeclKind clang_DeclInfo_getKind(CXDeclInfo DI) {
  return static_cast<CXDeclInfo_DeclKind>(
      static_cast<clang::comments::DeclInfo *>(DI)->getKind());
}

CXDeclInfo_TemplateDeclKind clang_DeclInfo_getTemplateKind(CXDeclInfo DI) {
  return static_cast<CXDeclInfo_TemplateDeclKind>(
      static_cast<clang::comments::DeclInfo *>(DI)->getTemplateKind());
}

bool clang_DeclInfo_involvesFunctionType(CXDeclInfo DI) {
  return static_cast<clang::comments::DeclInfo *>(DI)->involvesFunctionType();
}

// FullComment
CXDecl clang_FullComment_getDecl(CXFullComment FC) {
  auto *F = static_cast<clang::comments::FullComment *>(FC);
  return const_cast<clang::Decl *>(F->getDecl());
}

CXDeclInfo clang_FullComment_getDeclInfo(CXFullComment FC) {
  auto *F = static_cast<clang::comments::FullComment *>(FC);
  return const_cast<clang::comments::DeclInfo *>(F->getDeclInfo());
}

unsigned clang_FullComment_getNumBlocks(CXFullComment FC) {
  auto *F = static_cast<clang::comments::FullComment *>(FC);
  return static_cast<unsigned>(F->getBlocks().size());
}

CXComment clang_FullComment_getBlock(CXFullComment FC, unsigned Idx) {
  return static_cast<clang::comments::FullComment *>(FC)->getBlocks()[Idx];
}
