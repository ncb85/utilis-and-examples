;bin to dec and bit to hex 16-bit routines
		.module SMALLC_GENERATED
		.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
		.nlist  (pag)
		.area  SMALLC_GENERATED  (REL,CON,CSEG)

                ;.extrn result
                .globl GLCD_int_to_hex, GLCD_char_to_dec, GLCD_int_to_dec, result
                ;16-bit unsigned int to HEX, called as C function
                ;result stores in external buffer
GLCD_int_to_hex:ldsi 2                  ;pop parameter
                lhlx
                lxi d,result
                call hl_to_buff
                call GLCD_write
                ret

hl_to_buff:     mov a,h
                call tohexh
                mov a,h
                call tohexl
l_to_buff:      mov a,l
                call tohexh
l2_to_buff:     mov a,l
                call tohexl
                xra a                   ;terminate string
                stax d
                ret
tohexh:         rlc                     ;high 4-bits
                rlc
                rlc
                rlc
tohexl:         ani 0x0F                ;low 4-bits
                adi 0x30                
                cpi 0x3A                ;9 is 0x39
                jm nohex                ;0-9 ?
                adi 0x07                ;no, it is A-F
nohex:          stax d
                inx d
                ret

                ;8-bit unsigned number to decimal, called as C function
                ;max value is 99, result stores in external buffer
GLCD_char_to_dec: ldsi 2                  ;pop parameter
                lhlx                    ;do HL
		mvi b,8                 ;8 bitove cislo
		mvi c,0                 ;vynuluj vysledok v C
                mov a,c
                mov h,l                 ;data is in L
cloop1:		dad h                   ;najvyssi bit do CY
                adc c                   ;pripocitaj CY
		daa			;preved do BCD
		mov c,a
		dcr b		        ;opakuj pre 8 bitov
		jnz cloop1
                lxi d,result
                mov l,c
                call l_to_buff
                call GLCD_write
                ret

                ;16bit unsigned int to decimal
GLCD_int_to_dec:ldsi 2                  ;pop parameter
                lhlx                    ;into HL
                xchg                    ;shld BIN
                lxi h,BCD               ;clear buffer
                mvi b,3                 ;5 digits is in 3 bytes
bloop1:         mvi m,0                 ;clear
                inx h                   ;next byte
                dcr b
                jnz bloop1              ;loop
                mvi b,16                ;number of bits
bloop:          xra a                   ;clear CY
bloop3:         mov a,e
                ral                     ;left shift through CY
                mov e,a
                mov a,d
                ral                     ;left shift through CY
                mov d,a
                lxi h,BCD               ;buffer
                mvi c,3                 ;5 digits BCD number is 3 bytes long
bloop4:         mov a,m
                adc a                   ;double it
                daa                     ;BCD
                mov m,a
                inx h                   ;next byte
                dcr c
                jnz bloop4
                dcr b                   ;next bit round
                jnz bloop
                lxi h,BCD+2             ;print result to buff
                mov a,m
                lxi d,result
                call tohexl             ;convert to ASCII and store to external buff
                dcx h
                mov a,m
                dcx h
                mov l,m
                mov h,a
                call hl_to_buff
                call GLCD_write
                ret            
BCD:            .ds 3                   ;BCD digits
result:         .ds 6                   ;out buffer

GLCD_write:     lxi d, result           ;call glcd write
                push d
                call GLCD_WriteString
                pop b
                ret
