#[
KEY cligen ,SV

## D20181130T094211:here DPSV doesn't work:
this doesn't work:
nim c -r -d:DPSV -d:case1a /Users/timothee/git_clone//nim//vitanim/testcases/tests/t0000.nim --a :foo1:foo2
@["foo1:foo2"]

## D20181130T093828:here cligen accepts invalid code:
nim c -r -d:case1a /Users/timothee/git_clone//nim//vitanim/testcases/tests/t0000.nim --a@=foo
@["foo"]

## D20181130T093940:here cligen += doesn't work with ,SV:
nim c -r -d:case1a /Users/timothee/git_clone//nim//vitanim/testcases/tests/t0000.nim --a+=foo1,foo2,foo3
@["foo1", "foo1foo2", "foo1foo2foo3"]

## D20181130T094043:here cligen doesn't distinguish bw `a: seq[int]` and `a: seq[string]` (etc)
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


## D20181130T094445:here `a: seq[string]` treamtment not consistent with `a: T` for other non-seq types T, in that it becomes positional arg
instead, how about requiring an option (in dispatch) for making a seq become positional?
]#

import cligen

when defined(case1a):
  # how to have args that contain `,` ? DPSV doesn't seem to work
  proc main(a: seq[string] = @[])=
    echo a

when defined(case1b):
  proc main(a: seq[string])=
    echo a

when defined(case2a):
  proc main(a: seq[int])=
    echo a

when defined(case2b):
  proc main(a: seq[string])=
    echo a

when defined(case4):
  proc main(a: float)=
    echo a

when defined(DPSV):
  let d = "<D>"
  dispatch(main, delimit=d)
else:
  dispatch(main)
