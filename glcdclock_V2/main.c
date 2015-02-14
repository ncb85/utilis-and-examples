/*
 * File:   main.c, september 2011
 * glcd on 8080 cpu
 */
#include <stdio.h>

// 8155 constants
#define STATUS_CMD_REG_8155     0x00
#define LOW_ORDER_TIMER_BITS    0x04
#define HIGH_ORDER_TIMER_BITS   0x05

// 8255 constants
#define STATUS_CMD_REG_8255     0x13
#define PORT_A_8255             0x10
#define PORT_B_8255             0x11
#define PORT_C_8255             0x12

// 8253 constants
#define STATUS_CMD_REG_8253     0x1B
#define COUNTER_0_8253          0x18
#define COUNTER_1_8253          0x19
#define COUNTER_2_8253          0x1A

// 8251 constants
#define SERIAL_DATA             0x08
#define SERIAL_CONTROL          0x09

//#define NUMBER_OF_DIGITS_1      6       // 5 digits plus terminating 0

#define BUFFER_LEN              10

// constants
#define CTRL_Q                  0x11
#define CTRL_C                  0x03
#define CTRL_Z                  0x1A

unsigned int i = 0, command_received = 0, buffer_position = 0;
char backspaces[] = {0x08,0x08,0x08,0x08,0x08,0x08,0x08,0x08,0x00};
unsigned char day, hour, minute, second, prev_second, tick;
char serial_buffer[BUFFER_LEN];

int stkp;
extern char result[];  // defined in convert.asm

// SmallC pozna define "smallc", Netbeans ho nepozna
#ifndef smallc
GLCD_char_to_dec(char);
GLCD_int_to_dec(int);
GLCD_int_to_hex(int);
#endif
// tento blok je tu len kvoli IDE Netbeans, aby nepodciarkovalo tieto tri funkcie ako nezname
// funkcie su implementovane v ASM v convert.asm a Netbeans ich tam "nevidi"

/**
 * interrupt 6.5 routine - timer output
 * @return 
 */
interrupt_65() {
#ifdef smallc
#asm
        push    psw
        push    b
        push    d
        push    h
#endasm
#endif
    if (++tick > 9) {
        tick = 0;
        if (++second > 59) {
            second = 0;
            if (++minute > 59) {
                minute = 0;
                if (++hour > 23) {
                    hour = 0;
                    ++day;
                }
            }
        }
    }
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
 * stops 8155 timer
 * @return 
 */
stop_clock() {
    outp(STATUS_CMD_REG_8155, 0x80); // stop timer, disable port C interrupts, C port output
}

display_digital_clock() {
    GLCD_GoTo(60, 0);
    GLCD_char_to_dec(day);
    //console_puts(backspaces);
    uart_puts(backspaces);
    GLCD_GoTo(78, 0);
    GLCD_char_to_dec(hour);
    //console_puts(result);
    //console_putc(':');
    uart_puts(result);
    uart_putc(':');
    GLCD_GoTo(96, 0);
    GLCD_char_to_dec(minute);
    //console_puts(result);
    //console_putc(':');
    uart_puts(result);
    uart_putc(':');
    GLCD_GoTo(114, 0);
    GLCD_char_to_dec(second);
    //console_puts(result);
    uart_puts(result);
}

/**
 * process commands received over serial line
 * THHMMSS - T set time, HH hour, MM minute, SS second
 * @return 
 */
process_command(char *command) {
    switch (command[0]) {
        case 'T':
        case 't':
            hour = 10*(command[1]-'0') + command[2]-'0';
            minute = 10*(command[3]-'0') + command[4]-'0';
            second = 10*(command[5]-'0') + command[6]-'0';
            break;
        default:
            printf("unknown command:%s\n", command);
            ;
    }
}

/**
 * main routine
 * @return
 */
main(int argc, int argv[]) {
    char c;
    // wait for floppy to stop 10s
    for (hour = 0; hour < 6; hour++) {
        for (minute = 0; minute < 255; minute++) {
            for (second = 0; second < 255; second++) {
            }
        }
    }
    //hour = minute = second = 0;
    
    if (argc == 2) {
        process_command(argv[1]);
        prev_second = second;
    } else {
        printf("usage clck.com tHHMMSS\n");
        day = hour = minute = second = prev_second = 0;
    }
    
#ifdef smallc
#asm
        mvi     a,0xC3          ; JUMP instruction
        sta     0x34            ; NCB85 firmware dependend address, timer intrpt
        lxi     h,interrupt_65
        shld    0x34+1 ;
        mvi     a,0b00011101    ; set interrupt mask, enable 6.5
        sim
        ei
#endasm
#endif
            
    i = tick = 0;
    // 8155
    // counter low 8 bits, count frequency is 153600Hz, reload 3C00 yields 10Hz
    outp(LOW_ORDER_TIMER_BITS, 0x00); // 
    // top 2 bits, mode: one pulse -> 1 0, cont.square -> 0 1, aut.reload single pulse 1 1
    outp(HIGH_ORDER_TIMER_BITS, 0xFC); // low 6 bits are counter high 6 bits
    outp(STATUS_CMD_REG_8155, 0xCE); // start timer, disable port C interrupts, B&C ports output
    
    // 8253, with c800 frequency will be 3Hz, 3C00 yields 10Hz
    outp(STATUS_CMD_REG_8253, 0x34); // start timer 0, LSB first, MSB after, Mode 2
    outp(COUNTER_0_8253, 0x00); // timer 0, LSB
    outp(COUNTER_0_8253, 0x3C); // timer 0, MSB
    
    //16552
    //uart_init();
    
    // program
    serial_buffer[0] = 0;

    GLCD_Initalize();
    GLCD_ClearScreen();
    GLCD_GoTo(0,0);
    GLCD_WriteString("NCB85v2");
    GLCD_GoTo(0,1);
    GLCD_WriteString("KS0108");
    GLCD_GoTo(72, 0);
    GLCD_WriteChar(':');
    GLCD_GoTo(90, 0);
    GLCD_WriteChar(':');
    GLCD_GoTo(108, 0);
    GLCD_WriteChar(':');
    GLCD_GoTo(0, 6);
    GLCD_WriteString("SP:");

    init_analog_clock();
    while (1) {
        if (prev_second != second) {
            prev_second = second;
            display_digital_clock();
            display_analog_clock(hour, minute, second);
        }
        GLCD_GoTo(0, 7);
        GLCD_int_to_dec(i);
        i++;
        if (command_received == 1) {
            command_received = 0;
            process_command(serial_buffer);
        }
        
        GLCD_GoTo(18, 6);
#ifdef smallc
#asm
        lxi h,0
        dad     sp
        lxi     d,stkp
        shlx
#endasm
#endif
        GLCD_int_to_hex(stkp);
        
        // key pressed ?
        c = console_keypress();
        if (c == CTRL_C) {
            break;
        } else {
            if (c != 0) {
                serial_buffer[buffer_position] = c;
                if (serial_buffer[buffer_position] == '\r') {
                    command_received = 1;
                    serial_buffer[buffer_position] = 0;
                    buffer_position = 0;
                } else {
                    if (buffer_position < BUFFER_LEN) {
                        ++buffer_position;
                    }
                }
            }
        }
    }
}