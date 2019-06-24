#[
D20190407T015205:here
MOVED from $timn_D/bugs/stdlib/t22_lldb_execCmdEx.nim

BUG:can't debug (with lldb) a nim binary that calls execCmdEx
[debugging (eg w lldb) a nim program crashes at the 1st call to `execCmdEx` · Issue #9634 · nim-lang/Nim](https://github.com/nim-lang/Nim/issues/9634)

[Calls to fgets should be retried when error is EINTR · Issue #7632 · neovim/neovim](https://github.com/neovim/neovim/issues/7632)

[Re: EINTR](https://lists.gnu.org/archive/html/bug-gnulib/2011-07/msg00020.html)

[⚙ D47643 Rewrite JSON dispatcher loop using C IO (FILE*) instead of std::istream.](https://reviews.llvm.org/D47643)
/// We use C-style FILE* for reading as std::istream has unclear interaction
/// with signals, which are sent by debuggers on some OSs.


When a debugger attached on MacOS, the
// process received EINTR, the stream went bad, and clangd exited.
// A retry-on-EINTR loop around reads solved this problem, but caused clangd to
// sometimes hang rather than exit on other OSes. The interaction between
// istreams and signals isn't well-specified, so it's hard to get this right.
// The C APIs seem to be clearer in this respect.

TODO: fix readLine => fgets?
proc readLine*(s: Stream, line: var TaintedString): bool =


[#568149 - zlib: please allow resuming after EINTR - Debian Bug report logs](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=568149)


[linux - When to check for EINTR and repeat the function call? - Stack Overflow](https://stackoverflow.com/questions/4959524/when-to-check-for-eintr-and-repeat-the-function-call/4960077#4960077)


[c - Are interrupt signals dispatched during fread() and fwrite() library calls? - Stack Overflow](https://stackoverflow.com/questions/53245721/are-interrupt-signals-dispatched-during-fread-and-fwrite-library-calls)

Interrupts can occur during the fread() and fwrite() functions (and during the read() and write() system calls — there's no way to stop that. 

On all systems, when a signal handler has the SA_RESTART flag cleared,
   not only the read() system call will fail with EINTR, but also an fread()
   call will fail and set the stream's error bit.


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

A:https://github.com/timotheecour/Nim/commit/422da6c0a3c73176a90f2e41fc5c221eb455cc9d

proc readBuffer*(f: File, buffer: pointer, len: Natural): int {.
  tags: [ReadIOEffect], benign.} =
  ## reads `len` bytes into the buffer pointed to by `buffer`. Returns
  ## the actual number of bytes that have been read which may be less than
  ## `len` (if not as many bytes are remaining), but not greater.
  while true:
    result = c_fread(buffer, 1, len, f)
    if result == len: return result
    when not defined(NimScript):
      if errno == EINTR:
        errno = 0
        c_clearerr(f)
        continue
    checkErr(f)
    break



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

