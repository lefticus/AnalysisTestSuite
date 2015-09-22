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
add_executable(null_dereference_3 null_dereference_3.cpp )
add_executable(null_dereference_4 null_dereference_4.cpp )
add_executable(null_dereference_5 null_dereference_5.cpp )
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
add_executable(unreachable_code unreachable_code.cpp )
add_executable(unreachable_code_2 unreachable_code_2.cpp )
add_executable(unreferenced_variadic unreferenced_variadic.cpp )
add_executable(loop_over_empty_container loop_over_empty_container.cpp )
add_executable(invalid_loop_arguments invalid_loop_arguments.cpp )
add_executable(std_array_out_of_bounds std_array_out_of_bounds.cpp )
add_executable(array_out_of_bounds array_out_of_bounds.cpp )
add_executable(reassigned_pointer reassigned_pointer.cpp )
add_executable(iterator_mismatch iterator_mismatch.cpp )
add_executable(reference_to_temporary reference_to_temporary.cpp )




