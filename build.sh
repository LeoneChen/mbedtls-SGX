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
SIM=${SIM:="TRUE"}

echo "-- MODE: ${MODE}"
echo "-- FUZZER: ${FUZZER}"
echo "-- SIM: ${SIM}"

if [[ "${MODE}" = "DEBUG" ]]
then
    CMAKE_FLAGS+=" -DCMAKE_BUILD_TYPE=Debug"
else
    CMAKE_FLAGS+=" -DCMAKE_BUILD_TYPE=Release"
fi

if [[ "${FUZZER}" = "KAFL" ]]
then
    CMAKE_FLAGS+=" -DKAFL_FUZZER=1"
else
    CMAKE_FLAGS+=" -DKAFL_FUZZER=0"
fi

if [[ "${SIM}" = "TRUE" ]]
then
    CMAKE_FLAGS+=" -DSGX_MODE=SIM"
else
    CMAKE_FLAGS+=" -DSGX_MODE=HW"
fi

CC=clang-13 CXX=clang++-13 cmake ${CMAKE_FLAGS} -B build
cmake --build build
