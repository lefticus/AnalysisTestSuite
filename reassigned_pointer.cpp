#include <memory>

int main()
{
  auto s = std::make_shared<int>(1);

  int *p = s.get();
  *p = 1;

  s = std::make_shared<int>(2);
  *p = 5;

}
