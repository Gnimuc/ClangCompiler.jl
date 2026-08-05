# Concrete carriers for the clang::Decl hierarchy — see src/clang/CLAUDE.md.
"""
    struct TranslationUnitDecl <: AbstractTranslationUnitDecl
Hold a pointer to a `clang::TranslationUnitDecl` object.
"""
struct TranslationUnitDecl <: AbstractTranslationUnitDecl
    ptr::CXTranslationUnitDecl
end

"""
    struct PragmaCommentDecl <: AbstractPragmaCommentDecl
Hold a pointer to a `clang::PragmaCommentDecl` object.
"""
struct PragmaCommentDecl <: AbstractPragmaCommentDecl
    ptr::CXPragmaCommentDecl
end

"""
    struct PragmaDetectMismatchDecl <: AbstractPragmaDetectMismatchDecl
Hold a pointer to a `clang::PragmaDetectMismatchDecl` object.
"""
struct PragmaDetectMismatchDecl <: AbstractPragmaDetectMismatchDecl
    ptr::CXPragmaDetectMismatchDecl
end

"""
    struct ExternCContextDecl <: AbstractExternCContextDecl
Hold a pointer to a `clang::ExternCContextDecl` object.
"""
struct ExternCContextDecl <: AbstractExternCContextDecl
    ptr::CXExternCContextDecl
end

"""
    struct NamedDecl <: AbstractNamedDecl
Hold a pointer to a `clang::NamedDecl` object.
"""
struct NamedDecl <: AbstractNamedDecl
    ptr::CXNamedDecl
end

"""
    struct LabelDecl <: AbstractLabelDecl
Hold a pointer to a `clang::LabelDecl` object.
"""
struct LabelDecl <: AbstractLabelDecl
    ptr::CXLabelDecl
end

"""
    struct NamespaceDecl <: AbstractNamespaceDecl
Hold a pointer to a `clang::NamespaceDecl` object.
"""
struct NamespaceDecl <: AbstractNamespaceDecl
    ptr::CXNamespaceDecl
end

"""
    struct ValueDecl <: AbstractValueDecl
Hold a pointer to a `clang::ValueDecl` object.
"""
struct ValueDecl <: AbstractValueDecl
    ptr::CXValueDecl
end

"""
    struct DeclaratorDecl <: AbstractDeclaratorDecl
Hold a pointer to a `clang::DeclaratorDecl` object.
"""
struct DeclaratorDecl <: AbstractDeclaratorDecl
    ptr::CXDeclaratorDecl
end

"""
    struct EvaluatedStmt
Hold a pointer to a `clang::EvaluatedStmt` object.
"""
struct EvaluatedStmt
    ptr::CXEvaluatedStmt
end

Base.unsafe_convert(::Type{CXEvaluatedStmt}, x::EvaluatedStmt) = x.ptr
Base.cconvert(::Type{CXEvaluatedStmt}, x::EvaluatedStmt) = x

"""
    struct VarDecl <: AbstractVarDecl
Hold a pointer to a `clang::VarDecl` object.
"""
struct VarDecl <: AbstractVarDecl
    ptr::CXVarDecl
end

"""
    struct ImplicitParamDecl <: AbstractImplicitParamDecl
Hold a pointer to a `clang::ImplicitParamDecl` object.
"""
struct ImplicitParamDecl <: AbstractImplicitParamDecl
    ptr::CXImplicitParamDecl
end

"""
    struct ParmVarDecl <: AbstractParmVarDecl
Hold a pointer to a `clang::ParmVarDecl` object.
"""
struct ParmVarDecl <: AbstractParmVarDecl
    ptr::CXParmVarDecl
end

"""
    struct FunctionDecl <: AbstractFunctionDecl
Hold a pointer to a `clang::FunctionDecl` object.
"""
struct FunctionDecl <: AbstractFunctionDecl
    ptr::CXFunctionDecl
end

"""
    struct FieldDecl <: AbstractFieldDecl
Hold a pointer to a `clang::FieldDecl` object.
"""
struct FieldDecl <: AbstractFieldDecl
    ptr::CXFieldDecl
end

"""
    struct EnumConstantDecl <: AbstractEnumConstantDecl
Hold a pointer to a `clang::EnumConstantDecl` object.
"""
struct EnumConstantDecl <: AbstractEnumConstantDecl
    ptr::CXEnumConstantDecl
end

"""
    struct IndirectFieldDecl <: AbstractIndirectFieldDecl
Hold a pointer to a `clang::IndirectFieldDecl` object.
"""
struct IndirectFieldDecl <: AbstractIndirectFieldDecl
    ptr::CXIndirectFieldDecl
end

"""
    struct TypeDecl <: AbstractTypeDecl
Hold a pointer to a `clang::TypeDecl` object.
"""
struct TypeDecl <: AbstractTypeDecl
    ptr::CXTypeDecl
end

"""
    struct TypedefNameDecl <: AbstractTypedefNameDecl
Hold a pointer to a `clang::TypedefNameDecl` object.
"""
struct TypedefNameDecl <: AbstractTypedefNameDecl
    ptr::CXTypedefNameDecl
end

"""
    struct TypedefDecl <: AbstractTypedefDecl
Hold a pointer to a `clang::TypedefDecl` object.
"""
struct TypedefDecl <: AbstractTypedefDecl
    ptr::CXTypedefDecl
end

"""
    struct TypeAliasDecl <: AbstractTypeAliasDecl
Hold a pointer to a `clang::TypeAliasDecl` object.
"""
struct TypeAliasDecl <: AbstractTypeAliasDecl
    ptr::CXTypeAliasDecl
end

"""
    struct TagDecl <: AbstractTagDecl
Hold a pointer to a `clang::TagDecl` object.
"""
struct TagDecl <: AbstractTagDecl
    ptr::CXTagDecl
end

"""
    struct EnumDecl <: AbstractEnumDecl
Hold a pointer to a `clang::EnumDecl` object.
"""
struct EnumDecl <: AbstractEnumDecl
    ptr::CXEnumDecl
end

"""
    struct RecordDecl <: AbstractRecordDecl
Hold a pointer to a `clang::RecordDecl` object.
"""
struct RecordDecl <: AbstractRecordDecl
    ptr::CXRecordDecl
end

"""
    struct FileScopeAsmDecl <: AbstractFileScopeAsmDecl
Hold a pointer to a `clang::FileScopeAsmDecl` object.
"""
struct FileScopeAsmDecl <: AbstractFileScopeAsmDecl
    ptr::CXFileScopeAsmDecl
end

"""
    struct BlockDecl <: AbstractBlockDecl
Hold a pointer to a `clang::BlockDecl` object.
"""
struct BlockDecl <: AbstractBlockDecl
    ptr::CXBlockDecl
end

"""
    struct CapturedDecl <: AbstractCapturedDecl
Hold a pointer to a `clang::CapturedDecl` object.
"""
struct CapturedDecl <: AbstractCapturedDecl
    ptr::CXCapturedDecl
end

"""
    struct ImportDecl <: AbstractImportDecl
Hold a pointer to a `clang::ImportDecl` object.
"""
struct ImportDecl <: AbstractImportDecl
    ptr::CXImportDecl
end

"""
    struct ExportDecl <: AbstractExportDecl
Hold a pointer to a `clang::ExportDecl` object.
"""
struct ExportDecl <: AbstractExportDecl
    ptr::CXExportDecl
end

"""
    struct EmptyDecl <: AbstractEmptyDecl
Hold a pointer to a `clang::EmptyDecl` object.
"""
struct EmptyDecl <: AbstractEmptyDecl
    ptr::CXEmptyDecl
end

"""
    struct TopLevelStmtDecl <: AbstractTopLevelStmtDecl
Hold a pointer to a `clang::TopLevelStmtDecl` object.
"""
struct TopLevelStmtDecl <: AbstractTopLevelStmtDecl
    ptr::CXTopLevelStmtDecl
end

"""
    struct HLSLBufferDecl <: AbstractHLSLBufferDecl
Hold a pointer to a `clang::HLSLBufferDecl` object.
"""
struct HLSLBufferDecl <: AbstractHLSLBufferDecl
    ptr::CXHLSLBufferDecl
end

"""
    abstract type AbstractDefaultedFunctionInfo end
Supertype for `DefaultedFunctionInfo`s.
"""
abstract type AbstractDefaultedFunctionInfo end

"""
    struct DefaultedFunctionInfo <: AbstractDefaultedFunctionInfo
Hold a pointer to a `clang::FunctionDecl::DefaultedFunctionInfo` object.
"""
struct DefaultedFunctionInfo <: AbstractDefaultedFunctionInfo
    ptr::CXFunctionDecl_DefaultedFunctionInfo
end
