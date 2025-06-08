/*
 * File:   main.c, december 2011
 * Hello World on 8080 cpu
 */

// 8155 constants
#define STATUS_CMD_REG_8155     0x00
#define LOW_ORDER_TIMER_BITS    0x04
#define HIGH_ORDER_TIMER_BITS   0x05

// 8251 constants
#define SERIAL_DATA     0x08
#define SERIAL_CONTROL  0x09

#define SOK	"Valid"
#define SHOBAD	"****Invalid"

#define NUMBER_OF_DIGITS_1 6

char *AOK;
char *NOK;

/**
 * sends one char to serial port
 * @param ch
 * @return 
 */
putc(char ch) {
    while((inp(SERIAL_CONTROL) & 0x01) == 0) {
        ;
    }
    outp(SERIAL_DATA, ch);
}

/**
 * sends a string over serial line
 * @param message
 * @return 
 */
puts(char *message) {
    while(*message) {
        putc(*message);
        message++;
    }
}

NLfn() {
    putc(13);
    putc(10);
}

tab() {
    putc(9);
}

writeOK() {
    tab();
    puts(AOK);
    NLfn();
}

writeNOK() {
    tab();
    puts(NOK);
    NLfn();
}

/**
 * main routine
 * @return
 */
main() {
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
    
    while(1) {
        ;
    }
}
