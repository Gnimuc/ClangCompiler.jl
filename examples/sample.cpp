#include <iostream>

int main() {
  float x = 15000;
  float y = x >= 3.6 ? 3.6 : x; 
  std::cout << y << ", not great, not terrible." << std::endl;
  return 0;
}
