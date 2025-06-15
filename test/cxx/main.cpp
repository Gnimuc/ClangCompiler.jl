#include <iostream>
#include <vector>

struct Node {
    int x;
    float y;
};

class Foo {
  int x;
public:
  Foo() : x(0) {}
  Foo(int x) : x(x) {}
};

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
