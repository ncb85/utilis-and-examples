; Small C 8080
;	Coder (2.4,84/11/27)
;	Front End (2.7,84/11/28)
;	Front End for ASXXXX (2.8,13/01/20)
		;program area SMALLC_GENERATED is RELOCATABLE
		.module SMALLC_GENERATED
		.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
		.nlist  (pag)
		.area  SMALLC_GENERATED  (REL,CON,CSEG)
;bdos (c, de) int c, de; {
bdos:
;#asm
;       CP/M support routine
;       bdos(C,DE);
;       char *DE; int C;
;       returns H=B,L=A per CPM standard
        pop     h       ; hold return address
        pop     d       ; get DE register argument
        pop     b       ; get bdos function number (C reg)
        push    d
        push    b
        push    h
        call    5
        mov     h,b
        mov     l,a
;}
$1:
	ret
		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
	.globl	bdos

;0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:51
	;	.end
