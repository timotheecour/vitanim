build(){
  (
    set -e
    temp_D=/tmp/D20190124T204416/
    logF=$temp_D/log.txt

    nim_X=nim
    # nim_X=$nim_dev_temp_X.1

    $nim_X c -o:$temp_D/libclib.dylib --app:lib --nimcache:$temp_D clib.nim
    clang -o $temp_D/test test2.c -lclib -L$temp_D/
    $temp_D/test > $logF

    # nim c -r --nimcache:$temp_D clib.nim > $logF

    # grep 'occupied memory' $temp_D/log.txt |less
    nim c -r plot.nim
  )
}

build
