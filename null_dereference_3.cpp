#include <memory>

void null_dereference_3()
{
  std::shared_ptr<int> i;
  // dereferencing obviously null value
  *i = 5;
}

int main()
{
  null_dereference_3();
}
