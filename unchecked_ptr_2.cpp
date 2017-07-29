
void use_unchecked_ptr(int *p)
{
  *p = 52;
}

int main()
{
  use_unchecked_ptr(nullptr);
}

