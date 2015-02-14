;
; Perform formatted output to a string
;

        .area   USER_GENERATED (REL,CON)

sprintf::
	;dad	h		;x2 for words
    lxi h,2
	dad	sp		;hl=ptr to args
	mov	c,m		;get low string
	inx	h		;advance to high
	mov	b,m		;get high string
	dcx	h		;backup to low
	dcx	h		;backup to previous
	xchg		;de=ptr to args
	jmp	format	;do the deed
