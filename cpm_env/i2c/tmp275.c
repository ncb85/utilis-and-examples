/**
 * File:   tmp275.c, jan 2016
 * routines for temperature sensor chip TMP275
 */

#define TMP275_ADDR 0x90

//configuration's register internal address is 1, 10bit resolution, +-0.25 C is 0x20
unsigned char cfg_data_cmd[] = {0x01, 0xA1};// one shot, shut down, 10bits
// temperature register is 0
unsigned char read_data_cmd[] = {0x00};
// here comes the data from TMP275 temp.registers
unsigned char temperature_buff[2];

/**
 * configure TMP275 to 10 bit resolution (1/4 of degree celsius accuracy)
 */
configure_tmp275() {
    int result;
    // params: device adr., buffer, length
    result = i2c_send_buffer(TMP275_ADDR, cfg_data_cmd, 2); // 2 bytes
}

/**
 * read temperature out of tmp275
 * @returns a int containing 16th multiple of temperature
 */
read_tmp275() {
    int result, tempr, whole, fract;
    // params: device adr., buffer, length
    result = i2c_send_buffer(TMP275_ADDR, read_data_cmd, 1); // 1 byte
    // read two temperature registers
    result = i2c_recv_buffer(TMP275_ADDR, temperature_buff, 2); // we want 2 bytes
    whole = temperature_buff[0] << 8;
    fract = temperature_buff[1];
    tempr = whole | fract;
    tempr = tempr >> 4;
    /*
    // following is valid for 10bit resolution
    fract = result%16;
    // if negative, inverse bits in fraction part
    if (result < 0) {
        fract = -fract;
    }
    fract = fract*25/4;
    printf("\ntemperature:%d.%02u degree Celsius", tempr/16, fract);
    */
    return tempr;
}

