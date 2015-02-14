;
; Write a string to the console using formatting information
;

        .area   USER_GENERATED (REL,CON)

printf::
	;dad	h           ;x2 for words
    lxi h,2
	dad	sp          ;hl=ptr to args
	inx	h           ;offset to high byte
	xchg			;de=ptr to args
	lxi	h,-100		;size of output buffer
	dad	sp          ;include stack position
	sphl			;adjust stack
	mov	b,h         ;set high
	mov	c,l         ;set low
	push b  		;save for later
	call format     ;do the deed
	call putstr     ;output the string
	lxi	h,102		;remove local vars
	dad	sp          ;include stack position
	sphl			;adjust stack
	ret

; print zero terminated string buffer to console
putstr::
    lxi 	h,#2    ;ptr to buffer
	dad 	sp
	mov 	a,m     ;get first character
	ora 	a
	rz              ;done
    call	putchar ;print the char
	lxi 	h,#2
	dad 	sp
	push	h
	call	ccgint  ;get the pointer to buffer in HL
	inx 	h       ; point to next character
	pop 	d
	call	ccpint  ;save modified pointer
	jmp 	putstr  ;next chcaracter

putchar::
    ret