#[
KEY murmur

nim c -r -d:case_with_murmur $vitanim_D/testcases/tests/t0129.nim
1.5 seconds

nim c -r $vitanim_D/testcases/tests/t0129.nim
45 seconds
]#

import std/[hashes,oids,tables,strutils]
import std/math
import ../../murmur/murmur

when defined(case_with_murmur):
  proc hash*(x: string): Hash {.inline.} = toHashMurmur3(x.string)[0].Hash

proc main()=
  var t: Table[string, string]
  let n = 100_000
  var keys: seq[string]
  for i in 0..<n:
    let key = $genOid()
    t[key] = $i
    keys.add key

  var dummy = 0
  for key in keys:
    let val = t[key]
    dummy += val.len
  echo dummy

main()
