#include <functional>
#include <iostream>

std::function<void ()> capture_local_uninitialized_by_ref()
{
  int some_value;

  return [&some_value](){ std::cout << some_value << '\n'; };
}

int main()
{
  const auto f = capture_local_uninitialized_by_ref();
  f();
}
