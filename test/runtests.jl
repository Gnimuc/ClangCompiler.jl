using ClangCompiler
using Test

# The test tree mirrors the three levels of the Julia API:
#   - whole-package / meta and high-level API (outside clang/)  → test/*.jl
#   - middle-level helpers (src/clang/*.jl)                     → test/clang/*.jl
#   - low-level thin wrappers (src/clang/api/**)                → test/clang/api/**

# meta + high-level
include("lint.jl")
include("abi.jl")
include("types.jl")
include("parse.jl")
include("lookup.jl")
include("platform.jl")
include("acceptance.jl")

# middle-level (src/clang/*.jl)
include("clang/type.jl")
include("clang/stmt.jl")
include("clang/decl.jl")
include("clang/attr.jl")
include("clang/helpers.jl")
include("clang/diagnostic.jl")
include("clang/source.jl")
include("clang/status.jl")
include("clang/instance.jl")

# low-level wrappers (src/clang/api/**)
include("clang/api/AST/APValue.jl")
include("clang/api/AST/ASTConsumer.jl")
include("clang/api/AST/ASTContext.jl")
include("clang/api/AST/Attr.jl")
include("clang/api/AST/Decl.jl")
include("clang/api/AST/DeclCXX.jl")
include("clang/api/AST/DeclTemplate.jl")
include("clang/api/AST/DeclarationName.jl")
include("clang/api/AST/Expr.jl")
include("clang/api/AST/ExprCXX.jl")
include("clang/api/AST/Mangle.jl")
include("clang/api/AST/NestedNameSpecifier.jl")
include("clang/api/AST/RecordLayout.jl")
include("clang/api/AST/Stmt.jl")
include("clang/api/AST/StmtOpenMP.jl")
include("clang/api/AST/TemplateName.jl")
include("clang/api/AST/Type.jl")
include("clang/api/AST/TypeLoc.jl")
include("clang/api/Analysis/CFG.jl")
include("clang/api/Basic/Diagnostic.jl")
include("clang/api/Basic/FileManager.jl")
include("clang/api/Basic/IdentifierTable.jl")
include("clang/api/Basic/SourceManager.jl")
include("clang/api/Basic/TargetInfo.jl")
include("clang/api/CodeGen/CodeGenAction.jl")
include("clang/api/CodeGen/ModuleBuilder.jl")
include("clang/api/Driver/Driver.jl")
include("clang/api/Frontend/CompilerInstance.jl")
include("clang/api/Frontend/CompilerInvocation.jl")
include("clang/api/Interpreter/Interpreter.jl")
include("clang/api/Interpreter/Value.jl")
include("clang/api/Lex/HeaderSearch.jl")
include("clang/api/Lex/Lexer.jl")
include("clang/api/Lex/MacroInfo.jl")
include("clang/api/Lex/Preprocessor.jl")

# execution last (JIT is the slowest)
include("execution.jl")

# include("llvm/pointer_from_objref.jl")
