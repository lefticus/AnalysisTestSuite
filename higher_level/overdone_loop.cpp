#include <vector>
#include <iostream>


void print_vector(std::vector<int> t_vec) {
  for (std::vector<int>::iterator itr = t_vec.begin();
       itr != t_vec.end();
       ++itr) {
    std::cout << *itr;
  }
}

int main() {
  print_vector({1,2,3,4});
}

