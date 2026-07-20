# CLAUDE.md — ClangExtra (libclangex)

Guidance for working on the hand-written C API shim over Clang's C++ API. The repo-root
CLAUDE.md covers the overall package; this file covers the C/C++ wrapper conventions.
Everything compiles into one shared target `clangex` (C++17, `-fPIC -fno-rtti`, links the
monolithic `LLVM` + `clang-cpp` shared libs). Format C++ with clang-format (LLVM style,
ColumnLimit 92 — narrower than the Julia code's 120).

## The governing axiom

This C API has exactly one client: the Julia thin wrapper in `src/clang/`. It is not a
public C library — nothing else, C or C++, ever calls it directly. Every other rule in this
file derives from that single fact, and the choices that look unsafe in isolation are
principled because of it:

- **Handles are opaque `void *`** (all of them, in `CXTypes.h`). The C layer carries no
  subtyping information at all; Clang's class hierarchy and its multiple-inheritance pivots
  are reproduced one layer up, in Julia's type system.
- **Payload downcasts are `static_cast`, not `dyn_cast`.** The wrapper has already
  established the receiver's dynamic type before it calls, so the cast's precondition holds
  by construction.
- **No null checks, no validation, no error codes cross the boundary** (see Error handling).
  Preconditions are the caller's contract, and there is exactly one caller.

The safety this discards is re-established entirely in the Julia thin wrapper, which is the
**sole safety boundary**. Two invariants there make every `static_cast` in this library
valid — they are specified and must be preserved in `../../src/clang/CLAUDE.md`:

1. **Faithful carriers** — a Julia carrier's type always reflects its pointee's true dynamic
   C++ class, because carriers are constructed only through checked casts.
2. **Correctly-leveled receivers** — each wrapper types its receiver at the abstract
   supertype of the C++ class that declares the method, so multiple dispatch rejects a
   mistyped receiver before the ccall is emitted.

Corollary for writing C here: never add defensive code to protect a hypothetical direct
caller — there isn't one. Keep the shim dumb and total; the type-checking intelligence lives
in Julia.

## The rule that prevents disasters

**Header and .cpp must change in lockstep.** The Julia bindings are generated from the
headers alone, and `extern "C"` + `void*`-typedef signatures mean neither the C++ compiler
nor the linker catches arity or type drift between declaration and definition — failures
surface at Julia runtime as memory corruption or `dlsym` errors, never at build time.
Corollaries:

- A function defined only in the .cpp but missing from the header never reaches Julia.
- A .cpp missing from its `CMakeLists.txt` compiles into nothing — the symbol is missing
  only when Julia first calls it (the shared lib has no link-time consumer of its own
  symbols).
- Renaming any existing symbol (including frozen typos like `clang_DeclGroupRef_fromeDecl`
  and `clang_ASTContext_getCFContantStringDecl`, and the lowercase outliers
  `clang_value_*` / `clang_sema_getTypeName`) is an ABI break: regenerated bindings, Julia
  callers, and a libclangex_jll release are all implicated. Don't fix spellings in passing.

## Layout and registration

- One header/impl pair per wrapped Clang header, in the directory mirroring the Clang
  source tree: `include/clang-ex/<Dir>/CX<Header>.h` + `lib/<Dir>/CX<Header>.cpp`
  (e.g. `clang/AST/DeclBase.h` → `AST/CXDeclBase.{h,cpp}`).
- Wrapper declarations/definitions keep the same order as methods in the Clang class.
  Unwrapped methods are left as `// methodName` placeholder comments, mirrored in header
  and .cpp (most files keep both sides in sync; a few are header-only); rejected
  experiments stay as commented-out code. Preserve this discipline — it makes diffing
  against upstream after LLVM bumps possible.
- ALL opaque handles are `typedef void *CX<ClangClassName>;` in the central
  `include/clang-ex/CXTypes.h`, grouped under `// <Library>` / `// <ClangHeader>` comments
  in upstream declaration order. Don't typedef handles in per-class headers (one legacy
  stray exists: `CXFunctionDecl_DefaultedFunctionInfo` in AST/CXDecl.h — search beyond
  CXTypes.h when checking for an existing typedef; `CXTemplateSpecializationType` is
  already duplicated inside CXTypes.h itself). A typedef existing does not mean wrapper
  functions exist.
- On a name collision with libclang, the **type** gets a trailing underscore — currently
  exactly five: `CXType_`, `CXSourceLocation_`, `CXSourceRange_`, `CXTargetInfo_`,
  `CXToken_`. Function names never get the underscore. Using the un-underscored name in a
  new signature silently binds to libclang's unrelated type in the generated bindings.
- Header skeleton: guard `LLVM_CLANG_C_EXTRA_<NAME>_H` (watch for copy-paste guard
  collisions — a colliding guard silently drops the header from the generated bindings); include
  `clang-ex/CXTypes.h`, `clang-c/ExternC.h`, `clang-c/Platform.h` (+ `clang-c/CXString.h`
  only if CXString appears, + `llvm-c/...` only if `LLVM*Ref` appears); wrap everything in
  `LLVM_CLANG_C_EXTERN_C_BEGIN/END`; zero-arg functions are `(void)`.
- .cpp skeleton: own clang-ex header first, then `"utils.h"` if producing strings, then
  clang/llvm C++ headers. `lib/` is on the include path, so `#include "utils.h"` works
  unqualified. `utils.h` is private — never include it from `include/clang-ex/`.
- CMake: add `target_sources(clangex PRIVATE ${CMAKE_CURRENT_LIST_DIR}/<file>)` lines —
  the .cpp in `lib/<Dir>/CMakeLists.txt` (**load-bearing**) and the .h in
  `include/clang-ex/<Dir>/CMakeLists.txt` (convention; headers install via the directory
  glob regardless). New subsystem dirs need `add_subdirectory` in both parents
  (alphabetical). Never create a second target, and never add visibility/dllexport
  attributes — export-everything is configured globally.

## Naming

- `clang_<ClassName>_<methodName>` with the C++ method name copied **verbatim including
  case** (`getDiagnostics`, but `ExecuteAction`, `Parse`, `CreateTargetInfo`). Static
  member functions keep the class segment and take no receiver; namespace-level free
  functions use the namespace as the class segment (`clang_CodeGen_convertTypeForMemory`)
  or drop it entirely (`clang_ParseAST`).
- First parameter is the receiver, named with the class-initial abbreviation (FD, DC, CI…).
- Only invented names are lowercase `_create`/`_dispose`, and `castTo<Derived>` helpers.
- Composite convenience wrappers (not 1:1 with a Clang method) are allowed; give them an
  intent-revealing name (`clang_CompilerInstance_setTargetAndLangOpts`,
  `clang_EnumConstantDecl_getEnumConstantDeclValue` — the latter marked `// helper` in
  its header).

## Marshalling

The trivial shapes are below. For value types, iterator ranges, arbitrary-precision numbers,
and other out-of-band results that a `void *` accessor can't carry, follow the playbook in
`MARSHALLING.md` (APValue/APSInt/APFloat, `std::string`→CXString, count+fill vs count+index for
ranges, exposing aggregate fields, discriminated unions, opaque navigation handles) — extend
that file rather than inventing a one-off scheme.

- Handle → C++: `static_cast<clang::T *>(h)`. Never `dynamic_cast`/`typeid` (built with
  `-fno-rtti`), never C-style casts. `T&` returns → `return &...;` const returns →
  `const_cast` (the C surface is all non-const `void*`). Reference params → deref a
  pointer arg.
- Downcasts: `clang_<Base>_castTo<Derived>` = `llvm::dyn_cast_or_null<clang::Derived>(...)`
  (null-safe, nullptr on wrong kind), placed under a `// <Base> Cast` comment at the end
  of that class's section (files hold several classes; casts close each section, not the
  file). Decl ↔ DeclContext cross-casts go through Clang's static
  `Decl::castToDeclContext`/`castFromDeclContext` or `dyn_cast` — never a plain pointer
  cast of the `void*` (multiple inheritance shifts the pointer).
- Value types cross by encoding, never as object pointers: `SourceLocation` ↔
  `.getPtrEncoding()` / `SourceLocation::getFromPtrEncoding()` (a `CXSourceLocation_` is
  the encoding itself — casting it to `SourceLocation*` and dereferencing is wrong);
  `QualType`/`DeclarationName`/`DeclGroupRef` ↔ `getAsOpaquePtr`/`getFromOpaquePtr`;
  `TemplateName` ↔ `getAsVoidPointer`/`getFromVoidPointer`. `SourceRange` returns by value
  as `CXSourceRange_{b.getPtrEncoding(), e.getPtrEncoding()}`; SourceRange parameters are
  passed either as `CXSourceRange_` by value (`clang_TagDecl_setBraceRange`) or
  decomposed into two `CXSourceLocation_` args (`clang_Sema_setAnnotationRange`) — match
  the local file.
- Strings out: computed/temporary → `extra::makeCXString(std::string)` from `utils.h`
  (strdup + CXS_Malloc; empty string is a static unmanaged ""; Julia frees via libclang's
  `clang_disposeString` — libclangex ships no string-free functions). Stable Clang-owned
  storage → borrowed `const char*` (`StringRef.data()`). The third pattern is the two-call
  length+fill protocol (`GetResourcesPathLength` + fill) — note it copies exactly N bytes
  with **no NUL terminator**. Strings in: `const char*` → `llvm::StringRef`, or an
  explicit `(const char*, size_t)` pair when length matters.
- Arrays: `ArrayRef` returns → `CXArrayRef{arr.data(), arr.size()}` (borrowed view into
  AST-owned memory, element type implied by the function, never freed); or the
  `getNum*()` + `get*(unsigned i)` index pair; or count+fill into a caller buffer. Array
  inputs are `(ptr, count)` rebuilt with `llvm::ArrayRef`.
- LLVM (non-Clang) objects cross as LLVM-C types (`LLVMModuleRef`, `LLVMOrcLLJITRef`,
  `LLVMOrcExecutorAddress`…) converted with `llvm::wrap`/`llvm::unwrap` where llvm-c
  exposes them (Module, Context, MemoryBuffer, Type). Where llvm-c has no public
  wrap/unwrap, the established pattern is `reinterpret_cast` — currently the
  `LLVMGenericValueRef ↔ llvm::GenericValue*` bridge for APSInt values and the
  `LLVMOrcLLJITRef` return in `clang_Interpreter_getExecutionEngine`. **Never mint a
  parallel `CX` type for something llvm-c or LLVM.jl's libLLVMExtra already exposes** (APInt,
  APFloat, Value, Type, Module, …); reuse the LLVM-C handle, and if an accessor is missing add
  it to libLLVMExtra in llvm-c style so it stays upstreamable. See `MARSHALLING.md` §0.

## The stamped Stmt layer (AST/CXStmt.h)

The Stmt hierarchy's classification surface is NOT hand-written: `CXStmtClass`
and the `clang_Stmt_castTo*`/`clang_Stmt_is*` families are stamped by X-macro
from the vendored `include/clang-ex/AST/StmtNodes.inc` (a verbatim copy of the
pinned LLVM version's TableGen output — vendored because the binding generator
drops declarations expanded from `-isystem` paths). Rules: never edit the
vendored .inc (re-copy it on an LLVM bump; the static_assert tables in
CXStmt.cpp fail the build if it goes stale); stamped symbols are
version-following per LLVM major, exempt from the frozen-ABI rule; per-class
payload accessors are hand-written in the normal per-header files, NOT stamped.
gen/generator.jl auto-ignorelists the .inc's transient per-class macros and
emits lib/<major>/StmtNodes.jl (the table the Julia layer stamps from) — both
regenerate with the bindings.

## Enums

- Every mirrored enum MUST have an ENUM_SYNC table in lib/Basic/CXEnumSync.cpp
  covering every enumerator — a partial mirror silently ships missing enumerators
  and wrong numbering.
- Mirror as `typedef enum CX<ClangEnumName> { CX<ClangEnumName>_<EnumeratorVerbatim>, ... }`
  in the subsystem header matching the Clang header the enum lives in (shared clang/Basic
  enums → `include/clang-ex/Basic/*.h`; class-local enums inline in the class's CX header).
  CXTypes.h's lone `CXTranslationUnitKind` is a legacy exception, not the pattern.
- Copy Clang's explicit underlying type when it has one (`: unsigned char` → Julia
  `@enum ...::UInt8`); the default maps to UInt32.
- Conversion is a blind `static_cast` in both directions — **order and values must match
  the pinned LLVM version's header exactly**, verified against the actual artifact header
  (`~/.julia/artifacts/<LLVM_full_jll>/include/clang/...`), not memory. A mirror that lags
  the pinned LLVM version's numbering returns values shifted from what callers expect.
- Pure-enum headers get no .cpp and are registered only in the include-side CMakeLists.
  The six Basic ones (CXLinkage.h, CXSpecifiers.h, CXLambda.h, CXPragmaKinds.h,
  CXVisibility.h, CXExceptionSpecificationType.h) contain no #includes at all and must be
  included after a header that already provides the extern-C macros;
  AST/CXOperationKinds.h instead includes ExternC.h/Platform.h itself and is
  self-sufficient — the latter is the safer style for new enum headers.
- Two-state enum-class params (e.g. `ImplicitTypenameContext`) are exposed as `bool` and
  bridged with a ternary.

## Ownership

The only reliable way to tell ownership is to read the impl; these are the rules to write
new code by:

- Caller-owned: a heap-allocating `_create` = `std::make_unique<T>(...).release()` with a
  matching `_dispose` = `delete static_cast<T*>(h)` declared in the same header (creates
  that return a value encoding, like `clang_DeclarationName_create`, allocate nothing and
  have no dispose). Subclass creates return the BASE-class handle and share the base
  `_dispose` (`clang_TextDiagnosticPrinter_create` → `CXDiagnosticConsumer`,
  `clang_DiagnosticConsumer_dispose`).
- Borrowed: `get*` accessors normally return interior pointers — no dispose exists, and
  disposing a handle obtained from a getter is a double free even when the same handle
  type has a `_dispose` (`getInvocation` vs `clang_CompilerInvocation_create`). The
  exceptions are getters forced to heap-box a by-value C++ return —
  `clang_FileManager_getFileRef` (→ `clang_FileEntryRef_dispose`),
  `clang_SourceManager_getMainFileID` (→ `clang_FileID_dispose`) — and
  `clang_FileManager_getBufferForFile`, which hands the caller an owned
  `LLVMMemoryBufferRef`.
- **Adoption overrides dispose.** Once an object is handed to an owning Clang API, its
  `_dispose` becomes a double free: `clang_Interpreter_create` consumes the
  CompilerInstance (even on failure); `setInvocation`/`setPreprocessor` wrap the raw
  handle in a fresh `shared_ptr`; `setASTConsumer` in a `unique_ptr`;
  `clang_DiagnosticsEngine_create` adopts the IDs/Options (and the consumer iff
  `ShouldOwnClient`); `clang_TargetInfo_CreateTargetInfo` absorbs the TargetOptions;
  `createFileIDFromMemoryBuffer`/`overrideFileContents`/`createFileManagerWithVOFS4PCH`
  consume the `LLVMMemoryBufferRef`.
- C++ objects returned **by value** with no pointer encoding (FileEntryRef, FileID,
  TemplateArgument) are heap-boxed with make_unique/release and get an explicit dispose —
  flag this in a header comment. TemplateArgument is the only AST-area family with a
  dispose; nearly everything else in AST wrappers is ASTContext-arena memory (one leak to
  know about: `clang_ASTContext_createMangleContext` returns a caller-owned heap object
  with no dispose function).
- Lifetime traps documented in code, keep them true: `clang_SourceManager_create` stores
  references (dispose SourceManager before its FileManager/DiagnosticsEngine);
  `clang_Interpreter_Parse` returns a pointer into the interpreter's PTU list (invalidated
  by `Undo`); `SetCompilerArgs` stores only the char pointers (strings must outlive the
  builder until `Create*`); a Parser from `clang_Interpreter_getParser` is borrowed while
  `clang_Parser_create`'s is owned.

## Error handling

- Nothing crosses the C boundary: no exceptions and no error codes — checks happen
  on the Julia side. Fallible calls (`llvm::Expected`/`ErrorOr`/`llvm::Error`) are
  unwrapped in the shim: log to `llvm::errs()` and return a sentinel (nullptr for
  pointers, 0 for `LLVMOrcExecutorAddress`); void wrappers log the same way but give the
  caller no failure signal. Always consume the `Error` (`toString(std::move(E))`) — a
  destroyed-unconsumed Error aborts under LLVM assertion builds, which build_local.jl
  supports. The `"LIBCLANGEX ERROR: "` prefix is the Interpreter-file convention; other
  files log unprefixed messages — match the local file.
- Most wrappers deliberately have zero checks (the Clang methods can't fail); don't add
  ad-hoc validation. Null/precondition checking is the Julia layer's job (`@check_ptrs`,
  `@assert hasX`).
- One known anti-pattern not to copy: `clang_Interpreter_getExecutionEngine` dereferences
  an `Expected` without checking.

## upstream/ — private-header hacks

`upstream/` holds verbatim copies of Clang headers edited ONLY to change member access
(inserting `public:`/`private:`) so wrappers can reach private members (currently
`Interpreter::IncrParser` and `IncrementalParser::P`). It's on the include path as
`CLANG_SRC`, so `#include "Interpreter/Interpreter.h"` gets the hacked copy while
`#include "clang/Interpreter/Interpreter.h"` gets the real one — CXInterpreter.cpp uses
the hacked copies, CXValue.cpp the real header; this ODR tightrope is safe only because
the class layout stays byte-identical. Rules: never reorder/add/remove data members, only
access-specifier edits (and deleting declarations); `IncrementalParser.h` comes from
`clang/lib/Interpreter/` in the llvm-project **source tree** (it is not installed in any
artifact); on an LLVM bump both files must be re-copied and re-hacked, and the Interpreter
internals changed after 18, so `getCodeGen`/`getParser` will need rework. These headers
are never installed.

## After any change here

1. Rebuild: `julia --project=deps deps/build_local.jl` (writes LocalPreferences.toml to
   point at the local build; pass a directory as ARGS[1] for incremental rebuilds,
   otherwise every run recompiles everything in a fresh tempdir). Delete
   LocalPreferences.toml to fall back to libclangex_jll.
2. Regenerate bindings: `julia --project=gen gen/generator.jl` (needs network). Headers
   are auto-discovered — no gen-side registration — EXCEPT: a new LLVM-C/libc type in a
   signature needs an import in gen/prologue.jl (required — the module won't load
   without it) plus, by convention, an `@add_def` line in gen/generator.jl (most existing
   types have both; the Orc refs get by on prologue-only); a new helper macro (X-macro
   tables etc.) must go in `output_ignorelist` in gen/option.toml or it becomes a junk
   binding.
3. Commit the header, .cpp, CMakeLists, and regenerated `lib/18/LibClangEx.jl` together —
   deterministic symbol mode keeps the lib diff minimal. The `bindings` CI job reruns the
   generator and fails on any diff under `lib/`, and the test suite enforces the rest:
   test/abi.jl (every binding's symbol resolves), test/lint.jl (layout/guards/CMake
   parity/collision names), test/coverage.jl (every binding wrapped, stamped, or
   skiplisted — and the skiplist only shrinks).
4. Note: any commit touching deps/ClangExtra makes every CI job compile libclangex from
   source (build_ci.jl timestamp check), and a ClangCompiler.jl release then requires a
   libclangex_jll rebuild on Yggdrasil + a compat bump in the top-level Project.toml —
   the shim itself carries no version number in this repo (CMake declares none); the
   Project.toml compat entry is the only reference to the JLL's version.
