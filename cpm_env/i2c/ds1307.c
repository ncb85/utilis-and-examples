/**
 * File:   ds1307.c, january 2016
 * routines for real time clock chip DS1307
 */

#define DS1307_ADDR     0xD0

#define SECOND_REG      0x00
#define MINUTE_REG      0x01
#define HOUR_REG        0x02
#define DATE_REG        0x04
#define MONTH_REG       0x05
#define YEAR_REG        0x06
#define CONTROL_REG     0x07
#define SRAM_BEGIN      0x08

// data buffer
unsigned char data_buff[8];
// variables
unsigned char day, date, month, year, hour, minute, second;

/**
 * Init the DS1307
 * The time and calendar information is obtained by reading the appropriate
 * register bytes. Table 2 shows the RTC registers. The time and calendar are set
 * or initialized by writing the appropriate register bytes.
 * The contents of the time and calendar registers are in the BCD format.
 * The day-of-week register increments at midnight. Values that correspond to
 * the day of week are user-defined but must be sequential (i.e., if 1 equals Sunday,
 * then 2 equals Monday, and so on.) Illogical time and date entries result in
 * undefined operation. Bit 7 of Register 0 is the clock halt (CH) bit. When this bit
 * is set to 1, the oscillator is disabled. When cleared to 0, the oscillator is enabled.
 * Please note that the initial power-on state of all registers is not defined.
 * Therefore, it is important to enable the oscillator (CH bit = 0) during
 * initial configuration
 */
init_ds1307() {
    set_reg_ds1307(CONTROL_REG, 0x08);
    set_reg_ds1307(SECOND_REG, 0); // reset clock halt bit
}

/**
 * read time out of DS1307 into data_buff
 * @return
 */
refresh_time_ds1307() {
    //set register pointer to 0 - seconds
    data_buff[0] = SECOND_REG; // seconds register in DS1307
    fetch_data_ds1307();
}

/**
 * read last visit time from battery backed SRAM area
 * @return 
 */
last_visit_time_ds1307() {
    data_buff[0] = SRAM_BEGIN; // set first SRAM address in DS1307
    fetch_data_ds1307(); // read backed up date & time
}

/**
 * read date time out of DS1307 into data_buff
 * data_buff's first member contains address of starting register, next positions
 * will be filled with the content from DS1307
 * @return success code
 */
fetch_data_ds1307() {
    int result;
    i2c_send_buffer(DS1307_ADDR, data_buff, 1);
    // read out 7 registers, seconds, minutes ... leave first data empty
    result = i2c_recv_buffer(DS1307_ADDR, data_buff+1, 7);
    //report(result);
    second = bcd_to_bin(data_buff[1]);
    minute = bcd_to_bin(data_buff[2]);
    hour = bcd_to_bin(data_buff[3]);
    day = bcd_to_bin(data_buff[4]);
    date = bcd_to_bin(data_buff[5]);
    month = bcd_to_bin(data_buff[6]);
    year = bcd_to_bin(data_buff[7]);
    return result;
}

/**
 * store actual visit time (in data_buff) into battery backed SRAM area
 * @return 
 */
backup_visit_time_ds1307() {
    data_buff[0] = SRAM_BEGIN; // set first SRAM address in DS1307
    // save data to battery backed up SRAM
    i2c_send_buffer(DS1307_ADDR, data_buff, 8); // 1 byte reg.address, 7 bytes data
}

/**
 * Set time to DS1307
 * The DS1307 can be run in either 12-hour or 24-hour mode. Bit 6 of the hours register
 * is defined as the 12-hour or 24-hour mode-select bit. When HIGH, the 12-hour mode
 * is selected. In the 12-hour mode, bit 5 is the AM/PM bit with logic high being PM.
 * In the 24-hour mode, bit 5 is the second 10-hour bit (20 to 23 hours). The hours
 * value must be re-entered whenever the 12/24-hour mode bit is changed.
 * @param hour
 * @param min
 * @param sec
 */
set_time_ds1307(unsigned char hour, unsigned char min, unsigned char sec) {
    set_reg_ds1307(SECOND_REG, bin_to_bcd(sec));
    set_reg_ds1307(MINUTE_REG, bin_to_bcd(min));
    set_reg_ds1307(HOUR_REG, bin_to_bcd(hour));
}

/**
 * Set date to DS1307
 * @param hour
 * @param min
 * @param sec
 */
set_date_ds1307(unsigned char year, unsigned char month, unsigned char date) {
    set_reg_ds1307(DATE_REG, bin_to_bcd(date));
    set_reg_ds1307(MONTH_REG, bin_to_bcd(month));
    set_reg_ds1307(YEAR_REG, bin_to_bcd(year));
}

/**
 * Set one register in DS1307
 * @param reg register address
 * @param value
 */
set_reg_ds1307(unsigned char reg, unsigned char value) {
    data_buff[0] = reg;
    data_buff[1] = value;
    i2c_send_buffer(DS1307_ADDR, data_buff, 2); // reg address and value
}

/**
 * get combined hour/minute BCD encoded time from DS1307
 * @return int "0955" -> 09:55
 */
get_ctime_ds1307() {
    unsigned int result;
    result = 100*hour;
    result += minute;
    return result;
}
/**
 * get combined day/month BCD encoded date from DS1307
 * @return int "3112" -> 31.12.
 */
get_cdate_ds1307() {
    unsigned int result;
    result = 100*date;
    result += month;
    return result;
}

/**
 * get seconds from DS1307 in BCD format
 */
get_second_ds1307() {
    return second;
}

/**
 * get minutes from DS1307 in BCD format
 */
get_minute_ds1307() {
    return minute;
}

/**
 * get hours from DS1307 in BCD format
 */
get_hour_ds1307() {
    return hour;
}

/**
 * get day from DS1307 in BCD format
 */
get_day_ds1307() {
    return day;
}

/**
 * get date from DS1307 in BCD format
 */
get_date_ds1307() {
    return date;
}

/**
 * get month from DS1307 in BCD format
 */
get_month_ds1307() {
    return month;
}

/**
 * get year from DS1307 in BCD format
 */
get_year_ds1307() {
    return year;
}

/**
 * converts BCD encoded byte to bin value, e.g "99" to 63h, or 99d
 * @param bcd
 * @return bin value
 */
bcd_to_bin(unsigned char bcd) {
    unsigned char result;
    result = bcd >> 4;
    result *= 10;
    result += bcd & 0x0F;
    return result;
}

/**
 * converts bin value to BCD encoded byte
 * @param bin must be less then 100 binary
 * @return BCD encoded byte
 */
bin_to_bcd(unsigned char bin) {
    unsigned char result;
    result = ((bin/10)<<4) | (bin%10);
    return result;
}