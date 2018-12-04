/*
D20181202T213158

## links
ADAPTED https://gist.github.com/fairlight1337/55978671ace2c75020eddbfbdd670221
https://github.com/google/glog/blob/master/m4/pc_from_ucontext.m4
https://github.com/xoreaxeaxeax/sandsifter/issues/3
https://github.com/facebook/react-native/issues/19839
https://thisissecurity.stormshield.com/2015/01/03/playing-with-signals-an-overview-on-sigreturn-oriented-programming/

-fnon-call-exceptions https://stackoverflow.com/questions/1717991/throwing-an-exception-from-within-a-signal-handler
*/

// This code installs a custom signal handler for the SIGSEGV signal
// (segmentation fault) and then purposefully creates a segmentation
// fault. The custom handler `handler` is then entered, which now
// increases the instruction pointer by 1, skipping the current byte
// of the faulty instruction. This is done for as long as the faulty
// instruction is still active; in the below case, that's 2 bytes.

// Note: This is for 64 bit systems. If you prefer 32 bit, change
// `REG_RIP` to `REG_EIP`. I didn't bother putting an appropriate
// `#ifdef` here.


#include <iostream>

#include <string.h>
#include <signal.h>

#include <signal.h>
#include <string.h>
#include <unistd.h>
#include <sys/ucontext.h>

std::runtime_error* gex = 0;

extern "C" void BREAK(){ // TODO: volatile to prevent optimizing out?

}
void handler(int nSignum, siginfo_t* si, void* vcontext) {
  std::cout << "Segmentation fault:v1" << std::endl;
  BREAK();
  ucontext_t* context = (ucontext_t*)vcontext;
  std::cout << "Segmentation fault:v2" << std::endl;
  // context->uc_mcontext.gregs[REG_RIP]++;
  // context->uc_mcontext->gregs[REG_RIP]++;

  // ((ucontext_t*)p)->uc_mcontext.gregs[IP]+=UD2_SIZE;
  // ((ucontext_t*)p)->uc_mcontext->__ss.__rip+=UD2_SIZE;
  
  // context->uc_mcontext->__ss.__rip++;
  context->uc_mcontext->__ss.__rip+=2;// better
  // context->uc_mcontext->__ss.__srr0+=2;// better
  // context->uc_mcontext->__ss.__rip+=-5;
  // context->uc_mcontext->__ss.__rip+=4;
  // throw std::runtime_error("v3");


   try{
    // throw new std::runtime_error("v5");
    throw std::runtime_error("v5");
   // } catch(std::runtime_error* e){
   } catch(const std::runtime_error& e){
    std::cout << "in catch in handler " << std::endl;
  }
  throw std::runtime_error("v6");
  // throw gex;
}


int main() {
  // gex = new std::runtime_error("v7");
  std::cout << "Start" << std::endl;
  
  struct sigaction action;
  memset(&action, 0, sizeof(struct sigaction));
  // action.sa_flags = SA_NODEFER;
  // action.sa_flags = SA_SIGINFO;
  action.sa_flags = SA_NODEFER|SA_SIGINFO;
  action.sa_sigaction = handler;
  sigaction(SIGSEGV, &action, NULL);
  
  int* x = 0;

  try{
    // throw std::runtime_error("v3.1");
    int y = *x;
  } catch(const std::runtime_error& e){
  // } catch(std::runtime_error* e){
    std::cout << "in catch" << std::endl;
  }
  
  std::cout << "End" << std::endl;
  
  return 0;
}
