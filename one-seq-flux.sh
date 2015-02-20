#!/bin/bash

# where is the flux simulator
FLUXDIR=../flux-simulator-1.2

#for ((a = 0; a < 20; a++)) do
$FLUXDIR/bin/flux-simulator -p foo-single.par -x -l -s ;
#mv foo.pro foo$a.pro
#mv foo.lib foo$a.lib
#done
