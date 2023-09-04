#!/bin/bash
set -e

if [[ $1 == 'debug' ]]; then
    CMAKE_FLAGS="-DSGX_BUILD=DEBUG -DSGX_MODE=HW -DCOMPILE_EXAMPLES=true"
else
    CMAKE_FLAGS="-DSGX_BUILD=PRERELEASE -DSGX_MODE=HW -DCOMPILE_EXAMPLES=true"
fi

cmake ${CMAKE_FLAGS} -B build
cmake --build build -j$(nproc)

# ~/SGXSan/Tool/GetLayout.sh -d build/example/enclave CMakeFiles/enclave.dir/Enclave_t.c.o CMakeFiles/enclave.dir/ecalls.cpp.o CMakeFiles/enclave.dir/Log.c.o CMakeFiles/enclave.dir/pprint.c.o CMakeFiles/enclave.dir/s_client.c.o CMakeFiles/enclave.dir/s_server.c.o CMakeFiles/enclave.dir/ssl_conn_hdlr.cpp.o /mnt/hdd/sgx-evaluate/sgxfuzz/Enclaves/mbedtls-SGX/build/trusted/libmbedtls_SGX_t.a /opt/intel/sgxsdk/lib64/libsgx_trts.a /opt/intel/sgxsdk/lib64/libsgx_tstdc.a /opt/intel/sgxsdk/lib64/libsgx_tcxx.a /opt/intel/sgxsdk/lib64/libsgx_tcrypto.a /opt/intel/sgxsdk/lib64/libsgx_tservice.a
