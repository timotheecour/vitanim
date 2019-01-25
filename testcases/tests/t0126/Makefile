# NIMBASE = ~/lib/Nim/lib/nimbase.h
NIMBASE = $nimc_D/lib/nimbase.h

.PHONY: run

run: a.out
	./a.out

a.out: test.cpp csrc/clib.cpp csrc/nimbase.h
	g++ -Icsrc test.cpp

csrc/clib.cpp: clib.nim
	nim cpp --checks:on -d:traceGC --memTracker:on -d:memProfiler -d:lineDir -d:leakDetector -d:useSysAssert -d:useGcAssert --header --nimcache:csrc --compileOnly ./clib.nim

csrc/nimbase.h: $(NIMBASE) csrc/clib.cpp
