# Per-carrier abstract types for hand-written leaf/value carriers that would
# otherwise subtype a parent's abstract (or Any). Front-loaded via abstract.jl
# so every concrete Foo has its own AbstractFoo (uniform loose-typing / MI).
abstract type AbstractAPValue end
abstract type AbstractASTNameGenerator end
abstract type AbstractASTTemplateArgumentListInfo end
abstract type AbstractAnnotationValue end
abstract type AbstractBFloat16Ty <: AbstractBuiltinType end
abstract type AbstractBoolTy <: AbstractBuiltinType end
abstract type AbstractBuiltinTemplateDecl <: AbstractTemplateDecl end
abstract type AbstractCXXBaseSpecifier end
abstract type AbstractCXXCtorInitializer end
abstract type AbstractCXXScopeSpec end
abstract type AbstractChar16Ty <: AbstractBuiltinType end
abstract type AbstractChar32Ty <: AbstractBuiltinType end
abstract type AbstractChar8Ty <: AbstractBuiltinType end
abstract type AbstractCharTy <: AbstractBuiltinType end
abstract type AbstractClassScopeFunctionSpecializationDecl <: AbstractDecl end
abstract type AbstractClassTemplatePartialSpecializationDecl <: AbstractClassTemplateSpecializationDecl end
abstract type AbstractCodeGenModule end
abstract type AbstractCodeGenOptions end
abstract type AbstractCodeGenerator <: AbstractASTConsumer end
abstract type AbstractCompilerInvocation end
abstract type AbstractConceptDecl <: AbstractTemplateDecl end
abstract type AbstractDeclarationNameInfo end
abstract type AbstractDependentFunctionTemplateSpecializationInfo end
abstract type AbstractDiagnosticIDs end
abstract type AbstractDiagnosticOptions end
abstract type AbstractDiagnosticsEngine end
abstract type AbstractDirectoryEntry end
abstract type AbstractDoubleComplexTy <: AbstractBuiltinType end
abstract type AbstractDoubleTy <: AbstractBuiltinType end
abstract type AbstractEmitAssemblyAction <: AbstractCodeGenAction end
abstract type AbstractEmitBCAction <: AbstractCodeGenAction end
abstract type AbstractEmitCodeGenOnlyAction <: AbstractCodeGenAction end
abstract type AbstractEmitLLVMAction <: AbstractCodeGenAction end
abstract type AbstractEmitObjAction <: AbstractCodeGenAction end
abstract type AbstractExplicitSpecifier end
abstract type AbstractExpr_ <: AbstractExpr end
abstract type AbstractFileEntry end
abstract type AbstractFileEntryRef end
abstract type AbstractFileID end
abstract type AbstractFileManager end
abstract type AbstractFloat128ComplexTy <: AbstractBuiltinType end
abstract type AbstractFloat128Ty <: AbstractBuiltinType end
abstract type AbstractFloat16Ty <: AbstractBuiltinType end
abstract type AbstractFloatComplexTy <: AbstractBuiltinType end
abstract type AbstractFloatTy <: AbstractBuiltinType end
abstract type AbstractFriendTemplateDecl <: AbstractDecl end
abstract type AbstractFrontendOptions end
abstract type AbstractFunctionTemplateDecl <: AbstractRedeclarableTemplateDecl end
abstract type AbstractFunctionTemplateSpecializationInfo end
abstract type AbstractHalfTy <: AbstractBuiltinType end
abstract type AbstractHeaderSearch end
abstract type AbstractHeaderSearchOptions end
abstract type AbstractIdentifierInfo end
abstract type AbstractIdentifierTable end
abstract type AbstractIgnoringDiagConsumer <: AbstractDiagnosticConsumer end
abstract type AbstractInt128Ty <: AbstractBuiltinType end
abstract type AbstractIntTy <: AbstractBuiltinType end
abstract type AbstractLLVMOnlyAction <: AbstractCodeGenAction end
abstract type AbstractLambdaCapture end
abstract type AbstractLangOptions end
abstract type AbstractLexer end
abstract type AbstractLongDoubleComplexTy <: AbstractBuiltinType end
abstract type AbstractLongDoubleTy <: AbstractBuiltinType end
abstract type AbstractLongLongTy <: AbstractBuiltinType end
abstract type AbstractLongTy <: AbstractBuiltinType end
abstract type AbstractLookupResult end
abstract type AbstractMangleContext end
abstract type AbstractMemberSpecializationInfo end
abstract type AbstractNestedNameSpecifier end
abstract type AbstractNonTypeTemplateParmDecl <: AbstractDeclaratorDecl end
abstract type AbstractNullPtrTy <: AbstractBuiltinType end
abstract type AbstractParser end
abstract type AbstractPreprocessor end
abstract type AbstractPreprocessorOptions end
abstract type AbstractScope end
abstract type AbstractSema end
abstract type AbstractShortTy <: AbstractBuiltinType end
abstract type AbstractSignedCharTy <: AbstractBuiltinType end
abstract type AbstractSourceLocation end
abstract type AbstractSourceManager end
abstract type AbstractTargetInfo end
abstract type AbstractTargetOptions end
abstract type AbstractTemplateArgument end
abstract type AbstractTemplateArgumentList end
abstract type AbstractTemplateArgumentListInfo end
abstract type AbstractTemplateArgumentLoc end
abstract type AbstractTemplateArgumentLocInfo end
abstract type AbstractTemplateName end
abstract type AbstractTemplateParamObjectDecl <: AbstractValueDecl end
abstract type AbstractTemplateParameterList end
abstract type AbstractTemplateTemplateParmDecl <: AbstractTemplateDecl end
abstract type AbstractTemplateTypeParmDecl <: AbstractTypeDecl end
abstract type AbstractTextDiagnosticPrinter <: AbstractDiagnosticConsumer end
abstract type AbstractToken end
abstract type AbstractTypeAliasTemplateDecl <: AbstractRedeclarableTemplateDecl end
abstract type AbstractTypeLoc end
abstract type AbstractTypeSourceInfo end
abstract type AbstractType_ <: AbstractType end
abstract type AbstractUnsignedCharTy <: AbstractBuiltinType end
abstract type AbstractUnsignedInt128Ty <: AbstractBuiltinType end
abstract type AbstractUnsignedIntTy <: AbstractBuiltinType end
abstract type AbstractUnsignedLongLongTy <: AbstractBuiltinType end
abstract type AbstractUnsignedLongTy <: AbstractBuiltinType end
abstract type AbstractUnsignedShortTy <: AbstractBuiltinType end
abstract type AbstractVarTemplateDecl <: AbstractRedeclarableTemplateDecl end
abstract type AbstractVarTemplatePartialSpecializationDecl <: AbstractVarTemplateSpecializationDecl end
abstract type AbstractVoidPtrTy <: AbstractBuiltinType end
abstract type AbstractVoidTy <: AbstractBuiltinType end
abstract type AbstractWCharTy <: AbstractBuiltinType end
abstract type AbstractWIntTy <: AbstractBuiltinType end
abstract type AbstractWideCharTy <: AbstractBuiltinType end
