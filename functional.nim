#[
]#

import macros
#[
TODO: do a nim RFC to make ForLoopStmt more flexible by accepting more args, eg:
`macro takeN(x: ForLoopStmt, n: int): untyped =` is currently not allowed
so we work around by passing a tuple
]#

macro takeN(x: ForLoopStmt): untyped =
  var body = x[^1]
  let inputs = x[^2][1]
  doAssert inputs.len == 2
  let elems = inputs[0]
  let maxIter = inputs[1]
  let count = genSym(nskVar, "count")
  expectKind x, nnkForStmt
  body.add quote do:
    `count`.dec
    if `count` == 0: break
  var newFor = newTree(nnkForStmt)
  for i in 0..x.len-3: newFor.add x[i]
  newFor.add elems
  newFor.add body
  result = quote do:
    var `count` = `maxIter`
    if `count` > 0: `newFor`
  echo result.repr

when isMainModule:
  {.push experimental: "forLoopMacros".}
  import tables, sequtils
  proc main =
    var t = toTable({1:1, 2:2, 3:3, 4:4})
    echo t
    for b in takeN (pairs(t), 1+1): echo b
    for a,b in takeN (pairs(t), 1+1): echo (k: a, v:b)
    # echo toSeq(takeN (pairs(t), 2)) # limitation: we can't compose
  main()
