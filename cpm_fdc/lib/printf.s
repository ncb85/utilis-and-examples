; Small C 8080
;	Coder (2.4,84/11/27)
;	Front End (2.7,84/11/28)
;	Front End for ASXXXX (2.8,13/01/20)
		;program area SMALLC_GENERATED is RELOCATABLE
		.module SMALLC_GENERATED
		.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
		.nlist  (pag)
		.area  SMALLC_GENERATED  (REL,CON,CSEG)
;/**
;        PRINTF Library Documentation
; 
;PRINTF supplies formatted output like that described by
;Kernighan and Ritchie.  The input conversion routine utoi (for
;unsigned integers) is also supplied.   
; 
;FUNCTIONS
; 
;printf(controlstring, arg, arg, ...) -- formatted print 
;    "controlstring" is a string which can contain any of
;    the following format codes: 
;        %d	decimal integer 
;        %u	unsigned decimal integer 
;        %x	hexidecimal integer 
;        %c	ASCII character 
;        %s	null-terminated ASCII string 
;        %f	fixed point conversion for double
;        %e	floating point conversion for double 
;    For each format code, there is an "arg" - a pointer to
;    an object of that type. Between the '%' and the format
;    code letter field specification may appear. For formats
;    'f' and 'e', the specification consists of two integers
;    separated by a period. The first specifies the minimum
;    field width, and the second the number of digits to be
;    printed after the decimal point. For all other formats,
;    the specification consists only of the one integer
;    giving the minimum field width. If there is no field 
;    specification, the item is printed in no more space 
;    than is necessary. 
;        Example			  Output 
;    printf(" decimal: %d ",15+2)	  decimal: 17  
;    printf(" unsigned: %u ",-1)	  unsigned: 65535  
;    printf(" hexidecimal: %x ",-1)	  hexidecimal: FFFF  
;    printf(" string: %s ","hello")	  string: hello  
;    printf(" character: %c ",65)	  character: A  
;    printf(" fixed: %f ",1./7.)	  fixed: .142857  
;    printf(" exponent: %8.5e ",1./7.) exponent: 1.42857e-1
;    printf returns the number of characters output.
; 
;fprintf(unit, controlstring, arg, arg, ..)
;    Provides functions similar to printf, but with output
;    going to the file associated with 'unit'.
;    fprintf returns the number of characters output.
;sprintf(string, controlstring, arg, arg, ..)
;    Provides functions similar to printf, but with output
;    going to the character pointer 'string'.
;    sprintf returns the number of characters output.
;itod(n, str, sz)  int n;  char str[];  int sz;  
;    convert n to signed decimal string of width sz, 
;    right adjusted, blank filled; returns str 
;    if sz > 0 terminate with null byte 
;    if sz = 0 find end of string 
;    if sz < 0 use last byte for data 
;  
;itou(nbr, str, sz)  int nbr;  char str[];  int sz;  
;    convert nbr to unsigned decimal string of width sz, 
;    right adjusted, blank filled; returns str 
;    if sz > 0 terminate with null byte 
;    if sz = 0 find end of string 
;    if sz < 0 use last byte for data 
;  
;itox(n, str, sz)  int n;  char str[];  int sz;  
;    converts n to hex string of length sz, right adjusted 
;    and blank filled, returns str 
;    if sz > 0 terminate with null byte 
;    if sz = 0 find end of string 
;    if sz < 0 use last byte for data 
;  
;ftoa(x,f,str) double x; int f; char *str; 
;    converts x to fixed point string with f digits after 
;    the decimal point, return str 
;  
;ftoe(x,f,str) double x; int f; char *str; 
;    converts x to floating point string with f digits after
;    the decimal point, return str 
; 
;utoi(decstr, nbr)  char *decstr;  int *nbr;  
;    converts unsigned decimal ASCII string to integer 
;    number. Returns field size, else ERR on error. (This is
;    used to interpret the specification fields.) 
; 
; 
;AUTHOR
;    J. E. Hendrix for the original routines. J. R.
;    Van Zandt for ftoa, ftoe, and the floating point
;    modifications in printf.
; 
; 
;INTERNAL DOCUMENTATION 
; 
;    The method used in ftoa to convert to a decimal string
;involves more divisions than the classical method, but does not
;require that the original number be scaled down at the
;beginning. It was found that this initial scaling was causing
;loss of precision. The present algorithm should always convert
;an integer exactly if it can be represented exactly as a
;floating point number (that is, if it is less than 2**40).
;The routines seen by the user (printf, fprintf, sprintf) are in
;the library PRINTF.  The routine which does all the hard work,
;_printf, is in either PRINTF1 or PRINTF2 depending on whether or
;not floating point output is required.
; */
;#include <stdio.h>
;#define stdin 0
;#define stdout 1
;#define stderr 2
;#define NULL 0
;#define EOF (-1)
;#define FILE char
;int ccargc;
;char *buffer, *_string;
;/**
; * fprintf(fd, ctlstring, arg, arg, ...) - Formatted print.
; * Operates as described by Kernighan & Ritchie.
; * b, c, d, o, s, u, and x specifications are supported.
; * Note: b (binary) is a non-standard extension.
; */
;fprintf(int argc) {
fprintf:
;    int *nxtarg;
	push	b
;    #asm
        sta     ccargc
        xra     a
        sta     ccargc+1
;    nxtarg = ccargc + &argc;
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
;	_string = NULL;
	lxi 	h,#0
	shld	_string
;    return _print(*(--nxtarg), --nxtarg);
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
	call	_print
	pop 	b
	pop 	b
	jmp 	$1
;}
$1:
	pop 	b
	ret
;/**
; * printf(ctlstring, arg, arg, ...) - Formatted print.
; * Operates as described by Kernighan & Ritchie.
; * b, c, d, o, s, u, and x specifications are supported.
; * Note: b (binary) is a non-standard extension.
; */
;printf(int argc) {
printf:
;    int *nxtarg;
	push	b
;    #asm
        sta     ccargc
        xra     a
        sta     ccargc+1
;    nxtarg = ccargc + &argc - 1;
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
;	_string = NULL;
	lxi 	h,#0
	shld	_string
;    return _print(stdout, nxtarg);
	lxi 	h,#1
	push	h
	lxi 	h,#2
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#2
	call	_print
	pop 	b
	pop 	b
	jmp 	$2
;}
$2:
	pop 	b
	ret
;sprintf(int argc) {
sprintf:
;	int *nxtarg;
	push	b
;    #asm
        sta     ccargc
        xra     a
        sta     ccargc+1
;    nxtarg = ccargc + &argc;
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
;	_string = *--nxtarg;
	lxi 	h,#0
	dad 	sp
	push	h
	call	ccgint
	dcx 	h
	dcx 	h
	pop 	d
	call	ccpint
	call	ccgint
	shld	_string
;	return _print(stdin, --nxtarg);
	lxi 	h,#0
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
	call	_print
	pop 	b
	pop 	b
	jmp 	$3
;}
$3:
	pop 	b
	ret
;/**
; * _print(fd, ctlstring, arg, arg, ...)
; * Called by fprintf() and printf().
; */
;_print(int fd, int *nxtarg) {
_print:
;    int arg, left, pad, cc, len, maxchr, width;
	push	b
	push	b
	push	b
	push	b
	push	b
	push	b
	push	b
;    char *ctl, *sptr, str[17];
	push	b
	push	b
	xchg
	lxi 	h,#-17
	dad 	sp
	sphl
	xchg
;    cc = 0;
	lxi 	h,#27
	dad 	sp
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
;    ctl = *nxtarg--;
	lxi 	h,#19
	dad 	sp
	push	h
	lxi 	h,#39
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
$5:
	lxi 	h,#19
	dad 	sp
	call	ccgint
	call	ccgchar
	mov 	a,h
	ora 	l
	jz  	$6
;        if (*ctl != '%') {
	lxi 	h,#19
	dad 	sp
	call	ccgint
	call	ccgchar
	push	h
	lxi 	h,#37
	pop 	d
	call	ccne
	mov 	a,h
	ora 	l
	jz  	$7
;            _outc(*ctl++, fd);
	lxi 	h,#19
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
	call	ccgchar
	push	h
	lxi 	h,#41
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#2
	call	_outc
	pop 	b
	pop 	b
;            ++cc;
	lxi 	h,#27
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
;            continue;
	jmp 	$5
;        } else {
	jmp 	$8
$7:
;            ++ctl;
	lxi 	h,#19
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
;        }
$8:
;        if (*ctl == '%') {
	lxi 	h,#19
	dad 	sp
	call	ccgint
	call	ccgchar
	push	h
	lxi 	h,#37
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$9
;            _outc(*ctl++, fd);
	lxi 	h,#19
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
	call	ccgchar
	push	h
	lxi 	h,#41
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#2
	call	_outc
	pop 	b
	pop 	b
;            ++cc;
	lxi 	h,#27
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
;            continue;
	jmp 	$5
;        }
;        if (*ctl == '-') {
$9:
	lxi 	h,#19
	dad 	sp
	call	ccgint
	call	ccgchar
	push	h
	lxi 	h,#45
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$10
;            left = 1;
	lxi 	h,#31
	dad 	sp
	push	h
	lxi 	h,#1
	pop 	d
	call	ccpint
;            ++ctl;
	lxi 	h,#19
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
;        } else left = 0;
	jmp 	$11
$10:
	lxi 	h,#31
	dad 	sp
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
$11:
;        if (*ctl == '0') pad = '0';
	lxi 	h,#19
	dad 	sp
	call	ccgint
	call	ccgchar
	push	h
	lxi 	h,#48
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$12
	lxi 	h,#29
	dad 	sp
	push	h
	lxi 	h,#48
	pop 	d
	call	ccpint
;        else pad = ' ';
	jmp 	$13
$12:
	lxi 	h,#29
	dad 	sp
	push	h
	lxi 	h,#32
	pop 	d
	call	ccpint
$13:
;        if (isdigit(*ctl)) {
	lxi 	h,#19
	dad 	sp
	call	ccgint
	call	ccgchar
	push	h
	mvi 	a,#1
	call	isdigit
	pop 	b
	mov 	a,h
	ora 	l
	jz  	$14
;            width = atoi(ctl++);
	lxi 	h,#21
	dad 	sp
	push	h
	lxi 	h,#21
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
	push	h
	mvi 	a,#1
	call	atoi
	pop 	b
	pop 	d
	call	ccpint
;            while (isdigit(*ctl)) ++ctl;
$15:
	lxi 	h,#19
	dad 	sp
	call	ccgint
	call	ccgchar
	push	h
	mvi 	a,#1
	call	isdigit
	pop 	b
	mov 	a,h
	ora 	l
	jz  	$16
	lxi 	h,#19
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	jmp 	$15
$16:
;        } else width = 0;
	jmp 	$17
$14:
	lxi 	h,#21
	dad 	sp
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
$17:
;        if (*ctl == '.') {
	lxi 	h,#19
	dad 	sp
	call	ccgint
	call	ccgchar
	push	h
	lxi 	h,#46
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$18
;            maxchr = atoi(++ctl);
	lxi 	h,#23
	dad 	sp
	push	h
	lxi 	h,#21
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	push	h
	mvi 	a,#1
	call	atoi
	pop 	b
	pop 	d
	call	ccpint
;            while (isdigit(*ctl)) ++ctl;
$19:
	lxi 	h,#19
	dad 	sp
	call	ccgint
	call	ccgchar
	push	h
	mvi 	a,#1
	call	isdigit
	pop 	b
	mov 	a,h
	ora 	l
	jz  	$20
	lxi 	h,#19
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	jmp 	$19
$20:
;        } else maxchr = 0;
	jmp 	$21
$18:
	lxi 	h,#23
	dad 	sp
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
$21:
;        arg = *nxtarg--;
	lxi 	h,#33
	dad 	sp
	push	h
	lxi 	h,#39
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
;        sptr = str;
	lxi 	h,#17
	dad 	sp
	push	h
	lxi 	h,#2
	dad 	sp
	pop 	d
	call	ccpint
;        switch (*ctl++) {
	lxi 	h,$22
	push	h
	lxi 	h,#21
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
	call	ccgchar
	jmp 	cccase
;            case 'c': str[0] = arg;
$24:
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#0
	pop 	d
	dad 	d
	push	h
	lxi 	h,#35
	dad 	sp
	call	ccgint
	pop 	d
	mov 	a,l
	stax	d
;                str[1] = NULL;
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#1
	pop 	d
	dad 	d
	push	h
	lxi 	h,#0
	pop 	d
	mov 	a,l
	stax	d
;                break;
	jmp 	$23
;            case 's': sptr = arg;
$25:
	lxi 	h,#17
	dad 	sp
	push	h
	lxi 	h,#35
	dad 	sp
	call	ccgint
	pop 	d
	call	ccpint
;                break;
	jmp 	$23
;            case 'd': itoa(arg, str);
$26:
	lxi 	h,#33
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#2
	dad 	sp
	push	h
	mvi 	a,#2
	call	itoa
	pop 	b
	pop 	b
;                break;
	jmp 	$23
;            case 'b': utoab(arg, str, 2);
$27:
	lxi 	h,#33
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#2
	dad 	sp
	push	h
	lxi 	h,#2
	push	h
	mvi 	a,#3
	call	utoab
	pop 	b
	pop 	b
	pop 	b
;                break;
	jmp 	$23
;            case 'o': utoab(arg, str, 8);
$28:
	lxi 	h,#33
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#2
	dad 	sp
	push	h
	lxi 	h,#8
	push	h
	mvi 	a,#3
	call	utoab
	pop 	b
	pop 	b
	pop 	b
;                break;
	jmp 	$23
;            case 'u': utoab(arg, str, 10);
$29:
	lxi 	h,#33
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#2
	dad 	sp
	push	h
	lxi 	h,#10
	push	h
	mvi 	a,#3
	call	utoab
	pop 	b
	pop 	b
	pop 	b
;                break;
	jmp 	$23
;            case 'x': utoab(arg, str, 16);
$30:
	lxi 	h,#33
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#2
	dad 	sp
	push	h
	lxi 	h,#16
	push	h
	mvi 	a,#3
	call	utoab
	pop 	b
	pop 	b
	pop 	b
;                break;
	jmp 	$23
;            default: return (cc);
$31:
	lxi 	h,#27
	dad 	sp
	call	ccgint
	jmp 	$4
;        }
	jmp 	$23
		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
$22:
	.dw	#99,$24,#115,$25,#100,$26,#98,$27
	.dw	#111,$28,#117,$29,#120,$30
	.dw	$31,0
		.area  SMALLC_GENERATED  (REL,CON,CSEG)
$23:
;        len = strlen(sptr);
	lxi 	h,#25
	dad 	sp
	push	h
	lxi 	h,#19
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	strlen
	pop 	b
	pop 	d
	call	ccpint
;        if (maxchr && maxchr < len) {
	lxi 	h,#23
	dad 	sp
	call	ccgint
	mov 	a,h
	ora 	l
	jz  	$33
	lxi 	h,#23
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#27
	dad 	sp
	call	ccgint
	pop 	d
	call	cclt
$33:
	call	ccbool
	mov 	a,h
	ora 	l
	jz  	$32
;            len = maxchr;
	lxi 	h,#25
	dad 	sp
	push	h
	lxi 	h,#25
	dad 	sp
	call	ccgint
	pop 	d
	call	ccpint
;        }
;        if (width > len) {
$32:
	lxi 	h,#21
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#27
	dad 	sp
	call	ccgint
	pop 	d
	call	ccgt
	mov 	a,h
	ora 	l
	jz  	$34
;            width = width - len;
	lxi 	h,#21
	dad 	sp
	push	h
	lxi 	h,#23
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#29
	dad 	sp
	call	ccgint
	pop 	d
	call	ccsub
	pop 	d
	call	ccpint
;        } else {
	jmp 	$35
$34:
;            width = 0;
	lxi 	h,#21
	dad 	sp
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
;        }
$35:
;        if (!left) {
	lxi 	h,#31
	dad 	sp
	call	ccgint
	call	cclneg
	mov 	a,h
	ora 	l
	jz  	$36
;            while (width--) {
$37:
	lxi 	h,#21
	dad 	sp
	push	h
	call	ccgint
	dcx 	h
	pop 	d
	call	ccpint
	inx 	h
	mov 	a,h
	ora 	l
	jz  	$38
;                _outc(pad, fd);
	lxi 	h,#29
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#41
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#2
	call	_outc
	pop 	b
	pop 	b
;                ++cc;
	lxi 	h,#27
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
;            }
	jmp 	$37
$38:
;        }
;        while (len--) {
$36:
$39:
	lxi 	h,#25
	dad 	sp
	push	h
	call	ccgint
	dcx 	h
	pop 	d
	call	ccpint
	inx 	h
	mov 	a,h
	ora 	l
	jz  	$40
;            _outc(*sptr++, fd);
	lxi 	h,#17
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
	call	ccgchar
	push	h
	lxi 	h,#41
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#2
	call	_outc
	pop 	b
	pop 	b
;            ++cc;
	lxi 	h,#27
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
;        }
	jmp 	$39
$40:
;        if (left) {
	lxi 	h,#31
	dad 	sp
	call	ccgint
	mov 	a,h
	ora 	l
	jz  	$41
;            while (width--) {
$42:
	lxi 	h,#21
	dad 	sp
	push	h
	call	ccgint
	dcx 	h
	pop 	d
	call	ccpint
	inx 	h
	mov 	a,h
	ora 	l
	jz  	$43
;                _outc(pad, fd);
	lxi 	h,#29
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#41
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#2
	call	_outc
	pop 	b
	pop 	b
;                ++cc;
	lxi 	h,#27
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
;            }
	jmp 	$42
$43:
;        }
;    }
$41:
	jmp 	$5
$6:
;    return (cc);
	lxi 	h,#27
	dad 	sp
	call	ccgint
	jmp 	$4
;}
$4:
	xchg
	lxi 	h,#35
	dad 	sp
	sphl
	xchg
	ret
;/**
; * _outc - output a single character
; * if _string is not null send output to a string instead
; */
;_outc(char c, int fd) {
_outc:
;	if (_string == NULL)
	lhld	_string
	push	h
	lxi 	h,#0
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$45
;		fputc(c, fd);
	lxi 	h,#4
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#2
	call	fputc
	pop 	b
	pop 	b
;	else
	jmp 	$46
$45:
;		*_string++ = c;
	lhld	_string
	inx 	h
	shld	_string
	dcx 	h
	push	h
	lxi 	h,#6
	dad 	sp
	call	ccgchar
	pop 	d
	mov 	a,l
	stax	d
$46:
;}
$44:
	ret
		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
	.globl	ccargc
ccargc:
	.dw	#0
	.globl	buffer
buffer:
	.dw	#0
	.globl	_string
_string:
	.dw	#0
	.globl	fprintf
	.globl	_print
	.globl	printf
	.globl	sprintf
	.globl	_outc
	;extrn	isdigit
	;extrn	atoi
	;extrn	itoa
	;extrn	utoab
	;extrn	strlen
	;extrn	fputc

;0 error(s) in compilation
;	literal pool:0
;	global pool:14
;	Macro pool:103
	;	.end
