#[
MOVED from $timn_D/bugs/stdlib/t22_lldb_execCmdEx.nim
BUG:can't debug (with lldb) a nim binary that calls execCmdEx
[debugging (eg w lldb) a nim program crashes at the 1st call to `execCmdEx` · Issue #9634 · nim-lang/Nim](https://github.com/nim-lang/Nim/issues/9634)

## links
$timn_D/tests/D/t09.d

##
rnim -d:case1 $nim_D/vitanim/testcases/tests/t22_lldb_execCmdEx.nim
# note: works fine with -d:case2 (ie, execCmd)

lldb /tmp/nim//app
(lldb) target create "/tmp/nim//app"
Traceback (most recent call last):
  File "<input>", line 1, in <module>
  File "/Users/timothee/homebrew/Cellar/python@2/2.7.15_1/Frameworks/Python.framework/Versions/2.7/lib/python2.7/copy.py", line 52, in <module>
    import weakref
  File "/Users/timothee/homebrew/Cellar/python@2/2.7.15_1/Frameworks/Python.framework/Versions/2.7/lib/python2.7/weakref.py", line 14, in <module>
    from _weakref import (
ImportError: cannot import name _remove_dead_weakref
Current executable set to '/tmp/nim//app' (x86_64).
(lldb) r
Process 98697 launched: '/tmp/nim/app' (x86_64)
ok1b.1
/Users/timothee/git_clone/nim/timn/bugs/stdlib/t22_lldb_execCmdEx.nim(12) t22_lldb_execCmdEx
/Users/timothee/git_clone/nim/timn/bugs/stdlib/t22_lldb_execCmdEx.nim(9) test
/Users/timothee/git_clone/nim/Nim/lib/pure/osproc.nim(1330) execCmdEx
/Users/timothee/git_clone/nim/Nim/lib/pure/streams.nim(280) readLine
/Users/timothee/git_clone/nim/Nim/lib/pure/streams.nim(162) readChar
/Users/timothee/git_clone/nim/Nim/lib/pure/streams.nim(87) readData
/Users/timothee/git_clone/nim/Nim/lib/pure/streams.nim(413) fsReadData
/Users/timothee/git_clone/nim/Nim/lib/system/sysio.nim(80) checkErr
/Users/timothee/git_clone/nim/Nim/lib/system/sysio.nim(72) raiseEIO
/Users/timothee/git_clone/nim/Nim/lib/system.nim(2970) sysFatal
Error: unhandled exception: Unknown IO Error [IOError]
Process 98697 exited with status = 1 (0x00000001)
(lldb) ^D


]#
import osproc

proc test=
  echo "ok1b.1"
  when defined(case1):
    let temp = "echo foo".execCmdEx()
  elif defined(case2):
    let temp = "echo foo".execCmd()
  else:
    let temp = ""
  echo "ok1b.2"
  echo temp
test()

