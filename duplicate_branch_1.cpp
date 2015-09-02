
namespace duplicate_branch_1 {
  bool test_value_1() { return true; }


  bool duplicate_branch_1()
  {
    if (test_value_1()) {
      return true;
    } else {
      return true;
    }
  }

}

int main()
{
  duplicate_branch_1::duplicate_branch_1();
}
