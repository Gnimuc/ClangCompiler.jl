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

// clang/AST/Comment.h: enum class clang::comments::CommentKind. Trailing
// underscore: libclang's clang-c/Documentation.h defines an unrelated
// `enum CXCommentKind`. The enumerators are TableGen-stamped from
// CommentNodes.inc (abstract classes get none), so order and values must stay
// identical to the pinned Clang header; the range alias constants
// (First*Constant/Last*Constant) are omitted because they duplicate values.
typedef enum CXCommentKind_ {
  CXCommentKind_None = 0,
  CXCommentKind_VerbatimBlockLineComment,
  CXCommentKind_TextComment,
  CXCommentKind_InlineCommandComment,
  CXCommentKind_HTMLStartTagComment,
  CXCommentKind_HTMLEndTagComment,
  CXCommentKind_FullComment,
  CXCommentKind_ParagraphComment,
  CXCommentKind_BlockCommandComment,
  CXCommentKind_VerbatimLineComment,
  CXCommentKind_VerbatimBlockComment,
  CXCommentKind_TParamCommandComment,
  CXCommentKind_ParamCommandComment
} CXCommentKind_;

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

CXCommentKind_ clang_Comment_getCommentKind(CXComment C);

// dump
// dumpColor
// Debug dumpers writing to llvm::errs(); the output format is not stable.
void clang_Comment_dump(CXComment C);

void clang_Comment_dumpColor(CXComment C);

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

CXVerbatimBlockLineComment clang_Comment_castToVerbatimBlockLineComment(CXComment C);

CXVerbatimBlockComment clang_Comment_castToVerbatimBlockComment(CXComment C);

CXVerbatimLineComment clang_Comment_castToVerbatimLineComment(CXComment C);

CXParagraphComment clang_Comment_castToParagraphComment(CXComment C);

CXFullComment clang_Comment_castToFullComment(CXComment C);

// Comment Predicates
// InlineContentComment, BlockContentComment and HTMLTagComment are abstract
// tiers with no handle of their own, so their classof() is exposed as a
// predicate on the base handle instead of as a cast.
bool clang_Comment_isInlineContentComment(CXComment C);

bool clang_Comment_isBlockContentComment(CXComment C);

bool clang_Comment_isHTMLTagComment(CXComment C);

// InlineContentComment
// addTrailingNewline
void clang_InlineContentComment_addTrailingNewline(CXInlineContentComment ICC);

bool clang_InlineContentComment_hasTrailingNewline(CXInlineContentComment ICC);

// TextComment
// The text is a slice of the comment buffer and is NOT NUL-terminated.
CXString clang_TextComment_getText(CXTextComment TC);

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

void clang_HTMLTagComment_setIsMalformed(CXHTMLTagComment HTC);

// HTMLStartTagComment
unsigned clang_HTMLStartTagComment_getNumAttrs(CXHTMLStartTagComment HSTC);

// helper: getAttr(Idx) exposed as its component fields — the Attribute value
// type itself does not cross the boundary. Reads Attributes[Idx] unchecked;
// Idx < getNumAttrs required. Both strings are slices of the comment buffer and
// are NOT NUL-terminated; the value is empty for a valueless attribute.
CXString clang_HTMLStartTagComment_getAttrName(CXHTMLStartTagComment HSTC, unsigned Idx);

CXString clang_HTMLStartTagComment_getAttrValue(CXHTMLStartTagComment HSTC, unsigned Idx);

// helper: getAttr(Idx).getNameRange() / getAttr(Idx).getNameLocEnd() — the
// Attribute value type itself does not cross the boundary. Reads Attributes[Idx]
// unchecked; Idx < getNumAttrs required.
CXSourceRange_ clang_HTMLStartTagComment_getAttrNameRange(CXHTMLStartTagComment HSTC,
                                                          unsigned Idx);

CXSourceLocation_ clang_HTMLStartTagComment_getAttrNameLocEnd(CXHTMLStartTagComment HSTC,
                                                              unsigned Idx);

// helper: getAttr(Idx).EqualsLoc / getAttr(Idx).ValueRange — the two remaining Attribute
// fields, so the whole value type is reachable as its components. Reads Attributes[Idx]
// unchecked; Idx < getNumAttrs required. Both are invalid for an attribute written
// without a value.
CXSourceLocation_ clang_HTMLStartTagComment_getAttrEqualsLoc(CXHTMLStartTagComment HSTC,
                                                             unsigned Idx);

CXSourceRange_ clang_HTMLStartTagComment_getAttrValueRange(CXHTMLStartTagComment HSTC,
                                                           unsigned Idx);

// helper: setAttrs(ArrayRef<Attribute>) with the attributes rebuilt from their component
// fields and copied into Ctx's arena — the C++ setter stores the ArrayRef itself and each
// Attribute holds StringRefs, so the array and both strings are copied. Ctx must be the
// ASTContext that owns HSTC. The five arrays are read in lockstep and must all hold N
// entries. The setter also moves the tag's range end to the last attribute's value-range
// end, or to its name end when that range is invalid.
void clang_HTMLStartTagComment_setAttrs(CXHTMLStartTagComment HSTC, CXASTContext Ctx,
                                        const CXSourceLocation_ *NameLocBegins,
                                        const char **Names,
                                        const CXSourceLocation_ *EqualsLocs,
                                        const CXSourceRange_ *ValueRanges,
                                        const char **Values, unsigned N);
void clang_HTMLStartTagComment_setGreaterLoc(CXHTMLStartTagComment HSTC,
                                             CXSourceLocation_ GreaterLoc);

bool clang_HTMLStartTagComment_isSelfClosing(CXHTMLStartTagComment HSTC);

void clang_HTMLStartTagComment_setSelfClosing(CXHTMLStartTagComment HSTC);

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

// helper: getCommandNameRange(Traits) with the CommandTraits taken from Ctx.
// Precondition: Ctx is the ASTContext whose comment parser produced BCC — the
// command ID indexes that context's traits table and the CommandInfo it returns
// is dereferenced unchecked.
CXSourceRange_ clang_BlockCommandComment_getCommandNameRange(CXBlockCommandComment BCC,
                                                             CXASTContext Ctx);

unsigned clang_BlockCommandComment_getNumArgs(CXBlockCommandComment BCC);

// Reads Args[Idx] unchecked; Idx < getNumArgs required. The arg text is a slice
// of the comment buffer and is NOT NUL-terminated.
CXString clang_BlockCommandComment_getArgText(CXBlockCommandComment BCC, unsigned Idx);

CXSourceRange_ clang_BlockCommandComment_getArgRange(CXBlockCommandComment BCC,
                                                     unsigned Idx);

// helper: setArgs(ArrayRef<Argument>) with the arguments rebuilt from their component
// fields and copied into Ctx's arena — the C++ setter stores the ArrayRef itself and each
// Argument holds a StringRef, so the array and the texts are copied. Ctx must be the
// ASTContext that owns BCC. The two arrays are read in lockstep and must both hold N
// entries. The setter also extends the command's source range to the last argument's
// range end when that end is valid.
void clang_BlockCommandComment_setArgs(CXBlockCommandComment BCC, CXASTContext Ctx,
                                       const char **Texts, const CXSourceRange_ *Ranges,
                                       unsigned N);

// May return null when the command carries no paragraph.
CXParagraphComment clang_BlockCommandComment_getParagraph(CXBlockCommandComment BCC);

bool clang_BlockCommandComment_hasNonWhitespaceParagraph(CXBlockCommandComment BCC);

// Dereferences PC to extend the command's source range, so PC must be non-null.
void clang_BlockCommandComment_setParagraph(CXBlockCommandComment BCC,
                                            CXParagraphComment PC);

CXCommandMarkerKind clang_BlockCommandComment_getCommandMarker(CXBlockCommandComment BCC);

// ParamCommandComment
// getDirection
// isDirectionExplicit
CXParamCommandPassDirection
clang_ParamCommandComment_getDirection(CXParamCommandComment PCC);

bool clang_ParamCommandComment_isDirectionExplicit(CXParamCommandComment PCC);

void clang_ParamCommandComment_setDirection(CXParamCommandComment PCC,
                                            CXParamCommandPassDirection Direction,
                                            bool Explicit);

// static member function: no receiver. Returns Clang-owned literal storage
// ("[in]", "[out]", "[in,out]"), borrowed. The C++ switch ends in
// llvm_unreachable, so D must be one of the three enumerators.
const char *clang_ParamCommandComment_getDirectionAsString(CXParamCommandPassDirection D);

bool clang_ParamCommandComment_hasParamName(CXParamCommandComment PCC);

// Asserts isParamIndexValid(); for a non-vararg parameter it indexes FC's
// DeclInfo::ParamVars with the resolved index and dereferences the entry
// unchecked. Precondition: FC is the FullComment that owns PCC.
CXString clang_ParamCommandComment_getParamName(CXParamCommandComment PCC,
                                                CXFullComment FC);

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

// Sets the parameter index to the vararg sentinel. Afterwards isVarArgParam is
// true and getParamIndex must not be called: it asserts !isVarArgParam().
void clang_ParamCommandComment_setIsVarArgParam(CXParamCommandComment PCC);

// Asserts isParamIndexValid() && !isVarArgParam().
unsigned clang_ParamCommandComment_getParamIndex(CXParamCommandComment PCC);

// Asserts the new index is neither the invalid (0xFFFFFFFF) nor the vararg
// (0xFFFFFFFE) sentinel, so Index < 0xFFFFFFFEu is required.
void clang_ParamCommandComment_setParamIndex(CXParamCommandComment PCC, unsigned Index);

// TParamCommandComment
bool clang_TParamCommandComment_hasParamName(CXTParamCommandComment TPCC);

// Asserts isPositionValid() and walks FC's DeclInfo::TemplateParameters with
// unchecked dereferences. Precondition: FC is the FullComment that owns TPCC.
CXString clang_TParamCommandComment_getParamName(CXTParamCommandComment TPCC,
                                                 CXFullComment FC);

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

// helper: setPosition(ArrayRef<unsigned>) with the array copied into Ctx's arena —
// the C++ setter stores the ArrayRef itself. Ctx must be the ASTContext that owns
// TPCC, and N must be non-zero: the setter asserts isPositionValid(). The position is
// what getParamName(FC) indexes FC's template parameter list with, so a value that no
// longer matches that list makes getParamName undefined.
void clang_TParamCommandComment_setPosition(CXTParamCommandComment TPCC, CXASTContext Ctx,
                                            const unsigned *Position, unsigned N);

// VerbatimBlockLineComment
// The text is a slice of the comment buffer and is NOT NUL-terminated.
CXString clang_VerbatimBlockLineComment_getText(CXVerbatimBlockLineComment VBLC);

// VerbatimBlockComment
// setCloseName
// helper: setCloseName(StringRef, SourceLocation) with the name copied into Ctx's
// arena — the C++ setter stores the StringRef itself, so a caller-owned buffer would
// dangle. Ctx must be the ASTContext that owns VBC.
void clang_VerbatimBlockComment_setCloseName(CXVerbatimBlockComment VBC, CXASTContext Ctx,
                                             const char *Name, CXSourceLocation_ LocBegin);
// helper: setLines(ArrayRef<VerbatimBlockLineComment *>) with the array copied into
// Ctx's arena — the C++ setter stores the ArrayRef itself. Ctx must be the ASTContext
// that owns VBC. The array becomes the node's child list, so no slot may be null.
void clang_VerbatimBlockComment_setLines(CXVerbatimBlockComment VBC, CXASTContext Ctx,
                                         const CXVerbatimBlockLineComment *Lines,
                                         unsigned N);
// The close name is a slice of the comment buffer and is NOT NUL-terminated; it
// stays empty until the block's closing command has been parsed.
CXString clang_VerbatimBlockComment_getCloseName(CXVerbatimBlockComment VBC);

unsigned clang_VerbatimBlockComment_getNumLines(CXVerbatimBlockComment VBC);

// Reads Lines[LineIdx] unchecked; LineIdx < getNumLines required. The text is a
// slice of the comment buffer and is NOT NUL-terminated.
CXString clang_VerbatimBlockComment_getText(CXVerbatimBlockComment VBC, unsigned LineIdx);

// VerbatimLineComment
// The text is a slice of the comment buffer and is NOT NUL-terminated.
CXString clang_VerbatimLineComment_getText(CXVerbatimLineComment VLC);

CXSourceRange_ clang_VerbatimLineComment_getTextRange(CXVerbatimLineComment VLC);

// DeclInfo
// clang/AST/Comment.h: enum DeclKind (nested in clang::comments::DeclInfo)
typedef enum CXDeclInfo_DeclKind {
  CXDeclInfo_OtherKind,
  CXDeclInfo_FunctionKind,
  CXDeclInfo_ClassKind,
  CXDeclInfo_VariableKind,
  CXDeclInfo_NamespaceKind,
  CXDeclInfo_TypedefKind,
  CXDeclInfo_EnumKind
} CXDeclInfo_DeclKind;

// clang/AST/Comment.h: enum TemplateDeclKind (nested in clang::comments::DeclInfo)
typedef enum CXDeclInfo_TemplateDeclKind {
  CXDeclInfo_NotTemplate,
  CXDeclInfo_Template,
  CXDeclInfo_TemplateSpecialization,
  CXDeclInfo_TemplatePartialSpecialization
} CXDeclInfo_TemplateDeclKind;

// fill

// Reads the Kind bitfield, which has no default initializer and is written only
// by DeclInfo::fill(). Precondition: DI came from clang_FullComment_getDeclInfo,
// which fills on demand and is the only producer of a CXDeclInfo.
CXDeclInfo_DeclKind clang_DeclInfo_getKind(CXDeclInfo DI);

// Reads the TemplateKind bitfield; same precondition as getKind.
CXDeclInfo_TemplateDeclKind clang_DeclInfo_getTemplateKind(CXDeclInfo DI);

// Reads ReturnType, which the implicit default constructor initializes to a null
// QualType, so this one is well-defined even on an unfilled DeclInfo.
bool clang_DeclInfo_involvesFunctionType(CXDeclInfo DI);

// FullComment
// Dereferences the node's DeclInfo unconditionally.
// Precondition: FC came from clang_ASTContext_getCommentForDecl or
// clang_ASTContext_getLocalCommentForDeclUncached, which always attach one.
CXDecl clang_FullComment_getDecl(CXFullComment FC);

// Dereferences the node's DeclInfo unconditionally and fills it on first use, so
// the returned handle always has its bitfields initialized.
// Precondition: FC came from clang_ASTContext_getCommentForDecl or
// clang_ASTContext_getLocalCommentForDeclUncached, which always attach one.
CXDeclInfo clang_FullComment_getDeclInfo(CXFullComment FC);

// helper: getBlocks() exposed as count+index. The elements are BlockContentComment
// nodes, handed back at the CXComment base handle (single inheritance, so the
// pointer value is unchanged); refine them with the clang_Comment_castTo* family.
unsigned clang_FullComment_getNumBlocks(CXFullComment FC);

// Reads Blocks[Idx] unchecked; Idx < getNumBlocks required.
CXComment clang_FullComment_getBlock(CXFullComment FC, unsigned Idx);

LLVM_CLANG_C_EXTERN_C_END

#endif
