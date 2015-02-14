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
                             17 ;#define EOS 0
                             18 ;/**
                             19 ; * integer to ascii representation
                             20 ; * @param n the integer number
                             21 ; * @param s string buffer
                             22 ; * @return 
                             23 ; */
                             24 ;itoa(int n, char s[]) {
   3551                      25 itoa:
                             26 ;    int i, sign;
   3551 C5            [12]   27 	push	b
   3552 C5            [12]   28 	push	b
                             29 ;    if ((sign = n) < 0) {
   3553 21 00 00      [10]   30 	lxi 	h,#0
   3556 39            [10]   31 	dad 	sp
   3557 E5            [12]   32 	push	h
   3558 21 0A 00      [10]   33 	lxi 	h,#10
   355B 39            [10]   34 	dad 	sp
   355C CD 28 01      [18]   35 	call	ccgint
   355F D1            [10]   36 	pop 	d
   3560 CD 30 01      [18]   37 	call	ccpint
   3563 E5            [12]   38 	push	h
   3564 21 00 00      [10]   39 	lxi 	h,#0
   3567 D1            [10]   40 	pop 	d
   3568 CD 6B 01      [18]   41 	call	cclt
   356B 7C            [ 4]   42 	mov 	a,h
   356C B5            [ 4]   43 	ora 	l
   356D CA 83 35      [10]   44 	jz  	$2
                             45 ;        n = -n;
   3570 21 08 00      [10]   46 	lxi 	h,#8
   3573 39            [10]   47 	dad 	sp
   3574 E5            [12]   48 	push	h
   3575 21 0A 00      [10]   49 	lxi 	h,#10
   3578 39            [10]   50 	dad 	sp
   3579 CD 28 01      [18]   51 	call	ccgint
   357C CD D2 01      [18]   52 	call	ccneg
   357F D1            [10]   53 	pop 	d
   3580 CD 30 01      [18]   54 	call	ccpint
                             55 ;    }
                             56 ;    i = 0;
   3583                      57 $2:
   3583 21 02 00      [10]   58 	lxi 	h,#2
   3586 39            [10]   59 	dad 	sp
   3587 E5            [12]   60 	push	h
   3588 21 00 00      [10]   61 	lxi 	h,#0
   358B D1            [10]   62 	pop 	d
   358C CD 30 01      [18]   63 	call	ccpint
                             64 ;    do {
   358F                      65 $3:
                             66 ;        s[i++] = n % 10 + '0';
   358F 21 06 00      [10]   67 	lxi 	h,#6
   3592 39            [10]   68 	dad 	sp
   3593 CD 28 01      [18]   69 	call	ccgint
   3596 E5            [12]   70 	push	h
   3597 21 04 00      [10]   71 	lxi 	h,#4
   359A 39            [10]   72 	dad 	sp
   359B E5            [12]   73 	push	h
   359C CD 28 01      [18]   74 	call	ccgint
   359F 23            [ 6]   75 	inx 	h
   35A0 D1            [10]   76 	pop 	d
   35A1 CD 30 01      [18]   77 	call	ccpint
   35A4 2B            [ 6]   78 	dcx 	h
   35A5 D1            [10]   79 	pop 	d
   35A6 19            [10]   80 	dad 	d
   35A7 E5            [12]   81 	push	h
   35A8 21 0A 00      [10]   82 	lxi 	h,#10
   35AB 39            [10]   83 	dad 	sp
   35AC CD 28 01      [18]   84 	call	ccgint
   35AF E5            [12]   85 	push	h
   35B0 21 0A 00      [10]   86 	lxi 	h,#10
   35B3 D1            [10]   87 	pop 	d
   35B4 CD 0F 02      [18]   88 	call	ccdiv
   35B7 EB            [ 4]   89 	xchg
   35B8 E5            [12]   90 	push	h
   35B9 21 30 00      [10]   91 	lxi 	h,#48
   35BC D1            [10]   92 	pop 	d
   35BD 19            [10]   93 	dad 	d
   35BE D1            [10]   94 	pop 	d
   35BF 7D            [ 4]   95 	mov 	a,l
   35C0 12            [ 7]   96 	stax	d
                             97 ;    } while ((n = n / 10) > 0);
   35C1                      98 $4:
   35C1 21 08 00      [10]   99 	lxi 	h,#8
   35C4 39            [10]  100 	dad 	sp
   35C5 E5            [12]  101 	push	h
   35C6 21 0A 00      [10]  102 	lxi 	h,#10
   35C9 39            [10]  103 	dad 	sp
   35CA CD 28 01      [18]  104 	call	ccgint
   35CD E5            [12]  105 	push	h
   35CE 21 0A 00      [10]  106 	lxi 	h,#10
   35D1 D1            [10]  107 	pop 	d
   35D2 CD 0F 02      [18]  108 	call	ccdiv
   35D5 D1            [10]  109 	pop 	d
   35D6 CD 30 01      [18]  110 	call	ccpint
   35D9 E5            [12]  111 	push	h
   35DA 21 00 00      [10]  112 	lxi 	h,#0
   35DD D1            [10]  113 	pop 	d
   35DE CD 57 01      [18]  114 	call	ccgt
   35E1 7C            [ 4]  115 	mov 	a,h
   35E2 B5            [ 4]  116 	ora 	l
   35E3 C2 8F 35      [10]  117 	jnz 	$3
   35E6                     118 $5:
                            119 ;    if (sign < 0) {
   35E6 21 00 00      [10]  120 	lxi 	h,#0
   35E9 39            [10]  121 	dad 	sp
   35EA CD 28 01      [18]  122 	call	ccgint
   35ED E5            [12]  123 	push	h
   35EE 21 00 00      [10]  124 	lxi 	h,#0
   35F1 D1            [10]  125 	pop 	d
   35F2 CD 6B 01      [18]  126 	call	cclt
   35F5 7C            [ 4]  127 	mov 	a,h
   35F6 B5            [ 4]  128 	ora 	l
   35F7 CA 19 36      [10]  129 	jz  	$6
                            130 ;        s[i++] = '-';
   35FA 21 06 00      [10]  131 	lxi 	h,#6
   35FD 39            [10]  132 	dad 	sp
   35FE CD 28 01      [18]  133 	call	ccgint
   3601 E5            [12]  134 	push	h
   3602 21 04 00      [10]  135 	lxi 	h,#4
   3605 39            [10]  136 	dad 	sp
   3606 E5            [12]  137 	push	h
   3607 CD 28 01      [18]  138 	call	ccgint
   360A 23            [ 6]  139 	inx 	h
   360B D1            [10]  140 	pop 	d
   360C CD 30 01      [18]  141 	call	ccpint
   360F 2B            [ 6]  142 	dcx 	h
   3610 D1            [10]  143 	pop 	d
   3611 19            [10]  144 	dad 	d
   3612 E5            [12]  145 	push	h
   3613 21 2D 00      [10]  146 	lxi 	h,#45
   3616 D1            [10]  147 	pop 	d
   3617 7D            [ 4]  148 	mov 	a,l
   3618 12            [ 7]  149 	stax	d
                            150 ;    }
                            151 ;    s[i] = EOS;
   3619                     152 $6:
   3619 21 06 00      [10]  153 	lxi 	h,#6
   361C 39            [10]  154 	dad 	sp
   361D CD 28 01      [18]  155 	call	ccgint
   3620 E5            [12]  156 	push	h
   3621 21 04 00      [10]  157 	lxi 	h,#4
   3624 39            [10]  158 	dad 	sp
   3625 CD 28 01      [18]  159 	call	ccgint
   3628 D1            [10]  160 	pop 	d
   3629 19            [10]  161 	dad 	d
   362A E5            [12]  162 	push	h
   362B 21 00 00      [10]  163 	lxi 	h,#0
   362E D1            [10]  164 	pop 	d
   362F 7D            [ 4]  165 	mov 	a,l
   3630 12            [ 7]  166 	stax	d
                            167 ;    reverse(s);
   3631 21 06 00      [10]  168 	lxi 	h,#6
   3634 39            [10]  169 	dad 	sp
   3635 CD 28 01      [18]  170 	call	ccgint
   3638 E5            [12]  171 	push	h
   3639 3E 01         [ 7]  172 	mvi 	a,#1
   363B CD F9 39      [18]  173 	call	reverse
   363E C1            [10]  174 	pop 	b
                            175 ;}
   363F                     176 $1:
   363F C1            [10]  177 	pop 	b
   3640 C1            [10]  178 	pop 	b
   3641 C9            [10]  179 	ret
                            180 ;/**
                            181 ; * unsigned integer to ASCII
                            182 ; * @param n the unsigned number
                            183 ; * @param s string buffer
                            184 ; * @param base
                            185 ; * @return 
                            186 ; */
                            187 ;utoab(unsigned int n, char s[], int base) {
   3642                     188 utoab:
                            189 ;    int i, offset;
   3642 C5            [12]  190 	push	b
   3643 C5            [12]  191 	push	b
                            192 ;    i = 0;
   3644 21 02 00      [10]  193 	lxi 	h,#2
   3647 39            [10]  194 	dad 	sp
   3648 E5            [12]  195 	push	h
   3649 21 00 00      [10]  196 	lxi 	h,#0
   364C D1            [10]  197 	pop 	d
   364D CD 30 01      [18]  198 	call	ccpint
                            199 ;    do {
   3650                     200 $8:
                            201 ;        s[i] = n % base;
   3650 21 08 00      [10]  202 	lxi 	h,#8
   3653 39            [10]  203 	dad 	sp
   3654 CD 28 01      [18]  204 	call	ccgint
   3657 E5            [12]  205 	push	h
   3658 21 04 00      [10]  206 	lxi 	h,#4
   365B 39            [10]  207 	dad 	sp
   365C CD 28 01      [18]  208 	call	ccgint
   365F D1            [10]  209 	pop 	d
   3660 19            [10]  210 	dad 	d
   3661 E5            [12]  211 	push	h
   3662 21 0C 00      [10]  212 	lxi 	h,#12
   3665 39            [10]  213 	dad 	sp
   3666 CD 28 01      [18]  214 	call	ccgint
   3669 E5            [12]  215 	push	h
   366A 21 0A 00      [10]  216 	lxi 	h,#10
   366D 39            [10]  217 	dad 	sp
   366E CD 28 01      [18]  218 	call	ccgint
   3671 D1            [10]  219 	pop 	d
   3672 CD A2 02      [18]  220 	call	ccudiv
   3675 EB            [ 4]  221 	xchg
   3676 D1            [10]  222 	pop 	d
   3677 7D            [ 4]  223 	mov 	a,l
   3678 12            [ 7]  224 	stax	d
                            225 ;        if (s[i] < 10 ) {
   3679 21 08 00      [10]  226 	lxi 	h,#8
   367C 39            [10]  227 	dad 	sp
   367D CD 28 01      [18]  228 	call	ccgint
   3680 E5            [12]  229 	push	h
   3681 21 04 00      [10]  230 	lxi 	h,#4
   3684 39            [10]  231 	dad 	sp
   3685 CD 28 01      [18]  232 	call	ccgint
   3688 D1            [10]  233 	pop 	d
   3689 19            [10]  234 	dad 	d
   368A CD 22 01      [18]  235 	call	ccgchar
   368D E5            [12]  236 	push	h
   368E 21 0A 00      [10]  237 	lxi 	h,#10
   3691 D1            [10]  238 	pop 	d
   3692 CD 6B 01      [18]  239 	call	cclt
   3695 7C            [ 4]  240 	mov 	a,h
   3696 B5            [ 4]  241 	ora 	l
   3697 CA A9 36      [10]  242 	jz  	$11
                            243 ;            offset = '0';
   369A 21 00 00      [10]  244 	lxi 	h,#0
   369D 39            [10]  245 	dad 	sp
   369E E5            [12]  246 	push	h
   369F 21 30 00      [10]  247 	lxi 	h,#48
   36A2 D1            [10]  248 	pop 	d
   36A3 CD 30 01      [18]  249 	call	ccpint
                            250 ;        } else {
   36A6 C3 B5 36      [10]  251 	jmp 	$12
   36A9                     252 $11:
                            253 ;            offset = 55; // 'A' - 10
   36A9 21 00 00      [10]  254 	lxi 	h,#0
   36AC 39            [10]  255 	dad 	sp
   36AD E5            [12]  256 	push	h
   36AE 21 37 00      [10]  257 	lxi 	h,#55
   36B1 D1            [10]  258 	pop 	d
   36B2 CD 30 01      [18]  259 	call	ccpint
                            260 ;        }
   36B5                     261 $12:
                            262 ;        s[i] = s[i] + offset;
   36B5 21 08 00      [10]  263 	lxi 	h,#8
   36B8 39            [10]  264 	dad 	sp
   36B9 CD 28 01      [18]  265 	call	ccgint
   36BC E5            [12]  266 	push	h
   36BD 21 04 00      [10]  267 	lxi 	h,#4
   36C0 39            [10]  268 	dad 	sp
   36C1 CD 28 01      [18]  269 	call	ccgint
   36C4 D1            [10]  270 	pop 	d
   36C5 19            [10]  271 	dad 	d
   36C6 E5            [12]  272 	push	h
   36C7 21 0A 00      [10]  273 	lxi 	h,#10
   36CA 39            [10]  274 	dad 	sp
   36CB CD 28 01      [18]  275 	call	ccgint
   36CE E5            [12]  276 	push	h
   36CF 21 06 00      [10]  277 	lxi 	h,#6
   36D2 39            [10]  278 	dad 	sp
   36D3 CD 28 01      [18]  279 	call	ccgint
   36D6 D1            [10]  280 	pop 	d
   36D7 19            [10]  281 	dad 	d
   36D8 CD 22 01      [18]  282 	call	ccgchar
   36DB E5            [12]  283 	push	h
   36DC 21 04 00      [10]  284 	lxi 	h,#4
   36DF 39            [10]  285 	dad 	sp
   36E0 CD 28 01      [18]  286 	call	ccgint
   36E3 D1            [10]  287 	pop 	d
   36E4 19            [10]  288 	dad 	d
   36E5 D1            [10]  289 	pop 	d
   36E6 7D            [ 4]  290 	mov 	a,l
   36E7 12            [ 7]  291 	stax	d
                            292 ;        i++;
   36E8 21 02 00      [10]  293 	lxi 	h,#2
   36EB 39            [10]  294 	dad 	sp
   36EC E5            [12]  295 	push	h
   36ED CD 28 01      [18]  296 	call	ccgint
   36F0 23            [ 6]  297 	inx 	h
   36F1 D1            [10]  298 	pop 	d
   36F2 CD 30 01      [18]  299 	call	ccpint
   36F5 2B            [ 6]  300 	dcx 	h
                            301 ;    } while ((n = n / base) > 0);
   36F6                     302 $9:
   36F6 21 0A 00      [10]  303 	lxi 	h,#10
   36F9 39            [10]  304 	dad 	sp
   36FA E5            [12]  305 	push	h
   36FB 21 0C 00      [10]  306 	lxi 	h,#12
   36FE 39            [10]  307 	dad 	sp
   36FF CD 28 01      [18]  308 	call	ccgint
   3702 E5            [12]  309 	push	h
   3703 21 0A 00      [10]  310 	lxi 	h,#10
   3706 39            [10]  311 	dad 	sp
   3707 CD 28 01      [18]  312 	call	ccgint
   370A D1            [10]  313 	pop 	d
   370B CD A2 02      [18]  314 	call	ccudiv
   370E D1            [10]  315 	pop 	d
   370F CD 30 01      [18]  316 	call	ccpint
   3712 E5            [12]  317 	push	h
   3713 21 00 00      [10]  318 	lxi 	h,#0
   3716 D1            [10]  319 	pop 	d
   3717 CD 7D 01      [18]  320 	call	ccugt
   371A 7C            [ 4]  321 	mov 	a,h
   371B B5            [ 4]  322 	ora 	l
   371C C2 50 36      [10]  323 	jnz 	$8
   371F                     324 $10:
                            325 ;    
                            326 ;    s[i] = EOS;
   371F 21 08 00      [10]  327 	lxi 	h,#8
   3722 39            [10]  328 	dad 	sp
   3723 CD 28 01      [18]  329 	call	ccgint
   3726 E5            [12]  330 	push	h
   3727 21 04 00      [10]  331 	lxi 	h,#4
   372A 39            [10]  332 	dad 	sp
   372B CD 28 01      [18]  333 	call	ccgint
   372E D1            [10]  334 	pop 	d
   372F 19            [10]  335 	dad 	d
   3730 E5            [12]  336 	push	h
   3731 21 00 00      [10]  337 	lxi 	h,#0
   3734 D1            [10]  338 	pop 	d
   3735 7D            [ 4]  339 	mov 	a,l
   3736 12            [ 7]  340 	stax	d
                            341 ;    reverse(s);
   3737 21 08 00      [10]  342 	lxi 	h,#8
   373A 39            [10]  343 	dad 	sp
   373B CD 28 01      [18]  344 	call	ccgint
   373E E5            [12]  345 	push	h
   373F 3E 01         [ 7]  346 	mvi 	a,#1
   3741 CD F9 39      [18]  347 	call	reverse
   3744 C1            [10]  348 	pop 	b
                            349 ;}
   3745                     350 $7:
   3745 C1            [10]  351 	pop 	b
   3746 C1            [10]  352 	pop 	b
   3747 C9            [10]  353 	ret
                            354 		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
                            355 	.globl	itoa
                            356 	;extrn	reverse
                            357 	.globl	utoab
                            358 
                            359 ;0 error(s) in compilation
                            360 ;	literal pool:0
                            361 ;	global pool:3
                            362 ;	Macro pool:109
                            363 	;	.end
