;       Run time start off for Small C.
        .module CRET
        .area   CRET (REL,CON) ;program area CRTSO is RELOCATABLE
        .list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
        .nlist  (pag)
        .globl  crtsoend

        lxi     h,0
        dad     sp
        shld    stksav  ; save the stack pointer
        lhld    6       ; pick up core top
        lxi     d,-10   ; decrease by 10 for safety
        dad     d
        sphl            ; set stack pointer
        lxi     h,0x0080
        push    h       ; line buffer is at 0080H
        call    Xarglist
        lhld    Xargc
        push    h
        lxi     h,Xargv
        push    h
        call    main    ; call main program
        jmp     0       ; warm boot, reload CCP
stksav: .ds     2
crtsoend:
        .end
