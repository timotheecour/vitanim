#[
D20201211T002220
]#

when true:
  # benchmark
  import std/times
  import std/threadutils # https://github.com/nim-lang/Nim/pull/16198
  # import timn/exp/once1
  import vitanim/once1

  var block1: Once
  initOnce(block1)

  template mainAux(algo) =
    block:
      proc bar(i: int, c: int): int =
        result = i
        template fn =
          echo (i, c)
          result += c
        if c >= 1234:
          when algo == "once(block1)":
            once(block1): fn()
          elif algo == "onceGlobal":
            onceGlobal: fn()
          elif algo == "onceThread":
            onceThread: fn()
          elif algo == "system.once":
            system.once: fn()
          else: static: doAssert false
      proc main =
        let n = 500_000_000
        var c = 0
        let t = cpuTime()
        for i in 0..<n:
          c+=bar(i, c)
        let t2 = cpuTime() - t
        echo (c, astToStr(algo), t2)
      for j in 0..<5:
        main()
  mainAux("once(block1)")
  mainAux("onceGlobal")
  mainAux("onceThread")
  mainAux("system.once")
