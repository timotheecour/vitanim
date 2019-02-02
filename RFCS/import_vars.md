## RFC/QQ: can parent nim.cfg files for a bar/foo be read if the main project file is outside `bar` nimble pkg?
* would fix [gemm_strided: error: always_inline function '_mm256_setzero_pd' requires target feature 'xsave' · Issue #22 · numforge/laser](https://github.com/numforge/laser/issues/22)
* would fix [config.nims hack prevents using `nim c somewrapper` from outside nimterop repo · Issue #21 · nimterop/wrappers](https://github.com/nimterop/wrappers/issues/21)
note: should work also with:
external.nim:
foo/bar.nim:
import foo/bar2 # this needs to be reliable regardless how foo/bar is imported / included (including via abspath, and including if another version of pkg foo is the main one installed)

import "/pathto/foo/bar.nim"


