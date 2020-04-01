# D20200331T180615
import dom

# import dom except `$`
# when defined case_bug:
#   proc `$`*(s: Selection): string = $(s.toString())

proc handleSelection1(a: cstring) =
  echo ("fun1", a)

proc handleSelection2(a: Selection) =
  echo ("fun2", a)
  let b = $a # BUG here
  echo ("fun2b", b)

proc fun1*() {.exportc.} =
  handleSelection1(document.getSelection())

proc fun2*() {.exportc.} =
  handleSelection2(document.getSelection())
