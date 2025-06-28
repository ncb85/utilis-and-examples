/*
 * led595.c routines for 4 decimal digit LED display driven by 3 lines
 * fully static with 4 74595 serial registers
 */

#define DISPLAY_LENGTH      4
#define MUART_ADDR          0x60
#define MUART_PORTA         0x68
#define DATA_PIN            0x01
#define CLCK_PIN            0x02
#define LOAD_PIN            0x04
#define DELAY_CONST         3000

/*
 out MUART8256_ADR+3
 mvi a,P17 | P16 | P15 | P14 | P13 | P12 | P11 | P10         ; port1, sets output pins
 */

unsigned char DIGIT[12] = {0xFC,0x60,0xDA,0xF2,0x66,0xB6,0xBE,0xE0,0xFE,0xF6,0x00,0x01};
unsigned char porta_val = 0;

/**
 * shifts the digit out to 74595
 * 8256 port 2 at address 0??3, status/command register at address 00
 * @param digit
 */
shift_out_8256_595(char digit) {
    char i;
    porta_val = 0;
    outp(MUART_PORTA, porta_val);
#ifdef smallc
#asm
#endasm
#endif
    for (i=0; i<8; i++) {
        porta_val = digit >> i;
        porta_val &= DATA_PIN;
        porta_val += CLCK_PIN;
        outp(MUART_PORTA, porta_val);       // shift out one bit
        porta_val -= CLCK_PIN;
        outp(MUART_PORTA, porta_val);
#ifdef smallc
#asm
#endasm
#endif
    }
}

/**
 * transition from low to high loads out.register of 595
 * @return 
 */
enable_output_8256_595() {
    porta_val += LOAD_PIN;                  // latch clock
    outp(MUART_PORTA, porta_val);
    porta_val -= LOAD_PIN;
    outp(MUART_PORTA, porta_val);
}

/**
 * displays decimal number
 * @param number the 4 digits number to display
 * @param show_trailing_zero set to 1 if trailing zeros wanted
 * @param decimal_point_pos sets position of decimal point, set to -1 if unwanted
 */
display_decimal_number_8256_595(unsigned int number, char show_trailing_zero, char decimal_point_pos) {
    // digits are 0123
    // on display 8888
    char result[DISPLAY_LENGTH];
    char begin_found;
    char i;

    begin_found = 0;
    if (number < 10000) {
        // compute digits
        for (i = 0; i < DISPLAY_LENGTH; i++) {
            result[DISPLAY_LENGTH - 1 - i] = number % 10;
            number /= 10;
        }
        // remove trailing zeros
        for (i = 0; !(begin_found || show_trailing_zero) && (i < DISPLAY_LENGTH - 1) && (i < decimal_point_pos - 1); i++) {
            if (result[i] == 0) {
                result[i] = 10; // " " a space
            } else {
                begin_found = 1;
            }
        }
    } else {
        for (i = 0; i < DISPLAY_LENGTH; i++) {
            result[i] = 11; // "...."
        }
    }
    // shift out the digits
    for (i = 0; i < DISPLAY_LENGTH; i++) {
        if ((DISPLAY_LENGTH - decimal_point_pos - 1) == i) {
            shift_out_8256_595(~(DIGIT[result[DISPLAY_LENGTH - 1 - i]] | 0x01));
        } else {
            shift_out_8256_595(~DIGIT[result[DISPLAY_LENGTH - 1 - i]]);
        }
    }
    enable_output_8256_595();
}

test_led_8256_595() {
int i,j,k;

    // test display, blink few times
    for (i = 0; i < 3; i++) {
        for (j = 0; j < DISPLAY_LENGTH; j++) {
            shift_out_8256_595(0x00);
        }
        enable_output_8256_595();
        delay(DELAY_CONST);
        for (j = 0; j < DISPLAY_LENGTH; j++) {
            shift_out_8256_595(0xFF);
        }
        enable_output_8256_595();
        delay(DELAY_CONST);
    }
    // test individual segments
    for (i = 0; i<2; i++) {
        for (j = 0; j < 8; j++) {
            for (k = 0; k < DISPLAY_LENGTH; k++) {
                shift_out_8256_595(~(1<<j));
            }
            enable_output_8256_595();
            delay(DELAY_CONST);
        }
    }
    
    //for (k = 0; k < 10000; k++) {
    //    display_decimal_number_8256_595(k, 0, -1);
    //}
}

delay(unsigned int time) {
    int i;
    for(i=0; i<time; i++) {
        i=i;
    }
}