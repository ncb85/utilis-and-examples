                              1 ; Small C 8080
                              2 ;	Coder (2.4,84/11/27)
                              3 ;	Front End (2.7,84/11/28)
                              4 ;	Front End for ASXXXX (2.8,13/01/20)
                              5 		;program area SMALLC_GENERATED is RELOCATABLE
                              6 		.module SMALLC_GENERATED
                              7 		.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
                              8 		.nlist  (pag)
                              9 		.area  SMALLC_GENERATED  (REL,CON,CSEG)
                             10 ;bdos1(c, de) int c, de; {
   2F51                      11 bdos1:
                             12 ;        /* returns only single byte (top half is 0) */
                             13 ;        return (255 & bdos(c, de));
   2F51 21 FF 00      [10]   14 	lxi 	h,#255
   2F54 E5            [12]   15 	push	h
   2F55 21 06 00      [10]   16 	lxi 	h,#6
   2F58 39            [10]   17 	dad 	sp
   2F59 CD 28 01      [18]   18 	call	ccgint
   2F5C E5            [12]   19 	push	h
   2F5D 21 06 00      [10]   20 	lxi 	h,#6
   2F60 39            [10]   21 	dad 	sp
   2F61 CD 28 01      [18]   22 	call	ccgint
   2F64 E5            [12]   23 	push	h
   2F65 3E 02         [ 7]   24 	mvi 	a,#2
   2F67 CD 29 1E      [18]   25 	call	bdos
   2F6A C1            [10]   26 	pop 	b
   2F6B C1            [10]   27 	pop 	b
   2F6C D1            [10]   28 	pop 	d
   2F6D CD 44 01      [18]   29 	call	ccand
   2F70 C3 73 2F      [10]   30 	jmp 	$1
                             31 ;}
   2F73                      32 $1:
   2F73 C9            [10]   33 	ret
                             34 		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
                             35 	.globl	bdos1
                             36 	;extrn	bdos
                             37 
                             38 ;0 error(s) in compilation
                             39 ;	literal pool:0
                             40 ;	global pool:2
                             41 ;	Macro pool:51
                             42 	;	.end
