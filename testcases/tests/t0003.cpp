/*
D20181202T213158
D20181203T013931
*/

// import segfaults
#include <iostream>
#include <stdio.h>

int main (int argc, char *argv[]) {
  int*x = nullptr;
  try{
    auto y = *x;
    std::cout << y << std::endl;
  } catch(...){
    std::cout << "in catch" << std::endl;
  }
  std::cout << "after" << std::endl;
  return 0;
}
