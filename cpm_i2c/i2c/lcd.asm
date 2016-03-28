                .module I2CLCD_DRIVER
                .area   SMALLC_GENERATED  (REL,CON,CSEG)
                .list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
                .nlist  (pag)
                .globl  lcd_init, lcd_on, lcd_off, lcd_home, lcd_pos, lcd_clr
                .globl  lcd_str
; ============================================
; LCD 1602, 1604, 2002, 2004 driver v. 2
; for LCD based on HD44580 controller chip
; driven via I2C PCF8574 backpack from e-bay
; commands
LCD_CLEARDISPLAY    .equ    0x01
LCD_RETURNHOME      .equ    0x02
; LCD_ENTRYMODESET 0x04
; LCD_DISPLAYCONTROL 0x08
; LCD_CURSORSHIFT 0x10
; LCD_FUNCTIONSET 0x20
; LCD_SETCGRAMADDR 0x40
; LCD_SETDDRAMADDR 0x80
; flags for display entry mode
; LCD_ENTRYRIGHT 0x00
; LCD_ENTRYLEFT 0x02
; LCD_ENTRYSHIFTINCREMENT 0x01
; LCD_ENTRYSHIFTDECREMENT 0x00
; flags for display on/off control
; LCD_DISPLAYON 0x04
; LCD_DISPLAYOFF 0x00
; LCD_CURSORON 0x02
; LCD_CURSOROFF 0x00
; LCD_BLINKON 0x01
; LCD_BLINKOFF 0x00
; flags for display/cursor shift
; LCD_DISPLAYMOVE 0x08
; LCD_CURSORMOVE 0x00
; LCD_MOVERIGHT 0x04
; LCD_MOVELEFT 0x00
; flags for function set
; LCD_8BITMODE 0x10
; LCD_4BITMODE 0x00
; LCD_2LINE 0x08
; LCD_1LINE 0x00
; LCD_5x10DOTS 0x04
; LCD_5x8DOTS 0x00
; I2C backpack pin definitions LCD -> PCF
; DB7 -> P7, DB6 -> P6, DB5 -> P5, DB4 -> P4
; flags for backlight control
LCD_BACKLIGHT       .equ    0x08 ; P3
LCD_NOBACKLIGHT     .equ    0x00
; En 0b00000100  // Enable pin/bit -> P2
; Rw 0b00000010  // Read/Write pin/bit, 0 write, 1 read -> P1
; Rs 0b00000001  // Register select pin/bit, 0 data, 1 command -> P0
; ============================================
; requires I2C driver
; ============================================
; public functions and procedures:
; LCDINI     - display initialization
; LCDON      - backlight on  (one more command needed to switch on, e. g. LCDHOME)
; LCDOFF     - backlight off (one more command needed to switch off)
; LCDHOME    - set cursot to top-left position
; LCDPOS     - set cursor position to x (col), y (row)
; LCDCHR     - show char on cursor position
; LCDSTR     - show null-terminated string, starting from cursor position
; LCDCLR     - clear display
; LCDUDG     - create user-defined graphic character
; ============================================
; addressing of 3rd and 4th row may be different !
; read LCD datasheet and check LCDPOS function
PCF8574_ADDR    .equ    0x4E            ; I2C interface address
LCDLIGHT:       .db     0               ; integrated light switch
LCD_BUF_CMDDAT: .db     4               ; two nibbles, repeated twice, e.g. ENABLE pin pulsed
INIT_SEQ1:      .db     0b00110100, 0b00110000  ; reset LCD controller, the same with ENABLE
INIT_SEQ2:      .db     0b00100100, 0b00100000  ; finally switch to 4 bits mode, with ENABLE
                ; 
lcd_init:       ; display initialization
                lxi     h, INIT_SEQ1
                mvi     c, 2
                call    bckpkgsend      ; send over i2c to LCD backpack
                lxi     h, 2000
                call    wait            ; delay 20ms
                lxi     h, INIT_SEQ1
                mvi     c, 2
                call    bckpkgsend      ; send over i2c to LCD backpack
                lxi     h, 2000
                call    wait            ; delay 20ms
                lxi     h, INIT_SEQ1
                mvi     c, 2
                call    bckpkgsend      ; send over i2c to LCD backpack
                lxi     h, 1000
                call    wait            ; delay 10ms
                ; and now set 4 bit mode
                lxi     h, INIT_SEQ2
                mvi     c, 2
                call    bckpkgsend      ; send over i2c to LCD backpack
                lxi     h, 200
                call    wait            ; delay
                ; hope it is in 4-bits mode so we can send next few commands
                mvi     a, 0x28         ; 4 bit mode, 2 lines, 5x7 font
                call    lcdcmd          ; send command
                mvi     a, 0x0C         ; display ON cursor OFF
                call    lcdcmd
                mvi     a, 0x06         ; set entry mode (auto increment)
                call    lcdcmd
                mvi     a, 0x80         ; cursor to line 1
                call    lcdcmd
                ret
; turn backlight on
lcd_on:         mvi     a, LCD_BACKLIGHT ; set light bit
                sta     LCDLIGHT
                ret
; turn backlight off
lcd_off:        xra     a
                sta     LCDLIGHT        ; reset light bit
                ret
; cursor home
lcd_home:       mvi     a, LCD_RETURNHOME
                call    lcdcmd          ; cursor to home
                lxi	h, 200       ; delay
                call	wait
                ret
; display one character, char ascii code in HL
;lcd_chr:        pop     h               ; get param from stack
;                push    h               ; adjust stack
;                mov     a, l            ; param to ACC
;                call    lcdata
;                ret
; clear LCD display
lcd_clr:        mvi     a, LCD_CLEARDISPLAY
                call    lcdcmd          ; clear display and DDRAM
                lxi	h, 0x1000       ; delay
                call	wait
                ret
; set position to HL [H=x (0..19), L=y (0..3)]
lcd_pos:        mvi     a, 0xC0
                dcr     l
                jz      lcdps0
                mvi     a, 0x90         ; 94h for some displays
                dcr     l
                jz      lcdps0
                mvi     a, 0xD0         ; D4h for some displays
                dcr     l
                jz      lcdps0
                mvi     a, 0x80         ; DDRAM starts here
lcdps0:         add     h
                call    lcdcmd          ; cursor to home
                ret
; create user-defined graphic
; matrix addr in HL
; character index in ACC
LCDUDG:         push    h
                ani     0x03            ; only 8 own characters possible
                rlc                     ; multiply by 8 (each character has 8 bytes)
                rlc
                rlc
                ori     0b01000000      ; Set CG RAM command
                call    lcdcmd
                pop     h
                mvi     b, 8            ; eight bytes for characters
LCDGR0:         mov     a, m            ; read from matrix
                push    h
                push    b
                call    lcdata          ; and send to LCD
                pop     b
                pop     h
                inx     h
                dcx     b
                mov     a, b
                ora     c
                jnz     LCDGR0          ; repeat
                ret
; show null-terminated string
; HL pointer to string is pushe on the stack
lcd_str:        pop     b               ; return address
                pop     h               ; get param from stack
                push    h               ; adjust stack
                push    b               ; adjust stack
lcdst0:         mov     a, m            ; read char
                ora     a
                rz                      ; return on null
                push    h
                call    lcdata          ; display char
                pop     h
                rc                      ; return on error
                inx     h
                jmp     lcdst0          ; next char
                ret
; send one byte to LCD over i2c bus
; A - contains value to be transmitted
lcdata:         push    d               ; backup DE
                mov     d, a            ; backup value
                lda     LCDLIGHT        ; get LIGHT bit
                ori     0b00000101      ; ENABLE, DATA
                jmp     lcdsnd          ; continue
lcdcmd:         push    d               ; backup DE
                mov     d, a            ; backup value
                lda     LCDLIGHT        ; get LIGHT bit
                ori     0b00000100      ; ENABLE, CMD
                ;                         fall through
lcdsnd:         mov     e, a            ; move control pins to E
                mov     a, d            ; restore value
                push    b               ; backup BC
                mvi     c, 0b11110000   ; filter to C
                ana     c               ; mask out low bits
                ora     e               ; LIGHT, ENABLE, R/W, CMD/DATA
                sta     LCD_BUF_CMDDAT  ; I2C msg's first byte
                ani     0b11111011      ; pulse ENABLE bit
                sta     LCD_BUF_CMDDAT+1; msg second byte
                mov     a, d            ; restore value
                rlc                     ; swap nibbles
                rlc                     ; now low four bits will be transmitted
                rlc                     ; to LCD
                rlc
                ana     c               ; mask out high(swapped low nibble) bits
                ora     e               ; complete with control pins
                sta     LCD_BUF_CMDDAT+2; msg third byte
                ani     0b11111011      ; pulse ENABLE bit
                sta     LCD_BUF_CMDDAT+3; msg fourth byte
                ; send prepared msg
                lxi     h, LCD_BUF_CMDDAT
                mvi     c,4
                call    bckpkgsend      ; send over i2c to LCD backpack
                pop     b               ; restore BC
                pop     d               ; restore DE
                ret
                ; send msg to I2C LCD backpack
                ; HL - src addr and C - msg length need to be set
bckpkgsend:     mvi     a, PCF8574_ADDR ; PCF8574 i2c address
                call    send_buf        ; in pcf8584.asm i2c bus controller
                ret
; --------------------------------------------
wait:           ;(15,5us) * 65536 = 1s
                arhl                    ; devide hl by two
                arhl                    ; devide hl by two
                arhl                    ; devide hl by two
waitl1:         dcx     h
                mov     a,h
                ora     l
                rz
                call    udelay          ; 80us
                jmp     waitl1
