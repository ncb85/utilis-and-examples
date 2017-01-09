; long.asm
; Utilities for handling 4byte unsigned long integers - intended for use with SmallC compiler
; They should be as C methods with parameters placed on stack
; Little-Endian representation orders values from base in increasing significance
; the highest order values are farthest from base
                ;
                .module IDE_DRIVER
                .area   SMALLC_GENERATED  (REL,CON,CSEG)
                .list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
                .nlist  (pag)
                .globl  long_to_dec, lng_buff, remove_zeroes, long_rlsft
                ;
lng_buff:       .ds 11                  ;buffer for decimal presentation
lng_bcd:        .ds 5                   ;BCD digits
lng_hghst_bt:   .dw 0                   ;pointer to the highest order byte
                ;
                ;shift long right logically by HL
                ;long_lsft(pointer_to_long, number_of_shift)
                ;leaves long shifted
long_rlsft:     ldsi 2                  ;load second parameter number_of_shiftings
                lhlx                    ;into HL
                push h                  ;push - number of shiftings
                ldsi 6                  ;load first parameter pointer_to_long
                lhlx                    ;into HL
                pop d                   ;get number of shiftings into DE
                inx h                   ;move to highest order byte
                inx h                   ;move to highest order byte
                inx h                   ;move to highest order byte
                push h                  ;back up pointer_to_long
lslsr1:         pop h                   ;get pointer
                push h                  ;back up again
                dcr e                   ;done all shiftings?
                jm rlsftr               ;yes, return
                xra a                   ;clear CY
                mvi b,4                 ;long is 4 bytes
lslsr2:         mov a,m                 ;get highest byte
                rar                     ;shift right
                mov m,a                 ;store it back
                dcx h                   ;next byte
                dcr b                   ;all 4 bytes?
                jnz lslsr2              ;no, loop
                jmp lslsr1              ;count shiftings 
rlsftr:         pop b                   ;adjust stack
                ret
                ;
                ;32bit unsigned int to decimal
                ;convert binary long number to decimal presentation
                ;result is zero terminated
                ;param on stack - pointer to little endian unsigned long
long_to_dec:    ldsi 2                  ;load parameter
                lhlx                    ;into HL
                shld lng_hghst_bt       ;store pointer to long
                xchg                    ;DE containts pointer to unsigned long
                lxi h,lng_bcd           ;clear buffer
                mvi b,5                 ;10 bcd digits is in 5 bytes
                xra a                   ;clear acc
clrlop:         mov m,a                 ;clear BCD result
                inx h                   ;next byte
                dcr b                   ;all cleared?
                jnz clrlop              ;no, clear next
                mvi b,32                ;number of bits
bitlop:         lhld lng_hghst_bt       ;get stored pointer to long
                xchg                    ;move to DE
                xra a                   ;clear CY and start shifting source number
                ldax d                  ;load lowest order byte
                ral                     ;left shift through CY
                stax d                  ;store lowest byte
                inx d                   ;higher byte
                ldax d                  ;load second order byte
                ral                     ;left shift through CY
                stax d                  ;store second byte
                inx d                   ;higher byte
                ldax d                  ;load third order byte
                ral                     ;left shift through CY
                stax d                  ;store third byte
                inx d                   ;higher byte
                ldax d                  ;load highest order byte
                ral                     ;left shift through CY
                stax d                  ;store highest byte
                                        ;start conversion to BCD - shift in bits from source
                lxi h,lng_bcd+4         ;right side of BCD digits buffer
                mvi c,5                 ;10 digits BCD number is 5 bytes long
bcdlop:         mov a,m                 ;fetch BCD
                adc a                   ;double it and add CY
                daa                     ;BCD
                mov m,a                 ;store back
                dcx h                   ;next BCD
                dcr c                   ;all 5 BCD couples?
                jnz bcdlop              ;no, next higher order BCD couple
                dcr b                   ;done all 32bit?
                jnz bitlop              ;no, next bit round
                                        ;conversion to BCD DONE, now ASCII part
                lxi d,lng_buff          ;output string
                lxi h,lng_bcd           ;BCD digits buff
                mov a,m                 ;first two digits
                inx h                   ;next BCD number - 4 digits
                mov l,m                 ;third nad fourth digits
                mov h,a                 ;first two digits
                call hl_to_buff         ;convert to ASCII
                lxi h,lng_bcd+2         ;next BCD number - 4 digits
                mov a,m                 ;digits 5 and 6
                inx h                   ;next BCD number
                mov l,m                 ;digits 7 and 8
                mov h,a                 ;digits 5 and 6
                call hl_to_buff         ;convert to ASCII
                lxi h,lng_bcd+4         ;last BCD number - lowest 2 digits
                mov l,m                 ;digits 9 and 10
                call l_to_buff          ;convert to ASCII
                inx d                   ;end of output buff
                xra a                   ;make acc zero
                stax d                  ;store it
                ret
                ;
                ;remove leading zeroes from buffer
                ;param on stack - pointer to string containing number
remove_zeroes:  mvi c,9                 ;10 bcd digits - max 9 shiftings
                ldsi 2                  ;load parameter
                lhlx                    ;into HL
                mov a,m                 ;get first char
                cpi "0"                 ;is it leading zero?
                rnz                     ;not a zero, return
                mvi b,10                ;10 bcd digits
shflop:         inx h                   ;point to next char
                mov a,m                 ;get it
                dcx h                   ;point back to previous
                mov m,a                 ;move it
                inx h                   ;next char
                dcr b                   ;more shifting?
                jnz shflop              ;yes
                dcr c                   ;no, check max number of shiftings
                jnz remove_zeroes+2     ;no, check first char again
                rz                      ;done, only one '0' left in buff
                ;
                ;convert BCD number to ASCII string
                ;HL - input BCD number
                ;DE - pointer to result buffer
hl_to_buff:     mov a,h
                call toasch
                mov a,h
                call toascl
l_to_buff:      mov a,l
                call toasch
l2_to_buff:     mov a,l
                call toascl
                xra a                   ;terminate string
                stax d
                ret
toasch:         rlc                     ;high 4-bits
                rlc
                rlc
                rlc
toascl:         ani 0x0F                ;low 4-bits
                adi 0x30                
                stax d
                inx d
                ret
                ;
                .end
