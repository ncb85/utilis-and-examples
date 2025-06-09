        ; C run-time start-off procedure, CRTSO for Small C.
        .module CRTSO
        .area   CRTSO   (REL,CON,CSEG)   ;program area CRTSO is ABSOLUTE at 0x0100
        .list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
        .nlist  (pag)

        .globl  main

init:
        di                      ; disable all interrupts
        lxi     sp,0xFFE0       ; set stack pointer

        jmp     main            ; call main program
crtsoend::
       .end
