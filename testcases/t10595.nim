#[
D20200420T233301

nim c -d:case2 --passl:-Wl,-no_pie testcases/t10595.nim

--passl:-Wl,-no_pie make addresses deterministic:

$vitanim_D/testcases/t10595
0x100065060
0x100066050
0x100066cd0
0x7ffeefbfb280
]#

when defined case1:
  type
    TFoo = object
      x1: int
      x2: pointer
      x3: seq[Foo]
      x4: ptr TFoo
    Foo = ref TFoo

  template fun() =
    var z = 0
    var a = Foo(x1: 1, x2: z.addr)
    a.x3 = @[nil, a, Foo()]
    a.x4 = a[].addr
    echo a[]

  fun()
  static: fun()

when defined case2:
  type Foo = ref object
    x1: int
    x2: seq[float]
  proc main()=
    var a = "abc"
    echo a[0].addr
    let n = 100
    var f = Foo()
    echo f
    var z: seq[Foo]
    for i in 0..<n:
      let b = Foo()
      if i>0:
        b.x2 = z[i-1].x2 & i.float
      z.add b
    echo $z[^1]
    var u = 1
    echo u.addr

  main()
