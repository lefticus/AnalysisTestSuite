
int get_value()
{
  int *ptr = new int(42);
  return *ptr;
}

int main()
{
  return get_value();
}
