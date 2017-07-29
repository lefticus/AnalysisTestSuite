#include <cstdint>

std::int8_t get_value(std::int8_t val)
{
  return val <<= 8;
}


int main()
{
  return get_value(1);
}

