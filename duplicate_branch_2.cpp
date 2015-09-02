
namespace duplicate_branch_2 {
  bool test_value_1() { return true; }
  bool test_value_2() { return true; }


  bool duplicate_branch_2()
  {
    if (test_value_1()) {

      if (test_value_2()) {
        return true;
      }

      return true;
    }

    return false;
  }

}

int main()
{
  duplicate_branch_2::duplicate_branch_2();
}
