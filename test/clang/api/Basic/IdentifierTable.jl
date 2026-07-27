using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_tag, get_instance
using Test

@testset "Basic | IdentifierTable, LangOptions, TokenKinds, Module" begin
    I = create_interpreter(String[])
    CC.parse(I, """
             extern "C" int idlm_probe(int a) { return a + 1; }
             """)
    ci = CC.get_instance(I)
    ctx = CC.get_ast_context(I)
    lo = CC.getLangOpts(ci)

    # ---- LangOptions read surface (C++ TU defaults) ----
    @test CC.isCompilingModule(lo) == false
    @test CC.isCompilingModuleInterface(lo) isa Bool
    @test CC.isCompilingModuleImplementation(lo) isa Bool
    @test CC.isSignedOverflowDefined(lo) isa Bool
    @test CC.isSubscriptPointerArithmetic(lo) isa Bool
    @test CC.isNoBuiltinFunc(lo, "memcpy") isa Bool
    @test CC.assumeFunctionsAreConvergent(lo) isa Bool
    @test CC.getOpenCLCompatibleVersion(lo) isa Int
    @test CC.getOpenCLVersionString(lo) isa String
    @test CC.requiresStrictPrototypes(lo) == true
    @test CC.implicitFunctionsAllowed(lo) == false
    @test CC.hasAtExit(lo) == true
    @test CC.isImplicitIntRequired(lo) == false
    @test CC.isImplicitIntAllowed(lo) == false
    @test CC.hasSjLjExceptions(lo) isa Bool
    @test CC.hasSEHExceptions(lo) isa Bool
    @test CC.hasDWARFExceptions(lo) isa Bool
    @test CC.hasWasmExceptions(lo) isa Bool
    @test CC.isSYCL(lo) == false

    # ---- IdentifierInfo predicates and IDs ----
    it = CC.getIdents(ctx)
    ii = get(it, "idlm_probe")
    @test CC.isStr(ii, "idlm_probe") == true
    @test CC.isStr(ii, "other") == false
    @test CC.getLength(ii) == length("idlm_probe")
    @test CC.hasMacroDefinition(ii) == false
    @test CC.hadMacroDefinition(ii) isa Bool
    @test CC.isDeprecatedMacro(ii) == false
    @test CC.isFinal(ii) == false
    @test CC.isExtensionToken(ii) == false
    @test CC.isFutureCompatKeyword(ii) == false
    @test CC.isPoisoned(ii) == false
    @test CC.setIsPoisoned(ii, true) === nothing
    @test CC.isPoisoned(ii) == true
    CC.setIsPoisoned(ii, false)
    @test CC.isCPlusPlusOperatorKeyword(ii) == false
    @test CC.isKeyword(ii, lo) == false
    @test CC.isCPlusPlusKeyword(ii, lo) == false
    @test CC.isEditorPlaceholder(ii) == false
    @test CC.isPlaceholder(ii) == false
    @test CC.getBuiltinID(ii) == 0
    @test CC.getPPKeywordID(ii) == CC.CXPPKeywordKind_pp_not_keyword

    # ---- tok::TokenKind queries via the raw kind ----
    tid = CC.getTokenID(ii)                # a plain identifier
    @test CC.isAnyIdentifier(tid) == true
    @test CC.getTokenName(tid) isa String
    @test CC.isLiteral(tid) == false
    @test CC.isStringLiteral(tid) == false
    @test CC.isAnnotation(tid) == false
    @test CC.isPragmaAnnotation(tid) == false

    kw = get(it, "int")                    # keyword entry (keywords added at PP init)
    ktid = CC.getTokenID(kw)
    @test CC.isKeyword(kw, lo) == true
    @test CC.isAnyIdentifier(ktid) == false
    @test CC.getTokenName(ktid) == "int"
    @test CC.getKeywordSpelling(ktid) == "int"
    @test CC.getPunctuatorSpelling(ktid) === nothing
    @test CC.getPPKeywordSpelling(CC.CXPPKeywordKind_pp_define) == "define"

    rsvd = get(it, "_Reserved")
    @test CC.isReserved(rsvd, lo) isa CC.CXReservedIdentifierStatus
    @test CC.isReserved(rsvd, lo) != CC.CXReservedIdentifierStatus_NotReserved
    @test CC.deuglifiedName(rsvd) == "Reserved"
    @test CC.isReservedLiteralSuffixId(rsvd) isa CC.CXReservedLiteralSuffixIdStatus

    # ---- standalone IdentifierTable (create → use → dispose) ----
    it2 = CC.IdentifierTable(lo)
    @test size(it2) > 0
    @test contains(it2, "int") == true     # keywords were added on create
    @test contains(it2, "idlm_no_such_ident") == false
    @test CC.AddKeywords(it2, lo) === nothing
    ii2 = get(it2, "idlm_fresh_ident")
    @test CC.getName(ii2) == "idlm_fresh_ident"
    @test contains(it2, "idlm_fresh_ident") == true
    CC.dispose(it2)

    # ---- Module identity/kind/parent + submodules (create → use → dispose) ----
    root = CC.Module_("TopMod")
    @test CC.getName(root) == "TopMod"
    @test CC.getKind(root) == CC.CXModuleKind_ModuleMapModule
    @test CC.isModuleMapModule(root) == true
    @test CC.isHeaderLikeModule(root) == true
    @test CC.isNamedModule(root) == false
    @test CC.isGlobalModule(root) == false
    @test CC.isExplicitGlobalModule(root) == false
    @test CC.isImplicitGlobalModule(root) == false
    @test CC.isPrivateModule(root) == false
    @test CC.isUnimportable(root) isa Bool
    @test CC.isAvailable(root) isa Bool
    @test CC.isSubModule(root) == false
    @test CC.isPartOfFramework(root) == false
    @test CC.isSubFramework(root) == false
    @test CC.isModulePartition(root) == false
    @test CC.isModuleImplementation(root) == false
    @test CC.isHeaderUnit(root) == false
    @test CC.isInterfaceOrPartition(root) == false
    @test CC.isNamedModuleUnit(root) == false
    @test CC.isModuleInterfaceUnit(root) == false
    @test CC.getNumSubmodules(root) == 0

    child = CC.Module_("Child"; parent=root)   # owned by root — do not dispose
    @test CC.getName(child) == "Child"
    @test CC.isSubModule(child) == true
    @test CC.isSubModuleOf(child, root) == true
    @test CC.isSubModuleOf(root, child) == false
    @test CC.getParent(child).ptr == root.ptr
    @test CC.getParent(root).ptr == C_NULL
    @test CC.getTopLevelModule(child).ptr == root.ptr
    @test CC.getTopLevelModuleName(child) == "TopMod"
    @test CC.getFullModuleName(child) == "TopMod.Child"
    @test CC.getPrimaryModuleInterfaceName(child) == "Child"
    @test CC.getNumSubmodules(root) == 1
    @test CC.getSubmodule(root, 0).ptr == child.ptr
    @test CC.findSubmodule(root, "Child").ptr == child.ptr
    @test CC.findSubmodule(root, "Nope").ptr == C_NULL
    @test CC.directlyUses(child, root) isa Bool
    CC.dispose(root)                           # also deletes child

    dispose(I)
end
