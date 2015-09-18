#include <memory>

std::shared_ptr<int> get_i() {
  return nullptr;
}

void null_dereference_2() 
{
  auto i = get_i();
  *i = 5;
}

int main()
{
  null_dereference_2();
}
