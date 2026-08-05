#include "clang-ex/Sema/CXScope.h"
#include "utils.h"
#include "clang/AST/Decl.h"
#include "clang/AST/DeclBase.h"
#include "clang/AST/DeclCXX.h"
#include "clang/Basic/Diagnostic.h"
#include "clang/Sema/Scope.h"
#include "llvm/Support/raw_ostream.h"
#include <memory>

unsigned clang_Scope_getFlags(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->getFlags();
}

CXScope clang_Scope_getFnParent(CXScope S) {
  return reinterpret_cast<CXScope>(reinterpret_cast<clang::Scope *>(S)->getFnParent());
}

CXDeclContext clang_Scope_getEntity(CXScope S) {
  return reinterpret_cast<CXDeclContext>(reinterpret_cast<clang::Scope *>(S)->getEntity());
}

bool clang_Scope_isTemplateParamScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isTemplateParamScope();
}

bool clang_Scope_isDeclScope(CXScope S, CXDecl D) {
  return reinterpret_cast<clang::Scope *>(S)->isDeclScope(reinterpret_cast<clang::Decl *>(D));
}

void clang_Scope_dump(CXScope S) { reinterpret_cast<clang::Scope *>(S)->dump(); }

bool clang_Scope_isBlockScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isBlockScope();
}

CXScope clang_Scope_getContinueParent(CXScope S) {
  return reinterpret_cast<CXScope>(reinterpret_cast<clang::Scope *>(S)->getContinueParent());
}

CXScope clang_Scope_getBreakParent(CXScope S) {
  return reinterpret_cast<CXScope>(reinterpret_cast<clang::Scope *>(S)->getBreakParent());
}

CXScope clang_Scope_getBlockParent(CXScope S) {
  return reinterpret_cast<CXScope>(reinterpret_cast<clang::Scope *>(S)->getBlockParent());
}

CXScope clang_Scope_getTemplateParamParent(CXScope S) {
  return reinterpret_cast<CXScope>(reinterpret_cast<clang::Scope *>(S)->getTemplateParamParent());
}

unsigned clang_Scope_getFunctionPrototypeDepth(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->getFunctionPrototypeDepth();
}

unsigned clang_Scope_getNumDecls(CXScope S) {
  auto *Sc = reinterpret_cast<clang::Scope *>(S);
  unsigned N = 0;
  for (auto *D : Sc->decls()) {
    (void)D;
    ++N;
  }
  return N;
}

void clang_Scope_getDecls(CXScope S, CXDecl *Buf) {
  auto *Sc = reinterpret_cast<clang::Scope *>(S);
  unsigned I = 0;
  for (auto *D : Sc->decls())
    Buf[I++] = reinterpret_cast<CXDecl>(D);
}

bool clang_Scope_decl_empty(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->decl_empty();
}

CXDeclContext clang_Scope_getLookupEntity(CXScope S) {
  return reinterpret_cast<CXDeclContext>(reinterpret_cast<clang::Scope *>(S)->getLookupEntity());
}

bool clang_Scope_isFunctionScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isFunctionScope();
}

bool clang_Scope_isClassScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isClassScope();
}

bool clang_Scope_containedInPrototypeScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->containedInPrototypeScope();
}

CXScope clang_Scope_getParent(CXScope S) {
  return reinterpret_cast<CXScope>(reinterpret_cast<clang::Scope *>(S)->getParent());
}

unsigned clang_Scope_getDepth(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->getDepth();
}

bool clang_Scope_isConditionVarScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isConditionVarScope();
}

bool clang_Scope_hasUnrecoverableErrorOccurred(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->hasUnrecoverableErrorOccurred();
}

bool clang_Scope_isClassInheritanceScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isClassInheritanceScope();
}

bool clang_Scope_isInCXXInlineMethodScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isInCXXInlineMethodScope();
}

bool clang_Scope_isFunctionPrototypeScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isFunctionPrototypeScope();
}

bool clang_Scope_isFunctionDeclarationScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isFunctionDeclarationScope();
}

bool clang_Scope_isCatchScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isCatchScope();
}

bool clang_Scope_isSwitchScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isSwitchScope();
}

bool clang_Scope_isContinueScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isContinueScope();
}

bool clang_Scope_isTryScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isTryScope();
}

bool clang_Scope_isCompoundStmtScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isCompoundStmtScope();
}

bool clang_Scope_isControlScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isControlScope();
}

CXScope clang_Scope_getMSLastManglingParent(CXScope S) {
  return reinterpret_cast<CXScope>(reinterpret_cast<clang::Scope *>(S)->getMSLastManglingParent());
}

unsigned clang_Scope_getMSLastManglingNumber(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->getMSLastManglingNumber();
}

unsigned clang_Scope_getMSCurManglingNumber(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->getMSCurManglingNumber();
}

bool clang_Scope_isInObjcMethodScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isInObjcMethodScope();
}

bool clang_Scope_isInObjcMethodOuterScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isInObjcMethodOuterScope();
}

bool clang_Scope_isAtCatchScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isAtCatchScope();
}

bool clang_Scope_isOpenMPDirectiveScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isOpenMPDirectiveScope();
}

bool clang_Scope_isOpenMPLoopDirectiveScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isOpenMPLoopDirectiveScope();
}

bool clang_Scope_isOpenMPSimdDirectiveScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isOpenMPSimdDirectiveScope();
}

bool clang_Scope_isOpenMPLoopScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isOpenMPLoopScope();
}

bool clang_Scope_isOpenMPOrderClauseScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isOpenMPOrderClauseScope();
}

bool clang_Scope_isFnTryCatchScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isFnTryCatchScope();
}

bool clang_Scope_isSEHTryScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isSEHTryScope();
}

bool clang_Scope_isSEHExceptScope(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->isSEHExceptScope();
}

bool clang_Scope_Contains(CXScope S, CXScope RHS) {
  return reinterpret_cast<clang::Scope *>(S)->Contains(*reinterpret_cast<clang::Scope *>(RHS));
}

unsigned clang_Scope_getNumUsingDirectives(CXScope S) {
  auto R = reinterpret_cast<clang::Scope *>(S)->using_directives();
  return static_cast<unsigned>(R.end() - R.begin());
}

CXUsingDirectiveDecl clang_Scope_getUsingDirective(CXScope S, unsigned I) {
  auto R = reinterpret_cast<clang::Scope *>(S)->using_directives();
  return reinterpret_cast<CXUsingDirectiveDecl>(R.begin()[I]);
}

CXString clang_Scope_dumpImplToString(CXScope S) {
  std::string Str;
  llvm::raw_string_ostream OS(Str);
  reinterpret_cast<clang::Scope *>(S)->dumpImpl(OS);
  return extra::makeCXString(OS.str());
}

CXScope clang_Scope_create(CXScope Parent, unsigned ScopeFlags, CXDiagnosticsEngine Diag) {
  return reinterpret_cast<CXScope>(std::make_unique<clang::Scope>(reinterpret_cast<clang::Scope *>(Parent), ScopeFlags,
                                        *reinterpret_cast<clang::DiagnosticsEngine *>(Diag))
      .release());
}

void clang_Scope_dispose(CXScope S) { delete reinterpret_cast<clang::Scope *>(S); }

void clang_Scope_setFlags(CXScope S, unsigned F) {
  reinterpret_cast<clang::Scope *>(S)->setFlags(F);
}

void clang_Scope_setIsConditionVarScope(CXScope S, bool InConditionVarScope) {
  reinterpret_cast<clang::Scope *>(S)->setIsConditionVarScope(InConditionVarScope);
}

unsigned clang_Scope_getNextFunctionPrototypeIndex(CXScope S) {
  return reinterpret_cast<clang::Scope *>(S)->getNextFunctionPrototypeIndex();
}

void clang_Scope_AddDecl(CXScope S, CXDecl D) {
  reinterpret_cast<clang::Scope *>(S)->AddDecl(reinterpret_cast<clang::Decl *>(D));
}

void clang_Scope_RemoveDecl(CXScope S, CXDecl D) {
  reinterpret_cast<clang::Scope *>(S)->RemoveDecl(reinterpret_cast<clang::Decl *>(D));
}

void clang_Scope_incrementMSManglingNumber(CXScope S) {
  reinterpret_cast<clang::Scope *>(S)->incrementMSManglingNumber();
}

void clang_Scope_decrementMSManglingNumber(CXScope S) {
  reinterpret_cast<clang::Scope *>(S)->decrementMSManglingNumber();
}

void clang_Scope_setEntity(CXScope S, CXDeclContext E) {
  reinterpret_cast<clang::Scope *>(S)->setEntity(reinterpret_cast<clang::DeclContext *>(E));
}

void clang_Scope_setLookupEntity(CXScope S, CXDeclContext E) {
  reinterpret_cast<clang::Scope *>(S)->setLookupEntity(reinterpret_cast<clang::DeclContext *>(E));
}

void clang_Scope_PushUsingDirective(CXScope S, CXUsingDirectiveDecl UDir) {
  reinterpret_cast<clang::Scope *>(S)->PushUsingDirective(
      reinterpret_cast<clang::UsingDirectiveDecl *>(UDir));
}

void clang_Scope_Init(CXScope S, CXScope Parent, unsigned ScopeFlags) {
  reinterpret_cast<clang::Scope *>(S)->Init(reinterpret_cast<clang::Scope *>(Parent), ScopeFlags);
}

void clang_Scope_AddFlags(CXScope S, unsigned Flags) {
  reinterpret_cast<clang::Scope *>(S)->AddFlags(Flags);
}
