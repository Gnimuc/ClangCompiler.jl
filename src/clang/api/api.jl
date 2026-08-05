# the file hierarchy is exactly the same as Clang, please refer to Clang's src for docs.
# AST
include("AST/APValue.jl")
include("AST/Comment.jl")
include("AST/Attr.jl")
include("AST/ASTConsumer.jl")
include("AST/ASTContext.jl")
include("AST/Mangle.jl")
include("AST/Decl.jl")
include("AST/DeclarationName.jl")
include("AST/DeclBase.jl")
include("AST/DeclCXX.jl")
include("AST/DeclGroup.jl")
include("AST/DeclTemplate.jl")
include("AST/NestedNameSpecifier.jl")
include("AST/ParentMapContext.jl")
include("AST/PrettyPrinter.jl")
include("AST/RecordLayout.jl")
include("AST/TemplateBase.jl")
include("AST/TemplateName.jl")
include("AST/Type.jl")
include("AST/TypeLoc.jl")
include("AST/Expr.jl")
include("AST/ExprCXX.jl")
include("AST/Stmt.jl")
include("AST/StmtOpenMP.jl")
include("AST/StmtCXX.jl")

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
include("Basic/Module.jl")
include("Basic/TokenKinds.jl")
include("Basic/IdentifierTable.jl")
include("Basic/LangOptions.jl")
include("Basic/OperatorKinds.jl")
include("Basic/SourceLocation.jl")
include("Basic/SourceManager.jl")
include("Basic/TargetInfo.jl")
include("Basic/TargetOptions.jl")

# CodeGen
include("CodeGen/CodeGenABITypes.jl")
include("CodeGen/CodeGenAction.jl")
include("CodeGen/ModuleBuilder.jl")

# Driver
include("Driver/Driver.jl")
include("Driver/Compilation.jl")
include("Driver/ToolChain.jl")
# Frontend
include("Frontend/ASTUnit.jl")
include("Frontend/CompilerInstance.jl")
include("Frontend/CompilerInvocation.jl")
include("Frontend/FrontendAction.jl")
include("Frontend/FrontendOptions.jl")
include("Frontend/TextDiagnosticPrinter.jl")

# Interpreter
include("Interpreter/Interpreter.jl")
include("Interpreter/Value.jl")

# Lex
include("Lex/DirectoryLookup.jl")
include("Lex/HeaderSearch.jl")
include("Lex/HeaderSearchOptions.jl")
include("Lex/Lexer.jl")
include("Lex/MacroInfo.jl")
include("Lex/Preprocessor.jl")
include("Lex/PreprocessingRecord.jl")
include("Lex/PreprocessorOptions.jl")
include("Lex/Token.jl")

# Parse
include("Parse/ParseAST.jl")
include("Parse/Parser.jl")

# Index
include("Index/USRGeneration.jl")

# Rewrite
include("Rewrite/Rewriter.jl")

# Sema
include("Sema/DeclSpec.jl")
include("Sema/Lookup.jl")
include("Sema/Scope.jl")
include("Sema/Sema.jl")
include("Sema/Overload.jl")
include("Sema/Template.jl")
include("Sema/TemplateDeduction.jl")
