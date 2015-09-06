#include <vector>
#include <iostream>

// adapted from http://googleresearch.blogspot.no/2006/06/extra-extra-read-all-about-it-nearly.html
uint64_t binarySearch(const std::vector <int64_t> &v, int64_t key) {
  int low = 0;
  int high = v.size() - 1; // loss of precision 


  while (low <= high) {
    int mid = (low + high) / 2;  
    int64_t midVal = v[mid];   // What happens with > 2B objects?

    if (midVal < key) {
      low = mid + 1;
    } else if (midVal > key) {
      high = mid - 1;
    } else {
      return mid; // key found
    }
  }

  return -(low + 1); // key not found. What if negative?
}

int main()
{
  return binarySearch(std::vector<int64_t>{1,2,3,4,5}, 2);
}
