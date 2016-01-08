;
; partial printf implementation
; only d,x,s formatters supported
; and padding supported
;
        .area	SMALLC_GENERATED	(REL,CON)
		.module SMALLC_GENERATED
		.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
		.nlist  (pag)
		.globl  print, printf, format

;printf (char *formatters, int arguments[])
printf:    
        ;lxi     h,0            ;get current SP
        ;dad     sp
        ;shld    0x3000
        lxi     h,2             ;pointer to stack frame
        dad     sp              ;move to last param
        call    ccgint          ;get formatter string address
        mov     b,h             ;back up pointer to formatting string
        mov     c,l
        lxi     h,4             ;pointer to second param from end
        dad     sp              ;
        xchg                    ;save it to DE
        call    format          ;process formatters and params
        ret
; HL beginning of buffer
; DE pointer to formatting string (method stack frame)
format:
frmt1:  ldax    b
        inx     b
        push    b
        push    psw
        push    d
        cpi     "%"             ;'%' format specifier?
        jz      frmt2           ;yes, handle it
        mov     l,a             ;place param on stack
        mvi     h,0
        push    h
        call	putchar         ;no, just print the char
        pop     h
        pop     d
        pop     psw
        pop     b
        ora     a               ;end of formatting string ?
        rz                      ;yes, return
        jmp     frmt1
frmt2:  push    b               ;back up BC, HL
        push    h
        push    d
        xchg
        call    ccgint          ;place next param to HL
        pop     d
        inx     d               ;move to next parameter
        inx     d
        push    d
        xchg                    ;place fetched number in DE
; 'u' unsigned decimal number
        ldax    b
    	cpi     "u"             ; 'u' unsigned decimal
    	jz      f6              ;yes, handle it
; 'd' signed decimal number
    	cpi     "d"             ; 'd' decimal
    	jnz     f7              ;no, try next
    	mov     a,d             ;get value
    	ana     a               ;test for negative
    	jp      f6              ;no, its ok
    	xchg                    ;hl = value
    	call	ccneg           ;negate the value
    	xchg                    ;de = value
    	pop     h               ;get output
    	mvi     m,"-"           ;'-' get minus sign
    	inx     h               ;advance pointer
    	push    h               ;resave
    	mov     a,c             ;get size
    	ana     a               ;fixed format?
    	jz      f6              ;no, its ok
    	dcr     c               ;yes, adjust
f6: 	mvi     a,10            ;set base 10
        jmp     f9              ;and process number
; 'x' hexadecimal number
f7: 	cpi     "x"             ;'x' hexidecimal
    	jnz	f8          ;no, try next
    	mvi	a,0x10		;set base 16
    	jmp	f9          ;and process number
; 'o' octal number
f8:     cpi	0x6F        ;'o' octal
    	;jnz	f12         ;octal number
    	mvi	a,0x08		;set base 8
; build string for value in de using numeric base in a
f9: 	lxi	h,-10		;offset to end of buffer
    	dad	sp          ;point to it
    	;mvi	m,0         ;zero terminate
    	push b  		;save flags & size
        push    h
        pop     b
        ;mov	b,d         ;copy high value
    	;mov	c,e         ;copy low value
    	xchg			;de = output pointer
    	mov	l,a         ;save base
    	mvi	h,0         ;set high to zero
f10:    push h          ;save base
        ;mov d,b
        ;mov e,c
    	call ccdiv		;de = de % hl, hl = de / hl
    	mov	a,e         ;get result
    	;pop	h           ;restore base
    	adi	0x30        ; '0', convert to ascii
    	cpi	0x39+1		;'9'+1, hex digit?
    	jc	f11         ;its ok
    	adi	7           ;convert hex
f11:    dcx	d           ;backup
    	stax    b       ;write it
    	mov	a,h         ;get high
    	ora	l           ;test against low
    	jnz	f10         ;and proceed
    	pop	b           ;restore output pointer
    	;jmp	f14         ;and proceed
        jmp frmt1
        
; print zero terminated string buffer to console
print:  lxi     h,2
        dad     sp
        call    ccgint
; input HL beginning of buffer
putstr: mov 	a,m     ;get first character
        ora 	a
        rz              ;done
        push    h       ;save HL
        mvi     b,0     ;place param on stack
        mov     c,a
        push    b
        call	putchar ;print the char
        pop     b       ;adjust stack
        pop     h       ;restore HL
        inx 	h       ;point to next character
        jmp 	putstr  ;next chcaracter

