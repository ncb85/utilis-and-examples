; Small C 8080
;	Coder (2.4,84/11/27)
;	Front End (2.7,84/11/28)
;	Front End for ASXXXX (2.8,13/01/20)
		;program area SMALLC_GENERATED is RELOCATABLE
		.module SMALLC_GENERATED
		.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
		.nlist  (pag)
		.area  SMALLC_GENERATED  (REL,CON,CSEG)
;exit(retcode) int retcode; {
exit:
;#asm
        jmp     0
;}
$1:
	ret
		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
	.globl	exit

;0 error(s) in compilation
;	literal pool:0
;	global pool:1
;	Macro pool:51
	;	.end
