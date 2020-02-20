import std/[strformat,sets,times]
import std/[tables]

type Data*[Fun] = ref object
  index*: int
  fun*: Fun
  name*: string
  num*: int
  numIter*: int

  runtime*: float ## total time
  runtimePut*: float ## just for get
  runtimeGet*: float ## just for get
  runtimeContainsGood*: float ## just for get
  runtimeContainsBad*: float ## just for getNonexistant

  enableGet*: bool
  timeout*: float
  timeoutExceeded*: bool
  timeoutExceededIter*: int
  dupCheck*: bool
  inCount*: int
  samples*: seq[string]

proc toString(a: Data): string =
  var timeoutmsg = ""
  if a.timeoutExceeded:
    timeoutmsg = fmt:"timeoutAtIter: {a.timeoutExceededIter}"

  var runtimemsg = ""
  runtimemsg.add fmt" t: {a.runtime:10}"
  runtimemsg.add fmt" tPut: {a.runtimePut:10}"
  runtimemsg.add fmt" tGet: {a.runtimeGet:10}"
  runtimemsg.add fmt" tin1: {a.runtimeContainsGood:10}"
  runtimemsg.add fmt" tin2: {a.runtimeContainsBad:10}"

  result = fmt"[{a.index:2}] name: {a.name:20} num: {a.num} numIter: {a.numIter} {runtimemsg} {timeoutmsg:20}"
  for i in 0..<a.samples.len:
    result.add fmt" ex[{i}]: {a.samples[i]:20}"

template epochTime2(): untyped =
  when nimvm: 0.0 # epochTime not defined in vm; TODO
  else: times.epochTime()

proc runPerf*[Data](data: Data) =
  type T = type(data.fun(1))
  let n = data.num
  var keys: seq[T] # cache in case fun is random, etc
  var keysOther: seq[T]

  const useDupCache = false # unfortonately, since runs into issues like https://github.com/nim-lang/Nim/issues/13393 depending on which nim version is used, so we just disable this
  when useDupCache:
    var cache = initHashSet[T]()
  template maybeAdd(data, key) =
    when useDupCache:
      if key notin cache:
        cache.incl key
        data.add key
    else:
      data.add key

  let n2 = n
  for i in 0..<n:
    let key = data.fun(i)
    maybeAdd(keys, key)
    if i in [1, n div 2, n-1]:
      data.samples.add $key

  for i in n..<n+n2:
    let key = data.fun(i)
    maybeAdd(keysOther, key)

  let eTime1 = epochTime2()
  let deadline = eTime1 + data.timeout

  block outer:
    template handleTimeout(iter) =
      if epochTime2() > deadline:
        data.timeoutExceeded = true
        data.timeoutExceededIter = iter
        break outer

    for iter in 0..<data.numIter:
      var tab = initTable[T, T]()

      template testLoop(keysAux, fieldTime, fun) =
        let eTime = epochTime2()
        for i in 0..<n:
          handleTimeout(iter)
          let key = keysAux[i]
          fun(key)
        fieldTime = epochTime2() - eTime

      block:
        template funGet(key) = tab[key] = key
        testLoop(keys, data.runtimePut, funGet)

      if data.enableGet: # get on non-existant keys is more expensive
        block:
          template funGet(key) = doAssert tab[key] == key
          testLoop(keys, data.runtimeGet, funGet)

        block:
          template funGet(key) =
            let ok = key in tab
            data.inCount.inc
            # if data.dupCheck: doAssert ok

          testLoop(keys, data.runtimeContainsGood, funGet)
          testLoop(keysOther, data.runtimeContainsBad, funGet)

      # TODO: also test for deletions

  doAssert data.inCount >= 0 # prevent optimizing out

  data.runtime = epochTime2() - eTime1
  echo data.toString
