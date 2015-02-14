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
                             11 ; * Core routine for integer-only scanf-type functions
                             12 ; *        only d, o, x, c, s, and u specs are supported.
                             13 ; */
                             14 ;//#include <ctype.h>
                             15 ;#include <stdio.h>
                             16 ;#define stdin 0
                             17 ;#define stdout 1
                             18 ;#define stderr 2
                             19 ;#define NULL 0
                             20 ;#define EOF (-1)
                             21 ;#define FILE char
                             22 ;//#define NULL 0
                             23 ;#define ERR (-1)
                             24 ;extern int _Oldch;
                             25 ;//extern _getc(), _ungetc(), utoi();
                             26 ;_scanf(fd, nxtarg)
   3C41                      27 _scanf:
                             28 ;int fd, *nxtarg;
                             29 ;{
                             30 ;    char *carg, *ctl, *unsigned;
   3C41 C5            [12]   31 	push	b
   3C42 C5            [12]   32 	push	b
   3C43 C5            [12]   33 	push	b
                             34 ;    int *narg, wast, ac, width, ch, cnv, base, ovfl, sign;
   3C44 C5            [12]   35 	push	b
   3C45 C5            [12]   36 	push	b
   3C46 C5            [12]   37 	push	b
   3C47 C5            [12]   38 	push	b
   3C48 C5            [12]   39 	push	b
   3C49 C5            [12]   40 	push	b
   3C4A C5            [12]   41 	push	b
   3C4B C5            [12]   42 	push	b
   3C4C C5            [12]   43 	push	b
                             44 ;    _Oldch = EOF;
   3C4D 21 01 00      [10]   45 	lxi 	h,#1
   3C50 CD D2 01      [18]   46 	call	ccneg
   3C53 22 4C 52      [16]   47 	shld	_Oldch
                             48 ;    ac = 0;
   3C56 21 0C 00      [10]   49 	lxi 	h,#12
   3C59 39            [10]   50 	dad 	sp
   3C5A E5            [12]   51 	push	h
   3C5B 21 00 00      [10]   52 	lxi 	h,#0
   3C5E D1            [10]   53 	pop 	d
   3C5F CD 30 01      [18]   54 	call	ccpint
                             55 ;    ctl = *nxtarg--;
   3C62 21 14 00      [10]   56 	lxi 	h,#20
   3C65 39            [10]   57 	dad 	sp
   3C66 E5            [12]   58 	push	h
   3C67 21 1C 00      [10]   59 	lxi 	h,#28
   3C6A 39            [10]   60 	dad 	sp
   3C6B E5            [12]   61 	push	h
   3C6C CD 28 01      [18]   62 	call	ccgint
   3C6F 2B            [ 6]   63 	dcx 	h
   3C70 2B            [ 6]   64 	dcx 	h
   3C71 D1            [10]   65 	pop 	d
   3C72 CD 30 01      [18]   66 	call	ccpint
   3C75 23            [ 6]   67 	inx 	h
   3C76 23            [ 6]   68 	inx 	h
   3C77 CD 28 01      [18]   69 	call	ccgint
   3C7A D1            [10]   70 	pop 	d
   3C7B CD 30 01      [18]   71 	call	ccpint
                             72 ;    while (*ctl) {
   3C7E                      73 $2:
   3C7E 21 14 00      [10]   74 	lxi 	h,#20
   3C81 39            [10]   75 	dad 	sp
   3C82 CD 28 01      [18]   76 	call	ccgint
   3C85 CD 22 01      [18]   77 	call	ccgchar
   3C88 7C            [ 4]   78 	mov 	a,h
   3C89 B5            [ 4]   79 	ora 	l
   3C8A CA 40 41      [10]   80 	jz  	$3
                             81 ;        if (isspace(*ctl)) {
   3C8D 21 14 00      [10]   82 	lxi 	h,#20
   3C90 39            [10]   83 	dad 	sp
   3C91 CD 28 01      [18]   84 	call	ccgint
   3C94 CD 22 01      [18]   85 	call	ccgchar
   3C97 E5            [12]   86 	push	h
   3C98 3E 01         [ 7]   87 	mvi 	a,#1
   3C9A CD 84 21      [18]   88 	call	isspace
   3C9D C1            [10]   89 	pop 	b
   3C9E 7C            [ 4]   90 	mov 	a,h
   3C9F B5            [ 4]   91 	ora 	l
   3CA0 CA B3 3C      [10]   92 	jz  	$4
                             93 ;            ++ctl;
   3CA3 21 14 00      [10]   94 	lxi 	h,#20
   3CA6 39            [10]   95 	dad 	sp
   3CA7 E5            [12]   96 	push	h
   3CA8 CD 28 01      [18]   97 	call	ccgint
   3CAB 23            [ 6]   98 	inx 	h
   3CAC D1            [10]   99 	pop 	d
   3CAD CD 30 01      [18]  100 	call	ccpint
                            101 ;            continue;
   3CB0 C3 7E 3C      [10]  102 	jmp 	$2
                            103 ;        }
                            104 ;        if (*ctl++ != '%') continue;
   3CB3                     105 $4:
   3CB3 21 14 00      [10]  106 	lxi 	h,#20
   3CB6 39            [10]  107 	dad 	sp
   3CB7 E5            [12]  108 	push	h
   3CB8 CD 28 01      [18]  109 	call	ccgint
   3CBB 23            [ 6]  110 	inx 	h
   3CBC D1            [10]  111 	pop 	d
   3CBD CD 30 01      [18]  112 	call	ccpint
   3CC0 2B            [ 6]  113 	dcx 	h
   3CC1 CD 22 01      [18]  114 	call	ccgchar
   3CC4 E5            [12]  115 	push	h
   3CC5 21 25 00      [10]  116 	lxi 	h,#37
   3CC8 D1            [10]  117 	pop 	d
   3CC9 CD 51 01      [18]  118 	call	ccne
   3CCC 7C            [ 4]  119 	mov 	a,h
   3CCD B5            [ 4]  120 	ora 	l
   3CCE CA D4 3C      [10]  121 	jz  	$5
   3CD1 C3 7E 3C      [10]  122 	jmp 	$2
                            123 ;        if (*ctl == '*') {
   3CD4                     124 $5:
   3CD4 21 14 00      [10]  125 	lxi 	h,#20
   3CD7 39            [10]  126 	dad 	sp
   3CD8 CD 28 01      [18]  127 	call	ccgint
   3CDB CD 22 01      [18]  128 	call	ccgchar
   3CDE E5            [12]  129 	push	h
   3CDF 21 2A 00      [10]  130 	lxi 	h,#42
   3CE2 D1            [10]  131 	pop 	d
   3CE3 CD 4B 01      [18]  132 	call	cceq
   3CE6 7C            [ 4]  133 	mov 	a,h
   3CE7 B5            [ 4]  134 	ora 	l
   3CE8 CA 11 3D      [10]  135 	jz  	$6
                            136 ;            narg = carg = &wast;
   3CEB 21 10 00      [10]  137 	lxi 	h,#16
   3CEE 39            [10]  138 	dad 	sp
   3CEF E5            [12]  139 	push	h
   3CF0 21 18 00      [10]  140 	lxi 	h,#24
   3CF3 39            [10]  141 	dad 	sp
   3CF4 E5            [12]  142 	push	h
   3CF5 21 12 00      [10]  143 	lxi 	h,#18
   3CF8 39            [10]  144 	dad 	sp
   3CF9 D1            [10]  145 	pop 	d
   3CFA CD 30 01      [18]  146 	call	ccpint
   3CFD D1            [10]  147 	pop 	d
   3CFE CD 30 01      [18]  148 	call	ccpint
                            149 ;            ++ctl;
   3D01 21 14 00      [10]  150 	lxi 	h,#20
   3D04 39            [10]  151 	dad 	sp
   3D05 E5            [12]  152 	push	h
   3D06 CD 28 01      [18]  153 	call	ccgint
   3D09 23            [ 6]  154 	inx 	h
   3D0A D1            [10]  155 	pop 	d
   3D0B CD 30 01      [18]  156 	call	ccpint
                            157 ;        } else narg = carg = *nxtarg--;
   3D0E C3 36 3D      [10]  158 	jmp 	$7
   3D11                     159 $6:
   3D11 21 10 00      [10]  160 	lxi 	h,#16
   3D14 39            [10]  161 	dad 	sp
   3D15 E5            [12]  162 	push	h
   3D16 21 18 00      [10]  163 	lxi 	h,#24
   3D19 39            [10]  164 	dad 	sp
   3D1A E5            [12]  165 	push	h
   3D1B 21 1E 00      [10]  166 	lxi 	h,#30
   3D1E 39            [10]  167 	dad 	sp
   3D1F E5            [12]  168 	push	h
   3D20 CD 28 01      [18]  169 	call	ccgint
   3D23 2B            [ 6]  170 	dcx 	h
   3D24 2B            [ 6]  171 	dcx 	h
   3D25 D1            [10]  172 	pop 	d
   3D26 CD 30 01      [18]  173 	call	ccpint
   3D29 23            [ 6]  174 	inx 	h
   3D2A 23            [ 6]  175 	inx 	h
   3D2B CD 28 01      [18]  176 	call	ccgint
   3D2E D1            [10]  177 	pop 	d
   3D2F CD 30 01      [18]  178 	call	ccpint
   3D32 D1            [10]  179 	pop 	d
   3D33 CD 30 01      [18]  180 	call	ccpint
   3D36                     181 $7:
                            182 ;        ctl += utoi(ctl, &width);
   3D36 21 14 00      [10]  183 	lxi 	h,#20
   3D39 39            [10]  184 	dad 	sp
   3D3A E5            [12]  185 	push	h
   3D3B CD 28 01      [18]  186 	call	ccgint
   3D3E E5            [12]  187 	push	h
   3D3F 21 18 00      [10]  188 	lxi 	h,#24
   3D42 39            [10]  189 	dad 	sp
   3D43 CD 28 01      [18]  190 	call	ccgint
   3D46 E5            [12]  191 	push	h
   3D47 21 10 00      [10]  192 	lxi 	h,#16
   3D4A 39            [10]  193 	dad 	sp
   3D4B E5            [12]  194 	push	h
   3D4C 3E 02         [ 7]  195 	mvi 	a,#2
   3D4E CD EC 38      [18]  196 	call	utoi
   3D51 C1            [10]  197 	pop 	b
   3D52 C1            [10]  198 	pop 	b
   3D53 D1            [10]  199 	pop 	d
   3D54 19            [10]  200 	dad 	d
   3D55 D1            [10]  201 	pop 	d
   3D56 CD 30 01      [18]  202 	call	ccpint
                            203 ;        if (!width) width = 32767;
   3D59 21 0A 00      [10]  204 	lxi 	h,#10
   3D5C 39            [10]  205 	dad 	sp
   3D5D CD 28 01      [18]  206 	call	ccgint
   3D60 CD DE 01      [18]  207 	call	cclneg
   3D63 7C            [ 4]  208 	mov 	a,h
   3D64 B5            [ 4]  209 	ora 	l
   3D65 CA 74 3D      [10]  210 	jz  	$8
   3D68 21 0A 00      [10]  211 	lxi 	h,#10
   3D6B 39            [10]  212 	dad 	sp
   3D6C E5            [12]  213 	push	h
   3D6D 21 FF 7F      [10]  214 	lxi 	h,#32767
   3D70 D1            [10]  215 	pop 	d
   3D71 CD 30 01      [18]  216 	call	ccpint
                            217 ;        if (!(cnv = *ctl++)) break;
   3D74                     218 $8:
   3D74 21 06 00      [10]  219 	lxi 	h,#6
   3D77 39            [10]  220 	dad 	sp
   3D78 E5            [12]  221 	push	h
   3D79 21 16 00      [10]  222 	lxi 	h,#22
   3D7C 39            [10]  223 	dad 	sp
   3D7D E5            [12]  224 	push	h
   3D7E CD 28 01      [18]  225 	call	ccgint
   3D81 23            [ 6]  226 	inx 	h
   3D82 D1            [10]  227 	pop 	d
   3D83 CD 30 01      [18]  228 	call	ccpint
   3D86 2B            [ 6]  229 	dcx 	h
   3D87 CD 22 01      [18]  230 	call	ccgchar
   3D8A D1            [10]  231 	pop 	d
   3D8B CD 30 01      [18]  232 	call	ccpint
   3D8E CD DE 01      [18]  233 	call	cclneg
   3D91 7C            [ 4]  234 	mov 	a,h
   3D92 B5            [ 4]  235 	ora 	l
   3D93 CA 99 3D      [10]  236 	jz  	$9
   3D96 C3 40 41      [10]  237 	jmp 	$3
                            238 ;        while (isspace(ch = _getc(fd)))
   3D99                     239 $9:
   3D99                     240 $10:
   3D99 21 08 00      [10]  241 	lxi 	h,#8
   3D9C 39            [10]  242 	dad 	sp
   3D9D E5            [12]  243 	push	h
   3D9E 21 1E 00      [10]  244 	lxi 	h,#30
   3DA1 39            [10]  245 	dad 	sp
   3DA2 CD 28 01      [18]  246 	call	ccgint
   3DA5 E5            [12]  247 	push	h
   3DA6 3E 01         [ 7]  248 	mvi 	a,#1
   3DA8 CD A4 3B      [18]  249 	call	_getc
   3DAB C1            [10]  250 	pop 	b
   3DAC D1            [10]  251 	pop 	d
   3DAD CD 30 01      [18]  252 	call	ccpint
   3DB0 E5            [12]  253 	push	h
   3DB1 3E 01         [ 7]  254 	mvi 	a,#1
   3DB3 CD 84 21      [18]  255 	call	isspace
   3DB6 C1            [10]  256 	pop 	b
   3DB7 7C            [ 4]  257 	mov 	a,h
   3DB8 B5            [ 4]  258 	ora 	l
   3DB9 CA BF 3D      [10]  259 	jz  	$11
                            260 ;            ;
   3DBC C3 99 3D      [10]  261 	jmp 	$10
   3DBF                     262 $11:
                            263 ;        if (ch == EOF) {
   3DBF 21 08 00      [10]  264 	lxi 	h,#8
   3DC2 39            [10]  265 	dad 	sp
   3DC3 CD 28 01      [18]  266 	call	ccgint
   3DC6 E5            [12]  267 	push	h
   3DC7 21 01 00      [10]  268 	lxi 	h,#1
   3DCA CD D2 01      [18]  269 	call	ccneg
   3DCD D1            [10]  270 	pop 	d
   3DCE CD 4B 01      [18]  271 	call	cceq
   3DD1 7C            [ 4]  272 	mov 	a,h
   3DD2 B5            [ 4]  273 	ora 	l
   3DD3 CA F1 3D      [10]  274 	jz  	$12
                            275 ;            if (ac) break;
   3DD6 21 0C 00      [10]  276 	lxi 	h,#12
   3DD9 39            [10]  277 	dad 	sp
   3DDA CD 28 01      [18]  278 	call	ccgint
   3DDD 7C            [ 4]  279 	mov 	a,h
   3DDE B5            [ 4]  280 	ora 	l
   3DDF CA E8 3D      [10]  281 	jz  	$13
   3DE2 C3 40 41      [10]  282 	jmp 	$3
                            283 ;            else return EOF;
   3DE5 C3 F1 3D      [10]  284 	jmp 	$14
   3DE8                     285 $13:
   3DE8 21 01 00      [10]  286 	lxi 	h,#1
   3DEB CD D2 01      [18]  287 	call	ccneg
   3DEE C3 4A 41      [10]  288 	jmp 	$1
   3DF1                     289 $14:
                            290 ;        }
                            291 ;        _ungetc(ch);
   3DF1                     292 $12:
   3DF1 21 08 00      [10]  293 	lxi 	h,#8
   3DF4 39            [10]  294 	dad 	sp
   3DF5 CD 28 01      [18]  295 	call	ccgint
   3DF8 E5            [12]  296 	push	h
   3DF9 3E 01         [ 7]  297 	mvi 	a,#1
   3DFB CD 36 3C      [18]  298 	call	_ungetc
   3DFE C1            [10]  299 	pop 	b
                            300 ;        switch (cnv) {
   3DFF 21 62 52      [10]  301 	lxi 	h,$15
   3E02 E5            [12]  302 	push	h
   3E03 21 08 00      [10]  303 	lxi 	h,#8
   3E06 39            [10]  304 	dad 	sp
   3E07 CD 28 01      [18]  305 	call	ccgint
   3E0A C3 6D 02      [10]  306 	jmp 	cccase
                            307 ;            case 'c':
   3E0D                     308 $17:
                            309 ;                *carg = _getc(fd);
   3E0D 21 16 00      [10]  310 	lxi 	h,#22
   3E10 39            [10]  311 	dad 	sp
   3E11 CD 28 01      [18]  312 	call	ccgint
   3E14 E5            [12]  313 	push	h
   3E15 21 1E 00      [10]  314 	lxi 	h,#30
   3E18 39            [10]  315 	dad 	sp
   3E19 CD 28 01      [18]  316 	call	ccgint
   3E1C E5            [12]  317 	push	h
   3E1D 3E 01         [ 7]  318 	mvi 	a,#1
   3E1F CD A4 3B      [18]  319 	call	_getc
   3E22 C1            [10]  320 	pop 	b
   3E23 D1            [10]  321 	pop 	d
   3E24 7D            [ 4]  322 	mov 	a,l
   3E25 12            [ 7]  323 	stax	d
                            324 ;                break;
   3E26 C3 30 41      [10]  325 	jmp 	$16
                            326 ;            case 's':
   3E29                     327 $18:
                            328 ;                while (width--) {
   3E29                     329 $19:
   3E29 21 0A 00      [10]  330 	lxi 	h,#10
   3E2C 39            [10]  331 	dad 	sp
   3E2D E5            [12]  332 	push	h
   3E2E CD 28 01      [18]  333 	call	ccgint
   3E31 2B            [ 6]  334 	dcx 	h
   3E32 D1            [10]  335 	pop 	d
   3E33 CD 30 01      [18]  336 	call	ccpint
   3E36 23            [ 6]  337 	inx 	h
   3E37 7C            [ 4]  338 	mov 	a,h
   3E38 B5            [ 4]  339 	ora 	l
   3E39 CA A6 3E      [10]  340 	jz  	$20
                            341 ;                    if ((*carg = _getc(fd)) == EOF) break;
   3E3C 21 16 00      [10]  342 	lxi 	h,#22
   3E3F 39            [10]  343 	dad 	sp
   3E40 CD 28 01      [18]  344 	call	ccgint
   3E43 E5            [12]  345 	push	h
   3E44 21 1E 00      [10]  346 	lxi 	h,#30
   3E47 39            [10]  347 	dad 	sp
   3E48 CD 28 01      [18]  348 	call	ccgint
   3E4B E5            [12]  349 	push	h
   3E4C 3E 01         [ 7]  350 	mvi 	a,#1
   3E4E CD A4 3B      [18]  351 	call	_getc
   3E51 C1            [10]  352 	pop 	b
   3E52 D1            [10]  353 	pop 	d
   3E53 7D            [ 4]  354 	mov 	a,l
   3E54 12            [ 7]  355 	stax	d
   3E55 E5            [12]  356 	push	h
   3E56 21 01 00      [10]  357 	lxi 	h,#1
   3E59 CD D2 01      [18]  358 	call	ccneg
   3E5C D1            [10]  359 	pop 	d
   3E5D CD 4B 01      [18]  360 	call	cceq
   3E60 7C            [ 4]  361 	mov 	a,h
   3E61 B5            [ 4]  362 	ora 	l
   3E62 CA 68 3E      [10]  363 	jz  	$21
   3E65 C3 A6 3E      [10]  364 	jmp 	$20
                            365 ;                    if (isspace(*carg)) break;
   3E68                     366 $21:
   3E68 21 16 00      [10]  367 	lxi 	h,#22
   3E6B 39            [10]  368 	dad 	sp
   3E6C CD 28 01      [18]  369 	call	ccgint
   3E6F CD 22 01      [18]  370 	call	ccgchar
   3E72 E5            [12]  371 	push	h
   3E73 3E 01         [ 7]  372 	mvi 	a,#1
   3E75 CD 84 21      [18]  373 	call	isspace
   3E78 C1            [10]  374 	pop 	b
   3E79 7C            [ 4]  375 	mov 	a,h
   3E7A B5            [ 4]  376 	ora 	l
   3E7B CA 81 3E      [10]  377 	jz  	$22
   3E7E C3 A6 3E      [10]  378 	jmp 	$20
                            379 ;                    if (carg != &wast) ++carg;
   3E81                     380 $22:
   3E81 21 16 00      [10]  381 	lxi 	h,#22
   3E84 39            [10]  382 	dad 	sp
   3E85 CD 28 01      [18]  383 	call	ccgint
   3E88 E5            [12]  384 	push	h
   3E89 21 10 00      [10]  385 	lxi 	h,#16
   3E8C 39            [10]  386 	dad 	sp
   3E8D D1            [10]  387 	pop 	d
   3E8E CD 51 01      [18]  388 	call	ccne
   3E91 7C            [ 4]  389 	mov 	a,h
   3E92 B5            [ 4]  390 	ora 	l
   3E93 CA A3 3E      [10]  391 	jz  	$23
   3E96 21 16 00      [10]  392 	lxi 	h,#22
   3E99 39            [10]  393 	dad 	sp
   3E9A E5            [12]  394 	push	h
   3E9B CD 28 01      [18]  395 	call	ccgint
   3E9E 23            [ 6]  396 	inx 	h
   3E9F D1            [10]  397 	pop 	d
   3EA0 CD 30 01      [18]  398 	call	ccpint
                            399 ;                }
   3EA3                     400 $23:
   3EA3 C3 29 3E      [10]  401 	jmp 	$19
   3EA6                     402 $20:
                            403 ;                *carg = 0;
   3EA6 21 16 00      [10]  404 	lxi 	h,#22
   3EA9 39            [10]  405 	dad 	sp
   3EAA CD 28 01      [18]  406 	call	ccgint
   3EAD E5            [12]  407 	push	h
   3EAE 21 00 00      [10]  408 	lxi 	h,#0
   3EB1 D1            [10]  409 	pop 	d
   3EB2 7D            [ 4]  410 	mov 	a,l
   3EB3 12            [ 7]  411 	stax	d
                            412 ;                break;
   3EB4 C3 30 41      [10]  413 	jmp 	$16
                            414 ;            default:
   3EB7                     415 $24:
                            416 ;                switch (cnv) {
   3EB7 21 4E 52      [10]  417 	lxi 	h,$25
   3EBA E5            [12]  418 	push	h
   3EBB 21 08 00      [10]  419 	lxi 	h,#8
   3EBE 39            [10]  420 	dad 	sp
   3EBF CD 28 01      [18]  421 	call	ccgint
   3EC2 C3 6D 02      [10]  422 	jmp 	cccase
                            423 ;                    case 'd': base = 10;
   3EC5                     424 $27:
   3EC5 21 04 00      [10]  425 	lxi 	h,#4
   3EC8 39            [10]  426 	dad 	sp
   3EC9 E5            [12]  427 	push	h
   3ECA 21 0A 00      [10]  428 	lxi 	h,#10
   3ECD D1            [10]  429 	pop 	d
   3ECE CD 30 01      [18]  430 	call	ccpint
                            431 ;                        sign = 0;
   3ED1 21 00 00      [10]  432 	lxi 	h,#0
   3ED4 39            [10]  433 	dad 	sp
   3ED5 E5            [12]  434 	push	h
   3ED6 21 00 00      [10]  435 	lxi 	h,#0
   3ED9 D1            [10]  436 	pop 	d
   3EDA CD 30 01      [18]  437 	call	ccpint
                            438 ;                        ovfl = 3276;
   3EDD 21 02 00      [10]  439 	lxi 	h,#2
   3EE0 39            [10]  440 	dad 	sp
   3EE1 E5            [12]  441 	push	h
   3EE2 21 CC 0C      [10]  442 	lxi 	h,#3276
   3EE5 D1            [10]  443 	pop 	d
   3EE6 CD 30 01      [18]  444 	call	ccpint
                            445 ;                        break;
   3EE9 C3 6E 3F      [10]  446 	jmp 	$26
                            447 ;                    case 'o': base = 8;
   3EEC                     448 $28:
   3EEC 21 04 00      [10]  449 	lxi 	h,#4
   3EEF 39            [10]  450 	dad 	sp
   3EF0 E5            [12]  451 	push	h
   3EF1 21 08 00      [10]  452 	lxi 	h,#8
   3EF4 D1            [10]  453 	pop 	d
   3EF5 CD 30 01      [18]  454 	call	ccpint
                            455 ;                        sign = 1;
   3EF8 21 00 00      [10]  456 	lxi 	h,#0
   3EFB 39            [10]  457 	dad 	sp
   3EFC E5            [12]  458 	push	h
   3EFD 21 01 00      [10]  459 	lxi 	h,#1
   3F00 D1            [10]  460 	pop 	d
   3F01 CD 30 01      [18]  461 	call	ccpint
                            462 ;                        ovfl = 8191;
   3F04 21 02 00      [10]  463 	lxi 	h,#2
   3F07 39            [10]  464 	dad 	sp
   3F08 E5            [12]  465 	push	h
   3F09 21 FF 1F      [10]  466 	lxi 	h,#8191
   3F0C D1            [10]  467 	pop 	d
   3F0D CD 30 01      [18]  468 	call	ccpint
                            469 ;                        break;
   3F10 C3 6E 3F      [10]  470 	jmp 	$26
                            471 ;                    case 'u': base = 10;
   3F13                     472 $29:
   3F13 21 04 00      [10]  473 	lxi 	h,#4
   3F16 39            [10]  474 	dad 	sp
   3F17 E5            [12]  475 	push	h
   3F18 21 0A 00      [10]  476 	lxi 	h,#10
   3F1B D1            [10]  477 	pop 	d
   3F1C CD 30 01      [18]  478 	call	ccpint
                            479 ;                        sign = 1;
   3F1F 21 00 00      [10]  480 	lxi 	h,#0
   3F22 39            [10]  481 	dad 	sp
   3F23 E5            [12]  482 	push	h
   3F24 21 01 00      [10]  483 	lxi 	h,#1
   3F27 D1            [10]  484 	pop 	d
   3F28 CD 30 01      [18]  485 	call	ccpint
                            486 ;                        ovfl = 6553;
   3F2B 21 02 00      [10]  487 	lxi 	h,#2
   3F2E 39            [10]  488 	dad 	sp
   3F2F E5            [12]  489 	push	h
   3F30 21 99 19      [10]  490 	lxi 	h,#6553
   3F33 D1            [10]  491 	pop 	d
   3F34 CD 30 01      [18]  492 	call	ccpint
                            493 ;                        break;
   3F37 C3 6E 3F      [10]  494 	jmp 	$26
                            495 ;                    case 'x': base = 16;
   3F3A                     496 $30:
   3F3A 21 04 00      [10]  497 	lxi 	h,#4
   3F3D 39            [10]  498 	dad 	sp
   3F3E E5            [12]  499 	push	h
   3F3F 21 10 00      [10]  500 	lxi 	h,#16
   3F42 D1            [10]  501 	pop 	d
   3F43 CD 30 01      [18]  502 	call	ccpint
                            503 ;                        sign = 1;
   3F46 21 00 00      [10]  504 	lxi 	h,#0
   3F49 39            [10]  505 	dad 	sp
   3F4A E5            [12]  506 	push	h
   3F4B 21 01 00      [10]  507 	lxi 	h,#1
   3F4E D1            [10]  508 	pop 	d
   3F4F CD 30 01      [18]  509 	call	ccpint
                            510 ;                        ovfl = 4095;
   3F52 21 02 00      [10]  511 	lxi 	h,#2
   3F55 39            [10]  512 	dad 	sp
   3F56 E5            [12]  513 	push	h
   3F57 21 FF 0F      [10]  514 	lxi 	h,#4095
   3F5A D1            [10]  515 	pop 	d
   3F5B CD 30 01      [18]  516 	call	ccpint
                            517 ;                        break;
   3F5E C3 6E 3F      [10]  518 	jmp 	$26
                            519 ;                    default: return ac;
   3F61                     520 $31:
   3F61 21 0C 00      [10]  521 	lxi 	h,#12
   3F64 39            [10]  522 	dad 	sp
   3F65 CD 28 01      [18]  523 	call	ccgint
   3F68 C3 4A 41      [10]  524 	jmp 	$1
                            525 ;                }
   3F6B C3 6E 3F      [10]  526 	jmp 	$26
                            527 		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
   524E                     528 $25:
   524E 64 00 C5 3E 6F 00   529 	.dw	#100,$27,#111,$28,#117,$29,#120,$30
        EC 3E 75 00 13 3F
        78 00 3A 3F
   525E 61 3F 00 00         530 	.dw	$31,0
                            531 		.area  SMALLC_GENERATED  (REL,CON,CSEG)
   3F6E                     532 $26:
                            533 ;                *narg = unsigned = 0;
   3F6E 21 10 00      [10]  534 	lxi 	h,#16
   3F71 39            [10]  535 	dad 	sp
   3F72 CD 28 01      [18]  536 	call	ccgint
   3F75 E5            [12]  537 	push	h
   3F76 21 14 00      [10]  538 	lxi 	h,#20
   3F79 39            [10]  539 	dad 	sp
   3F7A E5            [12]  540 	push	h
   3F7B 21 00 00      [10]  541 	lxi 	h,#0
   3F7E D1            [10]  542 	pop 	d
   3F7F CD 30 01      [18]  543 	call	ccpint
   3F82 D1            [10]  544 	pop 	d
   3F83 CD 30 01      [18]  545 	call	ccpint
                            546 ;                while (width-- && !isspace(ch = _getc(fd)) && ch != EOF) {
   3F86                     547 $32:
   3F86 21 0A 00      [10]  548 	lxi 	h,#10
   3F89 39            [10]  549 	dad 	sp
   3F8A E5            [12]  550 	push	h
   3F8B CD 28 01      [18]  551 	call	ccgint
   3F8E 2B            [ 6]  552 	dcx 	h
   3F8F D1            [10]  553 	pop 	d
   3F90 CD 30 01      [18]  554 	call	ccpint
   3F93 23            [ 6]  555 	inx 	h
   3F94 7C            [ 4]  556 	mov 	a,h
   3F95 B5            [ 4]  557 	ora 	l
   3F96 CA BA 3F      [10]  558 	jz  	$34
   3F99 21 08 00      [10]  559 	lxi 	h,#8
   3F9C 39            [10]  560 	dad 	sp
   3F9D E5            [12]  561 	push	h
   3F9E 21 1E 00      [10]  562 	lxi 	h,#30
   3FA1 39            [10]  563 	dad 	sp
   3FA2 CD 28 01      [18]  564 	call	ccgint
   3FA5 E5            [12]  565 	push	h
   3FA6 3E 01         [ 7]  566 	mvi 	a,#1
   3FA8 CD A4 3B      [18]  567 	call	_getc
   3FAB C1            [10]  568 	pop 	b
   3FAC D1            [10]  569 	pop 	d
   3FAD CD 30 01      [18]  570 	call	ccpint
   3FB0 E5            [12]  571 	push	h
   3FB1 3E 01         [ 7]  572 	mvi 	a,#1
   3FB3 CD 84 21      [18]  573 	call	isspace
   3FB6 C1            [10]  574 	pop 	b
   3FB7 CD DE 01      [18]  575 	call	cclneg
   3FBA                     576 $34:
   3FBA CD E9 01      [18]  577 	call	ccbool
   3FBD 7C            [ 4]  578 	mov 	a,h
   3FBE B5            [ 4]  579 	ora 	l
   3FBF CA D4 3F      [10]  580 	jz  	$35
   3FC2 21 08 00      [10]  581 	lxi 	h,#8
   3FC5 39            [10]  582 	dad 	sp
   3FC6 CD 28 01      [18]  583 	call	ccgint
   3FC9 E5            [12]  584 	push	h
   3FCA 21 01 00      [10]  585 	lxi 	h,#1
   3FCD CD D2 01      [18]  586 	call	ccneg
   3FD0 D1            [10]  587 	pop 	d
   3FD1 CD 51 01      [18]  588 	call	ccne
   3FD4                     589 $35:
   3FD4 CD E9 01      [18]  590 	call	ccbool
   3FD7 7C            [ 4]  591 	mov 	a,h
   3FD8 B5            [ 4]  592 	ora 	l
   3FD9 CA 0E 41      [10]  593 	jz  	$33
                            594 ;                    if (!sign)
   3FDC 21 00 00      [10]  595 	lxi 	h,#0
   3FDF 39            [10]  596 	dad 	sp
   3FE0 CD 28 01      [18]  597 	call	ccgint
   3FE3 CD DE 01      [18]  598 	call	cclneg
   3FE6 7C            [ 4]  599 	mov 	a,h
   3FE7 B5            [ 4]  600 	ora 	l
   3FE8 CA 20 40      [10]  601 	jz  	$36
                            602 ;                        if (ch == '-') {
   3FEB 21 08 00      [10]  603 	lxi 	h,#8
   3FEE 39            [10]  604 	dad 	sp
   3FEF CD 28 01      [18]  605 	call	ccgint
   3FF2 E5            [12]  606 	push	h
   3FF3 21 2D 00      [10]  607 	lxi 	h,#45
   3FF6 D1            [10]  608 	pop 	d
   3FF7 CD 4B 01      [18]  609 	call	cceq
   3FFA 7C            [ 4]  610 	mov 	a,h
   3FFB B5            [ 4]  611 	ora 	l
   3FFC CA 14 40      [10]  612 	jz  	$37
                            613 ;                            sign = -1;
   3FFF 21 00 00      [10]  614 	lxi 	h,#0
   4002 39            [10]  615 	dad 	sp
   4003 E5            [12]  616 	push	h
   4004 21 01 00      [10]  617 	lxi 	h,#1
   4007 CD D2 01      [18]  618 	call	ccneg
   400A D1            [10]  619 	pop 	d
   400B CD 30 01      [18]  620 	call	ccpint
                            621 ;                            continue;
   400E C3 86 3F      [10]  622 	jmp 	$32
                            623 ;                        } else sign = 1;
   4011 C3 20 40      [10]  624 	jmp 	$38
   4014                     625 $37:
   4014 21 00 00      [10]  626 	lxi 	h,#0
   4017 39            [10]  627 	dad 	sp
   4018 E5            [12]  628 	push	h
   4019 21 01 00      [10]  629 	lxi 	h,#1
   401C D1            [10]  630 	pop 	d
   401D CD 30 01      [18]  631 	call	ccpint
   4020                     632 $38:
                            633 ;                    if (ch < '0') return ac;
   4020                     634 $36:
   4020 21 08 00      [10]  635 	lxi 	h,#8
   4023 39            [10]  636 	dad 	sp
   4024 CD 28 01      [18]  637 	call	ccgint
   4027 E5            [12]  638 	push	h
   4028 21 30 00      [10]  639 	lxi 	h,#48
   402B D1            [10]  640 	pop 	d
   402C CD 6B 01      [18]  641 	call	cclt
   402F 7C            [ 4]  642 	mov 	a,h
   4030 B5            [ 4]  643 	ora 	l
   4031 CA 3E 40      [10]  644 	jz  	$39
   4034 21 0C 00      [10]  645 	lxi 	h,#12
   4037 39            [10]  646 	dad 	sp
   4038 CD 28 01      [18]  647 	call	ccgint
   403B C3 4A 41      [10]  648 	jmp 	$1
                            649 ;                    if (ch >= 'a') ch -= 87;
   403E                     650 $39:
   403E 21 08 00      [10]  651 	lxi 	h,#8
   4041 39            [10]  652 	dad 	sp
   4042 CD 28 01      [18]  653 	call	ccgint
   4045 E5            [12]  654 	push	h
   4046 21 61 00      [10]  655 	lxi 	h,#97
   4049 D1            [10]  656 	pop 	d
   404A CD 65 01      [18]  657 	call	ccge
   404D 7C            [ 4]  658 	mov 	a,h
   404E B5            [ 4]  659 	ora 	l
   404F CA 69 40      [10]  660 	jz  	$40
   4052 21 08 00      [10]  661 	lxi 	h,#8
   4055 39            [10]  662 	dad 	sp
   4056 E5            [12]  663 	push	h
   4057 CD 28 01      [18]  664 	call	ccgint
   405A E5            [12]  665 	push	h
   405B 21 57 00      [10]  666 	lxi 	h,#87
   405E D1            [10]  667 	pop 	d
   405F CD CB 01      [18]  668 	call	ccsub
   4062 D1            [10]  669 	pop 	d
   4063 CD 30 01      [18]  670 	call	ccpint
                            671 ;                    else if (ch >= 'A') ch -= 55;
   4066 C3 A8 40      [10]  672 	jmp 	$41
   4069                     673 $40:
   4069 21 08 00      [10]  674 	lxi 	h,#8
   406C 39            [10]  675 	dad 	sp
   406D CD 28 01      [18]  676 	call	ccgint
   4070 E5            [12]  677 	push	h
   4071 21 41 00      [10]  678 	lxi 	h,#65
   4074 D1            [10]  679 	pop 	d
   4075 CD 65 01      [18]  680 	call	ccge
   4078 7C            [ 4]  681 	mov 	a,h
   4079 B5            [ 4]  682 	ora 	l
   407A CA 94 40      [10]  683 	jz  	$42
   407D 21 08 00      [10]  684 	lxi 	h,#8
   4080 39            [10]  685 	dad 	sp
   4081 E5            [12]  686 	push	h
   4082 CD 28 01      [18]  687 	call	ccgint
   4085 E5            [12]  688 	push	h
   4086 21 37 00      [10]  689 	lxi 	h,#55
   4089 D1            [10]  690 	pop 	d
   408A CD CB 01      [18]  691 	call	ccsub
   408D D1            [10]  692 	pop 	d
   408E CD 30 01      [18]  693 	call	ccpint
                            694 ;                    else ch -= '0';
   4091 C3 A8 40      [10]  695 	jmp 	$43
   4094                     696 $42:
   4094 21 08 00      [10]  697 	lxi 	h,#8
   4097 39            [10]  698 	dad 	sp
   4098 E5            [12]  699 	push	h
   4099 CD 28 01      [18]  700 	call	ccgint
   409C E5            [12]  701 	push	h
   409D 21 30 00      [10]  702 	lxi 	h,#48
   40A0 D1            [10]  703 	pop 	d
   40A1 CD CB 01      [18]  704 	call	ccsub
   40A4 D1            [10]  705 	pop 	d
   40A5 CD 30 01      [18]  706 	call	ccpint
   40A8                     707 $43:
   40A8                     708 $41:
                            709 ;                    if (ch >= base || unsigned > ovfl) return ac;
   40A8 21 08 00      [10]  710 	lxi 	h,#8
   40AB 39            [10]  711 	dad 	sp
   40AC CD 28 01      [18]  712 	call	ccgint
   40AF E5            [12]  713 	push	h
   40B0 21 06 00      [10]  714 	lxi 	h,#6
   40B3 39            [10]  715 	dad 	sp
   40B4 CD 28 01      [18]  716 	call	ccgint
   40B7 D1            [10]  717 	pop 	d
   40B8 CD 65 01      [18]  718 	call	ccge
   40BB 7C            [ 4]  719 	mov 	a,h
   40BC B5            [ 4]  720 	ora 	l
   40BD C2 D3 40      [10]  721 	jnz 	$45
   40C0 21 12 00      [10]  722 	lxi 	h,#18
   40C3 39            [10]  723 	dad 	sp
   40C4 CD 28 01      [18]  724 	call	ccgint
   40C7 E5            [12]  725 	push	h
   40C8 21 04 00      [10]  726 	lxi 	h,#4
   40CB 39            [10]  727 	dad 	sp
   40CC CD 28 01      [18]  728 	call	ccgint
   40CF D1            [10]  729 	pop 	d
   40D0 CD 7D 01      [18]  730 	call	ccugt
   40D3                     731 $45:
   40D3 CD E9 01      [18]  732 	call	ccbool
   40D6 7C            [ 4]  733 	mov 	a,h
   40D7 B5            [ 4]  734 	ora 	l
   40D8 CA E5 40      [10]  735 	jz  	$44
   40DB 21 0C 00      [10]  736 	lxi 	h,#12
   40DE 39            [10]  737 	dad 	sp
   40DF CD 28 01      [18]  738 	call	ccgint
   40E2 C3 4A 41      [10]  739 	jmp 	$1
                            740 ;                    unsigned = unsigned * base + ch;
   40E5                     741 $44:
   40E5 21 12 00      [10]  742 	lxi 	h,#18
   40E8 39            [10]  743 	dad 	sp
   40E9 E5            [12]  744 	push	h
   40EA 21 14 00      [10]  745 	lxi 	h,#20
   40ED 39            [10]  746 	dad 	sp
   40EE CD 28 01      [18]  747 	call	ccgint
   40F1 E5            [12]  748 	push	h
   40F2 21 08 00      [10]  749 	lxi 	h,#8
   40F5 39            [10]  750 	dad 	sp
   40F6 CD 28 01      [18]  751 	call	ccgint
   40F9 D1            [10]  752 	pop 	d
   40FA CD EF 01      [18]  753 	call	ccmul
   40FD E5            [12]  754 	push	h
   40FE 21 0C 00      [10]  755 	lxi 	h,#12
   4101 39            [10]  756 	dad 	sp
   4102 CD 28 01      [18]  757 	call	ccgint
   4105 D1            [10]  758 	pop 	d
   4106 19            [10]  759 	dad 	d
   4107 D1            [10]  760 	pop 	d
   4108 CD 30 01      [18]  761 	call	ccpint
                            762 ;                }
   410B C3 86 3F      [10]  763 	jmp 	$32
   410E                     764 $33:
                            765 ;                *narg = sign * unsigned;
   410E 21 10 00      [10]  766 	lxi 	h,#16
   4111 39            [10]  767 	dad 	sp
   4112 CD 28 01      [18]  768 	call	ccgint
   4115 E5            [12]  769 	push	h
   4116 21 02 00      [10]  770 	lxi 	h,#2
   4119 39            [10]  771 	dad 	sp
   411A CD 28 01      [18]  772 	call	ccgint
   411D E5            [12]  773 	push	h
   411E 21 16 00      [10]  774 	lxi 	h,#22
   4121 39            [10]  775 	dad 	sp
   4122 CD 28 01      [18]  776 	call	ccgint
   4125 D1            [10]  777 	pop 	d
   4126 CD EF 01      [18]  778 	call	ccmul
   4129 D1            [10]  779 	pop 	d
   412A CD 30 01      [18]  780 	call	ccpint
                            781 ;        }
   412D C3 30 41      [10]  782 	jmp 	$16
                            783 		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
   5262                     784 $15:
   5262 63 00 0D 3E 73 00   785 	.dw	#99,$17,#115,$18
        29 3E
   526A B7 3E 00 00         786 	.dw	$24,0
                            787 		.area  SMALLC_GENERATED  (REL,CON,CSEG)
   4130                     788 $16:
                            789 ;        ++ac;
   4130 21 0C 00      [10]  790 	lxi 	h,#12
   4133 39            [10]  791 	dad 	sp
   4134 E5            [12]  792 	push	h
   4135 CD 28 01      [18]  793 	call	ccgint
   4138 23            [ 6]  794 	inx 	h
   4139 D1            [10]  795 	pop 	d
   413A CD 30 01      [18]  796 	call	ccpint
                            797 ;    }
   413D C3 7E 3C      [10]  798 	jmp 	$2
   4140                     799 $3:
                            800 ;    return ac;
   4140 21 0C 00      [10]  801 	lxi 	h,#12
   4143 39            [10]  802 	dad 	sp
   4144 CD 28 01      [18]  803 	call	ccgint
   4147 C3 4A 41      [10]  804 	jmp 	$1
                            805 ;}
   414A                     806 $1:
   414A EB            [ 4]  807 	xchg
   414B 21 18 00      [10]  808 	lxi 	h,#24
   414E 39            [10]  809 	dad 	sp
   414F F9            [ 6]  810 	sphl
   4150 EB            [ 4]  811 	xchg
   4151 C9            [10]  812 	ret
                            813 		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
                            814 	;extrn	_Oldch
                            815 	.globl	_scanf
                            816 	;extrn	isspace
                            817 	;extrn	utoi
                            818 	;extrn	_getc
                            819 	;extrn	_ungetc
                            820 
                            821 ;0 error(s) in compilation
                            822 ;	literal pool:0
                            823 ;	global pool:6
                            824 ;	Macro pool:112
                            825 	;	.end
