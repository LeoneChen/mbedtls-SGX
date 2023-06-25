#!/bin/bash
set -e

for ARG in "$@"
do
   KEY="$(echo $ARG | cut -f1 -d=)"
   VAL="$(echo $ARG | cut -f2 -d=)"
   export "$KEY"="$VAL"
done

CUR_DIR=$(realpath $(dirname $0))
ROOT_CIR=${CUR_DIR}
SGXSAN_DIR=$(realpath ${CUR_DIR}/../../install)
MAKE_FLAGS=
CMAKE_FLAGS="-DCOMPILE_EXAMPLES=1 -DSGX_SDK=${SGXSAN_DIR}"
MODE=${MODE:="RELEASE"}
FUZZER=${FUZZER:="LIBFUZZER"}

echo "-- MODE: ${MODE}"
echo "-- FUZZER: ${FUZZER}"

if [[ "${MODE}" = "DEBUG" ]]
then
    MAKE_FLAGS+=" SGX_DEBUG=1 SGX_PRERELEASE=0"
    CMAKE_FLAGS+=" -DCMAKE_BUILD_TYPE=Debug"
else
    MAKE_FLAGS+=" SGX_DEBUG=0 SGX_PRERELEASE=1"
    CMAKE_FLAGS+=" -DCMAKE_BUILD_TYPE=Release"
fi

if [[ "${FUZZER}" = "KAFL" ]]
then
    MAKE_FLAGS+=" KAFL_FUZZER=1"
    CMAKE_FLAGS+=" -DKAFL_FUZZER=1"
else
    MAKE_FLAGS+=" KAFL_FUZZER=0"
    CMAKE_FLAGS+=" -DKAFL_FUZZER=0"
fi

CC=clang-13 CXX=clang++-13 cmake ${CMAKE_FLAGS} -B build
cmake --build build -j$(nproc)
