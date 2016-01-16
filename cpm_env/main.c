/*
 * File:   main.c, jan 2016
 * i2c test on CP/M
 */
#include <stdio.h>

/**
 * main routine
 * @return
 */
main(int argc, int argv[]) {
    int i,j,k;
    
    i2c_init_pcf8584();
    configure_tmp275(); // 10-bit resolution
    
    // last visit - stored in SRAM of DS1307
    last_visit_time_ds1307();
    i = get_date_ds1307();
    j = get_month_ds1307();
    k = get_year_ds1307();
    printf("Last time you were here: %u.%u.20%u", i, j, k);
    i = get_second_ds1307();
    j = get_minute_ds1307();
    k = get_hour_ds1307();
    printf(", time: %02u:%02u:%02u\n", k, j, i);
    // ambient temperature
    i = read_tmp275();
    // following yields two decimal places only for 10-bit resolution
    // 11-bit would give results like 87.5
    j = i%16;
    // if negative, inverse bits in fraction part
    if (i < 0) {
        j = -j;
    }
    j = j*25/4;
    printf("Today is: %d.%02u'C", i/16, j);
    // actual time
    refresh_time_ds1307();
    i = get_date_ds1307();
    j = get_month_ds1307();
    k = get_year_ds1307();
    printf(", date: %u.%u.20%u", i, j, k);
    i = get_second_ds1307();
    j = get_minute_ds1307();
    k = get_hour_ds1307();
    printf(", time: %02u:%02u:%02u\n", k, j, i);
    // store actual time for future run as last visit time
    backup_visit_time_ds1307();
    
}
