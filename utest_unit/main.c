/*
 * File:   main.c, december 2011
 * Hello World on 8080 cpu
 */
#include "print.h"

// 8155 constants
#define STATUS_CMD_REG_8155     0x00
#define LOW_ORDER_TIMER_BITS    0x04
#define HIGH_ORDER_TIMER_BITS   0x05

#define SOK	"Valid"
#define SHOBAD	"****Invalid"


char *AOK;
char *NOK;

unsigned int pass = 0;
signed int fail = 0;

writeOK() {
    tab();
    puts(AOK);
    NLfn();
    pass++;
}

writeNOK() {
    tab();
    puts(NOK);
    NLfn();
    fail++;
}

/**
 * main routine
 * @return
 */
main() {
    unsigned char sum;
    unsigned int isum;
    // create ptr to strs to pass to puts, instead of quoted str const
    AOK = SOK;
    NOK = SHOBAD;
    puts("**********(Signed Tests)**********");NLfn();
    teqs();		/* equal */
    tnes();		/* not equal */
    tges();		/* greater than or equal to */
    tles();		/* less than or equal to */
    tgts();		/* greater than */
    tlts();		/* less than */
    puts("*****(Signed Tests Completed)*****");NLfn();

    puts("**********(Unsigned Tests)**********");NLfn();
    testUnsignedSuite();
    puts("*****(Unsigned Tests Completed)*****");NLfn();

    puts("*****(Function Param/Return Tests)*****");NLfn();
    sum = testKandR(1,2,3,4);
    puts("Testing K&R return");
    if (sum == 10) {
        writeOK();
    } else {
        writeNOK();
    }
    isum = testAnsi(1,2,3,4);
    puts("Testing ANSI return");
    if (isum == 10) {
        writeOK();
    } else {
        writeNOK();
    }
    puts("*****(Function Param/Return Completed)*****");NLfn();
    
    puts("*****(Function Struct/Union Tests)*****");NLfn();
    testStructSuite();
    puts("*****(Function Struct/Union Completed)*****");NLfn();

    puts("*****Total Number of Test:*****");
    decimal_number_to_str(pass+fail, 0);
    puts(result);
    NLfn();
    puts("*****Passed/Failed Test:*****");
    decimal_number_to_str(pass, 0);
    puts(result);
    decimal_number_to_str(fail, 0);
    putchar('/');
    puts(result);
    NLfn();
    
    /*while(1) {
        ;
    }*/
}
