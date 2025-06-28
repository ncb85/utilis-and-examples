/**
 * simple CP/M console byte oriented I/O
 */

// CP/M console services
#define CPMCON                  6
#define CPMKEYIN                0xFF

/**
 * Returns 00 if no key was pressed. Otherwise return key code. Non blocking method.
 * No echo on screen.
 * @return 
 */
console_keypress() {
    return bdos1(CPMCON, CPMKEYIN);
}

/**
 * puts a char to console
 * @param p, must be less than 255
 * @return 
 */
console_putc(char p) {
    bdos1(CPMCON, p);
}

/**
 * send a string to console
 * @return 
 */
console_puts(char str[]) {
    while(*str) {
        console_putc(*str);
        str++;
    }
}

