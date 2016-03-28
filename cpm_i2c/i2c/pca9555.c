/**
 * File:   pca9555.c, jan 2016
 * routines for I/O port PCA9555
 */

#define PCA9555_ADDR 0x40

#define PORT_0      0
#define PORT_1      1

#define DIR_OUT     0
#define DIR_IN      1

//conf.port 0, all output
unsigned char data_port[2];
// led patterns
unsigned char pattern[] = {0xb6, 0x6d, 0xdb};

/**
 * rotate lit LEDs on port 0
 */
pca_led_demo() {
    int i,j,k;
    // set port for output
    i = set_port_pca9555(PORT_0, DIR_OUT);
    if (i != 0) {   // return on error
        return i;
    }
    // switch three patterns around
    for(j=0; j<60; j++) {
        if (j<30) {
            k = j%3;
        } else { // change flow back
            k = 2-j%3;
        }
        out_port_pca9555(PORT_0, pattern[k]);
        // delay
        for (i=0; i< 1500; i++) {
            i = i;
        }
    }
    // LEDs off
    out_port_pca9555(PORT_0, 0xFF);
}

/**
 * sets port 0/1 for input/output
 * @param port 0 or 1
 * @param direction IN or OUT
 * @return 
 */
set_port_pca9555(unsigned char port, unsigned char direction) {
    data_port[0] = port+6;  // PCA's registers 6 and 7
    if (direction == DIR_OUT) {
        data_port[1] = 0x00;
    } else {
        data_port[1] = 0xFF;
    }
    // params: device adr., buffer, length
    i2c_send_buffer(PCA9555_ADDR, data_port, 2); // 2 bytes
}

/**
 * set value to port's output latch
 * @param port 0 or 1
 * @param value the value
 * @return 
 */
out_port_pca9555(unsigned char port, unsigned char value) {
    data_port[0] = port+2;// PCA's registers 2 and 3
    data_port[1] = value;
    i2c_send_buffer(PCA9555_ADDR, data_port, 2);
}