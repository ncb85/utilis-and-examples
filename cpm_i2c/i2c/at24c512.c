/**
 * File:   at24c512.c, jan 2016
 * routines for 64k x 8 bit I2C EEPROM
 * 128-byte page write
 */

#define AT24C512_ADDR 0xA0

#define ADR_HIGH    0
#define ADR_LOW     1


//address buffer
unsigned char addr_buff[2];

/**
 * read data form 24LC512
 * @param data_dest
 * @param len
 * @return 
 */
read_at24c512(char data_dest[], int len) {
    int result;
    //set register pointer to 0 - seconds
    i2c_send_buffer(AT24C512_ADDR, reg0_data, 1);
    // read out 7 registers, seconds, minutes ...
    result = i2c_recv_buffer(AT24C512_ADDR, data_buff, 7);
}

/**
 * write data to 24LC512
 * @param data_dest
 * @param len
 * @return 
 */
write_at24c512(char data_dest[], int len) {
    data_port[0] = 2;// address..
    data_port[1] = value;
    i2c_send_buffer(AT24C512_ADDR, data_port, 2);
}