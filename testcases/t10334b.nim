when defined case_normal:
  proc isUpperAscii*(c: char): bool = c in {'A'..'Z'}
elif defined case_inline:
  proc isUpperAscii*(c: char): bool {.inline.} = c in {'A'..'Z'}
elif defined case_template:
  template isUpperAscii*(c: char): bool = c in {'A'..'Z'}
elif defined case_generic_empty:
  proc isUpperAscii*[](c: char): bool = c in {'A'..'Z'}
elif defined case_generic:
  proc isUpperAscii*[T](c: T): bool = c in {'A'..'Z'}
else:
  static: doAssert false
