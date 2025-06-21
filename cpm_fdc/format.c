/*
 * File:   findbad.c, june 2025
 * format disk, find and lock out bad sectors
 */
#include <stdio.h>

#define CTRL_C                  0x03
#define SIZE_OF_DIR_ENTRY       32
#define MAX_BAD_ALLOC_UNITS     8

extern char user_response[82], drv;
extern unsigned int num_of_tracks, single_sided;
extern unsigned char status_reg_0, status_reg_1, status_reg_2, status_reg_3;
extern unsigned char number_of_sctrs, NUMBER_OF_BYTES, SECTOR_SIZE, sector_fnr[], dbuffer[];
extern unsigned char head_nr, track_nr, sector_nr, drive_nr;
extern unsigned char ccr_dsr_value, mode3_value, GAP_LENGTH, GAP3_LENGTH;
extern unsigned char CMD_FORMAT, CMD_READ, CMD_WRITE;

int interleave, stop, alloc_unit_address_size;
unsigned int bad_aloc_unit_count, bad_aloc_units[MAX_BAD_ALLOC_UNITS];
unsigned char file_entry[32] = {0x0F, 0x42, 0x41, 0x44, 0x20, 0x20, 0x20, 0x20, 0x20, 0xC3, 0x52, 0x43, 00, 00, 00, 0x7A};


get_interleave() {
    int interleave;
    do {
        printf("\ninterleave? (1-9) (recom. 1.44MB/3, 1.2MB/3, 360kB/4)\n");
        interleave = get_number();
    } while (interleave < 1 || interleave > 9);
    return interleave;
}

do_format(unsigned char track_nr) {
    if (cmd_format(track_nr, 0) == -1) {
        printf("\nformat track failed (head 0)\n");
        return;
    }
    if (!single_sided && cmd_format(track_nr, 1) == -1) {
        printf("\nformat track failed (head 1)\n");
        return;
    }
}

format_track() {
    printf("\nFormating track (%d sectors)\n", number_of_sctrs);
    track_nr = get_track_nr();
    interleave = get_interleave();
    generate_sec_numbers(interleave);
    do_format(track_nr);
}

format_disk() {
    char p;
    printf("\nFormating disk (%d sectors per track, %d tracks)\n", number_of_sctrs, num_of_tracks);
    interleave = get_interleave();
    generate_sec_numbers(interleave);
    printf("\ncurrent track:");
    for (track_nr = 0; track_nr < num_of_tracks; track_nr++) {
        printf("%02d", track_nr);
        //cmd_seek_track(track_nr);
        do_format(track_nr);
        if (track_nr < num_of_tracks-1) {
            printf("%c%c", 8, 8); //2x backspace
        }
        p = console_keypress();
        if (p == CTRL_C) { // terminate formating?
            stop = 1;
        }
    }
    printf("\nrun \"read disk\" to check for bad sectors\n");
}

/*
 * example first sector containing one file
00 42 41 44 20 20 20 20 20 43 52 43 00 00 00 7A     .BAD     CRC...z            
02 00 03 00 04 00 05 00 06 00 07 00 08 00 09 00     ................            
E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5     ................            
E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5     ................            
E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5     ................            
E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5     ................            
E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5     ................            
E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5     ................            
E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5     ................            
E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5     ................            
E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5     ................            
E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5     ................            
E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5     ................            
E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5     ................            
E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5     ................            
E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5 E5     ................ 
*/
lock_out() {
    char p;
    int i;
    unsigned char file_length;
    printf("\nDo you want lock out bad allocation units (%d)? [y/n]\n", bad_aloc_unit_count);
    do {
        p = console_getc();
    } while (p != 'y' && p != 'n');
    putchar('\n');
    if (p == 'y') {
        // create bad.crc hidden file
        for (i=0; i < SIZE_OF_DIR_ENTRY; i++) { // memcpy(dbuffer, bad_aloc_units, SIZE_OF_DIR_ENTRY); 
            dbuffer[i] = file_entry[i];
        }
        printf("Allocation units assigned to BAD.CRC: ");
	    for (i=0; i<bad_aloc_unit_count; i++) {
            printf("%d", bad_aloc_units[i]);
            if (i+1 < bad_aloc_unit_count) {
                putchar(',');
            } else {
                putchar('\n');
            }
            dbuffer[16 + i*alloc_unit_address_size] = bad_aloc_units[i]; // alloc unit address is one or two bytes
	    }
        // file length (in logical 128byte sector count) bad_aloc_unit_count * 2kB units size / 0.125kB (e.g. *8)
        file_length = bad_aloc_unit_count * 16;
        dbuffer[15] = file_length; 
    }
    printf("\nPrint buffer to check locked out units and write to sector 0/0/0\n");
}

/**
 * find and lock out bad sectorse
 * @return
 */
find_bad() {
    char p;
    int track_nr, sector_nr, sec_nr, head_nr, result;
    int error, stop, alloc_unit, position, dump_disk;
    
    error = 0;
    stop = 0;
    bad_aloc_unit_count = 0;
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
                    // remeber bad sectors and lock them out later
                    if (bad_aloc_unit_count < MAX_BAD_ALLOC_UNITS) {
                        bad_aloc_units[bad_aloc_unit_count++] =  alloc_unit;
                    }
                    printf(", [alloc unit %d, position %d of 0..7], ", alloc_unit, position);
                    report(result, 0);
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
    if (bad_aloc_unit_count <= MAX_BAD_ALLOC_UNITS) {
        lock_out(bad_aloc_unit_count);
    }
}
