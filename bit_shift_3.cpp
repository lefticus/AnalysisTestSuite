#include <cstdint>

std::int8_t shift(std::int8_t times)
{
  std::int8_t val = 1;
  val <<= (6 + times);
  return val;
}


int main(const int argc, const char *[])
{
  return shift(argc);
}

