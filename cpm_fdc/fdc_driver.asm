                ; floppy routines for 8085 CPU, PC8477B FDC
                ; uses no DMAs, no IRQs and TC pin is not serviced
                ; all data flow control is done via FDC internal registers
                .module FDC
                .area   FDC (CON)
                .list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
                .nlist  (pag)
                .globl  fd_nsc, fd_msr, fd_init, sense_intrpt, fd_format, motor_off
                .globl  sector_nr, track_nr, drive_nr, head_nr
                .globl  status_reg_0, status_reg_1, status_reg_2, status_reg_3
                .globl  sector_fnr, number_of_sctrs, dbuffer, NUMBER_OF_BYTES, SECTOR_SIZE
                .globl  ccr_dsr_value, mode3_value, gap_length, gap3_length
                .globl  set_drv_type0, set_drv_type1, set_drv_type2, set_drv_type3
                .globl  set_drv_type4, set_drv_type5, interpt_65, fd_exec_cmd
                .globl  fdc_asm_end, CMD_READ, CMD_WRITE, CMD_FORMAT

CRYSTAL         .equ 16                 ;8MHz 8085 (works fine for CPUs 4-12MHz) 

                ; symbolic constants
FDC_RECALIB     .equ 0
FDC_SEEK        .equ 1
FDC_READ        .equ 2
FDC_WRITE       .equ 3

READ_RETRY      .equ 3                  ;when read sector fails, retry it n times
RST65_ADDR      .equ 0x0034             ;6.5 interrupt vector
MOTOR_TIMEOUT   .equ 4                  ;seconds motor timeout

ticks:          .db 0                   ;8155/8253 timer ticks
seconds:        .db 0                   ;motor time off
motor_count:    .db 0                   ;motor on/off counter

FDC_BASE        .equ 0x50
REG_DOR         .equ FDC_BASE+0x02      ;digital output register
REG_MSR         .equ FDC_BASE+0x04      ;address of main status register
REG_DSR         .equ FDC_BASE+0x04      ;address of data rate select register
REG_DATA        .equ FDC_BASE+0x05      ;floppy data register
REG_CCR         .equ FDC_BASE+0x07      ;configuration control register

DRIVE_0_DOR     .equ 0x14               ;motor on & drive select, no DMA&INT
DRIVE_1_DOR     .equ 0x25               ;motor on & drive select, no DMA&INT
DRIVE_2_DOR     .equ 0x46               ;motor on & drive select, no DMA&INT
DRIVE_3_DOR     .equ 0x87               ;motor on & drive select, no DMA&INT
CNF_250         .equ 0x02               ;250kbps data rate (360kB, 720kB)
CNF_300         .equ 0x01               ;300kbps data rate (360kB disk in 1.2MB drive)
CNF_500         .equ 0x00               ;500kbps data rate (1.2MB, 1.44MB)
;MODE_BYTE1      .equ 0x86               ;mode2, no NSC imp.seek (better use 82077 method), ISO, auto low pwr
MODE_BYTE1      .equ 0x06               ;mode1, no imp.seek, IBM, auto low pwr
MODE_BYTE2      .equ 0x00               ;FIFO enabled, few tracks
MODE_BYTE3      .equ 0xC2               ;def.densel, 2x8ms head settle time
;MODE_BYTE3      .equ 0xC1               ;def.densel, 1x8ms head settle time
MODE_BYTE4      .equ 0x00               ;dskchg default
SPECIFY_BYTE1   .equ 0xCA               ;step rate 8/4ms, motor off 10s
;SPECIFY_BYTE1   .equ 0xEA               ;step rate 4/2ms, motor off 10s
SPECIFY_BYTE2   .equ 0x03               ;1ms motor on delay, no DMA
                ; fdc commands
CMD_RESET       .equ 0x80               ;reset fdc by pulling bit 7 high
CMD_INIT        .equ 0x04               ;unset reset bit, no DMA
CMD_RECALIB     .equ 0x07               ;recalibrate
CMD_READ        .equ 0x46               ;read command, bit 6 is MFM
CMD_WRITE       .equ 0x45               ;write command, bit 6 is MFM
CMD_SEEK        .equ 0x0F               ;absolute track seek
CMD_SENS_INTR   .equ 0x08               ;sense interrupt command
CMD_FORMAT      .equ 0x4D               ;format command, bit 6 is MFM
CMD_CONFIG1     .equ 0x13               ;configure command
CMD_CONFIG24    .equ 0x00
;CMD_CONFIG3     .equ 0x14               ;disable polling mode (765), no implied seeks, FIFO thresh 4
CMD_CONFIG3     .equ 0x54               ;disable polling mode (765), implied seeks 82077 method, FIFO thresh 4
CMD_NSC         .equ 0x18               ;National PC8477 identifes itself as 73h
CMD_MODE        .equ 0x01               ;set motor timer mode, implied seek, index address, low power
CMD_SPECIFY     .equ 0x03               ;set internal timers
CMD_SENSE_STAT  .equ 0x04               ;sense drive status
                ; result codes
RESULT_OK       .equ 0x00               ;success
BAD_DRIVE_NR    .equ 0x01               ;error codes
FORMAT_FAILED   .equ 0x02
SENSE_FAILED    .equ 0x03
EQUIPMENT_CHECK .equ 0x04
SEEK_FAILED     .equ 0x05
FDC_NOT_READY   .equ 0x06
DRIVE_BUSY      .equ 0x07
TIMEOUT_WATING  .equ 0x08
DATA_NOT_READY  .equ 0x09
ST0_ERROR       .equ 0x0A
ST1_EOTER       .equ 0x0B
ST1_CRCER       .equ 0x0C
ST1_OVERN       .equ 0x0D
ST1_NODAT       .equ 0x0E
ST1_MSADR       .equ 0x0F
ST1_WRTPRT      .equ 0x10
ST2_BADTRK      .equ 0x11
ST2_CRCERR      .equ 0x12
ST2_MISADR      .equ 0x13
ST2_SCANNO      .equ 0x14
ST_TOO_MANY     .equ 0x15
CMD_ABORT       .equ 0x16
SECTOR_SIZE:    .db 0                   ;256 bytes
                ; do not change order of following lines
                ; read/write param table (set at runtime)
drive_nr:       .db 0                   ;drive
track_nr:       .db 0                   ;track
head_nr:        .db 0                   ;head
sector_nr:      .db 1                   ;sector
NUMBER_OF_BYTES:.db 1                   ;256 bytes per sector
eot_sec_nr:     .db 0                   ;end of track sector number
                ; config values (changed at runtime when needed)
gap_length:     .db 0x0A                ;intersector gap length
                .db 0x80                ;data length - don't care (end of table above)
number_of_sctrs:.db 18                  ;18 sectors
gap3_length:    .db 0x0C                ;recommended value
ccr_dsr_value:  .db CNF_250
mode3_value:    .db MODE_BYTE3
                ; sector numbers
sector_fnr:     .db 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18
                .db 19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34
                ; disk format params
DATA_PATTERN:   .db 0xE5                ;format pattern
                ; data buffer
dbuffer:        .ds 256                 ;sector data buffer
                ; results area
status_reg_0:   .db 0                   ;status register 0
status_reg_1:   .db 0                   ;status register 1
status_reg_2:   .db 0                   ;status register 2
status_reg_3:   .db 0                   ;status register 3, bit 6 - write protect
                                        ;bit 4 - track0, bit 2 - head select
                                        ;bits 0,1 - drive
                .ds 3                   ;placeholder for last 3 bytes
fdc_extraloop:  .db 0                   ;used in some time loops
                ;
                ; table with drive type params(density,sectors,tracks,GAP,GAP3,densel)
table_drv_typ0: .db CNF_250, 18, 40, 0x0A, 0x0C, 0xC2   ; 360kB 5.25" DD/40tracks standard drive
table_drv_typ1: .db CNF_250, 18, 80, 0x0A, 0x0C, 0xC2   ; 720kB 5.25" DD/80tracks special drive (TEAC FD-55F)
table_drv_typ2: .db CNF_500, 26, 80, 0x0E, 0x36, 0xC2   ; 1.2MB 5.25" HD drive
table_drv_typ3: .db CNF_500, 32, 80, 0x0E, 0x36, 0x02   ; 1.44MB 3.5" HD drive
table_drv_typ4: .db CNF_300, 18, 80, 0x0A, 0x0C, 0xC2   ; 720kB 5.25" HD drive
table_drv_typ5: .db CNF_500, 26, 77, 0x0E, 0x36, 0xC2   ; 500(SS)/1MB(DS) or 500kB(SS) 8" DD drive
table_drv_typ6: .db CNF_250, 26, 77, 0x07, 0x1B, 0x02   ; 250(SS)/250kB(SS) 8" SD drive
                ; set drive type (0-360kb, 1-720kb, 2-1.2M, 3-1.44M, 4-720kb, 5-1M)
set_drv_type0:  lxi h, table_drv_typ0
set_drv_type:   mov a,m
                sta ccr_dsr_value       ;data rate
                out REG_CCR
                out REG_DSR
                inx h                   ;number of sectors
                mov a,m
                sta number_of_sctrs
                inx h                   ;tracks
                mov a,m
                sta num_of_tracks
                inx h                   ;read/write gap value
                mov a,m
                sta gap_length
                inx h                   ;format gap3 value
                mov a,m
                sta gap3_length
                inx h                   ;densel pin polarity (3.5 vs 5.25 drives)
                mov a,m
                sta mode3_value
                call fd_mode            ;use new value
                ret
set_drv_type1:  lxi h, table_drv_typ1
                jmp set_drv_type
set_drv_type2:  lxi h, table_drv_typ2
                jmp set_drv_type
set_drv_type3:  lxi h, table_drv_typ3
                jmp set_drv_type
set_drv_type4:  lxi h, table_drv_typ4
                jmp set_drv_type
set_drv_type5:  lxi h, table_drv_typ5
                jmp set_drv_type
                ;
                ; long delay, cca 3ms
long_delay:     push b
                lxi b,0x0100
ld1:            call fd_delay
                dcx b
                mov a,b
                ora c
                jnz ld1
                pop b
                ret
                ;
                ; wait aprox. 25us (42t fixed + 24t x LOOP)
                ; 5MHz CPU 125 cycles (act.162)
                ; 8MHz CPU 200 cycles (act.234)
fd_delay:       push b                  ;[12]
                lxi b,CRYSTAL/2         ;[10]
dela1:          dcx b                   ;[6]
                mov a,b                 ;[4]
                ora c                   ;[4]
                jnz dela1               ;[10]
                pop b                   ;[10]
                ret                     ;[10]
                ;
                ; wait until FDC is ready for new command, C flag set on timeout
busy_check:     push b
                mvi b,0xFF
busy_check2:    dcr b
                jz busy_err             ;something is wrong
                in REG_MSR              ;get FDC status
                ral                     ;look for busy bit
                jnc busy_wait           ;wait
                rar                     ;remake status byte
                pop b
                stc
                cmc                     ;ok
                ret
busy_wait:      call fd_delay
                jmp busy_check2
busy_err:       pop b
                stc
                ret
                ;
                ; motor on
motor_on:       lda drive_nr
                ora a
                jz motor0               ;drive 0
                cpi 01
                jz motor1               ;drive 1
                cpi 02
                jz motor2               ;drive 2
                cpi 03
                jz motor3               ;drive 3
                lxi h,BAD_DRIVE_NR
                stc                     ;error
                ret
motor0:         mvi a,DRIVE_0_DOR
                jmp motor_do
motor1:         mvi a,DRIVE_1_DOR
                jmp motor_do
motor2:         mvi a,DRIVE_2_DOR
                jmp motor_do
motor3:         mvi a,DRIVE_3_DOR
motor_do:       out REG_DOR
                ret
                ;
                ; stop drive motor
motor_off:      mvi a,CMD_INIT
                out REG_DOR
                ret
                ;
                ; read one byte from data reg
read_byte:      call busy_check
                rc                      ;timeout
                in REG_MSR              ;wants to give us result?
                ani 0x40
                cpi 0x40
                jz read_byte2
                stc
                lxi h,DATA_NOT_READY
                ret
read_byte2:     in REG_DATA             ;read the byte
                ora a                   ;set flags, clear carry
                ret
                ;
                ; write one byte to data reg
write_byte:     push af
                call busy_check
                jnc 1$
                pop af
                stc
                ret                     ;timeout
1$:             ani 0xC0
                cpi 0x80                ;ready to accept byte?
                jz write_byte2
                pop af
                stc
                lxi h,FDC_NOT_READY
                ret
write_byte2:    pop af
                out REG_DATA            ;write the byte
                stc
                cmc                     ;clear carry
                ret
                ;
                ; initialise FDC
fd_init:        mvi a,CMD_RESET
                out REG_DSR
                call long_delay
                xra a
                out REG_DOR             ;software reset
                call long_delay
                mvi a,CMD_INIT          ;unset reset bit, no DMA
                out REG_DOR
                call fd_delay
                lda ccr_dsr_value       ;250kbps/300kbps/500kbps
                out REG_DSR
                call fd_delay
                lda ccr_dsr_value       ;250kbps/300kbps/500kbps
                out REG_CCR
                call fd_configure
                call fd_specify
                call fd_mode
                ;call fd_recalib
                ret
                ;
                ; National Semiconductor PC8477B identifies itself as 73h
fd_nsc:         mvi a,CMD_NSC
                call write_byte
                call read_byte          ;should be 73h
                mov l,a                 ;following is only for C programm
                xra a                   ;return result in HL
                mov h,a
                ret
                ;
                ; configure command - implied seek, disable polling, fifo enable
fd_configure:   mvi a,CMD_CONFIG1
                call write_byte
                mvi a,CMD_CONFIG24
                call write_byte
                mvi a,CMD_CONFIG3
                call write_byte
                mvi a,CMD_CONFIG24
                call write_byte
                ret
                ;
                ; mode command - sets special features of fdc (FIFO, densel, low pwr, ..)
fd_mode:        mvi a,CMD_MODE
                call write_byte
                mvi a,MODE_BYTE1
                call write_byte
                mvi a,MODE_BYTE2
                call write_byte
                lda mode3_value         ;DENSEL polarity
                call write_byte
                mvi a,MODE_BYTE4
                call write_byte
                ret
                ;
                ; mode specify - sets internal timers of fdc (step rate, motor on/of)
fd_specify:     mvi a,CMD_SPECIFY
                call write_byte
                mvi a,SPECIFY_BYTE1
                call write_byte
                mvi a,SPECIFY_BYTE2
                call write_byte
                ret
                ;
                ; sense drive status - read status register 3
fd_sensestat:   mvi a,CMD_SENSE_STAT
                call write_byte
                rc                      ;without diskette it hangs (TODO init FDC?)
                lda drive_nr            ;2nd byte is drive number
                call write_byte
                call read_byte          ;result phase, status 3
                sta status_reg_3        ;store it
                ani 0x10                ;check track 0 flag
                stc                     ;not track 0
                rz
                cmc                     ;track 0 detected
                ret
                ;
                ; recalibrate - move to track 0
fd_recalib:     mvi a,CMD_RECALIB       ;output recalibrate command
                call write_byte
                lda drive_nr            ;2nd byte is drive number
                call write_byte
                lxi b,0x0FFF            ;wait limit
.1:             call fd_sensestat       ;check for track 0
                jnc .2                  ;track 0 detected
                dcx b
                mov a,b
                ora c
                jnz .1
                ;jmp sense_intrpt        ;timeout, try sensing now
.2:             ;fall through
                ;
                ; sense interrupt - clears busy bit in MSR after seek and recalibrate commands
sense_intrpt:   call long_delay         ;give the drive some time
                in REG_MSR              ;sense drive seek bits
                ani 0x0F                ;all four drive bits
                lxi h,0                 ;for C
                rz
                call long_delay         ;no hurry, mechanics is slow
                mvi a,CMD_SENS_INTR
                out REG_DATA
sense_stat:     call read_byte          ;result phase, status0
                ani 0xF0                ;isolate state bits
                mov b,a                 ;backup
                ani 0xC0                ;D7,6 must be 00 for normal termination
                lxi h,SENSE_FAILED      ;for C program
                stc                     ;error
                rnz
                mov a,b
                ani 0x10
                lxi h,EQUIPMENT_CHECK   ;track 0 signal failed after recalibrate
                stc
                rnz
sense_track:    call read_byte          ;read track_nr (recalibrate sets to 0)
                sta track_nr            ;drive is calibrated
sense_exit:     lxi h,RESULT_OK         ;for C programm
                ;stc                    optimized
                ;cmc                     ;clear carry
                ret
                ;
                ; seek track
fd_seek:        call motor_on           ;select drive
                mvi a,CMD_SEEK
                call write_byte         ;output seek command
                call send_head_drv      ;output head and drive number
                call send_track         ;output track number
                lxi d,0x40              ;sense interrupt retries
1$:             call sense_intrpt
                jnc 2$
                dcr d
                jnz 1$
                lxi h,SEEK_FAILED
                stc                     ;error
                ret
2$:             lxi h,RESULT_OK         ;for C
                ret                     ;optimized carry is cleared
                ;
                ; status - read result of a command
read_status:    lxi d,0                 ;bytes read
read_stl1:      lxi b,0                 ;timeout loop
read_stl2:      call fd_delay           ;wait
                in REG_MSR
                ani 0xF0                ;RQM=1, DIO=1, EXEC=0, BUSY=1 
                cpi 0xD0
                jz next_status
                cpi 0x80                ;command finished
                jz eval_status
                dcx b
                mov a,b
                ora c
                jnz read_stl2
                lxi h,TIMEOUT_WATING    ;timeout
                stc
                ret
next_status:    mov a,d
                cpi 0x07                ;there are 7 result bytes
                jz read_sterr           ;too many status bytes
                lxi h,status_reg_0
                dad d                   ;array offset
                inx d                   ;move to next array item
                in REG_DATA
                mov M,a
                jmp read_stl1           ;loop
read_sterr:     lxi h,ST_TOO_MANY       ;should never happen
                stc
                ret
                ;
                ; evaluate status bytes
eval_status:    ;lda status_reg_0        ;process Status 0
                lda status_reg_1        ;process Status 1
                mov b,a                 ;backup
                ;ani 0x80                ;end of track error
                ;jz 1$                  in non DMA transfers without using TC pin
                ;lxi h,ST1_EOTER        it is expected condition. There is no other
                ;stc                    way to stop FDC to process next sector
                ;ret
1$:             ;mov a,b
                ani 0x20                ;CRC error
                jz 2$
                lxi h,ST1_CRCER
                stc
                ret
2$:             mov a,b
                ani 0x10                ;overrun, CPU too slow
                jz 3$
                lxi h,ST1_OVERN
                stc
                ret
3$:             mov a,b
                ani 0x04                ;no data
                jz 4$
                lxi h,ST1_NODAT
                stc
                ret
4$:             mov a,b
                ani 0x02                ;write protect
                jz 5$
                lxi h,ST1_WRTPRT
                stc
                ret
5$:             mov a,b
                ani 0x01                ;mising address mark
                jz eval_st2
                lxi h,ST1_MSADR
                stc
                ret
eval_st2:       lda status_reg_2        ;process Status 2
                mov b,a
                ani 0x12                ;wrong track detected
                jz 1$
                lxi h,ST2_BADTRK        
                stc
                ret
1$:             mov a,b
                ani 0x40                ;scan not satisfied
                jz 2$
                lxi h,ST2_CRCERR
                stc
                ret
2$:             mov a,b
                ani 0x20                ;CRC error
                jz 3$
                lxi h,ST2_CRCERR
                stc
                ret
3$:             mov a,b
                ani 0x01                ;missing address mark in data field
                jz read_stok
                lxi h,ST2_MISADR
                stc
                ret
read_stok:      lxi h,RESULT_OK         ;all OK
                stc
                cmc
                ret
                ;
                ; output head and drive number
send_head_drv:  lda head_nr             ;head number
                ral
                ral
                mov b,a                 ;backup
                lda drive_nr            ;drive number
                ora b                   ;combine them
                call write_byte         ;output head and drive number
                ret
                ;
                ; output track number
send_track:     lda track_nr            ;get physical track
                call write_byte
                ret
                ;
                ; command phase, send 7 data fields
fd_cmd_pha:     lda sector_nr           ;load current sector number
                sta eot_sec_nr          ;store it in EOT to stop processing more secs
                mvi c,7
                lxi d,track_nr          ;table begin (track, head, sector, bytes, EOT, GAP, len)
fd_cmd_l1:      call busy_check
                ani 0xF0                ;RQM/DIO
                cpi 0x90                ;RQM=1, DIO=0 (fdc ready for a byte), CMD in progress
                jnz fd_cmd_err          ;error ..
                ldax d                  ;load data
                out REG_DATA            ;send to fdc
                inx d
                dcr c
                jnz fd_cmd_l1           ;next param
                ret                     ;command sent
fd_cmd_err:     jmp read_status         ;jump and return to caller from there
                ;
                ; format a track
fd_format:      mvi a,CMD_FORMAT        ;command phase
                call write_byte         ;output format command
                jc fo_error
                call send_head_drv
                jc fo_error
                lda NUMBER_OF_BYTES     ;bytes per sector
                call write_byte
                jc fo_error
                lda number_of_sctrs     ;sectors per track
                call write_byte
                jc fo_error
                lda gap3_length         ;format gap
                call write_byte
                jc fo_error
                lda DATA_PATTERN        ;data pattern
                call write_byte
                jc fo_error
                lxi h, dbuffer
                lda  number_of_sctrs    ;we'll transfer 4x number of sectors bytes
                add a                   ;x2
                add a                   ;x4
                mov e,a                 ;pass count in DE
                mvi d,0
                jmp fd_write_start      ;format all sectors on track
fo_error:       lxi h, FORMAT_FAILED    ;could not format
                stc
                ret                     ;
                ;
                ; write one sector to diskette
fd_write:       mvi a, CMD_WRITE        ;command phase
                call write_byte
                call send_head_drv      ;send head << 2 | drive byte
                call fd_cmd_pha         ;send 7 param bytes
                lda SECTOR_SIZE         ;128 FM or 256 MFM
                mov e,a                 ;sector size 256 bytes
                lxi h,dbuffer           ;execution phase
fd_write_start: mvi a,(CRYSTAL/2+8)/4   ;start write
                sta fdc_extraloop
fd_write_outlo: mvi c,0                 ;outer loop 256x
fd_write_inrlo: mvi b,0                 ;inner loop 256x
fd_write_l1:    in REG_MSR
                cpi 0xB0                ;RQM=1,DIO=1,NDM=1,BUSY=1 (ready to receive byte)
                jnz 1$                  ;wait
                mov a,m                 ;transfer data to FDC
                out REG_DATA
                inx h
                dcr e
                jnz fd_write_l1         ;next byte
                jmp read_status         ;result phase
1$:             dcr b
                jnz fd_write_l1         ;quickly poll for next byte
                cpi 0xC0                ;waiting for very first byte to write (or abort)
                jz fd_cmd_abort         ;RQM=1, DIO=1, EXEC=0, BUSY=0 (execution aborted)
                dcr c
                jnz fd_write_inrlo      ;try again
                cpi 0xD0                ;exec aborted (FDC hanged)?
                jnz 2$
                out REG_DATA            ;take FDC out of hung
                jmp read_status         ;and jump to status phase
2$:             lda fdc_extraloop
                dcr a
                sta fdc_extraloop
                jnz fd_write_outlo
                lxi h,TIMEOUT_WATING    ;timeout
                stc
                ret
                ;
                ; reads a sector, on error retries 3x
fd_read_retry:  mvi d,READ_RETRY        ;3x retry
1$:             push d
                call fd_read            ;read sector
                pop d
                rnc                     ;success, return
                dcr d                   ;no luck retrying
                jz 2$
                lda track_nr            ;backup track_nr to read
                mov e,a
                push h                  ;backup error code (for C program)
                call fd_recalib         ;recalibrate heads (sets track_nr to 0)
                pop h                   ;restore error code
                mov a,e                 ;restore track_nr
                sta track_nr            ;set it to param table
                jmp 1$                  ;try again
2$:             stc                     ;no luck
                ret
                ;
                ; read one sector from diskette
fd_read:        mvi a, CMD_READ         ;command phase
                call write_byte
                call send_head_drv      ;send head << 2 | drive byte
                call fd_cmd_pha         ;send 7 param bytes
                lxi h,dbuffer           ;execution phase
                mvi a,(CRYSTAL/2+8)/4   ;
                sta fdc_extraloop
                lda SECTOR_SIZE         ;128 FM or 256 MFM
                mov e,a                 ;sector size 256 bytes
fd_read_outlo:  mvi c,0                 ;outer loop 256x
fd_read_inrlo:  mvi b,0                 ;inner loop 256x
fd_read_l1:     in REG_MSR
                cpi 0xF0                ;RQM/DIO/EXEC/BUSY
                jnz 1$                  ;data from floppy?
                in REG_DATA             ;get it
                mov m,a                 ;transfer data to buff
                inx h
                dcr e
                jnz fd_read_l1          ;next byte
                call read_status        ;result phase
                ret
1$:             dcr b
                jnz fd_read_l1          ;quickly poll for next byte
                cpi 0xC0                ;waiting for first byte (or abort) takes longer
                jz fd_cmd_abort         ;RQM=1, DIO=1, EXEC=0, BUSY=0 (execution aborted)
                dcr c
                jnz fd_read_inrlo       ;try again
                cpi 0xD0                ;exec aborted (FDC hanged)?
                jnz 2$
                jmp read_status         ;and jump to status phase
2$:             lda fdc_extraloop
                dcr a
                sta fdc_extraloop
                jnz fd_read_outlo
                lxi h,TIMEOUT_WATING    ;timeout
                stc
                ret
fd_cmd_abort:   lxi h,CMD_ABORT
                stc
                ret
                ;
                ; report status register to C
fd_msr:         mvi h,0
                in REG_MSR
                mov l,a
                ret
                ;
                ; start timer - when it expires motor off will be called
timer_motor_off:; pulse frequency 10Hz
                mvi a,0x00              ;8155 timer
                out 0x04
                mvi a,0xFC
                out 0x05
                mvi a,0xCE
                out 0x00
                mvi a,0x34              ;8253 timer 0
                out 0x1B
                mvi a,0x00
                out 0x18
                mvi a,0x3C
                out 0x18
                ; hook up interrupt handler
                mvi a,0xC3				;JUMP instruction
                sta RST65_ADDR			;timer is connected to 6.5 interrupt
                lxi h,interpt_65		;routine's address
                shld RST65_ADDR+1		;
                ;mvi a,0b00011100		;set interrupt mask, enable 6.5, 5.5
				rim						;get interrupt status
				ani 0b00001101			;set interrupt mask enable 6.5
				ori 0b00001000			;
                sim
                ei
                ret
                ;
                ;interrupt 6.5 - the timer
interpt_65:     push psw
                ;push b
                ;push d
                ;push h
                lda ticks               ;load ticks
                inr a
                sta ticks
                cpi 10                  ;10hz signal
                jc 2$                   ;less then second, return
                xra a                   ;clear ticks
                sta ticks
                in 0x54                 ;flash LEDs
                lda seconds
                inr a
                sta seconds
                cpi MOTOR_TIMEOUT       ;motor off time
                jc 2$
                xra a
                sta seconds
                lda motor_count         ;motor on?
                cpi 1
                jnz 2$
                rim						;get interrupt status
				ani 0b00001111			;set interrupt mask disable 6.5
				ori 0b00001010			;
                sim
                call motor_off          ;stop motor
                xra a                   ;save 0
                sta motor_count         ;motor really stopped
2$:             ;pop h
                ;pop d
                ;pop b
                pop psw
                ei                      ;done, enable interrupt again
                ret
                ;
                ; execute command - all disk operation should be called from here
                ; A - operation number (0 - recalibrate, 1 - seek, 2 - read sector, 3 - read sector)
fd_exec_cmd:    push psw
                call fd_motor_on        ;motor started?
                pop psw
                cpi FDC_RECALIB         ;recalibrate
                jnz 1$
                call fd_recalib
                jmp 8$
1$:             cpi FDC_SEEK            ;seek track
                jnz 2$
                call fd_seek
                jmp 8$
2$:             cpi FDC_READ            ;read sector
                jz 3$
                cpi FDC_WRITE           ;write sector
                jnz 8$                  ;unknown operation
3$:             mvi d,READ_RETRY        ;3x retry
                mov e,a                 ;backup operation
4$:             push d
                mov a,e                 ;restore operation (what to do, read or write)
                cpi FDC_READ
                jz 5$
                call fd_write
                jmp 6$
5$:             call fd_read
6$:             pop d
                jnc 8$                  ;success, return
                dcr d                   ;no luck retrying
                jz 7$
                lda track_nr            ;backup track_nr to read
                mov c,a
                push b
                ;push h                  ;backup error code (for C program)
                call fd_recalib         ;recalibrate heads (sets track_nr to 0)
                ;pop h                   ;restore error code
                pop b
                mov a,c                 ;restore track_nr
                sta track_nr            ;set it to param table
                jmp 4$                  ;try again
7$:             stc                     ;no luck
8$:             push psw                ;backup
                push h
                call fd_motor_off       ;begin stop motor count
                pop h                   ;restore
                pop psw
                ret
                ;
                ; start motor (if not already started), disable interrupt from timer
fd_motor_on:    di                      ;disable interrupt
                lda motor_count
                cpi 0x01                ;already started?
                jz 2$
                inr a
                sta motor_count
                call motor_on           ;no start it now
                mvi b,0x18              ;wait till it starts, cca 200ms
1$:             call long_delay
                dcr b
                jnz 1$
2$:             ret
                ;
                ; stop motor (if not needed anymore)
fd_motor_off:   lda motor_count
                ora a                   ;not needed anymore?
                jz 1$
                xra a
                sta ticks               ;clear interval
                sta seconds
                call timer_motor_off
1$:             ret
fdc_asm_end:
                .end
