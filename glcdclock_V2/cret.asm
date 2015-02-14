        ; C run-time start-off procedure, CRTSO for Small C.
        .module CRET
        .area   CRET (REL,CON) ;program area CRET is RELOCATABLE
        .list   (err, loc, bin, eqt, cyc, lin, src, lst, md)
        .nlist  (pag)
        .globl  crtsoend

; NCB85 firmware dependend addresses
TRAP_ROUTINE   .equ    0x0024   ; interrupt vector - 3 bytes (C3 XXXX)
RST55_ROUTINE  .equ    0x002C   ; interrupt vector - 3 bytes (C3 XXXX)
RST65_ROUTINE  .equ    0x0034   ; interrupt vector - 3 bytes (C3 XXXX)
RST75_ROUTINE  .equ    0x003C   ; interrupt vector - 3 bytes (C3 XXXX)
STATUS_CMD_REG_8155 .equ 0x00   ; I/O address of 8155

init:
        ;di                      ; disable all interrupts
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

        ;mvi     a,0x4C          ; stop timer in 8155
        ;out     STATUS_CMD_REG_8155 ; 8155 command register
                                ; hook up the RST6.5 interrupt routine
        ;mvi     a,0xC3          ; JUMP instruction
        ;sta     RST65_ROUTINE   ; NCB85 firmware dependend address, timer
        ;sta     RST55_ROUTINE   ; serial
        ;lxi     h,interrupt_65
        ;shld    RST65_ROUTINE+1 ;
        ;lxi     h,interrupt_55
        ;shld    RST55_ROUTINE+1 ;
        ;mvi     a,0b00011100    ; set interrupt mask, enable 6.5, 5.5
        ;mvi     a,0b00011101    ; set interrupt mask, enable 6.5
        ;sim
        ;ei

        call    main            ; call main program
        ;mvi     a,0b00011101    ; set interrupt mask, enable 6.5 timer
        ;sim
        jmp     0
crtsoend:
       .end
