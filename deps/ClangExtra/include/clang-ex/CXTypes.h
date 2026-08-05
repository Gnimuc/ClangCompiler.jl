#ifndef LLVM_CLANG_C_EXTRA_CXTYPES_H
#define LLVM_CLANG_C_EXTRA_CXTYPES_H

#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"
#include <stdbool.h>
#include <stdint.h>
#include <time.h>

LLVM_CLANG_C_EXTERN_C_BEGIN

// One opaque handle per class in each of clang's node families, stamped from the same
// vendored .inc files that stamp the classification enums and the downcasts. Stamping
// rather than listing is what lets `clang_Stmt_castToIfStmt` return `CXIfStmt` instead of
// `CXStmt`: the cast's return type is spelled by the same macro expansion that declares the
// handle, so the two cannot drift, and an LLVM bump adds both together.
//
// StmtNodes.inc and TypeNodes.inc undef their own macros; DeclNodes.inc and AttrList.inc
// only undef their category macros, so those two are undef'd here.
#define STMT(CLASS, PARENT) typedef struct CX##CLASS##Impl *CX##CLASS;
#define ABSTRACT_STMT(S) S
#include "clang-ex/AST/StmtNodes.inc"

#define DECL(DERIVED, BASE) typedef struct CX##DERIVED##DeclImpl *CX##DERIVED##Decl;
#define ABSTRACT_DECL(D) D
#include "clang-ex/AST/DeclNodes.inc"
#undef DECL
#undef ABSTRACT_DECL

#define ATTR(X) typedef struct CX##X##AttrImpl *CX##X##Attr;
#include "clang-ex/AST/AttrList.inc"
#undef ATTR

#define TYPE(Class, Base) typedef struct CX##Class##TypeImpl *CX##Class##Type;
#include "clang-ex/AST/TypeNodes.inc"

#define TYPE(Class, Base) typedef struct CX##Class##TypeLocImpl *CX##Class##TypeLoc;
#define ABSTRACT_TYPE(Class, Base)
#include "clang-ex/AST/TypeNodes.inc"

// TypeLoc classes with no TypeNodes.inc counterpart: the qualified wrapper and the
// payload-bearing intermediates, all four cast by hand in CXTypeLoc.h.
typedef struct CXQualifiedTypeLocImpl *CXQualifiedTypeLoc;
typedef struct CXTypeSpecTypeLocImpl *CXTypeSpecTypeLoc;
typedef struct CXFunctionTypeLocImpl *CXFunctionTypeLoc;
typedef struct CXArrayTypeLocImpl *CXArrayTypeLoc;

// ADT
typedef struct {
  const void *Data;
  size_t Length;
} CXArrayRef;

// APINotes
// APINotesOptions
typedef struct CXAPINotesOptionsImpl *CXAPINotesOptions;

// AST

// PrettyPrinter
typedef struct CXPrintingPolicy_Impl *CXPrintingPolicy_;
// ASTConsumer
typedef struct CXASTConsumerImpl *CXASTConsumer;

// ASTContext
typedef struct CXDeclInfoImpl *CXDeclInfo;
typedef struct CXVerbatimLineCommentImpl *CXVerbatimLineComment;
typedef struct CXVerbatimBlockCommentImpl *CXVerbatimBlockComment;
typedef struct CXVerbatimBlockLineCommentImpl *CXVerbatimBlockLineComment;
typedef struct CXTParamCommandCommentImpl *CXTParamCommandComment;
typedef struct CXHTMLEndTagCommentImpl *CXHTMLEndTagComment;
typedef struct CXHTMLStartTagCommentImpl *CXHTMLStartTagComment;
typedef struct CXHTMLTagCommentImpl *CXHTMLTagComment;
typedef struct CXInlineCommandCommentImpl *CXInlineCommandComment;
typedef struct CXParagraphCommentImpl *CXParagraphComment;
typedef struct CXInlineContentCommentImpl *CXInlineContentComment;
typedef struct CXFullCommentImpl *CXFullComment;
typedef struct CXParamCommandCommentImpl *CXParamCommandComment;
typedef struct CXBlockCommandCommentImpl *CXBlockCommandComment;
typedef struct CXTextCommentImpl *CXTextComment;
typedef struct CXCommentImpl *CXComment;
typedef struct CXRawCommentImpl *CXRawComment;
typedef struct CXRawCommentListImpl *CXRawCommentList;
typedef struct CXASTContextImpl *CXASTContext;

// Decl
typedef struct CXEvaluatedStmtImpl *CXEvaluatedStmt;

// DeclarationName
typedef struct CXDeclarationNameTableImpl *CXDeclarationNameTable;
typedef struct CXDeclarationNameImpl *CXDeclarationName;
typedef struct CXDeclarationNameInfoImpl *CXDeclarationNameInfo;

// DeclBase
typedef struct CXDeclImpl *CXDecl;
typedef struct CXDeclContextImpl *CXDeclContext;

// DeclCXX
typedef struct CXCXXBaseSpecifierImpl *CXCXXBaseSpecifier;
typedef struct CXExplicitSpecifierImpl *CXExplicitSpecifier;
typedef struct CXCXXCtorInitializerImpl *CXCXXCtorInitializer;

// DeclGroup
typedef struct CXDeclGroupRefImpl *CXDeclGroupRef;

// DeclTemplate
typedef struct CXTemplateParameterListImpl *CXTemplateParameterList;
typedef struct CXTemplateArgumentListImpl *CXTemplateArgumentList;
typedef struct CXFunctionTemplateSpecializationInfoImpl *CXFunctionTemplateSpecializationInfo;
typedef struct CXMemberSpecializationInfoImpl *CXMemberSpecializationInfo;
typedef struct CXDependentFunctionTemplateSpecializationInfoImpl *CXDependentFunctionTemplateSpecializationInfo;
typedef struct CXClassScopeFunctionSpecializationDeclImpl *CXClassScopeFunctionSpecializationDecl;

// APValue
typedef struct CXAPValueImpl *CXAPValue;

// Attr
typedef struct CXAttrImpl *CXAttr;

// Expr
typedef struct CXEvalResult_Impl *CXEvalResult_;
typedef struct CXClassificationImpl *CXClassification;
typedef struct CXOffsetOfNodeImpl *CXOffsetOfNode;
typedef struct CXDesignatorImpl *CXDesignator;
typedef struct CXBlockVarCopyInitImpl *CXBlockVarCopyInit;

// ExprCXX
typedef struct CXCXXTemporaryImpl *CXCXXTemporary;

// LambdaCapture
typedef struct CXLambdaCaptureImpl *CXLambdaCapture;

// Mangle
typedef struct CXMangleContextImpl *CXMangleContext;
typedef struct CXItaniumMangleContextImpl *CXItaniumMangleContext;
typedef struct CXMicrosoftMangleContextImpl *CXMicrosoftMangleContext;
typedef struct CXASTNameGeneratorImpl *CXASTNameGenerator;

// NestedNameSpacifier
typedef struct CXNestedNameSpecifierLocImpl *CXNestedNameSpecifierLoc;
typedef struct CXNestedNameSpecifierImpl *CXNestedNameSpecifier;

// RecordLayout
typedef struct CXASTRecordLayoutImpl *CXASTRecordLayout;

// Stmt
typedef struct CXGCCAsmStmtAsmStringPieceImpl *CXGCCAsmStmtAsmStringPiece;
typedef struct CXCapturedStmtCaptureImpl *CXCapturedStmtCapture;
typedef struct CXStmtImpl *CXStmt;

// StmtCXX

// Types
typedef struct CXQualTypeImpl *CXQualType;
typedef struct CXType_Impl *CXType_;
typedef struct CXDependentTypeOfExprTypeImpl *CXDependentTypeOfExprType;
typedef struct CXDependentDecltypeTypeImpl *CXDependentDecltypeType;
typedef struct CXDependentUnaryTransformTypeImpl *CXDependentUnaryTransformType;
typedef struct CXTypeWithKeywordImpl *CXTypeWithKeyword;
typedef struct CXExtIntTypeImpl *CXExtIntType;
typedef struct CXDependentExtIntTypeImpl *CXDependentExtIntType;
typedef struct CXQualifierCollectorImpl *CXQualifierCollector;
typedef struct CXTypeSourceInfoImpl *CXTypeSourceInfo;

// TypeLoc
typedef struct CXTypeLocImpl *CXTypeLoc;

// TemplateBase
typedef struct CXTemplateNameImpl *CXTemplateName;
typedef struct CXTemplateArgumentLocInfoImpl *CXTemplateArgumentLocInfo;
typedef struct CXTemplateArgumentLocImpl *CXTemplateArgumentLoc;
typedef struct CXTemplateArgumentListInfoImpl *CXTemplateArgumentListInfo;
typedef struct CXASTTemplateArgumentListInfoImpl *CXASTTemplateArgumentListInfo;

// TemplateName
typedef struct CXDependentTemplateNameImpl *CXDependentTemplateName;
typedef struct CXQualifiedTemplateNameImpl *CXQualifiedTemplateName;
typedef struct CXSubstTemplateTemplateParmStorageImpl *CXSubstTemplateTemplateParmStorage;
typedef struct CXSubstTemplateTemplateParmPackStorageImpl *CXSubstTemplateTemplateParmPackStorage;
typedef struct CXAssumedTemplateStorageImpl *CXAssumedTemplateStorage;
typedef struct CXOverloadedTemplateStorageImpl *CXOverloadedTemplateStorage;
typedef struct CXTemplateArgumentImpl *CXTemplateArgument;

// Analysis

// ConstructionContext
typedef struct CXConstructionContextImpl *CXConstructionContext;
// CFG
typedef struct CXCFGBuildOptionsImpl *CXCFGBuildOptions;
typedef struct CXCFGBlockImpl *CXCFGBlock;
typedef struct CXCFGImpl *CXCFG;

// Basic
// Builtins
typedef struct CXBuiltinContextImpl *CXBuiltinContext;
// CodeGenOptions
typedef struct CXCodeGenOptionsImpl *CXCodeGenOptions;

// Diagnostic
typedef struct CXDiagnostic_Impl *CXDiagnostic_;
typedef struct CXDiagnosticBuilderImpl *CXDiagnosticBuilder;
typedef struct CXStreamingDiagnosticImpl *CXStreamingDiagnostic;
typedef struct CXFixItHintImpl *CXFixItHint;
typedef struct CXStoredDiagnosticImpl *CXStoredDiagnostic;
typedef struct CXDiagnosticErrorTrapImpl *CXDiagnosticErrorTrap;
typedef struct CXDiagnosticConsumerImpl *CXDiagnosticConsumer;
typedef struct CXDiagnosticsEngineImpl *CXDiagnosticsEngine;

// DiagnosticIDs
typedef struct CXDiagnosticIDsImpl *CXDiagnosticIDs;

// DiagnosticOptions
typedef struct CXDiagnosticOptionsImpl *CXDiagnosticOptions;

// FileEntry
typedef struct CXFileEntryImpl *CXFileEntry;

// FileManager
typedef struct CXDirectoryEntryImpl *CXDirectoryEntry;
typedef struct CXDirectoryEntryRefImpl *CXDirectoryEntryRef;
typedef struct CXFileEntryRefImpl *CXFileEntryRef;
typedef struct CXFileManagerImpl *CXFileManager;

// IdentifierTable
typedef struct CXSelectorImpl *CXSelector;
typedef struct CXSelectorTableImpl *CXSelectorTable;
typedef struct CXIdentifierInfoImpl *CXIdentifierInfo;
typedef struct CXIdentifierTableImpl *CXIdentifierTable;

// LangOptions
typedef struct CXLangOptionsImpl *CXLangOptions;

// Module
typedef struct CXModule_Impl *CXModule_;

// SourceLocation
typedef struct CXPresumedLocImpl *CXPresumedLoc;
typedef struct CXSourceLocation_Impl *CXSourceLocation_;

typedef struct CXSourceRange_ {
  CXSourceLocation_ B;
  CXSourceLocation_ E;
} CXSourceRange_;

// SourceManager
typedef struct CXSourceManagerForFileImpl *CXSourceManagerForFile;
typedef struct CXLineOffsetMappingImpl *CXLineOffsetMapping;
typedef struct CXContentCacheImpl *CXContentCache;
typedef struct CXSLocEntryImpl *CXSLocEntry;
typedef struct CXExpansionInfoImpl *CXExpansionInfo;
typedef struct CXFileInfoImpl *CXFileInfo;
typedef struct CXFileIDImpl *CXFileID;
typedef struct CXSourceManagerImpl *CXSourceManager;

// TargetInfo
typedef struct CXConstraintInfoImpl *CXConstraintInfo;
typedef struct CXTargetInfo_Impl *CXTargetInfo_;

// TargetOptions
typedef struct CXTargetOptionsImpl *CXTargetOptions;

// CodeGen
// CodeGenAction
typedef struct CXCodeGenActionImpl *CXCodeGenAction;

// ModuleBuilder
typedef struct CXCodeGeneratorImpl *CXCodeGenerator;
typedef struct CXCodeGenModuleImpl *CXCodeGenModule;

// Driver
// Driver
typedef struct CXDriverImpl *CXDriver;

// Compilation
typedef struct CXCompilationImpl *CXCompilation;

// ToolChain
typedef struct CXToolChainImpl *CXToolChain;

// Frontend
// ASTUnit
typedef struct CXASTUnitImpl *CXASTUnit;

// CompilerInstance
typedef struct CXCompilerInstanceImpl *CXCompilerInstance;

// CompilerInvocation
typedef struct CXPreprocessorOutputOptionsImpl *CXPreprocessorOutputOptions;
typedef struct CXDependencyOutputOptionsImpl *CXDependencyOutputOptions;
typedef struct CXFileSystemOptionsImpl *CXFileSystemOptions;
typedef struct CXMigratorOptionsImpl *CXMigratorOptions;
typedef struct CXAnalyzerOptionsImpl *CXAnalyzerOptions;
typedef struct CXCompilerInvocationImpl *CXCompilerInvocation;
typedef struct CXCowCompilerInvocationImpl *CXCowCompilerInvocation;

// FrontendOptions
typedef struct CXFrontendOptionsImpl *CXFrontendOptions;

// Interpreter
typedef struct CXIncrementalCompilerBuilderImpl *CXIncrementalCompilerBuilder;
typedef struct CXInterpreterImpl *CXInterpreter;
typedef struct CXPartialTranslationUnitImpl *CXPartialTranslationUnit;
typedef struct CXValueImpl *CXValue;

// Lex
// DirectoryLookup
typedef struct CXDirectoryLookupImpl *CXDirectoryLookup;

// HeaderMap
typedef struct CXHeaderMapImpl *CXHeaderMap;

// HeaderSearch
typedef struct CXHeaderFileInfoImpl *CXHeaderFileInfo;
typedef struct CXHeaderSearchImpl *CXHeaderSearch;

// HeaderSearchOptions
typedef struct CXHeaderSearchOptionsImpl *CXHeaderSearchOptions;

// Lexer
typedef struct CXPreprocessorLexerImpl *CXPreprocessorLexer;
typedef struct CXLexerImpl *CXLexer;

// MacroInfo
typedef struct CXModuleMacroImpl *CXModuleMacro;
typedef struct CXDefMacroDirectiveImpl *CXDefMacroDirective;
typedef struct CXDefInfoImpl *CXDefInfo;
typedef struct CXMacroDirectiveImpl *CXMacroDirective;
typedef struct CXMacroInfoImpl *CXMacroInfo;

// CodeCompletionHandler
typedef struct CXCodeCompletionHandlerImpl *CXCodeCompletionHandler;

// ExternalPreprocessorSource
typedef struct CXExternalPreprocessorSourceImpl *CXExternalPreprocessorSource;

// ModuleLoader
typedef struct CXModuleLoaderImpl *CXModuleLoader;

// PPCallbacks
typedef struct CXPPCallbacksImpl *CXPPCallbacks;

// Preprocessor
typedef struct CXInclusionDirectiveImpl *CXInclusionDirective;
typedef struct CXMacroExpansionImpl *CXMacroExpansion;
typedef struct CXMacroDefinitionRecordImpl *CXMacroDefinitionRecord;
typedef struct CXPreprocessedEntityImpl *CXPreprocessedEntity;
typedef struct CXPreprocessingRecordImpl *CXPreprocessingRecord;
typedef struct CXPreprocessorImpl *CXPreprocessor;
typedef struct CXEmptylineHandlerImpl *CXEmptylineHandler;

// PreprocessorOptions
typedef struct CXPreprocessorOptionsImpl *CXPreprocessorOptions;

// Token
typedef struct CXToken_Impl *CXToken_;

typedef struct CXAnnotationValueImpl *CXAnnotationValue;

// Parse
// Parser
typedef struct CXParserImpl *CXParser;

// Sema
typedef struct CXSFINAETrapImpl *CXSFINAETrap;
typedef struct CXDefaultedFunctionKindImpl *CXDefaultedFunctionKind;
typedef struct CXAlignPackInfoImpl *CXAlignPackInfo;
typedef struct CXExpressionEvaluationContextRecordImpl *CXExpressionEvaluationContextRecord;
typedef struct CXInstantiatingTemplateImpl *CXInstantiatingTemplate;
typedef struct CXSemaImpl *CXSema;

// Overload
typedef struct CXUserDefinedConversionSequenceImpl *CXUserDefinedConversionSequence;
typedef struct CXOverloadCandidateImpl *CXOverloadCandidate;
typedef struct CXAmbiguousConversionSequenceImpl *CXAmbiguousConversionSequence;
typedef struct CXStandardConversionSequenceImpl *CXStandardConversionSequence;
typedef struct CXBadConversionSequenceImpl *CXBadConversionSequence;
typedef struct CXImplicitConversionSequenceImpl *CXImplicitConversionSequence;
typedef struct CXOverloadCandidateSetImpl *CXOverloadCandidateSet;

// Template
typedef struct CXLocalInstantiationScopeImpl *CXLocalInstantiationScope;
typedef struct CXMultiLevelTemplateArgumentListImpl *CXMultiLevelTemplateArgumentList;

// TemplateDeduction
typedef struct CXTemplateDeductionInfoImpl *CXTemplateDeductionInfo;

// DeclSpec
typedef struct CXCXXScopeSpecImpl *CXCXXScopeSpec;

// Lookup
typedef struct CXLookupResult_FilterImpl *CXLookupResult_Filter;
typedef struct CXLookupResultImpl *CXLookupResult;

// Scope
typedef struct CXScopeImpl *CXScope;

// Others
typedef struct CXRewriterImpl *CXRewriter;
typedef enum CXTranslationUnitKind {
  CXTranslationUnitKind_TU_Complete,
  CXTranslationUnitKind_TU_Prefix,
  CXTranslationUnitKind_TU_Module,
  CXTranslationUnitKind_TU_Incremental,
} CXTranslationUnitKind;

typedef struct CXFrontendActionImpl *CXFrontendAction;

LLVM_CLANG_C_EXTERN_C_END

#endif