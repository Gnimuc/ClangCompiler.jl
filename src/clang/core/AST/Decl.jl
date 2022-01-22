"""
    struct TranslationUnitDecl <: AbstractDecl
Hold a pointer to a `clang::TranslationUnitDecl` object.
"""
struct TranslationUnitDecl <: AbstractDecl
    ptr::CXTranslationUnitDecl
end

Base.unsafe_convert(::Type{CXTranslationUnitDecl}, x::TranslationUnitDecl) = x.ptr
Base.cconvert(::Type{CXTranslationUnitDecl}, x::TranslationUnitDecl) = x

"""
    struct PragmaCommentDecl <: AbstractDecl
Hold a pointer to a `clang::PragmaCommentDecl` object.
"""
struct PragmaCommentDecl <: AbstractDecl
    ptr::CXPragmaCommentDecl
end

Base.unsafe_convert(::Type{CXPragmaCommentDecl}, x::PragmaCommentDecl) = x.ptr
Base.cconvert(::Type{CXPragmaCommentDecl}, x::PragmaCommentDecl) = x

"""
    struct PragmaDetectMismatchDecl <: AbstractDecl
Hold a pointer to a `clang::PragmaDetectMismatchDecl` object.
"""
struct PragmaDetectMismatchDecl <: AbstractDecl
    ptr::CXPragmaDetectMismatchDecl
end

Base.unsafe_convert(::Type{CXPragmaDetectMismatchDecl}, x::PragmaDetectMismatchDecl) = x.ptr
Base.cconvert(::Type{CXPragmaDetectMismatchDecl}, x::PragmaDetectMismatchDecl) = x

"""
    struct ExternCContextDecl <: AbstractDecl
Hold a pointer to a `clang::ExternCContextDecl` object.
"""
struct ExternCContextDecl <: AbstractDecl
    ptr::CXExternCContextDecl
end

Base.unsafe_convert(::Type{CXExternCContextDecl}, x::ExternCContextDecl) = x.ptr
Base.cconvert(::Type{CXExternCContextDecl}, x::ExternCContextDecl) = x

"""
    abstract type AbstractNamedDecl <: AbstractDecl
Supertype for `NamedDecl`s.
"""
abstract type AbstractNamedDecl <: AbstractDecl end

"""
    struct NamedDecl <: AbstractNamedDecl
Hold a pointer to a `clang::NamedDecl` object.
"""
struct NamedDecl <: AbstractNamedDecl
    ptr::CXNamedDecl
end

Base.unsafe_convert(::Type{CXNamedDecl}, x::NamedDecl) = x.ptr
Base.cconvert(::Type{CXNamedDecl}, x::NamedDecl) = x

"""
    struct LabelDecl <: AbstractNamedDecl
Hold a pointer to a `clang::LabelDecl` object.
"""
struct LabelDecl <: AbstractNamedDecl
    ptr::CXLabelDecl
end

Base.unsafe_convert(::Type{CXLabelDecl}, x::LabelDecl) = x.ptr
Base.cconvert(::Type{CXLabelDecl}, x::LabelDecl) = x

"""
    struct NamespaceDecl <: AbstractNamedDecl
Hold a pointer to a `clang::NamespaceDecl` object.
"""
struct NamespaceDecl <: AbstractNamedDecl
    ptr::CXNamespaceDecl
end

Base.unsafe_convert(::Type{CXNamespaceDecl}, x::NamespaceDecl) = x.ptr
Base.cconvert(::Type{CXNamespaceDecl}, x::NamespaceDecl) = x

"""
    abstract type AbstractValueDecl <: AbstractNamedDecl
Supertype for `ValueDecl`s.
"""
abstract type AbstractValueDecl <: AbstractNamedDecl end

"""
    struct ValueDecl <: AbstractValueDecl
Hold a pointer to a `clang::ValueDecl` object.
"""
struct ValueDecl <: AbstractValueDecl
    ptr::CXValueDecl
end

Base.unsafe_convert(::Type{CXValueDecl}, x::ValueDecl) = x.ptr
Base.cconvert(::Type{CXValueDecl}, x::ValueDecl) = x

"""
    abstract type AbstractDeclaratorDecl <: AbstractValueDecl
Supertype for `DeclaratorDecl`s.
"""
abstract type AbstractDeclaratorDecl <: AbstractValueDecl end

"""
    struct DeclaratorDecl <: AbstractDeclaratorDecl
Hold a pointer to a `clang::DeclaratorDecl` object.
"""
struct DeclaratorDecl <: AbstractDeclaratorDecl
    ptr::CXDeclaratorDecl
end

Base.unsafe_convert(::Type{CXDeclaratorDecl}, x::DeclaratorDecl) = x.ptr
Base.cconvert(::Type{CXDeclaratorDecl}, x::DeclaratorDecl) = x

"""
    abstract type AbstractVarDecl <: AbstractDeclaratorDecl
Supertype for `VarDecl`s.
"""
abstract type AbstractVarDecl <: AbstractDeclaratorDecl end

"""
    struct VarDecl <: AbstractVarDecl
Hold a pointer to a `clang::VarDecl` object.
"""
struct VarDecl <: AbstractVarDecl
    ptr::CXVarDecl
end

Base.unsafe_convert(::Type{CXVarDecl}, x::VarDecl) = x.ptr
Base.cconvert(::Type{CXVarDecl}, x::VarDecl) = x

"""
    struct ImplicitParamDecl <: AbstractVarDecl
Hold a pointer to a `clang::ImplicitParamDecl` object.
"""
struct ImplicitParamDecl <: AbstractVarDecl
    ptr::CXImplicitParamDecl
end

Base.unsafe_convert(::Type{CXImplicitParamDecl}, x::ImplicitParamDecl) = x.ptr
Base.cconvert(::Type{CXImplicitParamDecl}, x::ImplicitParamDecl) = x

"""
    struct ParmVarDecl <: AbstractVarDecl
Hold a pointer to a `clang::ParmVarDecl` object.
"""
struct ParmVarDecl <: AbstractVarDecl
    ptr::CXParmVarDecl
end

Base.unsafe_convert(::Type{CXParmVarDecl}, x::ParmVarDecl) = x.ptr
Base.cconvert(::Type{CXParmVarDecl}, x::ParmVarDecl) = x

"""
    abstract type AbstractFunctionDecl <: AbstractDeclaratorDecl
Supertype for `FunctionDecl`s.
"""
abstract type AbstractFunctionDecl <: AbstractDeclaratorDecl end

"""
    struct FunctionDecl <: AbstractFunctionDecl
Hold a pointer to a `clang::FunctionDecl` object.
"""
struct FunctionDecl <: AbstractFunctionDecl
    ptr::CXFunctionDecl
end

Base.unsafe_convert(::Type{CXFunctionDecl}, x::FunctionDecl) = x.ptr
Base.cconvert(::Type{CXFunctionDecl}, x::FunctionDecl) = x

"""
    abstract type AbstractFieldDecl <: AbstractDeclaratorDecl
Supertype for `FieldDecl`s.
"""
abstract type AbstractFieldDecl <: AbstractDeclaratorDecl end

"""
    struct FieldDecl <: AbstractFieldDecl
Hold a pointer to a `clang::FieldDecl` object.
"""
struct FieldDecl <: AbstractFieldDecl
    ptr::CXFieldDecl
end

Base.unsafe_convert(::Type{CXFieldDecl}, x::FieldDecl) = x.ptr
Base.cconvert(::Type{CXFieldDecl}, x::FieldDecl) = x

"""
    struct EnumConstantDecl <: AbstractValueDecl
Hold a pointer to a `clang::EnumConstantDecl` object.
"""
struct EnumConstantDecl <: AbstractValueDecl
    ptr::CXEnumConstantDecl
end

Base.unsafe_convert(::Type{CXEnumConstantDecl}, x::EnumConstantDecl) = x.ptr
Base.cconvert(::Type{CXEnumConstantDecl}, x::EnumConstantDecl) = x

"""
    struct IndirectFieldDecl <: AbstractValueDecl
Hold a pointer to a `clang::IndirectFieldDecl` object.
"""
struct IndirectFieldDecl <: AbstractValueDecl
    ptr::CXIndirectFieldDecl
end

Base.unsafe_convert(::Type{CXIndirectFieldDecl}, x::IndirectFieldDecl) = x.ptr
Base.cconvert(::Type{CXIndirectFieldDecl}, x::IndirectFieldDecl) = x

"""
    abstract type AbstractTypeDecl <: AbstractNamedDecl
Supertype for `TypeDecl`s.
"""
abstract type AbstractTypeDecl <: AbstractNamedDecl end

"""
    struct TypeDecl <: AbstractTypeDecl
Hold a pointer to a `clang::TypeDecl` object.
"""
struct TypeDecl <: AbstractTypeDecl
    ptr::CXTypeDecl
end

Base.unsafe_convert(::Type{CXTypeDecl}, x::TypeDecl) = x.ptr
Base.cconvert(::Type{CXTypeDecl}, x::TypeDecl) = x

"""
    abstract type AbstractTypedefNameDecl <: AbstractTypeDecl
Supertype for `TypedefNameDecl`s.
"""
abstract type AbstractTypedefNameDecl <: AbstractTypeDecl end

"""
    struct TypedefNameDecl <: AbstractTypedefNameDecl
Hold a pointer to a `clang::TypedefNameDecl` object.
"""
struct TypedefNameDecl <: AbstractTypedefNameDecl
    ptr::CXTypedefNameDecl
end

Base.unsafe_convert(::Type{CXTypedefNameDecl}, x::TypedefNameDecl) = x.ptr
Base.cconvert(::Type{CXTypedefNameDecl}, x::TypedefNameDecl) = x

"""
    struct TypedefDecl <: AbstractTypedefNameDecl
Hold a pointer to a `clang::TypedefDecl` object.
"""
struct TypedefDecl <: AbstractTypedefNameDecl
    ptr::CXTypedefDecl
end

Base.unsafe_convert(::Type{CXTypedefDecl}, x::TypedefDecl) = x.ptr
Base.cconvert(::Type{CXTypedefDecl}, x::TypedefDecl) = x

"""
    struct TypeAliasDecl <: AbstractTypedefNameDecl
Hold a pointer to a `clang::TypeAliasDecl` object.
"""
struct TypeAliasDecl <: AbstractTypedefNameDecl
    ptr::CXTypeAliasDecl
end

Base.unsafe_convert(::Type{CXTypeAliasDecl}, x::TypeAliasDecl) = x.ptr
Base.cconvert(::Type{CXTypeAliasDecl}, x::TypeAliasDecl) = x

"""
    abstract type AbstractTagDecl <: AbstractTypeDecl
Supertype for `TagDecl`s.
"""
abstract type AbstractTagDecl <: AbstractTypeDecl end

"""
    struct TagDecl <: AbstractTagDecl
Hold a pointer to a `clang::TagDecl` object.
"""
struct TagDecl <: AbstractTagDecl
    ptr::CXTagDecl
end

Base.unsafe_convert(::Type{CXTagDecl}, x::TagDecl) = x.ptr
Base.cconvert(::Type{CXTagDecl}, x::TagDecl) = x

"""
    struct EnumDecl <: AbstractTagDecl
Hold a pointer to a `clang::EnumDecl` object.
"""
struct EnumDecl <: AbstractTagDecl
    ptr::CXEnumDecl
end

Base.unsafe_convert(::Type{CXEnumDecl}, x::EnumDecl) = x.ptr
Base.cconvert(::Type{CXEnumDecl}, x::EnumDecl) = x

"""
    abstract type AbstractRecordDecl <: AbstractTagDecl
Supertype for `RecordDecl`s.
"""
abstract type AbstractRecordDecl <: AbstractTagDecl end

"""
    struct RecordDecl <: AbstractRecordDecl
Hold a pointer to a `clang::RecordDecl` object.
"""
struct RecordDecl <: AbstractRecordDecl
    ptr::CXRecordDecl
end

Base.unsafe_convert(::Type{CXRecordDecl}, x::RecordDecl) = x.ptr
Base.cconvert(::Type{CXRecordDecl}, x::RecordDecl) = x

"""
    struct FileScopeAsmDecl <: AbstractDecl
Hold a pointer to a `clang::FileScopeAsmDecl` object.
"""
struct FileScopeAsmDecl <: AbstractDecl
    ptr::CXFileScopeAsmDecl
end

Base.unsafe_convert(::Type{CXFileScopeAsmDecl}, x::FileScopeAsmDecl) = x.ptr
Base.cconvert(::Type{CXFileScopeAsmDecl}, x::FileScopeAsmDecl) = x

"""
    struct BlockDecl <: AbstractDecl
Hold a pointer to a `clang::BlockDecl` object.
"""
struct BlockDecl <: AbstractDecl
    ptr::CXBlockDecl
end

Base.unsafe_convert(::Type{CXBlockDecl}, x::BlockDecl) = x.ptr
Base.cconvert(::Type{CXBlockDecl}, x::BlockDecl) = x

"""
    struct CapturedDecl <: AbstractDecl
Hold a pointer to a `clang::CapturedDecl` object.
"""
struct CapturedDecl <: AbstractDecl
    ptr::CXCapturedDecl
end

Base.unsafe_convert(::Type{CXCapturedDecl}, x::CapturedDecl) = x.ptr
Base.cconvert(::Type{CXCapturedDecl}, x::CapturedDecl) = x

"""
    struct ImportDecl <: AbstractDecl
Hold a pointer to a `clang::ImportDecl` object.
"""
struct ImportDecl <: AbstractDecl
    ptr::CXImportDecl
end

Base.unsafe_convert(::Type{CXImportDecl}, x::ImportDecl) = x.ptr
Base.cconvert(::Type{CXImportDecl}, x::ImportDecl) = x

"""
    struct ExportDecl <: AbstractDecl
Hold a pointer to a `clang::ExportDecl` object.
"""
struct ExportDecl <: AbstractDecl
    ptr::CXExportDecl
end

Base.unsafe_convert(::Type{CXExportDecl}, x::ExportDecl) = x.ptr
Base.cconvert(::Type{CXExportDecl}, x::ExportDecl) = x

"""
    struct EmptyDecl <: AbstractDecl
Hold a pointer to a `clang::EmptyDecl` object.
"""
struct EmptyDecl <: AbstractDecl
    ptr::CXEmptyDecl
end

Base.unsafe_convert(::Type{CXEmptyDecl}, x::EmptyDecl) = x.ptr
Base.cconvert(::Type{CXEmptyDecl}, x::EmptyDecl) = x
