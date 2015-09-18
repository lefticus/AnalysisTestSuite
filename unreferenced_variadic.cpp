#include <vector>

template<typename T>
T add(T t, T u)
{
  return t + u;
}

template<typename ... T>
std::vector<int> add_values(int value, T ... t)
{
  return {add(t, value)...};
}

int main()
{
  // expected: no warnings or errors in this code
  add_values(4);
  add_values(4, 1);
  add_values(4, 1, 2);
}
