#[
KEY xyz
RESOLVED
]#
import strutils

proc formatHuman(a: string): string =
  if a.len == 0: return ""
  var isSimple = true
  for ai in a:
    # avoid ~ which, if given via `--foo ~bar`, is expanded by shell
    # avoid , (would cause confusion bc of separator syntax)
    if ai notin {'a'..'z'} + {'A'..'Z'} + {'0'..'9'} + {'-', '_', '.', '@', ':', '=', '+', '^', '/'}:
      isSimple = false
      break
  if isSimple:
    result = a
  else:
    result.addQuoted a

proc main()=
  # print newSeq[string]()
  # print @[""]
  echo formatHuman "abc"
  echo formatHuman "abc@gmail.com+="
  echo formatHuman "abc,def"
  echo formatHuman "aBc"
  echo formatHuman "ab c"
  echo formatHuman "a'bc"
  echo formatHuman "a\nbc"
  echo formatHuman "a\"bc"

main()
