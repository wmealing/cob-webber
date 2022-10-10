#!/usr/bin/env bash

set -e
set -x

source ./deps/emsdk/emsdk_env.sh 

cobc -C -Wall -o src/generated.c -g -x -static -free $1
GENPATH=`realpath src/generated.c`

# this will absolutely need ot be modified for any large project.
sed -i "s@REPLACEME@$GENPATH@g" ./src/cobweb.c

EM_ARGS=${EM_ARGS:-""}
EM_OUT=${EM_OUT:-"out.html"}

emcc ./src/cobweb.c \
    -I./dist/include -L./dist/lib \
    -lgmp -lcob  \
    -fno-rtti \
    -flto \
    --ignore-dynamic-linking \
    -s EXPORTED_FUNCTIONS="['_get_string', '_entry', '_main']" \
    -s EXPORTED_RUNTIME_METHODS="['ccall', 'cwrap']" \
    -s EXIT_RUNTIME=1 \
    -s INVOKE_RUN=1 \
    -s STRICT=1 \
    -s LLD_REPORT_UNDEFINED=1 \
    -s ERROR_ON_UNDEFINED_SYMBOLS=0 \
    --shell-file ./src/custom.html \
    $EM_ARGS \
    -o output/$EM_OUT
