#include <stdio.h>

template<typename T>
void f(T&& t){
    puts(__PRETTY_FUNCTION__);
}

int main(void) {
  int x = 20;
  f(x);
  return 0;
}