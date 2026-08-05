#include "clang-ex/AST/CXExpr.h"
#include "utils.h"
#include "clang/AST/APValue.h"
#include "clang/AST/ASTContext.h"
#include "clang/AST/DeclCXX.h"
#include "clang/AST/Expr.h"
#include "clang/Basic/LangOptions.h"
#include "llvm/ExecutionEngine/GenericValue.h"
#include "clang/Basic/PartialDiagnostic.h"
#include "clang/Basic/SourceManager.h"
#include "clang/Basic/TargetInfo.h"
#include "llvm/ADT/SmallVector.h"
#include "llvm/Support/raw_ostream.h"

// Expr::Classification
namespace {
// clang::Expr::Classification keeps "was modifiability tested" in a private member
// that only clang::Expr may read, and getModifiable() asserts on it. The box carries
// that flag next to the boxed value so the Julia layer can restate the precondition
// (MARSHALLING.md §13) instead of tripping the assert.
struct ClassificationBox {
  clang::Expr::Classification Value;
  bool Tested;

  ClassificationBox(clang::Expr::Classification V, bool T) : Value(V), Tested(T) {}
};
} // namespace

CXClassification clang_Expr_Classify(CXExpr E, CXASTContext Ctx) {
  return reinterpret_cast<CXClassification>(new ClassificationBox(
      reinterpret_cast<clang::Expr *>(E)->Classify(*reinterpret_cast<clang::ASTContext *>(Ctx)),
      false));
}

CXClassification clang_Expr_ClassifyModifiable(CXExpr E, CXASTContext Ctx,
                                               CXSourceLocation_ *Loc) {
  clang::SourceLocation L;
  clang::Expr::Classification C = reinterpret_cast<clang::Expr *>(E)->ClassifyModifiable(
      *reinterpret_cast<clang::ASTContext *>(Ctx), L);
  *Loc = reinterpret_cast<CXSourceLocation_>(L.getPtrEncoding());
  return reinterpret_cast<CXClassification>(new ClassificationBox(C, true));
}

CXClassification clang_Classification_makeSimpleLValue(void) {
  return reinterpret_cast<CXClassification>(new ClassificationBox(clang::Expr::Classification::makeSimpleLValue(), true));
}

void clang_Classification_dispose(CXClassification C) {
  delete reinterpret_cast<ClassificationBox *>(C);
}

CXClassification_Kinds clang_Classification_getKind(CXClassification C) {
  return static_cast<CXClassification_Kinds>(
      reinterpret_cast<ClassificationBox *>(C)->Value.getKind());
}

bool clang_Classification_isModifiableTested(CXClassification C) {
  return reinterpret_cast<ClassificationBox *>(C)->Tested;
}

CXClassification_ModifiableType clang_Classification_getModifiable(CXClassification C) {
  return static_cast<CXClassification_ModifiableType>(
      reinterpret_cast<ClassificationBox *>(C)->Value.getModifiable());
}

bool clang_Classification_isLValue(CXClassification C) {
  return reinterpret_cast<ClassificationBox *>(C)->Value.isLValue();
}

bool clang_Classification_isXValue(CXClassification C) {
  return reinterpret_cast<ClassificationBox *>(C)->Value.isXValue();
}

bool clang_Classification_isGLValue(CXClassification C) {
  return reinterpret_cast<ClassificationBox *>(C)->Value.isGLValue();
}

bool clang_Classification_isPRValue(CXClassification C) {
  return reinterpret_cast<ClassificationBox *>(C)->Value.isPRValue();
}

bool clang_Classification_isRValue(CXClassification C) {
  return reinterpret_cast<ClassificationBox *>(C)->Value.isRValue();
}

bool clang_Classification_isModifiable(CXClassification C) {
  return reinterpret_cast<ClassificationBox *>(C)->Value.isModifiable();
}

// Expr
bool clang_Expr_isOBJCGCCandidate(CXExpr E, CXASTContext Ctx) {
  return reinterpret_cast<clang::Expr *>(E)->isOBJCGCCandidate(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

// BinaryOperator
uint64_t clang_BinaryOperator_getFPFeatures(CXBinaryOperator BO) {
  return reinterpret_cast<clang::BinaryOperator *>(BO)->getFPFeatures().getAsOpaqueInt();
}

uint64_t clang_BinaryOperator_getStoredFPFeatures(CXBinaryOperator BO) {
  return reinterpret_cast<clang::BinaryOperator *>(BO)->getStoredFPFeatures().getAsOpaqueInt();
}

// CallExpr
uint64_t clang_CallExpr_getFPFeatures(CXCallExpr E) {
  return reinterpret_cast<clang::CallExpr *>(E)->getFPFeatures().getAsOpaqueInt();
}

uint64_t clang_CallExpr_getStoredFPFeatures(CXCallExpr E) {
  return reinterpret_cast<clang::CallExpr *>(E)->getStoredFPFeatures().getAsOpaqueInt();
}

// UnaryOperator
uint64_t clang_UnaryOperator_getFPOptionsOverride(CXUnaryOperator E) {
  return reinterpret_cast<clang::UnaryOperator *>(E)->getFPOptionsOverride().getAsOpaqueInt();
}

uint64_t clang_UnaryOperator_getStoredFPFeatures(CXUnaryOperator E) {
  return reinterpret_cast<clang::UnaryOperator *>(E)->getStoredFPFeatures().getAsOpaqueInt();
}

// AtomicExpr
unsigned clang_AtomicExpr_getOp(CXAtomicExpr E) {
  return static_cast<unsigned>(reinterpret_cast<clang::AtomicExpr *>(E)->getOp());
}

CXString clang_AtomicExpr_getOpAsString(CXAtomicExpr E) {
  return extra::makeCXString(reinterpret_cast<clang::AtomicExpr *>(E)->getOpAsString().str());
}

unsigned clang_AtomicExpr_getNumSubExprs(CXAtomicExpr E) {
  return reinterpret_cast<clang::AtomicExpr *>(E)->getNumSubExprs();
}

CXExpr clang_AtomicExpr_getSubExpr(CXAtomicExpr E, unsigned I) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::AtomicExpr *>(E)->getSubExprs()[I]);
}

bool clang_AtomicExpr_isCmpXChg(CXAtomicExpr E) {
  return reinterpret_cast<clang::AtomicExpr *>(E)->isCmpXChg();
}

// GenericSelectionExpr
unsigned clang_GenericSelectionExpr_getNumAssocs(CXGenericSelectionExpr E) {
  return reinterpret_cast<clang::GenericSelectionExpr *>(E)->getNumAssocs();
}

bool clang_GenericSelectionExpr_isResultDependent(CXGenericSelectionExpr E) {
  return reinterpret_cast<clang::GenericSelectionExpr *>(E)->isResultDependent();
}

unsigned clang_GenericSelectionExpr_getResultIndex(CXGenericSelectionExpr E) {
  return reinterpret_cast<clang::GenericSelectionExpr *>(E)->getResultIndex();
}

bool clang_GenericSelectionExpr_isExprPredicate(CXGenericSelectionExpr E) {
  return reinterpret_cast<clang::GenericSelectionExpr *>(E)->isExprPredicate();
}

CXExpr clang_GenericSelectionExpr_getControllingExpr(CXGenericSelectionExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::GenericSelectionExpr *>(E)->getControllingExpr());
}

CXExpr clang_GenericSelectionExpr_getAssocExpr(CXGenericSelectionExpr E, unsigned I) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::GenericSelectionExpr *>(E)->getAssocExprs()[I]);
}

// ChooseExpr
CXExpr clang_ChooseExpr_getCond(CXChooseExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ChooseExpr *>(E)->getCond());
}

CXExpr clang_ChooseExpr_getLHS(CXChooseExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ChooseExpr *>(E)->getLHS());
}

CXExpr clang_ChooseExpr_getRHS(CXChooseExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ChooseExpr *>(E)->getRHS());
}

bool clang_ChooseExpr_isConditionDependent(CXChooseExpr E) {
  return reinterpret_cast<clang::ChooseExpr *>(E)->isConditionDependent();
}

bool clang_ChooseExpr_isConditionTrue(CXChooseExpr E) {
  return reinterpret_cast<clang::ChooseExpr *>(E)->isConditionTrue();
}

// ShuffleVectorExpr
unsigned clang_ShuffleVectorExpr_getNumSubExprs(CXShuffleVectorExpr E) {
  return reinterpret_cast<clang::ShuffleVectorExpr *>(E)->getNumSubExprs();
}

CXExpr clang_ShuffleVectorExpr_getExpr(CXShuffleVectorExpr E, unsigned Index) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ShuffleVectorExpr *>(E)->getExpr(Index));
}

// ExtVectorElementExpr
CXExpr clang_ExtVectorElementExpr_getBase(CXExtVectorElementExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ExtVectorElementExpr *>(E)->getBase());
}

unsigned clang_ExtVectorElementExpr_getNumElements(CXExtVectorElementExpr E) {
  return reinterpret_cast<clang::ExtVectorElementExpr *>(E)->getNumElements();
}

// Expr
CXQualType clang_Expr_getType(CXExpr E) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::Expr *>(E)->getType().getAsOpaquePtr());
}

CXExprValueKind clang_Expr_getValueKind(CXExpr E) {
  return static_cast<CXExprValueKind>(reinterpret_cast<clang::Expr *>(E)->getValueKind());
}

bool clang_Expr_isLValue(CXExpr E) { return reinterpret_cast<clang::Expr *>(E)->isLValue(); }

bool clang_Expr_isPRValue(CXExpr E) { return reinterpret_cast<clang::Expr *>(E)->isPRValue(); }

bool clang_Expr_isXValue(CXExpr E) { return reinterpret_cast<clang::Expr *>(E)->isXValue(); }

bool clang_Expr_isGLValue(CXExpr E) { return reinterpret_cast<clang::Expr *>(E)->isGLValue(); }

CXExprObjectKind clang_Expr_getObjectKind(CXExpr E) {
  return static_cast<CXExprObjectKind>(reinterpret_cast<clang::Expr *>(E)->getObjectKind());
}

CXFieldDecl clang_Expr_getSourceBitField(CXExpr E) {
  return reinterpret_cast<CXFieldDecl>(reinterpret_cast<clang::Expr *>(E)->getSourceBitField());
}

CXDecl clang_Expr_getReferencedDeclOfCallee(CXExpr E) {
  return reinterpret_cast<CXDecl>(reinterpret_cast<clang::Expr *>(E)->getReferencedDeclOfCallee());
}

CXCXXRecordDecl clang_Expr_getBestDynamicClassType(CXExpr E) {
  return reinterpret_cast<CXCXXRecordDecl>(const_cast<clang::CXXRecordDecl *>(
      reinterpret_cast<clang::Expr *>(E)->getBestDynamicClassType()));
}

bool clang_Expr_isKnownToHaveBooleanValue(CXExpr E, bool Semantic) {
  return reinterpret_cast<clang::Expr *>(E)->isKnownToHaveBooleanValue(Semantic);
}

CXExpr clang_Expr_IgnoreImplicit(CXExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::Expr *>(E)->IgnoreImplicit());
}

CXExpr clang_Expr_IgnoreImplicitAsWritten(CXExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::Expr *>(E)->IgnoreImplicitAsWritten());
}

CXExpr clang_Expr_IgnoreParenBaseCasts(CXExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::Expr *>(E)->IgnoreParenBaseCasts());
}

CXExpr clang_Expr_IgnoreParenLValueCasts(CXExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::Expr *>(E)->IgnoreParenLValueCasts());
}

CXExpr clang_Expr_IgnoreUnlessSpelledInSource(CXExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::Expr *>(E)->IgnoreUnlessSpelledInSource());
}

CXExpr clang_Expr_IgnoreParenNoopCasts(CXExpr E, CXASTContext Ctx) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::Expr *>(E)->IgnoreParenNoopCasts(
      *reinterpret_cast<clang::ASTContext *>(Ctx)));
}

bool clang_Expr_isCXX98IntegralConstantExpr(CXExpr E, CXASTContext Ctx) {
  return reinterpret_cast<clang::Expr *>(E)->isCXX98IntegralConstantExpr(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

bool clang_Expr_isConstantInitializer(CXExpr E, CXASTContext Ctx, bool ForRef) {
  return reinterpret_cast<clang::Expr *>(E)->isConstantInitializer(
      *reinterpret_cast<clang::ASTContext *>(Ctx), ForRef);
}

CXValueDecl clang_Expr_getAsBuiltinConstantDeclRef(CXExpr E, CXASTContext Ctx) {
  return reinterpret_cast<CXValueDecl>(const_cast<clang::ValueDecl *>(
      reinterpret_cast<clang::Expr *>(E)->getAsBuiltinConstantDeclRef(
          *reinterpret_cast<clang::ASTContext *>(Ctx))));
}

bool clang_Expr_HasSideEffects(CXExpr E, CXASTContext Ctx, bool IncludePossibleEffects) {
  return reinterpret_cast<clang::Expr *>(E)->HasSideEffects(
      *reinterpret_cast<clang::ASTContext *>(Ctx), IncludePossibleEffects);
}

bool clang_Expr_hasNonTrivialCall(CXExpr E, CXASTContext Ctx) {
  return reinterpret_cast<clang::Expr *>(E)->hasNonTrivialCall(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

bool clang_Expr_isBoundMemberFunction(CXExpr E, CXASTContext Ctx) {
  return reinterpret_cast<clang::Expr *>(E)->isBoundMemberFunction(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

CXQualType clang_Expr_findBoundMemberType(CXExpr E) {
  return reinterpret_cast<CXQualType>(clang::Expr::findBoundMemberType(reinterpret_cast<clang::Expr *>(E))
      .getAsOpaquePtr());
}

bool clang_Expr_isSameComparisonOperand(CXExpr E1, CXExpr E2) {
  return clang::Expr::isSameComparisonOperand(reinterpret_cast<clang::Expr *>(E1),
                                              reinterpret_cast<clang::Expr *>(E2));
}

bool clang_Expr_isTemporaryObject(CXExpr E, CXASTContext Ctx, CXCXXRecordDecl TempTy) {
  return reinterpret_cast<clang::Expr *>(E)->isTemporaryObject(
      *reinterpret_cast<clang::ASTContext *>(Ctx),
      reinterpret_cast<clang::CXXRecordDecl *>(TempTy));
}

CXExprValueKind clang_Expr_getValueKindForType(CXQualType T) {
  return static_cast<CXExprValueKind>(
      clang::Expr::getValueKindForType(clang::QualType::getFromOpaquePtr(T)));
}

CXExpr_NullPointerConstantKind
clang_Expr_isNullPointerConstant(CXExpr E, CXASTContext Ctx,
                                 CXExpr_NullPointerConstantValueDependence NPC) {
  return static_cast<CXExpr_NullPointerConstantKind>(
      reinterpret_cast<clang::Expr *>(E)->isNullPointerConstant(
          *reinterpret_cast<clang::ASTContext *>(Ctx),
          static_cast<clang::Expr::NullPointerConstantValueDependence>(NPC)));
}

LLVMGenericValueRef clang_Expr_getIntegerConstantExpr(CXExpr E, CXASTContext Ctx) {
  std::optional<llvm::APSInt> Result =
      reinterpret_cast<clang::Expr *>(E)->getIntegerConstantExpr(
          *reinterpret_cast<clang::ASTContext *>(Ctx));
  if (!Result)
    return nullptr;
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = *Result;
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

LLVMGenericValueRef clang_Expr_EvaluateKnownConstInt(CXExpr E, CXASTContext Ctx) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = reinterpret_cast<clang::Expr *>(E)->EvaluateKnownConstInt(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

LLVMGenericValueRef clang_Expr_EvaluateKnownConstIntCheckOverflow(CXExpr E,
                                                                  CXASTContext Ctx) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = reinterpret_cast<clang::Expr *>(E)->EvaluateKnownConstIntCheckOverflow(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

CXAPValue clang_Expr_EvaluateAsLValue(CXExpr E, CXASTContext Ctx, bool InConstantContext) {
  clang::Expr::EvalResult Result;
  if (!reinterpret_cast<clang::Expr *>(E)->EvaluateAsLValue(
          Result, *reinterpret_cast<clang::ASTContext *>(Ctx), InConstantContext))
    return nullptr;
  return reinterpret_cast<CXAPValue>(new clang::APValue(Result.Val)); // NOLINT(*-owning-memory)
}

CXAPValue clang_Expr_EvaluateAsConstantExpr(CXExpr E, CXASTContext Ctx,
                                            CXExpr_ConstantExprKind Kind) {
  clang::Expr::EvalResult Result;
  if (!reinterpret_cast<clang::Expr *>(E)->EvaluateAsConstantExpr(
          Result, *reinterpret_cast<clang::ASTContext *>(Ctx),
          static_cast<clang::Expr::ConstantExprKind>(Kind)))
    return nullptr;
  return reinterpret_cast<CXAPValue>(new clang::APValue(Result.Val)); // NOLINT(*-owning-memory)
}

bool clang_Expr_tryEvaluateObjectSize(CXExpr E, CXASTContext Ctx, unsigned Type,
                                      uint64_t *Result) {
  return reinterpret_cast<clang::Expr *>(E)->tryEvaluateObjectSize(
      *Result, *reinterpret_cast<clang::ASTContext *>(Ctx), Type);
}

bool clang_Expr_tryEvaluateStrLen(CXExpr E, CXASTContext Ctx, uint64_t *Result) {
  return reinterpret_cast<clang::Expr *>(E)->tryEvaluateStrLen(
      *Result, *reinterpret_cast<clang::ASTContext *>(Ctx));
}

// BinaryOperator
CXBinaryOperatorKind clang_BinaryOperator_getOverloadedOpcode(CXOverloadedOperatorKind OO) {
  return static_cast<CXBinaryOperatorKind>(clang::BinaryOperator::getOverloadedOpcode(
      static_cast<clang::OverloadedOperatorKind>(OO)));
}

CXOverloadedOperatorKind
clang_BinaryOperator_getOverloadedOperator(CXBinaryOperatorKind Opc) {
  return static_cast<CXOverloadedOperatorKind>(
      clang::BinaryOperator::getOverloadedOperator(
          static_cast<clang::BinaryOperator::Opcode>(Opc)));
}

bool clang_BinaryOperator_isPtrMemOp(CXBinaryOperatorKind Opc) {
  return clang::BinaryOperator::isPtrMemOp(
      static_cast<clang::BinaryOperator::Opcode>(Opc));
}

bool clang_BinaryOperator_isMultiplicativeOp(CXBinaryOperatorKind Opc) {
  return clang::BinaryOperator::isMultiplicativeOp(
      static_cast<clang::BinaryOperator::Opcode>(Opc));
}

bool clang_BinaryOperator_isAdditiveOp(CXBinaryOperatorKind Opc) {
  return clang::BinaryOperator::isAdditiveOp(
      static_cast<clang::BinaryOperator::Opcode>(Opc));
}

bool clang_BinaryOperator_isShiftOp(CXBinaryOperatorKind Opc) {
  return clang::BinaryOperator::isShiftOp(
      static_cast<clang::BinaryOperator::Opcode>(Opc));
}

bool clang_BinaryOperator_isBitwiseOp(CXBinaryOperatorKind Opc) {
  return clang::BinaryOperator::isBitwiseOp(
      static_cast<clang::BinaryOperator::Opcode>(Opc));
}

bool clang_BinaryOperator_isRelationalOp(CXBinaryOperatorKind Opc) {
  return clang::BinaryOperator::isRelationalOp(
      static_cast<clang::BinaryOperator::Opcode>(Opc));
}

bool clang_BinaryOperator_isEqualityOp(CXBinaryOperatorKind Opc) {
  return clang::BinaryOperator::isEqualityOp(
      static_cast<clang::BinaryOperator::Opcode>(Opc));
}

bool clang_BinaryOperator_isCommaOp(CXBinaryOperatorKind Opc) {
  return clang::BinaryOperator::isCommaOp(
      static_cast<clang::BinaryOperator::Opcode>(Opc));
}

bool clang_BinaryOperator_isLogicalOp(CXBinaryOperatorKind Opc) {
  return clang::BinaryOperator::isLogicalOp(
      static_cast<clang::BinaryOperator::Opcode>(Opc));
}

bool clang_BinaryOperator_isShiftAssignOp(CXBinaryOperatorKind Opc) {
  return clang::BinaryOperator::isShiftAssignOp(
      static_cast<clang::BinaryOperator::Opcode>(Opc));
}

CXBinaryOperatorKind clang_BinaryOperator_negateComparisonOp(CXBinaryOperatorKind Opc) {
  return static_cast<CXBinaryOperatorKind>(clang::BinaryOperator::negateComparisonOp(
      static_cast<clang::BinaryOperator::Opcode>(Opc)));
}

CXBinaryOperatorKind clang_BinaryOperator_reverseComparisonOp(CXBinaryOperatorKind Opc) {
  return static_cast<CXBinaryOperatorKind>(clang::BinaryOperator::reverseComparisonOp(
      static_cast<clang::BinaryOperator::Opcode>(Opc)));
}

CXBinaryOperatorKind
clang_BinaryOperator_getOpForCompoundAssignment(CXBinaryOperatorKind Opc) {
  return static_cast<CXBinaryOperatorKind>(
      clang::BinaryOperator::getOpForCompoundAssignment(
          static_cast<clang::BinaryOperator::Opcode>(Opc)));
}

bool clang_BinaryOperator_isNullPointerArithmeticExtension(CXASTContext Ctx,
                                                           CXBinaryOperatorKind Opc,
                                                           CXExpr LHS, CXExpr RHS) {
  return clang::BinaryOperator::isNullPointerArithmeticExtension(
      *reinterpret_cast<clang::ASTContext *>(Ctx),
      static_cast<clang::BinaryOperator::Opcode>(Opc), reinterpret_cast<clang::Expr *>(LHS),
      reinterpret_cast<clang::Expr *>(RHS));
}

bool clang_BinaryOperator_hasStoredFPFeatures(CXBinaryOperator BO) {
  return reinterpret_cast<clang::BinaryOperator *>(BO)->hasStoredFPFeatures();
}

// UnaryOperator
const char *clang_UnaryOperator_getOpcodeStr(CXUnaryOperatorKind Op) {
  // the spelling table is static string literals: borrowed, NUL-terminated
  return clang::UnaryOperator::getOpcodeStr(
             static_cast<clang::UnaryOperator::Opcode>(Op))
      .data();
}

CXUnaryOperatorKind clang_UnaryOperator_getOverloadedOpcode(CXOverloadedOperatorKind OO,
                                                            bool Postfix) {
  return static_cast<CXUnaryOperatorKind>(clang::UnaryOperator::getOverloadedOpcode(
      static_cast<clang::OverloadedOperatorKind>(OO), Postfix));
}

CXOverloadedOperatorKind clang_UnaryOperator_getOverloadedOperator(CXUnaryOperatorKind Opc) {
  return static_cast<CXOverloadedOperatorKind>(
      clang::UnaryOperator::getOverloadedOperator(
          static_cast<clang::UnaryOperator::Opcode>(Opc)));
}

void clang_UnaryOperator_setOperatorLoc(CXUnaryOperator UO, CXSourceLocation_ L) {
  reinterpret_cast<clang::UnaryOperator *>(UO)->setOperatorLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

// CallExpr
CXQualType clang_CallExpr_getCallReturnType(CXCallExpr CE, CXASTContext Ctx) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::CallExpr *>(CE)
      ->getCallReturnType(*reinterpret_cast<clang::ASTContext *>(Ctx))
      .getAsOpaquePtr());
}

CXAttr clang_CallExpr_getUnusedResultAttr(CXCallExpr CE, CXASTContext Ctx) {
  return reinterpret_cast<CXAttr>(const_cast<clang::Attr *>(
      reinterpret_cast<clang::CallExpr *>(CE)->getUnusedResultAttr(
          *reinterpret_cast<clang::ASTContext *>(Ctx))));
}

bool clang_CallExpr_hasUnusedResultAttr(CXCallExpr CE, CXASTContext Ctx) {
  return reinterpret_cast<clang::CallExpr *>(CE)->hasUnusedResultAttr(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

bool clang_CallExpr_isUnevaluatedBuiltinCall(CXCallExpr CE, CXASTContext Ctx) {
  return reinterpret_cast<clang::CallExpr *>(CE)->isUnevaluatedBuiltinCall(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

bool clang_CallExpr_isBuiltinAssumeFalse(CXCallExpr CE, CXASTContext Ctx) {
  return reinterpret_cast<clang::CallExpr *>(CE)->isBuiltinAssumeFalse(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

void clang_CallExpr_setRParenLoc(CXCallExpr CE, CXSourceLocation_ L) {
  reinterpret_cast<clang::CallExpr *>(CE)->setRParenLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

// MemberExpr
CXNamedDecl clang_MemberExpr_getFoundDecl(CXMemberExpr E) {
  return reinterpret_cast<CXNamedDecl>(reinterpret_cast<clang::MemberExpr *>(E)->getFoundDecl().getDecl());
}

CXAccessSpecifier clang_MemberExpr_getFoundDeclAccess(CXMemberExpr E) {
  return static_cast<CXAccessSpecifier>(
      reinterpret_cast<clang::MemberExpr *>(E)->getFoundDecl().getAccess());
}

CXTemplateArgumentLoc clang_MemberExpr_getTemplateArg(CXMemberExpr E, unsigned I) {
  return reinterpret_cast<CXTemplateArgumentLoc>(const_cast<clang::TemplateArgumentLoc *>(
      reinterpret_cast<clang::MemberExpr *>(E)->getTemplateArgs() + I));
}

CXNonOdrUseReason clang_MemberExpr_isNonOdrUse(CXMemberExpr E) {
  return static_cast<CXNonOdrUseReason>(
      reinterpret_cast<clang::MemberExpr *>(E)->isNonOdrUse());
}

bool clang_MemberExpr_performsVirtualDispatch(CXMemberExpr E, CXLangOptions LO) {
  return reinterpret_cast<clang::MemberExpr *>(E)->performsVirtualDispatch(
      *reinterpret_cast<clang::LangOptions *>(LO));
}

void clang_MemberExpr_setMemberLoc(CXMemberExpr E, CXSourceLocation_ L) {
  reinterpret_cast<clang::MemberExpr *>(E)->setMemberLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

// DeclRefExpr
CXTemplateArgumentLoc clang_DeclRefExpr_getTemplateArg(CXDeclRefExpr E, unsigned I) {
  return reinterpret_cast<CXTemplateArgumentLoc>(const_cast<clang::TemplateArgumentLoc *>(
      reinterpret_cast<clang::DeclRefExpr *>(E)->getTemplateArgs() + I));
}

CXNonOdrUseReason clang_DeclRefExpr_isNonOdrUse(CXDeclRefExpr E) {
  return static_cast<CXNonOdrUseReason>(
      reinterpret_cast<clang::DeclRefExpr *>(E)->isNonOdrUse());
}

void clang_DeclRefExpr_setLocation(CXDeclRefExpr E, CXSourceLocation_ L) {
  reinterpret_cast<clang::DeclRefExpr *>(E)->setLocation(
      clang::SourceLocation::getFromPtrEncoding(L));
}

// CastExpr
CXFieldDecl clang_CastExpr_getTargetFieldForToUnionCast(CXQualType UnionType,
                                                        CXQualType OpType) {
  return reinterpret_cast<CXFieldDecl>(const_cast<clang::FieldDecl *>(clang::CastExpr::getTargetFieldForToUnionCast(
      clang::QualType::getFromOpaquePtr(UnionType),
      clang::QualType::getFromOpaquePtr(OpType))));
}

// ExplicitCastExpr
CXTypeSourceInfo clang_ExplicitCastExpr_getTypeInfoAsWritten(CXExplicitCastExpr E) {
  return reinterpret_cast<CXTypeSourceInfo>(reinterpret_cast<clang::ExplicitCastExpr *>(E)->getTypeInfoAsWritten());
}

// InitListExpr
bool clang_InitListExpr_isIdiomaticZeroInitializer(CXInitListExpr E, CXLangOptions LO) {
  return reinterpret_cast<clang::InitListExpr *>(E)->isIdiomaticZeroInitializer(
      *reinterpret_cast<clang::LangOptions *>(LO));
}

void clang_InitListExpr_setLBraceLoc(CXInitListExpr E, CXSourceLocation_ L) {
  reinterpret_cast<clang::InitListExpr *>(E)->setLBraceLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

void clang_InitListExpr_setRBraceLoc(CXInitListExpr E, CXSourceLocation_ L) {
  reinterpret_cast<clang::InitListExpr *>(E)->setRBraceLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

// AbstractConditionalOperator
CXSourceLocation_
clang_AbstractConditionalOperator_getQuestionLoc(CXAbstractConditionalOperator ACO) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::AbstractConditionalOperator *>(ACO)
      ->getQuestionLoc()
      .getPtrEncoding());
}

CXSourceLocation_
clang_AbstractConditionalOperator_getColonLoc(CXAbstractConditionalOperator ACO) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::AbstractConditionalOperator *>(ACO)
      ->getColonLoc()
      .getPtrEncoding());
}

// ParenListExpr
unsigned clang_ParenListExpr_getNumExprs(CXParenListExpr E) {
  return reinterpret_cast<clang::ParenListExpr *>(E)->getNumExprs();
}

CXExpr clang_ParenListExpr_getExpr(CXParenListExpr E, unsigned Init) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ParenListExpr *>(E)->getExpr(Init));
}

CXSourceLocation_ clang_ParenListExpr_getLParenLoc(CXParenListExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ParenListExpr *>(E)->getLParenLoc().getPtrEncoding());
}

CXSourceLocation_ clang_ParenListExpr_getRParenLoc(CXParenListExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ParenListExpr *>(E)->getRParenLoc().getPtrEncoding());
}

// ConstantExpr
LLVMGenericValueRef clang_ConstantExpr_getResultAsAPSInt(CXConstantExpr E) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = reinterpret_cast<clang::ConstantExpr *>(E)->getResultAsAPSInt();
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

CXAPValue clang_ConstantExpr_getAPValueResult(CXConstantExpr E) {
  return reinterpret_cast<CXAPValue>(new clang::APValue( // NOLINT(*-owning-memory)
      reinterpret_cast<clang::ConstantExpr *>(E)->getAPValueResult()));
}

// FloatingLiteral
LLVMGenericValueRef clang_FloatingLiteral_getValue(CXFloatingLiteral FL) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = reinterpret_cast<clang::FloatingLiteral *>(FL)->getValue().bitcastToAPInt();
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

bool clang_FloatingLiteral_isExact(CXFloatingLiteral FL) {
  return reinterpret_cast<clang::FloatingLiteral *>(FL)->isExact();
}

CXSourceLocation_ clang_FloatingLiteral_getLocation(CXFloatingLiteral FL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::FloatingLiteral *>(FL)->getLocation().getPtrEncoding());
}

void clang_FloatingLiteral_setLocation(CXFloatingLiteral FL, CXSourceLocation_ L) {
  reinterpret_cast<clang::FloatingLiteral *>(FL)->setLocation(
      clang::SourceLocation::getFromPtrEncoding(L));
}

// StringLiteral
unsigned clang_StringLiteral_getCodeUnit(CXStringLiteral SL, size_t I) {
  return reinterpret_cast<clang::StringLiteral *>(SL)->getCodeUnit(I);
}

CXSourceLocation_ clang_StringLiteral_getStrTokenLoc(CXStringLiteral SL, unsigned TokNum) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::StringLiteral *>(SL)->getStrTokenLoc(TokNum).getPtrEncoding());
}

// DesignatedInitExpr
unsigned clang_DesignatedInitExpr_size(CXDesignatedInitExpr E) {
  return reinterpret_cast<clang::DesignatedInitExpr *>(E)->size();
}

CXDesignator clang_DesignatedInitExpr_getDesignator(CXDesignatedInitExpr E, unsigned Idx) {
  return reinterpret_cast<CXDesignator>(reinterpret_cast<clang::DesignatedInitExpr *>(E)->getDesignator(Idx));
}

CXExpr clang_DesignatedInitExpr_getArrayIndex(CXDesignatedInitExpr E, CXDesignator D) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::DesignatedInitExpr *>(E)->getArrayIndex(
      *reinterpret_cast<clang::DesignatedInitExpr::Designator *>(D)));
}

CXExpr clang_DesignatedInitExpr_getArrayRangeStart(CXDesignatedInitExpr E, CXDesignator D) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::DesignatedInitExpr *>(E)->getArrayRangeStart(
      *reinterpret_cast<clang::DesignatedInitExpr::Designator *>(D)));
}

CXExpr clang_DesignatedInitExpr_getArrayRangeEnd(CXDesignatedInitExpr E, CXDesignator D) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::DesignatedInitExpr *>(E)->getArrayRangeEnd(
      *reinterpret_cast<clang::DesignatedInitExpr::Designator *>(D)));
}

CXSourceRange_ clang_DesignatedInitExpr_getDesignatorsSourceRange(CXDesignatedInitExpr E) {
  clang::SourceRange R =
      reinterpret_cast<clang::DesignatedInitExpr *>(E)->getDesignatorsSourceRange();
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

CXSourceLocation_ clang_DesignatedInitExpr_getEqualOrColonLoc(CXDesignatedInitExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DesignatedInitExpr *>(E)
      ->getEqualOrColonLoc()
      .getPtrEncoding());
}

bool clang_DesignatedInitExpr_isDirectInit(CXDesignatedInitExpr E) {
  return reinterpret_cast<clang::DesignatedInitExpr *>(E)->isDirectInit();
}

bool clang_DesignatedInitExpr_usesGNUSyntax(CXDesignatedInitExpr E) {
  return reinterpret_cast<clang::DesignatedInitExpr *>(E)->usesGNUSyntax();
}

CXExpr clang_DesignatedInitExpr_getInit(CXDesignatedInitExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::DesignatedInitExpr *>(E)->getInit());
}

unsigned clang_DesignatedInitExpr_getNumSubExprs(CXDesignatedInitExpr E) {
  return reinterpret_cast<clang::DesignatedInitExpr *>(E)->getNumSubExprs();
}

CXExpr clang_DesignatedInitExpr_getSubExpr(CXDesignatedInitExpr E, unsigned Idx) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::DesignatedInitExpr *>(E)->getSubExpr(Idx));
}

// DesignatedInitExpr::Designator
bool clang_Designator_isFieldDesignator(CXDesignator D) {
  return reinterpret_cast<clang::DesignatedInitExpr::Designator *>(D)->isFieldDesignator();
}

bool clang_Designator_isArrayDesignator(CXDesignator D) {
  return reinterpret_cast<clang::DesignatedInitExpr::Designator *>(D)->isArrayDesignator();
}

bool clang_Designator_isArrayRangeDesignator(CXDesignator D) {
  return reinterpret_cast<clang::DesignatedInitExpr::Designator *>(D)
      ->isArrayRangeDesignator();
}

CXIdentifierInfo clang_Designator_getFieldName(CXDesignator D) {
  return reinterpret_cast<CXIdentifierInfo>(const_cast<clang::IdentifierInfo *>(
      reinterpret_cast<clang::DesignatedInitExpr::Designator *>(D)->getFieldName()));
}

CXFieldDecl clang_Designator_getFieldDecl(CXDesignator D) {
  return reinterpret_cast<CXFieldDecl>(reinterpret_cast<clang::DesignatedInitExpr::Designator *>(D)->getFieldDecl());
}

CXSourceLocation_ clang_Designator_getDotLoc(CXDesignator D) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DesignatedInitExpr::Designator *>(D)
      ->getDotLoc()
      .getPtrEncoding());
}

CXSourceLocation_ clang_Designator_getFieldLoc(CXDesignator D) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DesignatedInitExpr::Designator *>(D)
      ->getFieldLoc()
      .getPtrEncoding());
}

unsigned clang_Designator_getArrayIndex(CXDesignator D) {
  return reinterpret_cast<clang::DesignatedInitExpr::Designator *>(D)->getArrayIndex();
}

CXSourceLocation_ clang_Designator_getLBracketLoc(CXDesignator D) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DesignatedInitExpr::Designator *>(D)
      ->getLBracketLoc()
      .getPtrEncoding());
}

CXSourceLocation_ clang_Designator_getEllipsisLoc(CXDesignator D) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DesignatedInitExpr::Designator *>(D)
      ->getEllipsisLoc()
      .getPtrEncoding());
}

CXSourceLocation_ clang_Designator_getRBracketLoc(CXDesignator D) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DesignatedInitExpr::Designator *>(D)
      ->getRBracketLoc()
      .getPtrEncoding());
}

CXSourceLocation_ clang_Designator_getBeginLoc(CXDesignator D) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DesignatedInitExpr::Designator *>(D)
      ->getBeginLoc()
      .getPtrEncoding());
}

CXSourceLocation_ clang_Designator_getEndLoc(CXDesignator D) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DesignatedInitExpr::Designator *>(D)
      ->getEndLoc()
      .getPtrEncoding());
}


CXExpr clang_Expr_IgnoreImpCasts(CXExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::Expr *>(E)->IgnoreImpCasts());
}

CXExpr clang_Expr_IgnoreCasts(CXExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::Expr *>(E)->IgnoreCasts());
}

CXExpr clang_Expr_IgnoreParens(CXExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::Expr *>(E)->IgnoreParens());
}

CXExpr clang_Expr_IgnoreParenCasts(CXExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::Expr *>(E)->IgnoreParenCasts());
}

CXExpr clang_Expr_IgnoreParenImpCasts(CXExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::Expr *>(E)->IgnoreParenImpCasts());
}

bool clang_Expr_containsErrors(CXExpr E) {
  return reinterpret_cast<clang::Expr *>(E)->containsErrors();
}

bool clang_Expr_containsUnexpandedParameterPack(CXExpr E) {
  return reinterpret_cast<clang::Expr *>(E)->containsUnexpandedParameterPack();
}

bool clang_Expr_hasPlaceholderType(CXExpr E) {
  return reinterpret_cast<clang::Expr *>(E)->hasPlaceholderType();
}

bool clang_Expr_isDefaultArgument(CXExpr E) {
  return reinterpret_cast<clang::Expr *>(E)->isDefaultArgument();
}

bool clang_Expr_isImplicitCXXThis(CXExpr E) {
  return reinterpret_cast<clang::Expr *>(E)->isImplicitCXXThis();
}

bool clang_Expr_isInstantiationDependent(CXExpr E) {
  return reinterpret_cast<clang::Expr *>(E)->isInstantiationDependent();
}

bool clang_Expr_isObjCSelfExpr(CXExpr E) {
  return reinterpret_cast<clang::Expr *>(E)->isObjCSelfExpr();
}

bool clang_Expr_isOrdinaryOrBitFieldObject(CXExpr E) {
  return reinterpret_cast<clang::Expr *>(E)->isOrdinaryOrBitFieldObject();
}

bool clang_Expr_isTypeDependent(CXExpr E) {
  return reinterpret_cast<clang::Expr *>(E)->isTypeDependent();
}

bool clang_Expr_isValueDependent(CXExpr E) {
  return reinterpret_cast<clang::Expr *>(E)->isValueDependent();
}

bool clang_Expr_refersToBitField(CXExpr E) {
  return reinterpret_cast<clang::Expr *>(E)->refersToBitField();
}

bool clang_Expr_refersToGlobalRegisterVar(CXExpr E) {
  return reinterpret_cast<clang::Expr *>(E)->refersToGlobalRegisterVar();
}

bool clang_Expr_refersToMatrixElement(CXExpr E) {
  return reinterpret_cast<clang::Expr *>(E)->refersToMatrixElement();
}

bool clang_Expr_refersToVectorElement(CXExpr E) {
  return reinterpret_cast<clang::Expr *>(E)->refersToVectorElement();
}

CXSourceLocation_ clang_Expr_getExprLoc(CXExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::Expr *>(E)->getExprLoc().getPtrEncoding());
}

CXAPValue clang_Expr_EvaluateAsRValue(CXExpr E, CXASTContext Ctx) {
  clang::Expr::EvalResult Result;
  if (!reinterpret_cast<clang::Expr *>(E)->EvaluateAsRValue(
          Result, *reinterpret_cast<clang::ASTContext *>(Ctx)))
    return nullptr;
  return reinterpret_cast<CXAPValue>(new clang::APValue(Result.Val)); // NOLINT(*-owning-memory)
}

bool clang_Expr_isEvaluatable(CXExpr E, CXASTContext Ctx) {
  return reinterpret_cast<clang::Expr *>(E)->isEvaluatable(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

bool clang_Expr_isIntegerConstantExpr(CXExpr E, CXASTContext Ctx) {
  return reinterpret_cast<clang::Expr *>(E)->isIntegerConstantExpr(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

bool clang_Expr_isCXX11ConstantExpr(CXExpr E, CXASTContext Ctx) {
  return reinterpret_cast<clang::Expr *>(E)->isCXX11ConstantExpr(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

int clang_Expr_EvaluateAsBooleanCondition(CXExpr E, CXASTContext Ctx) {
  bool Result = false;
  if (!reinterpret_cast<clang::Expr *>(E)->EvaluateAsBooleanCondition(
          Result, *reinterpret_cast<clang::ASTContext *>(Ctx)))
    return -1;
  return Result ? 1 : 0;
}

CXAPValue clang_Expr_EvaluateAsInt(CXExpr E, CXASTContext Ctx) {
  clang::Expr::EvalResult Result;
  if (!reinterpret_cast<clang::Expr *>(E)->EvaluateAsInt(
          Result, *reinterpret_cast<clang::ASTContext *>(Ctx)))
    return nullptr;
  return reinterpret_cast<CXAPValue>(new clang::APValue(Result.Val)); // NOLINT(*-owning-memory)
}

LLVMGenericValueRef clang_Expr_EvaluateAsFloat(CXExpr E, CXASTContext Ctx) {
  llvm::APFloat Result(0.0);
  if (!reinterpret_cast<clang::Expr *>(E)->EvaluateAsFloat(
          Result, *reinterpret_cast<clang::ASTContext *>(Ctx)))
    return nullptr;
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = Result.bitcastToAPInt();
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

// DeclRefExpr
CXValueDecl clang_DeclRefExpr_getDecl(CXDeclRefExpr DRE) {
  return reinterpret_cast<CXValueDecl>(reinterpret_cast<clang::DeclRefExpr *>(DRE)->getDecl());
}

CXNamedDecl clang_DeclRefExpr_getFoundDecl(CXDeclRefExpr DRE) {
  return reinterpret_cast<CXNamedDecl>(reinterpret_cast<clang::DeclRefExpr *>(DRE)->getFoundDecl());
}

bool clang_DeclRefExpr_hasQualifier(CXDeclRefExpr DRE) {
  return reinterpret_cast<clang::DeclRefExpr *>(DRE)->hasQualifier();
}

CXSourceLocation_ clang_DeclRefExpr_getLocation(CXDeclRefExpr DRE) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DeclRefExpr *>(DRE)->getLocation().getPtrEncoding());
}

CXDeclarationNameInfo clang_DeclRefExpr_getNameInfo(CXDeclRefExpr DRE) {
  return reinterpret_cast<CXDeclarationNameInfo>(std::make_unique<clang::DeclarationNameInfo>(
             reinterpret_cast<clang::DeclRefExpr *>(DRE)->getNameInfo())
      .release());
}

// IntegerLiteral
CXIntegerLiteral clang_IntegerLiteral_Create(CXASTContext C, LLVMGenericValueRef Val,
                                             CXQualType T, CXSourceLocation_ L) {
  return reinterpret_cast<CXIntegerLiteral>(clang::IntegerLiteral::Create(
      *reinterpret_cast<clang::ASTContext *>(C),
      llvm::APSInt(reinterpret_cast<llvm::GenericValue *>(Val)->IntVal),
      clang::QualType::getFromOpaquePtr(T), clang::SourceLocation::getFromPtrEncoding(L)));
}

CXSourceLocation_ clang_IntegerLiteral_getBeginLoc(CXIntegerLiteral IL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::IntegerLiteral *>(IL)->getBeginLoc().getPtrEncoding());
}

CXSourceLocation_ clang_IntegerLiteral_getEndLoc(CXIntegerLiteral IL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::IntegerLiteral *>(IL)->getEndLoc().getPtrEncoding());
}

CXSourceLocation_ clang_IntegerLiteral_getLocation(CXIntegerLiteral IL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::IntegerLiteral *>(IL)->getLocation().getPtrEncoding());
}

void clang_IntegerLiteral_setLocation(CXIntegerLiteral IL, CXSourceLocation_ L) {
  reinterpret_cast<clang::IntegerLiteral *>(IL)->setLocation(
      clang::SourceLocation::getFromPtrEncoding(L));
}

// CStyleCastExpr
CXCStyleCastExpr clang_CStyleCastExpr_CreateWithNoTypeInfo(CXASTContext C, CXQualType T,
                                                           CXExprValueKind VK, CXCastKind K,
                                                           CXExpr Op) {
  return reinterpret_cast<CXCStyleCastExpr>(clang::CStyleCastExpr::Create(
      *reinterpret_cast<clang::ASTContext *>(C), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::ExprValueKind>(VK), static_cast<clang::CastKind>(K),
      reinterpret_cast<clang::Expr *>(Op), nullptr, clang::FPOptionsOverride(),
      reinterpret_cast<clang::ASTContext *>(C)->getTrivialTypeSourceInfo(
          clang::QualType::getFromOpaquePtr(T), clang::SourceLocation()),
      clang::SourceLocation(), clang::SourceLocation()));
}

CXCStyleCastExpr clang_CStyleCastExpr_CreateEmpty(CXASTContext C, unsigned PathSize,
                                                  bool HasFPFeatures) {
  return reinterpret_cast<CXCStyleCastExpr>(clang::CStyleCastExpr::CreateEmpty(*reinterpret_cast<clang::ASTContext *>(C), PathSize,
                                            HasFPFeatures));
}

CXSourceLocation_ clang_CStyleCastExpr_getLParenLoc(CXCStyleCastExpr CSCE) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::CStyleCastExpr *>(CSCE)->getLParenLoc().getPtrEncoding());
}

void clang_CStyleCastExpr_setLParenLoc(CXCStyleCastExpr CSCE, CXSourceLocation_ L) {
  reinterpret_cast<clang::CStyleCastExpr *>(CSCE)->setLParenLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

CXSourceLocation_ clang_CStyleCastExpr_getRParenLoc(CXCStyleCastExpr CSCE) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::CStyleCastExpr *>(CSCE)->getRParenLoc().getPtrEncoding());
}

void clang_CStyleCastExpr_setRParenLoc(CXCStyleCastExpr CSCE, CXSourceLocation_ L) {
  reinterpret_cast<clang::CStyleCastExpr *>(CSCE)->setRParenLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

CXSourceLocation_ clang_CStyleCastExpr_getBeginLoc(CXCStyleCastExpr CSCE) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::CStyleCastExpr *>(CSCE)->getBeginLoc().getPtrEncoding());
}

CXSourceLocation_ clang_CStyleCastExpr_getEndLoc(CXCStyleCastExpr CSCE) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::CStyleCastExpr *>(CSCE)->getEndLoc().getPtrEncoding());
}

LLVMGenericValueRef clang_IntegerLiteral_getValue(CXIntegerLiteral IL) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = reinterpret_cast<clang::IntegerLiteral *>(IL)->getValue();
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

// CharacterLiteral
unsigned clang_CharacterLiteral_getValue(CXCharacterLiteral CL) {
  return reinterpret_cast<clang::CharacterLiteral *>(CL)->getValue();
}

CXCharacterLiteralKind clang_CharacterLiteral_getKind(CXCharacterLiteral CL) {
  return static_cast<CXCharacterLiteralKind>(
      reinterpret_cast<clang::CharacterLiteral *>(CL)->getKind());
}

// FloatingLiteral
double clang_FloatingLiteral_getValueAsApproximateDouble(CXFloatingLiteral FL) {
  return reinterpret_cast<clang::FloatingLiteral *>(FL)->getValueAsApproximateDouble();
}

// StringLiteral
CXString clang_StringLiteral_getBytes(CXStringLiteral SL) {
  return extra::makeCXString(reinterpret_cast<clang::StringLiteral *>(SL)->getBytes().str());
}

unsigned clang_StringLiteral_getByteLength(CXStringLiteral SL) {
  return reinterpret_cast<clang::StringLiteral *>(SL)->getByteLength();
}

unsigned clang_StringLiteral_getLength(CXStringLiteral SL) {
  return reinterpret_cast<clang::StringLiteral *>(SL)->getLength();
}

unsigned clang_StringLiteral_getCharByteWidth(CXStringLiteral SL) {
  return reinterpret_cast<clang::StringLiteral *>(SL)->getCharByteWidth();
}

// ParenExpr
CXExpr clang_ParenExpr_getSubExpr(CXParenExpr PE) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ParenExpr *>(PE)->getSubExpr());
}

// UnaryOperator
CXUnaryOperatorKind clang_UnaryOperator_getOpcode(CXUnaryOperator UO) {
  return static_cast<CXUnaryOperatorKind>(
      reinterpret_cast<clang::UnaryOperator *>(UO)->getOpcode());
}

CXExpr clang_UnaryOperator_getSubExpr(CXUnaryOperator UO) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::UnaryOperator *>(UO)->getSubExpr());
}

CXSourceLocation_ clang_UnaryOperator_getOperatorLoc(CXUnaryOperator UO) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::UnaryOperator *>(UO)->getOperatorLoc().getPtrEncoding());
}

bool clang_UnaryOperator_isPrefix(CXUnaryOperator UO) {
  return reinterpret_cast<clang::UnaryOperator *>(UO)->isPrefix();
}

bool clang_UnaryOperator_isPostfix(CXUnaryOperator UO) {
  return reinterpret_cast<clang::UnaryOperator *>(UO)->isPostfix();
}

bool clang_UnaryOperator_isIncrementOp(CXUnaryOperator UO) {
  return reinterpret_cast<clang::UnaryOperator *>(UO)->isIncrementOp();
}

bool clang_UnaryOperator_isDecrementOp(CXUnaryOperator UO) {
  return reinterpret_cast<clang::UnaryOperator *>(UO)->isDecrementOp();
}

// ArraySubscriptExpr
CXExpr clang_ArraySubscriptExpr_getLHS(CXArraySubscriptExpr ASE) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ArraySubscriptExpr *>(ASE)->getLHS());
}

CXExpr clang_ArraySubscriptExpr_getRHS(CXArraySubscriptExpr ASE) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ArraySubscriptExpr *>(ASE)->getRHS());
}

CXExpr clang_ArraySubscriptExpr_getBase(CXArraySubscriptExpr ASE) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ArraySubscriptExpr *>(ASE)->getBase());
}

CXExpr clang_ArraySubscriptExpr_getIdx(CXArraySubscriptExpr ASE) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ArraySubscriptExpr *>(ASE)->getIdx());
}

// CallExpr
CXExpr clang_CallExpr_getCallee(CXCallExpr CE) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::CallExpr *>(CE)->getCallee());
}

CXDecl clang_CallExpr_getCalleeDecl(CXCallExpr CE) {
  return reinterpret_cast<CXDecl>(reinterpret_cast<clang::CallExpr *>(CE)->getCalleeDecl());
}

CXFunctionDecl clang_CallExpr_getDirectCallee(CXCallExpr CE) {
  return reinterpret_cast<CXFunctionDecl>(reinterpret_cast<clang::CallExpr *>(CE)->getDirectCallee());
}

unsigned clang_CallExpr_getNumArgs(CXCallExpr CE) {
  return reinterpret_cast<clang::CallExpr *>(CE)->getNumArgs();
}

CXExpr clang_CallExpr_getArg(CXCallExpr CE, unsigned Arg) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::CallExpr *>(CE)->getArg(Arg));
}

CXSourceLocation_ clang_CallExpr_getRParenLoc(CXCallExpr CE) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::CallExpr *>(CE)->getRParenLoc().getPtrEncoding());
}

// MemberExpr
CXExpr clang_MemberExpr_getBase(CXMemberExpr ME) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::MemberExpr *>(ME)->getBase());
}

CXValueDecl clang_MemberExpr_getMemberDecl(CXMemberExpr ME) {
  return reinterpret_cast<CXValueDecl>(reinterpret_cast<clang::MemberExpr *>(ME)->getMemberDecl());
}

bool clang_MemberExpr_isArrow(CXMemberExpr ME) {
  return reinterpret_cast<clang::MemberExpr *>(ME)->isArrow();
}

CXSourceLocation_ clang_MemberExpr_getMemberLoc(CXMemberExpr ME) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::MemberExpr *>(ME)->getMemberLoc().getPtrEncoding());
}

bool clang_MemberExpr_isImplicitAccess(CXMemberExpr ME) {
  return reinterpret_cast<clang::MemberExpr *>(ME)->isImplicitAccess();
}

CXDeclarationNameInfo clang_MemberExpr_getMemberNameInfo(CXMemberExpr ME) {
  return reinterpret_cast<CXDeclarationNameInfo>(std::make_unique<clang::DeclarationNameInfo>(
             reinterpret_cast<clang::MemberExpr *>(ME)->getMemberNameInfo())
      .release());
}

// CastExpr
CXCastKind clang_CastExpr_getCastKind(CXCastExpr CE) {
  return static_cast<CXCastKind>(reinterpret_cast<clang::CastExpr *>(CE)->getCastKind());
}

const char *clang_CastExpr_getCastKindName(CXCastExpr CE) {
  return reinterpret_cast<clang::CastExpr *>(CE)->getCastKindName();
}

CXExpr clang_CastExpr_getSubExpr(CXCastExpr CE) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::CastExpr *>(CE)->getSubExpr());
}

CXExpr clang_CastExpr_getSubExprAsWritten(CXCastExpr CE) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::CastExpr *>(CE)->getSubExprAsWritten());
}

// ImplicitCastExpr
bool clang_ImplicitCastExpr_isPartOfExplicitCast(CXImplicitCastExpr ICE) {
  return reinterpret_cast<clang::ImplicitCastExpr *>(ICE)->isPartOfExplicitCast();
}

// ExplicitCastExpr
CXQualType clang_ExplicitCastExpr_getTypeAsWritten(CXExplicitCastExpr ECE) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::ExplicitCastExpr *>(ECE)->getTypeAsWritten().getAsOpaquePtr());
}

// BinaryOperator
CXBinaryOperatorKind clang_BinaryOperator_getOpcode(CXBinaryOperator BO) {
  return static_cast<CXBinaryOperatorKind>(
      reinterpret_cast<clang::BinaryOperator *>(BO)->getOpcode());
}

CXExpr clang_BinaryOperator_getLHS(CXBinaryOperator BO) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::BinaryOperator *>(BO)->getLHS());
}

CXExpr clang_BinaryOperator_getRHS(CXBinaryOperator BO) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::BinaryOperator *>(BO)->getRHS());
}

CXSourceLocation_ clang_BinaryOperator_getOperatorLoc(CXBinaryOperator BO) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::BinaryOperator *>(BO)->getOperatorLoc().getPtrEncoding());
}

const char *clang_BinaryOperator_getOpcodeStr(CXBinaryOperator BO) {
  // the spelling table is static string literals: borrowed, NUL-terminated
  return reinterpret_cast<clang::BinaryOperator *>(BO)->getOpcodeStr().data();
}

bool clang_BinaryOperator_isAssignmentOp(CXBinaryOperator BO) {
  return reinterpret_cast<clang::BinaryOperator *>(BO)->isAssignmentOp();
}

bool clang_BinaryOperator_isCompoundAssignmentOp(CXBinaryOperator BO) {
  return reinterpret_cast<clang::BinaryOperator *>(BO)->isCompoundAssignmentOp();
}

bool clang_BinaryOperator_isComparisonOp(CXBinaryOperator BO) {
  return reinterpret_cast<clang::BinaryOperator *>(BO)->isComparisonOp();
}

// CompoundAssignOperator
CXQualType
clang_CompoundAssignOperator_getComputationLHSType(CXCompoundAssignOperator CAO) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::CompoundAssignOperator *>(CAO)
      ->getComputationLHSType()
      .getAsOpaquePtr());
}

CXQualType
clang_CompoundAssignOperator_getComputationResultType(CXCompoundAssignOperator CAO) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::CompoundAssignOperator *>(CAO)
      ->getComputationResultType()
      .getAsOpaquePtr());
}

// AbstractConditionalOperator
CXExpr clang_AbstractConditionalOperator_getCond(CXAbstractConditionalOperator ACO) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::AbstractConditionalOperator *>(ACO)->getCond());
}

CXExpr clang_AbstractConditionalOperator_getTrueExpr(CXAbstractConditionalOperator ACO) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::AbstractConditionalOperator *>(ACO)->getTrueExpr());
}

CXExpr clang_AbstractConditionalOperator_getFalseExpr(CXAbstractConditionalOperator ACO) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::AbstractConditionalOperator *>(ACO)->getFalseExpr());
}

// InitListExpr
unsigned clang_InitListExpr_getNumInits(CXInitListExpr ILE) {
  return reinterpret_cast<clang::InitListExpr *>(ILE)->getNumInits();
}

CXExpr clang_InitListExpr_getInit(CXInitListExpr ILE, unsigned Init) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::InitListExpr *>(ILE)->getInit(Init));
}

bool clang_InitListExpr_isSemanticForm(CXInitListExpr ILE) {
  return reinterpret_cast<clang::InitListExpr *>(ILE)->isSemanticForm();
}

CXInitListExpr clang_InitListExpr_getSyntacticForm(CXInitListExpr ILE) {
  return reinterpret_cast<CXInitListExpr>(reinterpret_cast<clang::InitListExpr *>(ILE)->getSyntacticForm());
}

// UnaryExprOrTypeTraitExpr
bool clang_UnaryExprOrTypeTraitExpr_isArgumentType(CXUnaryExprOrTypeTraitExpr E) {
  return reinterpret_cast<clang::UnaryExprOrTypeTraitExpr *>(E)->isArgumentType();
}

CXQualType clang_UnaryExprOrTypeTraitExpr_getArgumentType(CXUnaryExprOrTypeTraitExpr E) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::UnaryExprOrTypeTraitExpr *>(E)->getArgumentType().getAsOpaquePtr());
}

CXQualType clang_UnaryExprOrTypeTraitExpr_getTypeOfArgument(CXUnaryExprOrTypeTraitExpr E) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::UnaryExprOrTypeTraitExpr *>(E)->getTypeOfArgument().getAsOpaquePtr());
}

CXSourceLocation_ clang_UnaryExprOrTypeTraitExpr_getOperatorLoc(CXUnaryExprOrTypeTraitExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::UnaryExprOrTypeTraitExpr *>(E)->getOperatorLoc().getPtrEncoding());
}

CXSourceLocation_ clang_UnaryExprOrTypeTraitExpr_getRParenLoc(CXUnaryExprOrTypeTraitExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::UnaryExprOrTypeTraitExpr *>(E)->getRParenLoc().getPtrEncoding());
}

// StringLiteral
bool clang_StringLiteral_isOrdinary(CXStringLiteral E) {
  return reinterpret_cast<clang::StringLiteral *>(E)->isOrdinary();
}

bool clang_StringLiteral_isWide(CXStringLiteral E) {
  return reinterpret_cast<clang::StringLiteral *>(E)->isWide();
}

bool clang_StringLiteral_isUTF8(CXStringLiteral E) {
  return reinterpret_cast<clang::StringLiteral *>(E)->isUTF8();
}

bool clang_StringLiteral_isUTF16(CXStringLiteral E) {
  return reinterpret_cast<clang::StringLiteral *>(E)->isUTF16();
}

bool clang_StringLiteral_isUTF32(CXStringLiteral E) {
  return reinterpret_cast<clang::StringLiteral *>(E)->isUTF32();
}

bool clang_StringLiteral_isUnevaluated(CXStringLiteral E) {
  return reinterpret_cast<clang::StringLiteral *>(E)->isUnevaluated();
}

bool clang_StringLiteral_isPascal(CXStringLiteral E) {
  return reinterpret_cast<clang::StringLiteral *>(E)->isPascal();
}

bool clang_StringLiteral_containsNonAscii(CXStringLiteral E) {
  return reinterpret_cast<clang::StringLiteral *>(E)->containsNonAscii();
}

bool clang_StringLiteral_containsNonAsciiOrNull(CXStringLiteral E) {
  return reinterpret_cast<clang::StringLiteral *>(E)->containsNonAsciiOrNull();
}

unsigned clang_StringLiteral_getNumConcatenated(CXStringLiteral E) {
  return reinterpret_cast<clang::StringLiteral *>(E)->getNumConcatenated();
}

// CharacterLiteral
CXSourceLocation_ clang_CharacterLiteral_getLocation(CXCharacterLiteral E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::CharacterLiteral *>(E)->getLocation().getPtrEncoding());
}

// UnaryOperator
bool clang_UnaryOperator_canOverflow(CXUnaryOperator E) {
  return reinterpret_cast<clang::UnaryOperator *>(E)->canOverflow();
}

bool clang_UnaryOperator_isIncrementDecrementOp(CXUnaryOperator E) {
  return reinterpret_cast<clang::UnaryOperator *>(E)->isIncrementDecrementOp();
}

bool clang_UnaryOperator_isArithmeticOp(CXUnaryOperator E) {
  return reinterpret_cast<clang::UnaryOperator *>(E)->isArithmeticOp();
}

bool clang_UnaryOperator_hasStoredFPFeatures(CXUnaryOperator E) {
  return reinterpret_cast<clang::UnaryOperator *>(E)->hasStoredFPFeatures();
}

// CallExpr
bool clang_CallExpr_usesADL(CXCallExpr E) {
  return reinterpret_cast<clang::CallExpr *>(E)->usesADL();
}

bool clang_CallExpr_hasStoredFPFeatures(CXCallExpr E) {
  return reinterpret_cast<clang::CallExpr *>(E)->hasStoredFPFeatures();
}

unsigned clang_CallExpr_getBuiltinCallee(CXCallExpr E) {
  return reinterpret_cast<clang::CallExpr *>(E)->getBuiltinCallee();
}

bool clang_CallExpr_isCallToStdMove(CXCallExpr E) {
  return reinterpret_cast<clang::CallExpr *>(E)->isCallToStdMove();
}

// MemberExpr
bool clang_MemberExpr_hasQualifier(CXMemberExpr E) {
  return reinterpret_cast<clang::MemberExpr *>(E)->hasQualifier();
}

CXSourceLocation_ clang_MemberExpr_getTemplateKeywordLoc(CXMemberExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::MemberExpr *>(E)->getTemplateKeywordLoc().getPtrEncoding());
}

CXSourceLocation_ clang_MemberExpr_getLAngleLoc(CXMemberExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::MemberExpr *>(E)->getLAngleLoc().getPtrEncoding());
}

CXSourceLocation_ clang_MemberExpr_getRAngleLoc(CXMemberExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::MemberExpr *>(E)->getRAngleLoc().getPtrEncoding());
}

bool clang_MemberExpr_hasTemplateKeyword(CXMemberExpr E) {
  return reinterpret_cast<clang::MemberExpr *>(E)->hasTemplateKeyword();
}

bool clang_MemberExpr_hasExplicitTemplateArgs(CXMemberExpr E) {
  return reinterpret_cast<clang::MemberExpr *>(E)->hasExplicitTemplateArgs();
}

unsigned clang_MemberExpr_getNumTemplateArgs(CXMemberExpr E) {
  return reinterpret_cast<clang::MemberExpr *>(E)->getNumTemplateArgs();
}

CXSourceLocation_ clang_MemberExpr_getOperatorLoc(CXMemberExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::MemberExpr *>(E)->getOperatorLoc().getPtrEncoding());
}

bool clang_MemberExpr_hadMultipleCandidates(CXMemberExpr E) {
  return reinterpret_cast<clang::MemberExpr *>(E)->hadMultipleCandidates();
}

// InitListExpr
bool clang_InitListExpr_hasArrayFiller(CXInitListExpr E) {
  return reinterpret_cast<clang::InitListExpr *>(E)->hasArrayFiller();
}

bool clang_InitListExpr_hasDesignatedInit(CXInitListExpr E) {
  return reinterpret_cast<clang::InitListExpr *>(E)->hasDesignatedInit();
}

bool clang_InitListExpr_isExplicit(CXInitListExpr E) {
  return reinterpret_cast<clang::InitListExpr *>(E)->isExplicit();
}

bool clang_InitListExpr_isStringLiteralInit(CXInitListExpr E) {
  return reinterpret_cast<clang::InitListExpr *>(E)->isStringLiteralInit();
}

bool clang_InitListExpr_isTransparent(CXInitListExpr E) {
  return reinterpret_cast<clang::InitListExpr *>(E)->isTransparent();
}

CXSourceLocation_ clang_InitListExpr_getLBraceLoc(CXInitListExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::InitListExpr *>(E)->getLBraceLoc().getPtrEncoding());
}

CXSourceLocation_ clang_InitListExpr_getRBraceLoc(CXInitListExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::InitListExpr *>(E)->getRBraceLoc().getPtrEncoding());
}

bool clang_InitListExpr_isSyntacticForm(CXInitListExpr E) {
  return reinterpret_cast<clang::InitListExpr *>(E)->isSyntacticForm();
}

bool clang_InitListExpr_hadArrayRangeDesignator(CXInitListExpr E) {
  return reinterpret_cast<clang::InitListExpr *>(E)->hadArrayRangeDesignator();
}

// ParenExpr
CXSourceLocation_ clang_ParenExpr_getLParen(CXParenExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ParenExpr *>(E)->getLParen().getPtrEncoding());
}

CXSourceLocation_ clang_ParenExpr_getRParen(CXParenExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ParenExpr *>(E)->getRParen().getPtrEncoding());
}

// ArraySubscriptExpr
CXSourceLocation_ clang_ArraySubscriptExpr_getRBracketLoc(CXArraySubscriptExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ArraySubscriptExpr *>(E)->getRBracketLoc().getPtrEncoding());
}

// DeclRefExpr
bool clang_DeclRefExpr_hasTemplateKWAndArgsInfo(CXDeclRefExpr E) {
  return reinterpret_cast<clang::DeclRefExpr *>(E)->hasTemplateKWAndArgsInfo();
}

CXSourceLocation_ clang_DeclRefExpr_getTemplateKeywordLoc(CXDeclRefExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DeclRefExpr *>(E)->getTemplateKeywordLoc().getPtrEncoding());
}

CXSourceLocation_ clang_DeclRefExpr_getLAngleLoc(CXDeclRefExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DeclRefExpr *>(E)->getLAngleLoc().getPtrEncoding());
}

CXSourceLocation_ clang_DeclRefExpr_getRAngleLoc(CXDeclRefExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::DeclRefExpr *>(E)->getRAngleLoc().getPtrEncoding());
}

bool clang_DeclRefExpr_hasTemplateKeyword(CXDeclRefExpr E) {
  return reinterpret_cast<clang::DeclRefExpr *>(E)->hasTemplateKeyword();
}

bool clang_DeclRefExpr_hasExplicitTemplateArgs(CXDeclRefExpr E) {
  return reinterpret_cast<clang::DeclRefExpr *>(E)->hasExplicitTemplateArgs();
}

unsigned clang_DeclRefExpr_getNumTemplateArgs(CXDeclRefExpr E) {
  return reinterpret_cast<clang::DeclRefExpr *>(E)->getNumTemplateArgs();
}

bool clang_DeclRefExpr_hadMultipleCandidates(CXDeclRefExpr E) {
  return reinterpret_cast<clang::DeclRefExpr *>(E)->hadMultipleCandidates();
}

bool clang_DeclRefExpr_refersToEnclosingVariableOrCapture(CXDeclRefExpr E) {
  return reinterpret_cast<clang::DeclRefExpr *>(E)->refersToEnclosingVariableOrCapture();
}

bool clang_DeclRefExpr_isImmediateEscalating(CXDeclRefExpr E) {
  return reinterpret_cast<clang::DeclRefExpr *>(E)->isImmediateEscalating();
}

bool clang_DeclRefExpr_isCapturedByCopyInLambdaWithExplicitObjectParameter(CXDeclRefExpr E) {
  return reinterpret_cast<clang::DeclRefExpr *>(E)->isCapturedByCopyInLambdaWithExplicitObjectParameter();
}

// CastExpr
bool clang_CastExpr_path_empty(CXCastExpr E) {
  return reinterpret_cast<clang::CastExpr *>(E)->path_empty();
}

unsigned clang_CastExpr_path_size(CXCastExpr E) {
  return reinterpret_cast<clang::CastExpr *>(E)->path_size();
}

bool clang_CastExpr_hasStoredFPFeatures(CXCastExpr E) {
  return reinterpret_cast<clang::CastExpr *>(E)->hasStoredFPFeatures();
}

bool clang_CastExpr_changesVolatileQualification(CXCastExpr E) {
  return reinterpret_cast<clang::CastExpr *>(E)->changesVolatileQualification();
}

// ConstantExpr
bool clang_ConstantExpr_isImmediateInvocation(CXConstantExpr E) {
  return reinterpret_cast<clang::ConstantExpr *>(E)->isImmediateInvocation();
}

bool clang_ConstantExpr_hasAPValueResult(CXConstantExpr E) {
  return reinterpret_cast<clang::ConstantExpr *>(E)->hasAPValueResult();
}

// StmtExpr
CXSourceLocation_ clang_StmtExpr_getLParenLoc(CXStmtExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::StmtExpr *>(E)->getLParenLoc().getPtrEncoding());
}

CXSourceLocation_ clang_StmtExpr_getRParenLoc(CXStmtExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::StmtExpr *>(E)->getRParenLoc().getPtrEncoding());
}

unsigned clang_StmtExpr_getTemplateDepth(CXStmtExpr E) {
  return reinterpret_cast<clang::StmtExpr *>(E)->getTemplateDepth();
}

// CompoundLiteralExpr
bool clang_CompoundLiteralExpr_isFileScope(CXCompoundLiteralExpr E) {
  return reinterpret_cast<clang::CompoundLiteralExpr *>(E)->isFileScope();
}

CXSourceLocation_ clang_CompoundLiteralExpr_getLParenLoc(CXCompoundLiteralExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::CompoundLiteralExpr *>(E)->getLParenLoc().getPtrEncoding());
}


// UnaryExprOrTypeTraitExpr
CXTypeSourceInfo clang_UnaryExprOrTypeTraitExpr_getArgumentTypeInfo(CXUnaryExprOrTypeTraitExpr E) {
  return reinterpret_cast<CXTypeSourceInfo>(const_cast<clang::TypeSourceInfo *>(reinterpret_cast<clang::UnaryExprOrTypeTraitExpr *>(E)->getArgumentTypeInfo()));
}

CXExpr clang_UnaryExprOrTypeTraitExpr_getArgumentExpr(CXUnaryExprOrTypeTraitExpr E) {
  return reinterpret_cast<CXExpr>(const_cast<clang::Expr *>(reinterpret_cast<clang::UnaryExprOrTypeTraitExpr *>(E)->getArgumentExpr()));
}

// MemberExpr
CXNestedNameSpecifier clang_MemberExpr_getQualifier(CXMemberExpr E) {
  return reinterpret_cast<CXNestedNameSpecifier>(const_cast<clang::NestedNameSpecifier *>(reinterpret_cast<clang::MemberExpr *>(E)->getQualifier()));
}

// InitListExpr
CXExpr clang_InitListExpr_getArrayFiller(CXInitListExpr E) {
  return reinterpret_cast<CXExpr>(const_cast<clang::Expr *>(reinterpret_cast<clang::InitListExpr *>(E)->getArrayFiller()));
}

CXFieldDecl clang_InitListExpr_getInitializedFieldInUnion(CXInitListExpr E) {
  return reinterpret_cast<CXFieldDecl>(const_cast<clang::FieldDecl *>(reinterpret_cast<clang::InitListExpr *>(E)->getInitializedFieldInUnion()));
}

CXInitListExpr clang_InitListExpr_getSemanticForm(CXInitListExpr E) {
  return reinterpret_cast<CXInitListExpr>(const_cast<clang::InitListExpr *>(reinterpret_cast<clang::InitListExpr *>(E)->getSemanticForm()));
}

// DeclRefExpr
CXNestedNameSpecifier clang_DeclRefExpr_getQualifier(CXDeclRefExpr E) {
  return reinterpret_cast<CXNestedNameSpecifier>(const_cast<clang::NestedNameSpecifier *>(reinterpret_cast<clang::DeclRefExpr *>(E)->getQualifier()));
}

// CastExpr
CXNamedDecl clang_CastExpr_getConversionFunction(CXCastExpr E) {
  return reinterpret_cast<CXNamedDecl>(const_cast<clang::NamedDecl *>(reinterpret_cast<clang::CastExpr *>(E)->getConversionFunction()));
}

CXFieldDecl clang_CastExpr_getTargetUnionField(CXCastExpr E) {
  return reinterpret_cast<CXFieldDecl>(const_cast<clang::FieldDecl *>(reinterpret_cast<clang::CastExpr *>(E)->getTargetUnionField()));
}

// StmtExpr
CXCompoundStmt clang_StmtExpr_getSubStmt(CXStmtExpr E) {
  return reinterpret_cast<CXCompoundStmt>(const_cast<clang::CompoundStmt *>(reinterpret_cast<clang::StmtExpr *>(E)->getSubStmt()));
}

// CompoundLiteralExpr
CXExpr clang_CompoundLiteralExpr_getInitializer(CXCompoundLiteralExpr E) {
  return reinterpret_cast<CXExpr>(const_cast<clang::Expr *>(reinterpret_cast<clang::CompoundLiteralExpr *>(E)->getInitializer()));
}

CXTypeSourceInfo clang_CompoundLiteralExpr_getTypeSourceInfo(CXCompoundLiteralExpr E) {
  return reinterpret_cast<CXTypeSourceInfo>(const_cast<clang::TypeSourceInfo *>(reinterpret_cast<clang::CompoundLiteralExpr *>(E)->getTypeSourceInfo()));
}

// StringLiteral
CXString clang_StringLiteral_getString(CXStringLiteral SL) {
  return extra::makeCXString(reinterpret_cast<clang::StringLiteral *>(SL)->getString().str());
}

CXStringLiteralKind clang_StringLiteral_getKind(CXStringLiteral SL) {
  return static_cast<CXStringLiteralKind>(
      reinterpret_cast<clang::StringLiteral *>(SL)->getKind());
}

CXSourceLocation_ clang_StringLiteral_getBeginLoc(CXStringLiteral SL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::StringLiteral *>(SL)->getBeginLoc().getPtrEncoding());
}

CXSourceLocation_ clang_StringLiteral_getEndLoc(CXStringLiteral SL) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::StringLiteral *>(SL)->getEndLoc().getPtrEncoding());
}

// UnaryExprOrTypeTraitExpr
CXUnaryExprOrTypeTrait
clang_UnaryExprOrTypeTraitExpr_getKind(CXUnaryExprOrTypeTraitExpr E) {
  return static_cast<CXUnaryExprOrTypeTrait>(
      reinterpret_cast<clang::UnaryExprOrTypeTraitExpr *>(E)->getKind());
}

// PredefinedExpr
CXPredefinedIdentKind clang_PredefinedExpr_getIdentKind(CXPredefinedExpr E) {
  return static_cast<CXPredefinedIdentKind>(
      reinterpret_cast<clang::PredefinedExpr *>(E)->getIdentKind());
}

CXStringLiteral clang_PredefinedExpr_getFunctionName(CXPredefinedExpr E) {
  return reinterpret_cast<CXStringLiteral>(reinterpret_cast<clang::PredefinedExpr *>(E)->getFunctionName());
}

CXString clang_PredefinedExpr_getIdentKindName(CXPredefinedExpr E) {
  return extra::makeCXString(
      reinterpret_cast<clang::PredefinedExpr *>(E)->getIdentKindName().str());
}

// CastExpr
CXCXXBaseSpecifier clang_CastExpr_getPathElement(CXCastExpr E, unsigned I) {
  return reinterpret_cast<CXCXXBaseSpecifier>(*(reinterpret_cast<clang::CastExpr *>(E)->path_begin() + I));
}

// OpaqueValueExpr
CXSourceLocation_ clang_OpaqueValueExpr_getLocation(CXOpaqueValueExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::OpaqueValueExpr *>(E)->getLocation().getPtrEncoding());
}

CXExpr clang_OpaqueValueExpr_getSourceExpr(CXOpaqueValueExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::OpaqueValueExpr *>(E)->getSourceExpr());
}

bool clang_OpaqueValueExpr_isUnique(CXOpaqueValueExpr E) {
  return reinterpret_cast<clang::OpaqueValueExpr *>(E)->isUnique();
}

// ConditionalOperator
CXExpr clang_ConditionalOperator_getLHS(CXConditionalOperator E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ConditionalOperator *>(E)->getLHS());
}

CXExpr clang_ConditionalOperator_getRHS(CXConditionalOperator E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ConditionalOperator *>(E)->getRHS());
}

// BinaryConditionalOperator
CXExpr clang_BinaryConditionalOperator_getCommon(CXBinaryConditionalOperator E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::BinaryConditionalOperator *>(E)->getCommon());
}

CXOpaqueValueExpr
clang_BinaryConditionalOperator_getOpaqueValue(CXBinaryConditionalOperator E) {
  return reinterpret_cast<CXOpaqueValueExpr>(reinterpret_cast<clang::BinaryConditionalOperator *>(E)->getOpaqueValue());
}

// AddrLabelExpr
CXSourceLocation_ clang_AddrLabelExpr_getAmpAmpLoc(CXAddrLabelExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::AddrLabelExpr *>(E)->getAmpAmpLoc().getPtrEncoding());
}

CXSourceLocation_ clang_AddrLabelExpr_getLabelLoc(CXAddrLabelExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::AddrLabelExpr *>(E)->getLabelLoc().getPtrEncoding());
}

CXLabelDecl clang_AddrLabelExpr_getLabel(CXAddrLabelExpr E) {
  return reinterpret_cast<CXLabelDecl>(reinterpret_cast<clang::AddrLabelExpr *>(E)->getLabel());
}

// GNUNullExpr
CXSourceLocation_ clang_GNUNullExpr_getTokenLocation(CXGNUNullExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::GNUNullExpr *>(E)->getTokenLocation().getPtrEncoding());
}

// VAArgExpr
CXExpr clang_VAArgExpr_getSubExpr(CXVAArgExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::VAArgExpr *>(E)->getSubExpr());
}

bool clang_VAArgExpr_isMicrosoftABI(CXVAArgExpr E) {
  return reinterpret_cast<clang::VAArgExpr *>(E)->isMicrosoftABI();
}

CXTypeSourceInfo clang_VAArgExpr_getWrittenTypeInfo(CXVAArgExpr E) {
  return reinterpret_cast<CXTypeSourceInfo>(reinterpret_cast<clang::VAArgExpr *>(E)->getWrittenTypeInfo());
}

CXSourceLocation_ clang_VAArgExpr_getBuiltinLoc(CXVAArgExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::VAArgExpr *>(E)->getBuiltinLoc().getPtrEncoding());
}

CXSourceLocation_ clang_VAArgExpr_getRParenLoc(CXVAArgExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::VAArgExpr *>(E)->getRParenLoc().getPtrEncoding());
}

// ImaginaryLiteral
CXExpr clang_ImaginaryLiteral_getSubExpr(CXImaginaryLiteral E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ImaginaryLiteral *>(E)->getSubExpr());
}

// MatrixSubscriptExpr
bool clang_MatrixSubscriptExpr_isIncomplete(CXMatrixSubscriptExpr E) {
  return reinterpret_cast<clang::MatrixSubscriptExpr *>(E)->isIncomplete();
}

CXExpr clang_MatrixSubscriptExpr_getBase(CXMatrixSubscriptExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::MatrixSubscriptExpr *>(E)->getBase());
}

CXExpr clang_MatrixSubscriptExpr_getRowIdx(CXMatrixSubscriptExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::MatrixSubscriptExpr *>(E)->getRowIdx());
}

CXExpr clang_MatrixSubscriptExpr_getColumnIdx(CXMatrixSubscriptExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::MatrixSubscriptExpr *>(E)->getColumnIdx());
}

CXSourceLocation_ clang_MatrixSubscriptExpr_getRBracketLoc(CXMatrixSubscriptExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::MatrixSubscriptExpr *>(E)->getRBracketLoc().getPtrEncoding());
}

// ConvertVectorExpr
CXExpr clang_ConvertVectorExpr_getSrcExpr(CXConvertVectorExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ConvertVectorExpr *>(E)->getSrcExpr());
}

CXTypeSourceInfo clang_ConvertVectorExpr_getTypeSourceInfo(CXConvertVectorExpr E) {
  return reinterpret_cast<CXTypeSourceInfo>(reinterpret_cast<clang::ConvertVectorExpr *>(E)->getTypeSourceInfo());
}

CXSourceLocation_ clang_ConvertVectorExpr_getBuiltinLoc(CXConvertVectorExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ConvertVectorExpr *>(E)->getBuiltinLoc().getPtrEncoding());
}

CXSourceLocation_ clang_ConvertVectorExpr_getRParenLoc(CXConvertVectorExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ConvertVectorExpr *>(E)->getRParenLoc().getPtrEncoding());
}

// ChooseExpr
CXExpr clang_ChooseExpr_getChosenSubExpr(CXChooseExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ChooseExpr *>(E)->getChosenSubExpr());
}

CXSourceLocation_ clang_ChooseExpr_getBuiltinLoc(CXChooseExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ChooseExpr *>(E)->getBuiltinLoc().getPtrEncoding());
}

CXSourceLocation_ clang_ChooseExpr_getRParenLoc(CXChooseExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ChooseExpr *>(E)->getRParenLoc().getPtrEncoding());
}

// SourceLocExpr
CXString clang_SourceLocExpr_getBuiltinStr(CXSourceLocExpr E) {
  return extra::makeCXString(reinterpret_cast<clang::SourceLocExpr *>(E)->getBuiltinStr().str());
}

bool clang_SourceLocExpr_isIntType(CXSourceLocExpr E) {
  return reinterpret_cast<clang::SourceLocExpr *>(E)->isIntType();
}

CXDeclContext clang_SourceLocExpr_getParentContext(CXSourceLocExpr E) {
  return reinterpret_cast<CXDeclContext>(const_cast<clang::DeclContext *>(
      reinterpret_cast<clang::SourceLocExpr *>(E)->getParentContext()));
}

CXSourceLocation_ clang_SourceLocExpr_getLocation(CXSourceLocExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SourceLocExpr *>(E)->getLocation().getPtrEncoding());
}

// BlockExpr
CXBlockDecl clang_BlockExpr_getBlockDecl(CXBlockExpr E) {
  return reinterpret_cast<CXBlockDecl>(reinterpret_cast<clang::BlockExpr *>(E)->getBlockDecl());
}

CXSourceLocation_ clang_BlockExpr_getCaretLocation(CXBlockExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::BlockExpr *>(E)->getCaretLocation().getPtrEncoding());
}

CXStmt clang_BlockExpr_getBody(CXBlockExpr E) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::BlockExpr *>(E)->getBody());
}

// AtomicExpr
CXExpr clang_AtomicExpr_getPtr(CXAtomicExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::AtomicExpr *>(E)->getPtr());
}

CXExpr clang_AtomicExpr_getOrder(CXAtomicExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::AtomicExpr *>(E)->getOrder());
}

CXQualType clang_AtomicExpr_getValueType(CXAtomicExpr E) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::AtomicExpr *>(E)->getValueType().getAsOpaquePtr());
}

bool clang_AtomicExpr_isVolatile(CXAtomicExpr E) {
  return reinterpret_cast<clang::AtomicExpr *>(E)->isVolatile();
}

bool clang_AtomicExpr_isOpenCL(CXAtomicExpr E) {
  return reinterpret_cast<clang::AtomicExpr *>(E)->isOpenCL();
}

CXSourceLocation_ clang_AtomicExpr_getBuiltinLoc(CXAtomicExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::AtomicExpr *>(E)->getBuiltinLoc().getPtrEncoding());
}

CXSourceLocation_ clang_AtomicExpr_getRParenLoc(CXAtomicExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::AtomicExpr *>(E)->getRParenLoc().getPtrEncoding());
}

// GenericSelectionExpr
bool clang_GenericSelectionExpr_isTypePredicate(CXGenericSelectionExpr E) {
  return reinterpret_cast<clang::GenericSelectionExpr *>(E)->isTypePredicate();
}

CXExpr clang_GenericSelectionExpr_getResultExpr(CXGenericSelectionExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::GenericSelectionExpr *>(E)->getResultExpr());
}

CXSourceLocation_ clang_GenericSelectionExpr_getGenericLoc(CXGenericSelectionExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::GenericSelectionExpr *>(E)->getGenericLoc().getPtrEncoding());
}

CXSourceLocation_ clang_GenericSelectionExpr_getDefaultLoc(CXGenericSelectionExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::GenericSelectionExpr *>(E)->getDefaultLoc().getPtrEncoding());
}

CXSourceLocation_ clang_GenericSelectionExpr_getRParenLoc(CXGenericSelectionExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::GenericSelectionExpr *>(E)->getRParenLoc().getPtrEncoding());
}

// ArrayInitLoopExpr
CXOpaqueValueExpr clang_ArrayInitLoopExpr_getCommonExpr(CXArrayInitLoopExpr E) {
  return reinterpret_cast<CXOpaqueValueExpr>(reinterpret_cast<clang::ArrayInitLoopExpr *>(E)->getCommonExpr());
}

CXExpr clang_ArrayInitLoopExpr_getSubExpr(CXArrayInitLoopExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::ArrayInitLoopExpr *>(E)->getSubExpr());
}

// PseudoObjectExpr
CXExpr clang_PseudoObjectExpr_getSyntacticForm(CXPseudoObjectExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::PseudoObjectExpr *>(E)->getSyntacticForm());
}

unsigned clang_PseudoObjectExpr_getResultExprIndex(CXPseudoObjectExpr E) {
  return reinterpret_cast<clang::PseudoObjectExpr *>(E)->getResultExprIndex();
}

CXExpr clang_PseudoObjectExpr_getResultExpr(CXPseudoObjectExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::PseudoObjectExpr *>(E)->getResultExpr());
}

unsigned clang_PseudoObjectExpr_getNumSemanticExprs(CXPseudoObjectExpr E) {
  return reinterpret_cast<clang::PseudoObjectExpr *>(E)->getNumSemanticExprs();
}

CXExpr clang_PseudoObjectExpr_getSemanticExpr(CXPseudoObjectExpr E, unsigned Index) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::PseudoObjectExpr *>(E)->getSemanticExpr(Index));
}

// OffsetOfNode
CXOffsetOfNode_Kind clang_OffsetOfNode_getKind(CXOffsetOfNode N) {
  return static_cast<CXOffsetOfNode_Kind>(reinterpret_cast<clang::OffsetOfNode *>(N)->getKind());
}

unsigned clang_OffsetOfNode_getArrayExprIndex(CXOffsetOfNode N) {
  return reinterpret_cast<clang::OffsetOfNode *>(N)->getArrayExprIndex();
}

CXFieldDecl clang_OffsetOfNode_getField(CXOffsetOfNode N) {
  return reinterpret_cast<CXFieldDecl>(reinterpret_cast<clang::OffsetOfNode *>(N)->getField());
}

CXIdentifierInfo clang_OffsetOfNode_getFieldName(CXOffsetOfNode N) {
  return reinterpret_cast<CXIdentifierInfo>(reinterpret_cast<clang::OffsetOfNode *>(N)->getFieldName());
}

CXCXXBaseSpecifier clang_OffsetOfNode_getBase(CXOffsetOfNode N) {
  return reinterpret_cast<CXCXXBaseSpecifier>(reinterpret_cast<clang::OffsetOfNode *>(N)->getBase());
}

CXSourceRange_ clang_OffsetOfNode_getSourceRange(CXOffsetOfNode N) {
  clang::SourceRange R = reinterpret_cast<clang::OffsetOfNode *>(N)->getSourceRange();
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

CXSourceLocation_ clang_OffsetOfNode_getBeginLoc(CXOffsetOfNode N) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::OffsetOfNode *>(N)->getBeginLoc().getPtrEncoding());
}

CXSourceLocation_ clang_OffsetOfNode_getEndLoc(CXOffsetOfNode N) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::OffsetOfNode *>(N)->getEndLoc().getPtrEncoding());
}

// OffsetOfExpr
CXSourceLocation_ clang_OffsetOfExpr_getOperatorLoc(CXOffsetOfExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::OffsetOfExpr *>(E)->getOperatorLoc().getPtrEncoding());
}

CXSourceLocation_ clang_OffsetOfExpr_getRParenLoc(CXOffsetOfExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::OffsetOfExpr *>(E)->getRParenLoc().getPtrEncoding());
}

CXTypeSourceInfo clang_OffsetOfExpr_getTypeSourceInfo(CXOffsetOfExpr E) {
  return reinterpret_cast<CXTypeSourceInfo>(reinterpret_cast<clang::OffsetOfExpr *>(E)->getTypeSourceInfo());
}

CXOffsetOfNode clang_OffsetOfExpr_getComponent(CXOffsetOfExpr E, unsigned Idx) {
  return reinterpret_cast<CXOffsetOfNode>(const_cast<clang::OffsetOfNode *>(
      &reinterpret_cast<clang::OffsetOfExpr *>(E)->getComponent(Idx)));
}

unsigned clang_OffsetOfExpr_getNumComponents(CXOffsetOfExpr E) {
  return reinterpret_cast<clang::OffsetOfExpr *>(E)->getNumComponents();
}

CXExpr clang_OffsetOfExpr_getIndexExpr(CXOffsetOfExpr E, unsigned Idx) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::OffsetOfExpr *>(E)->getIndexExpr(Idx));
}

unsigned clang_OffsetOfExpr_getNumExpressions(CXOffsetOfExpr E) {
  return reinterpret_cast<clang::OffsetOfExpr *>(E)->getNumExpressions();
}

// ExtVectorElementExpr
CXIdentifierInfo clang_ExtVectorElementExpr_getAccessor(CXExtVectorElementExpr E) {
  return reinterpret_cast<CXIdentifierInfo>(&reinterpret_cast<clang::ExtVectorElementExpr *>(E)->getAccessor());
}

CXSourceLocation_ clang_ExtVectorElementExpr_getAccessorLoc(CXExtVectorElementExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ExtVectorElementExpr *>(E)->getAccessorLoc().getPtrEncoding());
}

bool clang_ExtVectorElementExpr_containsDuplicateElements(CXExtVectorElementExpr E) {
  return reinterpret_cast<clang::ExtVectorElementExpr *>(E)->containsDuplicateElements();
}

bool clang_ExtVectorElementExpr_isArrow(CXExtVectorElementExpr E) {
  return reinterpret_cast<clang::ExtVectorElementExpr *>(E)->isArrow();
}

// Expr
CXExpr clang_Expr_IgnoreConversionOperatorSingleStep(CXExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::Expr *>(E)->IgnoreConversionOperatorSingleStep());
}

// Expr
void clang_Expr_setType(CXExpr E, CXQualType T) {
  reinterpret_cast<clang::Expr *>(E)->setType(clang::QualType::getFromOpaquePtr(T));
}

bool clang_Expr_isReadIfDiscardedInCPlusPlus11(CXExpr E) {
  return reinterpret_cast<clang::Expr *>(E)->isReadIfDiscardedInCPlusPlus11();
}

void clang_Expr_setValueKind(CXExpr E, CXExprValueKind Cat) {
  reinterpret_cast<clang::Expr *>(E)->setValueKind(static_cast<clang::ExprValueKind>(Cat));
}

void clang_Expr_setObjectKind(CXExpr E, CXExprObjectKind Cat) {
  reinterpret_cast<clang::Expr *>(E)->setObjectKind(static_cast<clang::ExprObjectKind>(Cat));
}

CXExpr clang_Expr_getBestDynamicClassTypeExpr(CXExpr E) {
  return reinterpret_cast<CXExpr>(const_cast<clang::Expr *>(
      reinterpret_cast<clang::Expr *>(E)->getBestDynamicClassTypeExpr()));
}

CXExpr clang_Expr_skipRValueSubobjectAdjustments(CXExpr E) {
  return reinterpret_cast<CXExpr>(const_cast<clang::Expr *>(
      reinterpret_cast<clang::Expr *>(E)->skipRValueSubobjectAdjustments()));
}

// FullExpr
CXExpr clang_FullExpr_getSubExpr(CXFullExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::FullExpr *>(E)->getSubExpr());
}

// ConstantExpr
CXConstantResultStorageKind clang_ConstantExpr_getResultStorageKind(CXConstantExpr E) {
  return static_cast<CXConstantResultStorageKind>(
      reinterpret_cast<clang::ConstantExpr *>(E)->getResultStorageKind());
}

CXAPValueKind clang_ConstantExpr_getResultAPValueKind(CXConstantExpr E) {
  return static_cast<CXAPValueKind>(
      reinterpret_cast<clang::ConstantExpr *>(E)->getResultAPValueKind());
}

// ShuffleVectorExpr
CXSourceLocation_ clang_ShuffleVectorExpr_getBuiltinLoc(CXShuffleVectorExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ShuffleVectorExpr *>(E)->getBuiltinLoc().getPtrEncoding());
}

void clang_ShuffleVectorExpr_setBuiltinLoc(CXShuffleVectorExpr E, CXSourceLocation_ L) {
  reinterpret_cast<clang::ShuffleVectorExpr *>(E)->setBuiltinLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

CXSourceLocation_ clang_ShuffleVectorExpr_getRParenLoc(CXShuffleVectorExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::ShuffleVectorExpr *>(E)->getRParenLoc().getPtrEncoding());
}

void clang_ShuffleVectorExpr_setRParenLoc(CXShuffleVectorExpr E, CXSourceLocation_ L) {
  reinterpret_cast<clang::ShuffleVectorExpr *>(E)->setRParenLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

// SourceLocExpr
CXSourceLocIdentKind clang_SourceLocExpr_getIdentKind(CXSourceLocExpr E) {
  return static_cast<CXSourceLocIdentKind>(
      reinterpret_cast<clang::SourceLocExpr *>(E)->getIdentKind());
}

bool clang_SourceLocExpr_MayBeDependent(CXSourceLocIdentKind Kind) {
  return clang::SourceLocExpr::MayBeDependent(static_cast<clang::SourceLocIdentKind>(Kind));
}

// BlockExpr
CXFunctionProtoType clang_BlockExpr_getFunctionType(CXBlockExpr E) {
  return reinterpret_cast<CXFunctionProtoType>(const_cast<clang::FunctionProtoType *>(
      reinterpret_cast<clang::BlockExpr *>(E)->getFunctionType()));
}

// AtomicExpr
CXExpr clang_AtomicExpr_getVal1(CXAtomicExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::AtomicExpr *>(E)->getVal1());
}

CXExpr clang_AtomicExpr_getOrderFail(CXAtomicExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::AtomicExpr *>(E)->getOrderFail());
}

CXExpr clang_AtomicExpr_getVal2(CXAtomicExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::AtomicExpr *>(E)->getVal2());
}

CXExpr clang_AtomicExpr_getWeak(CXAtomicExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::AtomicExpr *>(E)->getWeak());
}

// Expr
CXExpr_isModifiableLvalueResult clang_Expr_isModifiableLvalue(CXExpr E, CXASTContext Ctx) {
  return static_cast<CXExpr_isModifiableLvalueResult>(
      reinterpret_cast<clang::Expr *>(E)->isModifiableLvalue(
          *reinterpret_cast<clang::ASTContext *>(Ctx)));
}

void clang_Expr_EvaluateForOverflow(CXExpr E, CXASTContext Ctx) {
  reinterpret_cast<clang::Expr *>(E)->EvaluateForOverflow(
      *reinterpret_cast<clang::ASTContext *>(Ctx));
}

bool clang_Expr_isPotentialConstantExpr(CXFunctionDecl FD) {
  llvm::SmallVector<clang::PartialDiagnosticAt, 8> Diags;
  return clang::Expr::isPotentialConstantExpr(reinterpret_cast<clang::FunctionDecl *>(FD),
                                              Diags);
}

bool clang_Expr_hasAnyTypeDependentArguments(const CXExpr *Exprs, unsigned NumExprs) {
  llvm::SmallVector<clang::Expr *, 8> Args;
  Args.reserve(NumExprs);
  for (unsigned I = 0; I < NumExprs; ++I)
    Args.push_back(reinterpret_cast<clang::Expr *>(Exprs[I]));
  return clang::Expr::hasAnyTypeDependentArguments(Args);
}

bool clang_Expr_isUnusedResultAWarning(CXExpr E, CXASTContext Ctx) {
  const clang::Expr *WarnExpr = nullptr;
  clang::SourceLocation Loc;
  clang::SourceRange R1;
  clang::SourceRange R2;
  return reinterpret_cast<clang::Expr *>(E)->isUnusedResultAWarning(
      WarnExpr, Loc, R1, R2, *reinterpret_cast<clang::ASTContext *>(Ctx));
}

// StringLiteral
CXString clang_StringLiteral_outputString(CXStringLiteral SL) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::StringLiteral *>(SL)->outputString(OS);
  return extra::makeCXString(S);
}

CXSourceLocation_ clang_StringLiteral_getLocationOfByte(CXStringLiteral SL, unsigned ByteNo,
                                                        CXSourceManager SM,
                                                        CXLangOptions Features,
                                                        CXTargetInfo_ Target) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::StringLiteral *>(SL)
      ->getLocationOfByte(ByteNo, *reinterpret_cast<clang::SourceManager *>(SM),
                          *reinterpret_cast<clang::LangOptions *>(Features),
                          *reinterpret_cast<clang::TargetInfo *>(Target))
      .getPtrEncoding());
}

// PredefinedExpr
bool clang_PredefinedExpr_isTransparent(CXPredefinedExpr E) {
  return reinterpret_cast<clang::PredefinedExpr *>(E)->isTransparent();
}

CXSourceLocation_ clang_PredefinedExpr_getLocation(CXPredefinedExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::PredefinedExpr *>(E)->getLocation().getPtrEncoding());
}

CXString clang_PredefinedExpr_ComputeName(CXPredefinedIdentKind IK, CXDecl CurrentDecl) {
  return extra::makeCXString(
      clang::PredefinedExpr::ComputeName(static_cast<clang::PredefinedIdentKind>(IK),
                                         reinterpret_cast<clang::Decl *>(CurrentDecl)));
}

// ConstantExpr
CXConstantResultStorageKind clang_ConstantExpr_getStorageKind(CXAPValue V) {
  return static_cast<CXConstantResultStorageKind>(
      clang::ConstantExpr::getStorageKind(*reinterpret_cast<clang::APValue *>(V)));
}

CXConstantResultStorageKind clang_ConstantExpr_getStorageKindForType(CXType_ T,
                                                                     CXASTContext Ctx) {
  return static_cast<CXConstantResultStorageKind>(clang::ConstantExpr::getStorageKind(
      reinterpret_cast<clang::Type *>(T), *reinterpret_cast<clang::ASTContext *>(Ctx)));
}

// ShuffleVectorExpr
LLVMGenericValueRef clang_ShuffleVectorExpr_getShuffleMaskIdx(CXShuffleVectorExpr E,
                                                              CXASTContext Ctx,
                                                              unsigned N) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = reinterpret_cast<clang::ShuffleVectorExpr *>(E)->getShuffleMaskIdx(
      *reinterpret_cast<clang::ASTContext *>(Ctx), N);
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

// ExtVectorElementExpr
void clang_ExtVectorElementExpr_getEncodedElementAccess(CXExtVectorElementExpr E,
                                                        unsigned *Elts) {
  llvm::SmallVector<uint32_t, 8> Indices;
  reinterpret_cast<clang::ExtVectorElementExpr *>(E)->getEncodedElementAccess(Indices);
  for (unsigned I = 0, N = Indices.size(); I < N; ++I)
    Elts[I] = Indices[I];
}

// GenericSelectionExpr
CXTypeSourceInfo clang_GenericSelectionExpr_getAssocTypeSourceInfo(CXGenericSelectionExpr E,
                                                                   unsigned I) {
  return reinterpret_cast<CXTypeSourceInfo>(reinterpret_cast<clang::GenericSelectionExpr *>(E)->getAssocTypeSourceInfos()[I]);
}

// ArrayInitLoopExpr
LLVMGenericValueRef clang_ArrayInitLoopExpr_getArraySize(CXArrayInitLoopExpr E) {
  auto *GV = new llvm::GenericValue; // NOLINT(*-owning-memory)
  GV->IntVal = reinterpret_cast<clang::ArrayInitLoopExpr *>(E)->getArraySize();
  return reinterpret_cast<LLVMGenericValueRef>(GV);
}

// DesignatedInitExpr::Designator
CXSourceRange_ clang_Designator_getSourceRange(CXDesignator D) {
  clang::SourceRange R =
      reinterpret_cast<clang::DesignatedInitExpr::Designator *>(D)->getSourceRange();
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

// ParenExpr
void clang_ParenExpr_setSubExpr(CXParenExpr E, CXExpr SubExpr) {
  reinterpret_cast<clang::ParenExpr *>(E)->setSubExpr(reinterpret_cast<clang::Expr *>(SubExpr));
}

void clang_ParenExpr_setLParen(CXParenExpr E, CXSourceLocation_ L) {
  reinterpret_cast<clang::ParenExpr *>(E)->setLParen(
      clang::SourceLocation::getFromPtrEncoding(L));
}

void clang_ParenExpr_setRParen(CXParenExpr E, CXSourceLocation_ L) {
  reinterpret_cast<clang::ParenExpr *>(E)->setRParen(
      clang::SourceLocation::getFromPtrEncoding(L));
}

// UnaryOperator
void clang_UnaryOperator_setOpcode(CXUnaryOperator UO, CXUnaryOperatorKind Opc) {
  reinterpret_cast<clang::UnaryOperator *>(UO)->setOpcode(
      static_cast<clang::UnaryOperator::Opcode>(Opc));
}

void clang_UnaryOperator_setSubExpr(CXUnaryOperator UO, CXExpr E) {
  reinterpret_cast<clang::UnaryOperator *>(UO)->setSubExpr(reinterpret_cast<clang::Expr *>(E));
}

void clang_UnaryOperator_setCanOverflow(CXUnaryOperator UO, bool C) {
  reinterpret_cast<clang::UnaryOperator *>(UO)->setCanOverflow(C);
}

// ArraySubscriptExpr
void clang_ArraySubscriptExpr_setLHS(CXArraySubscriptExpr E, CXExpr LHS) {
  reinterpret_cast<clang::ArraySubscriptExpr *>(E)->setLHS(reinterpret_cast<clang::Expr *>(LHS));
}

void clang_ArraySubscriptExpr_setRHS(CXArraySubscriptExpr E, CXExpr RHS) {
  reinterpret_cast<clang::ArraySubscriptExpr *>(E)->setRHS(reinterpret_cast<clang::Expr *>(RHS));
}

void clang_ArraySubscriptExpr_setRBracketLoc(CXArraySubscriptExpr E, CXSourceLocation_ L) {
  reinterpret_cast<clang::ArraySubscriptExpr *>(E)->setRBracketLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

// BinaryOperator
void clang_BinaryOperator_setOpcode(CXBinaryOperator BO, CXBinaryOperatorKind Opc) {
  reinterpret_cast<clang::BinaryOperator *>(BO)->setOpcode(
      static_cast<clang::BinaryOperator::Opcode>(Opc));
}

void clang_BinaryOperator_setLHS(CXBinaryOperator BO, CXExpr E) {
  reinterpret_cast<clang::BinaryOperator *>(BO)->setLHS(reinterpret_cast<clang::Expr *>(E));
}

void clang_BinaryOperator_setRHS(CXBinaryOperator BO, CXExpr E) {
  reinterpret_cast<clang::BinaryOperator *>(BO)->setRHS(reinterpret_cast<clang::Expr *>(E));
}

void clang_BinaryOperator_setOperatorLoc(CXBinaryOperator BO, CXSourceLocation_ L) {
  reinterpret_cast<clang::BinaryOperator *>(BO)->setOperatorLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

// CharacterLiteral
void clang_CharacterLiteral_setValue(CXCharacterLiteral CL, unsigned Val) {
  reinterpret_cast<clang::CharacterLiteral *>(CL)->setValue(Val);
}

void clang_CharacterLiteral_setKind(CXCharacterLiteral CL, CXCharacterLiteralKind Kind) {
  reinterpret_cast<clang::CharacterLiteral *>(CL)->setKind(
      static_cast<clang::CharacterLiteralKind>(Kind));
}

void clang_CharacterLiteral_setLocation(CXCharacterLiteral CL, CXSourceLocation_ L) {
  reinterpret_cast<clang::CharacterLiteral *>(CL)->setLocation(
      clang::SourceLocation::getFromPtrEncoding(L));
}

CXString clang_CharacterLiteral_print(unsigned Val, CXCharacterLiteralKind Kind) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  clang::CharacterLiteral::print(Val, static_cast<clang::CharacterLiteralKind>(Kind), OS);
  return extra::makeCXString(S);
}

// GenericSelectionExpr
CXTypeSourceInfo clang_GenericSelectionExpr_getControllingType(CXGenericSelectionExpr E) {
  return reinterpret_cast<CXTypeSourceInfo>(reinterpret_cast<clang::GenericSelectionExpr *>(E)->getControllingType());
}

// AtomicExpr
bool clang_AtomicExpr_hasScopeModel(CXAtomicExpr E) {
  return reinterpret_cast<clang::AtomicExpr *>(E)->getScopeModel() != nullptr;
}

CXExpr clang_AtomicExpr_getScope(CXAtomicExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::AtomicExpr *>(E)->getScope());
}

// FullExpr
void clang_FullExpr_setSubExpr(CXFullExpr E, CXExpr SubExpr) {
  reinterpret_cast<clang::FullExpr *>(E)->setSubExpr(reinterpret_cast<clang::Expr *>(SubExpr));
}

// DeclRefExpr
void clang_DeclRefExpr_setDecl(CXDeclRefExpr E, CXValueDecl NewD) {
  reinterpret_cast<clang::DeclRefExpr *>(E)->setDecl(reinterpret_cast<clang::ValueDecl *>(NewD));
}

void clang_DeclRefExpr_setHadMultipleCandidates(CXDeclRefExpr E, bool V) {
  reinterpret_cast<clang::DeclRefExpr *>(E)->setHadMultipleCandidates(V);
}

// UnaryExprOrTypeTraitExpr
void clang_UnaryExprOrTypeTraitExpr_setKind(CXUnaryExprOrTypeTraitExpr E,
                                            CXUnaryExprOrTypeTrait K) {
  reinterpret_cast<clang::UnaryExprOrTypeTraitExpr *>(E)->setKind(
      static_cast<clang::UnaryExprOrTypeTrait>(K));
}

void clang_UnaryExprOrTypeTraitExpr_setArgumentExpr(CXUnaryExprOrTypeTraitExpr E,
                                                    CXExpr Arg) {
  reinterpret_cast<clang::UnaryExprOrTypeTraitExpr *>(E)->setArgument(
      reinterpret_cast<clang::Expr *>(Arg));
}

// CallExpr
void clang_CallExpr_setCallee(CXCallExpr CE, CXExpr F) {
  reinterpret_cast<clang::CallExpr *>(CE)->setCallee(reinterpret_cast<clang::Expr *>(F));
}

void clang_CallExpr_setArg(CXCallExpr CE, unsigned Arg, CXExpr ArgExpr) {
  reinterpret_cast<clang::CallExpr *>(CE)->setArg(Arg, reinterpret_cast<clang::Expr *>(ArgExpr));
}

// MemberExpr
void clang_MemberExpr_setBase(CXMemberExpr E, CXExpr Base) {
  reinterpret_cast<clang::MemberExpr *>(E)->setBase(reinterpret_cast<clang::Expr *>(Base));
}

void clang_MemberExpr_setMemberDecl(CXMemberExpr E, CXValueDecl D) {
  reinterpret_cast<clang::MemberExpr *>(E)->setMemberDecl(reinterpret_cast<clang::ValueDecl *>(D));
}

void clang_MemberExpr_setArrow(CXMemberExpr E, bool A) {
  reinterpret_cast<clang::MemberExpr *>(E)->setArrow(A);
}

void clang_MemberExpr_setHadMultipleCandidates(CXMemberExpr E, bool V) {
  reinterpret_cast<clang::MemberExpr *>(E)->setHadMultipleCandidates(V);
}

// CastExpr
void clang_CastExpr_setCastKind(CXCastExpr E, CXCastKind K) {
  reinterpret_cast<clang::CastExpr *>(E)->setCastKind(static_cast<clang::CastKind>(K));
}

void clang_CastExpr_setSubExpr(CXCastExpr E, CXExpr SubExpr) {
  reinterpret_cast<clang::CastExpr *>(E)->setSubExpr(reinterpret_cast<clang::Expr *>(SubExpr));
}

// ImplicitCastExpr
void clang_ImplicitCastExpr_setIsPartOfExplicitCast(CXImplicitCastExpr E,
                                                    bool PartOfExplicitCast) {
  reinterpret_cast<clang::ImplicitCastExpr *>(E)->setIsPartOfExplicitCast(PartOfExplicitCast);
}

// ExplicitCastExpr
void clang_ExplicitCastExpr_setTypeInfoAsWritten(CXExplicitCastExpr E,
                                                 CXTypeSourceInfo WrittenTy) {
  reinterpret_cast<clang::ExplicitCastExpr *>(E)->setTypeInfoAsWritten(
      reinterpret_cast<clang::TypeSourceInfo *>(WrittenTy));
}

// InitListExpr
void clang_InitListExpr_setInit(CXInitListExpr E, unsigned Init, CXExpr Val) {
  reinterpret_cast<clang::InitListExpr *>(E)->setInit(Init, reinterpret_cast<clang::Expr *>(Val));
}

void clang_InitListExpr_setArrayFiller(CXInitListExpr E, CXExpr Filler) {
  reinterpret_cast<clang::InitListExpr *>(E)->setArrayFiller(reinterpret_cast<clang::Expr *>(Filler));
}

void clang_InitListExpr_setInitializedFieldInUnion(CXInitListExpr E, CXFieldDecl FD) {
  reinterpret_cast<clang::InitListExpr *>(E)->setInitializedFieldInUnion(
      reinterpret_cast<clang::FieldDecl *>(FD));
}

void clang_InitListExpr_setSyntacticForm(CXInitListExpr E, CXInitListExpr Init) {
  reinterpret_cast<clang::InitListExpr *>(E)->setSyntacticForm(
      reinterpret_cast<clang::InitListExpr *>(Init));
}

void clang_InitListExpr_sawArrayRangeDesignator(CXInitListExpr E, bool ARD) {
  reinterpret_cast<clang::InitListExpr *>(E)->sawArrayRangeDesignator(ARD);
}

// UnaryOperator
bool clang_UnaryOperator_isFPContractableWithinStatement(CXUnaryOperator UO,
                                                         CXLangOptions LO) {
  return reinterpret_cast<clang::UnaryOperator *>(UO)->isFPContractableWithinStatement(
      *reinterpret_cast<clang::LangOptions *>(LO));
}

bool clang_UnaryOperator_isFEnvAccessOn(CXUnaryOperator UO, CXLangOptions LO) {
  return reinterpret_cast<clang::UnaryOperator *>(UO)->isFEnvAccessOn(
      *reinterpret_cast<clang::LangOptions *>(LO));
}

// UnaryExprOrTypeTraitExpr
void clang_UnaryExprOrTypeTraitExpr_setOperatorLoc(CXUnaryExprOrTypeTraitExpr E,
                                                   CXSourceLocation_ L) {
  reinterpret_cast<clang::UnaryExprOrTypeTraitExpr *>(E)->setOperatorLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

void clang_UnaryExprOrTypeTraitExpr_setRParenLoc(CXUnaryExprOrTypeTraitExpr E,
                                                 CXSourceLocation_ L) {
  reinterpret_cast<clang::UnaryExprOrTypeTraitExpr *>(E)->setRParenLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

// BinaryOperator
bool clang_BinaryOperator_isFPContractableWithinStatement(CXBinaryOperator BO,
                                                          CXLangOptions LO) {
  return reinterpret_cast<clang::BinaryOperator *>(BO)->isFPContractableWithinStatement(
      *reinterpret_cast<clang::LangOptions *>(LO));
}

bool clang_BinaryOperator_isFEnvAccessOn(CXBinaryOperator BO, CXLangOptions LO) {
  return reinterpret_cast<clang::BinaryOperator *>(BO)->isFEnvAccessOn(
      *reinterpret_cast<clang::LangOptions *>(LO));
}

// StmtExpr
void clang_StmtExpr_setSubStmt(CXStmtExpr E, CXCompoundStmt S) {
  reinterpret_cast<clang::StmtExpr *>(E)->setSubStmt(reinterpret_cast<clang::CompoundStmt *>(S));
}

void clang_StmtExpr_setLParenLoc(CXStmtExpr E, CXSourceLocation_ L) {
  reinterpret_cast<clang::StmtExpr *>(E)->setLParenLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

void clang_StmtExpr_setRParenLoc(CXStmtExpr E, CXSourceLocation_ L) {
  reinterpret_cast<clang::StmtExpr *>(E)->setRParenLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

// ChooseExpr
void clang_ChooseExpr_setIsConditionTrue(CXChooseExpr E, bool IsTrue) {
  reinterpret_cast<clang::ChooseExpr *>(E)->setIsConditionTrue(IsTrue);
}

void clang_ChooseExpr_setCond(CXChooseExpr E, CXExpr Cond) {
  reinterpret_cast<clang::ChooseExpr *>(E)->setCond(reinterpret_cast<clang::Expr *>(Cond));
}

void clang_ChooseExpr_setLHS(CXChooseExpr E, CXExpr LHS) {
  reinterpret_cast<clang::ChooseExpr *>(E)->setLHS(reinterpret_cast<clang::Expr *>(LHS));
}

void clang_ChooseExpr_setRHS(CXChooseExpr E, CXExpr RHS) {
  reinterpret_cast<clang::ChooseExpr *>(E)->setRHS(reinterpret_cast<clang::Expr *>(RHS));
}

void clang_ChooseExpr_setBuiltinLoc(CXChooseExpr E, CXSourceLocation_ L) {
  reinterpret_cast<clang::ChooseExpr *>(E)->setBuiltinLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

void clang_ChooseExpr_setRParenLoc(CXChooseExpr E, CXSourceLocation_ L) {
  reinterpret_cast<clang::ChooseExpr *>(E)->setRParenLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

// VAArgExpr
void clang_VAArgExpr_setSubExpr(CXVAArgExpr E, CXExpr Sub) {
  reinterpret_cast<clang::VAArgExpr *>(E)->setSubExpr(reinterpret_cast<clang::Expr *>(Sub));
}

void clang_VAArgExpr_setIsMicrosoftABI(CXVAArgExpr E, bool IsMS) {
  reinterpret_cast<clang::VAArgExpr *>(E)->setIsMicrosoftABI(IsMS);
}

void clang_VAArgExpr_setWrittenTypeInfo(CXVAArgExpr E, CXTypeSourceInfo TI) {
  reinterpret_cast<clang::VAArgExpr *>(E)->setWrittenTypeInfo(
      reinterpret_cast<clang::TypeSourceInfo *>(TI));
}

void clang_VAArgExpr_setBuiltinLoc(CXVAArgExpr E, CXSourceLocation_ L) {
  reinterpret_cast<clang::VAArgExpr *>(E)->setBuiltinLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

void clang_VAArgExpr_setRParenLoc(CXVAArgExpr E, CXSourceLocation_ L) {
  reinterpret_cast<clang::VAArgExpr *>(E)->setRParenLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

// OpaqueValueExpr
void clang_OpaqueValueExpr_setIsUnique(CXOpaqueValueExpr E, bool V) {
  reinterpret_cast<clang::OpaqueValueExpr *>(E)->setIsUnique(V);
}

// PredefinedExpr
void clang_PredefinedExpr_setLocation(CXPredefinedExpr E, CXSourceLocation_ L) {
  reinterpret_cast<clang::PredefinedExpr *>(E)->setLocation(
      clang::SourceLocation::getFromPtrEncoding(L));
}

// CompoundLiteralExpr
void clang_CompoundLiteralExpr_setInitializer(CXCompoundLiteralExpr E, CXExpr Init) {
  reinterpret_cast<clang::CompoundLiteralExpr *>(E)->setInitializer(
      reinterpret_cast<clang::Expr *>(Init));
}

void clang_CompoundLiteralExpr_setFileScope(CXCompoundLiteralExpr E, bool FS) {
  reinterpret_cast<clang::CompoundLiteralExpr *>(E)->setFileScope(FS);
}

void clang_CompoundLiteralExpr_setLParenLoc(CXCompoundLiteralExpr E, CXSourceLocation_ L) {
  reinterpret_cast<clang::CompoundLiteralExpr *>(E)->setLParenLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

void clang_CompoundLiteralExpr_setTypeSourceInfo(CXCompoundLiteralExpr E,
                                                 CXTypeSourceInfo TI) {
  reinterpret_cast<clang::CompoundLiteralExpr *>(E)->setTypeSourceInfo(
      reinterpret_cast<clang::TypeSourceInfo *>(TI));
}

// CompoundAssignOperator
void clang_CompoundAssignOperator_setComputationLHSType(CXCompoundAssignOperator CAO,
                                                        CXQualType T) {
  reinterpret_cast<clang::CompoundAssignOperator *>(CAO)->setComputationLHSType(
      clang::QualType::getFromOpaquePtr(T));
}

void clang_CompoundAssignOperator_setComputationResultType(CXCompoundAssignOperator CAO,
                                                           CXQualType T) {
  reinterpret_cast<clang::CompoundAssignOperator *>(CAO)->setComputationResultType(
      clang::QualType::getFromOpaquePtr(T));
}

// AddrLabelExpr
void clang_AddrLabelExpr_setAmpAmpLoc(CXAddrLabelExpr E, CXSourceLocation_ L) {
  reinterpret_cast<clang::AddrLabelExpr *>(E)->setAmpAmpLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

void clang_AddrLabelExpr_setLabelLoc(CXAddrLabelExpr E, CXSourceLocation_ L) {
  reinterpret_cast<clang::AddrLabelExpr *>(E)->setLabelLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

void clang_AddrLabelExpr_setLabel(CXAddrLabelExpr E, CXLabelDecl L) {
  reinterpret_cast<clang::AddrLabelExpr *>(E)->setLabel(reinterpret_cast<clang::LabelDecl *>(L));
}

// ConvertVectorExpr
void clang_ConvertVectorExpr_setTypeSourceInfo(CXConvertVectorExpr E, CXTypeSourceInfo TI) {
  reinterpret_cast<clang::ConvertVectorExpr *>(E)->setTypeSourceInfo(
      reinterpret_cast<clang::TypeSourceInfo *>(TI));
}

// GNUNullExpr
void clang_GNUNullExpr_setTokenLocation(CXGNUNullExpr E, CXSourceLocation_ L) {
  reinterpret_cast<clang::GNUNullExpr *>(E)->setTokenLocation(
      clang::SourceLocation::getFromPtrEncoding(L));
}

// DesignatedInitUpdateExpr
CXExpr clang_DesignatedInitUpdateExpr_getBase(CXDesignatedInitUpdateExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::DesignatedInitUpdateExpr *>(E)->getBase());
}

void clang_DesignatedInitUpdateExpr_setBase(CXDesignatedInitUpdateExpr E, CXExpr Base) {
  reinterpret_cast<clang::DesignatedInitUpdateExpr *>(E)->setBase(
      reinterpret_cast<clang::Expr *>(Base));
}

CXInitListExpr clang_DesignatedInitUpdateExpr_getUpdater(CXDesignatedInitUpdateExpr E) {
  return reinterpret_cast<CXInitListExpr>(reinterpret_cast<clang::DesignatedInitUpdateExpr *>(E)->getUpdater());
}

void clang_DesignatedInitUpdateExpr_setUpdater(CXDesignatedInitUpdateExpr E,
                                               CXInitListExpr Updater) {
  reinterpret_cast<clang::DesignatedInitUpdateExpr *>(E)->setUpdater(
      reinterpret_cast<clang::InitListExpr *>(Updater));
}

// ExtVectorElementExpr
void clang_ExtVectorElementExpr_setBase(CXExtVectorElementExpr E, CXExpr Base) {
  reinterpret_cast<clang::ExtVectorElementExpr *>(E)->setBase(reinterpret_cast<clang::Expr *>(Base));
}

void clang_ExtVectorElementExpr_setAccessor(CXExtVectorElementExpr E, CXIdentifierInfo II) {
  reinterpret_cast<clang::ExtVectorElementExpr *>(E)->setAccessor(
      reinterpret_cast<clang::IdentifierInfo *>(II));
}

void clang_ExtVectorElementExpr_setAccessorLoc(CXExtVectorElementExpr E,
                                               CXSourceLocation_ L) {
  reinterpret_cast<clang::ExtVectorElementExpr *>(E)->setAccessorLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

// Expr
CXExpr_LValueClassification clang_Expr_ClassifyLValue(CXExpr E, CXASTContext Ctx) {
  return static_cast<CXExpr_LValueClassification>(
      reinterpret_cast<clang::Expr *>(E)->ClassifyLValue(
          *reinterpret_cast<clang::ASTContext *>(Ctx)));
}

unsigned clang_Expr_getFPFeaturesInEffect(CXExpr E, CXLangOptions LO) {
  return reinterpret_cast<clang::Expr *>(E)
      ->getFPFeaturesInEffect(*reinterpret_cast<clang::LangOptions *>(LO))
      .getAsOpaqueInt();
}

bool clang_Expr_isPotentialConstantExprUnevaluated(CXExpr E, CXFunctionDecl FD) {
  llvm::SmallVector<clang::PartialDiagnosticAt, 8> Diags;
  return clang::Expr::isPotentialConstantExprUnevaluated(
      reinterpret_cast<clang::Expr *>(E), reinterpret_cast<clang::FunctionDecl *>(FD), Diags);
}

CXAPValue clang_Expr_EvaluateAsInitializer(CXExpr E, CXASTContext Ctx, CXVarDecl VD,
                                           bool IsConstantInitializer) {
  clang::APValue Value;
  llvm::SmallVector<clang::PartialDiagnosticAt, 8> Notes;
  if (!reinterpret_cast<clang::Expr *>(E)->EvaluateAsInitializer(
          Value, *reinterpret_cast<clang::ASTContext *>(Ctx), reinterpret_cast<clang::VarDecl *>(VD),
          Notes, IsConstantInitializer))
    return nullptr;
  return reinterpret_cast<CXAPValue>(new clang::APValue(Value)); // NOLINT(*-owning-memory)
}

CXAPValue clang_Expr_EvaluateWithSubstitution(CXExpr E, CXASTContext Ctx,
                                              CXFunctionDecl Callee, const CXExpr *Args,
                                              unsigned NumArgs, CXExpr This) {
  llvm::SmallVector<const clang::Expr *, 8> ArgExprs;
  ArgExprs.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    ArgExprs.push_back(reinterpret_cast<const clang::Expr *>(Args[I]));
  clang::APValue Value;
  if (!reinterpret_cast<clang::Expr *>(E)->EvaluateWithSubstitution(
          Value, *reinterpret_cast<clang::ASTContext *>(Ctx),
          reinterpret_cast<clang::FunctionDecl *>(Callee), ArgExprs,
          reinterpret_cast<clang::Expr *>(This)))
    return nullptr;
  return reinterpret_cast<CXAPValue>(new clang::APValue(Value)); // NOLINT(*-owning-memory)
}

// CallExpr
void clang_CallExpr_setADLCallKind(CXCallExpr E, bool UsesADL) {
  reinterpret_cast<clang::CallExpr *>(E)->setADLCallKind(UsesADL ? clang::CallExpr::UsesADL
                                                            : clang::CallExpr::NotADL);
}

// CastExpr
uint64_t clang_CastExpr_getFPFeatures(CXCastExpr E) {
  return reinterpret_cast<clang::CastExpr *>(E)->getFPFeatures().getAsOpaqueInt();
}

uint64_t clang_CastExpr_getStoredFPFeatures(CXCastExpr E) {
  return reinterpret_cast<clang::CastExpr *>(E)->getStoredFPFeatures().getAsOpaqueInt();
}

// OffsetOfExpr
void clang_OffsetOfExpr_setOperatorLoc(CXOffsetOfExpr E, CXSourceLocation_ L) {
  reinterpret_cast<clang::OffsetOfExpr *>(E)->setOperatorLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

void clang_OffsetOfExpr_setRParenLoc(CXOffsetOfExpr E, CXSourceLocation_ R) {
  reinterpret_cast<clang::OffsetOfExpr *>(E)->setRParenLoc(
      clang::SourceLocation::getFromPtrEncoding(R));
}

void clang_OffsetOfExpr_setTypeSourceInfo(CXOffsetOfExpr E, CXTypeSourceInfo TSI) {
  reinterpret_cast<clang::OffsetOfExpr *>(E)->setTypeSourceInfo(
      reinterpret_cast<clang::TypeSourceInfo *>(TSI));
}

void clang_OffsetOfExpr_setIndexExpr(CXOffsetOfExpr E, unsigned Idx, CXExpr Value) {
  reinterpret_cast<clang::OffsetOfExpr *>(E)->setIndexExpr(Idx,
                                                      reinterpret_cast<clang::Expr *>(Value));
}

// InitListExpr
void clang_InitListExpr_reserveInits(CXInitListExpr E, CXASTContext C, unsigned NumInits) {
  reinterpret_cast<clang::InitListExpr *>(E)->reserveInits(*reinterpret_cast<clang::ASTContext *>(C),
                                                      NumInits);
}

CXExpr clang_InitListExpr_updateInit(CXInitListExpr E, CXASTContext C, unsigned Init,
                                     CXExpr Value) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::InitListExpr *>(E)->updateInit(
      *reinterpret_cast<clang::ASTContext *>(C), Init, reinterpret_cast<clang::Expr *>(Value)));
}

void clang_InitListExpr_markError(CXInitListExpr E) {
  reinterpret_cast<clang::InitListExpr *>(E)->markError();
}

// DesignatedInitExpr
void clang_DesignatedInitExpr_setEqualOrColonLoc(CXDesignatedInitExpr E,
                                                 CXSourceLocation_ L) {
  reinterpret_cast<clang::DesignatedInitExpr *>(E)->setEqualOrColonLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

void clang_DesignatedInitExpr_setGNUSyntax(CXDesignatedInitExpr E, bool GNU) {
  reinterpret_cast<clang::DesignatedInitExpr *>(E)->setGNUSyntax(GNU);
}

void clang_DesignatedInitExpr_setInit(CXDesignatedInitExpr E, CXExpr Init) {
  reinterpret_cast<clang::DesignatedInitExpr *>(E)->setInit(reinterpret_cast<clang::Expr *>(Init));
}

void clang_DesignatedInitExpr_setSubExpr(CXDesignatedInitExpr E, unsigned Idx,
                                         CXExpr Value) {
  reinterpret_cast<clang::DesignatedInitExpr *>(E)->setSubExpr(
      Idx, reinterpret_cast<clang::Expr *>(Value));
}

// SourceLocExpr
CXAPValue clang_SourceLocExpr_EvaluateInContext(CXSourceLocExpr E, CXASTContext Ctx,
                                                CXExpr DefaultExpr) {
  return reinterpret_cast<CXAPValue>(new clang::APValue( // NOLINT(*-owning-memory)
      reinterpret_cast<clang::SourceLocExpr *>(E)->EvaluateInContext(
          *reinterpret_cast<clang::ASTContext *>(Ctx), reinterpret_cast<clang::Expr *>(DefaultExpr))));
}

// CallExpr
void clang_CallExpr_computeDependence(CXCallExpr CE) {
  reinterpret_cast<clang::CallExpr *>(CE)->computeDependence();
}

void clang_CallExpr_markDependentForPostponedNameLookup(CXCallExpr CE) {
  reinterpret_cast<clang::CallExpr *>(CE)->markDependentForPostponedNameLookup();
}

void clang_CallExpr_shrinkNumArgs(CXCallExpr CE, unsigned NewNumArgs) {
  reinterpret_cast<clang::CallExpr *>(CE)->shrinkNumArgs(NewNumArgs);
}

// InitListExpr
void clang_InitListExpr_resizeInits(CXInitListExpr E, CXASTContext C, unsigned NumInits) {
  reinterpret_cast<clang::InitListExpr *>(E)->resizeInits(*reinterpret_cast<clang::ASTContext *>(C),
                                                     NumInits);
}

// DeclRefExpr
void clang_DeclRefExpr_setIsImmediateEscalating(CXDeclRefExpr E, bool Set) {
  reinterpret_cast<clang::DeclRefExpr *>(E)->setIsImmediateEscalating(Set);
}

// FloatingLiteral
void clang_FloatingLiteral_setExact(CXFloatingLiteral E, bool Exact) {
  reinterpret_cast<clang::FloatingLiteral *>(E)->setExact(Exact);
}

// BinaryOperator
bool clang_BinaryOperator_isCompoundAssignmentOpKind(CXBinaryOperatorKind Opc) {
  return clang::BinaryOperator::isCompoundAssignmentOp(
      static_cast<clang::BinaryOperatorKind>(Opc));
}

CXBinaryOperator clang_BinaryOperator_Create(CXASTContext C, CXExpr LHS, CXExpr RHS,
                                             CXBinaryOperatorKind Opc, CXQualType ResTy,
                                             CXExprValueKind VK, CXExprObjectKind OK,
                                             CXSourceLocation_ OpLoc, uint64_t FPFeatures) {
  return reinterpret_cast<CXBinaryOperator>(clang::BinaryOperator::Create(
      *reinterpret_cast<clang::ASTContext *>(C), reinterpret_cast<clang::Expr *>(LHS),
      reinterpret_cast<clang::Expr *>(RHS), static_cast<clang::BinaryOperatorKind>(Opc),
      clang::QualType::getFromOpaquePtr(ResTy), static_cast<clang::ExprValueKind>(VK),
      static_cast<clang::ExprObjectKind>(OK),
      clang::SourceLocation::getFromPtrEncoding(OpLoc),
      clang::FPOptionsOverride::getFromOpaqueInt(FPFeatures)));
}

CXBinaryOperator clang_BinaryOperator_CreateEmpty(CXASTContext C, bool HasFPFeatures) {
  return reinterpret_cast<CXBinaryOperator>(clang::BinaryOperator::CreateEmpty(*reinterpret_cast<clang::ASTContext *>(C),
                                            HasFPFeatures));
}

// CompoundAssignOperator
CXCompoundAssignOperator clang_CompoundAssignOperator_Create(
    CXASTContext C, CXExpr LHS, CXExpr RHS, CXBinaryOperatorKind Opc, CXQualType ResTy,
    CXExprValueKind VK, CXExprObjectKind OK, CXSourceLocation_ OpLoc, uint64_t FPFeatures,
    CXQualType CompLHSType, CXQualType CompResultType) {
  return reinterpret_cast<CXCompoundAssignOperator>(clang::CompoundAssignOperator::Create(
      *reinterpret_cast<clang::ASTContext *>(C), reinterpret_cast<clang::Expr *>(LHS),
      reinterpret_cast<clang::Expr *>(RHS), static_cast<clang::BinaryOperatorKind>(Opc),
      clang::QualType::getFromOpaquePtr(ResTy), static_cast<clang::ExprValueKind>(VK),
      static_cast<clang::ExprObjectKind>(OK),
      clang::SourceLocation::getFromPtrEncoding(OpLoc),
      clang::FPOptionsOverride::getFromOpaqueInt(FPFeatures),
      clang::QualType::getFromOpaquePtr(CompLHSType),
      clang::QualType::getFromOpaquePtr(CompResultType)));
}

// UnaryOperator
CXUnaryOperator clang_UnaryOperator_Create(CXASTContext C, CXExpr Input,
                                           CXUnaryOperatorKind Opc, CXQualType Type,
                                           CXExprValueKind VK, CXExprObjectKind OK,
                                           CXSourceLocation_ L, bool CanOverflow,
                                           uint64_t FPFeatures) {
  return reinterpret_cast<CXUnaryOperator>(clang::UnaryOperator::Create(
      *reinterpret_cast<clang::ASTContext *>(C), reinterpret_cast<clang::Expr *>(Input),
      static_cast<clang::UnaryOperatorKind>(Opc), clang::QualType::getFromOpaquePtr(Type),
      static_cast<clang::ExprValueKind>(VK), static_cast<clang::ExprObjectKind>(OK),
      clang::SourceLocation::getFromPtrEncoding(L), CanOverflow,
      clang::FPOptionsOverride::getFromOpaqueInt(FPFeatures)));
}

// ImplicitCastExpr
CXImplicitCastExpr clang_ImplicitCastExpr_Create(CXASTContext C, CXQualType T, CXCastKind K,
                                                 CXExpr Op, CXExprValueKind VK,
                                                 uint64_t FPO) {
  return reinterpret_cast<CXImplicitCastExpr>(clang::ImplicitCastExpr::Create(
      *reinterpret_cast<clang::ASTContext *>(C), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::CastKind>(K), reinterpret_cast<clang::Expr *>(Op), nullptr,
      static_cast<clang::ExprValueKind>(VK),
      clang::FPOptionsOverride::getFromOpaqueInt(FPO)));
}

CXImplicitCastExpr clang_ImplicitCastExpr_CreateEmpty(CXASTContext C, unsigned PathSize,
                                                      bool HasFPFeatures) {
  return reinterpret_cast<CXImplicitCastExpr>(clang::ImplicitCastExpr::CreateEmpty(*reinterpret_cast<clang::ASTContext *>(C),
                                              PathSize, HasFPFeatures));
}

// MemberExpr
CXMemberExpr clang_MemberExpr_CreateImplicit(CXASTContext C, CXExpr Base, bool IsArrow,
                                             CXValueDecl MemberDecl, CXQualType T,
                                             CXExprValueKind VK, CXExprObjectKind OK) {
  return reinterpret_cast<CXMemberExpr>(clang::MemberExpr::CreateImplicit(
      *reinterpret_cast<clang::ASTContext *>(C), reinterpret_cast<clang::Expr *>(Base), IsArrow,
      reinterpret_cast<clang::ValueDecl *>(MemberDecl), clang::QualType::getFromOpaquePtr(T),
      static_cast<clang::ExprValueKind>(VK), static_cast<clang::ExprObjectKind>(OK)));
}

// PredefinedExpr
CXPredefinedExpr clang_PredefinedExpr_Create(CXASTContext C, CXSourceLocation_ L,
                                             CXQualType FNTy, CXPredefinedIdentKind IK,
                                             bool IsTransparent, CXStringLiteral SL) {
  return reinterpret_cast<CXPredefinedExpr>(clang::PredefinedExpr::Create(
      *reinterpret_cast<clang::ASTContext *>(C), clang::SourceLocation::getFromPtrEncoding(L),
      clang::QualType::getFromOpaquePtr(FNTy), static_cast<clang::PredefinedIdentKind>(IK),
      IsTransparent, reinterpret_cast<clang::StringLiteral *>(SL)));
}

// ParenListExpr
CXParenListExpr clang_ParenListExpr_Create(CXASTContext C, CXSourceLocation_ LParenLoc,
                                           const CXExpr *Exprs, unsigned NumExprs,
                                           CXSourceLocation_ RParenLoc) {
  llvm::SmallVector<clang::Expr *, 8> Es;
  Es.reserve(NumExprs);
  for (unsigned I = 0; I < NumExprs; ++I)
    Es.push_back(reinterpret_cast<clang::Expr *>(Exprs[I]));
  return reinterpret_cast<CXParenListExpr>(clang::ParenListExpr::Create(*reinterpret_cast<clang::ASTContext *>(C),
                                      clang::SourceLocation::getFromPtrEncoding(LParenLoc),
                                      Es,
                                      clang::SourceLocation::getFromPtrEncoding(RParenLoc)));
}

// ConstantExpr
CXConstantExpr clang_ConstantExpr_Create(CXASTContext C, CXExpr E, CXAPValue Result) {
  return reinterpret_cast<CXConstantExpr>(clang::ConstantExpr::Create(*reinterpret_cast<clang::ASTContext *>(C),
                                     reinterpret_cast<clang::Expr *>(E),
                                     *reinterpret_cast<clang::APValue *>(Result)));
}

CXConstantExpr clang_ConstantExpr_CreateEmpty(CXASTContext C,
                                              CXConstantResultStorageKind StorageKind) {
  return reinterpret_cast<CXConstantExpr>(clang::ConstantExpr::CreateEmpty(
      *reinterpret_cast<clang::ASTContext *>(C),
      static_cast<clang::ConstantResultStorageKind>(StorageKind)));
}

// RecoveryExpr
CXRecoveryExpr clang_RecoveryExpr_Create(CXASTContext C, CXQualType T,
                                         CXSourceLocation_ BeginLoc,
                                         CXSourceLocation_ EndLoc, const CXExpr *SubExprs,
                                         unsigned NumSubExprs) {
  llvm::SmallVector<clang::Expr *, 8> Es;
  Es.reserve(NumSubExprs);
  for (unsigned I = 0; I < NumSubExprs; ++I)
    Es.push_back(reinterpret_cast<clang::Expr *>(SubExprs[I]));
  return reinterpret_cast<CXRecoveryExpr>(clang::RecoveryExpr::Create(*reinterpret_cast<clang::ASTContext *>(C),
                                     clang::QualType::getFromOpaquePtr(T),
                                     clang::SourceLocation::getFromPtrEncoding(BeginLoc),
                                     clang::SourceLocation::getFromPtrEncoding(EndLoc), Es));
}

unsigned clang_RecoveryExpr_getNumSubExpressions(CXRecoveryExpr E) {
  return reinterpret_cast<clang::RecoveryExpr *>(E)->subExpressions().size();
}

CXExpr clang_RecoveryExpr_getSubExpression(CXRecoveryExpr E, unsigned I) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::RecoveryExpr *>(E)->subExpressions()[I]);
}

// Expr
CXAPValue clang_Expr_EvaluateAsFixedPoint(CXExpr E, CXASTContext Ctx) {
  clang::Expr::EvalResult Result;
  if (!reinterpret_cast<clang::Expr *>(E)->EvaluateAsFixedPoint(
          Result, *reinterpret_cast<clang::ASTContext *>(Ctx)))
    return nullptr;
  return reinterpret_cast<CXAPValue>(new clang::APValue(Result.Val)); // NOLINT(*-owning-memory)
}

// ConstantExpr
void clang_ConstantExpr_SetResult(CXConstantExpr E, CXAPValue Value, CXASTContext Ctx) {
  reinterpret_cast<clang::ConstantExpr *>(E)->SetResult(*reinterpret_cast<clang::APValue *>(Value),
                                                   *reinterpret_cast<clang::ASTContext *>(Ctx));
}

// FloatingLiteral
unsigned clang_FloatingLiteral_getRawSemantics(CXFloatingLiteral E) {
  return static_cast<unsigned>(reinterpret_cast<clang::FloatingLiteral *>(E)->getRawSemantics());
}

void clang_FloatingLiteral_setRawSemantics(CXFloatingLiteral E, unsigned Sem) {
  reinterpret_cast<clang::FloatingLiteral *>(E)->setRawSemantics(
      static_cast<llvm::APFloatBase::Semantics>(Sem));
}

void clang_FloatingLiteral_setValue(CXFloatingLiteral E, CXASTContext C,
                                    LLVMGenericValueRef Value) {
  auto *FL = reinterpret_cast<clang::FloatingLiteral *>(E);
  auto *GV = reinterpret_cast<llvm::GenericValue *>(Value);
  FL->setValue(*reinterpret_cast<clang::ASTContext *>(C),
               llvm::APFloat(FL->getSemantics(), GV->IntVal));
}

// ImaginaryLiteral
void clang_ImaginaryLiteral_setSubExpr(CXImaginaryLiteral E, CXExpr S) {
  reinterpret_cast<clang::ImaginaryLiteral *>(E)->setSubExpr(reinterpret_cast<clang::Expr *>(S));
}

// MatrixSubscriptExpr
void clang_MatrixSubscriptExpr_setBase(CXMatrixSubscriptExpr E, CXExpr Base) {
  reinterpret_cast<clang::MatrixSubscriptExpr *>(E)->setBase(reinterpret_cast<clang::Expr *>(Base));
}

void clang_MatrixSubscriptExpr_setRowIdx(CXMatrixSubscriptExpr E, CXExpr RowIdx) {
  reinterpret_cast<clang::MatrixSubscriptExpr *>(E)->setRowIdx(
      reinterpret_cast<clang::Expr *>(RowIdx));
}

void clang_MatrixSubscriptExpr_setColumnIdx(CXMatrixSubscriptExpr E, CXExpr ColumnIdx) {
  reinterpret_cast<clang::MatrixSubscriptExpr *>(E)->setColumnIdx(
      reinterpret_cast<clang::Expr *>(ColumnIdx));
}

void clang_MatrixSubscriptExpr_setRBracketLoc(CXMatrixSubscriptExpr E,
                                              CXSourceLocation_ L) {
  reinterpret_cast<clang::MatrixSubscriptExpr *>(E)->setRBracketLoc(
      clang::SourceLocation::getFromPtrEncoding(L));
}

// CallExpr
unsigned clang_CallExpr_getNumRawSubExprs(CXCallExpr E) {
  return reinterpret_cast<clang::CallExpr *>(E)->getRawSubExprs().size();
}

CXStmt clang_CallExpr_getRawSubExpr(CXCallExpr E, unsigned I) {
  return reinterpret_cast<CXStmt>(reinterpret_cast<clang::CallExpr *>(E)->getRawSubExprs()[I]);
}

void clang_CallExpr_setStoredFPFeatures(CXCallExpr E, uint64_t F) {
  reinterpret_cast<clang::CallExpr *>(E)->setStoredFPFeatures(
      clang::FPOptionsOverride::getFromOpaqueInt(F));
}

// BinaryOperator
void clang_BinaryOperator_setStoredFPFeatures(CXBinaryOperator BO, uint64_t F) {
  reinterpret_cast<clang::BinaryOperator *>(BO)->setStoredFPFeatures(
      clang::FPOptionsOverride::getFromOpaqueInt(F));
}

// ShuffleVectorExpr
void clang_ShuffleVectorExpr_setExprs(CXShuffleVectorExpr E, CXASTContext C,
                                      const CXExpr *Exprs, unsigned NumExprs) {
  llvm::SmallVector<clang::Expr *, 8> Es;
  Es.reserve(NumExprs);
  for (unsigned I = 0; I < NumExprs; ++I)
    Es.push_back(reinterpret_cast<clang::Expr *>(Exprs[I]));
  reinterpret_cast<clang::ShuffleVectorExpr *>(E)->setExprs(*reinterpret_cast<clang::ASTContext *>(C),
                                                       Es);
}

// DesignatedInitExpr::Designator
void clang_Designator_setFieldDecl(CXDesignator D, CXFieldDecl FD) {
  reinterpret_cast<clang::DesignatedInitExpr::Designator *>(D)->setFieldDecl(
      reinterpret_cast<clang::FieldDecl *>(FD));
}

// BlockExpr
void clang_BlockExpr_setBlockDecl(CXBlockExpr E, CXBlockDecl BD) {
  reinterpret_cast<clang::BlockExpr *>(E)->setBlockDecl(reinterpret_cast<clang::BlockDecl *>(BD));
}

// Expr
unsigned clang_Expr_getDependence(CXExpr E) {
  return static_cast<unsigned>(reinterpret_cast<clang::Expr *>(E)->getDependence());
}

bool clang_Expr_isFlexibleArrayMemberLike(CXExpr E, CXASTContext Ctx,
                                          CXStrictFlexArraysLevelKind StrictFlexArraysLevel,
                                          bool IgnoreTemplateOrMacroSubstitution) {
  return reinterpret_cast<clang::Expr *>(E)->isFlexibleArrayMemberLike(
      *reinterpret_cast<clang::ASTContext *>(Ctx),
      static_cast<clang::LangOptions::StrictFlexArraysLevelKind>(StrictFlexArraysLevel),
      IgnoreTemplateOrMacroSubstitution);
}

// StringLiteral
CXStringLiteral clang_StringLiteral_Create(CXASTContext Ctx, const char *Str, size_t StrLen,
                                           CXStringLiteralKind Kind, bool Pascal,
                                           CXQualType Ty, const CXSourceLocation_ *Locs,
                                           unsigned NumConcatenated) {
  llvm::SmallVector<clang::SourceLocation, 4> Ls;
  Ls.reserve(NumConcatenated);
  for (unsigned I = 0; I < NumConcatenated; ++I)
    Ls.push_back(clang::SourceLocation::getFromPtrEncoding(Locs[I]));
  return reinterpret_cast<CXStringLiteral>(clang::StringLiteral::Create(
      *reinterpret_cast<clang::ASTContext *>(Ctx), llvm::StringRef(Str, StrLen),
      static_cast<clang::StringLiteralKind>(Kind), Pascal,
      clang::QualType::getFromOpaquePtr(Ty), Ls.data(), NumConcatenated));
}

CXStringLiteral clang_StringLiteral_CreateEmpty(CXASTContext Ctx, unsigned NumConcatenated,
                                                unsigned Length, unsigned CharByteWidth) {
  return reinterpret_cast<CXStringLiteral>(clang::StringLiteral::CreateEmpty(*reinterpret_cast<clang::ASTContext *>(Ctx),
                                           NumConcatenated, Length, CharByteWidth));
}

// PredefinedExpr
CXPredefinedExpr clang_PredefinedExpr_CreateEmpty(CXASTContext Ctx, bool HasFunctionName) {
  return reinterpret_cast<CXPredefinedExpr>(clang::PredefinedExpr::CreateEmpty(*reinterpret_cast<clang::ASTContext *>(Ctx),
                                            HasFunctionName));
}

// UnaryOperator
CXUnaryOperator clang_UnaryOperator_CreateEmpty(CXASTContext C, bool HasFPFeatures) {
  return reinterpret_cast<CXUnaryOperator>(clang::UnaryOperator::CreateEmpty(*reinterpret_cast<clang::ASTContext *>(C),
                                           HasFPFeatures));
}

// OffsetOfExpr
CXOffsetOfExpr clang_OffsetOfExpr_CreateEmpty(CXASTContext C, unsigned NumComps,
                                              unsigned NumExprs) {
  return reinterpret_cast<CXOffsetOfExpr>(clang::OffsetOfExpr::CreateEmpty(*reinterpret_cast<clang::ASTContext *>(C), NumComps,
                                          NumExprs));
}

// CallExpr
CXCallExpr clang_CallExpr_CreateEmpty(CXASTContext Ctx, unsigned NumArgs,
                                      bool HasFPFeatures) {
  return reinterpret_cast<CXCallExpr>(clang::CallExpr::CreateEmpty(*reinterpret_cast<clang::ASTContext *>(Ctx), NumArgs,
                                      HasFPFeatures, clang::Stmt::EmptyShell()));
}

// MemberExpr
CXMemberExpr clang_MemberExpr_CreateEmpty(CXASTContext Context, bool HasQualifier,
                                          bool HasFoundDecl, bool HasTemplateKWAndArgsInfo,
                                          unsigned NumTemplateArgs) {
  return reinterpret_cast<CXMemberExpr>(clang::MemberExpr::CreateEmpty(*reinterpret_cast<clang::ASTContext *>(Context),
                                        HasQualifier, HasFoundDecl,
                                        HasTemplateKWAndArgsInfo, NumTemplateArgs));
}

// CompoundAssignOperator
CXCompoundAssignOperator clang_CompoundAssignOperator_CreateEmpty(CXASTContext C,
                                                                  bool HasFPFeatures) {
  return reinterpret_cast<CXCompoundAssignOperator>(clang::CompoundAssignOperator::CreateEmpty(*reinterpret_cast<clang::ASTContext *>(C),
                                                    HasFPFeatures));
}

// DesignatedInitExpr::Designator
CXDesignator clang_Designator_CreateFieldDesignator(CXIdentifierInfo FieldName,
                                                    CXSourceLocation_ DotLoc,
                                                    CXSourceLocation_ FieldLoc) {
  return reinterpret_cast<CXDesignator>(std::make_unique<clang::DesignatedInitExpr::Designator>(
             clang::DesignatedInitExpr::Designator::CreateFieldDesignator(
                 reinterpret_cast<const clang::IdentifierInfo *>(FieldName),
                 clang::SourceLocation::getFromPtrEncoding(DotLoc),
                 clang::SourceLocation::getFromPtrEncoding(FieldLoc)))
      .release());
}

CXDesignator clang_Designator_CreateArrayDesignator(unsigned Index,
                                                    CXSourceLocation_ LBracketLoc,
                                                    CXSourceLocation_ RBracketLoc) {
  return reinterpret_cast<CXDesignator>(std::make_unique<clang::DesignatedInitExpr::Designator>(
             clang::DesignatedInitExpr::Designator::CreateArrayDesignator(
                 Index, clang::SourceLocation::getFromPtrEncoding(LBracketLoc),
                 clang::SourceLocation::getFromPtrEncoding(RBracketLoc)))
      .release());
}

CXDesignator clang_Designator_CreateArrayRangeDesignator(unsigned Index,
                                                         CXSourceLocation_ LBracketLoc,
                                                         CXSourceLocation_ EllipsisLoc,
                                                         CXSourceLocation_ RBracketLoc) {
  return reinterpret_cast<CXDesignator>(std::make_unique<clang::DesignatedInitExpr::Designator>(
             clang::DesignatedInitExpr::Designator::CreateArrayRangeDesignator(
                 Index, clang::SourceLocation::getFromPtrEncoding(LBracketLoc),
                 clang::SourceLocation::getFromPtrEncoding(EllipsisLoc),
                 clang::SourceLocation::getFromPtrEncoding(RBracketLoc)))
      .release());
}

void clang_Designator_dispose(CXDesignator D) {
  delete reinterpret_cast<clang::DesignatedInitExpr::Designator *>(D);
}

// DesignatedInitExpr
CXDesignatedInitExpr clang_DesignatedInitExpr_CreateEmpty(CXASTContext C,
                                                          unsigned NumIndexExprs) {
  return reinterpret_cast<CXDesignatedInitExpr>(clang::DesignatedInitExpr::CreateEmpty(*reinterpret_cast<clang::ASTContext *>(C),
                                                NumIndexExprs));
}

void clang_DesignatedInitExpr_setDesignators(CXDesignatedInitExpr E, CXASTContext C,
                                             const CXDesignator *Desigs,
                                             unsigned NumDesigs) {
  llvm::SmallVector<clang::DesignatedInitExpr::Designator, 4> Ds;
  Ds.reserve(NumDesigs);
  for (unsigned I = 0; I < NumDesigs; ++I)
    Ds.push_back(*reinterpret_cast<clang::DesignatedInitExpr::Designator *>(Desigs[I]));
  reinterpret_cast<clang::DesignatedInitExpr *>(E)->setDesignators(
      *reinterpret_cast<clang::ASTContext *>(C), Ds.data(), NumDesigs);
}

// ParenListExpr
CXParenListExpr clang_ParenListExpr_CreateEmpty(CXASTContext Ctx, unsigned NumExprs) {
  return reinterpret_cast<CXParenListExpr>(clang::ParenListExpr::CreateEmpty(*reinterpret_cast<clang::ASTContext *>(Ctx),
                                           NumExprs));
}

// GenericSelectionExpr
CXGenericSelectionExpr clang_GenericSelectionExpr_CreateEmpty(CXASTContext Context,
                                                              unsigned NumAssocs) {
  return reinterpret_cast<CXGenericSelectionExpr>(clang::GenericSelectionExpr::CreateEmpty(
      *reinterpret_cast<clang::ASTContext *>(Context), NumAssocs));
}

// RecoveryExpr
CXRecoveryExpr clang_RecoveryExpr_CreateEmpty(CXASTContext Ctx, unsigned NumSubExprs) {
  return reinterpret_cast<CXRecoveryExpr>(clang::RecoveryExpr::CreateEmpty(*reinterpret_cast<clang::ASTContext *>(Ctx),
                                          NumSubExprs));
}

// CallExpr
CXCallExpr clang_CallExpr_Create(CXASTContext Ctx, CXExpr Fn, const CXExpr *Args,
                                 unsigned NumArgs, CXQualType Ty, CXExprValueKind VK,
                                 CXSourceLocation_ RParenLoc, uint64_t FPFeatures,
                                 unsigned MinNumArgs, bool UsesADL) {
  llvm::SmallVector<clang::Expr *, 8> As;
  As.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    As.push_back(reinterpret_cast<clang::Expr *>(Args[I]));
  return reinterpret_cast<CXCallExpr>(clang::CallExpr::Create(
      *reinterpret_cast<clang::ASTContext *>(Ctx), reinterpret_cast<clang::Expr *>(Fn), As,
      clang::QualType::getFromOpaquePtr(Ty), static_cast<clang::ExprValueKind>(VK),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc),
      clang::FPOptionsOverride::getFromOpaqueInt(FPFeatures), MinNumArgs,
      UsesADL ? clang::CallExpr::UsesADL : clang::CallExpr::NotADL));
}

// DeclRefExpr
void clang_DeclRefExpr_setCapturedByCopyInLambdaWithExplicitObjectParameter(
    CXDeclRefExpr E, bool Set, CXASTContext Ctx) {
  reinterpret_cast<clang::DeclRefExpr *>(E)
      ->setCapturedByCopyInLambdaWithExplicitObjectParameter(
          Set, *reinterpret_cast<clang::ASTContext *>(Ctx));
}

// FixedPointLiteral
CXFixedPointLiteral clang_FixedPointLiteral_Create(CXASTContext C) {
  return reinterpret_cast<CXFixedPointLiteral>(clang::FixedPointLiteral::Create(*reinterpret_cast<clang::ASTContext *>(C),
                                          clang::Stmt::EmptyShell()));
}

CXSourceLocation_ clang_FixedPointLiteral_getLocation(CXFixedPointLiteral E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::FixedPointLiteral *>(E)->getLocation().getPtrEncoding());
}

void clang_FixedPointLiteral_setLocation(CXFixedPointLiteral E, CXSourceLocation_ L) {
  reinterpret_cast<clang::FixedPointLiteral *>(E)->setLocation(
      clang::SourceLocation::getFromPtrEncoding(L));
}

unsigned clang_FixedPointLiteral_getScale(CXFixedPointLiteral E) {
  return reinterpret_cast<clang::FixedPointLiteral *>(E)->getScale();
}

void clang_FixedPointLiteral_setScale(CXFixedPointLiteral E, unsigned S) {
  reinterpret_cast<clang::FixedPointLiteral *>(E)->setScale(S);
}

// SYCLUniqueStableNameExpr
CXTypeSourceInfo
clang_SYCLUniqueStableNameExpr_getTypeSourceInfo(CXSYCLUniqueStableNameExpr E) {
  return reinterpret_cast<CXTypeSourceInfo>(reinterpret_cast<clang::SYCLUniqueStableNameExpr *>(E)->getTypeSourceInfo());
}

CXSYCLUniqueStableNameExpr clang_SYCLUniqueStableNameExpr_Create(CXASTContext Ctx,
                                                                 CXSourceLocation_ OpLoc,
                                                                 CXSourceLocation_ LParen,
                                                                 CXSourceLocation_ RParen,
                                                                 CXTypeSourceInfo TSI) {
  return reinterpret_cast<CXSYCLUniqueStableNameExpr>(clang::SYCLUniqueStableNameExpr::Create(
      *reinterpret_cast<clang::ASTContext *>(Ctx),
      clang::SourceLocation::getFromPtrEncoding(OpLoc),
      clang::SourceLocation::getFromPtrEncoding(LParen),
      clang::SourceLocation::getFromPtrEncoding(RParen),
      reinterpret_cast<clang::TypeSourceInfo *>(TSI)));
}

CXSourceLocation_ clang_SYCLUniqueStableNameExpr_getLocation(CXSYCLUniqueStableNameExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SYCLUniqueStableNameExpr *>(E)->getLocation().getPtrEncoding());
}

CXSourceLocation_
clang_SYCLUniqueStableNameExpr_getLParenLocation(CXSYCLUniqueStableNameExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SYCLUniqueStableNameExpr *>(E)
      ->getLParenLocation()
      .getPtrEncoding());
}

CXSourceLocation_
clang_SYCLUniqueStableNameExpr_getRParenLocation(CXSYCLUniqueStableNameExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::SYCLUniqueStableNameExpr *>(E)
      ->getRParenLocation()
      .getPtrEncoding());
}

CXString clang_SYCLUniqueStableNameExpr_ComputeName(CXSYCLUniqueStableNameExpr E,
                                                    CXASTContext Ctx) {
  return extra::makeCXString(reinterpret_cast<clang::SYCLUniqueStableNameExpr *>(E)->ComputeName(
      *reinterpret_cast<clang::ASTContext *>(Ctx)));
}

// DeclRefExpr
CXSourceRange_ clang_DeclRefExpr_getQualifierRange(CXDeclRefExpr E) {
  auto Q = reinterpret_cast<clang::DeclRefExpr *>(E)->getQualifierLoc();
  clang::SourceRange R = Q.getSourceRange();
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

void clang_DeclRefExpr_copyTemplateArgumentsInto(CXDeclRefExpr E,
                                                 CXTemplateArgumentListInfo List) {
  reinterpret_cast<clang::DeclRefExpr *>(E)->copyTemplateArgumentsInto(
      *reinterpret_cast<clang::TemplateArgumentListInfo *>(List));
}

// FixedPointLiteral
CXFixedPointLiteral clang_FixedPointLiteral_CreateFromRawInt(CXASTContext C, uint64_t Value,
                                                             unsigned BitWidth,
                                                             CXQualType Ty,
                                                             CXSourceLocation_ L,
                                                             unsigned Scale) {
  return reinterpret_cast<CXFixedPointLiteral>(clang::FixedPointLiteral::CreateFromRawInt(
      *reinterpret_cast<clang::ASTContext *>(C), llvm::APInt(BitWidth, Value),
      clang::QualType::getFromOpaquePtr(Ty), clang::SourceLocation::getFromPtrEncoding(L),
      Scale));
}

CXString clang_FixedPointLiteral_getValueAsString(CXFixedPointLiteral E, unsigned Radix) {
  return extra::makeCXString(
      reinterpret_cast<clang::FixedPointLiteral *>(E)->getValueAsString(Radix));
}

// OffsetOfExpr
void clang_OffsetOfExpr_setComponent(CXOffsetOfExpr E, unsigned Idx, CXOffsetOfNode N) {
  reinterpret_cast<clang::OffsetOfExpr *>(E)->setComponent(
      Idx, *reinterpret_cast<clang::OffsetOfNode *>(N));
}

// MemberExpr
CXSourceRange_ clang_MemberExpr_getQualifierRange(CXMemberExpr E) {
  auto Q = reinterpret_cast<clang::MemberExpr *>(E)->getQualifierLoc();
  clang::SourceRange R = Q.getSourceRange();
  return CXSourceRange_{reinterpret_cast<CXSourceLocation_>(R.getBegin().getPtrEncoding()), reinterpret_cast<CXSourceLocation_>(R.getEnd().getPtrEncoding())};
}

void clang_MemberExpr_copyTemplateArgumentsInto(CXMemberExpr E,
                                                CXTemplateArgumentListInfo List) {
  reinterpret_cast<clang::MemberExpr *>(E)->copyTemplateArgumentsInto(
      *reinterpret_cast<clang::TemplateArgumentListInfo *>(List));
}

// BinaryOperator
void clang_BinaryOperator_setHasStoredFPFeatures(CXBinaryOperator BO, bool B) {
  reinterpret_cast<clang::BinaryOperator *>(BO)->setHasStoredFPFeatures(B);
}

// DesignatedInitExpr
void clang_DesignatedInitExpr_ExpandDesignator(CXDesignatedInitExpr E, CXASTContext Ctx,
                                               unsigned Idx, const CXDesignator *Ds,
                                               unsigned N) {
  llvm::SmallVector<clang::DesignatedInitExpr::Designator, 4> Buf;
  Buf.reserve(N);
  for (unsigned I = 0; I != N; ++I)
    Buf.push_back(*reinterpret_cast<clang::DesignatedInitExpr::Designator *>(Ds[I]));
  reinterpret_cast<clang::DesignatedInitExpr *>(E)->ExpandDesignator(
      *reinterpret_cast<clang::ASTContext *>(Ctx), Idx, Buf.data(), Buf.data() + Buf.size());
}

// GenericSelectionExpr
CXQualType clang_GenericSelectionExpr_getAssocType(CXGenericSelectionExpr E, unsigned I) {
  return reinterpret_cast<CXQualType>(reinterpret_cast<clang::GenericSelectionExpr *>(E)
      ->getAssociation(I)
      .getType()
      .getAsOpaquePtr());
}

bool clang_GenericSelectionExpr_isAssocSelected(CXGenericSelectionExpr E, unsigned I) {
  return reinterpret_cast<clang::GenericSelectionExpr *>(E)->getAssociation(I).isSelected();
}

// AsTypeExpr
CXAsTypeExpr clang_AsTypeExpr_Create(CXASTContext Ctx, CXExpr SrcExpr, CXQualType DstType,
                                     CXExprValueKind VK, CXExprObjectKind OK,
                                     CXSourceLocation_ BuiltinLoc,
                                     CXSourceLocation_ RParenLoc) {
  clang::ASTContext &C = *reinterpret_cast<clang::ASTContext *>(Ctx);
  return reinterpret_cast<CXAsTypeExpr>(new (C) clang::AsTypeExpr(
      reinterpret_cast<clang::Expr *>(SrcExpr), clang::QualType::getFromOpaquePtr(DstType),
      static_cast<clang::ExprValueKind>(VK), static_cast<clang::ExprObjectKind>(OK),
      clang::SourceLocation::getFromPtrEncoding(BuiltinLoc),
      clang::SourceLocation::getFromPtrEncoding(RParenLoc)));
}

CXExpr clang_AsTypeExpr_getSrcExpr(CXAsTypeExpr E) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::AsTypeExpr *>(E)->getSrcExpr());
}

CXSourceLocation_ clang_AsTypeExpr_getBuiltinLoc(CXAsTypeExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::AsTypeExpr *>(E)->getBuiltinLoc().getPtrEncoding());
}

CXSourceLocation_ clang_AsTypeExpr_getRParenLoc(CXAsTypeExpr E) {
  return reinterpret_cast<CXSourceLocation_>(reinterpret_cast<clang::AsTypeExpr *>(E)->getRParenLoc().getPtrEncoding());
}

// Expr::EvalStatus / Expr::EvalResult
CXEvalResult_ clang_EvalResult_create(void) { return reinterpret_cast<CXEvalResult_>(new clang::Expr::EvalResult()); }

void clang_EvalResult_dispose(CXEvalResult_ R) {
  delete reinterpret_cast<clang::Expr::EvalResult *>(R);
}

CXAPValue clang_EvalResult_getVal(CXEvalResult_ R) {
  return reinterpret_cast<CXAPValue>(&reinterpret_cast<clang::Expr::EvalResult *>(R)->Val);
}

bool clang_EvalStatus_hasSideEffects(CXEvalResult_ R) {
  return reinterpret_cast<clang::Expr::EvalResult *>(R)->hasSideEffects();
}

bool clang_EvalStatus_hasUndefinedBehavior(CXEvalResult_ R) {
  return reinterpret_cast<clang::Expr::EvalResult *>(R)->HasUndefinedBehavior;
}

bool clang_EvalResult_isGlobalLValue(CXEvalResult_ R) {
  return reinterpret_cast<clang::Expr::EvalResult *>(R)->isGlobalLValue();
}

// Expr
bool clang_Expr_EvaluateAsRValueIntoResult(CXExpr E, CXASTContext Ctx,
                                           bool InConstantContext, CXEvalResult_ Result) {
  return reinterpret_cast<clang::Expr *>(E)->EvaluateAsRValue(
      *reinterpret_cast<clang::Expr::EvalResult *>(Result),
      *reinterpret_cast<clang::ASTContext *>(Ctx), InConstantContext);
}

bool clang_Expr_EvaluateAsLValueIntoResult(CXExpr E, CXASTContext Ctx,
                                           bool InConstantContext, CXEvalResult_ Result) {
  return reinterpret_cast<clang::Expr *>(E)->EvaluateAsLValue(
      *reinterpret_cast<clang::Expr::EvalResult *>(Result),
      *reinterpret_cast<clang::ASTContext *>(Ctx), InConstantContext);
}

CXString clang_Expr_EvaluateCharRangeAsString(CXExpr E, CXExpr SizeExpression,
                                              CXExpr PtrExpression, CXASTContext Ctx,
                                              CXEvalResult_ Status, bool *Succeeded) {
  std::string Text;
  *Succeeded = reinterpret_cast<clang::Expr *>(E)->EvaluateCharRangeAsString(
      Text, reinterpret_cast<clang::Expr *>(SizeExpression),
      reinterpret_cast<clang::Expr *>(PtrExpression), *reinterpret_cast<clang::ASTContext *>(Ctx),
      *reinterpret_cast<clang::Expr::EvalResult *>(Status));
  return extra::makeCXString(Text);
}

// DeclRefExpr
CXDeclRefExpr clang_DeclRefExpr_CreateEmpty(CXASTContext C, bool HasQualifier,
                                            bool HasFoundDecl,
                                            bool HasTemplateKWAndArgsInfo,
                                            unsigned NumTemplateArgs) {
  return reinterpret_cast<CXDeclRefExpr>(clang::DeclRefExpr::CreateEmpty(*reinterpret_cast<clang::ASTContext *>(C), HasQualifier,
                                         HasFoundDecl, HasTemplateKWAndArgsInfo,
                                         NumTemplateArgs));
}

// FloatingLiteral
CXFloatingLiteral clang_FloatingLiteral_CreateEmpty(CXASTContext C) {
  return reinterpret_cast<CXFloatingLiteral>(clang::FloatingLiteral::Create(*reinterpret_cast<clang::ASTContext *>(C),
                                        clang::Stmt::EmptyShell()));
}

// SYCLUniqueStableNameExpr
CXSYCLUniqueStableNameExpr clang_SYCLUniqueStableNameExpr_CreateEmpty(CXASTContext Ctx) {
  return reinterpret_cast<CXSYCLUniqueStableNameExpr>(clang::SYCLUniqueStableNameExpr::CreateEmpty(
      *reinterpret_cast<clang::ASTContext *>(Ctx)));
}

// CallExpr
void clang_CallExpr_setNumArgsUnsafe(CXCallExpr E, unsigned NewNumArgs) {
  reinterpret_cast<clang::CallExpr *>(E)->setNumArgsUnsafe(NewNumArgs);
}

// BlockVarCopyInit
CXBlockVarCopyInit clang_BlockVarCopyInit_create(CXExpr CopyExpr, bool CanThrow) {
  return reinterpret_cast<CXBlockVarCopyInit>(new clang::BlockVarCopyInit(reinterpret_cast<clang::Expr *>(CopyExpr), CanThrow));
}

void clang_BlockVarCopyInit_dispose(CXBlockVarCopyInit BVCI) {
  delete reinterpret_cast<clang::BlockVarCopyInit *>(BVCI);
}

CXExpr clang_BlockVarCopyInit_getCopyExpr(CXBlockVarCopyInit BVCI) {
  return reinterpret_cast<CXExpr>(reinterpret_cast<clang::BlockVarCopyInit *>(BVCI)->getCopyExpr());
}

bool clang_BlockVarCopyInit_canThrow(CXBlockVarCopyInit BVCI) {
  return reinterpret_cast<clang::BlockVarCopyInit *>(BVCI)->canThrow();
}

void clang_BlockVarCopyInit_setExprAndFlag(CXBlockVarCopyInit BVCI, CXExpr CopyExpr,
                                           bool CanThrow) {
  reinterpret_cast<clang::BlockVarCopyInit *>(BVCI)->setExprAndFlag(
      reinterpret_cast<clang::Expr *>(CopyExpr), CanThrow);
}

// PseudoObjectExpr
CXPseudoObjectExpr clang_PseudoObjectExpr_CreateEmpty(CXASTContext Context,
                                                      unsigned NumSemanticExprs) {
  return reinterpret_cast<CXPseudoObjectExpr>(clang::PseudoObjectExpr::Create(*reinterpret_cast<clang::ASTContext *>(Context),
                                         clang::Stmt::EmptyShell(), NumSemanticExprs));
}

void clang_UnaryExprOrTypeTraitExpr_setArgumentTypeInfo(CXUnaryExprOrTypeTraitExpr E,
                                                        CXTypeSourceInfo TInfo) {
  reinterpret_cast<clang::UnaryExprOrTypeTraitExpr *>(E)->setArgument(
      reinterpret_cast<clang::TypeSourceInfo *>(TInfo));
}
