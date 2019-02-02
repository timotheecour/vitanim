# RFC: `import npkg foo bar` =  resolves npkg to root of containing nimble package

## clean way to have tests point to correct dir in nimble tests:
$nim_D/wrappers/tests/config.nims
switch("path", "$projectDir/../src")

## RFC: customize special vars in import eg:
import "$repo"/foo/bar
import "$npkg"/foo/bar # current nimble package
import "$foo"/foo/bar # customizable (how? nim.cfg in parent dir => will that be guaranteed to be read even if main project is outside)

## RFC/QQ: can parent nim.cfg files for a bar/foo be read if the main project file is outside `bar` nimble pkg?
* would fix [gemm_strided: error: always_inline function '_mm256_setzero_pd' requires target feature 'xsave' · Issue #22 · numforge/laser](https://github.com/numforge/laser/issues/22)
* would fix [config.nims hack prevents using `nim c somewrapper` from outside nimterop repo · Issue #21 · nimterop/wrappers](https://github.com/nimterop/wrappers/issues/21)
note: should work also with:
external.nim:
foo/bar.nim:
import foo/bar2 # this needs to be reliable regardless how foo/bar is imported / included (including via abspath, and including if another version of pkg foo is the main one installed)

import "/pathto/foo/bar.nim"


