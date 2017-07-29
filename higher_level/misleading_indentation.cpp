#include <cstdlib>
#include <iostream>

int main(const int argc, const char *[])
{
  if (argc > 2)
    std::cout << "Error: Not Enough Args\n";
    return EXIT_FAILURE;

  return EXIT_SUCCESS;
}
