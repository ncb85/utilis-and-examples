        ; C run-time start-off procedure, CRTSO for Small C.
        .module CRET
        .area   CRET (REL,CON) ;program area CRET is RELOCATABLE
        .list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
        .nlist  (pag)
        .globl  crtsoend

init:
        lhld    6               ; pick up core top
        lxi     d,-10           ; decrease by 10 for safety
        dad     d
        ;lxi     h,0x8000       ;for use with DDT
        sphl                    ; set stack pointer
        call    stdioinit       ; initialize stdio
        lxi     h,0x0080
        push    h
        call    Xarglist
        lhld    Xargc
        push    h
        lxi     h,Xargv
        push    h

        call    main            ; call main program
        jmp     0
crtsoend:
       .end
