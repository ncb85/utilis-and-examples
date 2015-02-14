; Small C 8080
;	Coder (2.4,84/11/27)
;	Front End (2.7,84/11/28)
;	Front End for ASXXXX (2.8,13/01/20)
		;program area SMALLC_GENERATED is RELOCATABLE
		.module SMALLC_GENERATED
		.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
		.nlist  (pag)
		.area  SMALLC_GENERATED  (REL,CON,CSEG)
;/*
; * Main interface to scanf-type routines, independent of integer/float
; *
; * scanf(controlstring, arg, arg, ...)  or 
; * sscanf(string, controlstring, arg, arg, ...) or
; * fscanf(file, controlstring, arg, arg, ...) --  formatted read
; *        operates as described by Kernighan & Ritchie
; */
;#include <stdio.h>
;#define stdin 0
;#define stdout 1
;#define stderr 2
;#define NULL 0
;#define EOF (-1)
;#define FILE char
;//#include <ctype.h>
;#define ERR (-1)
;extern int ccargc;
;char *_String1;
;int _Oldch;
;scanf(args)
scanf:
;int args;
;{
;    #asm
        sta ccargc
        xra a
        sta ccargc + 1
;    _String1 = NULL;
	lxi 	h,#0
	shld	_String1
;    return ( _scanf(stdin, ccargc + &args - 1));
	lxi 	h,#0
	push	h
	lhld	ccargc
	push	h
	lxi 	h,#6
	dad 	sp
	pop 	d
	xchg
	dad 	h
	xchg
	dad 	d
	push	h
	lxi 	h,#1
	dad 	h
	pop 	d
	call	ccsub
	push	h
	mvi 	a,#2
	call	_scanf
	pop 	b
	pop 	b
	jmp 	$1
;}
$1:
	ret
;fscanf(args)
fscanf:
;int args;
;{
;    int *nxtarg;
	push	b
;    #asm
        sta ccargc
        xra a
        sta ccargc + 1
;    _String1 = NULL;
	lxi 	h,#0
	shld	_String1
;    nxtarg = ccargc + &args;
	lxi 	h,#0
	dad 	sp
	push	h
	lhld	ccargc
	push	h
	lxi 	h,#8
	dad 	sp
	pop 	d
	xchg
	dad 	h
	xchg
	dad 	d
	pop 	d
	call	ccpint
;    return ( _scanf(*(--nxtarg), --nxtarg));
	lxi 	h,#0
	dad 	sp
	push	h
	call	ccgint
	dcx 	h
	dcx 	h
	pop 	d
	call	ccpint
	call	ccgint
	push	h
	lxi 	h,#2
	dad 	sp
	push	h
	call	ccgint
	dcx 	h
	dcx 	h
	pop 	d
	call	ccpint
	push	h
	mvi 	a,#2
	call	_scanf
	pop 	b
	pop 	b
	jmp 	$2
;}
$2:
	pop 	b
	ret
;sscanf(args)
sscanf:
;int args;
;{
;    int *nxtarg;
	push	b
;    #asm
        sta ccargc
        xra a
        sta ccargc + 1
;    nxtarg = ccargc + &args - 1;
	lxi 	h,#0
	dad 	sp
	push	h
	lhld	ccargc
	push	h
	lxi 	h,#8
	dad 	sp
	pop 	d
	xchg
	dad 	h
	xchg
	dad 	d
	push	h
	lxi 	h,#1
	dad 	h
	pop 	d
	call	ccsub
	pop 	d
	call	ccpint
;    _String1 = *nxtarg;
	lxi 	h,#0
	dad 	sp
	call	ccgint
	call	ccgint
	shld	_String1
;    return ( _scanf(stdout, --nxtarg));
	lxi 	h,#1
	push	h
	lxi 	h,#2
	dad 	sp
	push	h
	call	ccgint
	dcx 	h
	dcx 	h
	pop 	d
	call	ccpint
	push	h
	mvi 	a,#2
	call	_scanf
	pop 	b
	pop 	b
	jmp 	$3
;}
$3:
	pop 	b
	ret
;/*
; * _getc - fetch a single character from file
; *         if _String1 is not null fetch from a string instead
; */
;_getc(fd)
_getc:
;int fd;
;{
;    int c;
	push	b
;    if (_Oldch != EOF) {
	lhld	_Oldch
	push	h
	lxi 	h,#1
	call	ccneg
	pop 	d
	call	ccne
	mov 	a,h
	ora 	l
	jz  	$5
;        c = _Oldch;
	lxi 	h,#0
	dad 	sp
	push	h
	lhld	_Oldch
	pop 	d
	call	ccpint
;        _Oldch = EOF;
	lxi 	h,#1
	call	ccneg
	shld	_Oldch
;        return c;
	lxi 	h,#0
	dad 	sp
	call	ccgint
	jmp 	$4
;    } else {
	jmp 	$6
$5:
;        if (_String1 != NULL) {
	lhld	_String1
	push	h
	lxi 	h,#0
	pop 	d
	call	ccne
	mov 	a,h
	ora 	l
	jz  	$7
;            if ((c = *_String1++)) return c;
	lxi 	h,#0
	dad 	sp
	push	h
	lhld	_String1
	inx 	h
	shld	_String1
	dcx 	h
	call	ccgchar
	pop 	d
	call	ccpint
	mov 	a,h
	ora 	l
	jz  	$8
	lxi 	h,#0
	dad 	sp
	call	ccgint
	jmp 	$4
;            else {
	jmp 	$9
$8:
;                --_String1;
	lhld	_String1
	dcx 	h
	shld	_String1
;                return EOF;
	lxi 	h,#1
	call	ccneg
	jmp 	$4
;            }
$9:
;        } else {
	jmp 	$10
$7:
;            return fgetc(fd);
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	fgetc
	pop 	b
	jmp 	$4
;        }
$10:
;    }
$6:
;}
$4:
	pop 	b
	ret
;/*
; * unget character assume only one source of characters
; * i.e. does not require file descriptor
; */
;_ungetc(ch)
_ungetc:
;int ch;
;{
;    _Oldch = ch;
	lxi 	h,#2
	dad 	sp
	call	ccgint
	shld	_Oldch
;}
$11:
	ret
		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
	;extrn	ccargc
	.globl	_String1
_String1:
	.dw	#0
	.globl	_Oldch
_Oldch:
	.dw	#0
	.globl	scanf
	;extrn	_scanf
	.globl	fscanf
	.globl	sscanf
	.globl	_getc
	;extrn	fgetc
	.globl	_ungetc

;0 error(s) in compilation
;	literal pool:0
;	global pool:10
;	Macro pool:112
	;	.end
