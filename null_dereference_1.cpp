
namespace null_dereference_1 {
  void null_dereference_1()
  {
    int *i = nullptr;
    *i = 5;
  }
}

int main()
{
  null_dereference_1::null_dereference_1();
}
