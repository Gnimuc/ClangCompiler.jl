enable_incremental(x::Preprocessor) = enableIncrementalProcessing(x)

is_incremental(x::Preprocessor) = isIncrementalProcessingEnabled(x)

"""
    macro_history(x::AbstractMacroDirective) -> ChainIterator
Iterate a macro's definition history, most recent first -- each `#define` and `#undef` of
that name, in reverse order.
"""
macro_history(x::AbstractMacroDirective) = ChainIterator(x, getPrevious)
