/*
 * File:   main.c, march 2014
 * fdc test on CP/M
 */
#include <stdio.h>

#define CTRL_C                  0x03

char user_response[82], drv;
unsigned int num_of_tracks, single_sided;
extern unsigned char status_reg_0, status_reg_1, status_reg_2, status_reg_3;
extern unsigned char number_of_sctrs, NUMBER_OF_BYTES, SECTOR_SIZE, sector_fnr[], dbuffer[];
extern unsigned char head_nr, track_nr, sector_nr, drive_nr;
extern unsigned char ccr_dsr_value, mode3_value, GAP_LENGTH, GAP3_LENGTH;
extern unsigned char CMD_FORMAT, CMD_READ, CMD_WRITE;

// SmallC recognizes define "smallc", Netbeans not
#ifndef smallc
set_drv_type0();
set_drv_type1();
set_drv_type2();
set_drv_type3();
set_drv_type4();
set_drv_type5();
fd_nsc();
fd_init();
fd_msr();
motor_off();
sense_intrpt();
fd_format();
#endif
// this block is here just to fool Netbeans IDE's parser

/**
 * set drive parameters
 * @param p
 * @return 
 */
set_drive_type(char p) {
    single_sided = 0;
    switch (p) {
        case '0': // 5.25, 360k, DD, 40 tracks
            set_drv_type0();
            break;
        case '1': // 5.25, 720k, DD, 80 tracks
            set_drv_type1();
            break;
        case '2': // 5.25, 1.2M, HD, 80 tracks
            set_drv_type2();
            break;
        case '3': // 3.5, 1.44M, HD, 80 tracks
            set_drv_type3();
            break;
        case '4': // 5.25, 720k, DD in HD drive, 360rpm, 80 tracks
            set_drv_type4();
            break;
        case '5': // 8, 1M, DS/DD drive, 360rpm, 77 tracks
            set_drv_type5();
            break;
        case '6': // 8, 500k, SS/DD drive, 360rpm, 77 tracks
            set_drv_type5();
            single_sided = 1;
            break;
        case '7': // 8, 250k, SS/SD drive, 360rpm, 77 tracks
            set_drv_type5();
            single_sided = 1;
            CMD_FORMAT &= 0xBF; // bit 6 of command is FM/MFM flag, set 0
            CMD_READ &= 0xBF;   // bit 6 of command is FM/MFM flag, set 0
            CMD_WRITE &= 0xBF;  // bit 6 of command is FM/MFM flag, set 0
            NUMBER_OF_BYTES = 0;// 128 byte sectors
            SECTOR_SIZE = 128;
            break;
        default:
            break;
    }
}

/**
 * generate sector numbers for given interleave factor
 * @param interl
 * @return 
 */
generate_sec_numbers(int interl) {
    int i,j;
    //erase array
    for (i=0; i<number_of_sctrs; i++) {
	    sector_fnr[i] = 255;
	}
    //compute sec.numbers
	j = 0;
	for (i=0; i<number_of_sctrs; i++) {
        sector_fnr[j] = i;
        if (i == number_of_sctrs - 1) {
              break;
        }
        j += interl;
        //skip positions that already have number
	    while (j >= number_of_sctrs || sector_fnr[j] != 255) {
            if (j >= number_of_sctrs) {
                j -= number_of_sctrs;
            } else {
		        j++;
            }
	    }
	}
    //printf("\n");
	//for (i=0; i<number_of_sctrs; i++) {
    //    printf("%02d,", sector_fnr[i]);
	//}
}

cmd_recalibrate() {
    drive_nr = drv;
#ifdef smallc
#asm
    xra a
    call fd_exec_cmd
#endasm
#endif    
}

cmd_seek_track(int ptrack_nr) {
    drive_nr = drv;
    track_nr = ptrack_nr;
    head_nr = 0;
    sector_nr = 0;
#ifdef smallc
#asm
    mvi a,1
    call fd_exec_cmd
#endasm
#endif    
}

cmd_sense_interrupt() {
    int result;
    result = sense_intrpt();
    report(result, 1);
}

cmd_format(int ptrack_nr, int phead_nr) {
    int result, i, j;
    cmd_seek_track(ptrack_nr);
    i = 0;
    // wait for seek end
    while ((i<1000) && (fd_msr()!=0x80)) {
        i++;
        if (i == 1000) {
            printf("seek before format failed\n");
            return -1;
        }
    }
    
    // prepare data for 4x NUM_OF_SECTORS (track, head, sector, bytes pre sector)
    for (i=0; i<number_of_sctrs; i++) {
        j = 4 * i;
        dbuffer[j++] = ptrack_nr;
        dbuffer[j++] = phead_nr;
        // for FM 128 byte sectors count from 1, for MFM from 0
        dbuffer[j++] = NUMBER_OF_BYTES == 0 ? sector_fnr[i] + 1 : sector_fnr[i];
        dbuffer[j] = NUMBER_OF_BYTES;
    }
    drive_nr = drv;
    track_nr = ptrack_nr;
    head_nr = phead_nr;
    sector_nr = 0;
    result = fd_format();
    return result == 0 ? 1 : -1;
}

cmd_read(int ptrack_nr, int psector_nr, int phead_nr) {
    drive_nr = drv;
    track_nr = ptrack_nr;
    head_nr = phead_nr;
    sector_nr = psector_nr;
#ifdef smallc
#asm
    mvi a,2
    call fd_exec_cmd
#endasm
#endif    
}

cmd_write(int ptrack_nr, int psector_nr, int phead_nr) {
    drive_nr = drv;
    track_nr = ptrack_nr;
    head_nr = phead_nr;
    sector_nr = psector_nr;
    printf("\nWriting data to track %02d, sector %02d, head %d\n", track_nr, sector_nr, head_nr);
#ifdef smallc
#asm
    mvi a,3
    call fd_exec_cmd
#endasm
#endif    
}

dump_buffer() {
    int i,j;
    unsigned char p;
	for (i=0; i<(SECTOR_SIZE == 128 ? 128 : 256); i+=16) {
        printf("\n");
        for (j=0; j<16; j++) {
            p = dbuffer[i+j];
            printf("%02x ", p);
        }
        printf("    ");
        for (j=0; j<16; j++) {
            p = dbuffer[i+j];
            if (p < 32 || p > 126) {
                p = '.';
            }
            printf("%c", p);
        }
    }
}

fill_buffer() {
    int i, j, k;
    char p;
    j = 0;
    k = SECTOR_SIZE == 128 ? 128 : 256;
    printf("press a letter to fill the buffer with");
    p = console_getc();
	for (i=0; i<k; i++) {
        for (;i<10;i++) {
            dbuffer[i] = '0' + i;
        }
        dbuffer[i] = p;
        for (;i>(k-5) && i<k;i++) {
            dbuffer[i] = p + ++j;
        }
    }
}

modify_buffer() {
    int address, value;
    do {
        printf("\naddress? (0-255)\n");
        address = get_number();
    } while (address < 0 || address > 255);   
    do {
        printf("\nvalue (%d)(%xh)? (0-255)\n", dbuffer[address], dbuffer[address]);
        value = get_number();
    } while (value < 0 || value > 255);   
    dbuffer[address] = value;
}

report(int result, int full_report) {
    if (full_report) {
        printf("\nReport :");
    }
    switch(result) {
        case 0:
            printf("OK\n");
            break;
        case 1:
            printf("bad drive\n");
            break;
        case 2:
            printf("format failed\n");
            break;
        case 3:
            printf("sense failed\n");
            break;
        case 4:
            printf("equipment check\n");
            break;
        case 5:
            printf("seek failed\n");
            break;
        case 6:
            printf("fdc not ready for a byte\n");
            break;
        case 7:
            printf("drive busy\n");
            break;
        case 8:
            printf("timeout waiting\n");
            break;
        case 9:
            printf("data not ready\n");
            break;
        case 10:
            printf("st0 abnormal termination\n");
            break;
        case 11:
            printf("st1 end of track\n");
            break;
        case 12:
            printf("st1 CRC error\n");
            break;
        case 13:
            printf("st1 overrun\n");
            break;
        case 14:
            printf("st1 no data\n");
            break;
        case 15:
            printf("st1 missing address mark\n");
            break;
        case 16:
            printf("st1 write protect\n");
            break;
        case 17:
            printf("st2 bad track\n");
            break;
        case 18:
            printf("st2 CRC error\n");
            break;
        case 19:
            printf("st2 missing address mark\n");
            break;
        case 20:
            printf("st2 scan not satisfied\n");
            break;
        case 21:
            printf("too many status reads\n");
            break;
        case 22:
            printf("command aborted\n");
            break;
        default:
            printf("unknown report error %04x\n", result);
            break;
    }
    if (full_report) {
        printf("Status bytes %08b,%02x,%02x,%02x\n", status_reg_0, status_reg_1, status_reg_2, status_reg_3);
        printf("Sectors %d\n", number_of_sctrs);
    }
}


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
 * @return track number, sector number, interleave etc..
 */
get_number() {
    int nr, i;
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
    printf("%d", nr);
    return nr;
}

get_track_nr() {
    int track_nr;
    do {
        printf("\ntrack number? (0-%d)\n", num_of_tracks-1);
        track_nr = get_number();
    } while (track_nr < 0 || track_nr > (num_of_tracks-1));
    return track_nr;
}

get_sector_nr() {
    int sector_nr;
    // IBM FM 128 byte sector, NUMBER_OF_BYTES is 0
    if (NUMBER_OF_BYTES == 0) { // 128 x 2^0
        // IBM counts sectors from 1
        do {
            printf("\nsector number? (1-%d)\n", number_of_sctrs);
            sector_nr = get_number();
        } while (sector_nr < 1 || sector_nr > number_of_sctrs);
    } else { // my own format starts from zero, PC8477 has no problem with it
        do {
            printf("\nsector number? (0-%d)\n", number_of_sctrs-1);
            sector_nr = get_number();
        } while (sector_nr < 0 || sector_nr > number_of_sctrs-1);
    }
    return sector_nr;
}

get_head_nr() {
    int head_nr;
    if (single_sided) {
        return 0;
    }
    do {
        printf("\nhead number? (0-1)\n");
        head_nr = get_number();
    } while (head_nr < 0 || head_nr > 1);
    return head_nr;
}

get_interleave() {
    int interleave;
    do {
        printf("\ninterleave? (1-9) (recom. 1.44MB/3, 1.2MB/3, 360kB/4)\n");
        interleave = get_number();
    } while (interleave < 1 || interleave > 9);
    return interleave;
}

/**
 * main routine
 * @return
 */
main(int argc, int argv[]) {
    char p;
    int track_nr, sector_nr, sec_nr, head_nr, interleave, result;
    int error, stop, alloc_unit, position, dump_disk;
    
    printf("FDC test for floppy drive\n");
    printf("Press 0 for 5.25\", double density, 40 tracks, (360k)\n");
    printf("Press 1 for 5.25\", double density, 80 tracks, (720k)\n");
    printf("Press 2 for 5.25\", high density, 80 tracks, (1.2M)\n");
    printf("Press 3 for 3.5\", high density, 80 tracks, (1.44M)\n");
    printf("Press 4 for 5.25\", double density, HD drive, 360rpm, 80 tracks(720k)\n");
    printf("Press 5 for 8\", double sided, double density, 360rpm, 77 tracks(1M)\n");
    printf("Press 6 for 8\", single sided, double density, 360rpm, 77 tracks(500k)\n");
    printf("Press 7 for 8\", single sided, single density, 360rpm, 77 tracks(250k)\n");
    do {
        p = console_getc();
    } while (p < '0' || p > '7');
    set_drive_type(p);
    printf("\nPress 0..3 for drive number\n");
    do {
        p = console_getc();
    } while (p < '0' || p > '3');
    drv  = p - '0';
    printf("\n");
    while(1) {
        do {
            printf("Menu:\ne. exit, f. format track, d. format disk, r. read sector, k. read disk\n");
            printf("c. recalibrate (seek track 0), s. seek track, n. identify NSC PC8477B\n");
            printf("w. write sector, i. reset FDC, a. sense interrupt, p. print buffer\n");
            printf("l. fill buffer, m.modify buffer, o. motor off\nYour choice?\n");
            p = console_getc();
        } while (p < 'a' || p > 'z');

        switch (p) {
            case 'e':
                motor_off();
                exit(1);
            case 'o':
                motor_off();
                break;
            case 'f': 
                printf("\nFormating track (%d sectors)\n", number_of_sctrs);
                track_nr = get_track_nr();
                interleave = get_interleave();
                generate_sec_numbers(interleave);
                if (cmd_format(track_nr, 0) == -1) {
                    printf("\nformat track failed (head 0)\n");
                    break;
                }
                if (!single_sided && cmd_format(track_nr, 1) == -1) {
                    printf("\nformat track failed (head 1)\n");
                    break;
                }
                break;
            case 'd':
                printf("\nFormating disk (%d sectors per track, %d tracks)\n", number_of_sctrs, num_of_tracks);
                interleave = get_interleave();
                generate_sec_numbers(interleave);
                printf("\ncurrent track:");
                for (track_nr = 0; track_nr < num_of_tracks; track_nr++) {
                    printf("%02d", track_nr);
                    cmd_seek_track(track_nr);
                    if (cmd_format(track_nr, 0) == -1) {
                        printf("\nformat track failed (head 0)\n");
                        break;
                    }
                    if (!single_sided && cmd_format(track_nr, 1) == -1) {
                        printf("\nformat track failed (head 1)\n");
                        break;
                    }
                    if (track_nr < num_of_tracks-1) {
                        printf("%c%c", 8, 8); //2x backspace
                    }
                    p = console_keypress();
                    if (p == CTRL_C) { // terminate formating?
                        stop = 1;
                    }
                }
                printf("\nrun \"read disk\" to check for bad sectors\n");
                break;
            case 'w':
                printf("\nWriting sector\n");
                track_nr = get_track_nr();
                sector_nr = get_sector_nr();
                head_nr = get_head_nr();
                result = cmd_write(track_nr, sector_nr, head_nr);
                report(result, 1);
                break;
            case 'r':
                printf("\nReading sector\n");
                track_nr = get_track_nr();
                sector_nr = get_sector_nr();
                head_nr = get_head_nr();
                result = cmd_read(track_nr, sector_nr, head_nr);
                report(result, 1);
                break;
            case 'k':
                error = 0;
                stop = 0;
                // dump old FM disks
                dump_disk = 0;
                printf("\nReading disk (%d sectors per track, %d tracks)", number_of_sctrs, num_of_tracks);
                printf("\ncurrent track:");
                for (track_nr = 0; track_nr < num_of_tracks && stop == 0; track_nr++) {
                    printf("%02d", track_nr);
                    for (head_nr = 0; head_nr < (single_sided ? 1 : 2) && stop == 0; head_nr++) {
                        for (sector_nr = 0; sector_nr< number_of_sctrs && stop == 0; sector_nr++) {
                            // IBM counts sectors from 1, NUMBER_OF_BYTES is FM IBM -> sector_nr+1
                            sec_nr = NUMBER_OF_BYTES == 0 ? sector_nr+1 : sector_nr;
                            if (dump_disk) {
                                // print sector number
                                printf("%02d", sec_nr);
                            }
                            if ((result = cmd_read(track_nr, sec_nr, head_nr)) != 0) {
                                if (error == 0) {
                                    printf("\nerror reading sector(head):\n%02d", track_nr);
                                }
                                error = 1;
                                printf(" %d(%d)", sector_nr, head_nr);
                                alloc_unit = track_nr * number_of_sctrs * (single_sided ? 1 : 2);
                                alloc_unit += head_nr * number_of_sctrs + sector_nr;
                                position = alloc_unit % 8;
                                alloc_unit /= 8;
                                printf(", [alloc unit %d, position %d of 0..7], ", alloc_unit, position);
                                report(result, 0);
                                // TODO save bad sectors in an array and lock them out later
                            }
                            // dump old FM disks
                            if (dump_disk) {
                                // dump sector data
                                dump_buffer();
                            }
                            // user break
                            p = console_keypress();
                            if (p == CTRL_C) { // terminate reading?
                                stop = 1;
                            }
                        }
                    }
                    if (!dump_disk && track_nr < num_of_tracks-1 && stop == 0) {
                        printf("%c%c", 8, 8); //2x backspace
                    }
                }
                printf("\n");
                break;
            case 'c':
                printf("\nRecalibrate - seeking track 0\n");
                result = cmd_recalibrate();
                report(result, 1);
                break;
            case 's':
                printf("\nSeeking track\n");
                track_nr = get_track_nr();
                result = cmd_seek_track(track_nr);
                report(result, 1);
                break;
            case 'n':
                result = fd_nsc();
                printf("\nNSC command (73=OK):%02x\n", result);
                break;
            case 'i':
                fd_init();
                printf("\n");
                break;
            case 'a':
                cmd_sense_interrupt();
                printf("\n");
                break;
            case 'm':
                modify_buffer();
            case 'p':
                dump_buffer();
                printf("\n");
                break;
            case 'l':
                fill_buffer();
                printf("\n");
                break;
            default:
                break;
        }
        result = fd_msr();
        printf("MSR(80=OK):%02x\n", result);
    }
}
