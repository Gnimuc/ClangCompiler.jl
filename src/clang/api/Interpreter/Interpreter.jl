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

function SetOffloadArch(x::AbstractIncrementalCompilerBuilder, arch::AbstractString)
    @check_ptrs x
    return clang_IncrementalCompilerBuilder_SetOffloadArch(x, arch)
end

function SetCudaSDK(x::AbstractIncrementalCompilerBuilder, path::AbstractString)
    @check_ptrs x
    return clang_IncrementalCompilerBuilder_SetCudaSDK(x, path)
end

"""
    CreateCudaHost(x::AbstractIncrementalCompilerBuilder) -> CompilerInstance
Create a compiler instance configured for CUDA host compilation. The result holds a NULL
pointer on failure. This function allocates and one should call `dispose` to release the
resources after using this object (creating an `Interpreter` from it transfers ownership
instead).
"""
function CreateCudaHost(x::AbstractIncrementalCompilerBuilder)
    @check_ptrs x
    return CompilerInstance(clang_IncrementalCompilerBuilder_CreateCudaHost(x))
end

"""
    CreateCudaDevice(x::AbstractIncrementalCompilerBuilder) -> CompilerInstance
Create a compiler instance configured for CUDA device compilation. The result holds a NULL
pointer on failure. This function allocates and one should call `dispose` to release the
resources after using this object (creating an `Interpreter` from it transfers ownership
instead).
"""
function CreateCudaDevice(x::AbstractIncrementalCompilerBuilder)
    @check_ptrs x
    return CompilerInstance(clang_IncrementalCompilerBuilder_CreateCudaDevice(x))
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

function getExecutionEngine(x::AbstractInterpreter)
    @check_ptrs x
    return LLVM.LLJIT(clang_Interpreter_getExecutionEngine(x))
end

function undo(x::AbstractInterpreter, n::Integer=1)
    @check_ptrs x
    return clang_Interpreter_Undo(x, n)
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

function Parse(x::AbstractInterpreter, code::AbstractString)
    @check_ptrs x
    return PartialTranslationUnit(clang_Interpreter_Parse(x, code))
end

function Execute(x::AbstractInterpreter, ptu::PartialTranslationUnit)
    @check_ptrs x ptu
    return clang_Interpreter_Execute(x, ptu)
end

function ParseAndExecute(x::AbstractInterpreter, code::AbstractString)
    @check_ptrs x
    v = create_value()
    clang_Interpreter_ParseAndExecute(x, code, v)
    return v
end

"""
    CompileDtorCall(x::AbstractInterpreter, rd::AbstractCXXRecordDecl) -> UInt64
Compile the destructor call for the record and return its executor address. Records whose
destructor is irrelevant (trivial) yield 0, as do failures (logged to stderr).
"""
function CompileDtorCall(x::AbstractInterpreter, rd::AbstractCXXRecordDecl)
    @check_ptrs x rd
    return clang_Interpreter_CompileDtorCall(x, rd)
end

function LoadDynamicLibrary(x::AbstractInterpreter, name::AbstractString)
    @check_ptrs x
    return clang_Interpreter_LoadDynamicLibrary(x, name)
end

"""
    getASTContext(x::AbstractInterpreter) -> ASTContext
Return the interpreter's `ASTContext`, borrowed — never `dispose` it through this carrier.

This is the same context [`getASTContext`](@ref) reaches through the compiler instance, which
is what clang's own body does; it is here so the context can be had without naming the
instance.
"""
function getASTContext(x::AbstractInterpreter)
    @check_ptrs x
    return ASTContext(clang_Interpreter_getASTContext(x))
end
