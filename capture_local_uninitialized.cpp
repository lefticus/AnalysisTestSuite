#include <functional>
#include <iostream>

std::function<void ()> capture_local_uninitialized()
{
  int some_value;

  return [some_value](){ std::cout << some_value << '\n'; };
}

int main()
{
  const auto f = capture_local_uninitialized();
  f();
}
