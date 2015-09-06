#include <vector>
#include <iostream>

int main()
{
  std::vector<int> v;

  // this is bad because it limits the loop to 2^31 elements
  for (int l = 0; l < v.size(); ++l)
  {
    std::cout << v[l] << '\n';
  }
}
