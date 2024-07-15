IncrementalCompilerBuilder() = IncrementalCompilerBuilder(clang_IncrementalCompilerBuilder_create())

dispose(x::IncrementalCompilerBuilder) = clang_IncrementalCompilerBuilder_dispose(x)

function SetCompilerArgs(x::AbstractIncrementalCompilerBuilder, args::AbstractVector{<:String})
    @check_ptrs x
    return clang_IncrementalCompilerBuilder_SetCompilerArgs(x, args, length(args))
end

function CreateCpp(x::AbstractIncrementalCompilerBuilder)
    @check_ptrs x
    return CompilerInstance(clang_IncrementalCompilerBuilder_CreateCpp(x))
end

function Interpreter(x::AbstractCompilerInstance)
    @check_ptrs x
    return Interpreter(clang_Interpreter_create(x))
end

function createWithCUDA(ci::AbstractCompilerInstance, dci::AbstractCompilerInstance)
    @check_ptrs ci dci
    return Interpreter(clang_Interpreter_createWithCUDA(ci, dci))
end

dispose(x::Interpreter) = clang_Interpreter_dispose(x)

function getCompilerInstance(x::AbstractInterpreter)
    @check_ptrs x
    return CompilerInstance(clang_Interpreter_getCompilerInstance(x))
end

function getExecuteEngine(x::AbstractInterpreter)
    @check_ptrs x
    return clang_Interpreter_getExecutionEngine(x)
end

function undo(x::AbstractInterpreter)
    @check_ptrs x
    return clang_Interpreter_Undo(x)
end

function getSymbolAddress(x::AbstractInterpreter, name::AbstractString)
    @check_ptrs x
    return clang_Interpreter_getSymbolAddress(x, name)
end

function getSymbolAddressFromLinkerName(x::AbstractInterpreter, name::AbstractString)
    @check_ptrs x
    return clang_Interpreter_getSymbolAddressFromLinkerName(x, name)
end

function getCodeGen(x::AbstractInterpreter)
    @check_ptrs x
    return CodeGenerator(clang_Interpreter_getCodeGen(x))
end

function getParser(x::AbstractInterpreter)
    @check_ptrs x
    return Parser(clang_Interpreter_getParser(x))
end
