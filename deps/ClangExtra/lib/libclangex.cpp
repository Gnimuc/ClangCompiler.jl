#include "clang-ex/libclangex.h"
#include "clang/AST/Stmt.h"

void clang_Stmt_EnableStatistics(void) { clang::Stmt::EnableStatistics(); }

void clang_Stmt_PrintStats(void) { clang::Stmt::PrintStats(); }