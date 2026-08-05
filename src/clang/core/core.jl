# abstract types
"""
    abstract type AbstractClangType <: Any
Supertype for all Clang types.
"""
abstract type AbstractClangType end

struct UnexposedType{T<:AbstractClangType} <: AbstractClangType
    ty::T
end

# the whole abstract-type skeleton (backbone + the subsystem/generated abstract
# files it aggregates); front-loaded before every struct file that subtypes it
include("abstract.jl")

# the file hierarchy is exactly the same as Clang, please refer to Clang's src for docs.
# APINotes
include("APINotes/APINotesOptions.jl")

# AST
include("AST/APValue.jl")
include("AST/Attr.jl")
include("AST/Comment.jl")
include("AST/ASTConsumer.jl")
include("AST/ASTContext.jl")
include("AST/Mangle.jl")
include("AST/Decl.jl")
include("AST/DeclarationName.jl")
include("AST/DeclBase.jl")
include("AST/DeclCXX.jl")
include("AST/DeclGroup.jl")
include("AST/DeclTemplate.jl")
include("AST/Expr.jl")
include("AST/ExprCXX.jl")
include("AST/NestedNameSpecifier.jl")
include("AST/ParentMapContext.jl")
include("AST/PrettyPrinter.jl")
include("AST/RecordLayout.jl")
include("AST/Stmt.jl")
include("AST/StmtCXX.jl")
include("AST/TemplateBase.jl")
include("AST/TemplateName.jl")
include("AST/Type.jl")
include("AST/TypeLoc.jl")
# after the hand-written AST files: fills in every Stmt-hierarchy class they
# don't define, generated from StmtNodes.inc
include("AST/StmtHierarchy.jl")

# Analysis
include("Analysis/CFG.jl")
include("Analysis/ConstructionContext.jl")

# Basic
include("Basic/CodeGenOptions.jl")
include("Basic/Diagnostic.jl")
include("Basic/DiagnosticIDs.jl")
include("Basic/DiagnosticOptions.jl")
include("Basic/FileEntry.jl")
include("Basic/FileManager.jl")
include("Basic/FileSystemOptions.jl")
include("Basic/IdentifierTable.jl")
include("Basic/Module.jl")
include("Basic/LangOptions.jl")
# SourceManager precedes SourceLocation: `FullSourceLoc` is reproduced structurally in Julia and
# stores a borrowed `SourceManager` by value, so the concrete carrier has to exist first. The
# reverse order costs an abstractly-typed field and, with it, inference through every accessor.
include("Basic/SourceManager.jl")
include("Basic/SourceLocation.jl")
include("Basic/TargetInfo.jl")
include("Basic/TargetOptions.jl")

# CodeGen
include("CodeGen/CodeGenAction.jl")
include("CodeGen/CodeGenModule.jl")
include("CodeGen/ModuleBuilder.jl")

# Frontend
include("Frontend/CompilerInstance.jl")
include("Frontend/ASTUnit.jl")
include("Frontend/CompilerInvocation.jl")
include("Frontend/DependencyOutputOptions.jl")
include("Frontend/MigratorOptions.jl")
include("Frontend/PreprocessorOutputOptions.jl")
include("Frontend/FrontendOptions.jl")
include("Frontend/TextDiagnosticPrinter.jl")

# Interpreter
include("Interpreter/Interpreter.jl")
include("Interpreter/Value.jl")

# Lex
include("Lex/DirectoryLookup.jl")
include("Lex/HeaderMap.jl")
include("Lex/HeaderSearch.jl")
include("Lex/HeaderSearchOptions.jl")
include("Lex/Lexer.jl")
include("Lex/MacroInfo.jl")
include("Lex/Preprocessor.jl")
include("Lex/PreprocessorLexer.jl")
include("Lex/PreprocessorOptions.jl")
include("Lex/PreprocessingRecord.jl")
include("Lex/Token.jl")

# Parse
include("Parse/ParseAST.jl")
include("Parse/Parser.jl")

# Rewrite
include("Rewrite/Rewriter.jl")

# StaticAnalyzer
include("StaticAnalyzer/AnalyzerOptions.jl")

# Sema
include("Sema/DeclSpec.jl")
include("Sema/Lookup.jl")
include("Sema/Scope.jl")
include("Sema/Sema.jl")
include("Sema/Overload.jl")
include("Sema/Template.jl")
include("Sema/TemplateDeduction.jl")

# Driver
include("Driver/Driver.jl")
include("Driver/Compilation.jl")
include("Driver/ToolChain.jl")

include("Basic/Builtins.jl")
include("Lex/CodeCompletionHandler.jl")
include("Lex/ExternalPreprocessorSource.jl")
include("Lex/ModuleLoader.jl")
include("Lex/PPCallbacks.jl")

# last, because each entry is keyed on an abstract type and so has to see the whole
# hierarchy: one unsafe_convert/cconvert pair per CX handle, generated from the carriers
# above by gen/handle_converts.jl
include("converts.jl")
# and the one base that is not at offset zero, which marshals through the pivot instead
include("AST/DeclContextUnion.jl")
