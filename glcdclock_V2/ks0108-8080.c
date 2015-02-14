/*
 * Universal KS0108 driver library
 * 8080-based MCU low-level driver.
 */

#define PORTA 0x01
#define PORTB 0x02
#define PORTC 0x03

/*
 * PORT B:
 * data
 * 
 * PORT C:
 * 0 - CS1
 * 1 - CS2
 * 2 - D/I
 * 3 - R/W
 * 4 - E signal, H->L
 */
char port_c_value = 0x10;

extern char screen_x;
extern char screen_y;

char glcd_data[1024];
char glcd_ctrl;

/**
 * Enable Controller (0-2)
 * @param controller
 */
GLCD_EnableController(char controller) {
    port_c_value &= 0xFC;
    // 128 pixel display
    if (controller == 0) {
        port_c_value |= 0x01;
    } else {
        port_c_value |= 0x02;
    }
/*  192 pixel
    if (controller == 0) {
        port_c_value |= 0x00;
    } else if (controller == 1) {
        port_c_value |= 0x02;
    } else {
        port_c_value |= 0x01;
    }
*/
}

/**
 * Write command to specified controller
 * @param commandToWrite
 * @param controller
 */
GLCD_WriteCommand(char commandToWrite, char controller) {
    GLCD_EnableController(controller);
    outp(PORTB, commandToWrite);
    port_c_value &= 0x13;
    port_c_value |= 0x10;
    outp(PORTC, port_c_value);
    port_c_value &= 0x0F;
    outp(PORTC, port_c_value);
}

/**
 * Read data from current position
 * @return 
 */
GLCD_ReadData() {
    return glcd_data[(screen_x << 3) + (screen_y)];
}

/**
 * Write data to current position
 * @param dataToWrite
 */
GLCD_WriteData(char dataToWrite) {
    GLCD_EnableController(screen_x / 64);
    outp(PORTB, dataToWrite);
    port_c_value &= 0x17;
    port_c_value |= 0x14;
    outp(PORTC, port_c_value); // datapin is PC_0, enable pin is PC_5
    port_c_value &= 0x0F;
    outp(PORTC, port_c_value);

    glcd_data[(screen_x << 3) + screen_y] = dataToWrite;
    screen_x++;
}

