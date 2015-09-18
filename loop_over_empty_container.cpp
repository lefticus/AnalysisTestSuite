#include <vector>
#include <iostream>

int main()
{
  std::vector<int> v;

  // For the sake of this test, the vector is empty. Can anyone catch that?
  for (const auto &o : v)
  {
    std::cout << o << '\n';
  }
}
