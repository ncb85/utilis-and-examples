                              1 ; Small C 8080
                              2 ;	Coder (2.4,84/11/27)
                              3 ;	Front End (2.7,84/11/28)
                              4 ;	Front End for ASXXXX (2.8,13/01/20)
                              5 		;program area SMALLC_GENERATED is RELOCATABLE
                              6 		.module SMALLC_GENERATED
                              7 		.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
                              8 		.nlist  (pag)
                              9 		.area  SMALLC_GENERATED  (REL,CON,CSEG)
                             10 ;exit(retcode) int retcode; {
   2F74                      11 exit:
                             12 ;#asm
   2F74 C3 00 00      [10]   13         jmp     0
                             14 ;}
   2F77                      15 $1:
   2F77 C9            [10]   16 	ret
                             17 		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
                             18 	.globl	exit
                             19 
                             20 ;0 error(s) in compilation
                             21 ;	literal pool:0
                             22 ;	global pool:1
                             23 ;	Macro pool:51
                             24 	;	.end
