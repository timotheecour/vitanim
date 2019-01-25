import strformat
import strutils
import sequtils

echo "clib initialized"
echo GC_getStatistics()

var s0 = "foobar"
var s1 = s0.cstring
proc hello_echo*(message:cstring):cstring {.exportc.} =
  ## Echo a message back
  echo GC_getStatistics()
  when defined(case1):
    var s_message = $message
    result = &"{s_message} echo"
    echo &"Nim echo result: {result}"
  else:
    result = s1

