#[
KEY cligen ,SV

## D20181130T094445:here `a: seq[string]` treamtment not consistent with `a: T` for other non-seq types T, in that it becomes positional arg
instead, how about requiring an option (in dispatch) for making a seq become positional?


## D20181130T094211:here RESOLVED DPSV doesn't work:
this doesn't work:
nim c -r -d:DPSV -d:case1a /Users/timothee/git_clone//nim//vitanim/testcases/tests/t0000.nim --a :foo1:foo2
@["foo1:foo2"]

## D20181130T093828:here RESOLVED cligen accepts invalid code:
nim c -r -d:case1a /Users/timothee/git_clone//nim//vitanim/testcases/tests/t0000.nim --a@=foo
@["foo"]

## D20181130T093940:here RESOLVED cligen += doesn't work with ,SV:
nim c -r -d:case1a /Users/timothee/git_clone//nim//vitanim/testcases/tests/t0000.nim --a+=foo1,foo2,foo3
@["foo1", "foo1foo2", "foo1foo2foo3"]

## D20181130T094043:here RESOLVED cligen doesn't distinguish bw `a: seq[int]` and `a: seq[string]` (etc)
nim c -r -d:case2a /Users/timothee/git_clone//nim//vitanim/testcases/tests/t0000.nim -h
Usage:
  main [optional-params] [a]
  Options(opt-arg sep :|=|spc):
  -h, --help      write this help to stdout

nim c -r -d:case2b /Users/timothee/git_clone//nim//vitanim/testcases/tests/t0000.nim -h
Usage:
  main [optional-params] [a]
  Options(opt-arg sep :|=|spc):
  -h, --help      write this help to stdout

## D20181130T150307:here RESOLVED positional="" doesn't work as workaround for https://github.com/c-blake/cligen/issues/61
rnim -d:case9 -d:nopositional $nim_D/vitanim/testcases/tests/t0000.nim -h
nim c -r -d:case9 -d:nopositional /Users/timothee/git_clone//nim//vitanim/testcases/tests/t0000.nim -h
Usage:
  main [required&optional-params] [foo3]
  Options(opt-arg sep :|=|spc):
  -h, --help                     write this help to stdout
  -f=, --foo1=  int    REQUIRED  set foo1
  --foo2=       float  REQUIRED  set foo2

## D20181130T172327:here
default values should escape \n for `seq[string]` (already works for `string`)
rnim -d:case13 $nim_D/vitanim/testcases/tests/t0000.nim -h
nim c -r -d:case13 /Users/timothee/git_clone//nim//vitanim/testcases/tests/t0000.nim -h
Usage:
  main [required&optional-params]
  Options(opt-arg sep :|=|spc):
  -h, --help                             write this help to stdout
  -f=, --foo1=  int          REQUIRED    set foo1
  --foo2=       ,SV[string]  abc
  def     set foo2
  --foo3=       string       "abc\ndef"  set foo3

## D20181202T120530:here
impossible to set a seq to empty
rnim -d:case14 $vitanim_D/testcases/tests/t0000.nim --foo1=
nim c -r -d:case14 /Users/timothee/git_clone//nim//vitanim//testcases/tests/t0000.nim --foo1=
(Field0: @[""])

## D20181204T102517:here
rnim -d:case15 $nim_D/vitanim/testcases/tests/t0000.nim -h
nim c -r -d:case15 $vitanim_D/testcases/tests/t0000.nim -h
Error: duplicate case label
    proc main(h = "bar")=
              ^


## D20181130T174608:here
the default value formatting for seq is not good:
* newlines are not escaped (see D20181130T172327)
  * @[""] prints as nothing_at_all (for DPSV, <D>)
  * @[] prints as EMPTY (for DPSV, EMPTY, which is not super consistent)
* it's neither DRY (DPSV or ,SV is repeated in every seq entry) nor standard notation

rnim -d:case11 $nim_D/vitanim/testcases/tests/t0000.nim -h
nim c -r -d:case11 /Users/timothee/git_clone//nim//vitanim/testcases/tests/t0000.nim -h
Usage:
  main [required&optional-params]
  Options(opt-arg sep :|=|spc):
  -h, --help                            write this help to stdout
  -f=, --foo1=  int          REQUIRED   set foo1
  --foo2=       float        REQUIRED   set foo2
  --foo3=       ,SV[string]  baz1,baz2  set foo3
  --foo4=       ,SV[string]  EMPTY      set foo4
  --foo5=       ,SV[string]             set foo5
  --foo6=       ,SV[int]     EMPTY      set foo6
  --foo7=       ,SV[int]     10         set foo7
  --foo8=       string       ""         set foo8

rnim -d:DPSV -d:case11 $nim_D/vitanim/testcases/tests/t0000.nim -h
nim c -r -d:DPSV -d:case11 /Users/timothee/git_clone//nim//vitanim/testcases/tests/t0000.nim -h
Usage:
  main [required&optional-params]
  Options(opt-arg sep :|=|spc):
  -h, --help                                  write this help to stdout
  -f=, --foo1=  int           REQUIRED        set foo1
  --foo2=       float         REQUIRED        set foo2
  --foo3=       DPSV[string]  <D>baz1<D>baz2  set foo3
  --foo4=       DPSV[string]  EMPTY           set foo4
  --foo5=       DPSV[string]  <D>             set foo5
  --foo6=       DPSV[int]     EMPTY           set foo6
  --foo7=       DPSV[int]     <D>10           set foo7
  --foo8=       string        ""              set foo8

## D20181203T173521:here `./main -f` fails even though `./main -f:` or `./main -f=` or `./main --foo` works
rnim -d:case10 $nim_D/vitanim/testcases/tests/t0000.nim -f
nim c -r -d:case10 /Users/timothee/git_clone//nim//vitanim/testcases/tests/t0000.nim -f

argument expected for option `f` at end of params
argument expected for option `` at end of params
Unknown short option: ""

Run with --help for full usage.
Error: execution of an external program failed: '/tmp/nim//app -f'


## 
rnim -d:case5 $nim_D/vitanim/testcases/tests/t0000.nim -h
nim c -r -d:case5 /Users/timothee/git_clone//nim//vitanim/testcases/tests/t0000.nim -h
Warning: cligen only supports one seq param for positional args; using `a1`, not `a2`. [User]


## TODO: escaping arbitrary cmd (cf DPSV)

## test for grep: -foobart

]#

import cligen

when defined(case1a):
  proc main(a: seq[string] = @[])=
    echo a

when defined(case1b):
  proc main(a: seq[string])=
    echo a

when defined(case2a):
  proc main(foo: seq[int])=
    echo foo

when defined(case2b):
  proc main(foo: seq[string])=
    echo foo

when defined(case2c):
  proc main(foo: seq[float])=
    echo foo

when defined(case4):
  proc main(a: float)=
    echo a

when defined(case5):
  proc main(a1: seq[string], a2: seq[string])=
    echo (a1, a2)

when defined(case5b):
  proc main(a1: seq[string], a2: seq[string])=
    echo (a1, a2)

when defined(case6):
  proc main(a1: seq[string] = @[], a2: seq[int] = @[], a3: seq[int])=
    echo (a1, a2, a3)

when defined(case7):
  type mystring_foobar = string
  proc main(a0: float, a1: seq[mystring_foobar] = @[], a2: seq[int] = @[])=
    echo (a1, a2)

when defined(case8):
  proc main(foo: string)=
    echo (foo)

when defined(case9):
  proc main(foo1: int, foo2: float, foo3: seq[string])=
    echo (foo1, foo2, foo3)

when defined(case10):
  proc main(foo: seq[string] = @["baz"])=
    echo (foo)

when defined(case10b):
  proc main(foo: seq[string] = @["baz"], goo: seq[string] = @["gaz"], a=false, b=false, c=false)=
    echo (foo, goo, a, b, c)

when defined(case11):
  proc main(foo1: int, foo2: float, foo3: seq[string] = @["baz1", "baz2"], foo4: seq[string] = @[], foo5: seq[string] = @[""], foo5b: seq[string] = @["", ""], foo6: seq[int] = @[], foo7: seq[int] = @[10], foo8="", foo9 = "abc+=@./def", foo10 = "abc def", zam = true, bam = "asdf") =
    echo foo3

when defined(case11b):
  proc main(foo1 = 10, coo = 0.0, foo3: seq[string] = @["baz1", "baz2"], foo4: seq[string] = @[], foo5: seq[string] = @[""], foo5b: seq[string] = @["", ""], foo6: seq[int] = @[], foo7: seq[int] = @[10], foo8="", foo9 = "abc+=@./def", foo10 = "abc def", zam = true, bam = "asdf") =
    echo foo3

when defined(case11c):
  proc main(foo = @["baz1", "baz2", "baz1"]) =
    echo foo

when defined(case12):
  let myDefault2 = block:
    var ret = ""
    for i in 0..<100:
      ret.add "arg" & $i & "\n"
    ret
  let myDefault3 = block:
    var ret: seq[string]
    for i in 0..<10:
      ret.add "arg" & $i & "\n"
    ret
  proc main(foo1: int, foo2 = myDefault2, foo3 = myDefault3)=
    discard

when defined(case13):
  proc main(foo1: int, foo2 = @["abc\ndef"], foo3 = "abc\ndef") = discard

when defined(case14):
  proc main(foo1 = @["abc", "def"])=
    echo (foo1,)

when defined(case15):
  # test h flag
  proc main(h = "bar")=
    echo (h,)

# PENDING https://github.com/c-blake/cligen/issues/66
# when defined(nopositional):
#   let positional = ""
# else:
#   # let positional = "<AUTO>"
#   let positional = "a3"

when defined(DPSV):
  let d = "<D>"
  dispatch(main, delimit=d, positional=positional)
elif defined(delimiter_SPACE):
  let d = " "
  dispatch(main, delimit=d, positional=positional)
elif defined(nopositional):
  dispatch(main, delimit=d, positional="")
elif defined(badHelpKey):
  # RESOLVED now gives CT error
  dispatch(main, help={ "badkey" : "asdf" }, positional=positional)
else:
  dispatch(main)
