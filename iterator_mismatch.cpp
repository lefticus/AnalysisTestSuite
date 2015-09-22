#include <vector>

int main()
{
  std::vector<int> v;
  std::vector<int> v2(2,4);
  std::vector<int> v3(3,4);

  v.insert(v.begin(), v2.begin(), v3.end());

}
