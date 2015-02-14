;
; shared format routine used by "printf", "sprintf" etc.
; input: de=ptr to args, bc=output buffer
;
        .area   USER_GENERATED (REL,CON)

format::
    lxi	h,-8		;buffer size
	dad	sp          ;include stack
	sphl			;adjust stack
	xchg			;hl=ptr to args
	mov	d,m         ;get high byte of source
	dcx	h           ;backup to low
	mov	e,m         ;get low byte of source
	dcx	h           ;backup to previous
f1:	ldax d          ;get char from string
	inx	d           ;advance to next
	cpi	25          ;'%' format specifier?
	jz	f2          ;yes, handle it
	stax b          ;write to output
	inx	b           ;advance to next
	ana	a           ;end of string?
	jnz	f1          ;no, keep going
	lxi	h, 8        ;buffer size
	dad	sp          ;include stack
	sphl			;adjust stack
	ret
; format specifier has been found
f2:	push b          ;save output pointer
	lxi	b, 0		;b=flags, c=width
; test for '-' (left justify)
	ldax d          ;get next char
	cpi 0x2D        ;left justify?
	jnz	f3          ;no, its ok
	inx	d           ;skip '-'
	mvi	b,0b10000000	;set left justify bit
; test for leading '0' (zero fill)
f3:	ldax d          ;get next char
	cpi	0x30        ; '0' zero fill?
	jnz	f4          ;no, its ok
	mov	a,b         ;get flags
	ori	0b01000000	;set '0' flag
	mov	b,a         ;and re-save
; evaluate the field width
f4:	ldax d          ;get char
	sui	0x30        ;subtract '0', convert from ascii
	cpi	10          ;in range?
	jnc	f5          ;no, its not
	inx	d           ;advance
	push psw		;save value
	mov	a,c         ;get current value
	rlc             ;x2
	rlc             ;x4
	add	c           ;x5
	rlc             ;x10
	mov	c,a         ;resave
	pop	psw         ;restore value
	add	c           ;include old
	mov	c,a         ;resave
	jmp	f4          ;and proceed
; interpret the format specifier character
f5:	ldax d          ;get specifier
	inx	d           ;skip it
; stack format & arg pointer, but leave output buffer on top
	xchg			;hl = format, de = arg pointer
	xthl			;stack it
	push h          ;resave output
	xchg			;swap back
	mov	d,m         ;get high value
	dcx	h           ;backup to previous
	mov	e,m         ;get low value
	dcx	h           ;backup to previous
	xthl			;save arg ptr
	push h          ;resave output
; 'u' unsigned decimal number
	cpi	0x75        ; 'u' unsigned decimal
	jz	f6          ;yes, handle it
; 'd' signed decimal number
	cpi	0x64        ; 'd' decimal
	jnz	f7          ;no, try next
	mov	a,d         ;get value
	ana	a           ;test for negative
	jp	f6          ;no, its ok
	xchg			;hl = value
	call	ccneg	;negate the value
	xchg			;de = value
	pop h           ;get output
	mvi	m,0x2D		;'-' get minus sign
	inx	h           ;advance pointer
	push h          ;resave
	mov	a,c         ;get size
	ana	a           ;fixed format?
	jz	f6          ;no, its ok
	dcr	c           ;yes, adjust
f6:	mvi	a,0x0A		;set base 10
	jmp	f9          ;and process number
; 'x' hexidecimal number
f7:	cpi	0x78        ;'x' hexidecimal
	jnz	f8          ;no, try next
	mvi	a,0x10		;set base 16
	jmp	f9          ;and process number
; 'o' octal number
f8:	cpi	0x6F        ;'o' octal
	jnz	f12         ;octal number
	mvi	a,0x08		;set base 8
; build string for value in de using numeric base in a
f9:	lxi	h,13		;offset to end of buffer
	dad	sp          ;point to it
	mvi	m,0         ;zero terminate
	push b  		;save flags & size
	mov	b,d         ;copy high value
	mov	c,e         ;copy low value
	xchg			;de = output pointer
	mov	l,a         ;save base
	mvi	h,0         ;set high to zero
f10:push h          ;save base
    mov d,b
    mov e,c
	call ccdiv		;de = de % hl, hl = de / hl
	mov	a,e         ;get result
	pop	h           ;restore base
	adi	0x30        ; '0', convert to ascii
	cpi	0x39+1		;'9'+1, hex digit?
	jc	f11         ;its ok
	adi	7           ;convert hex
f11:dcx	d           ;backup
	stax d          ;write it
	mov	a,h         ;get high
	ora	l           ;test against low
	jnz	f10         ;and proceed
	pop	b           ;restore output pointer
	jmp	f14         ;and proceed
; 's' string
f12:cpi	0x73        ;'s' string?
	jz	f14         ;yes, handle it
; 'c' character
	lxi	h,11		;offset to buffer
	dad	sp          ;point to it
	mvi	m,0         ;zero tail
	dcx	h           ;backup
	mov	m,e         ;set char
	cpi	0x63        ;'c' character?
	jz	f13         ;yes, its ok
	mvi	m,0x3F		;'?', indicate unknown
f13:xchg			;de = string
; copy string to output with correct width and justification
f14:pop	h           ;hl = output
	mov	a,b         ;get flags
	ana	a           ;right justify?
	cp	f100		;yes, pad it
	push d          ;save value
	push b          ;save flags
	mvi	b,0         ;initial count
f15:mov	a,c         ;get size of data
	ana	a           ;no size specified?
	jz	f16         ;yes, do not enforce
	inr	b           ;advance length
	cmp	b           ;in range?
	jc	f17         ;over, exit
f16:ldax	d		;get char
	ana	a           ;end of string?
	jz	f17         ;yes, exit
	mov	m,a         ;save in dest
	inx	d           ;advance source
	inx	h           ;advance dest
	jmp	f15         ;and proceed
f17:pop	b           ;restore flags
	pop	d           ;restore value
	mov	a,b         ;get flags
	ana	a           ;left justify?
	cm	f100		;yes, pad it
	mov	b,h         ;et new output
	mov	c,l         ;get new output
	pop	h           ;restore arg pointer
	pop	d           ;restore	format string
	jmp	f1          ;and proceed
;
; pad the field using flags in b, and width in c
;
f100:
	mov	a,c         ;get specified width?
	ana	a           ;0 = free format
	rz              ;no need to justify
	mov	a,b         ;get flags
	ani	0b01000000	;zero fill?
	rrc             ;shift into correct position
	rrc             ;shift into correct position
	ori	0x20        ;get ' ' or '0'
	push d          ;save pointer
	push b          ;save bc
	push psw		;save char
	mvi	b,0         ;zero count
f101:
	ldax d          ;get char
	ana	a           ;end of string
	jz	f102		;yes, exit
	inx	d           ;advance string
	inr	b           ;advance count
	jmp	f101		;and proceed
f102:
	pop	d           ;get character
f103:
	mov	a,b         ;get actual length
	cmp	c           ;in range?
	jnc	f104		;its over
	mov	m,d         ;output a space
	inx	h           ;advance output
	inr	b           ;advance count
	jmp	f103		;and proceed
f104:
	pop	b           ;restore flags
	pop	d           ;restore pointer
	ret
