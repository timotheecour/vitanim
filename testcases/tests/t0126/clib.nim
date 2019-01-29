proc hello_echo*() {.exportc.} =
  echo GC_getStatistics()

proc main()=
  for i in 0..<300:
    hello_echo()

main()
