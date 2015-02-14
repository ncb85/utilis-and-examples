                              1 ; Small C 8080
                              2 ;	Coder (2.4,84/11/27)
                              3 ;	Front End (2.7,84/11/28)
                              4 ;	Front End for ASXXXX (2.8,13/01/20)
                              5 		;program area SMALLC_GENERATED is RELOCATABLE
                              6 		.module SMALLC_GENERATED
                              7 		.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
                              8 		.nlist  (pag)
                              9 		.area  SMALLC_GENERATED  (REL,CON,CSEG)
                             10 ;/**
                             11 ;        PRINTF Library Documentation
                             12 ; 
                             13 ;PRINTF supplies formatted output like that described by
                             14 ;Kernighan and Ritchie.  The input conversion routine utoi (for
                             15 ;unsigned integers) is also supplied.   
                             16 ; 
                             17 ;FUNCTIONS
                             18 ; 
                             19 ;printf(controlstring, arg, arg, ...) -- formatted print 
                             20 ;    "controlstring" is a string which can contain any of
                             21 ;    the following format codes: 
                             22 ;        %d	decimal integer 
                             23 ;        %u	unsigned decimal integer 
                             24 ;        %x	hexidecimal integer 
                             25 ;        %c	ASCII character 
                             26 ;        %s	null-terminated ASCII string 
                             27 ;        %f	fixed point conversion for double
                             28 ;        %e	floating point conversion for double 
                             29 ;    For each format code, there is an "arg" - a pointer to
                             30 ;    an object of that type. Between the '%' and the format
                             31 ;    code letter field specification may appear. For formats
                             32 ;    'f' and 'e', the specification consists of two integers
                             33 ;    separated by a period. The first specifies the minimum
                             34 ;    field width, and the second the number of digits to be
                             35 ;    printed after the decimal point. For all other formats,
                             36 ;    the specification consists only of the one integer
                             37 ;    giving the minimum field width. If there is no field 
                             38 ;    specification, the item is printed in no more space 
                             39 ;    than is necessary. 
                             40 ;        Example			  Output 
                             41 ;    printf(" decimal: %d ",15+2)	  decimal: 17  
                             42 ;    printf(" unsigned: %u ",-1)	  unsigned: 65535  
                             43 ;    printf(" hexidecimal: %x ",-1)	  hexidecimal: FFFF  
                             44 ;    printf(" string: %s ","hello")	  string: hello  
                             45 ;    printf(" character: %c ",65)	  character: A  
                             46 ;    printf(" fixed: %f ",1./7.)	  fixed: .142857  
                             47 ;    printf(" exponent: %8.5e ",1./7.) exponent: 1.42857e-1
                             48 ;    printf returns the number of characters output.
                             49 ; 
                             50 ;fprintf(unit, controlstring, arg, arg, ..)
                             51 ;    Provides functions similar to printf, but with output
                             52 ;    going to the file associated with 'unit'.
                             53 ;    fprintf returns the number of characters output.
                             54 ;sprintf(string, controlstring, arg, arg, ..)
                             55 ;    Provides functions similar to printf, but with output
                             56 ;    going to the character pointer 'string'.
                             57 ;    sprintf returns the number of characters output.
                             58 ;itod(n, str, sz)  int n;  char str[];  int sz;  
                             59 ;    convert n to signed decimal string of width sz, 
                             60 ;    right adjusted, blank filled; returns str 
                             61 ;    if sz > 0 terminate with null byte 
                             62 ;    if sz = 0 find end of string 
                             63 ;    if sz < 0 use last byte for data 
                             64 ;  
                             65 ;itou(nbr, str, sz)  int nbr;  char str[];  int sz;  
                             66 ;    convert nbr to unsigned decimal string of width sz, 
                             67 ;    right adjusted, blank filled; returns str 
                             68 ;    if sz > 0 terminate with null byte 
                             69 ;    if sz = 0 find end of string 
                             70 ;    if sz < 0 use last byte for data 
                             71 ;  
                             72 ;itox(n, str, sz)  int n;  char str[];  int sz;  
                             73 ;    converts n to hex string of length sz, right adjusted 
                             74 ;    and blank filled, returns str 
                             75 ;    if sz > 0 terminate with null byte 
                             76 ;    if sz = 0 find end of string 
                             77 ;    if sz < 0 use last byte for data 
                             78 ;  
                             79 ;ftoa(x,f,str) double x; int f; char *str; 
                             80 ;    converts x to fixed point string with f digits after 
                             81 ;    the decimal point, return str 
                             82 ;  
                             83 ;ftoe(x,f,str) double x; int f; char *str; 
                             84 ;    converts x to floating point string with f digits after
                             85 ;    the decimal point, return str 
                             86 ; 
                             87 ;utoi(decstr, nbr)  char *decstr;  int *nbr;  
                             88 ;    converts unsigned decimal ASCII string to integer 
                             89 ;    number. Returns field size, else ERR on error. (This is
                             90 ;    used to interpret the specification fields.) 
                             91 ; 
                             92 ; 
                             93 ;AUTHOR
                             94 ;    J. E. Hendrix for the original routines. J. R.
                             95 ;    Van Zandt for ftoa, ftoe, and the floating point
                             96 ;    modifications in printf.
                             97 ; 
                             98 ; 
                             99 ;INTERNAL DOCUMENTATION 
                            100 ; 
                            101 ;    The method used in ftoa to convert to a decimal string
                            102 ;involves more divisions than the classical method, but does not
                            103 ;require that the original number be scaled down at the
                            104 ;beginning. It was found that this initial scaling was causing
                            105 ;loss of precision. The present algorithm should always convert
                            106 ;an integer exactly if it can be represented exactly as a
                            107 ;floating point number (that is, if it is less than 2**40).
                            108 ;The routines seen by the user (printf, fprintf, sprintf) are in
                            109 ;the library PRINTF.  The routine which does all the hard work,
                            110 ;_printf, is in either PRINTF1 or PRINTF2 depending on whether or
                            111 ;not floating point output is required.
                            112 ; */
                            113 ;#include <stdio.h>
                            114 ;#define stdin 0
                            115 ;#define stdout 1
                            116 ;#define stderr 2
                            117 ;#define NULL 0
                            118 ;#define EOF (-1)
                            119 ;#define FILE char
                            120 ;int ccargc;
                            121 ;char *buffer, *_string;
                            122 ;/**
                            123 ; * fprintf(fd, ctlstring, arg, arg, ...) - Formatted print.
                            124 ; * Operates as described by Kernighan & Ritchie.
                            125 ; * b, c, d, o, s, u, and x specifications are supported.
                            126 ; * Note: b (binary) is a non-standard extension.
                            127 ; */
                            128 ;fprintf(int argc) {
   2F78                     129 fprintf:
                            130 ;    int *nxtarg;
   2F78 C5            [12]  131 	push	b
                            132 ;    #asm
   2F79 32 38 52      [13]  133         sta     ccargc
   2F7C AF            [ 4]  134         xra     a
   2F7D 32 39 52      [13]  135         sta     ccargc+1
                            136 ;    nxtarg = ccargc + &argc;
   2F80 21 00 00      [10]  137 	lxi 	h,#0
   2F83 39            [10]  138 	dad 	sp
   2F84 E5            [12]  139 	push	h
   2F85 2A 38 52      [16]  140 	lhld	ccargc
   2F88 E5            [12]  141 	push	h
   2F89 21 08 00      [10]  142 	lxi 	h,#8
   2F8C 39            [10]  143 	dad 	sp
   2F8D D1            [10]  144 	pop 	d
   2F8E EB            [ 4]  145 	xchg
   2F8F 29            [10]  146 	dad 	h
   2F90 EB            [ 4]  147 	xchg
   2F91 19            [10]  148 	dad 	d
   2F92 D1            [10]  149 	pop 	d
   2F93 CD 30 01      [18]  150 	call	ccpint
                            151 ;	_string = NULL;
   2F96 21 00 00      [10]  152 	lxi 	h,#0
   2F99 22 3C 52      [16]  153 	shld	_string
                            154 ;    return _print(*(--nxtarg), --nxtarg);
   2F9C 21 00 00      [10]  155 	lxi 	h,#0
   2F9F 39            [10]  156 	dad 	sp
   2FA0 E5            [12]  157 	push	h
   2FA1 CD 28 01      [18]  158 	call	ccgint
   2FA4 2B            [ 6]  159 	dcx 	h
   2FA5 2B            [ 6]  160 	dcx 	h
   2FA6 D1            [10]  161 	pop 	d
   2FA7 CD 30 01      [18]  162 	call	ccpint
   2FAA CD 28 01      [18]  163 	call	ccgint
   2FAD E5            [12]  164 	push	h
   2FAE 21 02 00      [10]  165 	lxi 	h,#2
   2FB1 39            [10]  166 	dad 	sp
   2FB2 E5            [12]  167 	push	h
   2FB3 CD 28 01      [18]  168 	call	ccgint
   2FB6 2B            [ 6]  169 	dcx 	h
   2FB7 2B            [ 6]  170 	dcx 	h
   2FB8 D1            [10]  171 	pop 	d
   2FB9 CD 30 01      [18]  172 	call	ccpint
   2FBC E5            [12]  173 	push	h
   2FBD 3E 02         [ 7]  174 	mvi 	a,#2
   2FBF CD 5F 30      [18]  175 	call	_print
   2FC2 C1            [10]  176 	pop 	b
   2FC3 C1            [10]  177 	pop 	b
   2FC4 C3 C7 2F      [10]  178 	jmp 	$1
                            179 ;}
   2FC7                     180 $1:
   2FC7 C1            [10]  181 	pop 	b
   2FC8 C9            [10]  182 	ret
                            183 ;/**
                            184 ; * printf(ctlstring, arg, arg, ...) - Formatted print.
                            185 ; * Operates as described by Kernighan & Ritchie.
                            186 ; * b, c, d, o, s, u, and x specifications are supported.
                            187 ; * Note: b (binary) is a non-standard extension.
                            188 ; */
                            189 ;printf(int argc) {
   2FC9                     190 printf:
                            191 ;    int *nxtarg;
   2FC9 C5            [12]  192 	push	b
                            193 ;    #asm
   2FCA 32 38 52      [13]  194         sta     ccargc
   2FCD AF            [ 4]  195         xra     a
   2FCE 32 39 52      [13]  196         sta     ccargc+1
                            197 ;    nxtarg = ccargc + &argc - 1;
   2FD1 21 00 00      [10]  198 	lxi 	h,#0
   2FD4 39            [10]  199 	dad 	sp
   2FD5 E5            [12]  200 	push	h
   2FD6 2A 38 52      [16]  201 	lhld	ccargc
   2FD9 E5            [12]  202 	push	h
   2FDA 21 08 00      [10]  203 	lxi 	h,#8
   2FDD 39            [10]  204 	dad 	sp
   2FDE D1            [10]  205 	pop 	d
   2FDF EB            [ 4]  206 	xchg
   2FE0 29            [10]  207 	dad 	h
   2FE1 EB            [ 4]  208 	xchg
   2FE2 19            [10]  209 	dad 	d
   2FE3 E5            [12]  210 	push	h
   2FE4 21 01 00      [10]  211 	lxi 	h,#1
   2FE7 29            [10]  212 	dad 	h
   2FE8 D1            [10]  213 	pop 	d
   2FE9 CD CB 01      [18]  214 	call	ccsub
   2FEC D1            [10]  215 	pop 	d
   2FED CD 30 01      [18]  216 	call	ccpint
                            217 ;	_string = NULL;
   2FF0 21 00 00      [10]  218 	lxi 	h,#0
   2FF3 22 3C 52      [16]  219 	shld	_string
                            220 ;    return _print(stdout, nxtarg);
   2FF6 21 01 00      [10]  221 	lxi 	h,#1
   2FF9 E5            [12]  222 	push	h
   2FFA 21 02 00      [10]  223 	lxi 	h,#2
   2FFD 39            [10]  224 	dad 	sp
   2FFE CD 28 01      [18]  225 	call	ccgint
   3001 E5            [12]  226 	push	h
   3002 3E 02         [ 7]  227 	mvi 	a,#2
   3004 CD 5F 30      [18]  228 	call	_print
   3007 C1            [10]  229 	pop 	b
   3008 C1            [10]  230 	pop 	b
   3009 C3 0C 30      [10]  231 	jmp 	$2
                            232 ;}
   300C                     233 $2:
   300C C1            [10]  234 	pop 	b
   300D C9            [10]  235 	ret
                            236 ;sprintf(int argc) {
   300E                     237 sprintf:
                            238 ;	int *nxtarg;
   300E C5            [12]  239 	push	b
                            240 ;    #asm
   300F 32 38 52      [13]  241         sta     ccargc
   3012 AF            [ 4]  242         xra     a
   3013 32 39 52      [13]  243         sta     ccargc+1
                            244 ;    nxtarg = ccargc + &argc;
   3016 21 00 00      [10]  245 	lxi 	h,#0
   3019 39            [10]  246 	dad 	sp
   301A E5            [12]  247 	push	h
   301B 2A 38 52      [16]  248 	lhld	ccargc
   301E E5            [12]  249 	push	h
   301F 21 08 00      [10]  250 	lxi 	h,#8
   3022 39            [10]  251 	dad 	sp
   3023 D1            [10]  252 	pop 	d
   3024 EB            [ 4]  253 	xchg
   3025 29            [10]  254 	dad 	h
   3026 EB            [ 4]  255 	xchg
   3027 19            [10]  256 	dad 	d
   3028 D1            [10]  257 	pop 	d
   3029 CD 30 01      [18]  258 	call	ccpint
                            259 ;	_string = *--nxtarg;
   302C 21 00 00      [10]  260 	lxi 	h,#0
   302F 39            [10]  261 	dad 	sp
   3030 E5            [12]  262 	push	h
   3031 CD 28 01      [18]  263 	call	ccgint
   3034 2B            [ 6]  264 	dcx 	h
   3035 2B            [ 6]  265 	dcx 	h
   3036 D1            [10]  266 	pop 	d
   3037 CD 30 01      [18]  267 	call	ccpint
   303A CD 28 01      [18]  268 	call	ccgint
   303D 22 3C 52      [16]  269 	shld	_string
                            270 ;	return _print(stdin, --nxtarg);
   3040 21 00 00      [10]  271 	lxi 	h,#0
   3043 E5            [12]  272 	push	h
   3044 21 02 00      [10]  273 	lxi 	h,#2
   3047 39            [10]  274 	dad 	sp
   3048 E5            [12]  275 	push	h
   3049 CD 28 01      [18]  276 	call	ccgint
   304C 2B            [ 6]  277 	dcx 	h
   304D 2B            [ 6]  278 	dcx 	h
   304E D1            [10]  279 	pop 	d
   304F CD 30 01      [18]  280 	call	ccpint
   3052 E5            [12]  281 	push	h
   3053 3E 02         [ 7]  282 	mvi 	a,#2
   3055 CD 5F 30      [18]  283 	call	_print
   3058 C1            [10]  284 	pop 	b
   3059 C1            [10]  285 	pop 	b
   305A C3 5D 30      [10]  286 	jmp 	$3
                            287 ;}
   305D                     288 $3:
   305D C1            [10]  289 	pop 	b
   305E C9            [10]  290 	ret
                            291 ;/**
                            292 ; * _print(fd, ctlstring, arg, arg, ...)
                            293 ; * Called by fprintf() and printf().
                            294 ; */
                            295 ;_print(int fd, int *nxtarg) {
   305F                     296 _print:
                            297 ;    int arg, left, pad, cc, len, maxchr, width;
   305F C5            [12]  298 	push	b
   3060 C5            [12]  299 	push	b
   3061 C5            [12]  300 	push	b
   3062 C5            [12]  301 	push	b
   3063 C5            [12]  302 	push	b
   3064 C5            [12]  303 	push	b
   3065 C5            [12]  304 	push	b
                            305 ;    char *ctl, *sptr, str[17];
   3066 C5            [12]  306 	push	b
   3067 C5            [12]  307 	push	b
   3068 EB            [ 4]  308 	xchg
   3069 21 EF FF      [10]  309 	lxi 	h,#-17
   306C 39            [10]  310 	dad 	sp
   306D F9            [ 6]  311 	sphl
   306E EB            [ 4]  312 	xchg
                            313 ;    cc = 0;
   306F 21 1B 00      [10]  314 	lxi 	h,#27
   3072 39            [10]  315 	dad 	sp
   3073 E5            [12]  316 	push	h
   3074 21 00 00      [10]  317 	lxi 	h,#0
   3077 D1            [10]  318 	pop 	d
   3078 CD 30 01      [18]  319 	call	ccpint
                            320 ;    ctl = *nxtarg--;
   307B 21 13 00      [10]  321 	lxi 	h,#19
   307E 39            [10]  322 	dad 	sp
   307F E5            [12]  323 	push	h
   3080 21 27 00      [10]  324 	lxi 	h,#39
   3083 39            [10]  325 	dad 	sp
   3084 E5            [12]  326 	push	h
   3085 CD 28 01      [18]  327 	call	ccgint
   3088 2B            [ 6]  328 	dcx 	h
   3089 2B            [ 6]  329 	dcx 	h
   308A D1            [10]  330 	pop 	d
   308B CD 30 01      [18]  331 	call	ccpint
   308E 23            [ 6]  332 	inx 	h
   308F 23            [ 6]  333 	inx 	h
   3090 CD 28 01      [18]  334 	call	ccgint
   3093 D1            [10]  335 	pop 	d
   3094 CD 30 01      [18]  336 	call	ccpint
                            337 ;    while (*ctl) {
   3097                     338 $5:
   3097 21 13 00      [10]  339 	lxi 	h,#19
   309A 39            [10]  340 	dad 	sp
   309B CD 28 01      [18]  341 	call	ccgint
   309E CD 22 01      [18]  342 	call	ccgchar
   30A1 7C            [ 4]  343 	mov 	a,h
   30A2 B5            [ 4]  344 	ora 	l
   30A3 CA 01 35      [10]  345 	jz  	$6
                            346 ;        if (*ctl != '%') {
   30A6 21 13 00      [10]  347 	lxi 	h,#19
   30A9 39            [10]  348 	dad 	sp
   30AA CD 28 01      [18]  349 	call	ccgint
   30AD CD 22 01      [18]  350 	call	ccgchar
   30B0 E5            [12]  351 	push	h
   30B1 21 25 00      [10]  352 	lxi 	h,#37
   30B4 D1            [10]  353 	pop 	d
   30B5 CD 51 01      [18]  354 	call	ccne
   30B8 7C            [ 4]  355 	mov 	a,h
   30B9 B5            [ 4]  356 	ora 	l
   30BA CA F1 30      [10]  357 	jz  	$7
                            358 ;            _outc(*ctl++, fd);
   30BD 21 13 00      [10]  359 	lxi 	h,#19
   30C0 39            [10]  360 	dad 	sp
   30C1 E5            [12]  361 	push	h
   30C2 CD 28 01      [18]  362 	call	ccgint
   30C5 23            [ 6]  363 	inx 	h
   30C6 D1            [10]  364 	pop 	d
   30C7 CD 30 01      [18]  365 	call	ccpint
   30CA 2B            [ 6]  366 	dcx 	h
   30CB CD 22 01      [18]  367 	call	ccgchar
   30CE E5            [12]  368 	push	h
   30CF 21 29 00      [10]  369 	lxi 	h,#41
   30D2 39            [10]  370 	dad 	sp
   30D3 CD 28 01      [18]  371 	call	ccgint
   30D6 E5            [12]  372 	push	h
   30D7 3E 02         [ 7]  373 	mvi 	a,#2
   30D9 CD 13 35      [18]  374 	call	_outc
   30DC C1            [10]  375 	pop 	b
   30DD C1            [10]  376 	pop 	b
                            377 ;            ++cc;
   30DE 21 1B 00      [10]  378 	lxi 	h,#27
   30E1 39            [10]  379 	dad 	sp
   30E2 E5            [12]  380 	push	h
   30E3 CD 28 01      [18]  381 	call	ccgint
   30E6 23            [ 6]  382 	inx 	h
   30E7 D1            [10]  383 	pop 	d
   30E8 CD 30 01      [18]  384 	call	ccpint
                            385 ;            continue;
   30EB C3 97 30      [10]  386 	jmp 	$5
                            387 ;        } else {
   30EE C3 FE 30      [10]  388 	jmp 	$8
   30F1                     389 $7:
                            390 ;            ++ctl;
   30F1 21 13 00      [10]  391 	lxi 	h,#19
   30F4 39            [10]  392 	dad 	sp
   30F5 E5            [12]  393 	push	h
   30F6 CD 28 01      [18]  394 	call	ccgint
   30F9 23            [ 6]  395 	inx 	h
   30FA D1            [10]  396 	pop 	d
   30FB CD 30 01      [18]  397 	call	ccpint
                            398 ;        }
   30FE                     399 $8:
                            400 ;        if (*ctl == '%') {
   30FE 21 13 00      [10]  401 	lxi 	h,#19
   3101 39            [10]  402 	dad 	sp
   3102 CD 28 01      [18]  403 	call	ccgint
   3105 CD 22 01      [18]  404 	call	ccgchar
   3108 E5            [12]  405 	push	h
   3109 21 25 00      [10]  406 	lxi 	h,#37
   310C D1            [10]  407 	pop 	d
   310D CD 4B 01      [18]  408 	call	cceq
   3110 7C            [ 4]  409 	mov 	a,h
   3111 B5            [ 4]  410 	ora 	l
   3112 CA 46 31      [10]  411 	jz  	$9
                            412 ;            _outc(*ctl++, fd);
   3115 21 13 00      [10]  413 	lxi 	h,#19
   3118 39            [10]  414 	dad 	sp
   3119 E5            [12]  415 	push	h
   311A CD 28 01      [18]  416 	call	ccgint
   311D 23            [ 6]  417 	inx 	h
   311E D1            [10]  418 	pop 	d
   311F CD 30 01      [18]  419 	call	ccpint
   3122 2B            [ 6]  420 	dcx 	h
   3123 CD 22 01      [18]  421 	call	ccgchar
   3126 E5            [12]  422 	push	h
   3127 21 29 00      [10]  423 	lxi 	h,#41
   312A 39            [10]  424 	dad 	sp
   312B CD 28 01      [18]  425 	call	ccgint
   312E E5            [12]  426 	push	h
   312F 3E 02         [ 7]  427 	mvi 	a,#2
   3131 CD 13 35      [18]  428 	call	_outc
   3134 C1            [10]  429 	pop 	b
   3135 C1            [10]  430 	pop 	b
                            431 ;            ++cc;
   3136 21 1B 00      [10]  432 	lxi 	h,#27
   3139 39            [10]  433 	dad 	sp
   313A E5            [12]  434 	push	h
   313B CD 28 01      [18]  435 	call	ccgint
   313E 23            [ 6]  436 	inx 	h
   313F D1            [10]  437 	pop 	d
   3140 CD 30 01      [18]  438 	call	ccpint
                            439 ;            continue;
   3143 C3 97 30      [10]  440 	jmp 	$5
                            441 ;        }
                            442 ;        if (*ctl == '-') {
   3146                     443 $9:
   3146 21 13 00      [10]  444 	lxi 	h,#19
   3149 39            [10]  445 	dad 	sp
   314A CD 28 01      [18]  446 	call	ccgint
   314D CD 22 01      [18]  447 	call	ccgchar
   3150 E5            [12]  448 	push	h
   3151 21 2D 00      [10]  449 	lxi 	h,#45
   3154 D1            [10]  450 	pop 	d
   3155 CD 4B 01      [18]  451 	call	cceq
   3158 7C            [ 4]  452 	mov 	a,h
   3159 B5            [ 4]  453 	ora 	l
   315A CA 79 31      [10]  454 	jz  	$10
                            455 ;            left = 1;
   315D 21 1F 00      [10]  456 	lxi 	h,#31
   3160 39            [10]  457 	dad 	sp
   3161 E5            [12]  458 	push	h
   3162 21 01 00      [10]  459 	lxi 	h,#1
   3165 D1            [10]  460 	pop 	d
   3166 CD 30 01      [18]  461 	call	ccpint
                            462 ;            ++ctl;
   3169 21 13 00      [10]  463 	lxi 	h,#19
   316C 39            [10]  464 	dad 	sp
   316D E5            [12]  465 	push	h
   316E CD 28 01      [18]  466 	call	ccgint
   3171 23            [ 6]  467 	inx 	h
   3172 D1            [10]  468 	pop 	d
   3173 CD 30 01      [18]  469 	call	ccpint
                            470 ;        } else left = 0;
   3176 C3 85 31      [10]  471 	jmp 	$11
   3179                     472 $10:
   3179 21 1F 00      [10]  473 	lxi 	h,#31
   317C 39            [10]  474 	dad 	sp
   317D E5            [12]  475 	push	h
   317E 21 00 00      [10]  476 	lxi 	h,#0
   3181 D1            [10]  477 	pop 	d
   3182 CD 30 01      [18]  478 	call	ccpint
   3185                     479 $11:
                            480 ;        if (*ctl == '0') pad = '0';
   3185 21 13 00      [10]  481 	lxi 	h,#19
   3188 39            [10]  482 	dad 	sp
   3189 CD 28 01      [18]  483 	call	ccgint
   318C CD 22 01      [18]  484 	call	ccgchar
   318F E5            [12]  485 	push	h
   3190 21 30 00      [10]  486 	lxi 	h,#48
   3193 D1            [10]  487 	pop 	d
   3194 CD 4B 01      [18]  488 	call	cceq
   3197 7C            [ 4]  489 	mov 	a,h
   3198 B5            [ 4]  490 	ora 	l
   3199 CA AB 31      [10]  491 	jz  	$12
   319C 21 1D 00      [10]  492 	lxi 	h,#29
   319F 39            [10]  493 	dad 	sp
   31A0 E5            [12]  494 	push	h
   31A1 21 30 00      [10]  495 	lxi 	h,#48
   31A4 D1            [10]  496 	pop 	d
   31A5 CD 30 01      [18]  497 	call	ccpint
                            498 ;        else pad = ' ';
   31A8 C3 B7 31      [10]  499 	jmp 	$13
   31AB                     500 $12:
   31AB 21 1D 00      [10]  501 	lxi 	h,#29
   31AE 39            [10]  502 	dad 	sp
   31AF E5            [12]  503 	push	h
   31B0 21 20 00      [10]  504 	lxi 	h,#32
   31B3 D1            [10]  505 	pop 	d
   31B4 CD 30 01      [18]  506 	call	ccpint
   31B7                     507 $13:
                            508 ;        if (isdigit(*ctl)) {
   31B7 21 13 00      [10]  509 	lxi 	h,#19
   31BA 39            [10]  510 	dad 	sp
   31BB CD 28 01      [18]  511 	call	ccgint
   31BE CD 22 01      [18]  512 	call	ccgchar
   31C1 E5            [12]  513 	push	h
   31C2 3E 01         [ 7]  514 	mvi 	a,#1
   31C4 CD 4C 21      [18]  515 	call	isdigit
   31C7 C1            [10]  516 	pop 	b
   31C8 7C            [ 4]  517 	mov 	a,h
   31C9 B5            [ 4]  518 	ora 	l
   31CA CA 14 32      [10]  519 	jz  	$14
                            520 ;            width = atoi(ctl++);
   31CD 21 15 00      [10]  521 	lxi 	h,#21
   31D0 39            [10]  522 	dad 	sp
   31D1 E5            [12]  523 	push	h
   31D2 21 15 00      [10]  524 	lxi 	h,#21
   31D5 39            [10]  525 	dad 	sp
   31D6 E5            [12]  526 	push	h
   31D7 CD 28 01      [18]  527 	call	ccgint
   31DA 23            [ 6]  528 	inx 	h
   31DB D1            [10]  529 	pop 	d
   31DC CD 30 01      [18]  530 	call	ccpint
   31DF 2B            [ 6]  531 	dcx 	h
   31E0 E5            [12]  532 	push	h
   31E1 3E 01         [ 7]  533 	mvi 	a,#1
   31E3 CD 88 37      [18]  534 	call	atoi
   31E6 C1            [10]  535 	pop 	b
   31E7 D1            [10]  536 	pop 	d
   31E8 CD 30 01      [18]  537 	call	ccpint
                            538 ;            while (isdigit(*ctl)) ++ctl;
   31EB                     539 $15:
   31EB 21 13 00      [10]  540 	lxi 	h,#19
   31EE 39            [10]  541 	dad 	sp
   31EF CD 28 01      [18]  542 	call	ccgint
   31F2 CD 22 01      [18]  543 	call	ccgchar
   31F5 E5            [12]  544 	push	h
   31F6 3E 01         [ 7]  545 	mvi 	a,#1
   31F8 CD 4C 21      [18]  546 	call	isdigit
   31FB C1            [10]  547 	pop 	b
   31FC 7C            [ 4]  548 	mov 	a,h
   31FD B5            [ 4]  549 	ora 	l
   31FE CA 11 32      [10]  550 	jz  	$16
   3201 21 13 00      [10]  551 	lxi 	h,#19
   3204 39            [10]  552 	dad 	sp
   3205 E5            [12]  553 	push	h
   3206 CD 28 01      [18]  554 	call	ccgint
   3209 23            [ 6]  555 	inx 	h
   320A D1            [10]  556 	pop 	d
   320B CD 30 01      [18]  557 	call	ccpint
   320E C3 EB 31      [10]  558 	jmp 	$15
   3211                     559 $16:
                            560 ;        } else width = 0;
   3211 C3 20 32      [10]  561 	jmp 	$17
   3214                     562 $14:
   3214 21 15 00      [10]  563 	lxi 	h,#21
   3217 39            [10]  564 	dad 	sp
   3218 E5            [12]  565 	push	h
   3219 21 00 00      [10]  566 	lxi 	h,#0
   321C D1            [10]  567 	pop 	d
   321D CD 30 01      [18]  568 	call	ccpint
   3220                     569 $17:
                            570 ;        if (*ctl == '.') {
   3220 21 13 00      [10]  571 	lxi 	h,#19
   3223 39            [10]  572 	dad 	sp
   3224 CD 28 01      [18]  573 	call	ccgint
   3227 CD 22 01      [18]  574 	call	ccgchar
   322A E5            [12]  575 	push	h
   322B 21 2E 00      [10]  576 	lxi 	h,#46
   322E D1            [10]  577 	pop 	d
   322F CD 4B 01      [18]  578 	call	cceq
   3232 7C            [ 4]  579 	mov 	a,h
   3233 B5            [ 4]  580 	ora 	l
   3234 CA 7D 32      [10]  581 	jz  	$18
                            582 ;            maxchr = atoi(++ctl);
   3237 21 17 00      [10]  583 	lxi 	h,#23
   323A 39            [10]  584 	dad 	sp
   323B E5            [12]  585 	push	h
   323C 21 15 00      [10]  586 	lxi 	h,#21
   323F 39            [10]  587 	dad 	sp
   3240 E5            [12]  588 	push	h
   3241 CD 28 01      [18]  589 	call	ccgint
   3244 23            [ 6]  590 	inx 	h
   3245 D1            [10]  591 	pop 	d
   3246 CD 30 01      [18]  592 	call	ccpint
   3249 E5            [12]  593 	push	h
   324A 3E 01         [ 7]  594 	mvi 	a,#1
   324C CD 88 37      [18]  595 	call	atoi
   324F C1            [10]  596 	pop 	b
   3250 D1            [10]  597 	pop 	d
   3251 CD 30 01      [18]  598 	call	ccpint
                            599 ;            while (isdigit(*ctl)) ++ctl;
   3254                     600 $19:
   3254 21 13 00      [10]  601 	lxi 	h,#19
   3257 39            [10]  602 	dad 	sp
   3258 CD 28 01      [18]  603 	call	ccgint
   325B CD 22 01      [18]  604 	call	ccgchar
   325E E5            [12]  605 	push	h
   325F 3E 01         [ 7]  606 	mvi 	a,#1
   3261 CD 4C 21      [18]  607 	call	isdigit
   3264 C1            [10]  608 	pop 	b
   3265 7C            [ 4]  609 	mov 	a,h
   3266 B5            [ 4]  610 	ora 	l
   3267 CA 7A 32      [10]  611 	jz  	$20
   326A 21 13 00      [10]  612 	lxi 	h,#19
   326D 39            [10]  613 	dad 	sp
   326E E5            [12]  614 	push	h
   326F CD 28 01      [18]  615 	call	ccgint
   3272 23            [ 6]  616 	inx 	h
   3273 D1            [10]  617 	pop 	d
   3274 CD 30 01      [18]  618 	call	ccpint
   3277 C3 54 32      [10]  619 	jmp 	$19
   327A                     620 $20:
                            621 ;        } else maxchr = 0;
   327A C3 89 32      [10]  622 	jmp 	$21
   327D                     623 $18:
   327D 21 17 00      [10]  624 	lxi 	h,#23
   3280 39            [10]  625 	dad 	sp
   3281 E5            [12]  626 	push	h
   3282 21 00 00      [10]  627 	lxi 	h,#0
   3285 D1            [10]  628 	pop 	d
   3286 CD 30 01      [18]  629 	call	ccpint
   3289                     630 $21:
                            631 ;        arg = *nxtarg--;
   3289 21 21 00      [10]  632 	lxi 	h,#33
   328C 39            [10]  633 	dad 	sp
   328D E5            [12]  634 	push	h
   328E 21 27 00      [10]  635 	lxi 	h,#39
   3291 39            [10]  636 	dad 	sp
   3292 E5            [12]  637 	push	h
   3293 CD 28 01      [18]  638 	call	ccgint
   3296 2B            [ 6]  639 	dcx 	h
   3297 2B            [ 6]  640 	dcx 	h
   3298 D1            [10]  641 	pop 	d
   3299 CD 30 01      [18]  642 	call	ccpint
   329C 23            [ 6]  643 	inx 	h
   329D 23            [ 6]  644 	inx 	h
   329E CD 28 01      [18]  645 	call	ccgint
   32A1 D1            [10]  646 	pop 	d
   32A2 CD 30 01      [18]  647 	call	ccpint
                            648 ;        sptr = str;
   32A5 21 11 00      [10]  649 	lxi 	h,#17
   32A8 39            [10]  650 	dad 	sp
   32A9 E5            [12]  651 	push	h
   32AA 21 02 00      [10]  652 	lxi 	h,#2
   32AD 39            [10]  653 	dad 	sp
   32AE D1            [10]  654 	pop 	d
   32AF CD 30 01      [18]  655 	call	ccpint
                            656 ;        switch (*ctl++) {
   32B2 21 18 52      [10]  657 	lxi 	h,$22
   32B5 E5            [12]  658 	push	h
   32B6 21 15 00      [10]  659 	lxi 	h,#21
   32B9 39            [10]  660 	dad 	sp
   32BA E5            [12]  661 	push	h
   32BB CD 28 01      [18]  662 	call	ccgint
   32BE 23            [ 6]  663 	inx 	h
   32BF D1            [10]  664 	pop 	d
   32C0 CD 30 01      [18]  665 	call	ccpint
   32C3 2B            [ 6]  666 	dcx 	h
   32C4 CD 22 01      [18]  667 	call	ccgchar
   32C7 C3 6D 02      [10]  668 	jmp 	cccase
                            669 ;            case 'c': str[0] = arg;
   32CA                     670 $24:
   32CA 21 00 00      [10]  671 	lxi 	h,#0
   32CD 39            [10]  672 	dad 	sp
   32CE E5            [12]  673 	push	h
   32CF 21 00 00      [10]  674 	lxi 	h,#0
   32D2 D1            [10]  675 	pop 	d
   32D3 19            [10]  676 	dad 	d
   32D4 E5            [12]  677 	push	h
   32D5 21 23 00      [10]  678 	lxi 	h,#35
   32D8 39            [10]  679 	dad 	sp
   32D9 CD 28 01      [18]  680 	call	ccgint
   32DC D1            [10]  681 	pop 	d
   32DD 7D            [ 4]  682 	mov 	a,l
   32DE 12            [ 7]  683 	stax	d
                            684 ;                str[1] = NULL;
   32DF 21 00 00      [10]  685 	lxi 	h,#0
   32E2 39            [10]  686 	dad 	sp
   32E3 E5            [12]  687 	push	h
   32E4 21 01 00      [10]  688 	lxi 	h,#1
   32E7 D1            [10]  689 	pop 	d
   32E8 19            [10]  690 	dad 	d
   32E9 E5            [12]  691 	push	h
   32EA 21 00 00      [10]  692 	lxi 	h,#0
   32ED D1            [10]  693 	pop 	d
   32EE 7D            [ 4]  694 	mov 	a,l
   32EF 12            [ 7]  695 	stax	d
                            696 ;                break;
   32F0 C3 9A 33      [10]  697 	jmp 	$23
                            698 ;            case 's': sptr = arg;
   32F3                     699 $25:
   32F3 21 11 00      [10]  700 	lxi 	h,#17
   32F6 39            [10]  701 	dad 	sp
   32F7 E5            [12]  702 	push	h
   32F8 21 23 00      [10]  703 	lxi 	h,#35
   32FB 39            [10]  704 	dad 	sp
   32FC CD 28 01      [18]  705 	call	ccgint
   32FF D1            [10]  706 	pop 	d
   3300 CD 30 01      [18]  707 	call	ccpint
                            708 ;                break;
   3303 C3 9A 33      [10]  709 	jmp 	$23
                            710 ;            case 'd': itoa(arg, str);
   3306                     711 $26:
   3306 21 21 00      [10]  712 	lxi 	h,#33
   3309 39            [10]  713 	dad 	sp
   330A CD 28 01      [18]  714 	call	ccgint
   330D E5            [12]  715 	push	h
   330E 21 02 00      [10]  716 	lxi 	h,#2
   3311 39            [10]  717 	dad 	sp
   3312 E5            [12]  718 	push	h
   3313 3E 02         [ 7]  719 	mvi 	a,#2
   3315 CD 51 35      [18]  720 	call	itoa
   3318 C1            [10]  721 	pop 	b
   3319 C1            [10]  722 	pop 	b
                            723 ;                break;
   331A C3 9A 33      [10]  724 	jmp 	$23
                            725 ;            case 'b': utoab(arg, str, 2);
   331D                     726 $27:
   331D 21 21 00      [10]  727 	lxi 	h,#33
   3320 39            [10]  728 	dad 	sp
   3321 CD 28 01      [18]  729 	call	ccgint
   3324 E5            [12]  730 	push	h
   3325 21 02 00      [10]  731 	lxi 	h,#2
   3328 39            [10]  732 	dad 	sp
   3329 E5            [12]  733 	push	h
   332A 21 02 00      [10]  734 	lxi 	h,#2
   332D E5            [12]  735 	push	h
   332E 3E 03         [ 7]  736 	mvi 	a,#3
   3330 CD 42 36      [18]  737 	call	utoab
   3333 C1            [10]  738 	pop 	b
   3334 C1            [10]  739 	pop 	b
   3335 C1            [10]  740 	pop 	b
                            741 ;                break;
   3336 C3 9A 33      [10]  742 	jmp 	$23
                            743 ;            case 'o': utoab(arg, str, 8);
   3339                     744 $28:
   3339 21 21 00      [10]  745 	lxi 	h,#33
   333C 39            [10]  746 	dad 	sp
   333D CD 28 01      [18]  747 	call	ccgint
   3340 E5            [12]  748 	push	h
   3341 21 02 00      [10]  749 	lxi 	h,#2
   3344 39            [10]  750 	dad 	sp
   3345 E5            [12]  751 	push	h
   3346 21 08 00      [10]  752 	lxi 	h,#8
   3349 E5            [12]  753 	push	h
   334A 3E 03         [ 7]  754 	mvi 	a,#3
   334C CD 42 36      [18]  755 	call	utoab
   334F C1            [10]  756 	pop 	b
   3350 C1            [10]  757 	pop 	b
   3351 C1            [10]  758 	pop 	b
                            759 ;                break;
   3352 C3 9A 33      [10]  760 	jmp 	$23
                            761 ;            case 'u': utoab(arg, str, 10);
   3355                     762 $29:
   3355 21 21 00      [10]  763 	lxi 	h,#33
   3358 39            [10]  764 	dad 	sp
   3359 CD 28 01      [18]  765 	call	ccgint
   335C E5            [12]  766 	push	h
   335D 21 02 00      [10]  767 	lxi 	h,#2
   3360 39            [10]  768 	dad 	sp
   3361 E5            [12]  769 	push	h
   3362 21 0A 00      [10]  770 	lxi 	h,#10
   3365 E5            [12]  771 	push	h
   3366 3E 03         [ 7]  772 	mvi 	a,#3
   3368 CD 42 36      [18]  773 	call	utoab
   336B C1            [10]  774 	pop 	b
   336C C1            [10]  775 	pop 	b
   336D C1            [10]  776 	pop 	b
                            777 ;                break;
   336E C3 9A 33      [10]  778 	jmp 	$23
                            779 ;            case 'x': utoab(arg, str, 16);
   3371                     780 $30:
   3371 21 21 00      [10]  781 	lxi 	h,#33
   3374 39            [10]  782 	dad 	sp
   3375 CD 28 01      [18]  783 	call	ccgint
   3378 E5            [12]  784 	push	h
   3379 21 02 00      [10]  785 	lxi 	h,#2
   337C 39            [10]  786 	dad 	sp
   337D E5            [12]  787 	push	h
   337E 21 10 00      [10]  788 	lxi 	h,#16
   3381 E5            [12]  789 	push	h
   3382 3E 03         [ 7]  790 	mvi 	a,#3
   3384 CD 42 36      [18]  791 	call	utoab
   3387 C1            [10]  792 	pop 	b
   3388 C1            [10]  793 	pop 	b
   3389 C1            [10]  794 	pop 	b
                            795 ;                break;
   338A C3 9A 33      [10]  796 	jmp 	$23
                            797 ;            default: return (cc);
   338D                     798 $31:
   338D 21 1B 00      [10]  799 	lxi 	h,#27
   3390 39            [10]  800 	dad 	sp
   3391 CD 28 01      [18]  801 	call	ccgint
   3394 C3 0B 35      [10]  802 	jmp 	$4
                            803 ;        }
   3397 C3 9A 33      [10]  804 	jmp 	$23
                            805 		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
   5218                     806 $22:
   5218 63 00 CA 32 73 00   807 	.dw	#99,$24,#115,$25,#100,$26,#98,$27
        F3 32 64 00 06 33
        62 00 1D 33
   5228 6F 00 39 33 75 00   808 	.dw	#111,$28,#117,$29,#120,$30
        55 33 78 00 71 33
   5234 8D 33 00 00         809 	.dw	$31,0
                            810 		.area  SMALLC_GENERATED  (REL,CON,CSEG)
   339A                     811 $23:
                            812 ;        len = strlen(sptr);
   339A 21 19 00      [10]  813 	lxi 	h,#25
   339D 39            [10]  814 	dad 	sp
   339E E5            [12]  815 	push	h
   339F 21 13 00      [10]  816 	lxi 	h,#19
   33A2 39            [10]  817 	dad 	sp
   33A3 CD 28 01      [18]  818 	call	ccgint
   33A6 E5            [12]  819 	push	h
   33A7 3E 01         [ 7]  820 	mvi 	a,#1
   33A9 CD 48 37      [18]  821 	call	strlen
   33AC C1            [10]  822 	pop 	b
   33AD D1            [10]  823 	pop 	d
   33AE CD 30 01      [18]  824 	call	ccpint
                            825 ;        if (maxchr && maxchr < len) {
   33B1 21 17 00      [10]  826 	lxi 	h,#23
   33B4 39            [10]  827 	dad 	sp
   33B5 CD 28 01      [18]  828 	call	ccgint
   33B8 7C            [ 4]  829 	mov 	a,h
   33B9 B5            [ 4]  830 	ora 	l
   33BA CA D0 33      [10]  831 	jz  	$33
   33BD 21 17 00      [10]  832 	lxi 	h,#23
   33C0 39            [10]  833 	dad 	sp
   33C1 CD 28 01      [18]  834 	call	ccgint
   33C4 E5            [12]  835 	push	h
   33C5 21 1B 00      [10]  836 	lxi 	h,#27
   33C8 39            [10]  837 	dad 	sp
   33C9 CD 28 01      [18]  838 	call	ccgint
   33CC D1            [10]  839 	pop 	d
   33CD CD 6B 01      [18]  840 	call	cclt
   33D0                     841 $33:
   33D0 CD E9 01      [18]  842 	call	ccbool
   33D3 7C            [ 4]  843 	mov 	a,h
   33D4 B5            [ 4]  844 	ora 	l
   33D5 CA E8 33      [10]  845 	jz  	$32
                            846 ;            len = maxchr;
   33D8 21 19 00      [10]  847 	lxi 	h,#25
   33DB 39            [10]  848 	dad 	sp
   33DC E5            [12]  849 	push	h
   33DD 21 19 00      [10]  850 	lxi 	h,#25
   33E0 39            [10]  851 	dad 	sp
   33E1 CD 28 01      [18]  852 	call	ccgint
   33E4 D1            [10]  853 	pop 	d
   33E5 CD 30 01      [18]  854 	call	ccpint
                            855 ;        }
                            856 ;        if (width > len) {
   33E8                     857 $32:
   33E8 21 15 00      [10]  858 	lxi 	h,#21
   33EB 39            [10]  859 	dad 	sp
   33EC CD 28 01      [18]  860 	call	ccgint
   33EF E5            [12]  861 	push	h
   33F0 21 1B 00      [10]  862 	lxi 	h,#27
   33F3 39            [10]  863 	dad 	sp
   33F4 CD 28 01      [18]  864 	call	ccgint
   33F7 D1            [10]  865 	pop 	d
   33F8 CD 57 01      [18]  866 	call	ccgt
   33FB 7C            [ 4]  867 	mov 	a,h
   33FC B5            [ 4]  868 	ora 	l
   33FD CA 1F 34      [10]  869 	jz  	$34
                            870 ;            width = width - len;
   3400 21 15 00      [10]  871 	lxi 	h,#21
   3403 39            [10]  872 	dad 	sp
   3404 E5            [12]  873 	push	h
   3405 21 17 00      [10]  874 	lxi 	h,#23
   3408 39            [10]  875 	dad 	sp
   3409 CD 28 01      [18]  876 	call	ccgint
   340C E5            [12]  877 	push	h
   340D 21 1D 00      [10]  878 	lxi 	h,#29
   3410 39            [10]  879 	dad 	sp
   3411 CD 28 01      [18]  880 	call	ccgint
   3414 D1            [10]  881 	pop 	d
   3415 CD CB 01      [18]  882 	call	ccsub
   3418 D1            [10]  883 	pop 	d
   3419 CD 30 01      [18]  884 	call	ccpint
                            885 ;        } else {
   341C C3 2B 34      [10]  886 	jmp 	$35
   341F                     887 $34:
                            888 ;            width = 0;
   341F 21 15 00      [10]  889 	lxi 	h,#21
   3422 39            [10]  890 	dad 	sp
   3423 E5            [12]  891 	push	h
   3424 21 00 00      [10]  892 	lxi 	h,#0
   3427 D1            [10]  893 	pop 	d
   3428 CD 30 01      [18]  894 	call	ccpint
                            895 ;        }
   342B                     896 $35:
                            897 ;        if (!left) {
   342B 21 1F 00      [10]  898 	lxi 	h,#31
   342E 39            [10]  899 	dad 	sp
   342F CD 28 01      [18]  900 	call	ccgint
   3432 CD DE 01      [18]  901 	call	cclneg
   3435 7C            [ 4]  902 	mov 	a,h
   3436 B5            [ 4]  903 	ora 	l
   3437 CA 74 34      [10]  904 	jz  	$36
                            905 ;            while (width--) {
   343A                     906 $37:
   343A 21 15 00      [10]  907 	lxi 	h,#21
   343D 39            [10]  908 	dad 	sp
   343E E5            [12]  909 	push	h
   343F CD 28 01      [18]  910 	call	ccgint
   3442 2B            [ 6]  911 	dcx 	h
   3443 D1            [10]  912 	pop 	d
   3444 CD 30 01      [18]  913 	call	ccpint
   3447 23            [ 6]  914 	inx 	h
   3448 7C            [ 4]  915 	mov 	a,h
   3449 B5            [ 4]  916 	ora 	l
   344A CA 74 34      [10]  917 	jz  	$38
                            918 ;                _outc(pad, fd);
   344D 21 1D 00      [10]  919 	lxi 	h,#29
   3450 39            [10]  920 	dad 	sp
   3451 CD 28 01      [18]  921 	call	ccgint
   3454 E5            [12]  922 	push	h
   3455 21 29 00      [10]  923 	lxi 	h,#41
   3458 39            [10]  924 	dad 	sp
   3459 CD 28 01      [18]  925 	call	ccgint
   345C E5            [12]  926 	push	h
   345D 3E 02         [ 7]  927 	mvi 	a,#2
   345F CD 13 35      [18]  928 	call	_outc
   3462 C1            [10]  929 	pop 	b
   3463 C1            [10]  930 	pop 	b
                            931 ;                ++cc;
   3464 21 1B 00      [10]  932 	lxi 	h,#27
   3467 39            [10]  933 	dad 	sp
   3468 E5            [12]  934 	push	h
   3469 CD 28 01      [18]  935 	call	ccgint
   346C 23            [ 6]  936 	inx 	h
   346D D1            [10]  937 	pop 	d
   346E CD 30 01      [18]  938 	call	ccpint
                            939 ;            }
   3471 C3 3A 34      [10]  940 	jmp 	$37
   3474                     941 $38:
                            942 ;        }
                            943 ;        while (len--) {
   3474                     944 $36:
   3474                     945 $39:
   3474 21 19 00      [10]  946 	lxi 	h,#25
   3477 39            [10]  947 	dad 	sp
   3478 E5            [12]  948 	push	h
   3479 CD 28 01      [18]  949 	call	ccgint
   347C 2B            [ 6]  950 	dcx 	h
   347D D1            [10]  951 	pop 	d
   347E CD 30 01      [18]  952 	call	ccpint
   3481 23            [ 6]  953 	inx 	h
   3482 7C            [ 4]  954 	mov 	a,h
   3483 B5            [ 4]  955 	ora 	l
   3484 CA B8 34      [10]  956 	jz  	$40
                            957 ;            _outc(*sptr++, fd);
   3487 21 11 00      [10]  958 	lxi 	h,#17
   348A 39            [10]  959 	dad 	sp
   348B E5            [12]  960 	push	h
   348C CD 28 01      [18]  961 	call	ccgint
   348F 23            [ 6]  962 	inx 	h
   3490 D1            [10]  963 	pop 	d
   3491 CD 30 01      [18]  964 	call	ccpint
   3494 2B            [ 6]  965 	dcx 	h
   3495 CD 22 01      [18]  966 	call	ccgchar
   3498 E5            [12]  967 	push	h
   3499 21 29 00      [10]  968 	lxi 	h,#41
   349C 39            [10]  969 	dad 	sp
   349D CD 28 01      [18]  970 	call	ccgint
   34A0 E5            [12]  971 	push	h
   34A1 3E 02         [ 7]  972 	mvi 	a,#2
   34A3 CD 13 35      [18]  973 	call	_outc
   34A6 C1            [10]  974 	pop 	b
   34A7 C1            [10]  975 	pop 	b
                            976 ;            ++cc;
   34A8 21 1B 00      [10]  977 	lxi 	h,#27
   34AB 39            [10]  978 	dad 	sp
   34AC E5            [12]  979 	push	h
   34AD CD 28 01      [18]  980 	call	ccgint
   34B0 23            [ 6]  981 	inx 	h
   34B1 D1            [10]  982 	pop 	d
   34B2 CD 30 01      [18]  983 	call	ccpint
                            984 ;        }
   34B5 C3 74 34      [10]  985 	jmp 	$39
   34B8                     986 $40:
                            987 ;        if (left) {
   34B8 21 1F 00      [10]  988 	lxi 	h,#31
   34BB 39            [10]  989 	dad 	sp
   34BC CD 28 01      [18]  990 	call	ccgint
   34BF 7C            [ 4]  991 	mov 	a,h
   34C0 B5            [ 4]  992 	ora 	l
   34C1 CA FE 34      [10]  993 	jz  	$41
                            994 ;            while (width--) {
   34C4                     995 $42:
   34C4 21 15 00      [10]  996 	lxi 	h,#21
   34C7 39            [10]  997 	dad 	sp
   34C8 E5            [12]  998 	push	h
   34C9 CD 28 01      [18]  999 	call	ccgint
   34CC 2B            [ 6] 1000 	dcx 	h
   34CD D1            [10] 1001 	pop 	d
   34CE CD 30 01      [18] 1002 	call	ccpint
   34D1 23            [ 6] 1003 	inx 	h
   34D2 7C            [ 4] 1004 	mov 	a,h
   34D3 B5            [ 4] 1005 	ora 	l
   34D4 CA FE 34      [10] 1006 	jz  	$43
                           1007 ;                _outc(pad, fd);
   34D7 21 1D 00      [10] 1008 	lxi 	h,#29
   34DA 39            [10] 1009 	dad 	sp
   34DB CD 28 01      [18] 1010 	call	ccgint
   34DE E5            [12] 1011 	push	h
   34DF 21 29 00      [10] 1012 	lxi 	h,#41
   34E2 39            [10] 1013 	dad 	sp
   34E3 CD 28 01      [18] 1014 	call	ccgint
   34E6 E5            [12] 1015 	push	h
   34E7 3E 02         [ 7] 1016 	mvi 	a,#2
   34E9 CD 13 35      [18] 1017 	call	_outc
   34EC C1            [10] 1018 	pop 	b
   34ED C1            [10] 1019 	pop 	b
                           1020 ;                ++cc;
   34EE 21 1B 00      [10] 1021 	lxi 	h,#27
   34F1 39            [10] 1022 	dad 	sp
   34F2 E5            [12] 1023 	push	h
   34F3 CD 28 01      [18] 1024 	call	ccgint
   34F6 23            [ 6] 1025 	inx 	h
   34F7 D1            [10] 1026 	pop 	d
   34F8 CD 30 01      [18] 1027 	call	ccpint
                           1028 ;            }
   34FB C3 C4 34      [10] 1029 	jmp 	$42
   34FE                    1030 $43:
                           1031 ;        }
                           1032 ;    }
   34FE                    1033 $41:
   34FE C3 97 30      [10] 1034 	jmp 	$5
   3501                    1035 $6:
                           1036 ;    return (cc);
   3501 21 1B 00      [10] 1037 	lxi 	h,#27
   3504 39            [10] 1038 	dad 	sp
   3505 CD 28 01      [18] 1039 	call	ccgint
   3508 C3 0B 35      [10] 1040 	jmp 	$4
                           1041 ;}
   350B                    1042 $4:
   350B EB            [ 4] 1043 	xchg
   350C 21 23 00      [10] 1044 	lxi 	h,#35
   350F 39            [10] 1045 	dad 	sp
   3510 F9            [ 6] 1046 	sphl
   3511 EB            [ 4] 1047 	xchg
   3512 C9            [10] 1048 	ret
                           1049 ;/**
                           1050 ; * _outc - output a single character
                           1051 ; * if _string is not null send output to a string instead
                           1052 ; */
                           1053 ;_outc(char c, int fd) {
   3513                    1054 _outc:
                           1055 ;	if (_string == NULL)
   3513 2A 3C 52      [16] 1056 	lhld	_string
   3516 E5            [12] 1057 	push	h
   3517 21 00 00      [10] 1058 	lxi 	h,#0
   351A D1            [10] 1059 	pop 	d
   351B CD 4B 01      [18] 1060 	call	cceq
   351E 7C            [ 4] 1061 	mov 	a,h
   351F B5            [ 4] 1062 	ora 	l
   3520 CA 3D 35      [10] 1063 	jz  	$45
                           1064 ;		fputc(c, fd);
   3523 21 04 00      [10] 1065 	lxi 	h,#4
   3526 39            [10] 1066 	dad 	sp
   3527 CD 22 01      [18] 1067 	call	ccgchar
   352A E5            [12] 1068 	push	h
   352B 21 04 00      [10] 1069 	lxi 	h,#4
   352E 39            [10] 1070 	dad 	sp
   352F CD 28 01      [18] 1071 	call	ccgint
   3532 E5            [12] 1072 	push	h
   3533 3E 02         [ 7] 1073 	mvi 	a,#2
   3535 CD 95 27      [18] 1074 	call	fputc
   3538 C1            [10] 1075 	pop 	b
   3539 C1            [10] 1076 	pop 	b
                           1077 ;	else
   353A C3 50 35      [10] 1078 	jmp 	$46
   353D                    1079 $45:
                           1080 ;		*_string++ = c;
   353D 2A 3C 52      [16] 1081 	lhld	_string
   3540 23            [ 6] 1082 	inx 	h
   3541 22 3C 52      [16] 1083 	shld	_string
   3544 2B            [ 6] 1084 	dcx 	h
   3545 E5            [12] 1085 	push	h
   3546 21 06 00      [10] 1086 	lxi 	h,#6
   3549 39            [10] 1087 	dad 	sp
   354A CD 22 01      [18] 1088 	call	ccgchar
   354D D1            [10] 1089 	pop 	d
   354E 7D            [ 4] 1090 	mov 	a,l
   354F 12            [ 7] 1091 	stax	d
   3550                    1092 $46:
                           1093 ;}
   3550                    1094 $44:
   3550 C9            [10] 1095 	ret
                           1096 		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
                           1097 	.globl	ccargc
   5238                    1098 ccargc:
   5238 00 00              1099 	.dw	#0
                           1100 	.globl	buffer
   523A                    1101 buffer:
   523A 00 00              1102 	.dw	#0
                           1103 	.globl	_string
   523C                    1104 _string:
   523C 00 00              1105 	.dw	#0
                           1106 	.globl	fprintf
                           1107 	.globl	_print
                           1108 	.globl	printf
                           1109 	.globl	sprintf
                           1110 	.globl	_outc
                           1111 	;extrn	isdigit
                           1112 	;extrn	atoi
                           1113 	;extrn	itoa
                           1114 	;extrn	utoab
                           1115 	;extrn	strlen
                           1116 	;extrn	fputc
                           1117 
                           1118 ;0 error(s) in compilation
                           1119 ;	literal pool:0
                           1120 ;	global pool:14
                           1121 ;	Macro pool:103
                           1122 	;	.end
