import std/[strformat,sets,times]
import std/[tables]

type Data*[Fun] = ref object
  index*: int
  fun*: Fun
  name*: string
  num*: int
  numIter*: int
  runtime*: float
  enableGet*: bool
  enableGetNonexistant*: bool
  timeout*: float
  timeoutExceeded*: bool
  timeoutExceededIter*: int
  dupCheck*: bool
  notinCount*: int
  samples*: seq[string]

proc toString(a: Data): string =
  var timeoutmsg = ""
  if a.timeoutExceeded:
    timeoutmsg = fmt:"timeoutAtIter: {a.timeoutExceededIter}"
  result = fmt"[{a.index:2}] name: {a.name:20} num: {a.num} numIter: {a.numIter} runtime: {a.runtime:20} {timeoutmsg:20}"
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
      for i in 0..<n:
        handleTimeout(iter)
        let key = keys[i]
        tab[key] = key

      if data.enableGet:
        for i in 0..<n:
          handleTimeout(iter)
          let key = keys[i]
          doAssert key in tab
          doAssert tab[key] == key

      if data.enableGetNonexistant: # get on non-existant keys is more expensive
        for i in 0..<n:
          handleTimeout(iter)
          let key = keysOther[i]
          let ok = key notin tab
          if not ok:
            data.notinCount.inc
            if data.dupCheck:
              doAssert key notin tab

      # TODO: also test for deletions

  doAssert data.notinCount >= 0 # prevent optimizing out

  let eTime2 = epochTime2()
  data.runtime = eTime2 - eTime1
  echo data.toString
