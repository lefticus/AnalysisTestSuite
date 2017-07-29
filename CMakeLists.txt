cmake_minimum_required(VERSION 3.1)

cmake_policy(SET CMP0054 NEW)
cmake_policy(SET CMP0037 NEW)



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




add_executable(array_out_of_bounds array_out_of_bounds.cpp)
add_executable(assert_with_side_effects assert_with_side_effects.cpp)
add_executable(binary_search binary_search.cpp)
add_executable(bit_shift_1 bit_shift_1.cpp)
add_executable(bit_shift_2 bit_shift_2.cpp)
add_executable(bit_shift_3 bit_shift_3.cpp)
add_executable(capture_local_by_reference capture_local_by_reference.cpp)
add_executable(capture_local_uninitialized_by_ref capture_local_uninitialized_by_ref.cpp)
add_executable(capture_local_uninitialized capture_local_uninitialized.cpp)
add_executable(confusing_indentation confusing_indentation.cpp)
add_executable(duplicate_branch_1 duplicate_branch_1.cpp)
add_executable(duplicate_branch_2 duplicate_branch_2.cpp)
add_executable(empty empty.cpp)
add_executable(invalid_loop_arguments invalid_loop_arguments.cpp)
add_executable(iterator_mismatch iterator_mismatch.cpp)
add_executable(loop_over_empty_container loop_over_empty_container.cpp)
add_executable(loss_of_precision loss_of_precision.cpp)
add_executable(loss_of_sign_and_precision loss_of_sign_and_precision.cpp)
add_executable(loss_of_sign loss_of_sign.cpp)
add_executable(member_reassignment member_reassignment.cpp)
add_executable(memory_leak memory_leak.cpp)
add_executable(move_const move_const.cpp)
add_executable(null_dereference_1 null_dereference_1.cpp)
add_executable(null_dereference_2 null_dereference_2.cpp)
add_executable(null_dereference_3 null_dereference_3.cpp)
add_executable(null_dereference_4 null_dereference_4.cpp)
add_executable(null_dereference_5 null_dereference_5.cpp)
add_executable(reassigned_pointer reassigned_pointer.cpp)
add_executable(redundant_member_initialization redundant_member_initialization.cpp)
add_executable(rule_of_zero rule_of_zero.cpp)
add_executable(std_array_out_of_bounds std_array_out_of_bounds.cpp)
add_executable(unchecked_ptr unchecked_ptr.cpp)
add_executable(unchecked_ptr_2 unchecked_ptr_2.cpp)
add_executable(unreachable_code_2 unreachable_code_2.cpp)
add_executable(unreachable_code unreachable_code.cpp)
add_executable(unreferenced_variadic unreferenced_variadic.cpp)
add_executable(use_after_move use_after_move.cpp)


add_executable(higher_level.overdone_loop higher_level/overdone_loop.cpp)
add_executable(higher_level.null_ptr_assign higher_level/null_ptr_assign.cpp)
add_executable(higher_level.use_after_move higher_level/use_after_move.cpp)
add_executable(higher_level.expensive_copies higher_level/expensive_copies.cpp)
add_executable(higher_level.over_bit_shifted higher_level/over_bit_shifted.cpp)
add_executable(higher_level.infinite_loop higher_level/infinite_loop.cpp)
add_executable(higher_level.misleading_indentation higher_level/misleading_indentation.cpp)
add_executable(higher_level.parse higher_level/parse.cpp)
add_executable(higher_level.parse_past_end higher_level/parse_past_end.cpp)




