#include <functional>
#include <iostream>

std::function<void ()> capture_local_uninitialized_by_ref()
{
  int some_value;

  // local some_value is used uninitialized and is captured by reference
  return [&some_value](){ std::cout << some_value << '\n'; };
}

int main()
{
  const auto f = capture_local_uninitialized_by_ref();
  f();
}
