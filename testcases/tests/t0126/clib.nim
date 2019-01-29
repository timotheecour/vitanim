import strformat
import strutils
import sequtils

echo "clib initialized"
echo GC_getStatistics()

var s0 = "foobar"
var s1 = s0.cstring

# proc hello_echo*(message:cstring) {.exportc.} =
proc hello_echo*() {.exportc.} =
  echo GC_getStatistics()
  # let ret = s1
  # echo "ok"
  # when defined(case1):
  #   var s_message = $message
  #   result = &"{s_message} echo"
  #   echo &"Nim echo result: {result}"
  # else:
  #   result = s1

proc hello_echo_bak1*(message:cstring):cstring {.exportc.} =
  ## Echo a message back
  echo GC_getStatistics()
  when defined(case1):
    var s_message = $message
    result = &"{s_message} echo"
    echo &"Nim echo result: {result}"
  else:
    result = s1

# proc main()=
#   for i in 0..<10000:
#     char* retval = hello_echo("hello");
# main()
