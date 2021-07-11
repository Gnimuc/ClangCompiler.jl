#include <iostream>

extern "C" void mycppfunction() {   
  int z = 0;
  int y = 5;
  int x = 10;
  z = x*y + 2;
  std::cout << "The number is " << z << std::endl;
}
