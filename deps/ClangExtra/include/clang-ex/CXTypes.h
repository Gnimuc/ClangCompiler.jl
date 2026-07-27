#ifndef LLVM_CLANG_C_EXTRA_CXTYPES_H
#define LLVM_CLANG_C_EXTRA_CXTYPES_H

#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include <stdbool.h>
#include <stdint.h>
#include <time.h>

LLVM_CLANG_C_EXTERN_C_BEGIN

// ADT
typedef struct {
  const void *Data;
  size_t Length;
} CXArrayRef;

// APINotes
// APINotesOptions
typedef void *CXAPINotesOptions;

// AST
// ASTConsumer
typedef void *CXASTConsumer;

// ASTContext
typedef void *CXDeclInfo;
typedef void *CXVerbatimLineComment;
typedef void *CXVerbatimBlockComment;
typedef void *CXVerbatimBlockLineComment;
typedef void *CXTParamCommandComment;
typedef void *CXHTMLEndTagComment;
typedef void *CXHTMLStartTagComment;
typedef void *CXHTMLTagComment;
typedef void *CXInlineCommandComment;
typedef void *CXParagraphComment;
typedef void *CXInlineContentComment;
typedef void *CXFullComment;
typedef void *CXParamCommandComment;
typedef void *CXBlockCommandComment;
typedef void *CXTextComment;
typedef void *CXComment;
typedef void *CXRawComment;
typedef void *CXASTContext;

// Decl
typedef void *CXHLSLBufferDecl;
typedef void *CXTranslationUnitDecl;
typedef void *CXPragmaCommentDecl;
typedef void *CXPragmaDetectMismatchDecl;
typedef void *CXExternCContextDecl;
typedef void *CXNamedDecl;
typedef void *CXLabelDecl;
typedef void *CXNamespaceDecl;
typedef void *CXValueDecl;
typedef void *CXDeclaratorDecl;
typedef void *CXEvaluatedStmt;
typedef void *CXVarDecl;
typedef void *CXImplicitParamDecl;
typedef void *CXParmVarDecl;
typedef void *CXFunctionDecl;
typedef void *CXFieldDecl;
typedef void *CXEnumConstantDecl;
typedef void *CXIndirectFieldDecl;
typedef void *CXTypeDecl;
typedef void *CXTypedefNameDecl;
typedef void *CXTypedefDecl;
typedef void *CXTypeAliasDecl;
typedef void *CXTagDecl;
typedef void *CXEnumDecl;
typedef void *CXRecordDecl;
typedef void *CXFileScopeAsmDecl;
typedef void *CXBlockDecl;
typedef void *CXCapturedDecl;
typedef void *CXImportDecl;
typedef void *CXExportDecl;
typedef void *CXEmptyDecl;
typedef void *CXTopLevelStmtDecl;

// DeclarationName
typedef void *CXDeclarationNameTable;
typedef void *CXDeclarationName;
typedef void *CXDeclarationNameInfo;

// DeclBase
typedef void *CXDecl;
typedef void *CXDeclContext;

// DeclCXX
typedef void *CXUnnamedGlobalConstantDecl;
typedef void *CXUnresolvedUsingIfExistsDecl;
typedef void *CXUsingEnumDecl;
typedef void *CXAccessSpecDecl;
typedef void *CXCXXBaseSpecifier;
typedef void *CXCXXRecordDecl;
typedef void *CXExplicitSpecifier;
typedef void *CXCXXDeductionGuideDecl;
typedef void *CXRequiresExprBodyDecl;
typedef void *CXCXXMethodDecl;
typedef void *CXCXXCtorInitializer;
typedef void *CXCXXConstructorDecl;
typedef void *CXCXXDestructorDecl;
typedef void *CXCXXConversionDecl;
typedef void *CXLinkageSpecDecl;
typedef void *CXUsingDirectiveDecl;
typedef void *CXNamespaceAliasDecl;
typedef void *CXLifetimeExtendedTemporaryDecl;
typedef void *CXUsingShadowDecl;
typedef void *CXConstructorUsingShadowDecl;
typedef void *CXBaseUsingDecl;
typedef void *CXUsingDecl;
typedef void *CXUsingPackDecl;
typedef void *CXUnresolvedUsingValueDecl;
typedef void *CXUnresolvedUsingTypenameDecl;
typedef void *CXStaticAssertDecl;
typedef void *CXBindingDecl;
typedef void *CXDecompositionDecl;
typedef void *CXMSPropertyDecl;
typedef void *CXMSGuidDecl;

// DeclGroup
typedef void *CXDeclGroupRef;

// DeclTemplate
typedef void *CXImplicitConceptSpecializationDecl;
typedef void *CXTemplateParameterList;
typedef void *CXTemplateArgumentList;
typedef void *CXTemplateDecl;
typedef void *CXFunctionTemplateSpecializationInfo;
typedef void *CXMemberSpecializationInfo;
typedef void *CXDependentFunctionTemplateSpecializationInfo;
typedef void *CXRedeclarableTemplateDecl;
typedef void *CXFunctionTemplateDecl;
typedef void *CXTemplateTypeParmDecl;
typedef void *CXNonTypeTemplateParmDecl;
typedef void *CXTemplateTemplateParmDecl;
typedef void *CXBuiltinTemplateDecl;
typedef void *CXClassTemplateSpecializationDecl;
typedef void *CXClassTemplatePartialSpecializationDecl;
typedef void *CXClassTemplateDecl;
typedef void *CXFriendTemplateDecl;
typedef void *CXTypeAliasTemplateDecl;
typedef void *CXClassScopeFunctionSpecializationDecl;
typedef void *CXVarTemplateSpecializationDecl;
typedef void *CXVarTemplatePartialSpecializationDecl;
typedef void *CXVarTemplateDecl;
typedef void *CXConceptDecl;
typedef void *CXTemplateParamObjectDecl;

// APValue
typedef void *CXAPValue;

// Attr
typedef void *CXAttr;
typedef void *CXAlignedAttr;
typedef void *CXAnnotateAttr;
typedef void *CXAsmLabelAttr;
typedef void *CXCleanupAttr;
typedef void *CXConstructorAttr;
typedef void *CXDeprecatedAttr;
typedef void *CXDestructorAttr;
typedef void *CXFormatAttr;
typedef void *CXNonNullAttr;
typedef void *CXSectionAttr;
typedef void *CXTLSModelAttr;
typedef void *CXUnavailableAttr;
typedef void *CXVisibilityAttr;
typedef void *CXWarnUnusedResultAttr;

// Expr
typedef void *CXEvalResult;
typedef void *CXSYCLUniqueStableNameExpr;
typedef void *CXClassification;
typedef void *CXExpr;
typedef void *CXFullExpr;
typedef void *CXConstantExpr;
typedef void *CXOpaqueValueExpr;
typedef void *CXDeclRefExpr;
typedef void *CXIntegerLiteral;
typedef void *CXFixedPointLiteral;
typedef void *CXCharacterLiteral;
typedef void *CXFloatingLiteral;
typedef void *CXImaginaryLiteral;
typedef void *CXStringLiteral;
typedef void *CXPredefinedExpr;
typedef void *CXParenExpr;
typedef void *CXUnaryOperator;
typedef void *CXOffsetOfNode;
typedef void *CXOffsetOfExpr;
typedef void *CXUnaryExprOrTypeTraitExpr;
typedef void *CXArraySubscriptExpr;
typedef void *CXMatrixSubscriptExpr;
typedef void *CXCallExpr;
typedef void *CXMemberExpr;
typedef void *CXCompoundLiteralExpr;
typedef void *CXCastExpr;
typedef void *CXImplicitCastExpr;
typedef void *CXExplicitCastExpr;
typedef void *CXCStyleCastExpr;
typedef void *CXBinaryOperator;
typedef void *CXCompoundAssignOperator;
typedef void *CXAbstractConditionalOperator;
typedef void *CXConditionalOperator;
typedef void *CXBinaryConditionalOperator;
typedef void *CXAddrLabelExpr;
typedef void *CXStmtExpr;
typedef void *CXShuffleVectorExpr;
typedef void *CXConvertVectorExpr;
typedef void *CXChooseExpr;
typedef void *CXGNUNullExpr;
typedef void *CXVAArgExpr;
typedef void *CXSourceLocExpr;
typedef void *CXInitListExpr;
typedef void *CXDesignatedInitExpr;
typedef void *CXDesignator;
typedef void *CXNoInitExpr;
typedef void *CXDesignatedInitUpdateExpr;
typedef void *CXArrayInitLoopExpr;
typedef void *CXArrayInitIndexExpr;
typedef void *CXImplicitValueInitExpr;
typedef void *CXParenListExpr;
typedef void *CXGenericSelectionExpr;
typedef void *CXExtVectorElementExpr;
typedef void *CXBlockExpr;
typedef void *CXBlockVarCopyInit;
typedef void *CXAsTypeExpr;
typedef void *CXPseudoObjectExpr;
typedef void *CXAtomicExpr;
typedef void *CXTypoExpr;
typedef void *CXRecoveryExpr;

// ExprCXX
typedef void *CXCXXParenListInitExpr;
typedef void *CXCXXTemporary;
typedef void *CXCXXOperatorCallExpr;
typedef void *CXCXXMemberCallExpr;
typedef void *CXCUDAKernelCallExpr;
typedef void *CXCXXRewrittenBinaryOperator;
typedef void *CXCXXNamedCastExpr;
typedef void *CXCXXStaticCastExpr;
typedef void *CXCXXDynamicCastExpr;
typedef void *CXCXXReinterpretCastExpr;
typedef void *CXCXXConstCastExpr;
typedef void *CXCXXAddrspaceCastExpr;
typedef void *CXUserDefinedLiteral;
typedef void *CXCXXBoolLiteralExpr;
typedef void *CXCXXNullPtrLiteralExpr;
typedef void *CXCXXStdInitializerListExpr;
typedef void *CXCXXTypeidExpr;
typedef void *CXMSPropertyRefExpr;
typedef void *CXMSPropertySubscriptExpr;
typedef void *CXCXXUuidofExpr;
typedef void *CXCXXThisExpr;
typedef void *CXCXXThrowExpr;
typedef void *CXCXXDefaultArgExpr;
typedef void *CXCXXDefaultInitExpr;
typedef void *CXCXXBindTemporaryExpr;
typedef void *CXCXXConstructExpr;
typedef void *CXCXXInheritedCtorInitExpr;
typedef void *CXCXXFunctionalCastExpr;
typedef void *CXCXXTemporaryObjectExpr;
typedef void *CXLambdaExpr;

// LambdaCapture
typedef void *CXLambdaCapture;
typedef void *CXCXXScalarValueInitExpr;
typedef void *CXCXXNewExpr;
typedef void *CXCXXDeleteExpr;
typedef void *CXCXXPseudoDestructorExpr;
typedef void *CXTypeTraitExpr;
typedef void *CXArrayTypeTraitExpr;
typedef void *CXExpressionTraitExpr;
typedef void *CXOverloadExpr;
typedef void *CXUnresolvedLookupExpr;
typedef void *CXDependentScopeDeclRefExpr;
typedef void *CXExprWithCleanups;
typedef void *CXCXXUnresolvedConstructExpr;
typedef void *CXCXXDependentScopeMemberExpr;
typedef void *CXUnresolvedMemberExpr;
typedef void *CXCXXNoexceptExpr;
typedef void *CXPackExpansionExpr;
typedef void *CXSizeOfPackExpr;
typedef void *CXSubstNonTypeTemplateParmExpr;
typedef void *CXSubstNonTypeTemplateParmPackExpr;
typedef void *CXFunctionParmPackExpr;
typedef void *CXMaterializeTemporaryExpr;
typedef void *CXCXXFoldExpr;
typedef void *CXCoroutineSuspendExpr;
typedef void *CXCoawaitExpr;
typedef void *CXDependentCoawaitExpr;
typedef void *CXCoyieldExpr;
typedef void *CXBuiltinBitCastExpr;

// Mangle
typedef void *CXMangleContext;
typedef void *CXItaniumMangleContext;
typedef void *CXMicrosoftMangleContext;
typedef void *CXASTNameGenerator;

// NestedNameSpacifier
typedef void *CXNestedNameSpecifierLoc;
typedef void *CXNestedNameSpecifier;

// RecordLayout
typedef void *CXASTRecordLayout;

// Stmt
typedef void *CXGCCAsmStmtAsmStringPiece;
typedef void *CXCapturedStmtCapture;
typedef void *CXStmt;
typedef void *CXDeclStmt;
typedef void *CXNullStmt;
typedef void *CXCompoundStmt;
typedef void *CXSwitchCase;
typedef void *CXCaseStmt;
typedef void *CXDefaultStmt;
typedef void *CXValueStmt;
typedef void *CXLabelStmt;
typedef void *CXAttributedStmt;
typedef void *CXIfStmt;
typedef void *CXSwitchStmt;
typedef void *CXWhileStmt;
typedef void *CXDoStmt;
typedef void *CXForStmt;
typedef void *CXGotoStmt;
typedef void *CXIndirectGotoStmt;
typedef void *CXContinueStmt;
typedef void *CXBreakStmt;
typedef void *CXReturnStmt;
typedef void *CXAsmStmt;
typedef void *CXGCCAsmStmt;
typedef void *CXMSAsmStmt;
typedef void *CXSEHExceptStmt;
typedef void *CXSEHFinallyStmt;
typedef void *CXSEHTryStmt;
typedef void *CXSEHLeaveStmt;
typedef void *CXCapturedStmt;

// StmtCXX
typedef void *CXCXXCatchStmt;
typedef void *CXCXXTryStmt;
typedef void *CXCXXForRangeStmt;
typedef void *CXMSDependentExistsStmt;
typedef void *CXCoroutineBodyStmt;
typedef void *CXCoreturnStmt;

// Types
typedef void *CXDependentBitIntType;
typedef void *CXBitIntType;
typedef void *CXQualType;
typedef void *CXType_;
typedef void *CXBuiltinType;
typedef void *CXComplexType;
typedef void *CXParenType;
typedef void *CXPointerType;
typedef void *CXAdjustedType;
typedef void *CXDecayedType;
typedef void *CXBlockPointerType;
typedef void *CXReferenceType;
typedef void *CXLValueReferenceType;
typedef void *CXRValueReferenceType;
typedef void *CXMemberPointerType;
typedef void *CXArrayType;
typedef void *CXConstantArrayType;
typedef void *CXIncompleteArrayType;
typedef void *CXVariableArrayType;
typedef void *CXDependentSizedArrayType;
typedef void *CXDependentAddressSpaceType;
typedef void *CXDependentSizedExtVectorType;
typedef void *CXVectorType;
typedef void *CXDependentVectorType;
typedef void *CXExtVectorType;
typedef void *CXMatrixType;
typedef void *CXConstantMatrixType;
typedef void *CXDependentSizedMatrixType;
typedef void *CXFunctionType;
typedef void *CXFunctionNoProtoType;
typedef void *CXFunctionProtoType;
typedef void *CXUnresolvedUsingType;
typedef void *CXUsingType;
typedef void *CXTypedefType;
typedef void *CXMacroQualifiedType;
typedef void *CXTypeOfExprType;
typedef void *CXDependentTypeOfExprType;
typedef void *CXTypeOfType;
typedef void *CXDecltypeType;
typedef void *CXDependentDecltypeType;
typedef void *CXUnaryTransformType;
typedef void *CXDependentUnaryTransformType;
typedef void *CXTagType;
typedef void *CXRecordType;
typedef void *CXEnumType;
typedef void *CXAttributedType;
typedef void *CXTemplateTypeParmType;
typedef void *CXSubstTemplateTypeParmType;
typedef void *CXSubstTemplateTypeParmPackType;
typedef void *CXDeducedType;
typedef void *CXAutoType;
typedef void *CXDeducedTemplateSpecializationType;
typedef void *CXTemplateSpecializationType;
typedef void *CXInjectedClassNameType;
typedef void *CXTypeWithKeyword;
typedef void *CXElaboratedType;
typedef void *CXDependentNameType;
typedef void *CXDependentTemplateSpecializationType;
typedef void *CXPackExpansionType;
typedef void *CXObjCTypeParamType;
typedef void *CXObjCObjectType;
typedef void *CXObjCInterfaceType;
typedef void *CXObjCObjectPointerType;
typedef void *CXAtomicType;
typedef void *CXPipeType;
typedef void *CXExtIntType;
typedef void *CXDependentExtIntType;
typedef void *CXQualifierCollector;
typedef void *CXTypeSourceInfo;

// TypeLoc
typedef void *CXTypeLoc;

// TemplateBase
typedef void *CXTemplateName;
typedef void *CXTemplateArgumentLocInfo;
typedef void *CXTemplateArgumentLoc;
typedef void *CXTemplateArgumentListInfo;
typedef void *CXASTTemplateArgumentListInfo;

// TemplateName
typedef void *CXDependentTemplateName;
typedef void *CXQualifiedTemplateName;
typedef void *CXSubstTemplateTemplateParmStorage;
typedef void *CXSubstTemplateTemplateParmPackStorage;
typedef void *CXAssumedTemplateStorage;
typedef void *CXOverloadedTemplateStorage;
typedef void *CXTemplateArgument;

// Analysis

// ConstructionContext
typedef void *CXConstructionContext;
// CFG
typedef void *CXCFGBuildOptions;
typedef void *CXCFGBlock;
typedef void *CXCFG;

// Basic
// Builtins
typedef void *CXBuiltinContext;
// CodeGenOptions
typedef void *CXCodeGenOptions;

// Diagnostic
typedef void *CXDiagnostic_;
typedef void *CXDiagnosticBuilder;
typedef void *CXStreamingDiagnostic;
typedef void *CXFixItHint;
typedef void *CXStoredDiagnostic;
typedef void *CXDiagnosticErrorTrap;
typedef void *CXDiagnosticConsumer;
typedef void *CXDiagnosticsEngine;

// DiagnosticIDs
typedef void *CXDiagnosticIDs;

// DiagnosticOptions
typedef void *CXDiagnosticOptions;

// FileEntry
typedef void *CXFileEntry;

// FileManager
typedef void *CXDirectoryEntry;
typedef void *CXFileEntryRef;
typedef void *CXFileManager;

// IdentifierTable
typedef void *CXSelector;
typedef void *CXSelectorTable;
typedef void *CXIdentifierInfo;
typedef void *CXIdentifierTable;

// LangOptions
typedef void *CXLangOptions;

// Module
typedef void *CXModule;

// SourceLocation
typedef void *CXPresumedLoc;
typedef void *CXSourceLocation_;

typedef struct CXSourceRange_ {
  CXSourceLocation_ B;
  CXSourceLocation_ E;
} CXSourceRange_;

// SourceManager
typedef void *CXSourceManagerForFile;
typedef void *CXLineOffsetMapping;
typedef void *CXContentCache;
typedef void *CXSLocEntry;
typedef void *CXExpansionInfo;
typedef void *CXFileInfo;
typedef void *CXFileID;
typedef void *CXSourceManager;

// TargetInfo
typedef void *CXConstraintInfo;
typedef void *CXTargetInfo_;

// TargetOptions
typedef void *CXTargetOptions;

// CodeGen
// CodeGenAction
typedef void *CXCodeGenAction;

// ModuleBuilder
typedef void *CXCodeGenerator;
typedef void *CXCodeGenModule;

// Driver
// Driver
typedef void *CXDriver;

// Compilation
typedef void *CXCompilation;

// ToolChain
typedef void *CXToolChain;

// Frontend
// ASTUnit
typedef void *CXASTUnit;

// CompilerInstance
typedef void *CXCompilerInstance;

// CompilerInvocation
typedef void *CXPreprocessorOutputOptions;
typedef void *CXDependencyOutputOptions;
typedef void *CXFileSystemOptions;
typedef void *CXMigratorOptions;
typedef void *CXAnalyzerOptions;
typedef void *CXCompilerInvocation;
typedef void *CXCowCompilerInvocation;

// FrontendOptions
typedef void *CXFrontendOptions;

// Interpreter
typedef void *CXIncrementalCompilerBuilder;
typedef void *CXInterpreter;
typedef void *CXPartialTranslationUnit;
typedef void *CXValue;

// Lex
// HeaderSearch
typedef void *CXHeaderFileInfo;
typedef void *CXHeaderSearch;

// HeaderSearchOptions
typedef void *CXHeaderSearchOptions;

// Lexer
typedef void *CXPreprocessorLexer;
typedef void *CXLexer;

// MacroInfo
typedef void *CXModuleMacro;
typedef void *CXDefMacroDirective;
typedef void *CXDefInfo;
typedef void *CXMacroDirective;
typedef void *CXMacroInfo;

// CodeCompletionHandler
typedef void *CXCodeCompletionHandler;

// ExternalPreprocessorSource
typedef void *CXExternalPreprocessorSource;

// ModuleLoader
typedef void *CXModuleLoader;

// PPCallbacks
typedef void *CXPPCallbacks;

// Preprocessor
typedef void *CXInclusionDirective;
typedef void *CXMacroExpansion;
typedef void *CXMacroDefinitionRecord;
typedef void *CXPreprocessedEntity;
typedef void *CXPreprocessingRecord;
typedef void *CXPreprocessor;
typedef void *CXEmptylineHandler;

// PreprocessorOptions
typedef void *CXPreprocessorOptions;

// Token
typedef void *CXToken_;

typedef void *CXAnnotationValue;

// Parse
// Parser
typedef void *CXParser;

// Sema
typedef void *CXSFINAETrap;
typedef void *CXDefaultedFunctionKind;
typedef void *CXAlignPackInfo;
typedef void *CXExpressionEvaluationContextRecord;
typedef void *CXInstantiatingTemplate;
typedef void *CXSema;

// Overload
typedef void *CXUserDefinedConversionSequence;
typedef void *CXOverloadCandidate;
typedef void *CXAmbiguousConversionSequence;
typedef void *CXStandardConversionSequence;
typedef void *CXBadConversionSequence;
typedef void *CXImplicitConversionSequence;
typedef void *CXOverloadCandidateSet;

// Template
typedef void *CXLocalInstantiationScope;
typedef void *CXMultiLevelTemplateArgumentList;

// TemplateDeduction
typedef void *CXTemplateDeductionInfo;

// DeclSpec
typedef void *CXCXXScopeSpec;

// Lookup
typedef void *CXLookupResult_Filter;
typedef void *CXLookupResult;

// Scope
typedef void *CXScope;

// Others
typedef void *CXRewriter;
typedef enum CXTranslationUnitKind {
  CXTranslationUnitKind_TU_Complete,
  CXTranslationUnitKind_TU_Prefix,
  CXTranslationUnitKind_TU_Module,
  CXTranslationUnitKind_TU_Incremental,
} CXTranslationUnitKind;

typedef void *CXFrontendAction;

LLVM_CLANG_C_EXTERN_C_END

#endif