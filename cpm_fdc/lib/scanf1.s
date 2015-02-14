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
; * Core routine for integer-only scanf-type functions
; *        only d, o, x, c, s, and u specs are supported.
; */
;//#include <ctype.h>
;#include <stdio.h>
;#define stdin 0
;#define stdout 1
;#define stderr 2
;#define NULL 0
;#define EOF (-1)
;#define FILE char
;//#define NULL 0
;#define ERR (-1)
;extern int _Oldch;
;//extern _getc(), _ungetc(), utoi();
;_scanf(fd, nxtarg)
_scanf:
;int fd, *nxtarg;
;{
;    char *carg, *ctl, *unsigned;
	push	b
	push	b
	push	b
;    int *narg, wast, ac, width, ch, cnv, base, ovfl, sign;
	push	b
	push	b
	push	b
	push	b
	push	b
	push	b
	push	b
	push	b
	push	b
;    _Oldch = EOF;
	lxi 	h,#1
	call	ccneg
	shld	_Oldch
;    ac = 0;
	lxi 	h,#12
	dad 	sp
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
;    ctl = *nxtarg--;
	lxi 	h,#20
	dad 	sp
	push	h
	lxi 	h,#28
	dad 	sp
	push	h
	call	ccgint
	dcx 	h
	dcx 	h
	pop 	d
	call	ccpint
	inx 	h
	inx 	h
	call	ccgint
	pop 	d
	call	ccpint
;    while (*ctl) {
$2:
	lxi 	h,#20
	dad 	sp
	call	ccgint
	call	ccgchar
	mov 	a,h
	ora 	l
	jz  	$3
;        if (isspace(*ctl)) {
	lxi 	h,#20
	dad 	sp
	call	ccgint
	call	ccgchar
	push	h
	mvi 	a,#1
	call	isspace
	pop 	b
	mov 	a,h
	ora 	l
	jz  	$4
;            ++ctl;
	lxi 	h,#20
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
;            continue;
	jmp 	$2
;        }
;        if (*ctl++ != '%') continue;
$4:
	lxi 	h,#20
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
	call	ccgchar
	push	h
	lxi 	h,#37
	pop 	d
	call	ccne
	mov 	a,h
	ora 	l
	jz  	$5
	jmp 	$2
;        if (*ctl == '*') {
$5:
	lxi 	h,#20
	dad 	sp
	call	ccgint
	call	ccgchar
	push	h
	lxi 	h,#42
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$6
;            narg = carg = &wast;
	lxi 	h,#16
	dad 	sp
	push	h
	lxi 	h,#24
	dad 	sp
	push	h
	lxi 	h,#18
	dad 	sp
	pop 	d
	call	ccpint
	pop 	d
	call	ccpint
;            ++ctl;
	lxi 	h,#20
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
;        } else narg = carg = *nxtarg--;
	jmp 	$7
$6:
	lxi 	h,#16
	dad 	sp
	push	h
	lxi 	h,#24
	dad 	sp
	push	h
	lxi 	h,#30
	dad 	sp
	push	h
	call	ccgint
	dcx 	h
	dcx 	h
	pop 	d
	call	ccpint
	inx 	h
	inx 	h
	call	ccgint
	pop 	d
	call	ccpint
	pop 	d
	call	ccpint
$7:
;        ctl += utoi(ctl, &width);
	lxi 	h,#20
	dad 	sp
	push	h
	call	ccgint
	push	h
	lxi 	h,#24
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#16
	dad 	sp
	push	h
	mvi 	a,#2
	call	utoi
	pop 	b
	pop 	b
	pop 	d
	dad 	d
	pop 	d
	call	ccpint
;        if (!width) width = 32767;
	lxi 	h,#10
	dad 	sp
	call	ccgint
	call	cclneg
	mov 	a,h
	ora 	l
	jz  	$8
	lxi 	h,#10
	dad 	sp
	push	h
	lxi 	h,#32767
	pop 	d
	call	ccpint
;        if (!(cnv = *ctl++)) break;
$8:
	lxi 	h,#6
	dad 	sp
	push	h
	lxi 	h,#22
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
	call	ccgchar
	pop 	d
	call	ccpint
	call	cclneg
	mov 	a,h
	ora 	l
	jz  	$9
	jmp 	$3
;        while (isspace(ch = _getc(fd)))
$9:
$10:
	lxi 	h,#8
	dad 	sp
	push	h
	lxi 	h,#30
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	_getc
	pop 	b
	pop 	d
	call	ccpint
	push	h
	mvi 	a,#1
	call	isspace
	pop 	b
	mov 	a,h
	ora 	l
	jz  	$11
;            ;
	jmp 	$10
$11:
;        if (ch == EOF) {
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#1
	call	ccneg
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$12
;            if (ac) break;
	lxi 	h,#12
	dad 	sp
	call	ccgint
	mov 	a,h
	ora 	l
	jz  	$13
	jmp 	$3
;            else return EOF;
	jmp 	$14
$13:
	lxi 	h,#1
	call	ccneg
	jmp 	$1
$14:
;        }
;        _ungetc(ch);
$12:
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	_ungetc
	pop 	b
;        switch (cnv) {
	lxi 	h,$15
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	jmp 	cccase
;            case 'c':
$17:
;                *carg = _getc(fd);
	lxi 	h,#22
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#30
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	_getc
	pop 	b
	pop 	d
	mov 	a,l
	stax	d
;                break;
	jmp 	$16
;            case 's':
$18:
;                while (width--) {
$19:
	lxi 	h,#10
	dad 	sp
	push	h
	call	ccgint
	dcx 	h
	pop 	d
	call	ccpint
	inx 	h
	mov 	a,h
	ora 	l
	jz  	$20
;                    if ((*carg = _getc(fd)) == EOF) break;
	lxi 	h,#22
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#30
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	_getc
	pop 	b
	pop 	d
	mov 	a,l
	stax	d
	push	h
	lxi 	h,#1
	call	ccneg
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$21
	jmp 	$20
;                    if (isspace(*carg)) break;
$21:
	lxi 	h,#22
	dad 	sp
	call	ccgint
	call	ccgchar
	push	h
	mvi 	a,#1
	call	isspace
	pop 	b
	mov 	a,h
	ora 	l
	jz  	$22
	jmp 	$20
;                    if (carg != &wast) ++carg;
$22:
	lxi 	h,#22
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#16
	dad 	sp
	pop 	d
	call	ccne
	mov 	a,h
	ora 	l
	jz  	$23
	lxi 	h,#22
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
;                }
$23:
	jmp 	$19
$20:
;                *carg = 0;
	lxi 	h,#22
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#0
	pop 	d
	mov 	a,l
	stax	d
;                break;
	jmp 	$16
;            default:
$24:
;                switch (cnv) {
	lxi 	h,$25
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	jmp 	cccase
;                    case 'd': base = 10;
$27:
	lxi 	h,#4
	dad 	sp
	push	h
	lxi 	h,#10
	pop 	d
	call	ccpint
;                        sign = 0;
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
;                        ovfl = 3276;
	lxi 	h,#2
	dad 	sp
	push	h
	lxi 	h,#3276
	pop 	d
	call	ccpint
;                        break;
	jmp 	$26
;                    case 'o': base = 8;
$28:
	lxi 	h,#4
	dad 	sp
	push	h
	lxi 	h,#8
	pop 	d
	call	ccpint
;                        sign = 1;
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#1
	pop 	d
	call	ccpint
;                        ovfl = 8191;
	lxi 	h,#2
	dad 	sp
	push	h
	lxi 	h,#8191
	pop 	d
	call	ccpint
;                        break;
	jmp 	$26
;                    case 'u': base = 10;
$29:
	lxi 	h,#4
	dad 	sp
	push	h
	lxi 	h,#10
	pop 	d
	call	ccpint
;                        sign = 1;
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#1
	pop 	d
	call	ccpint
;                        ovfl = 6553;
	lxi 	h,#2
	dad 	sp
	push	h
	lxi 	h,#6553
	pop 	d
	call	ccpint
;                        break;
	jmp 	$26
;                    case 'x': base = 16;
$30:
	lxi 	h,#4
	dad 	sp
	push	h
	lxi 	h,#16
	pop 	d
	call	ccpint
;                        sign = 1;
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#1
	pop 	d
	call	ccpint
;                        ovfl = 4095;
	lxi 	h,#2
	dad 	sp
	push	h
	lxi 	h,#4095
	pop 	d
	call	ccpint
;                        break;
	jmp 	$26
;                    default: return ac;
$31:
	lxi 	h,#12
	dad 	sp
	call	ccgint
	jmp 	$1
;                }
	jmp 	$26
		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
$25:
	.dw	#100,$27,#111,$28,#117,$29,#120,$30
	.dw	$31,0
		.area  SMALLC_GENERATED  (REL,CON,CSEG)
$26:
;                *narg = unsigned = 0;
	lxi 	h,#16
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#20
	dad 	sp
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
	pop 	d
	call	ccpint
;                while (width-- && !isspace(ch = _getc(fd)) && ch != EOF) {
$32:
	lxi 	h,#10
	dad 	sp
	push	h
	call	ccgint
	dcx 	h
	pop 	d
	call	ccpint
	inx 	h
	mov 	a,h
	ora 	l
	jz  	$34
	lxi 	h,#8
	dad 	sp
	push	h
	lxi 	h,#30
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	_getc
	pop 	b
	pop 	d
	call	ccpint
	push	h
	mvi 	a,#1
	call	isspace
	pop 	b
	call	cclneg
$34:
	call	ccbool
	mov 	a,h
	ora 	l
	jz  	$35
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#1
	call	ccneg
	pop 	d
	call	ccne
$35:
	call	ccbool
	mov 	a,h
	ora 	l
	jz  	$33
;                    if (!sign)
	lxi 	h,#0
	dad 	sp
	call	ccgint
	call	cclneg
	mov 	a,h
	ora 	l
	jz  	$36
;                        if (ch == '-') {
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#45
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$37
;                            sign = -1;
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#1
	call	ccneg
	pop 	d
	call	ccpint
;                            continue;
	jmp 	$32
;                        } else sign = 1;
	jmp 	$38
$37:
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#1
	pop 	d
	call	ccpint
$38:
;                    if (ch < '0') return ac;
$36:
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#48
	pop 	d
	call	cclt
	mov 	a,h
	ora 	l
	jz  	$39
	lxi 	h,#12
	dad 	sp
	call	ccgint
	jmp 	$1
;                    if (ch >= 'a') ch -= 87;
$39:
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#97
	pop 	d
	call	ccge
	mov 	a,h
	ora 	l
	jz  	$40
	lxi 	h,#8
	dad 	sp
	push	h
	call	ccgint
	push	h
	lxi 	h,#87
	pop 	d
	call	ccsub
	pop 	d
	call	ccpint
;                    else if (ch >= 'A') ch -= 55;
	jmp 	$41
$40:
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#65
	pop 	d
	call	ccge
	mov 	a,h
	ora 	l
	jz  	$42
	lxi 	h,#8
	dad 	sp
	push	h
	call	ccgint
	push	h
	lxi 	h,#55
	pop 	d
	call	ccsub
	pop 	d
	call	ccpint
;                    else ch -= '0';
	jmp 	$43
$42:
	lxi 	h,#8
	dad 	sp
	push	h
	call	ccgint
	push	h
	lxi 	h,#48
	pop 	d
	call	ccsub
	pop 	d
	call	ccpint
$43:
$41:
;                    if (ch >= base || unsigned > ovfl) return ac;
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#6
	dad 	sp
	call	ccgint
	pop 	d
	call	ccge
	mov 	a,h
	ora 	l
	jnz 	$45
	lxi 	h,#18
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	pop 	d
	call	ccugt
$45:
	call	ccbool
	mov 	a,h
	ora 	l
	jz  	$44
	lxi 	h,#12
	dad 	sp
	call	ccgint
	jmp 	$1
;                    unsigned = unsigned * base + ch;
$44:
	lxi 	h,#18
	dad 	sp
	push	h
	lxi 	h,#20
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	pop 	d
	call	ccmul
	push	h
	lxi 	h,#12
	dad 	sp
	call	ccgint
	pop 	d
	dad 	d
	pop 	d
	call	ccpint
;                }
	jmp 	$32
$33:
;                *narg = sign * unsigned;
	lxi 	h,#16
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#2
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#22
	dad 	sp
	call	ccgint
	pop 	d
	call	ccmul
	pop 	d
	call	ccpint
;        }
	jmp 	$16
		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
$15:
	.dw	#99,$17,#115,$18
	.dw	$24,0
		.area  SMALLC_GENERATED  (REL,CON,CSEG)
$16:
;        ++ac;
	lxi 	h,#12
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
;    }
	jmp 	$2
$3:
;    return ac;
	lxi 	h,#12
	dad 	sp
	call	ccgint
	jmp 	$1
;}
$1:
	xchg
	lxi 	h,#24
	dad 	sp
	sphl
	xchg
	ret
		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
	;extrn	_Oldch
	.globl	_scanf
	;extrn	isspace
	;extrn	utoi
	;extrn	_getc
	;extrn	_ungetc

;0 error(s) in compilation
;	literal pool:0
;	global pool:6
;	Macro pool:112
	;	.end
