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
                             17 ;#define EOL 10
                             18 ;atoi(char s[]) {
   3788                      19 atoi:
                             20 ;    int i, n, sign;
   3788 C5            [12]   21 	push	b
   3789 C5            [12]   22 	push	b
   378A C5            [12]   23 	push	b
                             24 ;    for (i = 0; (s[i] == ' ') | (s[i] == EOL) | (s[i] == '\t'); ++i);
   378B 21 04 00      [10]   25 	lxi 	h,#4
   378E 39            [10]   26 	dad 	sp
   378F E5            [12]   27 	push	h
   3790 21 00 00      [10]   28 	lxi 	h,#0
   3793 D1            [10]   29 	pop 	d
   3794 CD 30 01      [18]   30 	call	ccpint
   3797                      31 $2:
   3797 21 08 00      [10]   32 	lxi 	h,#8
   379A 39            [10]   33 	dad 	sp
   379B CD 28 01      [18]   34 	call	ccgint
   379E E5            [12]   35 	push	h
   379F 21 06 00      [10]   36 	lxi 	h,#6
   37A2 39            [10]   37 	dad 	sp
   37A3 CD 28 01      [18]   38 	call	ccgint
   37A6 D1            [10]   39 	pop 	d
   37A7 19            [10]   40 	dad 	d
   37A8 CD 22 01      [18]   41 	call	ccgchar
   37AB E5            [12]   42 	push	h
   37AC 21 20 00      [10]   43 	lxi 	h,#32
   37AF D1            [10]   44 	pop 	d
   37B0 CD 4B 01      [18]   45 	call	cceq
   37B3 E5            [12]   46 	push	h
   37B4 21 0A 00      [10]   47 	lxi 	h,#10
   37B7 39            [10]   48 	dad 	sp
   37B8 CD 28 01      [18]   49 	call	ccgint
   37BB E5            [12]   50 	push	h
   37BC 21 08 00      [10]   51 	lxi 	h,#8
   37BF 39            [10]   52 	dad 	sp
   37C0 CD 28 01      [18]   53 	call	ccgint
   37C3 D1            [10]   54 	pop 	d
   37C4 19            [10]   55 	dad 	d
   37C5 CD 22 01      [18]   56 	call	ccgchar
   37C8 E5            [12]   57 	push	h
   37C9 21 0A 00      [10]   58 	lxi 	h,#10
   37CC D1            [10]   59 	pop 	d
   37CD CD 4B 01      [18]   60 	call	cceq
   37D0 D1            [10]   61 	pop 	d
   37D1 CD 36 01      [18]   62 	call	ccor
   37D4 E5            [12]   63 	push	h
   37D5 21 0A 00      [10]   64 	lxi 	h,#10
   37D8 39            [10]   65 	dad 	sp
   37D9 CD 28 01      [18]   66 	call	ccgint
   37DC E5            [12]   67 	push	h
   37DD 21 08 00      [10]   68 	lxi 	h,#8
   37E0 39            [10]   69 	dad 	sp
   37E1 CD 28 01      [18]   70 	call	ccgint
   37E4 D1            [10]   71 	pop 	d
   37E5 19            [10]   72 	dad 	d
   37E6 CD 22 01      [18]   73 	call	ccgchar
   37E9 E5            [12]   74 	push	h
   37EA 21 09 00      [10]   75 	lxi 	h,#9
   37ED D1            [10]   76 	pop 	d
   37EE CD 4B 01      [18]   77 	call	cceq
   37F1 D1            [10]   78 	pop 	d
   37F2 CD 36 01      [18]   79 	call	ccor
   37F5 7C            [ 4]   80 	mov 	a,h
   37F6 B5            [ 4]   81 	ora 	l
   37F7 C2 0D 38      [10]   82 	jnz 	$4
   37FA C3 10 38      [10]   83 	jmp 	$5
   37FD                      84 $3:
   37FD 21 04 00      [10]   85 	lxi 	h,#4
   3800 39            [10]   86 	dad 	sp
   3801 E5            [12]   87 	push	h
   3802 CD 28 01      [18]   88 	call	ccgint
   3805 23            [ 6]   89 	inx 	h
   3806 D1            [10]   90 	pop 	d
   3807 CD 30 01      [18]   91 	call	ccpint
   380A C3 97 37      [10]   92 	jmp 	$2
   380D                      93 $4:
   380D C3 FD 37      [10]   94 	jmp 	$3
   3810                      95 $5:
                             96 ;    sign = 1;
   3810 21 00 00      [10]   97 	lxi 	h,#0
   3813 39            [10]   98 	dad 	sp
   3814 E5            [12]   99 	push	h
   3815 21 01 00      [10]  100 	lxi 	h,#1
   3818 D1            [10]  101 	pop 	d
   3819 CD 30 01      [18]  102 	call	ccpint
                            103 ;    switch (s[i]) {
   381C 21 3E 52      [10]  104 	lxi 	h,$6
   381F E5            [12]  105 	push	h
   3820 21 0A 00      [10]  106 	lxi 	h,#10
   3823 39            [10]  107 	dad 	sp
   3824 CD 28 01      [18]  108 	call	ccgint
   3827 E5            [12]  109 	push	h
   3828 21 08 00      [10]  110 	lxi 	h,#8
   382B 39            [10]  111 	dad 	sp
   382C CD 28 01      [18]  112 	call	ccgint
   382F D1            [10]  113 	pop 	d
   3830 19            [10]  114 	dad 	d
   3831 CD 22 01      [18]  115 	call	ccgchar
   3834 C3 6D 02      [10]  116 	jmp 	cccase
                            117 ;        case '-': sign = -1; /* and fall through */
   3837                     118 $8:
   3837 21 00 00      [10]  119 	lxi 	h,#0
   383A 39            [10]  120 	dad 	sp
   383B E5            [12]  121 	push	h
   383C 21 01 00      [10]  122 	lxi 	h,#1
   383F CD D2 01      [18]  123 	call	ccneg
   3842 D1            [10]  124 	pop 	d
   3843 CD 30 01      [18]  125 	call	ccpint
                            126 ;        case '+': ++i;
   3846                     127 $9:
   3846 21 04 00      [10]  128 	lxi 	h,#4
   3849 39            [10]  129 	dad 	sp
   384A E5            [12]  130 	push	h
   384B CD 28 01      [18]  131 	call	ccgint
   384E 23            [ 6]  132 	inx 	h
   384F D1            [10]  133 	pop 	d
   3850 CD 30 01      [18]  134 	call	ccpint
                            135 ;            break;
   3853 C3 59 38      [10]  136 	jmp 	$7
                            137 ;    }
   3856 C3 59 38      [10]  138 	jmp 	$7
                            139 		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
   523E                     140 $6:
   523E 2D 00 37 38 2B 00   141 	.dw	#45,$8,#43,$9
        46 38
   5246 59 38 00 00         142 	.dw	$7,0
                            143 		.area  SMALLC_GENERATED  (REL,CON,CSEG)
   3859                     144 $7:
                            145 ;    for (n = 0; isdigit(s[i]); ++i) {
   3859 21 02 00      [10]  146 	lxi 	h,#2
   385C 39            [10]  147 	dad 	sp
   385D E5            [12]  148 	push	h
   385E 21 00 00      [10]  149 	lxi 	h,#0
   3861 D1            [10]  150 	pop 	d
   3862 CD 30 01      [18]  151 	call	ccpint
   3865                     152 $10:
   3865 21 08 00      [10]  153 	lxi 	h,#8
   3868 39            [10]  154 	dad 	sp
   3869 CD 28 01      [18]  155 	call	ccgint
   386C E5            [12]  156 	push	h
   386D 21 06 00      [10]  157 	lxi 	h,#6
   3870 39            [10]  158 	dad 	sp
   3871 CD 28 01      [18]  159 	call	ccgint
   3874 D1            [10]  160 	pop 	d
   3875 19            [10]  161 	dad 	d
   3876 CD 22 01      [18]  162 	call	ccgchar
   3879 E5            [12]  163 	push	h
   387A 3E 01         [ 7]  164 	mvi 	a,#1
   387C CD 4C 21      [18]  165 	call	isdigit
   387F C1            [10]  166 	pop 	b
   3880 7C            [ 4]  167 	mov 	a,h
   3881 B5            [ 4]  168 	ora 	l
   3882 C2 98 38      [10]  169 	jnz 	$12
   3885 C3 D2 38      [10]  170 	jmp 	$13
   3888                     171 $11:
   3888 21 04 00      [10]  172 	lxi 	h,#4
   388B 39            [10]  173 	dad 	sp
   388C E5            [12]  174 	push	h
   388D CD 28 01      [18]  175 	call	ccgint
   3890 23            [ 6]  176 	inx 	h
   3891 D1            [10]  177 	pop 	d
   3892 CD 30 01      [18]  178 	call	ccpint
   3895 C3 65 38      [10]  179 	jmp 	$10
   3898                     180 $12:
                            181 ;        n = 10 * n + s[i] - '0';
   3898 21 02 00      [10]  182 	lxi 	h,#2
   389B 39            [10]  183 	dad 	sp
   389C E5            [12]  184 	push	h
   389D 21 0A 00      [10]  185 	lxi 	h,#10
   38A0 E5            [12]  186 	push	h
   38A1 21 06 00      [10]  187 	lxi 	h,#6
   38A4 39            [10]  188 	dad 	sp
   38A5 CD 28 01      [18]  189 	call	ccgint
   38A8 D1            [10]  190 	pop 	d
   38A9 CD EF 01      [18]  191 	call	ccmul
   38AC E5            [12]  192 	push	h
   38AD 21 0C 00      [10]  193 	lxi 	h,#12
   38B0 39            [10]  194 	dad 	sp
   38B1 CD 28 01      [18]  195 	call	ccgint
   38B4 E5            [12]  196 	push	h
   38B5 21 0A 00      [10]  197 	lxi 	h,#10
   38B8 39            [10]  198 	dad 	sp
   38B9 CD 28 01      [18]  199 	call	ccgint
   38BC D1            [10]  200 	pop 	d
   38BD 19            [10]  201 	dad 	d
   38BE CD 22 01      [18]  202 	call	ccgchar
   38C1 D1            [10]  203 	pop 	d
   38C2 19            [10]  204 	dad 	d
   38C3 E5            [12]  205 	push	h
   38C4 21 30 00      [10]  206 	lxi 	h,#48
   38C7 D1            [10]  207 	pop 	d
   38C8 CD CB 01      [18]  208 	call	ccsub
   38CB D1            [10]  209 	pop 	d
   38CC CD 30 01      [18]  210 	call	ccpint
                            211 ;    }
   38CF C3 88 38      [10]  212 	jmp 	$11
   38D2                     213 $13:
                            214 ;    return (sign * n);
   38D2 21 00 00      [10]  215 	lxi 	h,#0
   38D5 39            [10]  216 	dad 	sp
   38D6 CD 28 01      [18]  217 	call	ccgint
   38D9 E5            [12]  218 	push	h
   38DA 21 04 00      [10]  219 	lxi 	h,#4
   38DD 39            [10]  220 	dad 	sp
   38DE CD 28 01      [18]  221 	call	ccgint
   38E1 D1            [10]  222 	pop 	d
   38E2 CD EF 01      [18]  223 	call	ccmul
   38E5 C3 E8 38      [10]  224 	jmp 	$1
                            225 ;}
   38E8                     226 $1:
   38E8 C1            [10]  227 	pop 	b
   38E9 C1            [10]  228 	pop 	b
   38EA C1            [10]  229 	pop 	b
   38EB C9            [10]  230 	ret
                            231 ;utoi(char s[]) {
   38EC                     232 utoi:
                            233 ;    unsigned int i, n;
   38EC C5            [12]  234 	push	b
   38ED C5            [12]  235 	push	b
                            236 ;    for (i = 0; (s[i] == ' ') | (s[i] == EOL) | (s[i] == '\t'); ++i);
   38EE 21 02 00      [10]  237 	lxi 	h,#2
   38F1 39            [10]  238 	dad 	sp
   38F2 E5            [12]  239 	push	h
   38F3 21 00 00      [10]  240 	lxi 	h,#0
   38F6 D1            [10]  241 	pop 	d
   38F7 CD 30 01      [18]  242 	call	ccpint
   38FA                     243 $15:
   38FA 21 06 00      [10]  244 	lxi 	h,#6
   38FD 39            [10]  245 	dad 	sp
   38FE CD 28 01      [18]  246 	call	ccgint
   3901 E5            [12]  247 	push	h
   3902 21 04 00      [10]  248 	lxi 	h,#4
   3905 39            [10]  249 	dad 	sp
   3906 CD 28 01      [18]  250 	call	ccgint
   3909 D1            [10]  251 	pop 	d
   390A 19            [10]  252 	dad 	d
   390B CD 22 01      [18]  253 	call	ccgchar
   390E E5            [12]  254 	push	h
   390F 21 20 00      [10]  255 	lxi 	h,#32
   3912 D1            [10]  256 	pop 	d
   3913 CD 4B 01      [18]  257 	call	cceq
   3916 E5            [12]  258 	push	h
   3917 21 08 00      [10]  259 	lxi 	h,#8
   391A 39            [10]  260 	dad 	sp
   391B CD 28 01      [18]  261 	call	ccgint
   391E E5            [12]  262 	push	h
   391F 21 06 00      [10]  263 	lxi 	h,#6
   3922 39            [10]  264 	dad 	sp
   3923 CD 28 01      [18]  265 	call	ccgint
   3926 D1            [10]  266 	pop 	d
   3927 19            [10]  267 	dad 	d
   3928 CD 22 01      [18]  268 	call	ccgchar
   392B E5            [12]  269 	push	h
   392C 21 0A 00      [10]  270 	lxi 	h,#10
   392F D1            [10]  271 	pop 	d
   3930 CD 4B 01      [18]  272 	call	cceq
   3933 D1            [10]  273 	pop 	d
   3934 CD 36 01      [18]  274 	call	ccor
   3937 E5            [12]  275 	push	h
   3938 21 08 00      [10]  276 	lxi 	h,#8
   393B 39            [10]  277 	dad 	sp
   393C CD 28 01      [18]  278 	call	ccgint
   393F E5            [12]  279 	push	h
   3940 21 06 00      [10]  280 	lxi 	h,#6
   3943 39            [10]  281 	dad 	sp
   3944 CD 28 01      [18]  282 	call	ccgint
   3947 D1            [10]  283 	pop 	d
   3948 19            [10]  284 	dad 	d
   3949 CD 22 01      [18]  285 	call	ccgchar
   394C E5            [12]  286 	push	h
   394D 21 09 00      [10]  287 	lxi 	h,#9
   3950 D1            [10]  288 	pop 	d
   3951 CD 4B 01      [18]  289 	call	cceq
   3954 D1            [10]  290 	pop 	d
   3955 CD 36 01      [18]  291 	call	ccor
   3958 7C            [ 4]  292 	mov 	a,h
   3959 B5            [ 4]  293 	ora 	l
   395A C2 70 39      [10]  294 	jnz 	$17
   395D C3 73 39      [10]  295 	jmp 	$18
   3960                     296 $16:
   3960 21 02 00      [10]  297 	lxi 	h,#2
   3963 39            [10]  298 	dad 	sp
   3964 E5            [12]  299 	push	h
   3965 CD 28 01      [18]  300 	call	ccgint
   3968 23            [ 6]  301 	inx 	h
   3969 D1            [10]  302 	pop 	d
   396A CD 30 01      [18]  303 	call	ccpint
   396D C3 FA 38      [10]  304 	jmp 	$15
   3970                     305 $17:
   3970 C3 60 39      [10]  306 	jmp 	$16
   3973                     307 $18:
                            308 ;    for (n = 0; isdigit(s[i]); ++i) {
   3973 21 00 00      [10]  309 	lxi 	h,#0
   3976 39            [10]  310 	dad 	sp
   3977 E5            [12]  311 	push	h
   3978 21 00 00      [10]  312 	lxi 	h,#0
   397B D1            [10]  313 	pop 	d
   397C CD 30 01      [18]  314 	call	ccpint
   397F                     315 $19:
   397F 21 06 00      [10]  316 	lxi 	h,#6
   3982 39            [10]  317 	dad 	sp
   3983 CD 28 01      [18]  318 	call	ccgint
   3986 E5            [12]  319 	push	h
   3987 21 04 00      [10]  320 	lxi 	h,#4
   398A 39            [10]  321 	dad 	sp
   398B CD 28 01      [18]  322 	call	ccgint
   398E D1            [10]  323 	pop 	d
   398F 19            [10]  324 	dad 	d
   3990 CD 22 01      [18]  325 	call	ccgchar
   3993 E5            [12]  326 	push	h
   3994 3E 01         [ 7]  327 	mvi 	a,#1
   3996 CD 4C 21      [18]  328 	call	isdigit
   3999 C1            [10]  329 	pop 	b
   399A 7C            [ 4]  330 	mov 	a,h
   399B B5            [ 4]  331 	ora 	l
   399C C2 B2 39      [10]  332 	jnz 	$21
   399F C3 EC 39      [10]  333 	jmp 	$22
   39A2                     334 $20:
   39A2 21 02 00      [10]  335 	lxi 	h,#2
   39A5 39            [10]  336 	dad 	sp
   39A6 E5            [12]  337 	push	h
   39A7 CD 28 01      [18]  338 	call	ccgint
   39AA 23            [ 6]  339 	inx 	h
   39AB D1            [10]  340 	pop 	d
   39AC CD 30 01      [18]  341 	call	ccpint
   39AF C3 7F 39      [10]  342 	jmp 	$19
   39B2                     343 $21:
                            344 ;        n = 10 * n + s[i] - '0';
   39B2 21 00 00      [10]  345 	lxi 	h,#0
   39B5 39            [10]  346 	dad 	sp
   39B6 E5            [12]  347 	push	h
   39B7 21 0A 00      [10]  348 	lxi 	h,#10
   39BA E5            [12]  349 	push	h
   39BB 21 04 00      [10]  350 	lxi 	h,#4
   39BE 39            [10]  351 	dad 	sp
   39BF CD 28 01      [18]  352 	call	ccgint
   39C2 D1            [10]  353 	pop 	d
   39C3 CD EF 01      [18]  354 	call	ccmul
   39C6 E5            [12]  355 	push	h
   39C7 21 0A 00      [10]  356 	lxi 	h,#10
   39CA 39            [10]  357 	dad 	sp
   39CB CD 28 01      [18]  358 	call	ccgint
   39CE E5            [12]  359 	push	h
   39CF 21 08 00      [10]  360 	lxi 	h,#8
   39D2 39            [10]  361 	dad 	sp
   39D3 CD 28 01      [18]  362 	call	ccgint
   39D6 D1            [10]  363 	pop 	d
   39D7 19            [10]  364 	dad 	d
   39D8 CD 22 01      [18]  365 	call	ccgchar
   39DB D1            [10]  366 	pop 	d
   39DC 19            [10]  367 	dad 	d
   39DD E5            [12]  368 	push	h
   39DE 21 30 00      [10]  369 	lxi 	h,#48
   39E1 D1            [10]  370 	pop 	d
   39E2 CD CB 01      [18]  371 	call	ccsub
   39E5 D1            [10]  372 	pop 	d
   39E6 CD 30 01      [18]  373 	call	ccpint
                            374 ;    }
   39E9 C3 A2 39      [10]  375 	jmp 	$20
   39EC                     376 $22:
                            377 ;    return (n);
   39EC 21 00 00      [10]  378 	lxi 	h,#0
   39EF 39            [10]  379 	dad 	sp
   39F0 CD 28 01      [18]  380 	call	ccgint
   39F3 C3 F6 39      [10]  381 	jmp 	$14
                            382 ;}
   39F6                     383 $14:
   39F6 C1            [10]  384 	pop 	b
   39F7 C1            [10]  385 	pop 	b
   39F8 C9            [10]  386 	ret
                            387 		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
                            388 	.globl	atoi
                            389 	;extrn	isdigit
                            390 	.globl	utoi
                            391 
                            392 ;0 error(s) in compilation
                            393 ;	literal pool:0
                            394 ;	global pool:3
                            395 ;	Macro pool:110
                            396 	;	.end
