                              1 ; Small C 8080
                              2 ;	Coder (2.4,84/11/27)
                              3 ;	Front End (2.7,84/11/28)
                              4 ;	Front End for ASXXXX (2.8,13/01/20)
                              5 		;program area SMALLC_GENERATED is RELOCATABLE
                              6 		.module SMALLC_GENERATED
                              7 		.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
                              8 		.nlist  (pag)
                              9 		.area  SMALLC_GENERATED  (REL,CON,CSEG)
                             10 ;isalpha(c) char c;{
   207C                      11 isalpha:
                             12 ;        if ((c >= 'a' & c <= 'z') |
   207C 21 02 00      [10]   13 	lxi 	h,#2
   207F 39            [10]   14 	dad 	sp
   2080 CD 22 01      [18]   15 	call	ccgchar
   2083 E5            [12]   16 	push	h
   2084 21 61 00      [10]   17 	lxi 	h,#97
   2087 D1            [10]   18 	pop 	d
   2088 CD 65 01      [18]   19 	call	ccge
   208B E5            [12]   20 	push	h
   208C 21 04 00      [10]   21 	lxi 	h,#4
   208F 39            [10]   22 	dad 	sp
   2090 CD 22 01      [18]   23 	call	ccgchar
   2093 E5            [12]   24 	push	h
   2094 21 7A 00      [10]   25 	lxi 	h,#122
   2097 D1            [10]   26 	pop 	d
   2098 CD 5E 01      [18]   27 	call	ccle
   209B D1            [10]   28 	pop 	d
   209C CD 44 01      [18]   29 	call	ccand
   209F E5            [12]   30 	push	h
                             31 ;            (c >= 'A' & c <= 'Z'))    return(1);
   20A0 21 04 00      [10]   32 	lxi 	h,#4
   20A3 39            [10]   33 	dad 	sp
   20A4 CD 22 01      [18]   34 	call	ccgchar
   20A7 E5            [12]   35 	push	h
   20A8 21 41 00      [10]   36 	lxi 	h,#65
   20AB D1            [10]   37 	pop 	d
   20AC CD 65 01      [18]   38 	call	ccge
   20AF E5            [12]   39 	push	h
   20B0 21 06 00      [10]   40 	lxi 	h,#6
   20B3 39            [10]   41 	dad 	sp
   20B4 CD 22 01      [18]   42 	call	ccgchar
   20B7 E5            [12]   43 	push	h
   20B8 21 5A 00      [10]   44 	lxi 	h,#90
   20BB D1            [10]   45 	pop 	d
   20BC CD 5E 01      [18]   46 	call	ccle
   20BF D1            [10]   47 	pop 	d
   20C0 CD 44 01      [18]   48 	call	ccand
   20C3 D1            [10]   49 	pop 	d
   20C4 CD 36 01      [18]   50 	call	ccor
   20C7 7C            [ 4]   51 	mov 	a,h
   20C8 B5            [ 4]   52 	ora 	l
   20C9 CA D5 20      [10]   53 	jz  	$2
   20CC 21 01 00      [10]   54 	lxi 	h,#1
   20CF C3 DB 20      [10]   55 	jmp 	$1
                             56 ;        else                            return(0);
   20D2 C3 DB 20      [10]   57 	jmp 	$3
   20D5                      58 $2:
   20D5 21 00 00      [10]   59 	lxi 	h,#0
   20D8 C3 DB 20      [10]   60 	jmp 	$1
   20DB                      61 $3:
                             62 ;        }
   20DB                      63 $1:
   20DB C9            [10]   64 	ret
                             65 ;isupper(c) char c;{
   20DC                      66 isupper:
                             67 ;        if (c >= 'A' & c <= 'Z')      return(1);
   20DC 21 02 00      [10]   68 	lxi 	h,#2
   20DF 39            [10]   69 	dad 	sp
   20E0 CD 22 01      [18]   70 	call	ccgchar
   20E3 E5            [12]   71 	push	h
   20E4 21 41 00      [10]   72 	lxi 	h,#65
   20E7 D1            [10]   73 	pop 	d
   20E8 CD 65 01      [18]   74 	call	ccge
   20EB E5            [12]   75 	push	h
   20EC 21 04 00      [10]   76 	lxi 	h,#4
   20EF 39            [10]   77 	dad 	sp
   20F0 CD 22 01      [18]   78 	call	ccgchar
   20F3 E5            [12]   79 	push	h
   20F4 21 5A 00      [10]   80 	lxi 	h,#90
   20F7 D1            [10]   81 	pop 	d
   20F8 CD 5E 01      [18]   82 	call	ccle
   20FB D1            [10]   83 	pop 	d
   20FC CD 44 01      [18]   84 	call	ccand
   20FF 7C            [ 4]   85 	mov 	a,h
   2100 B5            [ 4]   86 	ora 	l
   2101 CA 0D 21      [10]   87 	jz  	$5
   2104 21 01 00      [10]   88 	lxi 	h,#1
   2107 C3 13 21      [10]   89 	jmp 	$4
                             90 ;        else                            return(0);
   210A C3 13 21      [10]   91 	jmp 	$6
   210D                      92 $5:
   210D 21 00 00      [10]   93 	lxi 	h,#0
   2110 C3 13 21      [10]   94 	jmp 	$4
   2113                      95 $6:
                             96 ;        }
   2113                      97 $4:
   2113 C9            [10]   98 	ret
                             99 ;islower(c) char c;{
   2114                     100 islower:
                            101 ;        if (c >= 'a' & c <= 'z')      return(1);
   2114 21 02 00      [10]  102 	lxi 	h,#2
   2117 39            [10]  103 	dad 	sp
   2118 CD 22 01      [18]  104 	call	ccgchar
   211B E5            [12]  105 	push	h
   211C 21 61 00      [10]  106 	lxi 	h,#97
   211F D1            [10]  107 	pop 	d
   2120 CD 65 01      [18]  108 	call	ccge
   2123 E5            [12]  109 	push	h
   2124 21 04 00      [10]  110 	lxi 	h,#4
   2127 39            [10]  111 	dad 	sp
   2128 CD 22 01      [18]  112 	call	ccgchar
   212B E5            [12]  113 	push	h
   212C 21 7A 00      [10]  114 	lxi 	h,#122
   212F D1            [10]  115 	pop 	d
   2130 CD 5E 01      [18]  116 	call	ccle
   2133 D1            [10]  117 	pop 	d
   2134 CD 44 01      [18]  118 	call	ccand
   2137 7C            [ 4]  119 	mov 	a,h
   2138 B5            [ 4]  120 	ora 	l
   2139 CA 45 21      [10]  121 	jz  	$8
   213C 21 01 00      [10]  122 	lxi 	h,#1
   213F C3 4B 21      [10]  123 	jmp 	$7
                            124 ;        else                            return(0);
   2142 C3 4B 21      [10]  125 	jmp 	$9
   2145                     126 $8:
   2145 21 00 00      [10]  127 	lxi 	h,#0
   2148 C3 4B 21      [10]  128 	jmp 	$7
   214B                     129 $9:
                            130 ;        }
   214B                     131 $7:
   214B C9            [10]  132 	ret
                            133 ;isdigit(c) char c;{
   214C                     134 isdigit:
                            135 ;        if (c >= '0' & c <= '9')      return(1);
   214C 21 02 00      [10]  136 	lxi 	h,#2
   214F 39            [10]  137 	dad 	sp
   2150 CD 22 01      [18]  138 	call	ccgchar
   2153 E5            [12]  139 	push	h
   2154 21 30 00      [10]  140 	lxi 	h,#48
   2157 D1            [10]  141 	pop 	d
   2158 CD 65 01      [18]  142 	call	ccge
   215B E5            [12]  143 	push	h
   215C 21 04 00      [10]  144 	lxi 	h,#4
   215F 39            [10]  145 	dad 	sp
   2160 CD 22 01      [18]  146 	call	ccgchar
   2163 E5            [12]  147 	push	h
   2164 21 39 00      [10]  148 	lxi 	h,#57
   2167 D1            [10]  149 	pop 	d
   2168 CD 5E 01      [18]  150 	call	ccle
   216B D1            [10]  151 	pop 	d
   216C CD 44 01      [18]  152 	call	ccand
   216F 7C            [ 4]  153 	mov 	a,h
   2170 B5            [ 4]  154 	ora 	l
   2171 CA 7D 21      [10]  155 	jz  	$11
   2174 21 01 00      [10]  156 	lxi 	h,#1
   2177 C3 83 21      [10]  157 	jmp 	$10
                            158 ;        else                            return(0);
   217A C3 83 21      [10]  159 	jmp 	$12
   217D                     160 $11:
   217D 21 00 00      [10]  161 	lxi 	h,#0
   2180 C3 83 21      [10]  162 	jmp 	$10
   2183                     163 $12:
                            164 ;        }
   2183                     165 $10:
   2183 C9            [10]  166 	ret
                            167 ;isspace(c) char c;{
   2184                     168 isspace:
                            169 ;        if (c == ' ' | c == '\t' | c == '\n')   return(1);
   2184 21 02 00      [10]  170 	lxi 	h,#2
   2187 39            [10]  171 	dad 	sp
   2188 CD 22 01      [18]  172 	call	ccgchar
   218B E5            [12]  173 	push	h
   218C 21 20 00      [10]  174 	lxi 	h,#32
   218F D1            [10]  175 	pop 	d
   2190 CD 4B 01      [18]  176 	call	cceq
   2193 E5            [12]  177 	push	h
   2194 21 04 00      [10]  178 	lxi 	h,#4
   2197 39            [10]  179 	dad 	sp
   2198 CD 22 01      [18]  180 	call	ccgchar
   219B E5            [12]  181 	push	h
   219C 21 09 00      [10]  182 	lxi 	h,#9
   219F D1            [10]  183 	pop 	d
   21A0 CD 4B 01      [18]  184 	call	cceq
   21A3 D1            [10]  185 	pop 	d
   21A4 CD 36 01      [18]  186 	call	ccor
   21A7 E5            [12]  187 	push	h
   21A8 21 04 00      [10]  188 	lxi 	h,#4
   21AB 39            [10]  189 	dad 	sp
   21AC CD 22 01      [18]  190 	call	ccgchar
   21AF E5            [12]  191 	push	h
   21B0 21 0A 00      [10]  192 	lxi 	h,#10
   21B3 D1            [10]  193 	pop 	d
   21B4 CD 4B 01      [18]  194 	call	cceq
   21B7 D1            [10]  195 	pop 	d
   21B8 CD 36 01      [18]  196 	call	ccor
   21BB 7C            [ 4]  197 	mov 	a,h
   21BC B5            [ 4]  198 	ora 	l
   21BD CA C9 21      [10]  199 	jz  	$14
   21C0 21 01 00      [10]  200 	lxi 	h,#1
   21C3 C3 CF 21      [10]  201 	jmp 	$13
                            202 ;        else                                    return(0);
   21C6 C3 CF 21      [10]  203 	jmp 	$15
   21C9                     204 $14:
   21C9 21 00 00      [10]  205 	lxi 	h,#0
   21CC C3 CF 21      [10]  206 	jmp 	$13
   21CF                     207 $15:
                            208 ;        }
   21CF                     209 $13:
   21CF C9            [10]  210 	ret
                            211 ;toupper(c) char c;{
   21D0                     212 toupper:
                            213 ;        return ((c >= 'a' && c <= 'z') ? c - 32: c);
   21D0 21 02 00      [10]  214 	lxi 	h,#2
   21D3 39            [10]  215 	dad 	sp
   21D4 CD 22 01      [18]  216 	call	ccgchar
   21D7 E5            [12]  217 	push	h
   21D8 21 61 00      [10]  218 	lxi 	h,#97
   21DB D1            [10]  219 	pop 	d
   21DC CD 65 01      [18]  220 	call	ccge
   21DF 7C            [ 4]  221 	mov 	a,h
   21E0 B5            [ 4]  222 	ora 	l
   21E1 CA F3 21      [10]  223 	jz  	$17
   21E4 21 02 00      [10]  224 	lxi 	h,#2
   21E7 39            [10]  225 	dad 	sp
   21E8 CD 22 01      [18]  226 	call	ccgchar
   21EB E5            [12]  227 	push	h
   21EC 21 7A 00      [10]  228 	lxi 	h,#122
   21EF D1            [10]  229 	pop 	d
   21F0 CD 5E 01      [18]  230 	call	ccle
   21F3                     231 $17:
   21F3 CD E9 01      [18]  232 	call	ccbool
   21F6 7C            [ 4]  233 	mov 	a,h
   21F7 B5            [ 4]  234 	ora 	l
   21F8 CA 0D 22      [10]  235 	jz  	$18
   21FB 21 02 00      [10]  236 	lxi 	h,#2
   21FE 39            [10]  237 	dad 	sp
   21FF CD 22 01      [18]  238 	call	ccgchar
   2202 E5            [12]  239 	push	h
   2203 21 20 00      [10]  240 	lxi 	h,#32
   2206 D1            [10]  241 	pop 	d
   2207 CD CB 01      [18]  242 	call	ccsub
   220A C3 14 22      [10]  243 	jmp 	$19
   220D                     244 $18:
   220D 21 02 00      [10]  245 	lxi 	h,#2
   2210 39            [10]  246 	dad 	sp
   2211 CD 22 01      [18]  247 	call	ccgchar
   2214                     248 $19:
   2214 C3 17 22      [10]  249 	jmp 	$16
                            250 ;        }
   2217                     251 $16:
   2217 C9            [10]  252 	ret
                            253 ;tolower(c) char c;{
   2218                     254 tolower:
                            255 ;        return((c >= 'A' && c <= 'Z') ? c + 32: c);
   2218 21 02 00      [10]  256 	lxi 	h,#2
   221B 39            [10]  257 	dad 	sp
   221C CD 22 01      [18]  258 	call	ccgchar
   221F E5            [12]  259 	push	h
   2220 21 41 00      [10]  260 	lxi 	h,#65
   2223 D1            [10]  261 	pop 	d
   2224 CD 65 01      [18]  262 	call	ccge
   2227 7C            [ 4]  263 	mov 	a,h
   2228 B5            [ 4]  264 	ora 	l
   2229 CA 3B 22      [10]  265 	jz  	$21
   222C 21 02 00      [10]  266 	lxi 	h,#2
   222F 39            [10]  267 	dad 	sp
   2230 CD 22 01      [18]  268 	call	ccgchar
   2233 E5            [12]  269 	push	h
   2234 21 5A 00      [10]  270 	lxi 	h,#90
   2237 D1            [10]  271 	pop 	d
   2238 CD 5E 01      [18]  272 	call	ccle
   223B                     273 $21:
   223B CD E9 01      [18]  274 	call	ccbool
   223E 7C            [ 4]  275 	mov 	a,h
   223F B5            [ 4]  276 	ora 	l
   2240 CA 53 22      [10]  277 	jz  	$22
   2243 21 02 00      [10]  278 	lxi 	h,#2
   2246 39            [10]  279 	dad 	sp
   2247 CD 22 01      [18]  280 	call	ccgchar
   224A E5            [12]  281 	push	h
   224B 21 20 00      [10]  282 	lxi 	h,#32
   224E D1            [10]  283 	pop 	d
   224F 19            [10]  284 	dad 	d
   2250 C3 5A 22      [10]  285 	jmp 	$23
   2253                     286 $22:
   2253 21 02 00      [10]  287 	lxi 	h,#2
   2256 39            [10]  288 	dad 	sp
   2257 CD 22 01      [18]  289 	call	ccgchar
   225A                     290 $23:
   225A C3 5D 22      [10]  291 	jmp 	$20
                            292 ;        }
   225D                     293 $20:
   225D C9            [10]  294 	ret
                            295 		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
                            296 	.globl	isalpha
                            297 	.globl	isupper
                            298 	.globl	islower
                            299 	.globl	isdigit
                            300 	.globl	isspace
                            301 	.globl	toupper
                            302 	.globl	tolower
                            303 
                            304 ;0 error(s) in compilation
                            305 ;	literal pool:0
                            306 ;	global pool:7
                            307 ;	Macro pool:51
                            308 	;	.end
