#include <iostream>
#include <vector>

namespace foo {

namespace bar {

typedef int(f)(void);

int ff() { return 42; }

} // namespace bar

} // namespace foo

namespace bar {

double g() { return 3.1415926; }

} // namespace bar

int main(void) {
  std::cout << "bar::g(): " << bar::g() << std::endl;
  return 0;
}