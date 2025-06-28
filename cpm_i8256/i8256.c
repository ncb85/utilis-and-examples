/* 
 * File:   i8256.c, jan 2016
 * routines for MUART 8256
 */

#ifdef smallc
#asm
MUART8256_ADR               .equ    0x60
MUART8256_CMD1              .equ    MUART8256_ADR
MUART8256_CMD2              .equ    MUART8256_ADR+1
MUART8256_CMD3              .equ    MUART8256_ADR+2

; command register 1 - bit 0
FRQ_16K                     .equ    0           ;16kHz for all timers
FRQ_1K                      .equ    1           ;1kHz for all timers
; bit 1
MODE_8085                   .equ    0           ;RST n instruction generated
MODE_8086                   .equ    2           ;8086 interrupts
; bit 2
BITI                        .equ    0           ;0-timer2 is Level1, 0x04-port P17 is interrupt Level 1
; bit 3
BRKI                        .equ    0           ;port P16 is general purpose I/O
; bit 4
S0                          .equ    0           ;UART 1 stop bit
; bit 5
S1                          .equ    0           ;UART 1 stop bit
; bit 6
L0                          .equ    0           ;UART 8 bit
; bit 7
L1                          .equ    0           ;UART 8 bit

; command register 2 - bit 0-3
BAUD_RATE_19                .equ    0x03        ;bits 0011
; bits 4,5
SYSTEM_CLK                  .equ    0           ;system clock 5.12MHz
; bits 6,75
PARITY                      .equ    0           ;no parity bit generated on UART

; command register 3 - bit 0
RST_BIT                     .equ    1           ;RESET
; bit 1
; bit 5
IAE                         .equ    0x20        ;enables response to INTA signal
; bit 6
RXE                         .equ    0x40        ;enables serial receiver
; bit 7
SET_BIT                     .equ    0x80        ;bits marked high will be set
RESET_BIT                   .equ    0x00        ;bits marked high will be reset

; mode register
P2C0                        .equ    0x01
P2C1                        .equ    0x02
P2C2                        .equ    0x04
CT2                         .equ    0x08
CT3                         .equ    0x10
T5                          .equ    0x20
T24                         .equ    0x40
T35                         .equ    0x80

; port1
P17                         .equ    0x80
P16                         .equ    0x40
P15                         .equ    0x20
P14                         .equ    0x10
P13                         .equ    0x08
P12                         .equ    0x04
P11                         .equ    0x02
P10                         .equ    0x01

; interrupts
; timer5 or handshaking port2
LEVEL7                      .equ    0x80
; timer4 or timers2,4
LEVEL6                      .equ    0x40
; transmitter interrupt
LEVEL5                      .equ    0x20
; receiver interrupt
LEVEL4                      .equ    0x10
; timer3 or timers3,5
LEVEL3                      .equ    0x08
; external interrupt
LEVEL2                      .equ    0x04
; timer2 or port intr.
LEVEL1                      .equ    0x02
; timer 1
LEVEL0                      .equ    0x01
; interrupt registers
INTERRUPT_SET_REG           .equ    0x05
INTERRUPT_RESET_REG         .equ    0x06

#endasm
#endif

// status register
#define STATUS_REG_8256             0x6F
// UART
#define RECEIVER_BUFFER_8256        0x67
#define TRANSMITTER_BUFFER_8256     0x67
// bits
#define TrBuffEmpty                 0x20
#define RecBuffFull                 0x40
#define OverRunError                0x02
#define ParityError                 0x04
// timers, T2,3 are lower bytes, T4,5 are upper bytes in cascaded mode
#define T1                          0x6A
#define T24_LOW                     0x6B
#define T35_LOW                     0x6C
#define T24_HIGH                    0x6D
#define T35_HIGH                    0x6E

/*
 * initialize MUART 8256, order of necessary commands is as
 * command byte 1
 * command byte 2
 * command byte 3
 * mode byte
 * port 1 control
 * set interrupts
 */
init_muart_8256() {
#ifdef smallc
#asm
                mvi a,L1 | L0 | S1 | S0 | BRKI | BITI | MODE_8085 | FRQ_1K  ; command1
                out MUART8256_ADR
                mvi a,PARITY | SYSTEM_CLK | BAUD_RATE_19                    ; command2
                out MUART8256_ADR+1
                mvi a,SET_BIT | IAE | RXE | RST_BIT                         ; command3
                ;mvi a,SET_BIT | RXE | RST_BIT                               ; command3
                out MUART8256_ADR+2
                mvi a,T35 | T24 | P2C1 | P2C0                               ; mode, P2 output
                out MUART8256_ADR+3
                mvi a,P17 | P16 | P15 | P14 | P13 | P12 | P11 | P10         ; port1, sets output pins
                out MUART8256_ADR+4
                mvi a,0xFF                                                  ; disable all interrupts
                out MUART8256_ADR+INTERRUPT_RESET_REG
                ;mvi a,LEVEL6                                                ; enable individual interrupts
                ;out MUART8256_ADR+INTERRUPT_SET_REG
#endasm
#endif
}


/**
 * check status register
 * @return status reg
 */
uart_status_8256() {
    return inp(STATUS_REG_8256);
}

/**
 * check transmitter buffer
 * @return 1 when output buffer is capable of accepting more characters, 0 otherwise
 */
uart_output_buffer_accept_8256() {
    return inp(STATUS_REG_8256) & TrBuffEmpty;
}

/**
 * check receiver buffer
 * @return 1 when data was received, 0 otherwise
 */
uart_input_data_received_8256() {
    return inp(STATUS_REG_8256) & RecBuffFull;
}

/**
 * input from UART
 * @return input character
 */
uart_input_8256() {
    return inp(RECEIVER_BUFFER_8256);
}

/**
 * send character over UART
 * @param c char to send
 */
uart_putc_8256(char c) {
    while(!uart_output_buffer_accept_8256());
    outp(TRANSMITTER_BUFFER_8256, c);
}

/**
 * send string over UART
 * @param str
 * @return 
 */
uart_puts_8256(char str[]) {
    while(*str) {
        uart_putc_8256(*str);
        str++;
    }
}

/**
 * sets 16-bit timer pair T24 or T35
 * @param timer pair T24 - 0 or T35 - 1
 * @param value initial value for timer/counter
 * @return 
 */
set_timer_pair_8256(int pair, int value) {
    switch (pair) {
        case 0: // T24
            outp(T24_HIGH, value >> 8);
            outp(T24_LOW, value);
            break;
        case 1: // T35
            outp(T35_HIGH, value >> 8);
            outp(T35_LOW, value);
            break;
    }
}

/**
 * read value from timer pair, if lower value equals FF reading needs to be repeated
 * sets HL reg so that this method's result can be assigned
 * @param pair
 * @return 
 */
read_timer_pair_8256(int pair) {
    switch (pair) {
        case 0: // T24
#ifdef smallc
#asm
            call rtpc0                  ; read timers
            cz rtpc0                    ; repeat once
            ret                         ; return
rtpc0:      in 0x6d                     ; in higher byte
            mov h,a
            in 0x6b                     ; in lower byte
            mov l,a                     ; store higher byte
            cpi 0xff                    ; just changed value, repeat from begin
            ret
#endasm
#endif
            break;
        case 1: // T35
#ifdef smallc
#asm
            call rtpc1                  ; read timers
            cz rtpc1                    ; repeat once
            ret                         ; return
rtpc1:      in 0x6e                     ; in higher byte
            mov h,a
            in 0x6c                     ; in lower byte
            mov l,a                     ; store higher byte
            cpi 0xff                    ; just changed value, repeat from begin
            ret
#endasm
#endif
            break;
    }
}

/**
 * can enable individual interrupt, useful for timer interrupts that disable themself
 * automatically from repeated invocation when they occur
 * @param mask interrupt mask bits
 */
enable_interrupt_8256(int mask) {
    mask;
#ifdef smallc
#asm    
            mov a,l                                 ; move value to A
            out MUART8256_ADR+INTERRUPT_SET_REG     ; set bit in SET interrupt mask register
#endasm
#endif
}