#include <string>
#include <cstdint>

// expected: no static analysis errors

std::size_t find_newline(const std::string &t_str, std::size_t start) {
  while (t_str[start] != '\n') {
    ++start;
  }
  return start;
}

extern "C" int LLVMFuzzerTestOneInput(const std::uint8_t *Data, size_t Size) {
  find_newline(std::string(reinterpret_cast<const char *>(Data), Size), 0);
  return 0;  // Non-zero return values are reserved for future use.
}

