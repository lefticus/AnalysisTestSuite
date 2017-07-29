#include <string>
#include <vector>
#include <utility>

struct Data {
  int x; int y;
  std::string name;
  ~Data() {}
};
int main() {
  std::vector<Data> vec;
  const Data d{1,2,"Object"};
  vec.push_back(std::move(d));
}


