function create_interpreter(x::AbstractCompilerInstance)
    @check_ptrs x
	return Interpreter(clang_Interpreter_create(x))
end

function createWithCUDA(ci::AbstractCompilerInstance, dci::AbstractCompilerInstance)
    @check_ptrs ci dci
    return Interpreter(clang_Interpreter_createWithCUDA(ci, dci))
end

dispose(x::AbstractInterpreter) = clang_interpreter_dispose(x)

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
