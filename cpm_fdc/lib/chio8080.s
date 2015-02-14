; Small C 8080
;	Coder (2.4,84/11/27)
;	Front End (2.7,84/11/28)
;	Front End for ASXXXX (2.8,13/01/20)
		;program area SMALLC_GENERATED is RELOCATABLE
		.module SMALLC_GENERATED
		.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
		.nlist  (pag)
		.area  SMALLC_GENERATED  (REL,CON,CSEG)
;#define EOL 10
;#define CR 13
;getchar() {
getchar:
;    return (bdos(1, 1));
	lxi 	h,#1
	push	h
	lxi 	h,#1
	push	h
	mvi 	a,#2
	call	bdos
	pop 	b
	pop 	b
	jmp 	$1
;}
$1:
	ret
;putchar(char c) {
putchar:
;    if (c == EOL) {
	lxi 	h,#2
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#10
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$3
;        bdos(2, CR);
	lxi 	h,#2
	push	h
	lxi 	h,#13
	push	h
	mvi 	a,#2
	call	bdos
	pop 	b
	pop 	b
;    }
;    bdos(2, c);
$3:
	lxi 	h,#2
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgchar
	push	h
	mvi 	a,#2
	call	bdos
	pop 	b
	pop 	b
;    return c;
	lxi 	h,#2
	dad 	sp
	call	ccgchar
	jmp 	$2
;}
$2:
	ret
		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
	.globl	getchar
	;extrn	bdos
	.globl	putchar

;0 error(s) in compilation
;	literal pool:0
;	global pool:3
;	Macro pool:64
	;	.end
