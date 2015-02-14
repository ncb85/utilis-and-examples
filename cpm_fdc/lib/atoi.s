; Small C 8080
;	Coder (2.4,84/11/27)
;	Front End (2.7,84/11/28)
;	Front End for ASXXXX (2.8,13/01/20)
		;program area SMALLC_GENERATED is RELOCATABLE
		.module SMALLC_GENERATED
		.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
		.nlist  (pag)
		.area  SMALLC_GENERATED  (REL,CON,CSEG)
;#include <stdio.h>
;#define stdin 0
;#define stdout 1
;#define stderr 2
;#define NULL 0
;#define EOF (-1)
;#define FILE char
;#define EOL 10
;atoi(char s[]) {
atoi:
;    int i, n, sign;
	push	b
	push	b
	push	b
;    for (i = 0; (s[i] == ' ') | (s[i] == EOL) | (s[i] == '\t'); ++i);
	lxi 	h,#4
	dad 	sp
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
$2:
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#6
	dad 	sp
	call	ccgint
	pop 	d
	dad 	d
	call	ccgchar
	push	h
	lxi 	h,#32
	pop 	d
	call	cceq
	push	h
	lxi 	h,#10
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	pop 	d
	dad 	d
	call	ccgchar
	push	h
	lxi 	h,#10
	pop 	d
	call	cceq
	pop 	d
	call	ccor
	push	h
	lxi 	h,#10
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	pop 	d
	dad 	d
	call	ccgchar
	push	h
	lxi 	h,#9
	pop 	d
	call	cceq
	pop 	d
	call	ccor
	mov 	a,h
	ora 	l
	jnz 	$4
	jmp 	$5
$3:
	lxi 	h,#4
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	jmp 	$2
$4:
	jmp 	$3
$5:
;    sign = 1;
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#1
	pop 	d
	call	ccpint
;    switch (s[i]) {
	lxi 	h,$6
	push	h
	lxi 	h,#10
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	pop 	d
	dad 	d
	call	ccgchar
	jmp 	cccase
;        case '-': sign = -1; /* and fall through */
$8:
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#1
	call	ccneg
	pop 	d
	call	ccpint
;        case '+': ++i;
$9:
	lxi 	h,#4
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
;            break;
	jmp 	$7
;    }
	jmp 	$7
		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
$6:
	.dw	#45,$8,#43,$9
	.dw	$7,0
		.area  SMALLC_GENERATED  (REL,CON,CSEG)
$7:
;    for (n = 0; isdigit(s[i]); ++i) {
	lxi 	h,#2
	dad 	sp
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
$10:
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#6
	dad 	sp
	call	ccgint
	pop 	d
	dad 	d
	call	ccgchar
	push	h
	mvi 	a,#1
	call	isdigit
	pop 	b
	mov 	a,h
	ora 	l
	jnz 	$12
	jmp 	$13
$11:
	lxi 	h,#4
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	jmp 	$10
$12:
;        n = 10 * n + s[i] - '0';
	lxi 	h,#2
	dad 	sp
	push	h
	lxi 	h,#10
	push	h
	lxi 	h,#6
	dad 	sp
	call	ccgint
	pop 	d
	call	ccmul
	push	h
	lxi 	h,#12
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#10
	dad 	sp
	call	ccgint
	pop 	d
	dad 	d
	call	ccgchar
	pop 	d
	dad 	d
	push	h
	lxi 	h,#48
	pop 	d
	call	ccsub
	pop 	d
	call	ccpint
;    }
	jmp 	$11
$13:
;    return (sign * n);
	lxi 	h,#0
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	pop 	d
	call	ccmul
	jmp 	$1
;}
$1:
	pop 	b
	pop 	b
	pop 	b
	ret
;utoi(char s[]) {
utoi:
;    unsigned int i, n;
	push	b
	push	b
;    for (i = 0; (s[i] == ' ') | (s[i] == EOL) | (s[i] == '\t'); ++i);
	lxi 	h,#2
	dad 	sp
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
$15:
	lxi 	h,#6
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	pop 	d
	dad 	d
	call	ccgchar
	push	h
	lxi 	h,#32
	pop 	d
	call	cceq
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#6
	dad 	sp
	call	ccgint
	pop 	d
	dad 	d
	call	ccgchar
	push	h
	lxi 	h,#10
	pop 	d
	call	cceq
	pop 	d
	call	ccor
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#6
	dad 	sp
	call	ccgint
	pop 	d
	dad 	d
	call	ccgchar
	push	h
	lxi 	h,#9
	pop 	d
	call	cceq
	pop 	d
	call	ccor
	mov 	a,h
	ora 	l
	jnz 	$17
	jmp 	$18
$16:
	lxi 	h,#2
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	jmp 	$15
$17:
	jmp 	$16
$18:
;    for (n = 0; isdigit(s[i]); ++i) {
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
$19:
	lxi 	h,#6
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	pop 	d
	dad 	d
	call	ccgchar
	push	h
	mvi 	a,#1
	call	isdigit
	pop 	b
	mov 	a,h
	ora 	l
	jnz 	$21
	jmp 	$22
$20:
	lxi 	h,#2
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	jmp 	$19
$21:
;        n = 10 * n + s[i] - '0';
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#10
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	pop 	d
	call	ccmul
	push	h
	lxi 	h,#10
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	pop 	d
	dad 	d
	call	ccgchar
	pop 	d
	dad 	d
	push	h
	lxi 	h,#48
	pop 	d
	call	ccsub
	pop 	d
	call	ccpint
;    }
	jmp 	$20
$22:
;    return (n);
	lxi 	h,#0
	dad 	sp
	call	ccgint
	jmp 	$14
;}
$14:
	pop 	b
	pop 	b
	ret
		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
	.globl	atoi
	;extrn	isdigit
	.globl	utoi

;0 error(s) in compilation
;	literal pool:0
;	global pool:3
;	Macro pool:110
	;	.end
