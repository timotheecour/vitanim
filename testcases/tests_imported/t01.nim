# [lldb can't continue on NilAccessError · Issue #9753 · nim-lang/Nim](https://github.com/nim-lang/Nim/issues/9753)

import segfaults

proc main =
  try:
    var x: ptr int
    echo x[]
  except NilAccessError:
    echo "caught a crash!"

echo "ok1"
main()
echo "ok2"
