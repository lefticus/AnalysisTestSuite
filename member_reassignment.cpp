#include <string>

struct S
{
  std::string value;

  S() : value("Hello World") 
  {
    // expected: warn on reassignment
    value = "Hello Other World";
  }
};

int main()
{
}

