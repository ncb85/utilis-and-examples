                              1 ; Small C 8080
                              2 ;	Coder (2.4,84/11/27)
                              3 ;	Front End (2.7,84/11/28)
                              4 ;	Front End for ASXXXX (2.8,13/01/20)
                              5 		;program area SMALLC_GENERATED is RELOCATABLE
                              6 		.module SMALLC_GENERATED
                              7 		.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
                              8 		.nlist  (pag)
                              9 		.area  SMALLC_GENERATED  (REL,CON,CSEG)
                             10 ;/*
                             11 ; * Main interface to scanf-type routines, independent of integer/float
                             12 ; *
                             13 ; * scanf(controlstring, arg, arg, ...)  or 
                             14 ; * sscanf(string, controlstring, arg, arg, ...) or
                             15 ; * fscanf(file, controlstring, arg, arg, ...) --  formatted read
                             16 ; *        operates as described by Kernighan & Ritchie
                             17 ; */
                             18 ;#include <stdio.h>
                             19 ;#define stdin 0
                             20 ;#define stdout 1
                             21 ;#define stderr 2
                             22 ;#define NULL 0
                             23 ;#define EOF (-1)
                             24 ;#define FILE char
                             25 ;//#include <ctype.h>
                             26 ;#define ERR (-1)
                             27 ;extern int ccargc;
                             28 ;char *_String1;
                             29 ;int _Oldch;
                             30 ;scanf(args)
   3ACD                      31 scanf:
                             32 ;int args;
                             33 ;{
                             34 ;    #asm
   3ACD 32 38 52      [13]   35         sta ccargc
   3AD0 AF            [ 4]   36         xra a
   3AD1 32 39 52      [13]   37         sta ccargc + 1
                             38 ;    _String1 = NULL;
   3AD4 21 00 00      [10]   39 	lxi 	h,#0
   3AD7 22 4A 52      [16]   40 	shld	_String1
                             41 ;    return ( _scanf(stdin, ccargc + &args - 1));
   3ADA 21 00 00      [10]   42 	lxi 	h,#0
   3ADD E5            [12]   43 	push	h
   3ADE 2A 38 52      [16]   44 	lhld	ccargc
   3AE1 E5            [12]   45 	push	h
   3AE2 21 06 00      [10]   46 	lxi 	h,#6
   3AE5 39            [10]   47 	dad 	sp
   3AE6 D1            [10]   48 	pop 	d
   3AE7 EB            [ 4]   49 	xchg
   3AE8 29            [10]   50 	dad 	h
   3AE9 EB            [ 4]   51 	xchg
   3AEA 19            [10]   52 	dad 	d
   3AEB E5            [12]   53 	push	h
   3AEC 21 01 00      [10]   54 	lxi 	h,#1
   3AEF 29            [10]   55 	dad 	h
   3AF0 D1            [10]   56 	pop 	d
   3AF1 CD CB 01      [18]   57 	call	ccsub
   3AF4 E5            [12]   58 	push	h
   3AF5 3E 02         [ 7]   59 	mvi 	a,#2
   3AF7 CD 41 3C      [18]   60 	call	_scanf
   3AFA C1            [10]   61 	pop 	b
   3AFB C1            [10]   62 	pop 	b
   3AFC C3 FF 3A      [10]   63 	jmp 	$1
                             64 ;}
   3AFF                      65 $1:
   3AFF C9            [10]   66 	ret
                             67 ;fscanf(args)
   3B00                      68 fscanf:
                             69 ;int args;
                             70 ;{
                             71 ;    int *nxtarg;
   3B00 C5            [12]   72 	push	b
                             73 ;    #asm
   3B01 32 38 52      [13]   74         sta ccargc
   3B04 AF            [ 4]   75         xra a
   3B05 32 39 52      [13]   76         sta ccargc + 1
                             77 ;    _String1 = NULL;
   3B08 21 00 00      [10]   78 	lxi 	h,#0
   3B0B 22 4A 52      [16]   79 	shld	_String1
                             80 ;    nxtarg = ccargc + &args;
   3B0E 21 00 00      [10]   81 	lxi 	h,#0
   3B11 39            [10]   82 	dad 	sp
   3B12 E5            [12]   83 	push	h
   3B13 2A 38 52      [16]   84 	lhld	ccargc
   3B16 E5            [12]   85 	push	h
   3B17 21 08 00      [10]   86 	lxi 	h,#8
   3B1A 39            [10]   87 	dad 	sp
   3B1B D1            [10]   88 	pop 	d
   3B1C EB            [ 4]   89 	xchg
   3B1D 29            [10]   90 	dad 	h
   3B1E EB            [ 4]   91 	xchg
   3B1F 19            [10]   92 	dad 	d
   3B20 D1            [10]   93 	pop 	d
   3B21 CD 30 01      [18]   94 	call	ccpint
                             95 ;    return ( _scanf(*(--nxtarg), --nxtarg));
   3B24 21 00 00      [10]   96 	lxi 	h,#0
   3B27 39            [10]   97 	dad 	sp
   3B28 E5            [12]   98 	push	h
   3B29 CD 28 01      [18]   99 	call	ccgint
   3B2C 2B            [ 6]  100 	dcx 	h
   3B2D 2B            [ 6]  101 	dcx 	h
   3B2E D1            [10]  102 	pop 	d
   3B2F CD 30 01      [18]  103 	call	ccpint
   3B32 CD 28 01      [18]  104 	call	ccgint
   3B35 E5            [12]  105 	push	h
   3B36 21 02 00      [10]  106 	lxi 	h,#2
   3B39 39            [10]  107 	dad 	sp
   3B3A E5            [12]  108 	push	h
   3B3B CD 28 01      [18]  109 	call	ccgint
   3B3E 2B            [ 6]  110 	dcx 	h
   3B3F 2B            [ 6]  111 	dcx 	h
   3B40 D1            [10]  112 	pop 	d
   3B41 CD 30 01      [18]  113 	call	ccpint
   3B44 E5            [12]  114 	push	h
   3B45 3E 02         [ 7]  115 	mvi 	a,#2
   3B47 CD 41 3C      [18]  116 	call	_scanf
   3B4A C1            [10]  117 	pop 	b
   3B4B C1            [10]  118 	pop 	b
   3B4C C3 4F 3B      [10]  119 	jmp 	$2
                            120 ;}
   3B4F                     121 $2:
   3B4F C1            [10]  122 	pop 	b
   3B50 C9            [10]  123 	ret
                            124 ;sscanf(args)
   3B51                     125 sscanf:
                            126 ;int args;
                            127 ;{
                            128 ;    int *nxtarg;
   3B51 C5            [12]  129 	push	b
                            130 ;    #asm
   3B52 32 38 52      [13]  131         sta ccargc
   3B55 AF            [ 4]  132         xra a
   3B56 32 39 52      [13]  133         sta ccargc + 1
                            134 ;    nxtarg = ccargc + &args - 1;
   3B59 21 00 00      [10]  135 	lxi 	h,#0
   3B5C 39            [10]  136 	dad 	sp
   3B5D E5            [12]  137 	push	h
   3B5E 2A 38 52      [16]  138 	lhld	ccargc
   3B61 E5            [12]  139 	push	h
   3B62 21 08 00      [10]  140 	lxi 	h,#8
   3B65 39            [10]  141 	dad 	sp
   3B66 D1            [10]  142 	pop 	d
   3B67 EB            [ 4]  143 	xchg
   3B68 29            [10]  144 	dad 	h
   3B69 EB            [ 4]  145 	xchg
   3B6A 19            [10]  146 	dad 	d
   3B6B E5            [12]  147 	push	h
   3B6C 21 01 00      [10]  148 	lxi 	h,#1
   3B6F 29            [10]  149 	dad 	h
   3B70 D1            [10]  150 	pop 	d
   3B71 CD CB 01      [18]  151 	call	ccsub
   3B74 D1            [10]  152 	pop 	d
   3B75 CD 30 01      [18]  153 	call	ccpint
                            154 ;    _String1 = *nxtarg;
   3B78 21 00 00      [10]  155 	lxi 	h,#0
   3B7B 39            [10]  156 	dad 	sp
   3B7C CD 28 01      [18]  157 	call	ccgint
   3B7F CD 28 01      [18]  158 	call	ccgint
   3B82 22 4A 52      [16]  159 	shld	_String1
                            160 ;    return ( _scanf(stdout, --nxtarg));
   3B85 21 01 00      [10]  161 	lxi 	h,#1
   3B88 E5            [12]  162 	push	h
   3B89 21 02 00      [10]  163 	lxi 	h,#2
   3B8C 39            [10]  164 	dad 	sp
   3B8D E5            [12]  165 	push	h
   3B8E CD 28 01      [18]  166 	call	ccgint
   3B91 2B            [ 6]  167 	dcx 	h
   3B92 2B            [ 6]  168 	dcx 	h
   3B93 D1            [10]  169 	pop 	d
   3B94 CD 30 01      [18]  170 	call	ccpint
   3B97 E5            [12]  171 	push	h
   3B98 3E 02         [ 7]  172 	mvi 	a,#2
   3B9A CD 41 3C      [18]  173 	call	_scanf
   3B9D C1            [10]  174 	pop 	b
   3B9E C1            [10]  175 	pop 	b
   3B9F C3 A2 3B      [10]  176 	jmp 	$3
                            177 ;}
   3BA2                     178 $3:
   3BA2 C1            [10]  179 	pop 	b
   3BA3 C9            [10]  180 	ret
                            181 ;/*
                            182 ; * _getc - fetch a single character from file
                            183 ; *         if _String1 is not null fetch from a string instead
                            184 ; */
                            185 ;_getc(fd)
   3BA4                     186 _getc:
                            187 ;int fd;
                            188 ;{
                            189 ;    int c;
   3BA4 C5            [12]  190 	push	b
                            191 ;    if (_Oldch != EOF) {
   3BA5 2A 4C 52      [16]  192 	lhld	_Oldch
   3BA8 E5            [12]  193 	push	h
   3BA9 21 01 00      [10]  194 	lxi 	h,#1
   3BAC CD D2 01      [18]  195 	call	ccneg
   3BAF D1            [10]  196 	pop 	d
   3BB0 CD 51 01      [18]  197 	call	ccne
   3BB3 7C            [ 4]  198 	mov 	a,h
   3BB4 B5            [ 4]  199 	ora 	l
   3BB5 CA DA 3B      [10]  200 	jz  	$5
                            201 ;        c = _Oldch;
   3BB8 21 00 00      [10]  202 	lxi 	h,#0
   3BBB 39            [10]  203 	dad 	sp
   3BBC E5            [12]  204 	push	h
   3BBD 2A 4C 52      [16]  205 	lhld	_Oldch
   3BC0 D1            [10]  206 	pop 	d
   3BC1 CD 30 01      [18]  207 	call	ccpint
                            208 ;        _Oldch = EOF;
   3BC4 21 01 00      [10]  209 	lxi 	h,#1
   3BC7 CD D2 01      [18]  210 	call	ccneg
   3BCA 22 4C 52      [16]  211 	shld	_Oldch
                            212 ;        return c;
   3BCD 21 00 00      [10]  213 	lxi 	h,#0
   3BD0 39            [10]  214 	dad 	sp
   3BD1 CD 28 01      [18]  215 	call	ccgint
   3BD4 C3 34 3C      [10]  216 	jmp 	$4
                            217 ;    } else {
   3BD7 C3 34 3C      [10]  218 	jmp 	$6
   3BDA                     219 $5:
                            220 ;        if (_String1 != NULL) {
   3BDA 2A 4A 52      [16]  221 	lhld	_String1
   3BDD E5            [12]  222 	push	h
   3BDE 21 00 00      [10]  223 	lxi 	h,#0
   3BE1 D1            [10]  224 	pop 	d
   3BE2 CD 51 01      [18]  225 	call	ccne
   3BE5 7C            [ 4]  226 	mov 	a,h
   3BE6 B5            [ 4]  227 	ora 	l
   3BE7 CA 23 3C      [10]  228 	jz  	$7
                            229 ;            if ((c = *_String1++)) return c;
   3BEA 21 00 00      [10]  230 	lxi 	h,#0
   3BED 39            [10]  231 	dad 	sp
   3BEE E5            [12]  232 	push	h
   3BEF 2A 4A 52      [16]  233 	lhld	_String1
   3BF2 23            [ 6]  234 	inx 	h
   3BF3 22 4A 52      [16]  235 	shld	_String1
   3BF6 2B            [ 6]  236 	dcx 	h
   3BF7 CD 22 01      [18]  237 	call	ccgchar
   3BFA D1            [10]  238 	pop 	d
   3BFB CD 30 01      [18]  239 	call	ccpint
   3BFE 7C            [ 4]  240 	mov 	a,h
   3BFF B5            [ 4]  241 	ora 	l
   3C00 CA 10 3C      [10]  242 	jz  	$8
   3C03 21 00 00      [10]  243 	lxi 	h,#0
   3C06 39            [10]  244 	dad 	sp
   3C07 CD 28 01      [18]  245 	call	ccgint
   3C0A C3 34 3C      [10]  246 	jmp 	$4
                            247 ;            else {
   3C0D C3 20 3C      [10]  248 	jmp 	$9
   3C10                     249 $8:
                            250 ;                --_String1;
   3C10 2A 4A 52      [16]  251 	lhld	_String1
   3C13 2B            [ 6]  252 	dcx 	h
   3C14 22 4A 52      [16]  253 	shld	_String1
                            254 ;                return EOF;
   3C17 21 01 00      [10]  255 	lxi 	h,#1
   3C1A CD D2 01      [18]  256 	call	ccneg
   3C1D C3 34 3C      [10]  257 	jmp 	$4
                            258 ;            }
   3C20                     259 $9:
                            260 ;        } else {
   3C20 C3 34 3C      [10]  261 	jmp 	$10
   3C23                     262 $7:
                            263 ;            return fgetc(fd);
   3C23 21 04 00      [10]  264 	lxi 	h,#4
   3C26 39            [10]  265 	dad 	sp
   3C27 CD 28 01      [18]  266 	call	ccgint
   3C2A E5            [12]  267 	push	h
   3C2B 3E 01         [ 7]  268 	mvi 	a,#1
   3C2D CD 5E 22      [18]  269 	call	fgetc
   3C30 C1            [10]  270 	pop 	b
   3C31 C3 34 3C      [10]  271 	jmp 	$4
                            272 ;        }
   3C34                     273 $10:
                            274 ;    }
   3C34                     275 $6:
                            276 ;}
   3C34                     277 $4:
   3C34 C1            [10]  278 	pop 	b
   3C35 C9            [10]  279 	ret
                            280 ;/*
                            281 ; * unget character assume only one source of characters
                            282 ; * i.e. does not require file descriptor
                            283 ; */
                            284 ;_ungetc(ch)
   3C36                     285 _ungetc:
                            286 ;int ch;
                            287 ;{
                            288 ;    _Oldch = ch;
   3C36 21 02 00      [10]  289 	lxi 	h,#2
   3C39 39            [10]  290 	dad 	sp
   3C3A CD 28 01      [18]  291 	call	ccgint
   3C3D 22 4C 52      [16]  292 	shld	_Oldch
                            293 ;}
   3C40                     294 $11:
   3C40 C9            [10]  295 	ret
                            296 		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
                            297 	;extrn	ccargc
                            298 	.globl	_String1
   524A                     299 _String1:
   524A 00 00               300 	.dw	#0
                            301 	.globl	_Oldch
   524C                     302 _Oldch:
   524C 00 00               303 	.dw	#0
                            304 	.globl	scanf
                            305 	;extrn	_scanf
                            306 	.globl	fscanf
                            307 	.globl	sscanf
                            308 	.globl	_getc
                            309 	;extrn	fgetc
                            310 	.globl	_ungetc
                            311 
                            312 ;0 error(s) in compilation
                            313 ;	literal pool:0
                            314 ;	global pool:10
                            315 ;	Macro pool:112
                            316 	;	.end
