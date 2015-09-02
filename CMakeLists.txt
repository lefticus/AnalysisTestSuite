cmake_minimum_required(VERSION 2.8)

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.1")
  cmake_policy(SET CMP0054 NEW)
endif()



project(AnalysisTestSuite)

if(MSVC)
  add_definitions(/W4)
  add_definitions(/analyze)
else()
  add_definitions(-std=c++11)
  add_definitions(-Wall -Wextra -Wshadow -Wnon-virtual-dtor -Wold-style-cast -Wcast-align -Wcast-qual -Wunused -Woverloaded-virtual  -pedantic )

  if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    add_definitions(-Weverything)
  endif()

endif()


add_executable(use_after_move use_after_move.cpp )
add_executable(duplicate_branch_1 duplicate_branch_1.cpp )
add_executable(duplicate_branch_2 duplicate_branch_2.cpp )


