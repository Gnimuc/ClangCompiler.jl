add_subdirectory(AST)
add_subdirectory(Basic)
add_subdirectory(CodeGen)
add_subdirectory(Driver)
add_subdirectory(Frontend)
add_subdirectory(Interpreter)
add_subdirectory(Lex)
add_subdirectory(Parse)
add_subdirectory(Sema)

target_sources(clangex PRIVATE ${CMAKE_CURRENT_LIST_DIR}/libclangex.cpp)

target_sources(clangex PRIVATE ${CMAKE_CURRENT_LIST_DIR}/utils.cpp)
target_sources(clangex PRIVATE ${CMAKE_CURRENT_LIST_DIR}/utils.h)