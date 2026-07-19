#include "clang-ex/AST/CXExpr.h"
#include "utils.h"
#include "clang/AST/APValue.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/Expr.h"
#include "clang/Basic/LangOptions.h"
#include "llvm/ExecutionEngine/GenericValue.h"

// Expr
CXQualType clang_Expr_getType(CXExpr E) {
  return static_cast<clang::Expr *>(E)->getType().getAsOpaquePtr();
}

CXExprValueKind clang_Expr_getValueKind(CXExpr E) {
  return static_cast<CXExprValueKind>(static_cast<clang::Expr *>(E)->getValueKind());
}

bool clang_Expr_isLValue(CXExpr E) { return static_cast<clang::Expr *>(E)->isLValue(); }

bool clang_Expr_isPRValue(CXExpr E) { return static_cast<clang::Expr *>(E)->isPRValue(); }

bool clang_Expr_isXValue(CXExpr E) { return static_cast<clang::Expr *>(E)->isXValue(); }

bool clang_Expr_isGLValue(CXExpr E) { return static_cast<clang::Expr *>(E)->isGLValue(); }

CXExpr clang_Expr_IgnoreImpCasts(CXExpr E) {
  return static_cast<clang::Expr *>(E)->IgnoreImpCasts();
}

CXExpr clang_Expr_IgnoreCasts(CXExpr E) {
  return static_cast<clang::Expr *>(E)->IgnoreCasts();
}

CXExpr clang_Expr_IgnoreParens(CXExpr E) {
  return static_cast<clang::Expr *>(E)->IgnoreParens();
}

CXExpr clang_Expr_IgnoreParenCasts(CXExpr E) {
  return static_cast<clang::Expr *>(E)->IgnoreParenCasts();
}

CXExpr clang_Expr_IgnoreParenImpCasts(CXExpr E) {
  return static_cast<clang::Expr *>(E)->IgnoreParenImpCasts();
}

bool clang_Expr_containsErrors(CXExpr E) {
  return static_cast<clang::Expr *>(E)->containsErrors();
}

bool clang_Expr_containsUnexpandedParameterPack(CXExpr E) {
  return static_cast<clang::Expr *>(E)->containsUnexpandedParameterPack();
}

bool clang_Expr_hasPlaceholderType(CXExpr E) {
  return static_cast<clang::Expr *>(E)->hasPlaceholderType();
}

bool clang_Expr_isDefaultArgument(CXExpr E) {
  return static_cast<clang::Expr *>(E)->isDefaultArgument();
}

bool clang_Expr_isImplicitCXXThis(CXExpr E) {
  return static_cast<clang::Expr *>(E)->isImplicitCXXThis();
}

bool clang_Expr_isInstantiationDependent(CXExpr E) {
  return static_cast<clang::Expr *>(E)->isInstantiationDependent();
}

bool clang_Expr_isObjCSelfExpr(CXExpr E) {
  return static_cast<clang::Expr *>(E)->isObjCSelfExpr();
}

bool clang_Expr_isOrdinaryOrBitFieldObject(CXExpr E) {
  return static_cast<clang::Expr *>(E)->isOrdinaryOrBitFieldObject();
}

bool clang_Expr_isTypeDependent(CXExpr E) {
  return static_cast<clang::Expr *>(E)->isTypeDependent();
}

bool clang_Expr_isValueDependent(CXExpr E) {
  return static_cast<clang::Expr *>(E)->isValueDependent();
}

bool clang_Expr_refersToBitField(CXExpr E) {
  return static_cast<clang::Expr *>(E)->refersToBitField();
}

bool clang_Expr_refersToGlobalRegisterVar(CXExpr E) {
  return static_cast<clang::Expr *>(E)->refersToGlobalRegisterVar();
}

bool clang_Expr_refersToMatrixElement(CXExpr E) {
  return static_cast<clang::Expr *>(E)->refersToMatrixElement();
}

bool clang_Expr_refersToVectorElement(CXExpr E) {
  return static_cast<clang::Expr *>(E)->refersToVectorElement();
}

CXSourceLocation_ clang_Expr_getExprLoc(CXExpr E) {
  return static_cast<clang::Expr *>(E)->getExprLoc().getPtrEncoding();
}

CXAPValue clang_Expr_EvaluateAsRValue(CXExpr E, CXASTContext Ctx) {
  clang::Expr::EvalResult Result;
  if (!static_cast<clang::Expr *>(E)->EvaluateAsRValue(
          Result, *static_cast<clang::ASTContext *>(Ctx)))
    return nullptr;
  return new clang::APValue(Result.Val); // NOLINT(*-owning-memory)
}

// DeclRefExpr
CXValueDecl clang_DeclRefExpr_getDecl(CXDeclRefExpr DRE) {
  return static_cast<clang::DeclRefExpr *>(DRE)->getDecl();
}

CXNamedDecl clang_DeclRefExpr_getFoundDecl(CXDeclRefExpr DRE) {
  return static_cast<clang::DeclRefExpr *>(DRE)->getFoundDecl();
}

bool clang_DeclRefExpr_hasQualifier(CXDeclRefExpr DRE) {
  return static_cast<clang::DeclRefExpr *>(DRE)->hasQualifier();
}

CXSourceLocation_ clang_DeclRefExpr_getLocation(CXDeclRefExpr DRE) {
  return static_cast<clang::DeclRefExpr *>(DRE)->getLocation().getPtrEncoding();
}

// IntegerLiteral
CXIntegerLiteral clang_IntegerLiteral_Create(CXASTContext C, LLVMGenericValueRef Val,
                                             CXQualType T, CXSourceLocation_ L) {
  return clang::IntegerLiteral::Create(
      *static_cast<clang::ASTContext *>(C),
      llvm::APSInt(reinterpret_cast<llvm::GenericValue *>(Val)->IntVal),
      clang::QualType::getFromOpaquePtr(T), clang::SourceLocation::getFromPtrEncoding(L));
}

CXSourceLocation_ clang_IntegerLiteral_getBeginLoc(CXIntegerLiteral IL) {
  return static_cast<clang::IntegerLiteral *>(IL)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_IntegerLiteral_getEndLoc(CXIntegerLiteral IL) {
  return static_cast<clang::IntegerLiteral *>(IL)->getEndLoc().getPtrEncoding();
}

CXSourceLocation_ clang_IntegerLiteral_getLocation(CXIntegerLiteral IL) {
  return static_cast<clang::IntegerLiteral *>(IL)->getLocation().getPtrEncoding();
}

void clang_IntegerLiteral_setLocation(CXIntegerLiteral IL, CXSourceLocation_ L) {
  static_cast<clang::IntegerLiteral *>(IL)->setLocation(
      clang::SourceLocation::getFromPtrEncoding(L));
}

// CStyleCastExpr
CXCStyleCastExpr clang_CStyleCastExpr_CreateWithNoTypeInfo(CXASTContext C, CXQualType T,
                                                           CXExprValueKind VK, CXCastKind K,
                                                           CXExpr Op) {
  return clang::CStyleCastExpr::Create(
      *static_cast<clang::ASTContext *>(C), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::ExprValueKind>(VK), static_cast<clang::CastKind>(K),
      static_cast<clang::Expr *>(Op), nullptr, clang::FPOptionsOverride(),
      static_cast<clang::ASTContext *>(C)->getTrivialTypeSourceInfo(
          clang::QualType::getFromOpaquePtr(T), clang::SourceLocation()),
      clang::SourceLocation(), clang::SourceLocation());
}

CXCStyleCastExpr clang_CStyleCastExpr_CreateEmpty(CXASTContext C, unsigned PathSize,
                                                  bool HasFPFeatures) {
  return clang::CStyleCastExpr::CreateEmpty(*static_cast<clang::ASTContext *>(C), PathSize,
                                            HasFPFeatures);
}

CXSourceLocation_ clang_CStyleCastExpr_getLParenLoc(CXCStyleCastExpr CSCE) {
  return static_cast<clang::CStyleCastExpr *>(CSCE)->getLParenLoc().getPtrEncoding();
}

void clang_CStyleCastExpr_setLParenLoc(CXCStyleCastExpr CSCE, CXSourceLocation_ L) {
  static_cast<clang::CStyleCastExpr *>(CSCE)->setLParenLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

CXSourceLocation_ clang_CStyleCastExpr_getRParenLoc(CXCStyleCastExpr CSCE) {
  return static_cast<clang::CStyleCastExpr *>(CSCE)->getRParenLoc().getPtrEncoding();
}

void clang_CStyleCastExpr_setRParenLoc(CXCStyleCastExpr CSCE, CXSourceLocation_ L) {
  static_cast<clang::CStyleCastExpr *>(CSCE)->setRParenLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

CXSourceLocation_ clang_CStyleCastExpr_getBeginLoc(CXCStyleCastExpr CSCE) {
  return static_cast<clang::CStyleCastExpr *>(CSCE)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_CStyleCastExpr_getEndLoc(CXCStyleCastExpr CSCE) {
  return static_cast<clang::CStyleCastExpr *>(CSCE)->getEndLoc().getPtrEncoding();
}

LLVMGenericValueRef clang_IntegerLiteral_getValue(CXIntegerLiteral IL) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = static_cast<clang::IntegerLiteral *>(IL)->getValue();
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

// CharacterLiteral
unsigned clang_CharacterLiteral_getValue(CXCharacterLiteral CL) {
  return static_cast<clang::CharacterLiteral *>(CL)->getValue();
}

CXCharacterLiteralKind clang_CharacterLiteral_getKind(CXCharacterLiteral CL) {
  return static_cast<CXCharacterLiteralKind>(
      static_cast<clang::CharacterLiteral *>(CL)->getKind());
}

// FloatingLiteral
double clang_FloatingLiteral_getValueAsApproximateDouble(CXFloatingLiteral FL) {
  return static_cast<clang::FloatingLiteral *>(FL)->getValueAsApproximateDouble();
}

// StringLiteral
CXString clang_StringLiteral_getBytes(CXStringLiteral SL) {
  return extra::makeCXString(static_cast<clang::StringLiteral *>(SL)->getBytes().str());
}

unsigned clang_StringLiteral_getByteLength(CXStringLiteral SL) {
  return static_cast<clang::StringLiteral *>(SL)->getByteLength();
}

unsigned clang_StringLiteral_getLength(CXStringLiteral SL) {
  return static_cast<clang::StringLiteral *>(SL)->getLength();
}

unsigned clang_StringLiteral_getCharByteWidth(CXStringLiteral SL) {
  return static_cast<clang::StringLiteral *>(SL)->getCharByteWidth();
}

// ParenExpr
CXExpr clang_ParenExpr_getSubExpr(CXParenExpr PE) {
  return static_cast<clang::ParenExpr *>(PE)->getSubExpr();
}

// UnaryOperator
CXUnaryOperatorKind clang_UnaryOperator_getOpcode(CXUnaryOperator UO) {
  return static_cast<CXUnaryOperatorKind>(
      static_cast<clang::UnaryOperator *>(UO)->getOpcode());
}

CXExpr clang_UnaryOperator_getSubExpr(CXUnaryOperator UO) {
  return static_cast<clang::UnaryOperator *>(UO)->getSubExpr();
}

CXSourceLocation_ clang_UnaryOperator_getOperatorLoc(CXUnaryOperator UO) {
  return static_cast<clang::UnaryOperator *>(UO)->getOperatorLoc().getPtrEncoding();
}

bool clang_UnaryOperator_isPrefix(CXUnaryOperator UO) {
  return static_cast<clang::UnaryOperator *>(UO)->isPrefix();
}

bool clang_UnaryOperator_isPostfix(CXUnaryOperator UO) {
  return static_cast<clang::UnaryOperator *>(UO)->isPostfix();
}

bool clang_UnaryOperator_isIncrementOp(CXUnaryOperator UO) {
  return static_cast<clang::UnaryOperator *>(UO)->isIncrementOp();
}

bool clang_UnaryOperator_isDecrementOp(CXUnaryOperator UO) {
  return static_cast<clang::UnaryOperator *>(UO)->isDecrementOp();
}

// ArraySubscriptExpr
CXExpr clang_ArraySubscriptExpr_getLHS(CXArraySubscriptExpr ASE) {
  return static_cast<clang::ArraySubscriptExpr *>(ASE)->getLHS();
}

CXExpr clang_ArraySubscriptExpr_getRHS(CXArraySubscriptExpr ASE) {
  return static_cast<clang::ArraySubscriptExpr *>(ASE)->getRHS();
}

CXExpr clang_ArraySubscriptExpr_getBase(CXArraySubscriptExpr ASE) {
  return static_cast<clang::ArraySubscriptExpr *>(ASE)->getBase();
}

CXExpr clang_ArraySubscriptExpr_getIdx(CXArraySubscriptExpr ASE) {
  return static_cast<clang::ArraySubscriptExpr *>(ASE)->getIdx();
}

// CallExpr
CXExpr clang_CallExpr_getCallee(CXCallExpr CE) {
  return static_cast<clang::CallExpr *>(CE)->getCallee();
}

CXDecl clang_CallExpr_getCalleeDecl(CXCallExpr CE) {
  return static_cast<clang::CallExpr *>(CE)->getCalleeDecl();
}

CXFunctionDecl clang_CallExpr_getDirectCallee(CXCallExpr CE) {
  return static_cast<clang::CallExpr *>(CE)->getDirectCallee();
}

unsigned clang_CallExpr_getNumArgs(CXCallExpr CE) {
  return static_cast<clang::CallExpr *>(CE)->getNumArgs();
}

CXExpr clang_CallExpr_getArg(CXCallExpr CE, unsigned Arg) {
  return static_cast<clang::CallExpr *>(CE)->getArg(Arg);
}

CXSourceLocation_ clang_CallExpr_getRParenLoc(CXCallExpr CE) {
  return static_cast<clang::CallExpr *>(CE)->getRParenLoc().getPtrEncoding();
}

// MemberExpr
CXExpr clang_MemberExpr_getBase(CXMemberExpr ME) {
  return static_cast<clang::MemberExpr *>(ME)->getBase();
}

CXValueDecl clang_MemberExpr_getMemberDecl(CXMemberExpr ME) {
  return static_cast<clang::MemberExpr *>(ME)->getMemberDecl();
}

bool clang_MemberExpr_isArrow(CXMemberExpr ME) {
  return static_cast<clang::MemberExpr *>(ME)->isArrow();
}

CXSourceLocation_ clang_MemberExpr_getMemberLoc(CXMemberExpr ME) {
  return static_cast<clang::MemberExpr *>(ME)->getMemberLoc().getPtrEncoding();
}

bool clang_MemberExpr_isImplicitAccess(CXMemberExpr ME) {
  return static_cast<clang::MemberExpr *>(ME)->isImplicitAccess();
}

// CastExpr
CXCastKind clang_CastExpr_getCastKind(CXCastExpr CE) {
  return static_cast<CXCastKind>(static_cast<clang::CastExpr *>(CE)->getCastKind());
}

const char *clang_CastExpr_getCastKindName(CXCastExpr CE) {
  return static_cast<clang::CastExpr *>(CE)->getCastKindName();
}

CXExpr clang_CastExpr_getSubExpr(CXCastExpr CE) {
  return static_cast<clang::CastExpr *>(CE)->getSubExpr();
}

CXExpr clang_CastExpr_getSubExprAsWritten(CXCastExpr CE) {
  return static_cast<clang::CastExpr *>(CE)->getSubExprAsWritten();
}

// ImplicitCastExpr
bool clang_ImplicitCastExpr_isPartOfExplicitCast(CXImplicitCastExpr ICE) {
  return static_cast<clang::ImplicitCastExpr *>(ICE)->isPartOfExplicitCast();
}

// ExplicitCastExpr
CXQualType clang_ExplicitCastExpr_getTypeAsWritten(CXExplicitCastExpr ECE) {
  return static_cast<clang::ExplicitCastExpr *>(ECE)->getTypeAsWritten().getAsOpaquePtr();
}

// BinaryOperator
CXBinaryOperatorKind clang_BinaryOperator_getOpcode(CXBinaryOperator BO) {
  return static_cast<CXBinaryOperatorKind>(
      static_cast<clang::BinaryOperator *>(BO)->getOpcode());
}

CXExpr clang_BinaryOperator_getLHS(CXBinaryOperator BO) {
  return static_cast<clang::BinaryOperator *>(BO)->getLHS();
}

CXExpr clang_BinaryOperator_getRHS(CXBinaryOperator BO) {
  return static_cast<clang::BinaryOperator *>(BO)->getRHS();
}

CXSourceLocation_ clang_BinaryOperator_getOperatorLoc(CXBinaryOperator BO) {
  return static_cast<clang::BinaryOperator *>(BO)->getOperatorLoc().getPtrEncoding();
}

const char *clang_BinaryOperator_getOpcodeStr(CXBinaryOperator BO) {
  // the spelling table is static string literals: borrowed, NUL-terminated
  return static_cast<clang::BinaryOperator *>(BO)->getOpcodeStr().data();
}

bool clang_BinaryOperator_isAssignmentOp(CXBinaryOperator BO) {
  return static_cast<clang::BinaryOperator *>(BO)->isAssignmentOp();
}

bool clang_BinaryOperator_isCompoundAssignmentOp(CXBinaryOperator BO) {
  return static_cast<clang::BinaryOperator *>(BO)->isCompoundAssignmentOp();
}

bool clang_BinaryOperator_isComparisonOp(CXBinaryOperator BO) {
  return static_cast<clang::BinaryOperator *>(BO)->isComparisonOp();
}

// CompoundAssignOperator
CXQualType
clang_CompoundAssignOperator_getComputationLHSType(CXCompoundAssignOperator CAO) {
  return static_cast<clang::CompoundAssignOperator *>(CAO)
      ->getComputationLHSType()
      .getAsOpaquePtr();
}

CXQualType
clang_CompoundAssignOperator_getComputationResultType(CXCompoundAssignOperator CAO) {
  return static_cast<clang::CompoundAssignOperator *>(CAO)
      ->getComputationResultType()
      .getAsOpaquePtr();
}

// AbstractConditionalOperator
CXExpr clang_AbstractConditionalOperator_getCond(CXAbstractConditionalOperator ACO) {
  return static_cast<clang::AbstractConditionalOperator *>(ACO)->getCond();
}

CXExpr clang_AbstractConditionalOperator_getTrueExpr(CXAbstractConditionalOperator ACO) {
  return static_cast<clang::AbstractConditionalOperator *>(ACO)->getTrueExpr();
}

CXExpr clang_AbstractConditionalOperator_getFalseExpr(CXAbstractConditionalOperator ACO) {
  return static_cast<clang::AbstractConditionalOperator *>(ACO)->getFalseExpr();
}

// InitListExpr
unsigned clang_InitListExpr_getNumInits(CXInitListExpr ILE) {
  return static_cast<clang::InitListExpr *>(ILE)->getNumInits();
}

CXExpr clang_InitListExpr_getInit(CXInitListExpr ILE, unsigned Init) {
  return static_cast<clang::InitListExpr *>(ILE)->getInit(Init);
}

bool clang_InitListExpr_isSemanticForm(CXInitListExpr ILE) {
  return static_cast<clang::InitListExpr *>(ILE)->isSemanticForm();
}

CXInitListExpr clang_InitListExpr_getSyntacticForm(CXInitListExpr ILE) {
  return static_cast<clang::InitListExpr *>(ILE)->getSyntacticForm();
}

// UnaryExprOrTypeTraitExpr
bool clang_UnaryExprOrTypeTraitExpr_isArgumentType(CXUnaryExprOrTypeTraitExpr E) {
  return static_cast<clang::UnaryExprOrTypeTraitExpr *>(E)->isArgumentType();
}

CXQualType clang_UnaryExprOrTypeTraitExpr_getArgumentType(CXUnaryExprOrTypeTraitExpr E) {
  return static_cast<clang::UnaryExprOrTypeTraitExpr *>(E)->getArgumentType().getAsOpaquePtr();
}

CXQualType clang_UnaryExprOrTypeTraitExpr_getTypeOfArgument(CXUnaryExprOrTypeTraitExpr E) {
  return static_cast<clang::UnaryExprOrTypeTraitExpr *>(E)->getTypeOfArgument().getAsOpaquePtr();
}

CXSourceLocation_ clang_UnaryExprOrTypeTraitExpr_getOperatorLoc(CXUnaryExprOrTypeTraitExpr E) {
  return static_cast<clang::UnaryExprOrTypeTraitExpr *>(E)->getOperatorLoc().getPtrEncoding();
}

CXSourceLocation_ clang_UnaryExprOrTypeTraitExpr_getRParenLoc(CXUnaryExprOrTypeTraitExpr E) {
  return static_cast<clang::UnaryExprOrTypeTraitExpr *>(E)->getRParenLoc().getPtrEncoding();
}

// StringLiteral
bool clang_StringLiteral_isOrdinary(CXStringLiteral E) {
  return static_cast<clang::StringLiteral *>(E)->isOrdinary();
}

bool clang_StringLiteral_isWide(CXStringLiteral E) {
  return static_cast<clang::StringLiteral *>(E)->isWide();
}

bool clang_StringLiteral_isUTF8(CXStringLiteral E) {
  return static_cast<clang::StringLiteral *>(E)->isUTF8();
}

bool clang_StringLiteral_isUTF16(CXStringLiteral E) {
  return static_cast<clang::StringLiteral *>(E)->isUTF16();
}

bool clang_StringLiteral_isUTF32(CXStringLiteral E) {
  return static_cast<clang::StringLiteral *>(E)->isUTF32();
}

bool clang_StringLiteral_isUnevaluated(CXStringLiteral E) {
  return static_cast<clang::StringLiteral *>(E)->isUnevaluated();
}

bool clang_StringLiteral_isPascal(CXStringLiteral E) {
  return static_cast<clang::StringLiteral *>(E)->isPascal();
}

bool clang_StringLiteral_containsNonAscii(CXStringLiteral E) {
  return static_cast<clang::StringLiteral *>(E)->containsNonAscii();
}

bool clang_StringLiteral_containsNonAsciiOrNull(CXStringLiteral E) {
  return static_cast<clang::StringLiteral *>(E)->containsNonAsciiOrNull();
}

unsigned clang_StringLiteral_getNumConcatenated(CXStringLiteral E) {
  return static_cast<clang::StringLiteral *>(E)->getNumConcatenated();
}

// CharacterLiteral
CXSourceLocation_ clang_CharacterLiteral_getLocation(CXCharacterLiteral E) {
  return static_cast<clang::CharacterLiteral *>(E)->getLocation().getPtrEncoding();
}

// UnaryOperator
bool clang_UnaryOperator_canOverflow(CXUnaryOperator E) {
  return static_cast<clang::UnaryOperator *>(E)->canOverflow();
}

bool clang_UnaryOperator_isIncrementDecrementOp(CXUnaryOperator E) {
  return static_cast<clang::UnaryOperator *>(E)->isIncrementDecrementOp();
}

bool clang_UnaryOperator_isArithmeticOp(CXUnaryOperator E) {
  return static_cast<clang::UnaryOperator *>(E)->isArithmeticOp();
}

bool clang_UnaryOperator_hasStoredFPFeatures(CXUnaryOperator E) {
  return static_cast<clang::UnaryOperator *>(E)->hasStoredFPFeatures();
}

// CallExpr
bool clang_CallExpr_usesADL(CXCallExpr E) {
  return static_cast<clang::CallExpr *>(E)->usesADL();
}

bool clang_CallExpr_hasStoredFPFeatures(CXCallExpr E) {
  return static_cast<clang::CallExpr *>(E)->hasStoredFPFeatures();
}

unsigned clang_CallExpr_getBuiltinCallee(CXCallExpr E) {
  return static_cast<clang::CallExpr *>(E)->getBuiltinCallee();
}

bool clang_CallExpr_isCallToStdMove(CXCallExpr E) {
  return static_cast<clang::CallExpr *>(E)->isCallToStdMove();
}

// MemberExpr
bool clang_MemberExpr_hasQualifier(CXMemberExpr E) {
  return static_cast<clang::MemberExpr *>(E)->hasQualifier();
}

CXSourceLocation_ clang_MemberExpr_getTemplateKeywordLoc(CXMemberExpr E) {
  return static_cast<clang::MemberExpr *>(E)->getTemplateKeywordLoc().getPtrEncoding();
}

CXSourceLocation_ clang_MemberExpr_getLAngleLoc(CXMemberExpr E) {
  return static_cast<clang::MemberExpr *>(E)->getLAngleLoc().getPtrEncoding();
}

CXSourceLocation_ clang_MemberExpr_getRAngleLoc(CXMemberExpr E) {
  return static_cast<clang::MemberExpr *>(E)->getRAngleLoc().getPtrEncoding();
}

bool clang_MemberExpr_hasTemplateKeyword(CXMemberExpr E) {
  return static_cast<clang::MemberExpr *>(E)->hasTemplateKeyword();
}

bool clang_MemberExpr_hasExplicitTemplateArgs(CXMemberExpr E) {
  return static_cast<clang::MemberExpr *>(E)->hasExplicitTemplateArgs();
}

unsigned clang_MemberExpr_getNumTemplateArgs(CXMemberExpr E) {
  return static_cast<clang::MemberExpr *>(E)->getNumTemplateArgs();
}

CXSourceLocation_ clang_MemberExpr_getOperatorLoc(CXMemberExpr E) {
  return static_cast<clang::MemberExpr *>(E)->getOperatorLoc().getPtrEncoding();
}

bool clang_MemberExpr_hadMultipleCandidates(CXMemberExpr E) {
  return static_cast<clang::MemberExpr *>(E)->hadMultipleCandidates();
}

// InitListExpr
bool clang_InitListExpr_hasArrayFiller(CXInitListExpr E) {
  return static_cast<clang::InitListExpr *>(E)->hasArrayFiller();
}

bool clang_InitListExpr_hasDesignatedInit(CXInitListExpr E) {
  return static_cast<clang::InitListExpr *>(E)->hasDesignatedInit();
}

bool clang_InitListExpr_isExplicit(CXInitListExpr E) {
  return static_cast<clang::InitListExpr *>(E)->isExplicit();
}

bool clang_InitListExpr_isStringLiteralInit(CXInitListExpr E) {
  return static_cast<clang::InitListExpr *>(E)->isStringLiteralInit();
}

bool clang_InitListExpr_isTransparent(CXInitListExpr E) {
  return static_cast<clang::InitListExpr *>(E)->isTransparent();
}

CXSourceLocation_ clang_InitListExpr_getLBraceLoc(CXInitListExpr E) {
  return static_cast<clang::InitListExpr *>(E)->getLBraceLoc().getPtrEncoding();
}

CXSourceLocation_ clang_InitListExpr_getRBraceLoc(CXInitListExpr E) {
  return static_cast<clang::InitListExpr *>(E)->getRBraceLoc().getPtrEncoding();
}

bool clang_InitListExpr_isSyntacticForm(CXInitListExpr E) {
  return static_cast<clang::InitListExpr *>(E)->isSyntacticForm();
}

bool clang_InitListExpr_hadArrayRangeDesignator(CXInitListExpr E) {
  return static_cast<clang::InitListExpr *>(E)->hadArrayRangeDesignator();
}

// ParenExpr
CXSourceLocation_ clang_ParenExpr_getLParen(CXParenExpr E) {
  return static_cast<clang::ParenExpr *>(E)->getLParen().getPtrEncoding();
}

CXSourceLocation_ clang_ParenExpr_getRParen(CXParenExpr E) {
  return static_cast<clang::ParenExpr *>(E)->getRParen().getPtrEncoding();
}

// ArraySubscriptExpr
CXSourceLocation_ clang_ArraySubscriptExpr_getRBracketLoc(CXArraySubscriptExpr E) {
  return static_cast<clang::ArraySubscriptExpr *>(E)->getRBracketLoc().getPtrEncoding();
}

// DeclRefExpr
bool clang_DeclRefExpr_hasTemplateKWAndArgsInfo(CXDeclRefExpr E) {
  return static_cast<clang::DeclRefExpr *>(E)->hasTemplateKWAndArgsInfo();
}

CXSourceLocation_ clang_DeclRefExpr_getTemplateKeywordLoc(CXDeclRefExpr E) {
  return static_cast<clang::DeclRefExpr *>(E)->getTemplateKeywordLoc().getPtrEncoding();
}

CXSourceLocation_ clang_DeclRefExpr_getLAngleLoc(CXDeclRefExpr E) {
  return static_cast<clang::DeclRefExpr *>(E)->getLAngleLoc().getPtrEncoding();
}

CXSourceLocation_ clang_DeclRefExpr_getRAngleLoc(CXDeclRefExpr E) {
  return static_cast<clang::DeclRefExpr *>(E)->getRAngleLoc().getPtrEncoding();
}

bool clang_DeclRefExpr_hasTemplateKeyword(CXDeclRefExpr E) {
  return static_cast<clang::DeclRefExpr *>(E)->hasTemplateKeyword();
}

bool clang_DeclRefExpr_hasExplicitTemplateArgs(CXDeclRefExpr E) {
  return static_cast<clang::DeclRefExpr *>(E)->hasExplicitTemplateArgs();
}

unsigned clang_DeclRefExpr_getNumTemplateArgs(CXDeclRefExpr E) {
  return static_cast<clang::DeclRefExpr *>(E)->getNumTemplateArgs();
}

bool clang_DeclRefExpr_hadMultipleCandidates(CXDeclRefExpr E) {
  return static_cast<clang::DeclRefExpr *>(E)->hadMultipleCandidates();
}

bool clang_DeclRefExpr_refersToEnclosingVariableOrCapture(CXDeclRefExpr E) {
  return static_cast<clang::DeclRefExpr *>(E)->refersToEnclosingVariableOrCapture();
}

bool clang_DeclRefExpr_isImmediateEscalating(CXDeclRefExpr E) {
  return static_cast<clang::DeclRefExpr *>(E)->isImmediateEscalating();
}

bool clang_DeclRefExpr_isCapturedByCopyInLambdaWithExplicitObjectParameter(CXDeclRefExpr E) {
  return static_cast<clang::DeclRefExpr *>(E)->isCapturedByCopyInLambdaWithExplicitObjectParameter();
}

// CastExpr
bool clang_CastExpr_path_empty(CXCastExpr E) {
  return static_cast<clang::CastExpr *>(E)->path_empty();
}

unsigned clang_CastExpr_path_size(CXCastExpr E) {
  return static_cast<clang::CastExpr *>(E)->path_size();
}

bool clang_CastExpr_hasStoredFPFeatures(CXCastExpr E) {
  return static_cast<clang::CastExpr *>(E)->hasStoredFPFeatures();
}

bool clang_CastExpr_changesVolatileQualification(CXCastExpr E) {
  return static_cast<clang::CastExpr *>(E)->changesVolatileQualification();
}

// ConstantExpr
bool clang_ConstantExpr_isImmediateInvocation(CXConstantExpr E) {
  return static_cast<clang::ConstantExpr *>(E)->isImmediateInvocation();
}

bool clang_ConstantExpr_hasAPValueResult(CXConstantExpr E) {
  return static_cast<clang::ConstantExpr *>(E)->hasAPValueResult();
}

// StmtExpr
CXSourceLocation_ clang_StmtExpr_getLParenLoc(CXStmtExpr E) {
  return static_cast<clang::StmtExpr *>(E)->getLParenLoc().getPtrEncoding();
}

CXSourceLocation_ clang_StmtExpr_getRParenLoc(CXStmtExpr E) {
  return static_cast<clang::StmtExpr *>(E)->getRParenLoc().getPtrEncoding();
}

unsigned clang_StmtExpr_getTemplateDepth(CXStmtExpr E) {
  return static_cast<clang::StmtExpr *>(E)->getTemplateDepth();
}

// CompoundLiteralExpr
bool clang_CompoundLiteralExpr_isFileScope(CXCompoundLiteralExpr E) {
  return static_cast<clang::CompoundLiteralExpr *>(E)->isFileScope();
}

CXSourceLocation_ clang_CompoundLiteralExpr_getLParenLoc(CXCompoundLiteralExpr E) {
  return static_cast<clang::CompoundLiteralExpr *>(E)->getLParenLoc().getPtrEncoding();
}


// UnaryExprOrTypeTraitExpr
CXTypeSourceInfo clang_UnaryExprOrTypeTraitExpr_getArgumentTypeInfo(CXUnaryExprOrTypeTraitExpr E) {
  return const_cast<clang::TypeSourceInfo *>(static_cast<clang::UnaryExprOrTypeTraitExpr *>(E)->getArgumentTypeInfo());
}

CXExpr clang_UnaryExprOrTypeTraitExpr_getArgumentExpr(CXUnaryExprOrTypeTraitExpr E) {
  return const_cast<clang::Expr *>(static_cast<clang::UnaryExprOrTypeTraitExpr *>(E)->getArgumentExpr());
}

// MemberExpr
CXNestedNameSpecifier clang_MemberExpr_getQualifier(CXMemberExpr E) {
  return const_cast<clang::NestedNameSpecifier *>(static_cast<clang::MemberExpr *>(E)->getQualifier());
}

// InitListExpr
CXExpr clang_InitListExpr_getArrayFiller(CXInitListExpr E) {
  return const_cast<clang::Expr *>(static_cast<clang::InitListExpr *>(E)->getArrayFiller());
}

CXFieldDecl clang_InitListExpr_getInitializedFieldInUnion(CXInitListExpr E) {
  return const_cast<clang::FieldDecl *>(static_cast<clang::InitListExpr *>(E)->getInitializedFieldInUnion());
}

CXInitListExpr clang_InitListExpr_getSemanticForm(CXInitListExpr E) {
  return const_cast<clang::InitListExpr *>(static_cast<clang::InitListExpr *>(E)->getSemanticForm());
}

// DeclRefExpr
CXNestedNameSpecifier clang_DeclRefExpr_getQualifier(CXDeclRefExpr E) {
  return const_cast<clang::NestedNameSpecifier *>(static_cast<clang::DeclRefExpr *>(E)->getQualifier());
}

// CastExpr
CXNamedDecl clang_CastExpr_getConversionFunction(CXCastExpr E) {
  return const_cast<clang::NamedDecl *>(static_cast<clang::CastExpr *>(E)->getConversionFunction());
}

CXFieldDecl clang_CastExpr_getTargetUnionField(CXCastExpr E) {
  return const_cast<clang::FieldDecl *>(static_cast<clang::CastExpr *>(E)->getTargetUnionField());
}

// StmtExpr
CXCompoundStmt clang_StmtExpr_getSubStmt(CXStmtExpr E) {
  return const_cast<clang::CompoundStmt *>(static_cast<clang::StmtExpr *>(E)->getSubStmt());
}

// CompoundLiteralExpr
CXExpr clang_CompoundLiteralExpr_getInitializer(CXCompoundLiteralExpr E) {
  return const_cast<clang::Expr *>(static_cast<clang::CompoundLiteralExpr *>(E)->getInitializer());
}

CXTypeSourceInfo clang_CompoundLiteralExpr_getTypeSourceInfo(CXCompoundLiteralExpr E) {
  return const_cast<clang::TypeSourceInfo *>(static_cast<clang::CompoundLiteralExpr *>(E)->getTypeSourceInfo());
}

