#ifndef LLVM_CLANG_C_EXTRA_CXTOKENCONCATENATION_H
#define LLVM_CLANG_C_EXTRA_CXTOKENCONCATENATION_H

#include "clang-ex/CXTypes.h"
#include "clang-c/ExternC.h"
#include "clang-c/Platform.h"

LLVM_CLANG_C_EXTERN_C_BEGIN

// Answers "may these two tokens be printed with nothing between them?". Printing a token
// stream back to text -- a macro body walked through `clang_MacroInfo_*`, or the output of
// `clang_Preprocessor_Lex` -- is otherwise wrong in both directions: joining `foo` and
// `bar` yields the single token `foobar`, while a space between every pair is unreadable.

// Builds the per-token-kind table for `PP`'s language options. Release with
// `clang_TokenConcatenation_dispose`; `PP` is borrowed and must outlive it.
CXTokenConcatenation clang_TokenConcatenation_create(CXPreprocessor PP);

void clang_TokenConcatenation_dispose(CXTokenConcatenation TC);

// True when a space must be printed between `PrevTok` and `Tok`. `PrevPrevTok` is the
// token before `PrevTok`, which a few kinds need in order to decide (`.` after a numeric
// constant, `+`/`-` after an exponent); pass a token built by `clang_Token_create` when
// there is none.
bool clang_TokenConcatenation_AvoidConcat(CXTokenConcatenation TC, CXToken_ PrevPrevTok,
                                          CXToken_ PrevTok, CXToken_ Tok);

LLVM_CLANG_C_EXTERN_C_END

#endif
