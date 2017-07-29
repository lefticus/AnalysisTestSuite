#include <utility>
#include <string>

void move_const()
{
  const std::string s;
  std::string s2(std::move(s));
  s2 = "Hello World";
}

int main()
{
  move_const();
}
