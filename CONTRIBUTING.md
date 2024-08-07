# API Styleguide

## C API

The C API is exactly the same as those exposed in the ClangExtra project.

* Like `libclang`, types are prefixed with `CX`.
* Like `libclang`, functions are prefixed with `clang_`, most of which use a name mangling rule: `clang_` `class name_` `method name`
* If there is a name collision between `libclang` and `libclangex`, the one exposed in `libclangex` will be suffixed by adding a tailing `_`. For example, `CXToken` is exposed by `libclang`, whereas the one exposed by `libclangex` is `CXToken_`.

## Julia API

The goal is to provide a set of Julia API that is as close as possible to the original C++ API of Clang. 

* For every `CX`-prefixed type, this package defines a corresponding Julia type. The type name is the same as the class name of Clang without the `CX`-prefix.
* Clang's class inheritance hierarchy is copied in Julia via abstract types and subtyping.
* The file hierarchy(in the folder `src/clang/core`) is the same as the one in the LLVM/Clang project.
* For every `clang`-prefixed function, the package defines a corresponding Julia wrapper. As Julia is not a tranditional OOP language, the `clang_`-prefix and the `class name` are all dropped. For example, the Julia wrapper for the C API `clang_CompilerInstance_hasDiagnostics` is called `hasDiagnostics`.
* The file hierarchy(in the folder `src/clang/api`) is the same as the one in the LLVM/Clang project.
* This package also defines some easy-to-use helper functions over the Clang low-level API. The [`YASStyle`](https://github.com/jrevels/YASGuide)'s naming guidelines are used for these functions.
