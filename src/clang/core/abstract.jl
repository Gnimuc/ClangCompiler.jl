# Decl
"""
    abstract type AbstractDecl <: Any
Supertype for `Decl`s.
"""
abstract type AbstractDecl end

"""
    abstract type AbstractNamedDecl <: AbstractDecl
Supertype for `NamedDecl`s.
"""
abstract type AbstractNamedDecl <: AbstractDecl end

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
    abstract type AbstractTagDecl <: AbstractTypeDecl
Supertype for `TagDecl`s.
"""
abstract type AbstractTagDecl <: AbstractTypeDecl end

"""
    abstract type AbstractRecordDecl <: AbstractTagDecl
Supertype for `RecordDecl`s.
"""
abstract type AbstractRecordDecl <: AbstractTagDecl end

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

# FrontendAction
"""
    abstract type AbstractFrontendAction <: Any
Supertype for `FrontendAction`s.
"""
abstract type AbstractFrontendAction end
