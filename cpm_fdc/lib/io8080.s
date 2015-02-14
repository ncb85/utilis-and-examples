; Small C 8080
;	Coder (2.4,84/11/27)
;	Front End (2.7,84/11/28)
;	Front End for ASXXXX (2.8,13/01/20)
		;program area SMALLC_GENERATED is RELOCATABLE
		.module SMALLC_GENERATED
		.list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
		.nlist  (pag)
		.area  SMALLC_GENERATED  (REL,CON,CSEG)
;/*      Basic CP/M file I/O:
;fopen,fclose,fgetc,fputc,feof
;Original:       Paul Tarvydas
;Fixed by:       Chris Lewis
;*/
;#include <stdio.h>
;#define stdin 0
;#define stdout 1
;#define stderr 2
;#define NULL 0
;#define EOF (-1)
;#define FILE char
;#define EOL 10
;#define EOL2 13
;#define CPMEOF 26
;#define CPMERR 255
;#define UNIT_OFFSET 3
;#define CPMCIN 1
;#define CPMCOUT 2
;#define READ_EOF 3
;#define SETDMA 26
;#define DEFAULT_DMA 128
;#define CPMREAD 20
;#define CPMWR 21
;#define WRITE 2
;#define READ 1
;#define FREE 0
;#define NBUFFS 4
;#define BUFSIZ 512
;#define FCBSIZ 33
;#define ALLBUFFS 2048
;#define ALLFCBS 132
;#define CPMERA 19
;#define CPMCREAT 22
;#define CPMOPEN 15
;#define NBLOCKS 4
;#define BLKSIZ 128
;#define BKSP 8
;#define CTRLU 21
;#define FWSP ' '
;#define CPMCLOSE 16
;char    buffs[ALLBUFFS],        /* disk buffers */
;fcbs[ALLFCBS];          /* fcbs for buffers */
;int     bptr[NBUFFS];           /* ptrs into buffers */
;int     modes[NBUFFS];          /* mode for each open file */
;int     eptr[NBUFFS];           /* buffers' ends */
;char eofstdin;  /* flag end of file on stdin */
;fgetc(unit) int unit;
fgetc:
;{
;    int c;
	push	b
;    while ((c = Xfgetc(unit)) == EOL2);
$2:
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#6
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	Xfgetc
	pop 	b
	pop 	d
	call	ccpint
	push	h
	lxi 	h,#13
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$3
	jmp 	$2
$3:
;    return c;
	lxi 	h,#0
	dad 	sp
	call	ccgint
	jmp 	$1
;}
$1:
	pop 	b
	ret
;Xfgetc(unit) int unit;
Xfgetc:
;{
;    int i;
	push	b
;    int c;
	push	b
;    char *buff;
	push	b
;    char *fcba;
	push	b
;    if ((unit == stdin) & !eofstdin) {
	lxi 	h,#10
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#0
	pop 	d
	call	cceq
	push	h
	lda	eofstdin
	call	ccsxt
	call	cclneg
	pop 	d
	call	ccand
	mov 	a,h
	ora 	l
	jz  	$5
;        c = bdos1(CPMCIN, 0);
	lxi 	h,#4
	dad 	sp
	push	h
	lxi 	h,#1
	push	h
	lxi 	h,#0
	push	h
	mvi 	a,#2
	call	bdos1
	pop 	b
	pop 	b
	pop 	d
	call	ccpint
;        if (c == 4) {
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#4
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$6
;            eofstdin = 1;
	lxi 	h,#1
	mov 	a,l
	sta 	eofstdin
;            return (EOF);
	lxi 	h,#1
	call	ccneg
	jmp 	$4
;        }
;        else if (c == 3)
	jmp 	$7
$6:
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#3
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$8
;            exit (1);
	lxi 	h,#1
	push	h
	mvi 	a,#1
	call	exit
	pop 	b
;        else {
	jmp 	$9
$8:
;            if (c == EOL2) {
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#13
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$10
;                c = EOL;
	lxi 	h,#4
	dad 	sp
	push	h
	lxi 	h,#10
	pop 	d
	call	ccpint
;                bdos (CPMCOUT, EOL);
	lxi 	h,#2
	push	h
	lxi 	h,#10
	push	h
	mvi 	a,#2
	call	bdos
	pop 	b
	pop 	b
;            }
;            return (c);
$10:
	lxi 	h,#4
	dad 	sp
	call	ccgint
	jmp 	$4
;        }
$9:
$7:
;    }
;    if (modes[unit = unit - UNIT_OFFSET] == READ) {
$5:
	lxi 	h,modes
	push	h
	lxi 	h,#12
	dad 	sp
	push	h
	lxi 	h,#14
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#3
	pop 	d
	call	ccsub
	pop 	d
	call	ccpint
	dad 	h
	pop 	d
	dad 	d
	call	ccgint
	push	h
	lxi 	h,#1
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$11
;        if (bptr[unit] >= eptr[unit]) {
	lxi 	h,bptr
	push	h
	lxi 	h,#12
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	call	ccgint
	push	h
	lxi 	h,eptr
	push	h
	lxi 	h,#14
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	call	ccgint
	pop 	d
	call	ccge
	mov 	a,h
	ora 	l
	jz  	$12
;            fcba = fcbaddr(unit);
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#12
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	fcbaddr
	pop 	b
	pop 	d
	call	ccpint
;            /* fill da buffer again */
;            i = 0;  /* block counter */
	lxi 	h,#6
	dad 	sp
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
;            buff = buffaddr(unit); /* dma ptr */
	lxi 	h,#2
	dad 	sp
	push	h
	lxi 	h,#12
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	buffaddr
	pop 	b
	pop 	d
	call	ccpint
;            /* if buffer wasn't totally
;                    filled last time, we already
;                    eof */
;            if (eptr[unit] == buffaddr(unit + 1))
	lxi 	h,eptr
	push	h
	lxi 	h,#12
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	call	ccgint
	push	h
	lxi 	h,#12
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#1
	pop 	d
	dad 	d
	push	h
	mvi 	a,#1
	call	buffaddr
	pop 	b
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$13
;            do {
$14:
;                bdos(SETDMA, buff);
	lxi 	h,#26
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#2
	call	bdos
	pop 	b
	pop 	b
;                if (0!=bdos1(CPMREAD, fcba))
	lxi 	h,#0
	push	h
	lxi 	h,#20
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#2
	call	bdos1
	pop 	b
	pop 	b
	pop 	d
	call	ccne
	mov 	a,h
	ora 	l
	jz  	$17
;                    break;
	jmp 	$16
;                buff = buff + BLKSIZ;
$17:
	lxi 	h,#2
	dad 	sp
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#128
	pop 	d
	dad 	d
	pop 	d
	call	ccpint
;            }
;            while (++i<NBLOCKS);
$15:
	lxi 	h,#6
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	push	h
	lxi 	h,#4
	pop 	d
	call	cclt
	mov 	a,h
	ora 	l
	jnz 	$14
$16:
;            bdos(SETDMA, DEFAULT_DMA);
$13:
	lxi 	h,#26
	push	h
	lxi 	h,#128
	push	h
	mvi 	a,#2
	call	bdos
	pop 	b
	pop 	b
;            /* if i still 0, no blocks read =>eof*/
;            if (i==0) {
	lxi 	h,#6
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#0
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$18
;                modes[unit] = READ_EOF;
	lxi 	h,modes
	push	h
	lxi 	h,#12
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	push	h
	lxi 	h,#3
	pop 	d
	call	ccpint
;                return EOF;
	lxi 	h,#1
	call	ccneg
	jmp 	$4
;            }
;            /* o.k. set start & end ptrs */
;            eptr[unit] =
$18:
	lxi 	h,eptr
	push	h
	lxi 	h,#12
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	push	h
;                (bptr[unit]=buffaddr(unit))
	lxi 	h,bptr
	push	h
	lxi 	h,#14
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	push	h
	lxi 	h,#14
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	buffaddr
	pop 	b
	pop 	d
	call	ccpint
;                + (i * BLKSIZ);
	push	h
	lxi 	h,#10
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#128
	pop 	d
	call	ccmul
	pop 	d
	dad 	d
	pop 	d
	call	ccpint
;        }
;        c = (*(bptr[unit]++)) & 0xff;
$12:
	lxi 	h,#4
	dad 	sp
	push	h
	lxi 	h,bptr
	push	h
	lxi 	h,#14
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
	call	ccgint
	push	h
	lxi 	h,#255
	pop 	d
	call	ccand
	pop 	d
	call	ccpint
;        if (c == CPMEOF) {
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#26
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$19
;            c = EOF;
	lxi 	h,#4
	dad 	sp
	push	h
	lxi 	h,#1
	call	ccneg
	pop 	d
	call	ccpint
;            modes[unit] = READ_EOF;
	lxi 	h,modes
	push	h
	lxi 	h,#12
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	push	h
	lxi 	h,#3
	pop 	d
	call	ccpint
;        }
;        return c;
$19:
	lxi 	h,#4
	dad 	sp
	call	ccgint
	jmp 	$4
;    }
;    return EOF;
$11:
	lxi 	h,#1
	call	ccneg
	jmp 	$4
;}
$4:
	xchg
	lxi 	h,#8
	dad 	sp
	sphl
	xchg
	ret
;fclose(unit) int unit;
fclose:
;{
;    int i;
	push	b
;    if ((unit==stdin)|(unit==stdout)|(unit==stderr))
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#0
	pop 	d
	call	cceq
	push	h
	lxi 	h,#6
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#1
	pop 	d
	call	cceq
	pop 	d
	call	ccor
	push	h
	lxi 	h,#6
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#2
	pop 	d
	call	cceq
	pop 	d
	call	ccor
	mov 	a,h
	ora 	l
	jz  	$21
;        return NULL;
	lxi 	h,#0
	jmp 	$20
;    if (modes[unit = unit - UNIT_OFFSET] != FREE) {
$21:
	lxi 	h,modes
	push	h
	lxi 	h,#6
	dad 	sp
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#3
	pop 	d
	call	ccsub
	pop 	d
	call	ccpint
	dad 	h
	pop 	d
	dad 	d
	call	ccgint
	push	h
	lxi 	h,#0
	pop 	d
	call	ccne
	mov 	a,h
	ora 	l
	jz  	$22
;        if (modes[unit] == WRITE)
	lxi 	h,modes
	push	h
	lxi 	h,#6
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	call	ccgint
	push	h
	lxi 	h,#2
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$23
;            fflush(unit + UNIT_OFFSET);
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#3
	pop 	d
	dad 	d
	push	h
	mvi 	a,#1
	call	fflush
	pop 	b
;        modes[unit] = FREE;
$23:
	lxi 	h,modes
	push	h
	lxi 	h,#6
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
;        return bdos1(CPMCLOSE, fcbaddr(unit));
	lxi 	h,#16
	push	h
	lxi 	h,#6
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	fcbaddr
	pop 	b
	push	h
	mvi 	a,#2
	call	bdos1
	pop 	b
	pop 	b
	jmp 	$20
;    }
;    return EOF;
$22:
	lxi 	h,#1
	call	ccneg
	jmp 	$20
;}
$20:
	pop 	b
	ret
;fflush(unit) int unit;
fflush:
;{
;    char *buffa;
	push	b
;    char *fcba;
	push	b
;    if ((unit!=stdin)|(unit!=stdout)|(unit!=stderr)) {
	lxi 	h,#6
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#0
	pop 	d
	call	ccne
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#1
	pop 	d
	call	ccne
	pop 	d
	call	ccor
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#2
	pop 	d
	call	ccne
	pop 	d
	call	ccor
	mov 	a,h
	ora 	l
	jz  	$25
;        /* put an eof at end of file */
;        fputc(CPMEOF, unit);
	lxi 	h,#26
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#2
	call	fputc
	pop 	b
	pop 	b
;        if (bptr[unit = unit - UNIT_OFFSET] !=
	lxi 	h,bptr
	push	h
	lxi 	h,#8
	dad 	sp
	push	h
	lxi 	h,#10
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#3
	pop 	d
	call	ccsub
	pop 	d
	call	ccpint
	dad 	h
	pop 	d
	dad 	d
	call	ccgint
	push	h
;            (buffa = buffaddr(unit))) {
	lxi 	h,#4
	dad 	sp
	push	h
	lxi 	h,#10
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	buffaddr
	pop 	b
	pop 	d
	call	ccpint
	pop 	d
	call	ccne
	mov 	a,h
	ora 	l
	jz  	$26
;            /* some chars in buffer - flush them */
;            fcba = fcbaddr(unit);
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	fcbaddr
	pop 	b
	pop 	d
	call	ccpint
;            do {
$27:
;                bdos(SETDMA, buffa);
	lxi 	h,#26
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#2
	call	bdos
	pop 	b
	pop 	b
;                if (0 != bdos1(CPMWR, fcba))
	lxi 	h,#0
	push	h
	lxi 	h,#21
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#2
	call	bdos1
	pop 	b
	pop 	b
	pop 	d
	call	ccne
	mov 	a,h
	ora 	l
	jz  	$30
;                    return (EOF);
	lxi 	h,#1
	call	ccneg
	jmp 	$24
;            }
$30:
;            while (bptr[unit] >
$28:
	lxi 	h,bptr
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	call	ccgint
	push	h
;                (buffa=buffa+BLKSIZ));
	lxi 	h,#4
	dad 	sp
	push	h
	lxi 	h,#6
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#128
	pop 	d
	dad 	d
	pop 	d
	call	ccpint
	pop 	d
	call	ccugt
	mov 	a,h
	ora 	l
	jnz 	$27
$29:
;            bdos(SETDMA, DEFAULT_DMA);
	lxi 	h,#26
	push	h
	lxi 	h,#128
	push	h
	mvi 	a,#2
	call	bdos
	pop 	b
	pop 	b
;        }
;    }
$26:
;    return NULL;
$25:
	lxi 	h,#0
	jmp 	$24
;}
$24:
	pop 	b
	pop 	b
	ret
;fputc(c, unit) char c;
fputc:
;int unit;
;{
;    char *buffa;
	push	b
;    char *fcba;
	push	b
;    if (c == EOL) fputc(EOL2, unit);
	lxi 	h,#8
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#10
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$32
	lxi 	h,#13
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#2
	call	fputc
	pop 	b
	pop 	b
;    if ((unit == stdout) | (unit == stderr)) {
$32:
	lxi 	h,#6
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#1
	pop 	d
	call	cceq
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#2
	pop 	d
	call	cceq
	pop 	d
	call	ccor
	mov 	a,h
	ora 	l
	jz  	$33
;        bdos(CPMCOUT, c);
	lxi 	h,#2
	push	h
	lxi 	h,#10
	dad 	sp
	call	ccgchar
	push	h
	mvi 	a,#2
	call	bdos
	pop 	b
	pop 	b
;        return c;
	lxi 	h,#8
	dad 	sp
	call	ccgchar
	jmp 	$31
;    }
;    if (WRITE == modes[unit = unit - UNIT_OFFSET]) {
$33:
	lxi 	h,#2
	push	h
	lxi 	h,modes
	push	h
	lxi 	h,#10
	dad 	sp
	push	h
	lxi 	h,#12
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#3
	pop 	d
	call	ccsub
	pop 	d
	call	ccpint
	dad 	h
	pop 	d
	dad 	d
	call	ccgint
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$34
;        if (bptr[unit] >= eptr[unit]) {
	lxi 	h,bptr
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	call	ccgint
	push	h
	lxi 	h,eptr
	push	h
	lxi 	h,#10
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	call	ccgint
	pop 	d
	call	ccge
	mov 	a,h
	ora 	l
	jz  	$35
;            /* no room - dump buffer */
;            fcba = fcbaddr(unit);
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	fcbaddr
	pop 	b
	pop 	d
	call	ccpint
;            buffa=buffaddr(unit);
	lxi 	h,#2
	dad 	sp
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	buffaddr
	pop 	b
	pop 	d
	call	ccpint
;            while (buffa < eptr[unit]) {
$36:
	lxi 	h,#2
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,eptr
	push	h
	lxi 	h,#10
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	call	ccgint
	pop 	d
	call	ccult
	mov 	a,h
	ora 	l
	jz  	$37
;                bdos(SETDMA, buffa);
	lxi 	h,#26
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#2
	call	bdos
	pop 	b
	pop 	b
;                if (0 != bdos1(CPMWR, fcba)) break;
	lxi 	h,#0
	push	h
	lxi 	h,#21
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#2
	call	bdos1
	pop 	b
	pop 	b
	pop 	d
	call	ccne
	mov 	a,h
	ora 	l
	jz  	$38
	jmp 	$37
;                buffa = buffa + BLKSIZ;
$38:
	lxi 	h,#2
	dad 	sp
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#128
	pop 	d
	dad 	d
	pop 	d
	call	ccpint
;            }
	jmp 	$36
$37:
;            bdos(SETDMA, DEFAULT_DMA);
	lxi 	h,#26
	push	h
	lxi 	h,#128
	push	h
	mvi 	a,#2
	call	bdos
	pop 	b
	pop 	b
;            bptr[unit] = buffaddr(unit);
	lxi 	h,bptr
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	buffaddr
	pop 	b
	pop 	d
	call	ccpint
;            if (buffa < eptr[unit]) return EOF;
	lxi 	h,#2
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,eptr
	push	h
	lxi 	h,#10
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	call	ccgint
	pop 	d
	call	ccult
	mov 	a,h
	ora 	l
	jz  	$39
	lxi 	h,#1
	call	ccneg
	jmp 	$31
;        }
$39:
;        *(bptr[unit]++) = c;
$35:
	lxi 	h,bptr
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
	push	h
	lxi 	h,#10
	dad 	sp
	call	ccgchar
	pop 	d
	call	ccpint
;        return c;
	lxi 	h,#8
	dad 	sp
	call	ccgchar
	jmp 	$31
;    }
;    return EOF;
$34:
	lxi 	h,#1
	call	ccneg
	jmp 	$31
;}
$31:
	pop 	b
	pop 	b
	ret
;allocunitno() {
allocunitno:
;    int i;
	push	b
;    /* returns # of first free buffer, EOF if none */
;    /* buffer is not reserved (ie. mode remains FREE) */
;    for (i = 0; i < NBUFFS; ++i)
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
$41:
	lxi 	h,#0
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#4
	pop 	d
	call	cclt
	mov 	a,h
	ora 	l
	jnz 	$43
	jmp 	$44
$42:
	lxi 	h,#0
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	jmp 	$41
$43:
;        if (modes[i] == FREE) break;
	lxi 	h,modes
	push	h
	lxi 	h,#2
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	call	ccgint
	push	h
	lxi 	h,#0
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$45
	jmp 	$44
;    if (i >= NBUFFS) return EOF;
$45:
	jmp 	$42
$44:
	lxi 	h,#0
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#4
	pop 	d
	call	ccge
	mov 	a,h
	ora 	l
	jz  	$46
	lxi 	h,#1
	call	ccneg
	jmp 	$40
;    else return (i + UNIT_OFFSET);
	jmp 	$47
$46:
	lxi 	h,#0
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#3
	pop 	d
	dad 	d
	jmp 	$40
$47:
;}
$40:
	pop 	b
	ret
;fopen(name, mode) char *name, *mode;
fopen:
;{
;    int fileno, fno2;
	push	b
	push	b
;    if (EOF != (fileno = allocunitno())) {
	lxi 	h,#1
	call	ccneg
	push	h
	lxi 	h,#4
	dad 	sp
	push	h
	mvi 	a,#0
	call	allocunitno
	pop 	d
	call	ccpint
	pop 	d
	call	ccne
	mov 	a,h
	ora 	l
	jz  	$49
;        /* internal file # excludes units 0,1 & 2
;                since there's no buffers associated with
;                these units */
;        movname(clearfcb(fcbaddr(fno2 = fileno
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#4
	dad 	sp
;            - UNIT_OFFSET)), name);
	call	ccgint
	push	h
	lxi 	h,#3
	pop 	d
	call	ccsub
	pop 	d
	call	ccpint
	push	h
	mvi 	a,#1
	call	fcbaddr
	pop 	b
	push	h
	mvi 	a,#1
	call	clearfcb
	pop 	b
	push	h
	lxi 	h,#10
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#2
	call	movname
	pop 	b
	pop 	b
;        if ('r' == *mode) {
	lxi 	h,#114
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	call	ccgchar
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$50
;            if (bdos1(CPMOPEN, fcbaddr(fno2)) != CPMERR)
	lxi 	h,#15
	push	h
	lxi 	h,#2
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	fcbaddr
	pop 	b
	push	h
	mvi 	a,#2
	call	bdos1
	pop 	b
	pop 	b
	push	h
	lxi 	h,#255
	pop 	d
	call	ccne
	mov 	a,h
	ora 	l
	jz  	$51
;            {
;                modes[fno2] = READ;
	lxi 	h,modes
	push	h
	lxi 	h,#2
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	push	h
	lxi 	h,#1
	pop 	d
	call	ccpint
;                /* ptr>bufsiz => buffer empty*/
;                eptr[fno2] =
	lxi 	h,eptr
	push	h
	lxi 	h,#2
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	push	h
;                    bptr[fno2] = buffaddr(fno2+1); // <tel:+1>);
	lxi 	h,bptr
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#1
	pop 	d
	dad 	d
	push	h
	mvi 	a,#1
	call	buffaddr
	pop 	b
	pop 	d
	call	ccpint
	pop 	d
	call	ccpint
;                return fileno;
	lxi 	h,#2
	dad 	sp
	call	ccgint
	jmp 	$48
;            }
;        }
$51:
;        else if ('w' == *mode) {
	jmp 	$52
$50:
	lxi 	h,#119
	push	h
	lxi 	h,#8
	dad 	sp
	call	ccgint
	call	ccgchar
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$53
;            bdos(CPMERA, fcbaddr(fno2));
	lxi 	h,#19
	push	h
	lxi 	h,#2
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	fcbaddr
	pop 	b
	push	h
	mvi 	a,#2
	call	bdos
	pop 	b
	pop 	b
;            if (bdos1(CPMCREAT, fcbaddr(fno2)) != CPMERR){
	lxi 	h,#22
	push	h
	lxi 	h,#2
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	fcbaddr
	pop 	b
	push	h
	mvi 	a,#2
	call	bdos1
	pop 	b
	pop 	b
	push	h
	lxi 	h,#255
	pop 	d
	call	ccne
	mov 	a,h
	ora 	l
	jz  	$54
;                modes[fno2] = WRITE;
	lxi 	h,modes
	push	h
	lxi 	h,#2
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	push	h
	lxi 	h,#2
	pop 	d
	call	ccpint
;                bptr[fno2] = buffaddr(fno2);
	lxi 	h,bptr
	push	h
	lxi 	h,#2
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	push	h
	lxi 	h,#2
	dad 	sp
	call	ccgint
	push	h
	mvi 	a,#1
	call	buffaddr
	pop 	b
	pop 	d
	call	ccpint
;                eptr[fno2] = buffaddr(fno2+1); // <tel:+1>);
	lxi 	h,eptr
	push	h
	lxi 	h,#2
	dad 	sp
	call	ccgint
	dad 	h
	pop 	d
	dad 	d
	push	h
	lxi 	h,#2
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#1
	pop 	d
	dad 	d
	push	h
	mvi 	a,#1
	call	buffaddr
	pop 	b
	pop 	d
	call	ccpint
;                return fileno;
	lxi 	h,#2
	dad 	sp
	call	ccgint
	jmp 	$48
;            }
;        }
$54:
;    }
$53:
$52:
;    return NULL;
$49:
	lxi 	h,#0
	jmp 	$48
;}
$48:
	pop 	b
	pop 	b
	ret
;clearfcb(fcb) char fcb[];
clearfcb:
;{
;    int i;
	push	b
;    for (i=0; i<FCBSIZ; fcb[i++] = 0);
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
$56:
	lxi 	h,#0
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#33
	pop 	d
	call	cclt
	mov 	a,h
	ora 	l
	jnz 	$58
	jmp 	$59
$57:
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#2
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
	pop 	d
	dad 	d
	push	h
	lxi 	h,#0
	pop 	d
	mov 	a,l
	stax	d
	jmp 	$56
$58:
	jmp 	$57
$59:
;    /* blank out name field */
;    for (i=1; i<12; fcb[i++] = ' ');
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#1
	pop 	d
	call	ccpint
$60:
	lxi 	h,#0
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#12
	pop 	d
	call	cclt
	mov 	a,h
	ora 	l
	jnz 	$62
	jmp 	$63
$61:
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#2
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
	pop 	d
	dad 	d
	push	h
	lxi 	h,#32
	pop 	d
	mov 	a,l
	stax	d
	jmp 	$60
$62:
	jmp 	$61
$63:
;    return fcb;
	lxi 	h,#4
	dad 	sp
	call	ccgint
	jmp 	$55
;}
$55:
	pop 	b
	ret
;movname(fcb, str) char fcb[], *str;
movname:
;{
;    int i;
	push	b
;    char c;
	dcx 	sp
;    i = 1; /* first char of name @ pos 1 */
	lxi 	h,#1
	dad 	sp
	push	h
	lxi 	h,#1
	pop 	d
	call	ccpint
;    *fcb = 0;
	lxi 	h,#7
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#0
	pop 	d
	mov 	a,l
	stax	d
;    if (':' == str[1]) {
	lxi 	h,#58
	push	h
	lxi 	h,#7
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#1
	pop 	d
	dad 	d
	call	ccgchar
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$65
;        c = toupper(str[0]);
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#7
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#0
	pop 	d
	dad 	d
	call	ccgchar
	push	h
	mvi 	a,#1
	call	toupper
	pop 	b
	pop 	d
	mov 	a,l
	stax	d
;        if (('A' <= c) & ('B' >= c)) {
	lxi 	h,#65
	push	h
	lxi 	h,#2
	dad 	sp
	call	ccgchar
	pop 	d
	call	ccle
	push	h
	lxi 	h,#66
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgchar
	pop 	d
	call	ccge
	pop 	d
	call	ccand
	mov 	a,h
	ora 	l
	jz  	$66
;            *fcb = (c - 'A' + 1);
	lxi 	h,#7
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#2
	dad 	sp
	call	ccgchar
	push	h
	lxi 	h,#65
	pop 	d
	call	ccsub
	push	h
	lxi 	h,#1
	pop 	d
	dad 	d
	pop 	d
	mov 	a,l
	stax	d
;            str++;
	lxi 	h,#5
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
;            str++;
	lxi 	h,#5
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
;        }
;    }
$66:
;    while ((NULL != *str) & (i<9)) {
$65:
$67:
	lxi 	h,#0
	push	h
	lxi 	h,#7
	dad 	sp
	call	ccgint
	call	ccgchar
	pop 	d
	call	ccne
	push	h
	lxi 	h,#3
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#9
	pop 	d
	call	cclt
	pop 	d
	call	ccand
	mov 	a,h
	ora 	l
	jz  	$68
;        /* up to 8 chars into file name field */
;        if ('.' == *str) break;
	lxi 	h,#46
	push	h
	lxi 	h,#7
	dad 	sp
	call	ccgint
	call	ccgchar
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$69
	jmp 	$68
;        fcb[i++] = toupper(*str++);
$69:
	lxi 	h,#7
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#3
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
	pop 	d
	dad 	d
	push	h
	lxi 	h,#7
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
	call	ccgchar
	push	h
	mvi 	a,#1
	call	toupper
	pop 	b
	pop 	d
	mov 	a,l
	stax	d
;    }
	jmp 	$67
$68:
;    /* strip off excess chars - up to '.' (beginning of
;        extension name ) */
;    while ((NULL != *str) & ((*str) != '.')) ++str;
$70:
	lxi 	h,#0
	push	h
	lxi 	h,#7
	dad 	sp
	call	ccgint
	call	ccgchar
	pop 	d
	call	ccne
	push	h
	lxi 	h,#7
	dad 	sp
	call	ccgint
	call	ccgchar
	push	h
	lxi 	h,#46
	pop 	d
	call	ccne
	pop 	d
	call	ccand
	mov 	a,h
	ora 	l
	jz  	$71
	lxi 	h,#5
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	jmp 	$70
$71:
;    if (*str)
	lxi 	h,#5
	dad 	sp
	call	ccgint
	call	ccgchar
	mov 	a,h
	ora 	l
	jz  	$72
;        /* '.' is first char of *str now */
;        /* copy 3 chars of ext. if there */
;        for (   /* first char of ext @ pos 9 (8+1 <tel:+1>)*/
;            i = 8;
	lxi 	h,#1
	dad 	sp
	push	h
	lxi 	h,#8
	pop 	d
	call	ccpint
$73:
;            /* '.' is stripped by ++ 1st time */
;            /* around */
;            (NULL != *++str) & (12 > ++i);
	lxi 	h,#0
	push	h
	lxi 	h,#7
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	call	ccgchar
	pop 	d
	call	ccne
	push	h
	lxi 	h,#12
	push	h
	lxi 	h,#5
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	pop 	d
	call	ccgt
	pop 	d
	call	ccand
	mov 	a,h
	ora 	l
	jnz 	$75
	jmp 	$76
$74:
;            fcb[i] = toupper(*str)
	lxi 	h,#7
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#3
	dad 	sp
	call	ccgint
	pop 	d
	dad 	d
	push	h
	lxi 	h,#7
	dad 	sp
	call	ccgint
	call	ccgchar
	push	h
	mvi 	a,#1
	call	toupper
	pop 	b
;        );
	pop 	d
	mov 	a,l
	stax	d
	jmp 	$73
$75:
	jmp 	$74
$76:
;        return fcb;
$72:
	lxi 	h,#7
	dad 	sp
	call	ccgint
	jmp 	$64
;}
$64:
	inx 	sp
	pop 	b
	ret
;stdioinit() {
stdioinit:
;    int i;
	push	b
;    eofstdin = 0;
	lxi 	h,#0
	mov 	a,l
	sta 	eofstdin
;    for (i=0; i<NBUFFS; modes[i++] = FREE);
	lxi 	h,#0
	dad 	sp
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
$78:
	lxi 	h,#0
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#4
	pop 	d
	call	cclt
	mov 	a,h
	ora 	l
	jnz 	$80
	jmp 	$81
$79:
	lxi 	h,modes
	push	h
	lxi 	h,#2
	dad 	sp
	push	h
	call	ccgint
	inx 	h
	pop 	d
	call	ccpint
	dcx 	h
	dad 	h
	pop 	d
	dad 	d
	push	h
	lxi 	h,#0
	pop 	d
	call	ccpint
	jmp 	$78
$80:
	jmp 	$79
$81:
;}
$77:
	pop 	b
	ret
;fcbaddr(unit) int unit;
fcbaddr:
;{
;    /* returns address of fcb associated with given unit -
;        unit taken with origin 0 (ie. std's not included) */
;    return &fcbs[unit * FCBSIZ];
	lxi 	h,fcbs
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#33
	pop 	d
	call	ccmul
	pop 	d
	dad 	d
	jmp 	$82
;}
$82:
	ret
;buffaddr(unit) int unit;
buffaddr:
;{
;    return &buffs[unit * BUFSIZ];
	lxi 	h,buffs
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#512
	pop 	d
	call	ccmul
	pop 	d
	dad 	d
	jmp 	$83
;}
$83:
	ret
;feof (unit) FILE *unit;
feof:
;{
;    if ((unit == stdin) & eofstdin)
	lxi 	h,#2
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#0
	pop 	d
	call	cceq
	push	h
	lda	eofstdin
	call	ccsxt
	pop 	d
	call	ccand
	mov 	a,h
	ora 	l
	jz  	$85
;        return 1;
	lxi 	h,#1
	jmp 	$84
;    if (modes[unit - UNIT_OFFSET] == READ_EOF)
$85:
	lxi 	h,modes
	push	h
	lxi 	h,#4
	dad 	sp
	call	ccgint
	push	h
	lxi 	h,#3
	pop 	d
	call	ccsub
	dad 	h
	pop 	d
	dad 	d
	call	ccgint
	push	h
	lxi 	h,#3
	pop 	d
	call	cceq
	mov 	a,h
	ora 	l
	jz  	$86
;        return 1;
	lxi 	h,#1
	jmp 	$84
;    return 0;
$86:
	lxi 	h,#0
	jmp 	$84
;}
$84:
	ret
		.area  SMALLC_GENERATED_DATA  (REL,CON,DSEG)
	.globl	buffs
buffs:
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0
	.globl	fcbs
fcbs:
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0,#0,#0,#0,#0,#0,#0,#0,#0
	.db	#0,#0
	.globl	bptr
bptr:
	.dw	#0,#0,#0,#0
	.globl	modes
modes:
	.dw	#0,#0,#0,#0
	.globl	eptr
eptr:
	.dw	#0,#0,#0,#0
	.globl	eofstdin
eofstdin:
	.db	#0
	.globl	fgetc
	.globl	Xfgetc
	;extrn	bdos1
	;extrn	exit
	;extrn	bdos
	.globl	fcbaddr
	.globl	buffaddr
	.globl	fclose
	.globl	fflush
	.globl	fputc
	.globl	allocunitno
	.globl	fopen
	.globl	movname
	.globl	clearfcb
	;extrn	toupper
	.globl	stdioinit
	.globl	feof

;0 error(s) in compilation
;	literal pool:0
;	global pool:23
;	Macro pool:398
	;	.end
