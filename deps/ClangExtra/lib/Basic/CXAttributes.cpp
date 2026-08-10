#include "clang-ex/Basic/CXAttributes.h"

#include "clang/Basic/Attributes.h"
#include "clang/Basic/IdentifierTable.h"
#include "clang/Basic/LangOptions.h"
#include "clang/Basic/TargetInfo.h"

int clang_hasAttribute(CXAttributeCommonInfoSyntax Syntax, CXIdentifierInfo Scope,
                       CXIdentifierInfo Attr, CXTargetInfo_ Target,
                       CXLangOptions LangOpts) {
  return clang::hasAttribute(
      static_cast<clang::AttributeCommonInfo::Syntax>(Syntax),
      reinterpret_cast<const clang::IdentifierInfo *>(Scope),
      reinterpret_cast<const clang::IdentifierInfo *>(Attr),
      *reinterpret_cast<const clang::TargetInfo *>(Target),
      *reinterpret_cast<const clang::LangOptions *>(LangOpts));
}
