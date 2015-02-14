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
; * return length of string, reference CPL p 36
; * @param s pointer to string
; */
;strlen(char *s) {
strlen:
;    int i;
	push	b
;    i = 0;
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
;    while (*s++) {
$2:
	lxi 	h,#4
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
	call	ccgchar
	mov 	a,h
	ora 	l
	jz  	$3
;        i++;
	lxi 	h,#0
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
;    }
	jmp 	$2
$3:
;    return i;
	lxi 	h,#0
	dad 	sp
	call	ccgint
	jmp 	$1
;}
$1:
	pop 	b
	ret
		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
	.globl	strlen

;0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:103
	;	.end
