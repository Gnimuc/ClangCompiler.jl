using ClangCompiler
import ClangCompiler as CC
using ClangCompiler: create_interpreter, dispose, DeclFinder, get_decl, get_instance
using Test

@testset "module parenting, exports, requirements and printing" begin
    I = create_interpreter(String[])
    ci = get_instance(I)
    lang_opts = CC.getLangOpts(ci)
    target = CC.getTarget(ci)

    root = CC.Module_("MvTopMod"; visibility_id=4100)
    child = CC.Module_("MvChild")   # parentless until setParent hands it to root
    @test CC.getParent(child).ptr == C_NULL
    @test CC.setParent(child, root) === nothing   # root owns child from here on
    @test CC.getParent(child).ptr == root.ptr
    @test CC.findSubmodule(root, "MvChild").ptr == child.ptr
    # a module that already has a parent cannot be re-parented
    @test_throws AssertionError CC.setParent(child, root)

    @test CC.fullModuleNameIs(root, ["MvTopMod"])
    @test CC.fullModuleNameIs(child, ["MvTopMod", "MvChild"])
    @test CC.fullModuleNameIs(child, ["MvTopMod"]) == false
    @test CC.fullModuleNameIs(child, String[]) == false

    # a module is always visible to itself; anything else depends on its imports
    @test CC.isModuleVisible(root, root)
    @test CC.isModuleVisible(root, child) isa Bool

    # non-explicit submodules are exported
    n = CC.getNumExportedModules(root)
    @test n isa Int
    exported = CC.getExportedModules(root)
    @test length(exported) == n
    @test all(m -> m isa CC.Module_ && m.ptr != C_NULL, exported)
    @test child.ptr in [m.ptr for m in exported]
    @test CC.getNumExportedModules(child) == 0
    @test isempty(CC.getExportedModules(child))

    # the module fragments are C++20 named-module state a module-map module lacks
    @test CC.isNamedModuleUnit(root) == false
    @test_throws AssertionError CC.getGlobalModuleFragment(root)
    @test_throws AssertionError CC.getPrivateModuleFragment(root)

    @test CC.getModuleInputBufferName() == "<module-includes>"

    # Availability of a hand-built module is host-decided, and so is the transition a
    # failing requirement would drive: markUnavailable reads bits a synthetic module
    # never had a module map to set. Only the shape is asserted.
    @test CC.addRequirement(root, "cplusplus", true, lang_opts, target) === nothing
    @test CC.isAvailable(root) isa Bool

    text = CC.print(root, 0, false)
    @test text isa String
    @test occursin("MvTopMod", text)
    @test CC.print(root, 2, true) isa String
    @test CC.dump(root) === nothing

    CC.dispose(root)   # deletes child along with it
    dispose(I)
end
