#include <iostream>
// #include "csrc/clib.h"
using namespace std;

// N_CDECL(void, NimMain)(void);

extern "C"
char* hello_echo(char* message);

std::string echo(std::string arg) {
    const char* message = arg.c_str();
    cout << "C++ passing message: " << message << "\n";
    cout << "C++ message addr: " << (void*)message << "\n";
    char* retval = hello_echo(
        (char *)(message)
    );
    cout << "C++ retval addr : " << (void*)retval << "\n";
    return std::string(retval);
}

int main() {
    // NimMain();
    cout << "Hello world\n";
    int i = 0;
    for (i = 0; i < 1000; i++) {
        std::string msg = std::string("Hello");
        std::string ret = echo(msg);
        cout << "Got reply: " << ret << "\n";
    }
    return 0;
}
