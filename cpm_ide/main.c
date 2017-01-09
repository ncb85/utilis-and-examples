/*
 * File:   main.c, dec 2016
 * IDE test on CP/M
 */
#include <stdio.h>

// constants
#define CTRL_Q                  0x11
#define CTRL_C                  0x03
#define CTRL_Z                  0x1A

char user_response[82];
unsigned char heads, sectors, head_nr, sector_nr;
unsigned int cylinders, capacity, position, cylinder_nr;
extern unsigned char lba_flag, LBA[], BUFFER[], lng_buff[];

/**
 * Returns 00 if no key was pressed. Otherwise return key code. Non blocking method.
 * No echo on screen.
 * @return 
 */
console_keypress() {
    return bdos1(6, 0xFF);
}

/**
 * Returns key pressed.
 * @return 
 */
console_getc() {
    return bdos1(1, 0);
}

/**
 * get input text from console
 * @return command line
 */
console_gets() {
    char len;
    user_response[0] = 80; // allow to type in max 80 keys
    bdos(10, user_response);
    len = user_response[1]; // length of typed line
    user_response[len + 2] = 0; // terminate typed in string
    return user_response+2;
}

/**
 * get number
 * @return number
 */
get_number() {
    unsigned int nr, i;
    char buff[];
    nr = 0;
    i = 0;
    buff = console_gets();
    while (buff[i]) {
        if (buff[i] >= '0' && buff[i] <= '9') {
            nr = nr * 10 + buff[i] - '0';
        } else {
            return -1;
        }
        ++i;
    }
    printf("%u", nr);
    return nr;
}

/**
 * get hex number
 * @return hex number
 */
get_hex_number() {
    int nr, i;
    char buff[];
    nr = 0;
    i = 0;
    buff = console_gets();
    while (buff[i]) {
        if (buff[i] >= '0' && buff[i] <= '9') {
            nr = nr * 16 + buff[i] - '0';
        } else if (buff[i] >= 'a' && buff[i] <= 'f') {
            nr = nr * 16 + buff[i] - 'a' + 10;
        } else if (buff[i] >= 'A' && buff[i] <= 'F') {
            nr = nr * 16 + buff[i] - 'A' + 10;
        } else {
            return -1;
        }
        ++i;
    }
    printf("%d", nr);
    return nr;
}

/**
 * get max number with prompt
 * @param msg the prompt
 * @param minval min value
 * @param maxval max value
 * @return entered number
 */
get_nr(char *msg, unsigned int minval, unsigned int maxval) {
    unsigned int nr;
    do {
        printf("\n%s? (%u-%u)\n", msg, minval, maxval);
        nr = get_number();
    } while (nr < minval || nr > maxval);
    return nr;
}

/**
 * set CHS into LBA
 * 28-bit unsigned binary number:
 *  bits 27–24 into the Drive/Head register bits 3–0
 *  bits 23–16 into the Cylinder High register
 *  bits 15–8 into the Cylinder Low register
 *  bits 7–0 into the Sector Number register
 * @param interactive ask user or not
 */
setup_lba(unsigned char interactive) {
    unsigned char hd_nr, sec_nr;
    unsigned int lgcl_sec_nr, cyl_nr;
    if (lba_flag) {
        if (interactive) {
            printf("\nUsing LBA\n");
            lgcl_sec_nr = get_nr("Logical sec nr.", 0, capacity-1);
        } else {
            lgcl_sec_nr = position;
        }
        LBA[3] = 0;
        LBA[2] = 0;
        LBA[1] = lgcl_sec_nr >> 8;
        LBA[0] = lgcl_sec_nr;
    } else {
        if (interactive) {
            printf("Using geometry:");
            hd_nr = get_nr("head nr.", 0, heads-1);
            cyl_nr = get_nr("cyl nr.", 0, cylinders-1);
            sec_nr = get_nr("sec nr.", 1, sectors);
        } else {
            hd_nr = head_nr;
            cyl_nr = cylinder_nr;
            sec_nr = sector_nr;
        }
        LBA[3] = hd_nr & 0x0f;
        LBA[2] = (cyl_nr >> 8) & 0xff;
        LBA[1] = cyl_nr;
        LBA[0] = sec_nr;
    }
}

/**
 * swap two bytes of an integer
 * @param num
 * @return swapped int
 */
swap_int(unsigned int num) {
    unsigned char div, mod;
    div = num / 256;
    mod = num % 256;
    return mod*256+div;
}

/**
 * report data returned by identify command
 */
report() {
    char msg[];
    unsigned int num, num2, *iptr, cls;
    unsigned char hds, scts;
    // Word 27–46 Model number (40 ASCII characters, left justified and padded with spaces [20H])
    msg = BUFFER+54;
    msg[40] = 0; // terminate string
    printf("Model: %s\n", msg);
    // Word 10–19 Serial number(20 ASCII characters, right justified and padded with spaces [20H])
    msg = BUFFER+20;
    msg[20] = 0; // terminate string
    printf("S/N:   %s\n", msg);
    // Word 23–26 Firmware revision(8 ASCII characters, left justified and padded with spaces [20H])
    msg = BUFFER+46;
    msg[8] = 0; // terminate string
    printf("Rev:   %s\n", msg);
    // Word 60–61 Total number of user-addressable sectors (LBA mode only)
    iptr = BUFFER+122;
    num2 = *iptr;
    *iptr = num2 = swap_int(num2);
    iptr = BUFFER+120;
    num = *iptr;
    *iptr = capacity = swap_int(num);
    printf("LBA capacity\nCapacity in sectors hex: %04x%04x\n", num2, capacity); // for big cards
    long_rlsft(BUFFER+120, 1); // shift unsigned long integer logically right
    long_to_dec(BUFFER+120); //convert long to decimal
    remove_zeroes(lng_buff); // remove leading zeroes
    printf("Capacity in kilobytes: %s\n", lng_buff);
    //57–58 — Current capacity in sectors, not valid unless bit 0 of word 53 is set to 1
    iptr = BUFFER+106;
    num2 = *iptr;
    num2 = swap_int(num2);
    if (num2%1 == 1) {
        iptr = BUFFER+114;
        num2 = *iptr;
        num2 = swap_int(num2);
        iptr = BUFFER+116;
        num = *iptr;
        num = swap_int(num);
        printf("Current capacity in sectors: %04x%04x\n", num2, num);
    }
    //Devices reporting the value 848Ah in IDENTIFY DEVICE data word 0 or devices having
    //bit 2 of IDENTIFY DEVICE data word 83 set to one shall support the CFA feature Set.
    //If the CFA feature set is implemented, all the CFA commands and the Enable/Disable
    //8-Bit transfers shall be implemented
    iptr = BUFFER;
    num = *iptr;
    num = swap_int(num);
    iptr = BUFFER+166;
    num2 = *iptr;
    num2 = swap_int(num2);
    //printf("data word 83:%x\n", num2);
    if ((num == 0x848A) || ((num2 & 0x04) == 1)) {
        printf("CFA 8-bit transfer supported\n");
    }
    // drive geometry - cylinders, heads, sectors
    iptr = BUFFER+2; // Word 1 Number of cylinders
    num = *iptr;
    num = swap_int(num);
    cls = num;
    iptr = BUFFER+6; // Word 3 Number of heads
    num = *iptr;
    num = swap_int(num);
    hds = num;
    iptr = BUFFER+12; // Word 6 Number of sectors per track
    num = *iptr;
    num = swap_int(num);
    scts = num;
    printf("Cylinders: %u\n", cls);
    printf("Heads: %u\n", hds);
    printf("Sectors: %u\n", scts);
    if (cls > 0 && hds > 0 && scts > 0) {
        printf("Accept geometry? (y/n)\n");
        msg[0] = console_getc();
        if (msg[0] == 'y') {
            heads = hds;
            cylinders = cls;
            sectors = scts;
        }
    }
}

/**
 * show status
 */
show_status() {
    unsigned char j;
    j = ide_get_status();
    printf("Status: %02xh (80 bsy, 40 rdy, 20 write fault, 10 no seek, 08 drq, 01 err)\n", j);
    // error ?
    if (j & 0x01) {
        eval_error();
    }
}

/**
 * print error msg
 */
eval_error() {
    unsigned char error;
    error = ide_get_error();
    printf("Error %02x\n", error);
    if (error & 0x01) {
        printf("Address mark not found\n");
    }
    if (error & 0x02) {
        printf("Track 0 not found\n");
    }
    if (error & 0x04) {
        printf("Command aborted\n");
    }
    if (error & 0x08) {
        printf("Removable media required\n");
    }
    if (error & 0x10) {
        printf("Sector ID not found\n");
    }
    if (error & 0x20) {
        printf("Media changed\n");
    }
    if (error & 0x40) {
        printf("Unrecoverable data error\n");
    }
    if (error & 0x80) {
        printf("Bad block mark in sector ID field\n");
    }
}

/**
 * fill buffer with a value
 */
fill_buffer() {
    int i, val;
    val = get_nr("fill value", 0, 255);
    for (i=0;i<512;i++) {
        BUFFER[i] = val;
    }
}

dump_buffer() {
    int i,j;
    unsigned char p;
	for (i=0; i<512; i+=16) {
        printf("\n");
        for (j=0; j<16; j++) {
            p = BUFFER[i+j];
            printf("%02x ", p);
        }
        printf("    ");
        for (j=0; j<16; j++) {
            p = BUFFER[i+j];
            if (p < 32 || p > 126) {
                p = '.';
            }
            printf("%c", p);
        }
    }
    printf("\n");
}

format() {
    unsigned int i,j,k,l,m;
    char p;
    printf("\nAre you sure? Press 'y' to proceed, any other key for break\n");
    p = console_getc();
    if (p == 'y') {
        fill_buffer();
        m = 0;
        if (lba_flag) { // format in LBA mode
            printf("\nFormat using LBA addressing\n");
            printf("\nformatting 00%%");
            for (position=0; position<capacity; position++) {
                setup_lba(0); // not interactive - use position variable
                i = ide_write_sector();
                ++m;
                if (m == 150) { //each 150 sectors refresh screen
                    m = 0;
                    printf("%c%c%c%02u%%", 8, 8, 8, (position-1)/(capacity/100)); // 8,8,8 - 3 x backspaces
                }
                if (i != 0) {
                    printf("Format failed\n");
                    eval_error();
                    break;
                }
                // key pressed ?
                p = console_keypress();
                if (p == CTRL_C) {
                    return;
                }
            }
        } else {
            printf("\nFormat using drive geometry\n");
            printf("\nformatting 00%%");
            for (i=0; i<cylinders; i++) {
                for (j=0; j<heads; j++) {
                    for (k=1; k<=sectors; k++) {
                        cylinder_nr = i;
                        head_nr = j;
                        sector_nr = k;
                        setup_lba(0); // not interactive - use position variable
                        l = ide_write_sector();
                        ++m;
                        if (m == 150) { //each 150 sectors refresh screen
                            m = 0;
                            printf("%c%c%c%02u%%", 8, 8, 8, (i*10)/(cylinders/10)); // 8,8,8 - 3 x backspaces
                        }
                        if (l != 0) {
                            printf("Format failed\n");
                            eval_error();
                            break;
                        }
                        // key pressed ?
                        p = console_keypress();
                        if (p == CTRL_C) {
                            return;
                        }
                    }
                }
            }
        }
        printf("%c%c%c100%% done\n", 8, 8, 8);
    }
}

/**
 * main routine
 * @return
 */
main(int argc, int argv[]) {
    unsigned int i,j,show_stat;
    char p;
    printf("IDE Disk Drive Test Program\n");
    while(1) {
        do {
            printf("Menu:\ne. exit, n. init IDE, t. reset IDE, s. status, c. drive ID, r. read sector\n");
            printf("w. write sector, u. spin up, o. spin down, d. dump buffer., l. fill buffer\n");
            printf("f.format disk, g. choose geometry CHS or LBA");
            printf("\nYour choice?\n");
            p = console_getc();
        } while (p < 'a' || p > 'z');
        show_stat = 1;
        switch (p) {
            case 'e':
                exit(1);
            case 'n':
                printf("\nInit IDE\n");
                ide_init();
                break;
            case 't':
                printf("\nReset IDE\n");
                ide_hard_reset();
                break;
            case 'u':
                printf("\nSpin up\n");
                ide_spinup();
                break;
            case 'o':
                printf("\nSpin up\n");
                ide_spindown();
                break;
            case 's':
                printf("\nStatus\n");
                show_status();
                show_stat = 0;
                break;
            case 'c':
                printf("\nDrive ID\n");
                ide_drive_id();
                report();
                break;
            case 'b':
                printf("\nDrive ID\n");
                ide_drive_id();
                dump_buffer();
                break;
            case 'g':
                printf("\nGeometry CHS or LBA? Press 'g' for geometry, any other key for LBA\n");
                p = console_getc();
                if (p == 'g') {
                    lba_flag = 0;
                } else {
                    lba_flag = 0x40;
                }
                break;
            case 'r':
                setup_lba(1);
                i = ide_read_sector();
                if (i==0) {
                    printf("\nSector Read OK\n");
                } else {
                    printf("Sector Read Error %02xh\n", i);
                    eval_error();
                }
                break;
            case 'w':
                setup_lba(1);
                i = ide_write_sector();
                if (i==0) {
                    printf("\nSector Write OK\n");
                } else {
                    printf("\nSector Write Error %02xh\n", i);
                    eval_error();
                }
                break;
            case 'd':
                dump_buffer();
                break;
            case 'l':
                fill_buffer();
                break;
            case 'f':
                format();
                break;
            default:
                break;
        }
        if (show_stat) {
            show_status();
        }
    }
}
