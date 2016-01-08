/*
 * File:   main.c, april 2015
 * i2c test on CP/M
 */
#include <stdio.h>

char buff[80], *txt;
char user_response[82], p;
int time;
int result = -1, err1 = -1, err2 = -1, adr1 = -2, adr2 = -2;
int secs = 0, minutes = 0, value;

/**
 * interrupt 6 routine - PCF8584
 */
interrupt_6() {
#ifdef smallc
#asm
        push    psw
        push    b
        push    d
        push    h
#endasm
#endif
        // C code here..
        
#ifdef smallc
#asm
        pop     h
        pop     d
        pop     b
        pop     psw
        ei
#endasm
#endif
}

/**
 * Returns 00 if no key was pressed. Otherwise return key code. Non blocking method.
 * No echo on screen.
 * @return 
 */
console_keypress() {
    return bdos1(6, 0xFF);
}

/**
 * Returns key pressed.
 * @return 
 */
console_getc() {
    return bdos1(1, 0);
}

/**
 * get input text from console
 * @return command line
 */
console_gets() {
    char len;
    user_response[0] = 80; // allow to type in max 80 keys
    bdos(10, user_response);
    len = user_response[1]; // length of typed line
    user_response[len + 2] = 0; // terminate typed in string
    return user_response+2;
}

/**
 * get number
 * @return number
 */
get_number() {
    int nr, i;
    char buff[];
    nr = 0;
    i = 0;
    buff = console_gets();
    while (buff[i]) {
        if (buff[i] >= '0' && buff[i] <= '9') {
            nr = nr * 10 + buff[i] - '0';
        } else {
            return -1;
        }
        ++i;
    }
    printf("%d", nr);
    return nr;
}

/**
 * get hex number
 * @return hex number
 */
get_hex_number() {
    int nr, i;
    char buff[];
    nr = 0;
    i = 0;
    buff = console_gets();
    while (buff[i]) {
        if (buff[i] >= '0' && buff[i] <= '9') {
            nr = nr * 16 + buff[i] - '0';
        } else if (buff[i] >= 'a' && buff[i] <= 'f') {
            nr = nr * 16 + buff[i] - 'a' + 10;
        } else if (buff[i] >= 'A' && buff[i] <= 'F') {
            nr = nr * 16 + buff[i] - 'A' + 10;
        } else {
            return -1;
        }
        ++i;
    }
    printf("%d", nr);
    return nr;
}

/**
 * get max number with prompt
 * @param msg the prompt
 * @param maxval max value
 * @return entered number
 */
get_nr(char *msg, int maxval) {
    int nr;
    do {
        printf("\n%s? (0-%d)\n", msg, maxval);
        nr = get_number();
    } while (nr < 0 || nr > maxval);
    return nr;
}

report(int result) {
    printf("Result:");
    switch(result) {
        case 0:
            printf("OK");
            break;
        case 1:
            printf("Waiting for PIN unsuccessful");
            break;
        case 2:
            printf("No acknowledge - device not present?");
            break;
        case 3:
            printf("Bus busy");
            break;
        default:
            printf("unknown code: %d", result);
    }
}

/**
 * main routine
 * @return
 */
main(int argc, int argv[]) {
    int port, val, fract, pin, bb, lbr, be;
    int i,j,k;
    
    printf("I2C fun\n");
    while(1) {
        do {
            printf("Menu:\ne. exit, i. port in, o. port out, n. init pcf8584, r. reset i2c bus\n");
            printf("d. get date, t. get time, s. set date, m. set time, a. init DS1307\n");
            printf("q. configure TMP275, p. read temp.TMP275, l. light leds on PCA9555\n");
            printf("c. show status reg., Your choice?\n");
            p = console_getc();
        } while (p < 'a' || p > 'z');

        switch (p) {
            case 'e':
                exit(1);
            case 'i':
                printf("port nr:");
                port = get_hex_number();
                val = inp(port);
                printf("\nvalue:%2x", val);
                break;
            case 'o': 
                printf("port nr:");
                port = get_hex_number();
                printf("\nvalue:");
                val = get_hex_number();
                outp(port, val);
                break;
            case 'n':
                printf("\nInit PCF8584\n");
                i2c_init_pcf8584();
                break;
            case 'r':
                printf("\nReset I2C bus\n");
                i2c_reset_bus();
                break;
            case 'l':
                printf("\nLight LEDs\n");
                result = pca_led_demo();
                report(result);
                break;
            case 'd':
                printf("\nGet date\n");
                refresh_time_ds1307();
                i = get_date_ds1307();
                j = get_month_ds1307();
                k = get_year_ds1307();
                printf("\nDate:%u.%u.20%u", i, j, k);
                break;
            case 'a':
                printf("\nStart DS1307\n");
                result = init_ds1307();
                break;
            case 't':
                printf("\nGet time\n");
                refresh_time_ds1307();
                i = get_second_ds1307();
                j = get_minute_ds1307();
                k = get_hour_ds1307();
                printf("\nTime:%02u:%02u:%02u", k, j, i);
                break;
                break;
            case 's':
                printf("\nSet date\n");
                i = get_nr("Year", 99);
                j = get_nr("Month", 12);
                k = get_nr("Date", 31);
                set_date_ds1307(i,j,k);
                break;
            case 'm':
                printf("\nSet time\n");
                i = get_nr("Hour", 23);
                j = get_nr("Minute", 59);
                k = get_nr("Second", 59);
                set_time_ds1307(i,j,k);
                break;
            case 'q':
                printf("\nConfigure temperature sensor TMP275\n");
                result = configure_tmp275(); // 10-bit resolution
                report(result);
                break;
            case 'p':
                result = read_tmp275();
                // following yields two decimal places only for 10-bit resolution
                // 11-bit would give results like 87.5
                fract = result%16;
                // if negative, inverse bits in fraction part
                if (result < 0) {
                    fract = -fract;
                }
                fract = fract*25/4;
                printf("\nTemperature:%d.%02u degree Celsius", result/16, fract);
                break;
            case 'c':
                result = inp(0x59);
                pin = result & 0x80 ? 1 : 0;
                bb = result & 0x01 ? 0 : 1;
                lbr = result & 0x04 ? 1 : 0;
                be = result & 0x10 ? 1 : 0;
                printf("\nPIN:%d, neg. Bus Busy: %d, Last Bit Received:%d, Bus Error:%d", pin, bb, lbr, be);
                break;
            default:
                break;
        }
        result = inp(0x59);
        printf("\nStatus(81=OK):%02x\n", result);
    }
}
