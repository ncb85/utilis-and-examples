; Small C 8080
;	Coder (2.4,84/11/27)
;	Front End (2.7,84/11/28)
;	Front End for ASXXXX (2.8,13/01/20)
		;program area SMALLC_GENERATED is RELOCATABLE
		.module SMALLC_GENERATED
		.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
		.nlist  (pag)
		.area  SMALLC_GENERATED  (REL,CON,CSEG)
;isalpha(c) char c;{
isalpha:
;        if ((c >= 'a' & c <= 'z') |
	lxi 	h,#2
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#97
	pop 	d
	call	ccge
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#122
	pop 	d
	call	ccle
	pop 	d
	call	ccand
	push	h
;            (c >= 'A' & c <= 'Z'))    return(1);
	lxi 	h,#4
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#65
	pop 	d
	call	ccge
	push	h
	lxi 	h,#6
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#90
	pop 	d
	call	ccle
	pop 	d
	call	ccand
	pop 	d
	call	ccor
	mov 	a,h
	ora 	l
	jz  	$2
	lxi 	h,#1
	jmp 	$1
;        else                            return(0);
	jmp 	$3
$2:
	lxi 	h,#0
	jmp 	$1
$3:
;        }
$1:
	ret
;isupper(c) char c;{
isupper:
;        if (c >= 'A' & c <= 'Z')      return(1);
	lxi 	h,#2
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#65
	pop 	d
	call	ccge
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#90
	pop 	d
	call	ccle
	pop 	d
	call	ccand
	mov 	a,h
	ora 	l
	jz  	$5
	lxi 	h,#1
	jmp 	$4
;        else                            return(0);
	jmp 	$6
$5:
	lxi 	h,#0
	jmp 	$4
$6:
;        }
$4:
	ret
;islower(c) char c;{
islower:
;        if (c >= 'a' & c <= 'z')      return(1);
	lxi 	h,#2
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#97
	pop 	d
	call	ccge
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#122
	pop 	d
	call	ccle
	pop 	d
	call	ccand
	mov 	a,h
	ora 	l
	jz  	$8
	lxi 	h,#1
	jmp 	$7
;        else                            return(0);
	jmp 	$9
$8:
	lxi 	h,#0
	jmp 	$7
$9:
;        }
$7:
	ret
;isdigit(c) char c;{
isdigit:
;        if (c >= '0' & c <= '9')      return(1);
	lxi 	h,#2
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#48
	pop 	d
	call	ccge
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#57
	pop 	d
	call	ccle
	pop 	d
	call	ccand
	mov 	a,h
	ora 	l
	jz  	$11
	lxi 	h,#1
	jmp 	$10
;        else                            return(0);
	jmp 	$12
$11:
	lxi 	h,#0
	jmp 	$10
$12:
;        }
$10:
	ret
;isspace(c) char c;{
isspace:
;        if (c == ' ' | c == '\t' | c == '\n')   return(1);
	lxi 	h,#2
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#32
	pop 	d
	call	cceq
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#9
	pop 	d
	call	cceq
	pop 	d
	call	ccor
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#10
	pop 	d
	call	cceq
	pop 	d
	call	ccor
	mov 	a,h
	ora 	l
	jz  	$14
	lxi 	h,#1
	jmp 	$13
;        else                                    return(0);
	jmp 	$15
$14:
	lxi 	h,#0
	jmp 	$13
$15:
;        }
$13:
	ret
;toupper(c) char c;{
toupper:
;        return ((c >= 'a' && c <= 'z') ? c - 32: c);
	lxi 	h,#2
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#97
	pop 	d
	call	ccge
	mov 	a,h
	ora 	l
	jz  	$17
	lxi 	h,#2
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#122
	pop 	d
	call	ccle
$17:
	call	ccbool
	mov 	a,h
	ora 	l
	jz  	$18
	lxi 	h,#2
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#32
	pop 	d
	call	ccsub
	jmp 	$19
$18:
	lxi 	h,#2
	dad 	sp
	call	ccgchar
$19:
	jmp 	$16
;        }
$16:
	ret
;tolower(c) char c;{
tolower:
;        return((c >= 'A' && c <= 'Z') ? c + 32: c);
	lxi 	h,#2
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#65
	pop 	d
	call	ccge
	mov 	a,h
	ora 	l
	jz  	$21
	lxi 	h,#2
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#90
	pop 	d
	call	ccle
$21:
	call	ccbool
	mov 	a,h
	ora 	l
	jz  	$22
	lxi 	h,#2
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#32
	pop 	d
	dad 	d
	jmp 	$23
$22:
	lxi 	h,#2
	dad 	sp
	call	ccgchar
$23:
	jmp 	$20
;        }
$20:
	ret
		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
	.globl	isalpha
	.globl	isupper
	.globl	islower
	.globl	isdigit
	.globl	isspace
	.globl	toupper
	.globl	tolower

;0 error(s) in compilation
;	literal pool:0
;	global pool:7
;	Macro pool:51
	;	.end
