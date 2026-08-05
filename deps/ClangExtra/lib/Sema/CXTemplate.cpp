#include "clang-ex/Sema/CXTemplate.h"
#include "clang/AST/DeclBase.h"
#include "clang/AST/TemplateBase.h"
#include "clang/Sema/Template.h"
#include "llvm/ADT/ArrayRef.h"
#include <deque>
#include <memory>
#include <vector>
#include "Sema/CXTemplateBox.h"
#include "clang/Sema/Sema.h"

// LocalInstantiationScope
//
// Constructing the scope installs it as Sema::CurrentInstantiationScope; the destructor
// that clang_LocalInstantiationScope_dispose runs restores the previous one, so the boxes
// must be released in reverse construction order.

CXLocalInstantiationScope clang_LocalInstantiationScope_create(CXSema S,
                                                               bool CombineWithOuterScope) {
  return std::make_unique<clang::LocalInstantiationScope>(*static_cast<clang::Sema *>(S),
                                                          CombineWithOuterScope)
      .release();
}

void clang_LocalInstantiationScope_dispose(CXLocalInstantiationScope Scope) {
  delete static_cast<clang::LocalInstantiationScope *>(Scope);
}

CXSema clang_LocalInstantiationScope_getSema(CXLocalInstantiationScope Scope) {
  return const_cast<clang::Sema *>(
      &static_cast<clang::LocalInstantiationScope *>(Scope)->getSema());
}

void clang_LocalInstantiationScope_Exit(CXLocalInstantiationScope Scope) {
  static_cast<clang::LocalInstantiationScope *>(Scope)->Exit();
}

bool clang_LocalInstantiationScope_isLocalPackExpansion(CXLocalInstantiationScope Scope,
                                                        CXDecl D) {
  return static_cast<clang::LocalInstantiationScope *>(Scope)->isLocalPackExpansion(
      static_cast<clang::Decl *>(D));
}

namespace {

/// Owning box for a clang::MultiLevelTemplateArgumentList.
///
/// The C++ class stores every level as an ArrayRef<TemplateArgument> and never copies the
/// elements, so a bare heap-boxed value would hold views onto memory the C caller owns.
/// The box keeps its own copy of each level. Declaration order is load-bearing: the
/// storage is declared first so it outlives the value that borrows it (MARSHALLING.md
/// §10). A std::deque never moves the elements already in it, so a level handed out
/// earlier stays valid when a later one is added.
struct MultiLevelTemplateArgumentListBox {
  std::deque<std::vector<clang::TemplateArgument>> Storage;
  clang::MultiLevelTemplateArgumentList Value;
};

MultiLevelTemplateArgumentListBox *unbox(CXMultiLevelTemplateArgumentList ML) {
  return static_cast<MultiLevelTemplateArgumentListBox *>(ML);
}

/// Copy a caller buffer of CXTemplateArgument handles into a fresh level of Box's storage
/// and return an ArrayRef over that copy. Args is a buffer of handles (pointers to
/// heap-boxed clang::TemplateArgument), not a contiguous value array (MARSHALLING.md
/// §11).
llvm::ArrayRef<clang::TemplateArgument> storeLevel(MultiLevelTemplateArgumentListBox *Box,
                                                   CXTemplateArgument Args,
                                                   unsigned NumArgs) {
  auto **Handles = static_cast<clang::TemplateArgument **>(Args);
  Box->Storage.emplace_back();
  std::vector<clang::TemplateArgument> &Level = Box->Storage.back();
  Level.reserve(NumArgs);
  for (unsigned I = 0; I < NumArgs; ++I)
    Level.push_back(*Handles[I]);
  return llvm::ArrayRef<clang::TemplateArgument>(Level.data(), Level.size());
}

} // namespace

CXMultiLevelTemplateArgumentList clang_MultiLevelTemplateArgumentList_create(void) {
  return std::make_unique<MultiLevelTemplateArgumentListBox>().release();
}

void clang_MultiLevelTemplateArgumentList_dispose(CXMultiLevelTemplateArgumentList ML) {
  delete unbox(ML);
}

void clang_MultiLevelTemplateArgumentList_setKind(CXMultiLevelTemplateArgumentList ML,
                                                  CXTemplateSubstitutionKind K) {
  unbox(ML)->Value.setKind(static_cast<clang::TemplateSubstitutionKind>(K));
}

CXTemplateSubstitutionKind
clang_MultiLevelTemplateArgumentList_getKind(CXMultiLevelTemplateArgumentList ML) {
  return static_cast<CXTemplateSubstitutionKind>(unbox(ML)->Value.getKind());
}

bool clang_MultiLevelTemplateArgumentList_isRewrite(CXMultiLevelTemplateArgumentList ML) {
  return unbox(ML)->Value.isRewrite();
}

unsigned
clang_MultiLevelTemplateArgumentList_getNumLevels(CXMultiLevelTemplateArgumentList ML) {
  return unbox(ML)->Value.getNumLevels();
}

unsigned clang_MultiLevelTemplateArgumentList_getNumSubstitutedLevels(
    CXMultiLevelTemplateArgumentList ML) {
  return unbox(ML)->Value.getNumSubstitutedLevels();
}

unsigned clang_MultiLevelTemplateArgumentList_getNumSubsitutedArgs(
    CXMultiLevelTemplateArgumentList ML, unsigned Depth) {
  return unbox(ML)->Value.getNumSubsitutedArgs(Depth);
}

unsigned clang_MultiLevelTemplateArgumentList_getNumRetainedOuterLevels(
    CXMultiLevelTemplateArgumentList ML) {
  return unbox(ML)->Value.getNumRetainedOuterLevels();
}

unsigned
clang_MultiLevelTemplateArgumentList_getNewDepth(CXMultiLevelTemplateArgumentList ML,
                                                 unsigned OldDepth) {
  return unbox(ML)->Value.getNewDepth(OldDepth);
}

CXTemplateArgument
clang_MultiLevelTemplateArgumentList_getArgument(CXMultiLevelTemplateArgumentList ML,
                                                 unsigned Depth, unsigned Index) {
  return const_cast<clang::TemplateArgument *>(&unbox(ML)->Value(Depth, Index));
}

CXDecl
clang_MultiLevelTemplateArgumentList_getAssociatedDecl(CXMultiLevelTemplateArgumentList ML,
                                                       unsigned Depth) {
  return unbox(ML)->Value.getAssociatedDecl(Depth).first;
}

bool clang_MultiLevelTemplateArgumentList_isAssociatedDeclFinal(
    CXMultiLevelTemplateArgumentList ML, unsigned Depth) {
  return unbox(ML)->Value.getAssociatedDecl(Depth).second;
}

bool clang_MultiLevelTemplateArgumentList_hasTemplateArgument(
    CXMultiLevelTemplateArgumentList ML, unsigned Depth, unsigned Index) {
  return unbox(ML)->Value.hasTemplateArgument(Depth, Index);
}

bool clang_MultiLevelTemplateArgumentList_isAnyArgInstantiationDependent(
    CXMultiLevelTemplateArgumentList ML) {
  return unbox(ML)->Value.isAnyArgInstantiationDependent();
}

void clang_MultiLevelTemplateArgumentList_setArgument(CXMultiLevelTemplateArgumentList ML,
                                                      unsigned Depth, unsigned Index,
                                                      CXTemplateArgument Arg) {
  unbox(ML)->Value.setArgument(Depth, Index, *static_cast<clang::TemplateArgument *>(Arg));
}

void clang_MultiLevelTemplateArgumentList_addOuterTemplateArguments(
    CXMultiLevelTemplateArgumentList ML, CXDecl AssociatedDecl, CXTemplateArgument Args,
    unsigned NumArgs, bool Final) {
  MultiLevelTemplateArgumentListBox *Box = unbox(ML);
  llvm::ArrayRef<clang::TemplateArgument> Level = storeLevel(Box, Args, NumArgs);
  Box->Value.addOuterTemplateArguments(static_cast<clang::Decl *>(AssociatedDecl), Level,
                                       Final);
}

void clang_MultiLevelTemplateArgumentList_replaceInnermostTemplateArguments(
    CXMultiLevelTemplateArgumentList ML, CXDecl AssociatedDecl, CXTemplateArgument Args,
    unsigned NumArgs) {
  MultiLevelTemplateArgumentListBox *Box = unbox(ML);
  llvm::ArrayRef<clang::TemplateArgument> Level = storeLevel(Box, Args, NumArgs);
  Box->Value.replaceInnermostTemplateArguments(static_cast<clang::Decl *>(AssociatedDecl),
                                               Level);
}

void clang_MultiLevelTemplateArgumentList_addOuterRetainedLevel(
    CXMultiLevelTemplateArgumentList ML) {
  unbox(ML)->Value.addOuterRetainedLevel();
}

void clang_MultiLevelTemplateArgumentList_addOuterRetainedLevels(
    CXMultiLevelTemplateArgumentList ML, unsigned Num) {
  unbox(ML)->Value.addOuterRetainedLevels(Num);
}

unsigned clang_MultiLevelTemplateArgumentList_getNumInnermostArgs(
    CXMultiLevelTemplateArgumentList ML) {
  return static_cast<unsigned>(unbox(ML)->Value.getInnermost().size());
}

CXTemplateArgument
clang_MultiLevelTemplateArgumentList_getInnermostArg(CXMultiLevelTemplateArgumentList ML,
                                                     unsigned I) {
  return const_cast<clang::TemplateArgument *>(&unbox(ML)->Value.getInnermost()[I]);
}

unsigned clang_MultiLevelTemplateArgumentList_getNumOutermostArgs(
    CXMultiLevelTemplateArgumentList ML) {
  return static_cast<unsigned>(unbox(ML)->Value.getOutermost().size());
}

CXTemplateArgument
clang_MultiLevelTemplateArgumentList_getOutermostArg(CXMultiLevelTemplateArgumentList ML,
                                                     unsigned I) {
  return const_cast<clang::TemplateArgument *>(&unbox(ML)->Value.getOutermost()[I]);
}

// begin
// end
// dump

// The box type above is file-local, so every other translation unit that has to hand a
// CXMultiLevelTemplateArgumentList to a clang API reaches the value through this accessor
// rather than redeclaring the layout. Declared in the private lib/Sema/CXTemplateBox.h.
clang::MultiLevelTemplateArgumentList &
extra::unboxMultiLevelTemplateArgumentList(CXMultiLevelTemplateArgumentList ML) {
  return unbox(ML)->Value;
}
