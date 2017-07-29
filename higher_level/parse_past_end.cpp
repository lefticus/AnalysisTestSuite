#include <string>

// expected: no static analysis errors

std::size_t find_newline(const std::string &t_str, std::size_t start) {
  while (t_str[start] != '\n') {
    ++start;
  }
  return start;
}


int main()
{
  return static_cast<int>(find_newline("Hello World", 2));
}
