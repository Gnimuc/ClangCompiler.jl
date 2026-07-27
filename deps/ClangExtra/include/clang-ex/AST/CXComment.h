#ifndef LLVM_CLANG_C_EXTRA_CXCOMMENT_H
#define LLVM_CLANG_C_EXTRA_CXCOMMENT_H

#include "clang-ex/CXTypes.h"
#include "clang-c/CXString.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// clang/AST/RawCommentList.h: enum RawComment::CommentKind
typedef enum CXRawCommentKind {
  CXRawCommentKind_RCK_Invalid,
  CXRawCommentKind_RCK_OrdinaryBCPL,
  CXRawCommentKind_RCK_OrdinaryC,
  CXRawCommentKind_RCK_BCPLSlash,
  CXRawCommentKind_RCK_BCPLExcl,
  CXRawCommentKind_RCK_JavaDoc,
  CXRawCommentKind_RCK_Qt,
  CXRawCommentKind_RCK_Merged
} CXRawCommentKind;

// clang/AST/Comment.h: enum clang::comments::CommandMarkerKind
typedef enum CXCommandMarkerKind {
  CXCommandMarkerKind_CMK_Backslash = 0,
  CXCommandMarkerKind_CMK_At = 1
} CXCommandMarkerKind;

// clang/AST/Comment.h: enum class clang::comments::ParamCommandPassDirection
typedef enum CXParamCommandPassDirection {
  CXParamCommandPassDirection_In,
  CXParamCommandPassDirection_Out,
  CXParamCommandPassDirection_InOut
} CXParamCommandPassDirection;

// RawComment
CXRawCommentKind clang_RawComment_getKind(CXRawComment RC);

// isInvalid
// isMerged

bool clang_RawComment_isAttached(CXRawComment RC);

// setAttached

bool clang_RawComment_isTrailingComment(CXRawComment RC);

// isAlmostTrailingComment
// isOrdinary

bool clang_RawComment_isDocumentation(CXRawComment RC);

// The raw text is a slice of the source buffer and is NOT NUL-terminated, so it
// is copied into a CXString rather than borrowed.
// Precondition: SM is the SourceManager the comment's range belongs to.
CXString clang_RawComment_getRawText(CXRawComment RC, CXSourceManager SM);

CXSourceRange_ clang_RawComment_getSourceRange(CXRawComment RC);

// getBeginLoc
// getEndLoc

// The brief text is NUL-terminated and lazily allocated in the ASTContext arena,
// so it is borrowed. Extracting it runs the comment parser.
// Precondition: Ctx is the ASTContext that owns RC.
const char *clang_RawComment_getBriefText(CXRawComment RC, CXASTContext Ctx);

// hasUnsupportedSplice
// getRawTextSlow

// Comment
const char *clang_Comment_getCommentKindName(CXComment C);

// dump
// dumpColor

CXSourceRange_ clang_Comment_getSourceRange(CXComment C);

// getBeginLoc
// getEndLoc
// getLocation
CXSourceLocation_ clang_Comment_getBeginLoc(CXComment C);

CXSourceLocation_ clang_Comment_getEndLoc(CXComment C);

CXSourceLocation_ clang_Comment_getLocation(CXComment C);

unsigned clang_Comment_child_count(CXComment C);

// helper: the child_begin()/child_end() iterator pair exposed as count+index.
// Precondition: i < clang_Comment_child_count(C) — the index is unchecked.
CXComment clang_Comment_getChild(CXComment C, unsigned i);

// Comment Cast
CXTextComment clang_Comment_castToTextComment(CXComment C);

CXBlockCommandComment clang_Comment_castToBlockCommandComment(CXComment C);

CXParamCommandComment clang_Comment_castToParamCommandComment(CXComment C);

CXInlineCommandComment clang_Comment_castToInlineCommandComment(CXComment C);

CXHTMLStartTagComment clang_Comment_castToHTMLStartTagComment(CXComment C);

CXHTMLEndTagComment clang_Comment_castToHTMLEndTagComment(CXComment C);

CXTParamCommandComment clang_Comment_castToTParamCommandComment(CXComment C);

// InlineContentComment
// addTrailingNewline

bool clang_InlineContentComment_hasTrailingNewline(CXInlineContentComment ICC);

// TextComment
// The text is a slice of the comment buffer and is NOT NUL-terminated.
CXString clang_TextComment_getText(CXTextComment TC);

// isWhitespace
bool clang_TextComment_isWhitespace(CXTextComment TC);

// clang/AST/Comment.h: enum class clang::comments::InlineCommandRenderKind
typedef enum CXInlineCommandRenderKind {
  CXInlineCommandRenderKind_Normal,
  CXInlineCommandRenderKind_Bold,
  CXInlineCommandRenderKind_Monospaced,
  CXInlineCommandRenderKind_Emphasized,
  CXInlineCommandRenderKind_Anchor
} CXInlineCommandRenderKind;

// InlineCommandComment
unsigned clang_InlineCommandComment_getCommandID(CXInlineCommandComment ICC);

// helper: getCommandName(Traits) with the CommandTraits taken from Ctx.
// Precondition: Ctx is the ASTContext whose comment parser produced ICC — the
// command ID indexes that context's traits table and the CommandInfo it returns
// is dereferenced unchecked.
CXString clang_InlineCommandComment_getCommandName(CXInlineCommandComment ICC,
                                                   CXASTContext Ctx);

CXSourceRange_ clang_InlineCommandComment_getCommandNameRange(CXInlineCommandComment ICC);

CXInlineCommandRenderKind
clang_InlineCommandComment_getRenderKind(CXInlineCommandComment ICC);

unsigned clang_InlineCommandComment_getNumArgs(CXInlineCommandComment ICC);

// Reads Args[Idx] unchecked; Idx < getNumArgs required. The arg text is a slice
// of the comment buffer and is NOT NUL-terminated.
CXString clang_InlineCommandComment_getArgText(CXInlineCommandComment ICC, unsigned Idx);

CXSourceRange_ clang_InlineCommandComment_getArgRange(CXInlineCommandComment ICC,
                                                      unsigned Idx);

// HTMLTagComment
// The tag name is a slice of the comment buffer and is NOT NUL-terminated.
CXString clang_HTMLTagComment_getTagName(CXHTMLTagComment HTC);

CXSourceRange_ clang_HTMLTagComment_getTagNameSourceRange(CXHTMLTagComment HTC);

bool clang_HTMLTagComment_isMalformed(CXHTMLTagComment HTC);

// setIsMalformed

// HTMLStartTagComment
unsigned clang_HTMLStartTagComment_getNumAttrs(CXHTMLStartTagComment HSTC);

// helper: getAttr(Idx) exposed as its component fields — the Attribute value
// type itself does not cross the boundary. Reads Attributes[Idx] unchecked;
// Idx < getNumAttrs required. Both strings are slices of the comment buffer and
// are NOT NUL-terminated; the value is empty for a valueless attribute.
CXString clang_HTMLStartTagComment_getAttrName(CXHTMLStartTagComment HSTC, unsigned Idx);

CXString clang_HTMLStartTagComment_getAttrValue(CXHTMLStartTagComment HSTC, unsigned Idx);

// setAttrs
// setGreaterLoc

bool clang_HTMLStartTagComment_isSelfClosing(CXHTMLStartTagComment HSTC);

// setSelfClosing

// ParagraphComment
bool clang_ParagraphComment_isWhitespace(CXParagraphComment PC);

// BlockCommandComment
// getCommandID
unsigned clang_BlockCommandComment_getCommandID(CXBlockCommandComment BCC);

// helper: getCommandName(Traits) with the CommandTraits taken from Ctx.
// Precondition: Ctx is the ASTContext whose comment parser produced BCC.
CXString clang_BlockCommandComment_getCommandName(CXBlockCommandComment BCC,
                                                  CXASTContext Ctx);

// getCommandNameBeginLoc
// getCommandNameRange
// getNumArgs
// getArgText
// getParagraph
CXSourceLocation_
clang_BlockCommandComment_getCommandNameBeginLoc(CXBlockCommandComment BCC);

unsigned clang_BlockCommandComment_getNumArgs(CXBlockCommandComment BCC);

// Reads Args[Idx] unchecked; Idx < getNumArgs required. The arg text is a slice
// of the comment buffer and is NOT NUL-terminated.
CXString clang_BlockCommandComment_getArgText(CXBlockCommandComment BCC, unsigned Idx);

CXSourceRange_ clang_BlockCommandComment_getArgRange(CXBlockCommandComment BCC,
                                                     unsigned Idx);

// May return null when the command carries no paragraph.
CXParagraphComment clang_BlockCommandComment_getParagraph(CXBlockCommandComment BCC);

bool clang_BlockCommandComment_hasNonWhitespaceParagraph(CXBlockCommandComment BCC);

CXCommandMarkerKind clang_BlockCommandComment_getCommandMarker(CXBlockCommandComment BCC);

// ParamCommandComment
// getDirection
// isDirectionExplicit
CXParamCommandPassDirection
clang_ParamCommandComment_getDirection(CXParamCommandComment PCC);

bool clang_ParamCommandComment_isDirectionExplicit(CXParamCommandComment PCC);

bool clang_ParamCommandComment_hasParamName(CXParamCommandComment PCC);

// getParamNameAsWritten reads Args[0] unchecked.
// Precondition: clang_ParamCommandComment_hasParamName(PCC).
CXString clang_ParamCommandComment_getParamNameAsWritten(CXParamCommandComment PCC);

// getParamName
// getParamNameRange
// isParamIndexValid
// isVarArgParam
// getParamIndex
// Reads Args[0] unchecked; hasParamName(PCC) required.
CXSourceRange_ clang_ParamCommandComment_getParamNameRange(CXParamCommandComment PCC);

bool clang_ParamCommandComment_isParamIndexValid(CXParamCommandComment PCC);

bool clang_ParamCommandComment_isVarArgParam(CXParamCommandComment PCC);

// Asserts isParamIndexValid() && !isVarArgParam().
unsigned clang_ParamCommandComment_getParamIndex(CXParamCommandComment PCC);

// TParamCommandComment
bool clang_TParamCommandComment_hasParamName(CXTParamCommandComment TPCC);

// getParamName
// getParamNameAsWritten reads Args[0] unchecked.
// Precondition: clang_TParamCommandComment_hasParamName(TPCC).
CXString clang_TParamCommandComment_getParamNameAsWritten(CXTParamCommandComment TPCC);

// Reads Args[0] unchecked; hasParamName(TPCC) required.
CXSourceRange_ clang_TParamCommandComment_getParamNameRange(CXTParamCommandComment TPCC);

bool clang_TParamCommandComment_isPositionValid(CXTParamCommandComment TPCC);

// Asserts isPositionValid().
unsigned clang_TParamCommandComment_getDepth(CXTParamCommandComment TPCC);

// Asserts isPositionValid(); reads Position[Depth] unchecked, so
// Depth < clang_TParamCommandComment_getDepth(TPCC) is also required.
unsigned clang_TParamCommandComment_getIndex(CXTParamCommandComment TPCC, unsigned Depth);

// setPosition

// FullComment
// Dereferences the node's DeclInfo unconditionally.
// Precondition: FC came from clang_ASTContext_getCommentForDecl or
// clang_ASTContext_getLocalCommentForDeclUncached, which always attach one.
CXDecl clang_FullComment_getDecl(CXFullComment FC);

LLVM_CLANG_C_EXTERN_C_END

#endif
