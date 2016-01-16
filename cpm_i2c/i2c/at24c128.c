/**
 * File:   at24c128.c, jan 2016
 * routines for 16/32k x 8 bit I2C EEPROMs 24C128, 24C256
 * 64-byte page write
 */

#define AT24C128_ADDR 0xA0

#define ADR_HIGH        0
#define ADR_LOW         1

#define OK_I2C          0
#define ERR_WAIT_PIN    1
#define ERR_NO_ACK      2

#define PAGE_SIZE       64

//address buffer
unsigned char addr_buff[2];

/**
 * read data from 24C128/256
 * @param data_dest dest.buffer
 * @param eeprom_addr address to read from
 * @param len max 64k
 * @return 
 */
read_at24c512(char data_dest[], int eeprom_addr, int len) {
    int result, tmp_len;
    //set temporarily eeprom source address in the first two bytes of dest.buffer
    addr_buff[0] = eeprom_addr >> 8;
    addr_buff[1] = eeprom_addr;
    i2c_send_buffer(AT24C128_ADDR, addr_buff, 2);
    // read number of bytes
    result = i2c_recv_buffer(AT24C128_ADDR, data_dest, len);
    return result;
}

/**
 * write data to 24C128/256
 * @param data_dest address of source buffer
 * @param eeprom_addr address to write to, must begin on page boundary when using paged write
 * @param len max 64
 * @return 
 */
write_at24c512(char data_src[], int eeprom_addr, int len) {
    int result, tmp_len, retry, pages;
    result = OK_I2C;
    tmp_len = eeprom_addr % PAGE_SIZE;
    pages = 0;
    if (tmp_len != 0) { // off page multiple address
        // write data
        result = i2c_send_buffer_with_addr(eeprom_addr, AT24C128_ADDR, data_src, tmp_len);
        eeprom_addr += tmp_len;
        data_src += tmp_len;
        len -= tmp_len;
        pages++;
    }
    // write 64-byte sized blocks (EEPROM page write size)
    for (tmp_len = len < PAGE_SIZE ? len : PAGE_SIZE; (len > 0) && (result == OK_I2C);pages++) {
        result = ERR_NO_ACK;
        // wait for eeprom to finish previous page write
        for (retry = 0; (result == ERR_NO_ACK) && (retry < 10); retry++) {
            result = i2c_send_buffer_with_addr(eeprom_addr, AT24C128_ADDR, data_src, tmp_len);
        }
        if (result == ERR_NO_ACK) {
            printf("\ncould not write");
        }
        eeprom_addr += tmp_len;
        data_src += tmp_len;
        if (len < PAGE_SIZE) { // last write of remaining off page data
            tmp_len = len;
        }
        len -= tmp_len;
    }
    printf("\npages written:%d\n", pages);
    return result;
}