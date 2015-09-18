#include <cassert>

bool assert_with_side_effects(int &i)
{
  ++i;
  return i < 10;
}

int main()
{
  int i = 0;

  // this is bad because behavior changes between debug and release builds
  assert(assert_with_side_effects(i));

  if (i < 5) { /* ... */ }
}
