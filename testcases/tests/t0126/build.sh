build(){
  (
    set -e
    temp_D=/tmp/D20190124T204416/
    nim c  -o:$temp_D/libclib.dylib --app:lib --nimcache:$temp_D clib.nim
    clang -o $temp_D/test test2.c -lclib -L$temp_D/
    $temp_D/test > $temp_D/log.txt
    # grep 'occupied memory' $temp_D/log.txt |less
    nim c -r plot.nim
  )
}

build
