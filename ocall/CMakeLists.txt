set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} ${SGX_COMMON_CFLAGS} -fPIC -Wno-attributes")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} ${CMAKE_C_FLAGS} -std=c++11")

add_library(${PROJECT_NAME}_u STATIC net_ocalls.c std_ocalls.c)

include_directories(
    ../trusted/mbedtls-${MBEDTLS_VERSION}/include)

install(TARGETS ${PROJECT_NAME}_u
    DESTINATION lib
    PERMISSIONS OWNER_READ OWNER_WRITE GROUP_READ WORLD_READ)

if(NOT KAFL_FUZZER)
set_target_properties(${PROJECT_NAME}_u PROPERTIES
    COMPILE_FLAGS
    "-fsanitize-coverage=inline-8bit-counters,bb,no-prune,pc-table,trace-cmp \
    -fprofile-instr-generate \
    -fcoverage-mapping"
)
endif()
