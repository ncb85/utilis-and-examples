; Small C 8080
;	Coder (2.4,84/11/27)
;	Front End (2.7,84/11/28)
;	Front End for ASXXXX (2.8,13/01/20)
		;program area SMALLC_GENERATED is RELOCATABLE
		.module SMALLC_GENERATED
		.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
		.nlist  (pag)
		.area  SMALLC_GENERATED  (REL,CON,CSEG)
;/*      Interpret CPM argument list to produce C style
;        argc/argv
;        default dma buffer has it, form:
;        ---------------------------------
;        |count|characters  ...          |
;        ---------------------------------
; */
;int Xargc;
;int Xargv[30];
;Xarglist(char *ap) {
Xarglist:
;    char qc;
	dcx 	sp
;    Xargc = 0;
	lxi 	h,#0
	shld	Xargc
;    ap[(*ap) + 1] = '\0';
	lxi 	h,#3
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#5
	dad 	sp
	call	ccgint
	call	ccgchar
	push	h
	lxi 	h,#1
	pop 	d
	dad 	d
	pop 	d
	dad 	d
	push	h
	lxi 	h,#0
	pop 	d
	mov 	a,l
	stax	d
;    ap++;
	lxi 	h,#3
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
;    while (isspace(*ap)) ap++;
$2:
	lxi 	h,#3
	dad 	sp
	call	ccgint
	call	ccgchar
	push	h
	mvi 	a,#1
	call	isspace
	pop 	b
	mov 	a,h
	ora 	l
	jz  	$3
	lxi 	h,#3
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
	jmp 	$2
$3:
;    Xargv[Xargc++] = "arg0";
	lxi 	h,Xargv
	push	h
	lhld	Xargc
	inx 	h
	shld	Xargc
	dcx 	h
	dad 	h
	pop 	d
	dad 	d
	push	h
	lxi 	h,$0+#0
	pop 	d
	call	ccpint
;    if (*ap)
	lxi 	h,#3
	dad 	sp
	call	ccgint
	call	ccgchar
	mov 	a,h
	ora 	l
	jz  	$4
;        do {
$5:
;            if (*ap == '\'' || *ap == '\"') {
	lxi 	h,#3
	dad 	sp
	call	ccgint
	call	ccgchar
	push	h
	lxi 	h,#39
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jnz 	$9
	lxi 	h,#3
	dad 	sp
	call	ccgint
	call	ccgchar
	push	h
	lxi 	h,#34
	pop 	d
	call	cceq
$9:
	call	ccbool
	mov 	a,h
	ora 	l
	jz  	$8
;                qc = *ap;
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#5
	dad 	sp
	call	ccgint
	call	ccgchar
	pop 	d
	mov 	a,l
	stax	d
;                Xargv[Xargc++] = ++ap;
	lxi 	h,Xargv
	push	h
	lhld	Xargc
	inx 	h
	shld	Xargc
	dcx 	h
	dad 	h
	pop 	d
	dad 	d
	push	h
	lxi 	h,#5
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	pop 	d
	call	ccpint
;                while (*ap&&*ap != qc) ap++;
$10:
	lxi 	h,#3
	dad 	sp
	call	ccgint
	call	ccgchar
	mov 	a,h
	ora 	l
	jz  	$12
	lxi 	h,#3
	dad 	sp
	call	ccgint
	call	ccgchar
	push	h
	lxi 	h,#2
	dad 	sp
	call	ccgchar
	pop 	d
	call	ccne
$12:
	call	ccbool
	mov 	a,h
	ora 	l
	jz  	$11
	lxi 	h,#3
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
	jmp 	$10
$11:
;            } else {
	jmp 	$13
$8:
;                Xargv[Xargc++] = ap;
	lxi 	h,Xargv
	push	h
	lhld	Xargc
	inx 	h
	shld	Xargc
	dcx 	h
	dad 	h
	pop 	d
	dad 	d
	push	h
	lxi 	h,#5
	dad 	sp
	call	ccgint
	pop 	d
	call	ccpint
;                while (*ap&&!isspace(*ap)) ap++;
$14:
	lxi 	h,#3
	dad 	sp
	call	ccgint
	call	ccgchar
	mov 	a,h
	ora 	l
	jz  	$16
	lxi 	h,#3
	dad 	sp
	call	ccgint
	call	ccgchar
	push	h
	mvi 	a,#1
	call	isspace
	pop 	b
	call	cclneg
$16:
	call	ccbool
	mov 	a,h
	ora 	l
	jz  	$15
	lxi 	h,#3
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
	jmp 	$14
$15:
;            }
$13:
;            if (!*ap) break;
	lxi 	h,#3
	dad 	sp
	call	ccgint
	call	ccgchar
	call	cclneg
	mov 	a,h
	ora 	l
	jz  	$17
	jmp 	$7
;            *ap++ = '\0';
$17:
	lxi 	h,#3
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
	push	h
	lxi 	h,#0
	pop 	d
	mov 	a,l
	stax	d
;            while (isspace(*ap)) ap++;
$18:
	lxi 	h,#3
	dad 	sp
	call	ccgint
	call	ccgchar
	push	h
	mvi 	a,#1
	call	isspace
	pop 	b
	mov 	a,h
	ora 	l
	jz  	$19
	lxi 	h,#3
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
	jmp 	$18
$19:
;        } while (*ap);
$6:
	lxi 	h,#3
	dad 	sp
	call	ccgint
	call	ccgchar
	mov 	a,h
	ora 	l
	jnz 	$5
$7:
;    Xargv[Xargc] = 0;
$4:
	lxi 	h,Xargv
	push	h
	lhld	Xargc
	dad 	h
	pop 	d
	dad 	d
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
;}
$1:
	inx 	sp
	ret
		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
$0:	.db	#97,#114,#103,#48,#0
	.globl	Xargc
Xargc:
	.dw	#0
	.globl	Xargv
Xargv:
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.globl	Xarglist
	;extrn	isspace

;0 error(s) in compilation
;	literal pool:5
;	global pool:4
;	Macro pool:51
	;	.end
