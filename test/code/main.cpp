#include <iostream>
#include <vector>

int main() {   
  int x = 40;
  int y = 2;
  int z = x + y;
  std::cout << "The number is " << z << std::endl;
  return z;
}

float sum(std::vector<float> &data) {
  float acc = 0;
  for (float v : data)
    acc += v;
  return acc;
}
