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
;/**
; * Reverse a character string, reference CPL p 59
; * @param s pointer to string
; */
;reverse(char *s) {
reverse:
;    int i, j;
	push	b
	push	b
;    char c;
	dcx 	sp
;    i = 0;
	lxi 	h,#3
	dad 	sp
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
;    j = strlen(s) - 1;
	lxi 	h,#1
	dad 	sp
	push	h
	lxi 	h,#9
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	strlen
	pop 	b
	push	h
	lxi 	h,#1
	pop 	d
	call	ccsub
	pop 	d
	call	ccpint
;    while (i < j) {
$2:
	lxi 	h,#3
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#3
	dad 	sp
	call	ccgint
	pop 	d
	call	cclt
	mov 	a,h
	ora 	l
	jz  	$3
;        c = s[i];
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#9
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#7
	dad 	sp
	call	ccgint
	pop 	d
	dad 	d
	call	ccgchar
	pop 	d
	mov 	a,l
	stax	d
;        s[i] = s[j];
	lxi 	h,#7
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#5
	dad 	sp
	call	ccgint
	pop 	d
	dad 	d
	push	h
	lxi 	h,#9
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#5
	dad 	sp
	call	ccgint
	pop 	d
	dad 	d
	call	ccgchar
	pop 	d
	mov 	a,l
	stax	d
;        s[j] = c;
	lxi 	h,#7
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#3
	dad 	sp
	call	ccgint
	pop 	d
	dad 	d
	push	h
	lxi 	h,#2
	dad 	sp
	call	ccgchar
	pop 	d
	mov 	a,l
	stax	d
;        i++;
	lxi 	h,#3
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
;        j--;
	lxi 	h,#1
	dad 	sp
	push	h
	call	ccgint
	dcx 	h
	pop 	d
	call	ccpint
	inx 	h
;    }
	jmp 	$2
$3:
;    return (s);
	lxi 	h,#7
	dad 	sp
	call	ccgint
	jmp 	$1
;}
$1:
	inx 	sp
	pop 	b
	pop 	b
	ret
		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
	.globl	reverse
	;extrn	strlen

;0 error(s) in compilation
;	literal pool:0
;	global pool:2
;	Macro pool:103
	;	.end
