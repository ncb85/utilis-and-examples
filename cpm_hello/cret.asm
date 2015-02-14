;       Run time start off for Small C.
;        cseg
        .module CRET
        .area   CRET (REL,CON) ;program area CRTSO is RELOCATABLE
        .list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
        .nlist  (pag)
        .globl  crtsoend
        lxi     h,0
        dad     sp
        shld    stksav
        lhld    6       ; pick up core top
        lxi     d,-10   ; decrease by 10 for safety
        dad     d
        sphl            ; set stack pointer
        call    main    ; call main program
        lhld    stksav ; restore stack pointer
        sphl
        ret             ; go back to CCP
stksav: .ds      2
crtsoend:
       .end