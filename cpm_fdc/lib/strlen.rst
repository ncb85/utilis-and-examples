                              1 ; Small C 8080
                              2 ;	Coder (2.4,84/11/27)
                              3 ;	Front End (2.7,84/11/28)
                              4 ;	Front End for ASXXXX (2.8,13/01/20)
                              5 		;program area SMALLC_GENERATED is RELOCATABLE
                              6 		.module SMALLC_GENERATED
                              7 		.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
                              8 		.nlist  (pag)
                              9 		.area  SMALLC_GENERATED  (REL,CON,CSEG)
                             10 ;#include <stdio.h>
                             11 ;#define stdin 0
                             12 ;#define stdout 1
                             13 ;#define stderr 2
                             14 ;#define NULL 0
                             15 ;#define EOF (-1)
                             16 ;#define FILE char
                             17 ;/**
                             18 ; * return length of string, reference CPL p 36
                             19 ; * @param s pointer to string
                             20 ; */
                             21 ;strlen(char *s) {
   3748                      22 strlen:
                             23 ;    int i;
   3748 C5            [12]   24 	push	b
                             25 ;    i = 0;
   3749 21 00 00      [10]   26 	lxi 	h,#0
   374C 39            [10]   27 	dad 	sp
   374D E5            [12]   28 	push	h
   374E 21 00 00      [10]   29 	lxi 	h,#0
   3751 D1            [10]   30 	pop 	d
   3752 CD 30 01      [18]   31 	call	ccpint
                             32 ;    while (*s++) {
   3755                      33 $2:
   3755 21 04 00      [10]   34 	lxi 	h,#4
   3758 39            [10]   35 	dad 	sp
   3759 E5            [12]   36 	push	h
   375A CD 28 01      [18]   37 	call	ccgint
   375D 23            [ 6]   38 	inx 	h
   375E D1            [10]   39 	pop 	d
   375F CD 30 01      [18]   40 	call	ccpint
   3762 2B            [ 6]   41 	dcx 	h
   3763 CD 22 01      [18]   42 	call	ccgchar
   3766 7C            [ 4]   43 	mov 	a,h
   3767 B5            [ 4]   44 	ora 	l
   3768 CA 7C 37      [10]   45 	jz  	$3
                             46 ;        i++;
   376B 21 00 00      [10]   47 	lxi 	h,#0
   376E 39            [10]   48 	dad 	sp
   376F E5            [12]   49 	push	h
   3770 CD 28 01      [18]   50 	call	ccgint
   3773 23            [ 6]   51 	inx 	h
   3774 D1            [10]   52 	pop 	d
   3775 CD 30 01      [18]   53 	call	ccpint
   3778 2B            [ 6]   54 	dcx 	h
                             55 ;    }
   3779 C3 55 37      [10]   56 	jmp 	$2
   377C                      57 $3:
                             58 ;    return i;
   377C 21 00 00      [10]   59 	lxi 	h,#0
   377F 39            [10]   60 	dad 	sp
   3780 CD 28 01      [18]   61 	call	ccgint
   3783 C3 86 37      [10]   62 	jmp 	$1
                             63 ;}
   3786                      64 $1:
   3786 C1            [10]   65 	pop 	b
   3787 C9            [10]   66 	ret
                             67 		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
                             68 	.globl	strlen
                             69 
                             70 ;0 error(s) in compilation
                             71 ;	literal pool:0
                             72 ;	global pool:1
                             73 ;	Macro pool:103
                             74 	;	.end
