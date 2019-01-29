#include <iostream>

extern "C"
char* hello_echo(char* message);

int main() {
    for (int i = 0; i < 10000; i++) {
        // std::string msg = std::string("Hello");
        char* retval = hello_echo("hello");
        // std::string ret = echo(msg);
        // cout << "Got reply: " << ret << "\n";
    }
    return 0;
}
