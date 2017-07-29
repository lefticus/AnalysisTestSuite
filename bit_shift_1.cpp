#include <cstdint>

int get_value()
{
  std::uint8_t val = 1;
  val <<= 8;
  return val;
}


int main()
{
  return get_value();
}

