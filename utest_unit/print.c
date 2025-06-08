

#define NUMBER_OF_DIGITS 5
#define NUMBER_OF_DIGITS_1 6

// 8251 constants
#define SERIAL_DATA     0x08
#define SERIAL_CONTROL  0x09

char result[NUMBER_OF_DIGITS_1];

/**
 * sends one char to serial port
 * @param ch
 * @return 
 */
/*putc(char ch) {
    while((inp(SERIAL_CONTROL) & 0x01) == 0) {
        ;
    }
    outp(SERIAL_DATA, ch);
}*/

/**
 * sends a string over serial line
 * @param message
 * @return 
 */
puts(char *message) {
    while(*message) {
        putchar(*message);
        message++;
    }
}

NLfn() {
    putchar(13);
    putchar(10);
}

tab() {
    putchar(9);
}

/**
 * convert decimal number. optionally left aligned with zeros
 * @param number number to display
 * @param leading_zero set to number of digits wanted, 0 otherwise
 */
decimal_number_to_str(unsigned int number, int leading_zero) {
    int begin_found;
    int i;

    begin_found = 0;
    // compute digits
    for (i = 0; i < NUMBER_OF_DIGITS; i++) {
        result[NUMBER_OF_DIGITS - 1 - i] = (number % 10) + '0';
        number /= 10;
    }
    // replace leading zeros with space
    for (i = 0; (i < NUMBER_OF_DIGITS - 1 ) && (i < NUMBER_OF_DIGITS - leading_zero); i++) {
        if (!begin_found) {
            if (result[i] == '0') {
                result[i] = ' ';
            } else {
                begin_found = i;
                break;
            }
        }
    }
}

