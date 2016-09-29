#include "log.h"
#include "glue.h"
#include "stdio.h"
#include "stdlib.h"
#include "mbedtls/bignum.h"
#include "mbedtls/ecdsa.h"

static void dump_buf(const char* title, void const * data, unsigned int len)
{
    unsigned int i;
    unsigned int r,c;
    
    if (!data)
	return;

    printf_sgx("%s\n", title);
    
    for (r=0,i=0; r<(len/16+(len%16!=0)); r++,i+=16)
    {
        printf_sgx("0x%04X:   ",i); /* location of first byte in line */
	
        for (c=i; c<i+8; c++) /* left half of hex dump */
	    if (c<len)
        	printf_sgx("%02X ",((unsigned char const *)data)[c]);
	    else
		printf_sgx("   "); /* pad if short line */
	
	printf_sgx("  ");
	
	for (c=i+8; c<i+16; c++) /* right half of hex dump */
	    if (c<len)
		printf_sgx("%02X ",((unsigned char const *)data)[c]); else
		printf_sgx("   "); /* pad if short line */
	
	printf_sgx("   ");
	
	for (c=i; c<i+16; c++) /* ASCII dump */
	    if (c<len)
		if (((unsigned char const *)data)[c]>=32 &&
		    ((unsigned char const *)data)[c]<127)
		    printf_sgx("%c",((char const *)data)[c]);
		else
		    printf_sgx("."); /* put this for non-printables */
	    else
		printf_sgx(" "); /* pad if short line */
	
	printf_sgx("\n");
    }
}

void dump_pubkey( const char *title, mbedtls_ecdsa_context *key )
{
    // each point on our curve is 256 bit (32 Bytes)
    // two points plus the leading 0x04 byte
    unsigned char buf[2*32 + 1];
    size_t len;

    if( mbedtls_ecp_point_write_binary( &key->grp, &key->Q,
                MBEDTLS_ECP_PF_UNCOMPRESSED, &len, buf, sizeof buf ) != 0 )
    {
        printf_sgx("internal error\n");
        return;
    }

    // buf + 1 to skip the first 0x04 byte
    dump_buf( title, buf + 1, len -1);
}

void dump_mpi (const char* title, mbedtls_mpi* X)
{
    size_t len = mbedtls_mpi_bitlen(X);
    unsigned char* buf;

    if (len == 0)
    {
        printf_sgx("%s%d\n", title, 0);
        return;
    }
    
    len = ((len + 7) & ~0x07) / 8;
    buf = (unsigned char*) malloc(len);
    mbedtls_mpi_write_binary (X, buf, len);
    dump_buf (title, buf, len);
    free(buf);
}

void dump_group( const char* title, mbedtls_ecp_group* grp)
{
    unsigned char buf[128];
    size_t len;

    printf_sgx("%s", title);

    dump_mpi("A=", &grp->A);
    dump_mpi("B=", &grp->B);

    mbedtls_ecp_point_write_binary( grp, &grp->G,
                MBEDTLS_ECP_PF_UNCOMPRESSED, &len, buf, sizeof buf );
    dump_buf("G=", buf, len);

    dump_mpi("N=", &grp->N);
    printf_sgx("h=%d\n", grp->h);
}
