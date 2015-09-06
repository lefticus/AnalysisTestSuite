#include <vector>
#include <iostream>

int main()
{
  std::vector<int> v;

  // this is bad because it limits the loop to 2^32 elements
  for (unsigned l = 0; l < v.size(); ++l)
  {
    std::cout << v[l] << '\n';
  }
}
