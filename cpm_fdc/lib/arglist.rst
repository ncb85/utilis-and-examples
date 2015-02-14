                              1 ; Small C 8080
                              2 ;	Coder (2.4,84/11/27)
                              3 ;	Front End (2.7,84/11/28)
                              4 ;	Front End for ASXXXX (2.8,13/01/20)
                              5 		;program area SMALLC_GENERATED is RELOCATABLE
                              6 		.module SMALLC_GENERATED
                              7 		.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
                              8 		.nlist  (pag)
                              9 		.area  SMALLC_GENERATED  (REL,CON,CSEG)
                             10 ;/*      Interpret CPM argument list to produce C style
                             11 ;        argc/argv
                             12 ;        default dma buffer has it, form:
                             13 ;        ---------------------------------
                             14 ;        |count|characters  ...          |
                             15 ;        ---------------------------------
                             16 ; */
                             17 ;int Xargc;
                             18 ;int Xargv[30];
                             19 ;Xarglist(char *ap) {
   1E89                      20 Xarglist:
                             21 ;    char qc;
   1E89 3B            [ 6]   22 	dcx 	sp
                             23 ;    Xargc = 0;
   1E8A 21 00 00      [10]   24 	lxi 	h,#0
   1E8D 22 3D 49      [16]   25 	shld	Xargc
                             26 ;    ap[(*ap) + 1] = '\0';
   1E90 21 03 00      [10]   27 	lxi 	h,#3
   1E93 39            [10]   28 	dad 	sp
   1E94 CD 28 01      [18]   29 	call	ccgint
   1E97 E5            [12]   30 	push	h
   1E98 21 05 00      [10]   31 	lxi 	h,#5
   1E9B 39            [10]   32 	dad 	sp
   1E9C CD 28 01      [18]   33 	call	ccgint
   1E9F CD 22 01      [18]   34 	call	ccgchar
   1EA2 E5            [12]   35 	push	h
   1EA3 21 01 00      [10]   36 	lxi 	h,#1
   1EA6 D1            [10]   37 	pop 	d
   1EA7 19            [10]   38 	dad 	d
   1EA8 D1            [10]   39 	pop 	d
   1EA9 19            [10]   40 	dad 	d
   1EAA E5            [12]   41 	push	h
   1EAB 21 00 00      [10]   42 	lxi 	h,#0
   1EAE D1            [10]   43 	pop 	d
   1EAF 7D            [ 4]   44 	mov 	a,l
   1EB0 12            [ 7]   45 	stax	d
                             46 ;    ap++;
   1EB1 21 03 00      [10]   47 	lxi 	h,#3
   1EB4 39            [10]   48 	dad 	sp
   1EB5 E5            [12]   49 	push	h
   1EB6 CD 28 01      [18]   50 	call	ccgint
   1EB9 23            [ 6]   51 	inx 	h
   1EBA D1            [10]   52 	pop 	d
   1EBB CD 30 01      [18]   53 	call	ccpint
   1EBE 2B            [ 6]   54 	dcx 	h
                             55 ;    while (isspace(*ap)) ap++;
   1EBF                      56 $2:
   1EBF 21 03 00      [10]   57 	lxi 	h,#3
   1EC2 39            [10]   58 	dad 	sp
   1EC3 CD 28 01      [18]   59 	call	ccgint
   1EC6 CD 22 01      [18]   60 	call	ccgchar
   1EC9 E5            [12]   61 	push	h
   1ECA 3E 01         [ 7]   62 	mvi 	a,#1
   1ECC CD 84 21      [18]   63 	call	isspace
   1ECF C1            [10]   64 	pop 	b
   1ED0 7C            [ 4]   65 	mov 	a,h
   1ED1 B5            [ 4]   66 	ora 	l
   1ED2 CA E6 1E      [10]   67 	jz  	$3
   1ED5 21 03 00      [10]   68 	lxi 	h,#3
   1ED8 39            [10]   69 	dad 	sp
   1ED9 E5            [12]   70 	push	h
   1EDA CD 28 01      [18]   71 	call	ccgint
   1EDD 23            [ 6]   72 	inx 	h
   1EDE D1            [10]   73 	pop 	d
   1EDF CD 30 01      [18]   74 	call	ccpint
   1EE2 2B            [ 6]   75 	dcx 	h
   1EE3 C3 BF 1E      [10]   76 	jmp 	$2
   1EE6                      77 $3:
                             78 ;    Xargv[Xargc++] = "arg0";
   1EE6 21 3F 49      [10]   79 	lxi 	h,Xargv
   1EE9 E5            [12]   80 	push	h
   1EEA 2A 3D 49      [16]   81 	lhld	Xargc
   1EED 23            [ 6]   82 	inx 	h
   1EEE 22 3D 49      [16]   83 	shld	Xargc
   1EF1 2B            [ 6]   84 	dcx 	h
   1EF2 29            [10]   85 	dad 	h
   1EF3 D1            [10]   86 	pop 	d
   1EF4 19            [10]   87 	dad 	d
   1EF5 E5            [12]   88 	push	h
   1EF6 21 38 49      [10]   89 	lxi 	h,$0+#0
   1EF9 D1            [10]   90 	pop 	d
   1EFA CD 30 01      [18]   91 	call	ccpint
                             92 ;    if (*ap)
   1EFD 21 03 00      [10]   93 	lxi 	h,#3
   1F00 39            [10]   94 	dad 	sp
   1F01 CD 28 01      [18]   95 	call	ccgint
   1F04 CD 22 01      [18]   96 	call	ccgchar
   1F07 7C            [ 4]   97 	mov 	a,h
   1F08 B5            [ 4]   98 	ora 	l
   1F09 CA 68 20      [10]   99 	jz  	$4
                            100 ;        do {
   1F0C                     101 $5:
                            102 ;            if (*ap == '\'' || *ap == '\"') {
   1F0C 21 03 00      [10]  103 	lxi 	h,#3
   1F0F 39            [10]  104 	dad 	sp
   1F10 CD 28 01      [18]  105 	call	ccgint
   1F13 CD 22 01      [18]  106 	call	ccgchar
   1F16 E5            [12]  107 	push	h
   1F17 21 27 00      [10]  108 	lxi 	h,#39
   1F1A D1            [10]  109 	pop 	d
   1F1B CD 4B 01      [18]  110 	call	cceq
   1F1E 7C            [ 4]  111 	mov 	a,h
   1F1F B5            [ 4]  112 	ora 	l
   1F20 C2 35 1F      [10]  113 	jnz 	$9
   1F23 21 03 00      [10]  114 	lxi 	h,#3
   1F26 39            [10]  115 	dad 	sp
   1F27 CD 28 01      [18]  116 	call	ccgint
   1F2A CD 22 01      [18]  117 	call	ccgchar
   1F2D E5            [12]  118 	push	h
   1F2E 21 22 00      [10]  119 	lxi 	h,#34
   1F31 D1            [10]  120 	pop 	d
   1F32 CD 4B 01      [18]  121 	call	cceq
   1F35                     122 $9:
   1F35 CD E9 01      [18]  123 	call	ccbool
   1F38 7C            [ 4]  124 	mov 	a,h
   1F39 B5            [ 4]  125 	ora 	l
   1F3A CA B1 1F      [10]  126 	jz  	$8
                            127 ;                qc = *ap;
   1F3D 21 00 00      [10]  128 	lxi 	h,#0
   1F40 39            [10]  129 	dad 	sp
   1F41 E5            [12]  130 	push	h
   1F42 21 05 00      [10]  131 	lxi 	h,#5
   1F45 39            [10]  132 	dad 	sp
   1F46 CD 28 01      [18]  133 	call	ccgint
   1F49 CD 22 01      [18]  134 	call	ccgchar
   1F4C D1            [10]  135 	pop 	d
   1F4D 7D            [ 4]  136 	mov 	a,l
   1F4E 12            [ 7]  137 	stax	d
                            138 ;                Xargv[Xargc++] = ++ap;
   1F4F 21 3F 49      [10]  139 	lxi 	h,Xargv
   1F52 E5            [12]  140 	push	h
   1F53 2A 3D 49      [16]  141 	lhld	Xargc
   1F56 23            [ 6]  142 	inx 	h
   1F57 22 3D 49      [16]  143 	shld	Xargc
   1F5A 2B            [ 6]  144 	dcx 	h
   1F5B 29            [10]  145 	dad 	h
   1F5C D1            [10]  146 	pop 	d
   1F5D 19            [10]  147 	dad 	d
   1F5E E5            [12]  148 	push	h
   1F5F 21 05 00      [10]  149 	lxi 	h,#5
   1F62 39            [10]  150 	dad 	sp
   1F63 E5            [12]  151 	push	h
   1F64 CD 28 01      [18]  152 	call	ccgint
   1F67 23            [ 6]  153 	inx 	h
   1F68 D1            [10]  154 	pop 	d
   1F69 CD 30 01      [18]  155 	call	ccpint
   1F6C D1            [10]  156 	pop 	d
   1F6D CD 30 01      [18]  157 	call	ccpint
                            158 ;                while (*ap&&*ap != qc) ap++;
   1F70                     159 $10:
   1F70 21 03 00      [10]  160 	lxi 	h,#3
   1F73 39            [10]  161 	dad 	sp
   1F74 CD 28 01      [18]  162 	call	ccgint
   1F77 CD 22 01      [18]  163 	call	ccgchar
   1F7A 7C            [ 4]  164 	mov 	a,h
   1F7B B5            [ 4]  165 	ora 	l
   1F7C CA 95 1F      [10]  166 	jz  	$12
   1F7F 21 03 00      [10]  167 	lxi 	h,#3
   1F82 39            [10]  168 	dad 	sp
   1F83 CD 28 01      [18]  169 	call	ccgint
   1F86 CD 22 01      [18]  170 	call	ccgchar
   1F89 E5            [12]  171 	push	h
   1F8A 21 02 00      [10]  172 	lxi 	h,#2
   1F8D 39            [10]  173 	dad 	sp
   1F8E CD 22 01      [18]  174 	call	ccgchar
   1F91 D1            [10]  175 	pop 	d
   1F92 CD 51 01      [18]  176 	call	ccne
   1F95                     177 $12:
   1F95 CD E9 01      [18]  178 	call	ccbool
   1F98 7C            [ 4]  179 	mov 	a,h
   1F99 B5            [ 4]  180 	ora 	l
   1F9A CA AE 1F      [10]  181 	jz  	$11
   1F9D 21 03 00      [10]  182 	lxi 	h,#3
   1FA0 39            [10]  183 	dad 	sp
   1FA1 E5            [12]  184 	push	h
   1FA2 CD 28 01      [18]  185 	call	ccgint
   1FA5 23            [ 6]  186 	inx 	h
   1FA6 D1            [10]  187 	pop 	d
   1FA7 CD 30 01      [18]  188 	call	ccpint
   1FAA 2B            [ 6]  189 	dcx 	h
   1FAB C3 70 1F      [10]  190 	jmp 	$10
   1FAE                     191 $11:
                            192 ;            } else {
   1FAE C3 08 20      [10]  193 	jmp 	$13
   1FB1                     194 $8:
                            195 ;                Xargv[Xargc++] = ap;
   1FB1 21 3F 49      [10]  196 	lxi 	h,Xargv
   1FB4 E5            [12]  197 	push	h
   1FB5 2A 3D 49      [16]  198 	lhld	Xargc
   1FB8 23            [ 6]  199 	inx 	h
   1FB9 22 3D 49      [16]  200 	shld	Xargc
   1FBC 2B            [ 6]  201 	dcx 	h
   1FBD 29            [10]  202 	dad 	h
   1FBE D1            [10]  203 	pop 	d
   1FBF 19            [10]  204 	dad 	d
   1FC0 E5            [12]  205 	push	h
   1FC1 21 05 00      [10]  206 	lxi 	h,#5
   1FC4 39            [10]  207 	dad 	sp
   1FC5 CD 28 01      [18]  208 	call	ccgint
   1FC8 D1            [10]  209 	pop 	d
   1FC9 CD 30 01      [18]  210 	call	ccpint
                            211 ;                while (*ap&&!isspace(*ap)) ap++;
   1FCC                     212 $14:
   1FCC 21 03 00      [10]  213 	lxi 	h,#3
   1FCF 39            [10]  214 	dad 	sp
   1FD0 CD 28 01      [18]  215 	call	ccgint
   1FD3 CD 22 01      [18]  216 	call	ccgchar
   1FD6 7C            [ 4]  217 	mov 	a,h
   1FD7 B5            [ 4]  218 	ora 	l
   1FD8 CA EF 1F      [10]  219 	jz  	$16
   1FDB 21 03 00      [10]  220 	lxi 	h,#3
   1FDE 39            [10]  221 	dad 	sp
   1FDF CD 28 01      [18]  222 	call	ccgint
   1FE2 CD 22 01      [18]  223 	call	ccgchar
   1FE5 E5            [12]  224 	push	h
   1FE6 3E 01         [ 7]  225 	mvi 	a,#1
   1FE8 CD 84 21      [18]  226 	call	isspace
   1FEB C1            [10]  227 	pop 	b
   1FEC CD DE 01      [18]  228 	call	cclneg
   1FEF                     229 $16:
   1FEF CD E9 01      [18]  230 	call	ccbool
   1FF2 7C            [ 4]  231 	mov 	a,h
   1FF3 B5            [ 4]  232 	ora 	l
   1FF4 CA 08 20      [10]  233 	jz  	$15
   1FF7 21 03 00      [10]  234 	lxi 	h,#3
   1FFA 39            [10]  235 	dad 	sp
   1FFB E5            [12]  236 	push	h
   1FFC CD 28 01      [18]  237 	call	ccgint
   1FFF 23            [ 6]  238 	inx 	h
   2000 D1            [10]  239 	pop 	d
   2001 CD 30 01      [18]  240 	call	ccpint
   2004 2B            [ 6]  241 	dcx 	h
   2005 C3 CC 1F      [10]  242 	jmp 	$14
   2008                     243 $15:
                            244 ;            }
   2008                     245 $13:
                            246 ;            if (!*ap) break;
   2008 21 03 00      [10]  247 	lxi 	h,#3
   200B 39            [10]  248 	dad 	sp
   200C CD 28 01      [18]  249 	call	ccgint
   200F CD 22 01      [18]  250 	call	ccgchar
   2012 CD DE 01      [18]  251 	call	cclneg
   2015 7C            [ 4]  252 	mov 	a,h
   2016 B5            [ 4]  253 	ora 	l
   2017 CA 1D 20      [10]  254 	jz  	$17
   201A C3 68 20      [10]  255 	jmp 	$7
                            256 ;            *ap++ = '\0';
   201D                     257 $17:
   201D 21 03 00      [10]  258 	lxi 	h,#3
   2020 39            [10]  259 	dad 	sp
   2021 E5            [12]  260 	push	h
   2022 CD 28 01      [18]  261 	call	ccgint
   2025 23            [ 6]  262 	inx 	h
   2026 D1            [10]  263 	pop 	d
   2027 CD 30 01      [18]  264 	call	ccpint
   202A 2B            [ 6]  265 	dcx 	h
   202B E5            [12]  266 	push	h
   202C 21 00 00      [10]  267 	lxi 	h,#0
   202F D1            [10]  268 	pop 	d
   2030 7D            [ 4]  269 	mov 	a,l
   2031 12            [ 7]  270 	stax	d
                            271 ;            while (isspace(*ap)) ap++;
   2032                     272 $18:
   2032 21 03 00      [10]  273 	lxi 	h,#3
   2035 39            [10]  274 	dad 	sp
   2036 CD 28 01      [18]  275 	call	ccgint
   2039 CD 22 01      [18]  276 	call	ccgchar
   203C E5            [12]  277 	push	h
   203D 3E 01         [ 7]  278 	mvi 	a,#1
   203F CD 84 21      [18]  279 	call	isspace
   2042 C1            [10]  280 	pop 	b
   2043 7C            [ 4]  281 	mov 	a,h
   2044 B5            [ 4]  282 	ora 	l
   2045 CA 59 20      [10]  283 	jz  	$19
   2048 21 03 00      [10]  284 	lxi 	h,#3
   204B 39            [10]  285 	dad 	sp
   204C E5            [12]  286 	push	h
   204D CD 28 01      [18]  287 	call	ccgint
   2050 23            [ 6]  288 	inx 	h
   2051 D1            [10]  289 	pop 	d
   2052 CD 30 01      [18]  290 	call	ccpint
   2055 2B            [ 6]  291 	dcx 	h
   2056 C3 32 20      [10]  292 	jmp 	$18
   2059                     293 $19:
                            294 ;        } while (*ap);
   2059                     295 $6:
   2059 21 03 00      [10]  296 	lxi 	h,#3
   205C 39            [10]  297 	dad 	sp
   205D CD 28 01      [18]  298 	call	ccgint
   2060 CD 22 01      [18]  299 	call	ccgchar
   2063 7C            [ 4]  300 	mov 	a,h
   2064 B5            [ 4]  301 	ora 	l
   2065 C2 0C 1F      [10]  302 	jnz 	$5
   2068                     303 $7:
                            304 ;    Xargv[Xargc] = 0;
   2068                     305 $4:
   2068 21 3F 49      [10]  306 	lxi 	h,Xargv
   206B E5            [12]  307 	push	h
   206C 2A 3D 49      [16]  308 	lhld	Xargc
   206F 29            [10]  309 	dad 	h
   2070 D1            [10]  310 	pop 	d
   2071 19            [10]  311 	dad 	d
   2072 E5            [12]  312 	push	h
   2073 21 00 00      [10]  313 	lxi 	h,#0
   2076 D1            [10]  314 	pop 	d
   2077 CD 30 01      [18]  315 	call	ccpint
                            316 ;}
   207A                     317 $1:
   207A 33            [ 6]  318 	inx 	sp
   207B C9            [10]  319 	ret
                            320 		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
   4938 61 72 67 30 00      321 $0:	.db	#97,#114,#103,#48,#0
                            322 	.globl	Xargc
   493D                     323 Xargc:
   493D 00 00               324 	.dw	#0
                            325 	.globl	Xargv
   493F                     326 Xargv:
   493F 00 00 00 00 00 00   327 	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   4953 00 00 00 00 00 00   328 	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
   4967 00 00 00 00 00 00   329 	.dw	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
        00 00 00 00 00 00
        00 00 00 00 00 00
        00 00
                            330 	.globl	Xarglist
                            331 	;extrn	isspace
                            332 
                            333 ;0 error(s) in compilation
                            334 ;	literal pool:5
                            335 ;	global pool:4
                            336 ;	Macro pool:51
                            337 	;	.end
