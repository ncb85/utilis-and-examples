/**
 * Dual UART 16552 routines
 * http://en.wikibooks.org/wiki/Serial_Programming/8250_UART_Programming#Serial_COM_Port_Memory_and_I.2FO_Allocation
 */

// FIFO Control Register - CHANNEL 1
#define FIFO_CTRL_REG_1                 0x2A
// Line Control Register
#define LINE_CTRL_REG_1                 0x2B
// Divisor Latch Bytes
#define DIVISOR_LOW_BYTE_1              0x28
#define DIVISOR_HIGH_BYTE_1             0x29
// Line Status Register
#define LINE_STATUS_REG_1               0x2D
// Receiver buffer register
#define RECEIVER_BUFFER_REG_1           0x28
// Transmitter buffer register
#define TRANSMITTER_BUFFER_REG_1        0x28

// FIFO Control Register - CHANNEL 2
#define FIFO_CTRL_REG_2                 0x22
// Line Control Register
#define LINE_CTRL_REG_2                 0x23
// Divisor Latch Bytes
#define DIVISOR_LOW_BYTE_2              0x20
#define DIVISOR_HIGH_BYTE_2             0x21
// Line Status Register
#define LINE_STATUS_REG_2               0x25
// Receiver buffer register
#define RECEIVER_BUFFER_REG_2           0x20
// Transmitter buffer register
#define TRANSMITTER_BUFFER_REG_2        0x20

// baud rate divisor constants
#define BAUD_DIVISOR_38400              0x01
#define BAUD_DIVISOR_19200              0x02
#define BAUD_DIVISOR_9600               0x04

// FIFO size constants
#define FIFO_DISABLED                   0x06
#define FIFO_ENABLED                    0x07

#define FORMAT_8N1_SET_DIVISOR          0x83
#define FORMAT_8N1                      0x03

uart_init() {
    // FIFO Control Register
    outp(FIFO_CTRL_REG_1, FIFO_ENABLED); // clear buffers & set FIFO
    // Line Control Register
    outp(LINE_CTRL_REG_1, FORMAT_8N1_SET_DIVISOR); // 8 bits, no parity, 1 stop bit, SET divisor
    // Divisor Latch Bytes
    outp(DIVISOR_LOW_BYTE_1, BAUD_DIVISOR_38400); // Low Divisor Latch Bytes
    outp(DIVISOR_HIGH_BYTE_1, 0); // High Divisor Latch Bytes
    // Line Control Register
    outp(LINE_CTRL_REG_1, FORMAT_8N1); // 8 bits, no parity, 1 stop bit, UNSET divisor
}

/**
 * check status register
 * @return status reg
 */
uart_status() {
    return inp(LINE_STATUS_REG_1);
}

/**
 * check transmitter buffer
 * @return 1 when output buffer is capable of accepting more characters, 0 otherwise
 */
uart_output_buffer_accept() {
    return inp(LINE_STATUS_REG_1) & 0x20;
}

/**
 * check receiver buffer
 * @return 1 when data was received, 0 otherwise
 */
uart_input_data_received() {
    return inp(LINE_STATUS_REG_1) & 0x01;
}

/**
 * input from uart
 * @return input character
 */
uart_input() {
    return inp(RECEIVER_BUFFER_REG_1);
}

/**
 * send character over uart
 * @param c char to send
 */
uart_putc(char c) {
    outp(TRANSMITTER_BUFFER_REG_1, c);
}

uart_puts(char str[]) {
    //while(!uart_output_buffer_accept()); //only 16 chars can be sent at a time
    while(*str) {
        uart_putc(*str);
        str++;
    }
}
