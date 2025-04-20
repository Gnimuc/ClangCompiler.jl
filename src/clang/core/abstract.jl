# AST
# ASTConsumer
"""
    abstract type AbstractASTConsumer <: Any
Supertype for `ASTConsumer`s.
"""
abstract type AbstractASTConsumer end

# ASTContext
"""
    abstract type AbstractASTContext <: Any
Supertype for `ASTContext`s.
"""
abstract type AbstractASTContext end

# Decl
"""
    abstract type AbstractDecl <: Any
Supertype for `Decl`s.
"""
abstract type AbstractDecl end

"""
    abstract type AbstractTranslationUnitDecl <: AbstractDecl
Supertype for `TranslationUnitDecl`s.
"""
abstract type AbstractTranslationUnitDecl <: AbstractDecl end

"""
    abstract type AbstractPragmaCommentDecl <: AbstractDecl
Supertype for `PragmaCommentDecl`s.
"""
abstract type AbstractPragmaCommentDecl <: AbstractDecl end

"""
    abstract type AbstractPragmaDetectMismatchDecl <: AbstractDecl
Supertype for `PragmaDetectMismatchDecl`s.
"""
abstract type AbstractPragmaDetectMismatchDecl <: AbstractDecl end

"""
    abstract type AbstractExternCContextDecl <: AbstractDecl
Supertype for `ExternCContextDecl`s.
"""
abstract type AbstractExternCContextDecl <: AbstractDecl end

"""
    abstract type AbstractNamedDecl <: AbstractDecl
Supertype for `NamedDecl`s.
"""
abstract type AbstractNamedDecl <: AbstractDecl end

"""
    abstract type AbstractLabelDecl <: AbstractNamedDecl
Supertype for `LabelDecl`s.
"""
abstract type AbstractLabelDecl <: AbstractNamedDecl end

"""
    abstract type AbstractNamespaceDecl <: AbstractNamedDecl
Supertype for `NamespaceDecl`s.
"""
abstract type AbstractNamespaceDecl <: AbstractNamedDecl end

"""
    abstract type AbstractValueDecl <: AbstractNamedDecl
Supertype for `ValueDecl`s.
"""
abstract type AbstractValueDecl <: AbstractNamedDecl end

"""
    abstract type AbstractDeclaratorDecl <: AbstractValueDecl
Supertype for `DeclaratorDecl`s.
"""
abstract type AbstractDeclaratorDecl <: AbstractValueDecl end

"""
    abstract type AbstractVarDecl <: AbstractDeclaratorDecl
Supertype for `VarDecl`s.
"""
abstract type AbstractVarDecl <: AbstractDeclaratorDecl end

"""
    abstract type AbstractImplicitParamDecl <: AbstractVarDecl
Supertype for `ImplicitParamDecl`s.
"""
abstract type AbstractImplicitParamDecl <: AbstractVarDecl end

"""
    abstract type AbstractParmVarDecl <: AbstractVarDecl
Supertype for `ParmVarDecl`s.
"""
abstract type AbstractParmVarDecl <: AbstractVarDecl end

"""
    abstract type AbstractFunctionDecl <: AbstractDeclaratorDecl
Supertype for `FunctionDecl`s.
"""
abstract type AbstractFunctionDecl <: AbstractDeclaratorDecl end

"""
    abstract type AbstractFieldDecl <: AbstractDeclaratorDecl
Supertype for `FieldDecl`s.
"""
abstract type AbstractFieldDecl <: AbstractDeclaratorDecl end

"""
    abstract type AbstractEnumConstantDecl <: AbstractValueDecl
Supertype for `EnumConstantDecl`s.
"""
abstract type AbstractEnumConstantDecl <: AbstractValueDecl end

"""
    abstract type AbstractIndirectFieldDecl <: AbstractValueDecl
Supertype for `IndirectFieldDecl`s.
"""
abstract type AbstractIndirectFieldDecl <: AbstractValueDecl end

"""
    abstract type AbstractTypeDecl <: AbstractNamedDecl
Supertype for `TypeDecl`s.
"""
abstract type AbstractTypeDecl <: AbstractNamedDecl end

"""
    abstract type AbstractTypedefNameDecl <: AbstractTypeDecl
Supertype for `TypedefNameDecl`s.
"""
abstract type AbstractTypedefNameDecl <: AbstractTypeDecl end

"""
    abstract type AbstractTypedefDecl <: AbstractTypedefNameDecl
Supertype for `TypedefDecl`s.
"""
abstract type AbstractTypedefDecl <: AbstractTypedefNameDecl end

"""
    abstract type AbstractTypeAliasDecl <: AbstractTypedefNameDecl
Supertype for `TypeAliasDecl`s.
"""
abstract type AbstractTypeAliasDecl <: AbstractTypedefNameDecl end

"""
    abstract type AbstractTagDecl <: AbstractTypeDecl
Supertype for `TagDecl`s.
"""
abstract type AbstractTagDecl <: AbstractTypeDecl end

"""
    abstract type AbstractEnumDecl <: AbstractTagDecl
Supertype for `EnumDecl`s.
"""
abstract type AbstractEnumDecl <: AbstractTagDecl end

"""
    abstract type AbstractRecordDecl <: AbstractTagDecl
Supertype for `RecordDecl`s.
"""
abstract type AbstractRecordDecl <: AbstractTagDecl end

"""
    abstract type AbstractFileScopeAsmDecl <: AbstractDecl
Supertype for `FileScopeAsmDecl`s.
"""
abstract type AbstractFileScopeAsmDecl <: AbstractDecl end

"""
    abstract type AbstractBlockDecl <: AbstractDecl
Supertype for `BlockDecl`s.
"""
abstract type AbstractBlockDecl <: AbstractDecl end

"""
    abstract type AbstractCapturedDecl <: AbstractDecl
Supertype for `CapturedDecl`s.
"""
abstract type AbstractCapturedDecl <: AbstractDecl end

"""
    abstract type AbstractImportDecl <: AbstractDecl
Supertype for `ImportDecl`s.
"""
abstract type AbstractImportDecl <: AbstractDecl end

"""
    abstract type AbstractExportDecl <: AbstractDecl
Supertype for `ExportDecl`s.
"""
abstract type AbstractExportDecl <: AbstractDecl end

"""
    abstract type AbstractEmptyDecl <: AbstractDecl
Supertype for `EmptyDecl`s.
"""
abstract type AbstractEmptyDecl <: AbstractDecl end

# DeclarationName
"""
    abstract type AbstractDeclarationName <: Any
Supertype for `DeclarationName`s.
"""
abstract type AbstractDeclarationName end

# DeclBase
"""
    abstract type AbstractDeclContext <: Any
Supertype for `DeclContext`s.
"""
abstract type AbstractDeclContext end

# DeclCXX
"""
    abstract type AbstractAccessSpecDecl <: AbstractDecl
Supertype for `AccessSpecDecl`s.
"""
abstract type AbstractAccessSpecDecl <: AbstractDecl end

"""
    abstract type AbstractCXXRecordDecl <: AbstractRecordDecl
Supertype for `CXXRecordDecl`s.
"""
abstract type AbstractCXXRecordDecl <: AbstractRecordDecl end

"""
    abstract type AbstractCXXDeductionGuideDecl <: AbstractFunctionDecl
Supertype for `CXXDeductionGuideDecl`s.
"""
abstract type AbstractCXXDeductionGuideDecl <: AbstractFunctionDecl end

"""
    abstract type AbstractRequiresExprBodyDecl <: AbstractDecl
Supertype for `RequiresExprBodyDecl`s.
"""
abstract type AbstractRequiresExprBodyDecl <: AbstractDecl end

"""
    abstract type AbstractCXXMethodDecl <: AbstractFunctionDecl
Supertype for `CXXMethodDecl`s.
"""
abstract type AbstractCXXMethodDecl <: AbstractFunctionDecl end

"""
    abstract type AbstractCXXConstructorDecl <: AbstractCXXMethodDecl
Supertype for `CXXConstructorDecl`s.
"""
abstract type AbstractCXXConstructorDecl <: AbstractCXXMethodDecl end

"""
    abstract type AbstractCXXDestructorDecl <: AbstractCXXMethodDecl
Supertype for `CXXDestructorDecl`s.
"""
abstract type AbstractCXXDestructorDecl <: AbstractCXXMethodDecl end

"""
    abstract type AbstractCXXConversionDecl <: AbstractCXXMethodDecl
Supertype for `CXXConversionDecl`s.
"""
abstract type AbstractCXXConversionDecl <: AbstractCXXMethodDecl end

"""
    abstract type AbstractLinkageSpecDecl <: AbstractDecl
Supertype for `LinkageSpecDecl`s.
"""
abstract type AbstractLinkageSpecDecl <: AbstractDecl end

"""
    abstract type AbstractUsingDirectiveDecl <: AbstractNamedDecl
Supertype for `UsingDirectiveDecl`s.
"""
abstract type AbstractUsingDirectiveDecl <: AbstractNamedDecl end

"""
    abstract type AbstractNamespaceAliasDecl <: AbstractNamedDecl
Supertype for `NamespaceAliasDecl`s.
"""
abstract type AbstractNamespaceAliasDecl <: AbstractNamedDecl end

"""
    abstract type AbstractLifetimeExtendedTemporaryDecl <: AbstractDecl
Supertype for `LifetimeExtendedTemporaryDecl`s.
"""
abstract type AbstractLifetimeExtendedTemporaryDecl <: AbstractDecl end

"""
    abstract type AbstractUsingShadowDecl <: AbstractNamedDecl
Supertype for `UsingShadowDecl`s.
"""
abstract type AbstractUsingShadowDecl <: AbstractNamedDecl end

"""
    abstract type AbstractConstructorUsingShadowDecl <: AbstractNamedDecl
Supertype for `ConstructorUsingShadowDecl`s.
"""
abstract type AbstractConstructorUsingShadowDecl <: AbstractNamedDecl end

"""
    abstract type AbstractBaseUsingDecl <: AbstractNamedDecl
Supertype for `BaseUsingDecl`s.
"""
abstract type AbstractBaseUsingDecl <: AbstractNamedDecl end

"""
    abstract type AbstractUsingDecl <: AbstractBaseUsingDecl
Supertype for `UsingDecl`s.
"""
abstract type AbstractUsingDecl <: AbstractBaseUsingDecl end

"""
    abstract type AbstractUsingPackDecl <: AbstractNamedDecl
Supertype for `UsingPackDecl`s.
"""
abstract type AbstractUsingPackDecl <: AbstractNamedDecl end

"""
    abstract type AbstractUnresolvedUsingValueDecl <: AbstractValueDecl
Supertype for `UnresolvedUsingValueDecl`s.
"""
abstract type AbstractUnresolvedUsingValueDecl <: AbstractValueDecl end

"""
    abstract type AbstractUnresolvedUsingTypenameDecl <: AbstractTypeDecl
Supertype for `UnresolvedUsingTypenameDecl`s.
"""
abstract type AbstractUnresolvedUsingTypenameDecl <: AbstractTypeDecl end

"""
    abstract type AbstractStaticAssertDecl <: AbstractDecl
Supertype for `StaticAssertDecl`s.
"""
abstract type AbstractStaticAssertDecl <: AbstractDecl end

"""
    abstract type AbstractBindingDecl <: AbstractValueDecl
Supertype for `BindingDecl`s.
"""
abstract type AbstractBindingDecl <: AbstractValueDecl end

"""
    abstract type AbstractDecompositionDecl <: AbstractVarDecl
Supertype for `DecompositionDecl`s.
"""
abstract type AbstractDecompositionDecl <: AbstractVarDecl end

"""
    abstract type AbstractMSPropertyDecl <: AbstractDeclaratorDecl
Supertype for `MSPropertyDecl`s.
"""
abstract type AbstractMSPropertyDecl <: AbstractDeclaratorDecl end

"""
    abstract type AbstractMSGuidDecl <: AbstractValueDecl
Supertype for `MSGuidDecl`s.
"""
abstract type AbstractMSGuidDecl <: AbstractValueDecl end

# DeclGroup
"""
    abstract type AbstractDeclGroupRef <: Any
Supertype for `DeclGroupRef`s.
"""
abstract type AbstractDeclGroupRef end

# DeclTemplate
"""
    abstract type AbstractTemplateDecl <: AbstractNamedDecl
Supertype for `TemplateDecl`s.
"""
abstract type AbstractTemplateDecl <: AbstractNamedDecl end

"""
    abstract type AbstractRedeclarableTemplateDecl <: AbstractTemplateDecl
Supertype for `RedeclarableTemplateDecl`s.
"""
abstract type AbstractRedeclarableTemplateDecl <: AbstractTemplateDecl end

"""
    abstract type AbstractClassTemplateSpecializationDecl <: AbstractCXXRecordDecl
Supertype for `ClassTemplateSpecializationDecl`s.
"""
abstract type AbstractClassTemplateSpecializationDecl <: AbstractCXXRecordDecl end

"""
    abstract type AbstractClassTemplateDecl <: AbstractRedeclarableTemplateDecl
Supertype for `ClassTemplateDecl`s.
"""
abstract type AbstractClassTemplateDecl <: AbstractRedeclarableTemplateDecl end

"""
    abstract type AbstractVarTemplateSpecializationDecl <: AbstractVarDecl
Supertype for `VarTemplateSpecializationDecl`s.
"""
abstract type AbstractVarTemplateSpecializationDecl <: AbstractVarDecl end

# Stmt
"""
    abstract type AbstractStmt <: Any
Supertype for `Stmt`s.
"""
abstract type AbstractStmt end

"""
    abstract type AbstractSwitchCase <: AbstractStmt
Supertype for `SwitchCase`s.
"""
abstract type AbstractSwitchCase <: AbstractStmt end

"""
    abstract type AbstractValueStmt <: AbstractStmt
Supertype for `ValueStmt`s.
"""
abstract type AbstractValueStmt <: AbstractStmt end

"""
    abstract type AbstractAsmStmt <: AbstractStmt
Supertype for `AsmStmt`s.
"""
abstract type AbstractAsmStmt <: AbstractStmt end

# Expr
"""
    abstract type AbstractExpr <: AbstractValueStmt
Supertype for `Expr`s.
"""
abstract type AbstractExpr <: AbstractValueStmt end

"""
    abstract type AbstractCastExpr <: AbstractExpr
Supertype for `CastExpr`s.
"""
abstract type AbstractCastExpr <: AbstractExpr end

"""
    abstract type AbstractExplicitCastExpr <: AbstractCastExpr
Supertype for `ExplicitCastExpr`s.
"""
abstract type AbstractExplicitCastExpr <: AbstractCastExpr end

"""
    abstract type AbstractBinaryOperator <: AbstractExpr
Supertype for `BinaryOperator`s.
"""
abstract type AbstractBinaryOperator <: AbstractExpr end

"""
    abstract type AbstractConditionalOperator <: AbstractExpr
Supertype for `AbstractConditionalOperator`s.
"""
abstract type AbstractConditionalOperator <: AbstractExpr end

# ExprCXX
"""
    abstract type AbstractCallExpr <: AbstractExpr
Supertype for `CallExpr`s.
"""
abstract type AbstractCallExpr <: AbstractExpr end

"""
    abstract type AbstractCXXNamedCastExpr <: AbstractExplicitCastExpr
Supertype for `CallExpr`s.
"""
abstract type AbstractCXXNamedCastExpr <: AbstractExplicitCastExpr end

"""
    abstract type AbstractCXXConstructExpr <: AbstractExpr
Supertype for `CXXConstructExpr`s.
"""
abstract type AbstractCXXConstructExpr <: AbstractExpr end

"""
    abstract type AbstractOverloadExpr <: AbstractExpr
Supertype for `OverloadExpr`s.
"""
abstract type AbstractOverloadExpr <: AbstractExpr end

"""
    abstract type AbstractCoroutineSuspendExpr <: AbstractExpr
Supertype for `CoroutineSuspendExpr`s.
"""
abstract type AbstractCoroutineSuspendExpr <: AbstractExpr end

# Type
"""
    abstract type AbstractType <: AbstractClangType end
Supertype for `clang::Type`s.

1. `CXType_` is an opaque pointer for `clang::Type *`.
2. `get_type_ptr`/`getTypePtr` is for converting a `QualType` to a `CXType_`. (qualifiers are removed)
3. `get_qual_type`/`getCanonicalTypeInternal` is for converting a `CXType_` to a `QualType`.
"""
abstract type AbstractType <: AbstractClangType end

"""
    abstract type AbstractQualType <: AbstractClangType
Supertype for `clang::QualType`s.
"""
abstract type AbstractQualType <: AbstractClangType end

"""
    abstract type AbstractBuiltinType <: AbstractType
Supertype for Clang builtin types.
"""
abstract type AbstractBuiltinType <: AbstractType end

"""
    abstract type AbstractComplexType <: AbstractType
Supertype for `ComplexType`s.
"""
abstract type AbstractComplexType <: AbstractType end

"""
    abstract type AbstractPointerType <: AbstractType
Supertype for `PointerType`s.
"""
abstract type AbstractPointerType <: AbstractType end

"""
    abstract type AbstractReferenceType <: AbstractType
Supertype for `ReferenceType`s.
"""
abstract type AbstractReferenceType <: AbstractType end

"""
    abstract type AbstractLValueReferenceType <: AbstractReferenceType
Supertype for `LValueReferenceType`s.
"""
abstract type AbstractLValueReferenceType <: AbstractReferenceType end

"""
    abstract type AbstractRValueReferenceType <: AbstractReferenceType
Supertype for `RValueReferenceType`s.
"""
abstract type AbstractRValueReferenceType <: AbstractReferenceType end

"""
    abstract type AbstractMemberPointerType <: AbstractType
Supertype for `MemberPointerType`s.
"""
abstract type AbstractMemberPointerType <: AbstractType end

"""
    abstract type AbstractArrayType <: AbstractType
Supertype for `ArrayType`s.
"""
abstract type AbstractArrayType <: AbstractType end

"""
    abstract type AbstractConstantArrayType <: AbstractArrayType
Supertype for `ConstantArrayType`s.
"""
abstract type AbstractConstantArrayType <: AbstractArrayType end

"""
    abstract type AbstractIncompleteArrayType <: AbstractArrayType
Supertype for `IncompleteArrayType`s.
"""
abstract type AbstractIncompleteArrayType <: AbstractArrayType end

"""
    abstract type AbstractVariableArrayType <: AbstractArrayType
Supertype for `VariableArrayType`s.
"""
abstract type AbstractVariableArrayType <: AbstractArrayType end

"""
    abstract type AbstractDependentSizedArrayType <: AbstractArrayType
Supertype for `DependentSizedArrayType`s.
"""
abstract type AbstractDependentSizedArrayType <: AbstractArrayType end

"""
    abstract type AbstractFunctionType <: AbstractType
Supertype for `FunctionType`s.
"""
abstract type AbstractFunctionType <: AbstractType end

"""
    abstract type AbstractFunctionNoProtoType <: AbstractFunctionType
Supertype for `FunctionNoProtoType`s.
"""
abstract type AbstractFunctionNoProtoType <: AbstractFunctionType end

"""
    abstract type AbstractFunctionProtoType <: AbstractFunctionType
Supertype for `FunctionProtoType`s.
"""
abstract type AbstractFunctionProtoType <: AbstractFunctionType end

"""
    abstract type AbstractUnresolvedUsingType <: AbstractType
Supertype for `UnresolvedUsingType`s.
"""
abstract type AbstractUnresolvedUsingType <: AbstractType end

"""
    abstract type AbstractUsingType <: AbstractType
Supertype for `UsingType`s.
"""
abstract type AbstractUsingType <: AbstractType end

"""
    abstract type AbstractTypedefType <: AbstractType
Supertype for `TypedefType`s.
"""
abstract type AbstractTypedefType <: AbstractType end

"""
    abstract type AbstractTagType <: AbstractType
Supertype for `TagType`s.
"""
abstract type AbstractTagType <: AbstractType end

"""
    abstract type AbstractRecordType <: AbstractTagType
Supertype for `RecordType`s.
"""
abstract type AbstractRecordType <: AbstractTagType end

"""
    abstract type AbstractEnumType <: AbstractTagType
Supertype for `EnumType`s.
"""
abstract type AbstractEnumType <: AbstractTagType end

"""
    abstract type AbstractTemplateTypeParmType <: AbstractType
Supertype for `TemplateTypeParmType`s.
"""
abstract type AbstractTemplateTypeParmType <: AbstractType end

"""
    abstract type AbstractSubstTemplateTypeParmType <: AbstractType
Supertype for `SubstTemplateTypeParmType`s.
"""
abstract type AbstractSubstTemplateTypeParmType <: AbstractType end

"""
    abstract type AbstractSubstTemplateTypeParmPackType <: AbstractType
Supertype for `SubstTemplateTypeParmPackType`s.
"""
abstract type AbstractSubstTemplateTypeParmPackType <: AbstractType end

"""
    abstract type AbstractTemplateSpecializationType <: AbstractType
Supertype for `TemplateSpecializationType`s.
"""
abstract type AbstractTemplateSpecializationType <: AbstractType end

"""
    abstract type AbstractTypeWithKeyword <: AbstractType
Supertype for `TypeWithKeyword`s.
"""
abstract type AbstractTypeWithKeyword <: AbstractType end

"""
    abstract type AbstractElaboratedType <: AbstractTypeWithKeyword
Supertype for `ElaboratedType`s.
"""
abstract type AbstractElaboratedType <: AbstractTypeWithKeyword end

"""
    abstract type AbstractDependentNameType <: AbstractTypeWithKeyword
Supertype for `DependentNameType`s.
"""
abstract type AbstractDependentNameType <: AbstractTypeWithKeyword end

"""
    abstract type AbstractDependentTemplateSpecializationType <: AbstractTypeWithKeyword
Supertype for `DependentTemplateSpecializationType`s.
"""
abstract type AbstractDependentTemplateSpecializationType <: AbstractTypeWithKeyword end

# Frontend
# CompilerInstance
"""
    abstract type AbstractCompilerInstance <: Any
Supertype for `CompilerInstance`s.
"""
abstract type AbstractCompilerInstance end

# FrontendAction
"""
    abstract type AbstractFrontendAction <: Any
Supertype for `FrontendAction`s.
"""
abstract type AbstractFrontendAction end
