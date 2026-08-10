#include "clang-ex/Analysis/CXCallGraph.h"
#include "utils.h"
#include "clang/AST/Decl.h"
#include "clang/AST/DeclBase.h"
#include "clang/AST/Expr.h"
#include "clang/Analysis/CallGraph.h"
#include "llvm/Support/raw_ostream.h"
#include <memory>
#include <string>

// CallGraph

CXCallGraph clang_CallGraph_create(void) {
  return reinterpret_cast<CXCallGraph>(std::make_unique<clang::CallGraph>().release());
}

void clang_CallGraph_dispose(CXCallGraph CG) {
  delete reinterpret_cast<clang::CallGraph *>(CG);
}

void clang_CallGraph_addToCallGraph(CXCallGraph CG, CXDecl D) {
  reinterpret_cast<clang::CallGraph *>(CG)->addToCallGraph(
      reinterpret_cast<clang::Decl *>(D));
}

bool clang_CallGraph_includeInGraph(CXDecl D) {
  return clang::CallGraph::includeInGraph(reinterpret_cast<clang::Decl *>(D));
}

bool clang_CallGraph_includeCalleeInGraph(CXDecl D) {
  return clang::CallGraph::includeCalleeInGraph(reinterpret_cast<clang::Decl *>(D));
}

CXCallGraphNode clang_CallGraph_getNode(CXCallGraph CG, CXDecl D) {
  return reinterpret_cast<CXCallGraphNode>(
      reinterpret_cast<clang::CallGraph *>(CG)->getNode(
          reinterpret_cast<clang::Decl *>(D)));
}

CXCallGraphNode clang_CallGraph_getOrInsertNode(CXCallGraph CG, CXDecl D) {
  return reinterpret_cast<CXCallGraphNode>(
      reinterpret_cast<clang::CallGraph *>(CG)->getOrInsertNode(
          reinterpret_cast<clang::Decl *>(D)));
}

// begin / end

unsigned clang_CallGraph_size(CXCallGraph CG) {
  return reinterpret_cast<clang::CallGraph *>(CG)->size();
}

CXCallGraphNode clang_CallGraph_getRoot(CXCallGraph CG) {
  return reinterpret_cast<CXCallGraphNode>(
      reinterpret_cast<clang::CallGraph *>(CG)->getRoot());
}

// nodes_iterator / const_nodes_iterator

CXString clang_CallGraph_printAsString(CXCallGraph CG) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::CallGraph *>(CG)->print(OS);
  return extra::makeCXString(OS.str());
}

void clang_CallGraph_dump(CXCallGraph CG) {
  reinterpret_cast<clang::CallGraph *>(CG)->dump();
}

// viewGraph

void clang_CallGraph_addNodesForBlocks(CXCallGraph CG, CXDeclContext D) {
  reinterpret_cast<clang::CallGraph *>(CG)->addNodesForBlocks(
      reinterpret_cast<clang::DeclContext *>(D));
}

// VisitFunctionDecl / VisitObjCMethodDecl / TraverseStmt / shouldWalkTypesOfTypeLocs /
// shouldVisitTemplateInstantiations / shouldVisitImplicitCode

void clang_CallGraph_getNodes(CXCallGraph CG, CXCallGraphNode *Buf, unsigned N) {
  if (!Buf)
    return;
  unsigned I = 0;
  for (auto &Entry : *reinterpret_cast<clang::CallGraph *>(CG)) {
    if (I >= N)
      break;
    Buf[I++] = reinterpret_cast<CXCallGraphNode>(Entry.second.get());
  }
}

// CallGraphNode

// begin / end / callees

bool clang_CallGraphNode_empty(CXCallGraphNode N) {
  return reinterpret_cast<clang::CallGraphNode *>(N)->empty();
}

unsigned clang_CallGraphNode_size(CXCallGraphNode N) {
  return reinterpret_cast<clang::CallGraphNode *>(N)->size();
}

CXCallGraphNode clang_CallGraphNode_getCallee(CXCallGraphNode N, unsigned I) {
  clang::CallGraphNode *Node = reinterpret_cast<clang::CallGraphNode *>(N);
  return reinterpret_cast<CXCallGraphNode>((Node->begin() + I)->Callee);
}

CXExpr clang_CallGraphNode_getCallExpr(CXCallGraphNode N, unsigned I) {
  clang::CallGraphNode *Node = reinterpret_cast<clang::CallGraphNode *>(N);
  return reinterpret_cast<CXExpr>((Node->begin() + I)->CallExpr);
}

void clang_CallGraphNode_addCallee(CXCallGraphNode N, CXCallGraphNode Callee,
                                   CXExpr CallExpr) {
  reinterpret_cast<clang::CallGraphNode *>(N)->addCallee(
      clang::CallGraphNode::CallRecord(reinterpret_cast<clang::CallGraphNode *>(Callee),
                                       reinterpret_cast<clang::Expr *>(CallExpr)));
}

CXDecl clang_CallGraphNode_getDecl(CXCallGraphNode N) {
  return reinterpret_cast<CXDecl>(reinterpret_cast<clang::CallGraphNode *>(N)->getDecl());
}

CXFunctionDecl clang_CallGraphNode_getDefinition(CXCallGraphNode N) {
  clang::Decl *D = reinterpret_cast<clang::CallGraphNode *>(N)->getDecl();
  if (!D)
    return nullptr;
  clang::FunctionDecl *FD = D->getAsFunction();
  if (!FD)
    return nullptr;
  return reinterpret_cast<CXFunctionDecl>(FD->getDefinition());
}

CXString clang_CallGraphNode_printAsString(CXCallGraphNode N) {
  std::string S;
  llvm::raw_string_ostream OS(S);
  reinterpret_cast<clang::CallGraphNode *>(N)->print(OS);
  return extra::makeCXString(OS.str());
}

void clang_CallGraphNode_dump(CXCallGraphNode N) {
  reinterpret_cast<clang::CallGraphNode *>(N)->dump();
}
