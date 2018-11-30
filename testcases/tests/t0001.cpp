/*
MOVED FROM $timn_D/tests/cpp/t54_lldb_system.cpp

[debugging (eg w lldb) a nim program crashes at the 1st call to `execCmdEx` · Issue #9634 · nim-lang/Nim](https://github.com/nim-lang/Nim/issues/9634)
https://stackoverflow.com/questions/478898/how-to-execute-a-command-and-get-output-of-command-within-c-using-posix
*/

#include <cstdio>
#include <iostream>
#include <memory>
#include <stdexcept>
#include <string>
#include <array>

std::string exec(const char* cmd) {
    std::array<char, 128> buffer;
    std::string result;
    std::shared_ptr<FILE> pipe(popen(cmd, "r"), pclose);
    if (!pipe) throw std::runtime_error("popen() failed!");
    while (!feof(pipe.get())) {
        if (fgets(buffer.data(), 128, pipe.get()) != nullptr)
            result += buffer.data();
    }
    return result;
}

int main(){
  auto ret = exec("date");
  std::cout << "ret:" << ret << std::endl;
}
