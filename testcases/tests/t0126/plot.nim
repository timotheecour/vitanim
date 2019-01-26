import plotly, strutils, os, sequtils, nimpy

proc main =
  const fname = "/tmp/D20190124T204416/log.txt"
  let lines = fname.readFile.strip.splitLines

  var y = newSeq[int]()
  for a in lines:
    if not a.startswith("[GC] occupied memory:"):
      continue
    y.add a.split[3].parseInt
  #echo y

  let nMax = 100
  if y.len > nMax:
    y.setLen nMax

  let x = toSeq(0 .. y.high)
  scatterPlot(x, y)
    .ylabel("[GC] occupied memory:")
    .show()
  # but if you have to use matplotlib ;)
  let plt = pyImport("matplotlib.pyplot")
  discard plt.plot(y, linestyle="", marker="o")
  discard plt.ylabel("[GC] occupied memory:")
  discard plt.show()

when isMainModule:
  main()
