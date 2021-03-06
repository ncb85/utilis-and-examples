; driver for the Phillips I2C bus controller PCF8584 for 8085 CPU
; uses no IRQs, all code control is done via status register
                .module PCF8584_DRIVER
                .area   SMALLC_GENERATED  (REL,CON,CSEG)
                .list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
                .nlist  (pag)
                .globl  pcf8584_init, reset_i2c_bus
                .globl  send_buf, recv_buf, send_buf_addr, udelay

PCF8584_S0      .equ    0x58                ;data register
PCF8584_S1      .equ    PCF8584_S0+1        ;control/status register
OWN_ADDR        .equ    0x55                ;effective own I2C address is shifted to left
                                            ;it will become AAH
CLCK_443        .equ    0x10                ;system clock is 4.43 MHz; SCL = 90 kHz
CLCK_600        .equ    0x14                ;system clock is 6 MHz; SCL = 90 kHz
TIMEOUT         .equ	0                   ;timeout (256 tries)
                ; control bits
PIN             .equ	0x80                ;pending interrupt (is also status bit)
ESO             .equ	0x40                ;enable serial output
ES1             .equ    0x20                ;controls selection of other registers
ES2             .equ    0x10                ;controls selection of other registers
ENI             .equ    0x08                ;enable external interrupt output
STA_            .equ    0x04                ;generate start condition (STA is reserved 8080 instruction code)
STO             .equ    0x02                ;generate stop condition
ACK             .equ    0x01                ;generate acknowledge
                ; status bits
STS             .equ    0x20                ;stop detected (when in slave mode)
BER             .equ    0x10                ;bus error
LRB             .equ    0x08                ;last received bit
AAS             .equ    0x04                ;addressed as slave bit
LAB             .equ    0x02                ;lost arbitration bit
BB              .equ    0x01                ;bus busy bit
                ;
SEND_I2C_START 	.equ    PIN | ESO | STA_
SEND_I2C_STOP   .equ    PIN | ESO | STO
CLEAR_I2C_BUS   .equ    PIN | ESO | ACK
NEGATIVE_ACK    .equ    ESO                 ;ACK bit is hereby set to 0, that causes negative ack
                                            ;which halts further transmision
S2              .equ    PIN + ES1
RESET           .equ    PIN
                ;
OK              .equ    0
ERR_WAIT_PIN    .equ    1
ERR_NO_ACK      .equ    2
ERR_BUS_BUSY    .equ    3
                ;
                ; wait aprox. 80us (42t fixed + 24t x LOOP)
                ; 5MHz CPU 400 cycles (act.402)
                ; 8MHz CPU 640 cycles
udelay:         push b                      ;[12]
                lxi b,15                    ;[10]  const CRYSTAL/2
dela1:          dcx b                       ;[6]
                mov a,b                     ;[4]
                ora c                       ;[4]
                jnz dela1                   ;[10]
                pop b                       ;[10]
                ret                         ;[10]
pcf8584_init:   ; initialize controller
                mvi a,RESET                 ; will also choose register S0_OWN i.e. next byte will be
                out PCF8584_S1              ; loaded into reg S0^ (own address reg); serial interface off.
                mvi a,OWN_ADDR              ; loads byte 55H into reg S0^ effective own address becomes AAH.
                out PCF8584_S0              ; pcf8584 shifts this value left one bit
                mvi a,S2                    ; loads byte A0H into reg S1, i.e. next byte will
                out PCF8584_S1              ; be loaded into the clock control reg S2.
                mvi a,CLCK_443              ; loads byte 10H into reg S2;system clock is 4.43 MHz; SCL = 90 kHz
                out PCF8584_S0
                mvi a,CLEAR_I2C_BUS         ; loads byte C1H into reg S1; reg enable serial interface
                out PCF8584_S1              ; next write or read operation will be to/from data transfer reg S0
                call udelay
                ret
reset_i2c_bus:  ; reset I2C bus
                mvi a,SEND_I2C_STOP         ; stop C2
                out PCF8584_S1              ; send to S1
                call udelay                 ; wait
                mvi a,CLEAR_I2C_BUS         ; clear C1
                out PCF8584_S1              ; send to S1
                ret
wait_for_bus:   ; wait for bus, set CY on timeout
                push b                      ; backup BC
                mvi b,TIMEOUT               ; timeout constant
wfbl1:          in PCF8584_S1               ; read status
                ani BB                      ; zero indicates that the bus is busy
                jz wfbl2                    ; bit=0, bus still busy
                pop b                       ; restore BC
                ret                         ; bit=1, I2C bus access now possible
wfbl2:          dcr b                       ; timeout reached?
                jnz wfbl3                   ; no
                stc                         ; yes, set CY
                pop b                       ; restore BC
                lxi h,ERR_BUS_BUSY          ; error code
                ret                         ; return
wfbl3:          call udelay                 ; wait
                jmp wfbl1                   ; try again
wait_for_pin:   ; wait for PIN, set CY on timeout
                push b                      ; backup BC
                mvi b,TIMEOUT               ; timeout constant
wfpl1:          in PCF8584_S1               ; read status
                ani PIN                     ; bit=1, transmission is in progress
                jnz wfpl2                   ;
                pop b                       ; bit=0, restore BC, return
                ret                         ; PIN cleared, transmission completed
wfpl2:          dcr b                       ; timeout reached?
                jnz wfpl3                   ; no
                stc                         ; yes, set CY
                pop b                       ; restore BC
                lxi h,ERR_WAIT_PIN          ; error
                ret                         ; return
wfpl3:          call udelay                 ; wait
                jmp wfpl1                   ; try again
xmit_raddr:     ; transmit address in read mode, A address
                ori 0x01                    ; set last address bit in READ mode
                jmp xmit_start              ; begin transmission
xmit_waddr:     ; transmit address in write mode, A address
                ani 0xFE                    ; clear last address bit in WRITE mode
                ;jmp xmit_start             ; begin transmission - fall through
xmit_start:     ; common routine, begin address transmission
                out PCF8584_S0              ; send(set) address
                mvi a,SEND_I2C_START+ACK    ; begin communication
                out PCF8584_S1              ; the transmission of address from S0 is now started
                call wait_for_pin           ; wait for the i2c send to finish
                rc                          ; error, abort
                ;jmp check_ack              ; check slave acknowledge - fall through
check_ack:      ; check if peer acknowledged
                in PCF8584_S1               ; read status
                ani LRB                     ; check LRB
                rz                          ; LRB=0, return
                stc                         ; peer did not acknowledge, set CY
                lxi h,ERR_NO_ACK            ; set error code
                ret                         ; return
xmit_byte:      ; transmit one byte
                out PCF8584_S0              ; send byte
                call wait_for_pin           ; wait for the i2c send to finish
                rc                          ; error, abort
                jmp check_ack               ; check slave acknowledge
recv_byte:      ; receive one byte
                call wait_for_pin           ; wait for the i2c read to finish
                rc                          ; error abort
                in PCF8584_S0               ; read byte
                stax d                      ; store byte to dest.buffer
                stc                         ; clear CY
                cmc                         ;
                ret
recv_buf:       ; receive buffer, A-I2C address, BC-length, DE-destination
                ; receives data from device, writes it to the memory buffer
                mov h,a                     ; back up I2C address
                call wait_for_bus           ; return when bus not available
                rc                          ; bus busy error
                mov a,h                     ; restore address
                call xmit_raddr             ; send I2C address
                jc rcerr                    ; error
                in PCF8584_S0               ; dummy read, begins transfer of first value from bus to S0
                                            ; therefore this very first value must be discarded
rcb1:           dcx b                       ; counter
                mov a,b                     ; check BC
                ora c                       ; both zero?
                jz rcdone                   ; last byte
                call recv_byte              ; receive one byte
                cnc check_ack               ; did master (this controller) acknowledge?
                jc rcerr                    ; error occured
                inx d                       ; increment destination pointer
                jmp rcb1                    ; next byte
rcdone:         mvi a,NEGATIVE_ACK          ; last byte (master receiver mode)
                out PCF8584_S1              ; send negative acknowledge
                call recv_byte              ; receive last byte
                jc rcerr                    ; error occured
                jmp done                    ; release bus
send_buf:       ; send buffer, A-I2C address, C-length, HL-source
                ; sends buffer content to the device (pure data)
                mov d,a                     ; back up I2C address
                call wait_for_bus           ; return when bus not available
                rc                          ; bus busy error
seb1:           mov a,d                     ; restore address
                call xmit_waddr             ; send address
                jc rcerr                    ; error
seb2:           mov a,m                     ; get byte
                call xmit_byte              ; transmit it
                jc rcerr                    ; error occured
                dcr c                       ; counter
                jz  done                    ; last byte?
                inx h                       ; increment source pointer
                jmp seb2                    ; next byte
send_buf_addr:  ; send buffer with address, A-I2C address, C-length, HL-source
                ; DE-dest. device internal address, sends device's internal dest. 
                ; address in the first two bytes, followed by buffer content
                ; e.g. as needed by EEPROMs, this convinience method should
                ; actually be in EEPROMs driver file but it has dependences here
                push d                      ; back up DE
                mov d,a                     ; back up I2C address
                call wait_for_bus           ; return when bus not available
                rc                          ; bus busy error
seba1:          mov a,d                     ; restore address
                call xmit_waddr             ; send device I2C address
                pop d                       ; restore DE
                jc rcerr                    ; error occured
                mov a,d                     ; higher byte of dest.address
                call xmit_byte              ; transmit it
                mov a,e                     ; lower byte of dest.address
                call xmit_byte              ; transmit it
                jmp seb2                    ; continue with the data
rcerr:          mvi a,SEND_I2C_STOP         ; error
                out PCF8584_S1              ; send stop
                stc                         ; error flag
                ret                         ; abort
done:           mvi a,SEND_I2C_STOP + ACK   ; done, stop
                out PCF8584_S1              ; send ack
                lxi h,OK                    ; all OK
                ret
                ;
                .end