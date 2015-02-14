; Small C 8080
;	Coder (2.4,84/11/27)
;	Front End (2.7,84/11/28)
;	Front End for ASXXXX (2.8,13/01/20)
		;program area SMALLC_GENERATED is RELOCATABLE
		.module SMALLC_GENERATED
		.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
		.nlist  (pag)
		.area  SMALLC_GENERATED  (REL,CON,CSEG)
;bdos1(c, de) int c, de; {
bdos1:
;        /* returns only single byte (top half is 0) */
;        return (255 & bdos(c, de));
	lxi 	h,#255
	push	h
	lxi 	h,#6
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#6
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#2
	call	bdos
	pop 	b
	pop 	b
	pop 	d
	call	ccand
	jmp 	$1
;}
$1:
	ret
		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
	.globl	bdos1
	;extrn	bdos

;0 error(s) in compilation
;	literal pool:0
;	global pool:2
;	Macro pool:51
	;	.end
