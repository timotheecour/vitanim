/*
D20181202T213158

https://stackoverflow.com/questions/18606468/segmentation-fault-in-sigaction-signal-handler
*/

// import segfaults
#include <iostream>
#include <stdio.h>
#include <signal.h>


void sighandler(int signum){
  printf("Caught signal:%d pressed ctrl+c!!\n",signum);
}

int main (int argc, char *argv[]) {
  struct sigaction act_h;
  struct sigaction old_act;

  //reset all members
  memset(&act_h, 0, sizeof(act_h));
  act_h.sa_handler = sighandler;
  act_h.sa_flags = SA_RESTART;

  sigaction(SIGINT,&act_h,&old_act);

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
