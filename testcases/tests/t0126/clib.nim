proc hello_echo*() {.exportc.} =
  echo GC_getStatistics()

proc main()=
  # warmup period => no short term leak
  for i in 0..<300:
    hello_echo()

main()
