#[
KEY xyz

nim r -d:case3 -d:danger $vitanim_D/testcases/t10975.nim

case1 4.37
case2 2.241
case3 26.51
]#

import times
let file = "/tmp/z03.log"

proc prepareData()=
  let t=cpuTime()
  let n = 1_000_000
  let f = open(file, fmWrite)
  defer: close(f)
  const m = 100
  # const m = 1
  for i in 0..<n:
    for j in 0..<m:
      write(f, $i)
    write(f, "\n")
  echo "Time for write: ", cpuTime() - t

proc fgetln(stream: File, len: var csize_t): cstring {.importc.}

when defined case3:
  import faststreams/inputs
  import faststreams/textio

proc lines2[Fun](file: string, fun: Fun) =
  #[
  TODO:
  use iterator
  customize whether to keep EOL (if any)
  ]#
  let f = open(file)
  defer: close(f)
  var s2: string
  while true:
    var n = 0.csize_t
    let s = fgetln(f, n)
    #[
    TODO: proper error handling
    > The fgetln() function does not distinguish between end-of-file and error; the routines feof(3) and ferror(3) must be used to determine which occurred.
    ]#
    if s == nil: break
    s2.setLen n
    for i in 0..<n: s2[i] = s[i]
    fun(s2)

proc readData()=
  let n = 10
  let t=cpuTime()
  var m = 0
  for i in 0..<n:
    proc fun(s: string) =
      # echo (s,)
      m += s.len
    when defined case1:
      for x in lines(file):
        fun(x)
    elif defined case2:
      lines2(file, fun)
    elif defined case3:
      let f = fileInput(file)
      # while f.readable:
      var count = 0
      for x in textio.lines(f, keepEol = false):
      # for x in textio.lines(f, keepEol = true): # BUG: goes on forever
        fun(x)
    else:
      static: doAssert false
  let t2 = cpuTime() - t
  echo (file, m, t2)

proc main()=
  prepareData()
  readData()
main()
