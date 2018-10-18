# drange
Nim adaptation of D ranges (see http://ddili.org/ders/d.en/ranges.html)

## status
Proof of concept works (see `nimble test`)

More advanced usage is currently blocked by [blocker for implementing D ranges in Nim · Issue #9422 · nim-lang/Nim](https://github.com/nim-lang/Nim/issues/9422)
```nim
nimble c -d:case1 tests/test1.nim
# fails
```
