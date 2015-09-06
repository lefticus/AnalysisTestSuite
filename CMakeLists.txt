cmake_minimum_required(VERSION 2.8)

if(NOT ${CMAKE_VERSION} VERSION_LESS "3.1")
  cmake_policy(SET CMP0054 NEW)
endif()



project(AnalysisTestSuite)

if(MSVC)
  add_definitions(/W4)
else()
  add_definitions(-std=c++11)
  add_definitions(-Wall -Wextra -Wshadow -Wnon-virtual-dtor -Wold-style-cast -Wcast-align -Wcast-qual -Wunused -Woverloaded-virtual  -pedantic )

  if("${CMAKE_CXX_COMPILER_ID}" STREQUAL "Clang")
    add_definitions(-Weverything -Wno-c++98-compat -Wno-missing-prototypes)
  endif()


endif()


add_executable(null_dereference_1 null_dereference_1.cpp )
add_executable(null_dereference_2 null_dereference_2.cpp )
add_executable(use_after_move use_after_move.cpp )
add_executable(duplicate_branch_1 duplicate_branch_1.cpp )
add_executable(duplicate_branch_2 duplicate_branch_2.cpp )
add_executable(capture_local_by_reference capture_local_by_reference.cpp )
add_executable(capture_local_uninitialized capture_local_uninitialized.cpp )
add_executable(capture_local_uninitialized_by_ref capture_local_uninitialized_by_ref.cpp )
add_executable(assert_with_side_effects assert_with_side_effects.cpp )
add_executable(loss_of_sign loss_of_sign.cpp )
add_executable(loss_of_precision loss_of_precision.cpp )
add_executable(loss_of_sign_and_precision loss_of_sign_and_precision.cpp )
add_executable(binary_search binary_search.cpp )




