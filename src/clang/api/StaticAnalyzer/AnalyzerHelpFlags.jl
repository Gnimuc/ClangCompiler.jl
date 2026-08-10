# ento — the four checker/config listings clang prints for its --help flags.
#
# Each returns the human-formatted text clang itself prints (wrapped to a fixed width),
# not a machine format. What makes them worth having over the static
# `getRegisteredCheckers` name list is the content: descriptions, documentation URIs,
# per-checker config options, and the *enabled* set of a real instance, plugin checkers
# included.
#
# The three instance forms build a `CheckerManager` out of the instance's AnalyzerOptions,
# LangOptions, DiagnosticsEngine and plugin list, so a bare instance aborts inside clang;
# both preconditions are checked here.

"""
    printCheckerHelp(ci::CompilerInstance) -> String
Return the listing of every checker registered for `ci`, with its description — the text
`clang -cc1 -analyzer-checker-help` prints. Plugin checkers appear because the registry is
built from this instance's plugin list.
"""
function printCheckerHelp(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasDiagnostics(ci) "CompilerInstance has no diagnostics engine."
    @assert hasInvocation(ci) "CompilerInstance has no invocation."
    return get_string(clang_ento_printCheckerHelp(ci))
end

"""
    printEnabledCheckerList(ci::CompilerInstance) -> String
Return the subset of checkers `ci`'s `AnalyzerOptions` actually enable, one per line.
"""
function printEnabledCheckerList(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasDiagnostics(ci) "CompilerInstance has no diagnostics engine."
    @assert hasInvocation(ci) "CompilerInstance has no invocation."
    return get_string(clang_ento_printEnabledCheckerList(ci))
end

"""
    printCheckerConfigList(ci::CompilerInstance) -> String
Return the per-checker `-analyzer-config` options of the checkers enabled for `ci`.
"""
function printCheckerConfigList(ci::CompilerInstance)
    @check_ptrs ci
    @assert hasDiagnostics(ci) "CompilerInstance has no diagnostics engine."
    @assert hasInvocation(ci) "CompilerInstance has no invocation."
    return get_string(clang_ento_printCheckerConfigList(ci))
end

"""
    printAnalyzerConfigList() -> String
Return the non-checker `-analyzer-config` options, with their defaults and descriptions.
This one reads nothing but `AnalyzerOptions.def`, so it needs no instance.
"""
printAnalyzerConfigList() = get_string(clang_ento_printAnalyzerConfigList())
