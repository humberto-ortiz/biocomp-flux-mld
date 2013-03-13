#!/bin/bash
for ((a = 0; a < 20; a++)) do
~/Documents/flux-simulator-1.2/bin/flux-simulator -p foo.par -x -l ; mv foo.pro foo$a.pro
done
