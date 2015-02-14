                              1 ; Small C 8080
                              2 ;	Coder (2.4,84/11/27)
                              3 ;	Front End (2.7,84/11/28)
                              4 ;	Front End for ASXXXX (2.8,13/01/20)
                              5 		;program area SMALLC_GENERATED is RELOCATABLE
                              6 		.module SMALLC_GENERATED
                              7 		.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
                              8 		.nlist  (pag)
                              9 		.area  SMALLC_GENERATED  (REL,CON,CSEG)
                             10 ;bdos (c, de) int c, de; {
   1E29                      11 bdos:
                             12 ;#asm
                             13 ;       CP/M support routine
                             14 ;       bdos(C,DE);
                             15 ;       char *DE; int C;
                             16 ;       returns H=B,L=A per CPM standard
   1E29 E1            [10]   17         pop     h       ; hold return address
   1E2A D1            [10]   18         pop     d       ; get DE register argument
   1E2B C1            [10]   19         pop     b       ; get bdos function number (C reg)
   1E2C D5            [12]   20         push    d
   1E2D C5            [12]   21         push    b
   1E2E E5            [12]   22         push    h
   1E2F CD 05 00      [18]   23         call    5
   1E32 60            [ 4]   24         mov     h,b
   1E33 6F            [ 4]   25         mov     l,a
                             26 ;}
   1E34                      27 $1:
   1E34 C9            [10]   28 	ret
                             29 		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
                             30 	.globl	bdos
                             31 
                             32 ;0 error(s) in compilation
                             33 ;	literal pool:0
                             34 ;	global pool:1
                             35 ;	Macro pool:51
                             36 	;	.end
