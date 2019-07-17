#[
KEY D20190624T193837 murmur

## without -d:danger
nim c -r -d:case_with_murmur $vitanim_D/testcases/tests/t0129.nim
(d0: 0.2829601764678955, d1: 0.2505824565887451)
nim c -r -d:case_with_bytewiseHashing $vitanim_D/testcases/tests/t0129.nim
(d0: 0.3149974346160889, d1: 0.4005148410797119)
nim c -r $vitanim_D/testcases/tests/t0129.nim
(d0: 41.01707029342651, d1: 32.43865561485291)

## with -d:danger
nim c -r -d:danger -d:case_with_murmur $vitanim_D/testcases/tests/t0129.nim
(d0: 0.07308745384216309, d1: 0.09539008140563965)
nim c -r -d:danger -d:case_with_bytewiseHashing $vitanim_D/testcases/tests/t0129.nim
(d0: 0.07447385787963867, d1: 0.1173701286315918)
nim c -r -d:danger $vitanim_D/testcases/tests/t0129.nim
(d0: 1.630150318145752, d1: 0.9602768421173096)

## with -d:danger -d:case_long_random_key, ie, using long random keys
nim c -r -d:danger -d:case_long_random_key -d:case_with_murmur $vitanim_D/testcases/tests/t0129.nim
(d0: 0.1081044673919678, d1: 0.1406888961791992)
nim c -r -d:danger -d:case_long_random_key -d:case_with_bytewiseHashing $vitanim_D/testcases/tests/t0129.nim
(d0: 0.1358921527862549, d1: 0.2246723175048828)
nim c -r -d:danger -d:case_long_random_key $vitanim_D/testcases/tests/t0129.nim
(d0: 0.1195473670959473, d1: 0.1329538822174072)
]#

import std/[hashes,oids,tables,strutils, times]
import std/math
import ../../murmur/murmur
import pkg/sysrandom

when defined(case_with_murmur):
  proc hash*(x: string): Hash {.inline.} = toHashMurmur3(x.string)[0].Hash

when defined(case_with_hash_silly):
  proc hash*(x: string): Hash {.inline.} =
    result = toHashMurmur3("asdf")[0].Hash
    # echo result

when defined(case_with_bytewiseHashing):
  proc hash*(x: string): Hash {.inline.} = bytewiseHashing(result, x, 0, high(x))

proc main()=
  var t: Table[string, string]
  let n = 100_000
  var keys: seq[string]

  var d0, d1: float

  for i in 0..<n:
    when defined(case_long_random_key):
      let key = getRandomString(100)
    else:
      let key = $genOid()
    var t0 = epochTime()
    t[key] = "val:" & key
    d0 += epochTime() - t0
    keys.add key

  var dummy = 0
  let t0 = epochTime()

  for i in 0..<4: # repeat 4 times
    for key in keys:
      var t0 = epochTime()
      let val = t[key]
      d1 += epochTime() - t0
      dummy += val.len
      doAssert val == "val:" & key # sanity check
  
  echo (d0: d0, d1: d1)
  doAssert dummy > 0 # prevent optimizing out

main()
