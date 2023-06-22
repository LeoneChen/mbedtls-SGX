#if defined(__cplusplus)
extern "C"{
#endif
void SGXSanLogEnter(const char *str);
#if defined(__cplusplus)
}
#endif
#define LogEnter SGXSanLogEnter
/*
 * This file is intentionally left empty. 
 * If mbedtls_sgx.edl has one or more public ECALL(s), this
 * file should be deleted. 
 *
 * Author:
 *   Fan Zhang <bl4ck5unxx@gmail.com>
 */

// a dummy function
void dummy(void) {
    LogEnter(__func__);
    ;
}
