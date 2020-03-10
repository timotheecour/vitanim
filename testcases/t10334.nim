#[
KEY xyz
]#

when defined case_test:
  include system/timers
  when defined case_normal_same_module:
    proc isUpperAscii*(c: char): bool = c in {'A'..'Z'}
  else:
    import t10334b

  func toLowerAsciiInPlace2*(s: var string) {.inline.} =
    const k = ord('a') - ord('A')
    for c in mitems(s):
      c = chr(c.ord + k * ord(c.isUpperAscii))
  proc main()=
    let n = 10_000_000
    let m = 1000
    var s = newString(m)
    var dt = 0.Nanos
    var x = 0
    for i in 0..<n:
      for j in 0..<m: s[j] = cast[char](i +% j) # generate fresh input to avoid trivial branch prediction
      let t = getTicks()
      toLowerAsciiInplace2(s)
      let t2 = getTicks()
      dt += t2-t
      x+=ord(s[^1]) + s.len # prevent optimizing out
    doAssert x > 0
    echo dt.float*1e-9
  main()
else:
  import os, strformat
  proc fun(opt: string) =
    const nim = getCurrentCompilerExe()
    let input = currentSourcePath
    let cmd = fmt"{nim} c -r --skipParentCfg --skipUserCfg --hints:off -d:danger -d:case_test {opt} {input}"
    # echo cmd
    # echo opt
    write(stdout, opt, ": ")
    flushFile(stdout)
    doAssert execShellCmd(cmd) == 0

  for opt in [
    "-d:case_normal_same_module",
    "-d:case_normal",
    "-d:case_inline",
    "-d:case_generic",
    "-d:case_generic_empty",
    "-d:case_template",
    ]:
    fun opt
