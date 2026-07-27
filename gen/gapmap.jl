# Gap map via libclang: extracts the public method surface of frequently-used
# clang-cpp headers (real access/nesting fidelity) for diffing against the
# libclangex bindings. Self-contained: activates a temp env with Clang.jl.
# Usage: julia gen/gapmap.jl <out.json>   (then diff class methods against
# `function clang_<Class>_<method>` names in lib/<major>/LibClangEx.jl)
import Pkg
Pkg.activate(temp=true, io=devnull)
Pkg.add(["Clang", "JSON3"]; io=devnull)
using Clang
using Clang.LibClang
using JSON3

const LLVM_INC = expanduser("~/.julia/artifacts/03178ba795d55ba102446a8eaccae5b1667dcc46/include")
const OUT = ARGS[1]

const HEADERS = [
    "clang/AST/DeclBase.h", "clang/AST/Decl.h", "clang/AST/DeclCXX.h",
    "clang/AST/DeclTemplate.h", "clang/AST/Expr.h", "clang/AST/ExprCXX.h",
    "clang/AST/Stmt.h", "clang/AST/StmtCXX.h", "clang/AST/Type.h",
    "clang/AST/ASTContext.h", "clang/AST/Mangle.h", "clang/AST/RecordLayout.h",
    "clang/AST/TemplateBase.h", "clang/AST/TemplateName.h",
    "clang/AST/NestedNameSpecifier.h", "clang/AST/DeclarationName.h",
    "clang/AST/APValue.h", "clang/AST/RawCommentList.h", "clang/AST/Comment.h",
    "clang/AST/ASTImporter.h",
    "clang/Sema/Sema.h", "clang/Sema/Lookup.h", "clang/Sema/Scope.h",
    "clang/Sema/Overload.h", "clang/Sema/Template.h",
    "clang/Lex/Preprocessor.h", "clang/Lex/Lexer.h", "clang/Lex/Token.h",
    "clang/Lex/MacroInfo.h", "clang/Lex/HeaderSearch.h",
    "clang/Lex/PreprocessingRecord.h",
    "clang/Basic/SourceManager.h", "clang/Basic/SourceLocation.h",
    "clang/Basic/LangOptions.h", "clang/Basic/TargetInfo.h",
    "clang/Basic/IdentifierTable.h", "clang/Basic/Diagnostic.h",
    "clang/Basic/FileManager.h", "clang/Basic/Module.h", "clang/Basic/FileEntry.h",
    "clang/Frontend/CompilerInstance.h", "clang/Frontend/CompilerInvocation.h",
    "clang/Frontend/ASTUnit.h", "clang/Frontend/FrontendAction.h",
    "clang/Analysis/CFG.h", "clang/Rewrite/Core/Rewriter.h",
    "clang/Index/USRGeneration.h",
    "clang/Interpreter/Interpreter.h", "clang/Interpreter/Value.h",
    "clang/CodeGen/ModuleBuilder.h", "clang/CodeGen/CodeGenAction.h",
    "clang/Driver/Driver.h",
]

# one umbrella TU
umbrella = joinpath(mktempdir(), "umbrella.hpp")
open(umbrella, "w") do io
    for h in HEADERS
        println(io, "#include \"$h\"")
    end
end

args = Clang.get_default_args(; is_cxx=true)
append!(args, ["-x", "c++-header", "-std=c++17", "-I$(LLVM_INC)"])

idx = Clang.Index()
tu = Clang.parse_header(idx, umbrella, args, CXTranslationUnit_SkipFunctionBodies)
tucur = Clang.getTranslationUnitCursor(tu)

# quick diagnostics sanity
ndiag = LibClang.clang_getNumDiagnostics(tu)
nerr = 0
for i in 0:(ndiag - 1)
    d = LibClang.clang_getDiagnostic(tu, i)
    sev = LibClang.clang_getDiagnosticSeverity(d)
    if sev >= LibClang.CXDiagnostic_Error
        global nerr += 1
        if nerr <= 5
            s = LibClang.clang_formatDiagnostic(d, 0)
            println(stderr, "DIAG: ", unsafe_string(LibClang.clang_getCString(s)))
            LibClang.clang_disposeString(s)
        end
    end
    LibClang.clang_disposeDiagnostic(d)
end
println(stderr, "parse errors: $nerr")

hdrset = Set(joinpath(LLVM_INC, h) for h in HEADERS)

cursor_file(c) = begin
    loc = LibClang.clang_getCursorLocation(c)
    f = Ref{LibClang.CXFile}(C_NULL)
    l = Ref{Cuint}(0); col = Ref{Cuint}(0); off = Ref{Cuint}(0)
    LibClang.clang_getExpansionLocation(loc, f, l, col, off)
    f[] == C_NULL && return ""
    s = LibClang.clang_getFileName(f[])
    r = unsafe_string(LibClang.clang_getCString(s))
    LibClang.clang_disposeString(s)
    return r
end

# type-marshallability classification by spelling
function classify_type(spelling::String)
    s = replace(spelling, "const " => "", " &" => "", "&" => "")
    s = strip(s)
    occursin("std::function", s) && return "hard"
    occursin("function_ref", s) && return "hard"
    occursin("unique_ptr", s) && return "hard"
    occursin("shared_ptr", s) && return "hard"
    occursin("IntrusiveRefCntPtr", s) && return "hard"
    occursin("iterator", s) && return "pattern"
    occursin("ArrayRef", s) && return "pattern"
    occursin("SmallVector", s) && return "pattern"
    occursin("std::vector", s) && return "pattern"
    occursin("std::string", s) && return "pattern"
    occursin("StringRef", s) && return "trivial"       # const char* + len
    occursin("std::optional", s) && return "pattern"
    occursin("std::pair", s) && return "pattern"
    occursin("PointerUnion", s) && return "pattern"
    occursin("raw_ostream", s) && return "pattern"
    occursin("APSInt", s) && return "pattern"
    occursin("APInt", s) && return "pattern"
    occursin("APValue", s) && return "trivial"          # CXAPValue exists
    occursin("APFloat", s) && return "pattern"
    occursin("CharUnits", s) && return "trivial"
    occursin("<", s) && return "hard"                   # other templates
    return "trivial"                                    # scalars, enums, X*/X&
end

results = Dict{String,Any}()  # class => Dict(method => info)
free_fns = Dict{String,Any}()

function visit(c, class_stack)
    k = Clang.kind(c)
    if k in (CXCursor_ClassDecl, CXCursor_StructDecl, CXCursor_ClassTemplate)
        LibClang.clang_isCursorDefinition(c) == 0 && return
        name = Clang.spelling(c)
        isempty(name) && return
        for ch in Clang.children(c)
            visit(ch, [class_stack; name])
        end
        return
    elseif k == CXCursor_Namespace || k == CXCursor_UnexposedDecl ||
           k == CXCursor_LinkageSpec
        for ch in Clang.children(c)
            visit(ch, class_stack)
        end
        return
    elseif k == CXCursor_CXXMethod || k == CXCursor_FunctionDecl
        file = cursor_file(c)
        file in hdrset || return
        name = Clang.spelling(c)
        (startswith(name, "operator") || startswith(name, "~")) && return
        if k == CXCursor_CXXMethod
            acc = LibClang.clang_getCXXAccessSpecifier(c)
            acc == LibClang.CX_CXXPublic || return
            isempty(class_stack) && return
            cls = join(class_stack, "::")
        else
            isempty(class_stack) || return
            cls = ""
        end
        ct = LibClang.clang_getCursorType(c)
        n = LibClang.clang_getNumArgTypes(ct)
        worst = "trivial"
        rank = Dict("trivial" => 0, "pattern" => 1, "hard" => 2)
        sig = String[]
        for i in 0:(n - 1)
            at = LibClang.clang_getArgType(ct, i)
            ss = LibClang.clang_getTypeSpelling(at)
            sp = unsafe_string(LibClang.clang_getCString(ss))
            LibClang.clang_disposeString(ss)
            push!(sig, sp)
            cl = classify_type(sp)
            rank[cl] > rank[worst] && (worst = cl)
        end
        rt = LibClang.clang_getResultType(ct)
        rs = LibClang.clang_getTypeSpelling(rt)
        rsp = unsafe_string(LibClang.clang_getCString(rs))
        LibClang.clang_disposeString(rs)
        cl = classify_type(rsp)
        rank[cl] > rank[worst] && (worst = cl)
        tgt = cls == "" ? free_fns : get!(Dict{String,Any}, results, cls)
        rel = replace(file, LLVM_INC * "/" => "")
        # keep the EASIEST overload's class per method name
        old = get(tgt, name, nothing)
        if old === nothing || rank[worst] < rank[old["class"]]
            tgt[name] = Dict("class" => worst, "hdr" => rel,
                             "ret" => rsp, "args" => sig)
        end
        return
    end
    # recurse shallowly elsewhere at TU level
    if isempty(class_stack)
        for ch in Clang.children(c)
            visit(ch, class_stack)
        end
    end
end

for ch in Clang.children(tucur)
    visit(ch, String[])
end

open(OUT, "w") do io
    JSON3.pretty(io, Dict("classes" => results, "free" => free_fns))
end
println(stderr, "classes: $(length(results)), free fns: $(length(free_fns))")
