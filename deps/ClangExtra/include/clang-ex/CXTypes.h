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

// ParentMap
typedef struct CXParentMapImpl *CXParentMap;

// ParentMapContext
typedef struct CXParentMapContextImpl *CXParentMapContext;

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

// ASTMatchers
typedef struct CXBoundNodesImpl *CXBoundNodes;
// ASTMatchFinder
typedef struct CXMatchFinderImpl *CXMatchFinder;
// ASTMatchersInternal
typedef struct CXDynTypedMatcherImpl *CXDynTypedMatcher;
// Dynamic/Parser
typedef struct CXMatcherDiagnosticsImpl *CXMatcherDiagnostics;
typedef struct CXMatcherCompletionListImpl *CXMatcherCompletionList;
// Dynamic/VariantValue
typedef struct CXVariantValueImpl *CXVariantValue;
typedef struct CXNamedValueMapImpl *CXNamedValueMap;
// ASTImporter
typedef struct CXASTImporterImpl *CXASTImporter;
// ASTStructuralEquivalence
typedef struct CXStructuralEquivalenceContextImpl *CXStructuralEquivalenceContext;
// ASTTypeTraits
typedef struct CXDynTypedNodeImpl *CXDynTypedNode;
// ASTConcept
typedef struct CXConceptReferenceImpl *CXConceptReference;
// ExprConcepts
typedef struct CXRequirementImpl *CXRequirement;
typedef struct CXTypeRequirementImpl *CXTypeRequirement;
typedef struct CXExprRequirementImpl *CXExprRequirement;
typedef struct CXNestedRequirementImpl *CXNestedRequirement;
// VTableBuilder
typedef struct CXVTableComponentImpl *CXVTableComponent;
typedef struct CXVTableLayoutImpl *CXVTableLayout;
typedef struct CXVTableContextBaseImpl *CXVTableContextBase;
typedef struct CXItaniumVTableContextImpl *CXItaniumVTableContext;

// Analysis

// ConstructionContext
typedef struct CXConstructionContextImpl *CXConstructionContext;
// CFG
typedef struct CXCFGBuildOptionsImpl *CXCFGBuildOptions;
typedef struct CXCFGBlockImpl *CXCFGBlock;
typedef struct CXCFGImpl *CXCFG;
// CallGraph
typedef struct CXCallGraphImpl *CXCallGraph;
typedef struct CXCallGraphNodeImpl *CXCallGraphNode;
// CloneDetection
typedef struct CXCloneDetectorImpl *CXCloneDetector;
// MacroExpansionContext
typedef struct CXMacroExpansionContextImpl *CXMacroExpansionContext;

// Analyses
// Dominators
typedef struct CXCFGDomTreeImpl *CXCFGDomTree;
typedef struct CXCFGPostDomTreeImpl *CXCFGPostDomTree;
typedef struct CXControlDependencyCalculatorImpl *CXControlDependencyCalculator;
// ExprMutationAnalyzer
typedef struct CXExprMutationAnalyzerImpl *CXExprMutationAnalyzer;
typedef struct CXFunctionParmMutationAnalyzerImpl *CXFunctionParmMutationAnalyzer;

// CFGStmtMap
typedef struct CXCFGStmtMapImpl *CXCFGStmtMap;

// AnalysisDeclContext
typedef struct CXAnalysisDeclContextImpl *CXAnalysisDeclContext;
typedef struct CXAnalysisDeclContextManagerImpl *CXAnalysisDeclContextManager;

// Analyses/CFGReachabilityAnalysis
typedef struct CXCFGReverseBlockReachabilityAnalysisImpl *CXCFGReverseBlockReachabilityAnalysis;

// Analyses/LiveVariables
typedef struct CXLiveVariablesImpl *CXLiveVariables;

// Analyses/UninitializedValues
typedef struct CXUninitVariablesResultImpl *CXUninitVariablesResult;

// Analyses/ReachableCode
typedef struct CXUnreachableCodeResultImpl *CXUnreachableCodeResult;

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

// VirtualFileSystem (llvm/Support/VirtualFileSystem.h; the FileManager cluster is what
// installs one, so the handles live next to it)
typedef struct CXVirtualFileSystemImpl *CXVirtualFileSystem;
typedef struct CXInMemoryFileSystemImpl *CXInMemoryFileSystem;
typedef struct CXOverlayFileSystemImpl *CXOverlayFileSystem;

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

// LangStandard
typedef struct CXLangStandardImpl *CXLangStandard;

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

// CGFunctionInfo
typedef struct CXCGFunctionInfoImpl *CXCGFunctionInfo;
typedef struct CXABIArgInfoImpl *CXABIArgInfo;
// CodeGenABITypes
typedef struct CXAttrBuilderImpl *CXAttrBuilder;
// ObjectFilePCHContainerOperations
typedef struct CXPCHContainerOperationsImpl *CXPCHContainerOperations;
typedef struct CXPCHContainerWriterImpl *CXPCHContainerWriter;
typedef struct CXPCHContainerReaderImpl *CXPCHContainerReader;
// CrossTU
// CrossTranslationUnit
typedef struct CXCrossTranslationUnitContextImpl *CXCrossTranslationUnitContext;
// The "USR<space>filepath" index of clang/CrossTU/CrossTranslationUnit.h, i.e. the
// `llvm::StringMap<std::string>` that parseCrossTUIndex returns and
// createCrossTUIndexString consumes. No llvm-c type spells a StringMap, so the shim
// owns one: clang_CrossTUIndex_create / _dispose in CXCrossTranslationUnit.h.
typedef struct CXCrossTUIndexImpl *CXCrossTUIndex;

// Driver
// Driver
typedef struct CXDriverImpl *CXDriver;

// Compilation
typedef struct CXCompilationImpl *CXCompilation;

// ToolChain
typedef struct CXToolChainImpl *CXToolChain;

// Edit
// Commit
typedef struct CXCommitImpl *CXCommit;
// EditedSource
typedef struct CXEditedSourceImpl *CXEditedSource;
// Format
typedef struct CXFormatStyleImpl *CXFormatStyle;
// Job
typedef struct CXJobListImpl *CXJobList;
typedef struct CXCommandImpl *CXCommand;
// Tool
typedef struct CXToolImpl *CXTool;
// Options
typedef struct CXOptTableImpl *CXOptTable;
typedef struct CXOptionImpl *CXOption;

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

// PrecompiledPreamble
typedef struct CXPrecompiledPreambleImpl *CXPrecompiledPreamble;
// Utils
typedef struct CXDependencyCollectorImpl *CXDependencyCollector;
// Index
// CommentToXML
typedef struct CXCommentToXMLConverterImpl *CXCommentToXMLConverter;
// IndexingAction
// Not a clang class: the one concrete `clang::index::IndexDataConsumer` subclass the
// shim compiles in, batch-collecting the occurrences a run of indexASTUnit /
// indexTopLevelDecls reports. See CXIndexingAction.h.
typedef struct CXIndexDataCollectorImpl *CXIndexDataCollector;

// Interpreter
typedef struct CXIncrementalCompilerBuilderImpl *CXIncrementalCompilerBuilder;
typedef struct CXInterpreterImpl *CXInterpreter;
typedef struct CXPartialTranslationUnitImpl *CXPartialTranslationUnit;
typedef struct CXValueImpl *CXValue;

// Lex
// DependencyDirectivesScanner
// One scan: the input copy, the POD token vector and the directive vector whose
// ArrayRefs point into it, boxed together so the directives stay valid.
typedef struct CXDependencyDirectivesScanImpl *CXDependencyDirectivesScan;

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

// LiteralSupport
// NumericLiteralParser keeps pointers into the spelling it was handed, so its box owns a
// copy of that spelling; the other two parsers hold their results by value.
typedef struct CXNumericLiteralParserImpl *CXNumericLiteralParser;
typedef struct CXCharLiteralParserImpl *CXCharLiteralParser;
typedef struct CXStringLiteralParserImpl *CXStringLiteralParser;

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

// PPConditionalDirectiveRecord
typedef struct CXPPConditionalDirectiveRecordImpl *CXPPConditionalDirectiveRecord;

// Pragma
typedef struct CXPragmaHandlerImpl *CXPragmaHandler;
typedef struct CXEmptyPragmaHandlerImpl *CXEmptyPragmaHandler;
typedef struct CXPragmaNamespaceImpl *CXPragmaNamespace;

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

// TokenConcatenation
typedef struct CXTokenConcatenationImpl *CXTokenConcatenation;

// Parse
// Parser
typedef struct CXParserImpl *CXParser;

// Initialization
typedef struct CXInitializedEntityImpl *CXInitializedEntity;
typedef struct CXInitializationKindImpl *CXInitializationKind;
typedef struct CXInitializationSequenceImpl *CXInitializationSequence;

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

// TypoCorrection
typedef struct CXTypoCorrectionImpl *CXTypoCorrection;
typedef struct CXCorrectionCandidateCallbackImpl *CXCorrectionCandidateCallback;

// Lookup
typedef struct CXLookupResult_FilterImpl *CXLookupResult_Filter;
typedef struct CXLookupResultImpl *CXLookupResult;

// Scope
typedef struct CXScopeImpl *CXScope;

// Tooling
// CompilationDatabase
typedef struct CXCompileCommandImpl *CXCompileCommand;
// A shim-owned std::vector<clang::tooling::CompileCommand>: clang returns the query results
// by value, and this is what a Julia caller indexes them through. No clang class of that name.
typedef struct CXCompileCommandListImpl *CXCompileCommandList;
typedef struct CXCompilationDatabaseImpl *CXCompilationDatabase;
typedef struct CXFixedCompilationDatabaseImpl *CXFixedCompilationDatabase;
// JSONCompilationDatabase
typedef struct CXJSONCompilationDatabaseImpl *CXJSONCompilationDatabase;
// ArgumentsAdjusters
// clang::tooling::ArgumentsAdjuster is a std::function typedef, so the handle boxes the
// closure itself rather than pointing at a clang object.
typedef struct CXArgumentsAdjusterImpl *CXArgumentsAdjuster;
// Tooling
typedef struct CXClangToolImpl *CXClangTool;
typedef struct CXToolInvocationImpl *CXToolInvocation;
// Replacement
typedef struct CXReplacementImpl *CXReplacement;
typedef struct CXReplacementsImpl *CXReplacements;
// StandardLibrary
// `stdlib::Symbol` and `stdlib::Header` are (unsigned ID, Lang) value pairs with private
// constructors; these handles are heap-boxed copies. The two *List handles are shim-owned
// std::vectors -- clang hands `all()`/`headers()` back by value, so there is nothing to
// borrow from.
typedef struct CXStdlibSymbolImpl *CXStdlibSymbol;
typedef struct CXStdlibHeaderImpl *CXStdlibHeader;
typedef struct CXStdlibSymbolListImpl *CXStdlibSymbolList;
typedef struct CXStdlibHeaderListImpl *CXStdlibHeaderList;
typedef struct CXStdlibRecognizerImpl *CXStdlibRecognizer;
// IncludeStyle
typedef struct CXIncludeStyleImpl *CXIncludeStyle;
// HeaderIncludes
typedef struct CXIncludeCategoryManagerImpl *CXIncludeCategoryManager;
typedef struct CXHeaderIncludesImpl *CXHeaderIncludes;
// DependencyScanningService
typedef struct CXDependencyScanningServiceImpl *CXDependencyScanningService;
// DependencyScanningTool
typedef struct CXDependencyScanningToolImpl *CXDependencyScanningTool;
// Tokens
typedef struct CXSyntaxTokenImpl *CXSyntaxToken;
typedef struct CXSyntaxTokenListImpl *CXSyntaxTokenList;
typedef struct CXTokenBufferImpl *CXTokenBuffer;
typedef struct CXTokenCollectorImpl *CXTokenCollector;

// Others
typedef struct CXRewriterImpl *CXRewriter;
// FixItRewriter -- the handle designates a shim-side box holding the FixItRewriter
// together with the one FixItOptions subclass libclangex compiles; see CXFixItRewriter.h.
typedef struct CXFixItRewriterImpl *CXFixItRewriter;
typedef enum CXTranslationUnitKind {
  CXTranslationUnitKind_TU_Complete,
  CXTranslationUnitKind_TU_Prefix,
  CXTranslationUnitKind_TU_Module,
  CXTranslationUnitKind_TU_Incremental,
} CXTranslationUnitKind;

typedef struct CXFrontendActionImpl *CXFrontendAction;

LLVM_CLANG_C_EXTERN_C_END

#endif