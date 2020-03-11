#[
D20200309T211522
# when defined case_with_custom_ticks:
#   include system/timers

[new std/timers module for high performance / low overhead timers and benchmarking (formerly system/timers include) by timotheecour · Pull Request #13617 · nim-lang/Nim : new std/timers module for high performance / low overhead timers and benchmarking (formerly system/timers include) by timotheecour · Pull Request #13617 · nim-lang/Nim](https://github.com/nim-lang/Nim/pull/13617)
]#

when defined case1:
  # include system/timers
  # import t10333b
  import std/timers
  import std/monotimes
  import times
  import strutils
  proc toSeconds(a: Nanos): float = a.float*1e-9
  proc toSeconds(a: float): float = a
  proc toSeconds(a: Duration): float = a.nanoseconds.float*1e-9
  template test(fun)=
    block:
      proc main()=
        let n = 10_000_000
        type T = type(fun()-fun())
        var dt: T
        for i in 0..<n:
          let t = fun()
          # code to benchmark here (intentionally empty)
          let t2 = fun()
          dt += t2-t
        echo "\n" & astToStr(fun) & ":"
        echo ("total secs", dt.toSeconds)
        echo ("ns/iter", (dt.toSeconds * 1e9 / n.float).formatEng)
        echo ("iters per sec", (n.float / dt.toSeconds).formatEng)
      main()
  # test(cpuTime)
  test(getMonoTime)
  test(getTicks)
