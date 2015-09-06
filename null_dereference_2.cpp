
namespace null_dereference_2 {

  int *get_i() {
    return nullptr;
  }

  void null_dereference_2() 
  {
    int *i = get_i();
    // dereferencing returned null value
    *i = 5;
  }
}

int main()
{
  null_dereference_2::null_dereference_2();
}
