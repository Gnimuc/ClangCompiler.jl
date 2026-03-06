#include "clang-ex/AST/CXExpr.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/Expr.h"
#include "clang/Basic/LangOptions.h"
#include "llvm/ExecutionEngine/GenericValue.h"

// Expr (base)
CXQualType clang_Expr_getType(CXExpr E) {
  return static_cast<clang::Expr *>(E)->getType().getAsOpaquePtr();
}

CXExprValueKind clang_Expr_getValueKind(CXExpr E) {
  return static_cast<CXExprValueKind>(static_cast<clang::Expr *>(E)->getValueKind());
}

bool clang_Expr_isLValue(CXExpr E) {
  return static_cast<clang::Expr *>(E)->isLValue();
}

bool clang_Expr_isPRValue(CXExpr E) {
  return static_cast<clang::Expr *>(E)->isPRValue();
}

bool clang_Expr_isXValue(CXExpr E) {
  return static_cast<clang::Expr *>(E)->isXValue();
}

bool clang_Expr_isGLValue(CXExpr E) {
  return static_cast<clang::Expr *>(E)->isGLValue();
}

bool clang_Expr_isIntegerConstantExpr(CXExpr E, CXASTContext Ctx) {
  return static_cast<clang::Expr *>(E)
      ->isIntegerConstantExpr(*static_cast<clang::ASTContext *>(Ctx))
      .has_value();
}

bool clang_Expr_isEvaluatable(CXExpr E, CXASTContext Ctx) {
  return static_cast<clang::Expr *>(E)->isEvaluatable(
      *static_cast<clang::ASTContext *>(Ctx));
}

CXSourceLocation_ clang_Expr_getExprLoc(CXExpr E) {
  return static_cast<clang::Expr *>(E)->getExprLoc().getPtrEncoding();
}

CXSourceLocation_ clang_Expr_getBeginLoc(CXExpr E) {
  return static_cast<clang::Expr *>(E)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_Expr_getEndLoc(CXExpr E) {
  return static_cast<clang::Expr *>(E)->getEndLoc().getPtrEncoding();
}

CXExpr clang_Expr_IgnoreParens(CXExpr E) {
  return static_cast<clang::Expr *>(E)->IgnoreParens();
}

CXExpr clang_Expr_IgnoreImpCasts(CXExpr E) {
  return static_cast<clang::Expr *>(E)->IgnoreImpCasts();
}

CXExpr clang_Expr_IgnoreParenImpCasts(CXExpr E) {
  return static_cast<clang::Expr *>(E)->IgnoreParenImpCasts();
}

CXExpr clang_Expr_IgnoreCasts(CXExpr E) {
  return static_cast<clang::Expr *>(E)->IgnoreCasts();
}

// DeclRefExpr
CXDeclRefExpr clang_DeclRefExpr_Create(CXASTContext Ctx, CXValueDecl D,
                                       CXQualType T, CXExprValueKind VK,
                                       CXSourceLocation_ L) {
  auto &C = *static_cast<clang::ASTContext *>(Ctx);
  auto *VD = static_cast<clang::ValueDecl *>(D);
  return clang::DeclRefExpr::Create(
      C, clang::NestedNameSpecifierLoc(), clang::SourceLocation(), VD, false,
      clang::SourceLocation::getFromPtrEncoding(L),
      clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::ExprValueKind>(VK));
}

CXValueDecl clang_DeclRefExpr_getDecl(CXDeclRefExpr E) {
  return static_cast<clang::DeclRefExpr *>(E)->getDecl();
}

CXSourceLocation_ clang_DeclRefExpr_getLocation(CXDeclRefExpr E) {
  return static_cast<clang::DeclRefExpr *>(E)->getLocation().getPtrEncoding();
}

CXSourceLocation_ clang_DeclRefExpr_getBeginLoc(CXDeclRefExpr E) {
  return static_cast<clang::DeclRefExpr *>(E)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_DeclRefExpr_getEndLoc(CXDeclRefExpr E) {
  return static_cast<clang::DeclRefExpr *>(E)->getEndLoc().getPtrEncoding();
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

// FloatingLiteral
CXFloatingLiteral clang_FloatingLiteral_Create(CXASTContext C, LLVMGenericValueRef Val,
                                               bool IsExact, CXQualType T,
                                               CXSourceLocation_ L) {
  auto &Ctx = *static_cast<clang::ASTContext *>(C);
  auto QT = clang::QualType::getFromOpaquePtr(T);
  const llvm::fltSemantics &Sem = Ctx.getFloatTypeSemantics(QT);
  llvm::APFloat APF(Sem, reinterpret_cast<llvm::GenericValue *>(Val)->DoubleVal);
  return clang::FloatingLiteral::Create(Ctx, APF, IsExact, QT,
                                        clang::SourceLocation::getFromPtrEncoding(L));
}

double clang_FloatingLiteral_getValueAsApproximateDouble(CXFloatingLiteral FL) {
  return static_cast<clang::FloatingLiteral *>(FL)->getValueAsApproximateDouble();
}

CXSourceLocation_ clang_FloatingLiteral_getLocation(CXFloatingLiteral FL) {
  return static_cast<clang::FloatingLiteral *>(FL)->getLocation().getPtrEncoding();
}

void clang_FloatingLiteral_setLocation(CXFloatingLiteral FL, CXSourceLocation_ L) {
  static_cast<clang::FloatingLiteral *>(FL)->setLocation(
      clang::SourceLocation::getFromPtrEncoding(L));
}

CXSourceLocation_ clang_FloatingLiteral_getBeginLoc(CXFloatingLiteral FL) {
  return static_cast<clang::FloatingLiteral *>(FL)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_FloatingLiteral_getEndLoc(CXFloatingLiteral FL) {
  return static_cast<clang::FloatingLiteral *>(FL)->getEndLoc().getPtrEncoding();
}

// CharacterLiteral
CXCharacterLiteral clang_CharacterLiteral_Create(CXASTContext C, unsigned Val,
                                                 CXQualType T, CXSourceLocation_ L) {
  return new (*static_cast<clang::ASTContext *>(C)) clang::CharacterLiteral(
      Val, clang::CharacterLiteralKind::Ascii, clang::QualType::getFromOpaquePtr(T),
      clang::SourceLocation::getFromPtrEncoding(L));
}

unsigned clang_CharacterLiteral_getValue(CXCharacterLiteral CL) {
  return static_cast<clang::CharacterLiteral *>(CL)->getValue();
}

CXSourceLocation_ clang_CharacterLiteral_getLocation(CXCharacterLiteral CL) {
  return static_cast<clang::CharacterLiteral *>(CL)->getLocation().getPtrEncoding();
}

void clang_CharacterLiteral_setLocation(CXCharacterLiteral CL, CXSourceLocation_ L) {
  static_cast<clang::CharacterLiteral *>(CL)->setLocation(
      clang::SourceLocation::getFromPtrEncoding(L));
}

CXSourceLocation_ clang_CharacterLiteral_getBeginLoc(CXCharacterLiteral CL) {
  return static_cast<clang::CharacterLiteral *>(CL)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_CharacterLiteral_getEndLoc(CXCharacterLiteral CL) {
  return static_cast<clang::CharacterLiteral *>(CL)->getEndLoc().getPtrEncoding();
}

// StringLiteral
CXSourceLocation_ clang_StringLiteral_getBeginLoc(CXStringLiteral SL) {
  return static_cast<clang::StringLiteral *>(SL)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_StringLiteral_getEndLoc(CXStringLiteral SL) {
  return static_cast<clang::StringLiteral *>(SL)->getEndLoc().getPtrEncoding();
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

CXSourceLocation_ clang_ParenExpr_getLParen(CXParenExpr PE) {
  return static_cast<clang::ParenExpr *>(PE)->getLParen().getPtrEncoding();
}

CXSourceLocation_ clang_ParenExpr_getRParen(CXParenExpr PE) {
  return static_cast<clang::ParenExpr *>(PE)->getRParen().getPtrEncoding();
}

CXSourceLocation_ clang_ParenExpr_getBeginLoc(CXParenExpr PE) {
  return static_cast<clang::ParenExpr *>(PE)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_ParenExpr_getEndLoc(CXParenExpr PE) {
  return static_cast<clang::ParenExpr *>(PE)->getEndLoc().getPtrEncoding();
}

// UnaryOperator
CXUnaryOperator clang_UnaryOperator_Create(CXASTContext C, CXExpr Input,
                                           CXUnaryOperatorKind Opc, CXQualType T,
                                           CXExprValueKind VK, CXSourceLocation_ L,
                                           bool CanOverflow) {
  return clang::UnaryOperator::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::Expr *>(Input),
      static_cast<clang::UnaryOperatorKind>(Opc), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::ExprValueKind>(VK), clang::OK_Ordinary,
      clang::SourceLocation::getFromPtrEncoding(L), CanOverflow,
      clang::FPOptionsOverride());
}

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

void clang_UnaryOperator_setOperatorLoc(CXUnaryOperator UO, CXSourceLocation_ L) {
  static_cast<clang::UnaryOperator *>(UO)->setOperatorLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

CXSourceLocation_ clang_UnaryOperator_getBeginLoc(CXUnaryOperator UO) {
  return static_cast<clang::UnaryOperator *>(UO)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_UnaryOperator_getEndLoc(CXUnaryOperator UO) {
  return static_cast<clang::UnaryOperator *>(UO)->getEndLoc().getPtrEncoding();
}

bool clang_UnaryOperator_isPrefix(CXUnaryOperatorKind Opc) {
  return clang::UnaryOperator::isPrefix(static_cast<clang::UnaryOperatorKind>(Opc));
}

bool clang_UnaryOperator_isPostfix(CXUnaryOperatorKind Opc) {
  return clang::UnaryOperator::isPostfix(static_cast<clang::UnaryOperatorKind>(Opc));
}

bool clang_UnaryOperator_isIncrementDecrementOp(CXUnaryOperatorKind Opc) {
  return clang::UnaryOperator::isIncrementDecrementOp(
      static_cast<clang::UnaryOperatorKind>(Opc));
}

bool clang_UnaryOperator_isArithmeticOp(CXUnaryOperatorKind Opc) {
  return clang::UnaryOperator::isArithmeticOp(
      static_cast<clang::UnaryOperatorKind>(Opc));
}

// BinaryOperator
CXBinaryOperator clang_BinaryOperator_Create(CXASTContext C, CXExpr LHS, CXExpr RHS,
                                             CXBinaryOperatorKind Opc, CXQualType T,
                                             CXExprValueKind VK, CXSourceLocation_ L) {
  return clang::BinaryOperator::Create(
      *static_cast<clang::ASTContext *>(C), static_cast<clang::Expr *>(LHS),
      static_cast<clang::Expr *>(RHS), static_cast<clang::BinaryOperatorKind>(Opc),
      clang::QualType::getFromOpaquePtr(T), static_cast<clang::ExprValueKind>(VK),
      clang::OK_Ordinary, clang::SourceLocation::getFromPtrEncoding(L),
      clang::FPOptionsOverride());
}

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

void clang_BinaryOperator_setOperatorLoc(CXBinaryOperator BO, CXSourceLocation_ L) {
  static_cast<clang::BinaryOperator *>(BO)->setOperatorLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

CXSourceLocation_ clang_BinaryOperator_getBeginLoc(CXBinaryOperator BO) {
  return static_cast<clang::BinaryOperator *>(BO)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_BinaryOperator_getEndLoc(CXBinaryOperator BO) {
  return static_cast<clang::BinaryOperator *>(BO)->getEndLoc().getPtrEncoding();
}

bool clang_BinaryOperator_isAssignmentOp(CXBinaryOperatorKind Opc) {
  return clang::BinaryOperator::isAssignmentOp(
      static_cast<clang::BinaryOperatorKind>(Opc));
}

bool clang_BinaryOperator_isCompoundAssignmentOp(CXBinaryOperatorKind Opc) {
  return clang::BinaryOperator::isCompoundAssignmentOp(
      static_cast<clang::BinaryOperatorKind>(Opc));
}

bool clang_BinaryOperator_isComparisonOp(CXBinaryOperatorKind Opc) {
  return clang::BinaryOperator::isComparisonOp(
      static_cast<clang::BinaryOperatorKind>(Opc));
}

bool clang_BinaryOperator_isLogicalOp(CXBinaryOperatorKind Opc) {
  return clang::BinaryOperator::isLogicalOp(
      static_cast<clang::BinaryOperatorKind>(Opc));
}

bool clang_BinaryOperator_isAdditiveOp(CXBinaryOperatorKind Opc) {
  return clang::BinaryOperator::isAdditiveOp(
      static_cast<clang::BinaryOperatorKind>(Opc));
}

bool clang_BinaryOperator_isMultiplicativeOp(CXBinaryOperatorKind Opc) {
  return clang::BinaryOperator::isMultiplicativeOp(
      static_cast<clang::BinaryOperatorKind>(Opc));
}

// CastExpr (base)
CXCastKind clang_CastExpr_getCastKind(CXCastExpr CE) {
  return static_cast<CXCastKind>(static_cast<clang::CastExpr *>(CE)->getCastKind());
}

CXExpr clang_CastExpr_getSubExpr(CXCastExpr CE) {
  return static_cast<clang::CastExpr *>(CE)->getSubExpr();
}

CXExpr clang_CastExpr_getSubExprAsWritten(CXCastExpr CE) {
  return static_cast<clang::CastExpr *>(CE)->getSubExprAsWritten();
}

// ImplicitCastExpr
CXImplicitCastExpr clang_ImplicitCastExpr_Create(CXASTContext C, CXQualType T,
                                                  CXCastKind K, CXExpr Op,
                                                  CXExprValueKind VK) {
  return clang::ImplicitCastExpr::Create(
      *static_cast<clang::ASTContext *>(C), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::CastKind>(K), static_cast<clang::Expr *>(Op), nullptr,
      static_cast<clang::ExprValueKind>(VK), clang::FPOptionsOverride());
}

CXSourceLocation_ clang_ImplicitCastExpr_getBeginLoc(CXImplicitCastExpr ICE) {
  return static_cast<clang::ImplicitCastExpr *>(ICE)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_ImplicitCastExpr_getEndLoc(CXImplicitCastExpr ICE) {
  return static_cast<clang::ImplicitCastExpr *>(ICE)->getEndLoc().getPtrEncoding();
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

// CallExpr
CXExpr clang_CallExpr_getCallee(CXCallExpr CE) {
  return static_cast<clang::CallExpr *>(CE)->getCallee();
}

unsigned clang_CallExpr_getNumArgs(CXCallExpr CE) {
  return static_cast<clang::CallExpr *>(CE)->getNumArgs();
}

CXExpr clang_CallExpr_getArg(CXCallExpr CE, unsigned Idx) {
  return static_cast<clang::CallExpr *>(CE)->getArg(Idx);
}

void clang_CallExpr_setArg(CXCallExpr CE, unsigned Idx, CXExpr Arg) {
  static_cast<clang::CallExpr *>(CE)->setArg(Idx, static_cast<clang::Expr *>(Arg));
}

CXSourceLocation_ clang_CallExpr_getBeginLoc(CXCallExpr CE) {
  return static_cast<clang::CallExpr *>(CE)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_CallExpr_getEndLoc(CXCallExpr CE) {
  return static_cast<clang::CallExpr *>(CE)->getEndLoc().getPtrEncoding();
}

CXQualType clang_CallExpr_getCallReturnType(CXCallExpr CE, CXASTContext Ctx) {
  return static_cast<clang::CallExpr *>(CE)
      ->getCallReturnType(*static_cast<clang::ASTContext *>(Ctx))
      .getAsOpaquePtr();
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

CXSourceLocation_ clang_MemberExpr_getBeginLoc(CXMemberExpr ME) {
  return static_cast<clang::MemberExpr *>(ME)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_MemberExpr_getEndLoc(CXMemberExpr ME) {
  return static_cast<clang::MemberExpr *>(ME)->getEndLoc().getPtrEncoding();
}

// ArraySubscriptExpr
CXExpr clang_ArraySubscriptExpr_getBase(CXArraySubscriptExpr ASE) {
  return static_cast<clang::ArraySubscriptExpr *>(ASE)->getBase();
}

CXExpr clang_ArraySubscriptExpr_getIdx(CXArraySubscriptExpr ASE) {
  return static_cast<clang::ArraySubscriptExpr *>(ASE)->getIdx();
}

CXExpr clang_ArraySubscriptExpr_getLHS(CXArraySubscriptExpr ASE) {
  return static_cast<clang::ArraySubscriptExpr *>(ASE)->getLHS();
}

CXExpr clang_ArraySubscriptExpr_getRHS(CXArraySubscriptExpr ASE) {
  return static_cast<clang::ArraySubscriptExpr *>(ASE)->getRHS();
}

CXSourceLocation_ clang_ArraySubscriptExpr_getBeginLoc(CXArraySubscriptExpr ASE) {
  return static_cast<clang::ArraySubscriptExpr *>(ASE)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_ArraySubscriptExpr_getEndLoc(CXArraySubscriptExpr ASE) {
  return static_cast<clang::ArraySubscriptExpr *>(ASE)->getEndLoc().getPtrEncoding();
}

// ConditionalOperator
CXExpr clang_ConditionalOperator_getCond(CXConditionalOperator CO) {
  return static_cast<clang::ConditionalOperator *>(CO)->getCond();
}

CXExpr clang_ConditionalOperator_getTrueExpr(CXConditionalOperator CO) {
  return static_cast<clang::ConditionalOperator *>(CO)->getTrueExpr();
}

CXExpr clang_ConditionalOperator_getFalseExpr(CXConditionalOperator CO) {
  return static_cast<clang::ConditionalOperator *>(CO)->getFalseExpr();
}

CXSourceLocation_ clang_ConditionalOperator_getBeginLoc(CXConditionalOperator CO) {
  return static_cast<clang::ConditionalOperator *>(CO)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_ConditionalOperator_getEndLoc(CXConditionalOperator CO) {
  return static_cast<clang::ConditionalOperator *>(CO)->getEndLoc().getPtrEncoding();
}

// InitListExpr
unsigned clang_InitListExpr_getNumInits(CXInitListExpr ILE) {
  return static_cast<clang::InitListExpr *>(ILE)->getNumInits();
}

CXExpr clang_InitListExpr_getInit(CXInitListExpr ILE, unsigned Idx) {
  return static_cast<clang::InitListExpr *>(ILE)->getInit(Idx);
}

CXExpr clang_InitListExpr_getArrayFiller(CXInitListExpr ILE) {
  return static_cast<clang::InitListExpr *>(ILE)->getArrayFiller();
}

bool clang_InitListExpr_hasArrayFiller(CXInitListExpr ILE) {
  return static_cast<clang::InitListExpr *>(ILE)->hasArrayFiller();
}

CXSourceLocation_ clang_InitListExpr_getBeginLoc(CXInitListExpr ILE) {
  return static_cast<clang::InitListExpr *>(ILE)->getBeginLoc().getPtrEncoding();
}

CXSourceLocation_ clang_InitListExpr_getEndLoc(CXInitListExpr ILE) {
  return static_cast<clang::InitListExpr *>(ILE)->getEndLoc().getPtrEncoding();
}
