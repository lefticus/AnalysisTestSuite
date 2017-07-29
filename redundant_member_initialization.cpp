#include <string>


struct S
{
  // expected: warning redundant member initialization code
  std::string value;
  int num;

  S() : value("Hello World"), num(0) 
  { }

  S(const int t_num) 
    : value("Hello World"), num(t_num) 
  { }

};

int main()
{
}


