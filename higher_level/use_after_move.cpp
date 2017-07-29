#include <string>
#include <vector>
#include <utility>


struct Data {
  int x; int y;
  std::string name;
};
int main() {
  std::vector<Data> vec;
  Data d{1,2,"Object"};
  vec.push_back(std::move(d));
  d.x = 15;
}
