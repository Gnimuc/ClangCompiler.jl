# Interpreter
Interpreter(x::CompilerInstance) = Interpreter(clang_Interpreter_create(x))

dispose(x::Interpreter) = clang_Interpreter_dispose(x)

function getCompilerInstance(x::Interpreter)
    @check_ptrs x
    return CompilerInstance(clang_Interpreter_getCompilerInstance(x))
end

function Parse(x::Interpreter, code::String)
    @check_ptrs x
    return PartialTranslationUnit(clang_Interpreter_Parse(x, code))
end

function Execute(x::Interpreter, ptu::PartialTranslationUnit)
    @check_ptrs x ptu
    return clang_Interpreter_Execute(x, ptu)
end

function ParseAndExecute(x::Interpreter, code::String)
    @check_ptrs x
    return clang_Interpreter_ParseAndExecute(x, code)
end

# IncrementalCompilerBuilder
function IncrementalCompilerBuilder_create(args::Vector{String})
    return CompilerInstance(clang_IncrementalCompilerBuilder_create(args, length(args)))
end
