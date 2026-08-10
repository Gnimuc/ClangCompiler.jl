#include "clang-ex/Frontend/CXMultiplexConsumer.h"
#include <memory>
#include <vector>
#include "clang/AST/ASTConsumer.h"
#include "clang/Frontend/MultiplexConsumer.h"

CXASTConsumer clang_MultiplexConsumer_create(CXASTConsumer *Consumers,
                                             unsigned NumConsumers) {
  std::vector<std::unique_ptr<clang::ASTConsumer>> Children;
  Children.reserve(NumConsumers);
  for (unsigned I = 0; I < NumConsumers; ++I)
    Children.emplace_back(reinterpret_cast<clang::ASTConsumer *>(Consumers[I]));
  std::unique_ptr<clang::ASTConsumer> MC =
      std::make_unique<clang::MultiplexConsumer>(std::move(Children));
  return reinterpret_cast<CXASTConsumer>(MC.release());
}
