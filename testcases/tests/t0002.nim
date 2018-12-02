#[
KEY cligen
[keyword arguments to dispatch should work if they're passed as const variables · Issue #66 · c-blake/cligen](https://github.com/c-blake/cligen/issues/66)
]#

import cligen

proc main(age = 23, foo: seq[string])=
  discard

when defined(case1):
  # works:
  dispatch(main, positional = "<AUTO>")

when defined(case2):
  # BUG: fails:
  # Error: requested positional argument catcher mypositional is not in formal parameter list
  const mypositional = "<AUTO>"
  dispatch(main, positional = mypositional)

when defined(case3):
  # BUG: silently ignores `myhelp`
  const myhelp = { "age" : "comment age" }
  dispatch(main, help = myhelp)

when defined(case4):
  # works
  dispatch(main, help = { "age" : "comment age" })
