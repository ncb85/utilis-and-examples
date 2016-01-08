;       Run time start off for Small C.
        .module CRET
        .area   CRET (REL,CON)
        .list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
        .nlist  (pag)
        .globl  crtsoend

        lhld    6               ; pick up core top
        lxi     d,-10           ; decrease by 10 for safety
        dad     d
        ;lxi     h,0x3000       ;for use with DDT
        sphl                    ; set stack pointer
        call    stdioinit       ; initialize stdio
        lxi     h,0x0080
        push    h
        call    Xarglist
        lhld    Xargc
        push    h
        lxi     h,Xargv
        push    h

        ;interrupt handler(s)
RST6_ROUTINE    .equ    0x0030   ; interrupt vector - 3 bytes (C3 XXXX)
        ;mvi     a,0xC3          ; JUMP instruction
        ;sta     RST6_ROUTINE    ; 
        ;lxi     h,interrupt_6   ; install handler
        ;shld    RST6_ROUTINE+1  ;

        call    main            ; call main program
        jmp     0
;stksav: .ds     2
crtsoend:
        .end
