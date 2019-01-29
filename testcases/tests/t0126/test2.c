// char* hello_echo(char* message);
// void hello_echo(char* message);
void hello_echo();
int main() {
  for (int i = 0; i < 10000; i++) {
    // char* retval = hello_echo("hello");
    // hello_echo("hello");
    hello_echo();
  }
  return 0;
}
