/*
 * File:   main.c, jan 2016
 * MUART 8256 test
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

// constants
#define CTRL_Q                  0x11
#define CTRL_C                  0x03
#define CTRL_Z                  0x1A

// 8256 timers
#define T24                     0
#define T35                     1

unsigned int intr3_handled, intr6_handled;
unsigned char p;

/**
 * interrupt 3 routine - T35 interrupt
 * @return 
 */
interrupt_3() {
#ifdef smallc
#asm
        push    psw
        push    b
        push    d
        push    h
#endasm
#endif
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
 * interrupt 4 routine - UART receiver interrupt
 * @return 
 */
interrupt_4() {
#ifdef smallc
#asm
        push    psw
        push    b
        push    d
        push    h
#endasm
#endif
        p = uart_input_8256();
        // printf("%c", p);     // echo typed keys
        //fputc(p, stdout);
        uart_putc_8256(p);
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
 * interrupt 6 routine - T24 interrupt
 * @return 
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
    intr6_handled += 1;
    set_timer_pair_8256(T24, 2500); // 2.5 seconds
#ifdef smallc
#asm
        mvi     a,0x40                      ; reenable level 6 interrupt in SET register
        out     0x65                        ; timer level interrupt disables itself
        
        pop     h
        pop     d
        pop     b
        pop     psw
        ei
#endasm
#endif
}
        
/**
 * main routine
 * @return
 */
main(int argc, int argv[]) {
    char c;
    unsigned int t24, intr6_last;
    intr6_last = -1;
    
    // install interrupt handlers
#ifdef smallc
#asm
        mvi     a,0xC3          ; JUMP instruction
        sta     0x30            ; interrupt 6 - 8256 T24 pair
        sta     0x20            ; interrupt 4 - 8256 UART receiver
        lxi     h,interrupt_6   ; install interrupt handler
        shld    0x30+1 ;
        lxi     h,interrupt_4   ; install interrupt handler
        shld    0x20+1 ;
        ei
#endasm
#endif
    
    //8256 UART
    init_muart_8256();
    // test LED display
    printf("testing led display\n");
    test_led_8256_595();
    printf("done\n");
        
    uart_puts_8256("abcdefghijklmopqrstuvxyz");
    enable_interrupt_8256(0x40+0x10); // T24 + UART Receive
    
    //8256 timer T24
    set_timer_pair_8256(T24, 5000);     // first interval 5 seconds
    
    while (1) {
        // key pressed ?
        c = console_keypress();
        if (c == CTRL_C) {
            break;
        }
        //t24 = read_timer_pair_8256(T24);
        if (intr6_last != intr6_handled) {
            printf("INTR6 occurred:%d\n", intr6_handled);
            display_decimal_number_8256_595(intr6_handled, 0, -1);
            intr6_last = intr6_handled;
        }
    }
}