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
;#define EOS 0
;/**
; * integer to ascii representation
; * @param n the integer number
; * @param s string buffer
; * @return 
; */
;itoa(int n, char s[]) {
itoa:
;    int i, sign;
	push	b
	push	b
;    if ((sign = n) < 0) {
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#10
	dad 	sp
	call	ccgint
	pop 	d
	call	ccpint
	push	h
	lxi 	h,#0
	pop 	d
	call	cclt
	mov 	a,h
	ora 	l
	jz  	$2
;        n = -n;
	lxi 	h,#8
	dad 	sp
	push	h
	lxi 	h,#10
	dad 	sp
	call	ccgint
	call	ccneg
	pop 	d
	call	ccpint
;    }
;    i = 0;
$2:
	lxi 	h,#2
	dad 	sp
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
;    do {
$3:
;        s[i++] = n % 10 + '0';
	lxi 	h,#6
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#4
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
	pop 	d
	dad 	d
	push	h
	lxi 	h,#10
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#10
	pop 	d
	call	ccdiv
	xchg
	push	h
	lxi 	h,#48
	pop 	d
	dad 	d
	pop 	d
	mov 	a,l
	stax	d
;    } while ((n = n / 10) > 0);
$4:
	lxi 	h,#8
	dad 	sp
	push	h
	lxi 	h,#10
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#10
	pop 	d
	call	ccdiv
	pop 	d
	call	ccpint
	push	h
	lxi 	h,#0
	pop 	d
	call	ccgt
	mov 	a,h
	ora 	l
	jnz 	$3
$5:
;    if (sign < 0) {
	lxi 	h,#0
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#0
	pop 	d
	call	cclt
	mov 	a,h
	ora 	l
	jz  	$6
;        s[i++] = '-';
	lxi 	h,#6
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#4
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
	pop 	d
	dad 	d
	push	h
	lxi 	h,#45
	pop 	d
	mov 	a,l
	stax	d
;    }
;    s[i] = EOS;
$6:
	lxi 	h,#6
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	pop 	d
	dad 	d
	push	h
	lxi 	h,#0
	pop 	d
	mov 	a,l
	stax	d
;    reverse(s);
	lxi 	h,#6
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	reverse
	pop 	b
;}
$1:
	pop 	b
	pop 	b
	ret
;/**
; * unsigned integer to ASCII
; * @param n the unsigned number
; * @param s string buffer
; * @param base
; * @return 
; */
;utoab(unsigned int n, char s[], int base) {
utoab:
;    int i, offset;
	push	b
	push	b
;    i = 0;
	lxi 	h,#2
	dad 	sp
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
;    do {
$8:
;        s[i] = n % base;
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	pop 	d
	dad 	d
	push	h
	lxi 	h,#12
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#10
	dad 	sp
	call	ccgint
	pop 	d
	call	ccudiv
	xchg
	pop 	d
	mov 	a,l
	stax	d
;        if (s[i] < 10 ) {
	lxi 	h,#8
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
	lxi 	h,#10
	pop 	d
	call	cclt
	mov 	a,h
	ora 	l
	jz  	$11
;            offset = '0';
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#48
	pop 	d
	call	ccpint
;        } else {
	jmp 	$12
$11:
;            offset = 55; // 'A' - 10
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#55
	pop 	d
	call	ccpint
;        }
$12:
;        s[i] = s[i] + offset;
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	pop 	d
	dad 	d
	push	h
	lxi 	h,#10
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
	lxi 	h,#4
	dad 	sp
	call	ccgint
	pop 	d
	dad 	d
	pop 	d
	mov 	a,l
	stax	d
;        i++;
	lxi 	h,#2
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
;    } while ((n = n / base) > 0);
$9:
	lxi 	h,#10
	dad 	sp
	push	h
	lxi 	h,#12
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#10
	dad 	sp
	call	ccgint
	pop 	d
	call	ccudiv
	pop 	d
	call	ccpint
	push	h
	lxi 	h,#0
	pop 	d
	call	ccugt
	mov 	a,h
	ora 	l
	jnz 	$8
$10:
;    
;    s[i] = EOS;
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	pop 	d
	dad 	d
	push	h
	lxi 	h,#0
	pop 	d
	mov 	a,l
	stax	d
;    reverse(s);
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	reverse
	pop 	b
;}
$7:
	pop 	b
	pop 	b
	ret
		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
	.globl	itoa
	;extrn	reverse
	.globl	utoab

;0 error(s) in compilation
;	literal pool:0
;	global pool:3
;	Macro pool:109
	;	.end
