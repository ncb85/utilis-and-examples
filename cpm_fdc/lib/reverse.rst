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
                             18 ; * Reverse a character string, reference CPL p 59
                             19 ; * @param s pointer to string
                             20 ; */
                             21 ;reverse(char *s) {
   39F9                      22 reverse:
                             23 ;    int i, j;
   39F9 C5            [12]   24 	push	b
   39FA C5            [12]   25 	push	b
                             26 ;    char c;
   39FB 3B            [ 6]   27 	dcx 	sp
                             28 ;    i = 0;
   39FC 21 03 00      [10]   29 	lxi 	h,#3
   39FF 39            [10]   30 	dad 	sp
   3A00 E5            [12]   31 	push	h
   3A01 21 00 00      [10]   32 	lxi 	h,#0
   3A04 D1            [10]   33 	pop 	d
   3A05 CD 30 01      [18]   34 	call	ccpint
                             35 ;    j = strlen(s) - 1;
   3A08 21 01 00      [10]   36 	lxi 	h,#1
   3A0B 39            [10]   37 	dad 	sp
   3A0C E5            [12]   38 	push	h
   3A0D 21 09 00      [10]   39 	lxi 	h,#9
   3A10 39            [10]   40 	dad 	sp
   3A11 CD 28 01      [18]   41 	call	ccgint
   3A14 E5            [12]   42 	push	h
   3A15 3E 01         [ 7]   43 	mvi 	a,#1
   3A17 CD 48 37      [18]   44 	call	strlen
   3A1A C1            [10]   45 	pop 	b
   3A1B E5            [12]   46 	push	h
   3A1C 21 01 00      [10]   47 	lxi 	h,#1
   3A1F D1            [10]   48 	pop 	d
   3A20 CD CB 01      [18]   49 	call	ccsub
   3A23 D1            [10]   50 	pop 	d
   3A24 CD 30 01      [18]   51 	call	ccpint
                             52 ;    while (i < j) {
   3A27                      53 $2:
   3A27 21 03 00      [10]   54 	lxi 	h,#3
   3A2A 39            [10]   55 	dad 	sp
   3A2B CD 28 01      [18]   56 	call	ccgint
   3A2E E5            [12]   57 	push	h
   3A2F 21 03 00      [10]   58 	lxi 	h,#3
   3A32 39            [10]   59 	dad 	sp
   3A33 CD 28 01      [18]   60 	call	ccgint
   3A36 D1            [10]   61 	pop 	d
   3A37 CD 6B 01      [18]   62 	call	cclt
   3A3A 7C            [ 4]   63 	mov 	a,h
   3A3B B5            [ 4]   64 	ora 	l
   3A3C CA BF 3A      [10]   65 	jz  	$3
                             66 ;        c = s[i];
   3A3F 21 00 00      [10]   67 	lxi 	h,#0
   3A42 39            [10]   68 	dad 	sp
   3A43 E5            [12]   69 	push	h
   3A44 21 09 00      [10]   70 	lxi 	h,#9
   3A47 39            [10]   71 	dad 	sp
   3A48 CD 28 01      [18]   72 	call	ccgint
   3A4B E5            [12]   73 	push	h
   3A4C 21 07 00      [10]   74 	lxi 	h,#7
   3A4F 39            [10]   75 	dad 	sp
   3A50 CD 28 01      [18]   76 	call	ccgint
   3A53 D1            [10]   77 	pop 	d
   3A54 19            [10]   78 	dad 	d
   3A55 CD 22 01      [18]   79 	call	ccgchar
   3A58 D1            [10]   80 	pop 	d
   3A59 7D            [ 4]   81 	mov 	a,l
   3A5A 12            [ 7]   82 	stax	d
                             83 ;        s[i] = s[j];
   3A5B 21 07 00      [10]   84 	lxi 	h,#7
   3A5E 39            [10]   85 	dad 	sp
   3A5F CD 28 01      [18]   86 	call	ccgint
   3A62 E5            [12]   87 	push	h
   3A63 21 05 00      [10]   88 	lxi 	h,#5
   3A66 39            [10]   89 	dad 	sp
   3A67 CD 28 01      [18]   90 	call	ccgint
   3A6A D1            [10]   91 	pop 	d
   3A6B 19            [10]   92 	dad 	d
   3A6C E5            [12]   93 	push	h
   3A6D 21 09 00      [10]   94 	lxi 	h,#9
   3A70 39            [10]   95 	dad 	sp
   3A71 CD 28 01      [18]   96 	call	ccgint
   3A74 E5            [12]   97 	push	h
   3A75 21 05 00      [10]   98 	lxi 	h,#5
   3A78 39            [10]   99 	dad 	sp
   3A79 CD 28 01      [18]  100 	call	ccgint
   3A7C D1            [10]  101 	pop 	d
   3A7D 19            [10]  102 	dad 	d
   3A7E CD 22 01      [18]  103 	call	ccgchar
   3A81 D1            [10]  104 	pop 	d
   3A82 7D            [ 4]  105 	mov 	a,l
   3A83 12            [ 7]  106 	stax	d
                            107 ;        s[j] = c;
   3A84 21 07 00      [10]  108 	lxi 	h,#7
   3A87 39            [10]  109 	dad 	sp
   3A88 CD 28 01      [18]  110 	call	ccgint
   3A8B E5            [12]  111 	push	h
   3A8C 21 03 00      [10]  112 	lxi 	h,#3
   3A8F 39            [10]  113 	dad 	sp
   3A90 CD 28 01      [18]  114 	call	ccgint
   3A93 D1            [10]  115 	pop 	d
   3A94 19            [10]  116 	dad 	d
   3A95 E5            [12]  117 	push	h
   3A96 21 02 00      [10]  118 	lxi 	h,#2
   3A99 39            [10]  119 	dad 	sp
   3A9A CD 22 01      [18]  120 	call	ccgchar
   3A9D D1            [10]  121 	pop 	d
   3A9E 7D            [ 4]  122 	mov 	a,l
   3A9F 12            [ 7]  123 	stax	d
                            124 ;        i++;
   3AA0 21 03 00      [10]  125 	lxi 	h,#3
   3AA3 39            [10]  126 	dad 	sp
   3AA4 E5            [12]  127 	push	h
   3AA5 CD 28 01      [18]  128 	call	ccgint
   3AA8 23            [ 6]  129 	inx 	h
   3AA9 D1            [10]  130 	pop 	d
   3AAA CD 30 01      [18]  131 	call	ccpint
   3AAD 2B            [ 6]  132 	dcx 	h
                            133 ;        j--;
   3AAE 21 01 00      [10]  134 	lxi 	h,#1
   3AB1 39            [10]  135 	dad 	sp
   3AB2 E5            [12]  136 	push	h
   3AB3 CD 28 01      [18]  137 	call	ccgint
   3AB6 2B            [ 6]  138 	dcx 	h
   3AB7 D1            [10]  139 	pop 	d
   3AB8 CD 30 01      [18]  140 	call	ccpint
   3ABB 23            [ 6]  141 	inx 	h
                            142 ;    }
   3ABC C3 27 3A      [10]  143 	jmp 	$2
   3ABF                     144 $3:
                            145 ;    return (s);
   3ABF 21 07 00      [10]  146 	lxi 	h,#7
   3AC2 39            [10]  147 	dad 	sp
   3AC3 CD 28 01      [18]  148 	call	ccgint
   3AC6 C3 C9 3A      [10]  149 	jmp 	$1
                            150 ;}
   3AC9                     151 $1:
   3AC9 33            [ 6]  152 	inx 	sp
   3ACA C1            [10]  153 	pop 	b
   3ACB C1            [10]  154 	pop 	b
   3ACC C9            [10]  155 	ret
                            156 		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
                            157 	.globl	reverse
                            158 	;extrn	strlen
                            159 
                            160 ;0 error(s) in compilation
                            161 ;	literal pool:0
                            162 ;	global pool:2
                            163 ;	Macro pool:103
                            164 	;	.end
