#[
RESOLVED => see D20190407T015205
MOVED from $timn_D/bugs/stdlib/t22_lldb_execCmdEx.nim

BUG:can't debug (with lldb) a nim binary that calls execCmdEx
[debugging (eg w lldb) a nim program crashes at the 1st call to `execCmdEx` · Issue #9634 · nim-lang/Nim](https://github.com/nim-lang/Nim/issues/9634)

## links
$timn_D/tests/D/t09.d

##
rnim -d:case1 $nim_D/vitanim/testcases/tests/t0001.nim
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
import streams

import timn/basics

proc test=
  echo "ok1b.1"
  let cmd = "echo foo"
  when defined(case1):
    let temp = cmd.execCmdEx()
  elif defined(case2):
    let temp = cmd.execCmd()
  elif defined(case3):
    # [[WIP] [do not merge] fix #9953 by timotheecour · Pull Request #9963 · nim-lang/Nim](https://github.com/nim-lang/Nim/pull/9963)
    # var p = startProcess(command = cmd, options={poStdErrToStdOut,poEvalCommand,poParentStreams})
    let temp = execCmdEx(command = cmd, options={poStdErrToStdOut,poEvalCommand,poParentStreams})
  elif defined(case4):
    var temp=""
    var p = startProcess(command = cmd, options={poStdErrToStdOut, poEvalCommand, poParentStreams})
    # var p = startProcess(command = cmd, options={poStdErrToStdOut, poEvalCommand})
    defer: close(p)
    let sub = outputStream(p)
    var line: string
    while true:
      let more = readLine(sub, line)
      temp.add line
      if not more: break
  else:
    let temp = ""
  echo "ok1b.2"
  echo temp
test()

