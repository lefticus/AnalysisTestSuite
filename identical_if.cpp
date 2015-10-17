#include<cstdio>

int identical_if(const int value)
{
  int result = 0;

  if (value == 0)
  {
    result = 1;
  }
  // Should get a warning here.
  if (value == 0)
  {
      result = 3;
  }
  return result;
}

int main(int /*argc*/, char **/*argv*/)
{
  int output = identical_if(2);
  printf("Output is %d.\n", output);
  return 0;
}
