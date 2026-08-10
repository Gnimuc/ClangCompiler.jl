#include "clang-ex/Lex/CXTokenConcatenation.h"

#include "clang/Lex/Preprocessor.h"
#include "clang/Lex/Token.h"
#include "clang/Lex/TokenConcatenation.h"

#include <memory>

namespace {

clang::TokenConcatenation *concat(CXTokenConcatenation TC) {
  return reinterpret_cast<clang::TokenConcatenation *>(TC);
}

} // namespace

CXTokenConcatenation clang_TokenConcatenation_create(CXPreprocessor PP) {
  return reinterpret_cast<CXTokenConcatenation>(
      std::make_unique<clang::TokenConcatenation>(
          *reinterpret_cast<clang::Preprocessor *>(PP))
          .release());
}

void clang_TokenConcatenation_dispose(CXTokenConcatenation TC) { delete concat(TC); }

bool clang_TokenConcatenation_AvoidConcat(CXTokenConcatenation TC, CXToken_ PrevPrevTok,
                                          CXToken_ PrevTok, CXToken_ Tok) {
  return concat(TC)->AvoidConcat(*reinterpret_cast<clang::Token *>(PrevPrevTok),
                                 *reinterpret_cast<clang::Token *>(PrevTok),
                                 *reinterpret_cast<clang::Token *>(Tok));
}
