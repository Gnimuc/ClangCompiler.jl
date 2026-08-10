# TrivialModuleLoader
"""
    TrivialModuleLoader() -> TrivialModuleLoader
Create the module loader that loads nothing: every override is a no-op, so importing a
module through it simply fails.

`Preprocessor`'s constructor takes a `ModuleLoader &`, and this is what satisfies it when a
preprocessor is stood up without the `CompilerInstance` that would otherwise supply one. It
must outlive every preprocessor built on it.

This function allocates and one should call `dispose` to release the resources after using
this object.
"""
function TrivialModuleLoader()
    ml = clang_TrivialModuleLoader_create()
    @assert ml != C_NULL "Failed to create TrivialModuleLoader"
    return TrivialModuleLoader(ml)
end

dispose(x::TrivialModuleLoader) = clang_TrivialModuleLoader_dispose(x)
